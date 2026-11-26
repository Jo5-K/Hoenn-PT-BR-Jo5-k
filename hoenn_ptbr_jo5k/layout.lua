-- Pixel-based text layout owned by this mod. No engine patches or private APIs.
return function(mod)
  local compile = loadstring or load
  local function read(path)
    local chunk, err = compile(assert(mod:read(path), 'Missing ' .. path), '@' .. path)
    assert(chunk, err)
    return chunk()
  end
  local metrics, data = read('fonts/metrics.lua'), read('lang/layout.lua')
  local L = { data = data, metrics = metrics, stats = { reflowed = 0, repaired_case = 0 } }
  if mod.content.font and mod.assets and mod.assets.path
      and not (mod.content.font.get and mod.content.font:get('ttf')) then
    -- The API's tiles list keeps these characters on the active native font.
    -- Exclude its entire eligible range except the four missing tilde letters.
    local tiles = {}
    for cp = 0x20, 0x24F do
      if cp <= 0x7E or cp >= 0xC0 then
        if cp ~= 0xC3 and cp ~= 0xD5 and cp ~= 0xE3 and cp ~= 0xF5 then
          if cp < 128 then tiles[#tiles + 1] = string.char(cp)
          elseif cp < 2048 then tiles[#tiles + 1] = string.char(192 + math.floor(cp / 64), 128 + cp % 64) end
        end
      end
    end
    mod.content.font:register('ttf', {
      file = mod.assets:path('fonts/HoennAccents.ttf'), size = 16, tiles = tiles,
    })
  end
  local char = '[%z\1-\127\194-\244][\128-\191]*'
  local lower = { ['Ã']='ã', ['Õ']='õ', ['Í']='í', ['Á']='á', ['É']='é', ['Ó']='ó', ['Ú']='ú', ['Â']='â', ['Ê']='ê', ['Ô']='ô' }
  local cleaned = {}
  function L.clean(text)
    if cleaned[text] then return cleaned[text] end
    local original = text
    text = text:gsub('\\\\n', '\n'):gsub('\\n', '\n')
    -- Repair mixed-case accent corruption inside words, not MÃE/POKéMON
    -- or an accented capital at the beginning of a name.
    local result = (text:gsub('[A-Za-z\128-\255]+', function(word)
      if not word:find('[a-z]') then return word end
      local out, index = {}, 0
      for ch in word:gmatch(char) do
        index = index + 1
        local value = ch
        if index > 1 and lower[ch] then value = lower[ch]; L.stats.repaired_case = L.stats.repaired_case + 1 end
        out[#out + 1] = value
      end
      return table.concat(out)
    end))
    cleaned[original] = result
    cleaned[result] = result
    return result
  end
  local ascii = {}
  for ch, advance in pairs(metrics) do if #ch == 1 then ascii[ch:byte()] = advance end end
  function L.width(text)
    local result, i = 0, 1
    while i <= #text do
      local byte = text:byte(i)
      if byte == 37 then
        local printf = text:sub(i):match('^%%[%d%.$%+%- #]*[cdeEfgGiouXxqs]')
        if printf then result, i = result + (printf:sub(-1) == 's' and 100 or 20), i + #printf
        else result, i = result + (ascii[byte] or 4), i + 1 end
      elseif byte == 123 then
        local token = text:sub(i):match('^%b{}')
        if token then
          local add = token:match('^{%d%d}$') and 96 or token:match('^%{DYNAMIC_') and 96 or 8
          if token:match('^%{COLOR') or token:match('^%{PAUSE') then add = 0 end
          result, i = result + add, i + #token
        else result, i = result + (ascii[byte] or 4), i + 1 end
      elseif byte < 128 then result, i = result + (ascii[byte] or 4), i + 1
      else
        local count = byte >= 240 and 4 or byte >= 224 and 3 or byte >= 192 and 2 or 1
        local ch = text:sub(i, i + count - 1)
        result, i = result + (metrics[ch] or 4), i + count
      end
    end
    return result
  end
  function L.wrap(text, limit)
    text = L.clean(text)
    local lines, line = {}, ''
    for word in text:gmatch('%S+') do
      local candidate = line == '' and word or line .. ' ' .. word
      if line ~= '' and L.width(candidate) > limit then lines[#lines + 1] = line; line = word
      else line = candidate end
    end
    lines[#lines + 1] = line
    return table.concat(lines, '\n')
  end
  function L.plain(source, target)
    if data.strings[source] then return data.strings[source] end
    target = L.clean(target)
    -- Printer control bytes and context/printf tokens must not be rewritten
    -- as glyphs. Dedicated templates handle the memo's dynamic values.
    if target:find(string.char(0xFC), 1, true) or target:find('{DYNAMIC_', 1, true) then return target end
    local out = {}
    for line in (target .. '\n'):gmatch('(.-)\n') do
      out[#out + 1] = L.width(line) > 208 and L.wrap(line, 208) or line
    end
    return table.concat(out, '\n')
  end
  function L.item(id, text)
    return data.items[id] or L.wrap(text, 109)
  end
  function L.dialogue(ir)
    local out, col, row = {}, 0, 1
    local function append(node)
      if node.t == 'text' and out[#out] and out[#out].t == 'text' then out[#out].s = out[#out].s .. node.s
      else out[#out + 1] = node end
    end
    local function newline()
      append({ t = row < 2 and 'nl' or 'scroll' }); col = 0; row = math.min(2, row + 1)
    end
    for _, node in ipairs(ir) do
      if node.t == 'text' then
        for spaces, word in L.clean(node.s):gmatch('(%s*)(%S+)') do
          local gap = spaces ~= '' and col > 0 and ' ' or ''
          local w = L.width(word)
          if col > 0 and col + L.width(gap) + w > 208 then newline(); gap = '' end
          -- Keep each word intact. The next native line/page handles wrapping;
          -- never split a UTF-8 word into individual letters.
          append({t='text',s=gap .. word}); col=col+L.width(gap)+w
        end
        if node.s:match('%s$') and col>0 then append({t='text',s=' '});col=col+(metrics[' '] or 4) end
      elseif node.t=='nl' or node.t=='scroll' then newline()
      elseif node.t=='para' then append(node);col,row=0,1
      elseif node.t=='player' or node.t=='rival' or node.t=='strvar' or node.t=='ph' or node.t=='dynamic' then
        local reserve=node.t=='player' and 42 or node.t=='rival' and 42 or 96
        if col>0 and col+reserve>208 then newline() end
        append(node);col=col+reserve
      else append(node) end
    end
    L.stats.reflowed = L.stats.reflowed + 1
    return out
  end
  local function dynamic(n) return {t='dynamic',n=n} end
  local function text(s) return {t='text',s=s} end
  local function nature()
    return {dynamic(0),text('Nat. '),dynamic(2),dynamic(1),dynamic(5)}
  end
  local function append(a,b) for _,v in ipairs(b) do a[#a+1]=v end end
  function L.memo(key, source)
    if type(source)~='table' then return nil end
    local ids={};for _,n in ipairs(source) do if n.t=='dynamic' then ids[n.n]=true end end
    if not (ids[0] and ids[1] and ids[2] and ids[5]) then return nil end
    local rules={
      gText_XNature={kind='nature'},
      gText_XNatureMetAtYZ={level='Obtido no Nv. ',place=true},
      gText_XNatureMetSomewhereAt={level='Obtido no Nv. ',unknown=true},
      gText_XNatureHatchedAtYZ={level='Chocou no Nv. ',place=true},
      gText_XNatureHatchedSomewhereAt={level='Chocou no Nv. ',unknown=true},
      gText_XNatureProbablyMetAt={level='Prov. no Nv. ',place=true},
      gText_XNatureObtainedInTrade={kind='trade'},
      gText_XNatureFatefulEncounter={level='Encontro especial',special=true},
    }
    local rule=rules[key];if not rule then return nil end
    if rule.level and not ids[3] then return nil end
    if rule.place and not ids[4] then return nil end
    local out=nature();out[#out+1]=text('.')
    if rule.kind=='trade' then append(out,{{t='nl'},text('Obtido em uma troca.')})
    elseif rule.level then
      out[#out+1]={t='nl'}
      if rule.special then append(out,{text(rule.level),{t='nl'},text('no Nv. '),dynamic(0),dynamic(3),dynamic(1),text('.')})
      else
        append(out,{text(rule.level),dynamic(0),dynamic(3),dynamic(1),text('.')})
        if rule.place then append(out,{{t='nl'},dynamic(0),dynamic(4),dynamic(1)}) end
        if rule.unknown then append(out,{{t='nl'},text('Local desconhecido.')}) end
      end
    end
    out[#out+1]={t='eos'}
    return out
  end
  return L
end
