-- Scoped compatibility bridge for the native Gen3 font cache, not game data.
return function(mod, shared)
  local Cache=require('src.import.CacheFs')
  local Runtime=require('src.mods.Runtime')
  local Font=require('src.ui.game3.frlg_font')
  local GV=require('src.core.GameVersion')
  if Cache._hoennPtbrFonts then Cache._hoennPtbrFonts() end
  local assets={}
  for _,name in ipairs({'latin_normal_fg','latin_normal_shadow','latin_small_fg','latin_small_shadow'}) do
    assets['data/generated/gba/chrome/fonts/'..name..'.rgba']={path='assets/gen3-export/chrome/fonts/'..name..'.png',raw=true}
  end
  for _,name in ipairs({'latin_widths','latin_small_widths'}) do
    assets['data/generated/gba/chrome/fonts/'..name..'.lua']={path='fonts/'..name..'.lua'}
  end
  -- Decode all resources before changing native functions: a failure is atomic.
  local memo={}
  for key,asset in pairs(assets) do
    local bytes=shared.read(asset.path)
    if asset.raw then
      assert(love and love.image and shared.fs.newFileData, 'Decodificação de fontes indisponível')
      local fd=shared.fs.newFileData(bytes,'font.png')
      local image=love.image.newImageData(fd)
      bytes=image:getString()
      if image.release then image:release() end
      if fd.release then fd:release() end
    end
    memo[key]=bytes
  end
  local function invalidate()
    Font.invalidate()
    local ok,chrome=pcall(require,'src.ui.game3.chrome')
    if ok and chrome.invalidate then chrome.invalidate() end
  end
  local previousGlyphs={}
  for code,glyph in pairs({[0x30]='Ã',[0x31]='Õ',[0x32]='ã',[0x33]='õ'}) do
    previousGlyphs[code]=Font.LATIN_GLYPHS[code];Font.LATIN_GLYPHS[code]=glyph
  end
  local method=type(Cache.readAt)=='function' and 'readAt' or 'read'
  local original=Cache[method]
  local wrapped=function(path,...)
    if GV.get()=='emerald' or GV.get()=='ruby' or GV.get()=='sapphire' then
      local key=path
      local prefix=GV.cachePrefix()
      if prefix~='' and key:sub(1,#prefix)==prefix then key=key:sub(#prefix+1) end
      key=key:gsub('^/','')
      if not key:match('^data/generated/gba/') then key='data/generated/gba/'..key end
      if memo[key] then return memo[key] end
    end
    return original(path,...)
  end
  Cache[method]=wrapped
  local previousInstall,previousReset=Runtime.install,Runtime.reset
  local install,reset,stopped
  local function stop()
    if stopped then return end;stopped=true
    if Cache[method]==wrapped then Cache[method]=original end
    if Runtime.install==install then Runtime.install=previousInstall end
    if Runtime.reset==reset then Runtime.reset=previousReset end
    for code in pairs({[0x30]=true,[0x31]=true,[0x32]=true,[0x33]=true}) do Font.LATIN_GLYPHS[code]=previousGlyphs[code] end
    if Cache._hoennPtbrFonts==stop then Cache._hoennPtbrFonts=nil end
    memo={};invalidate()
  end
  install=function(...) stop();return previousInstall(...) end
  reset=function(...) stop();return previousReset(...) end
  Runtime.install,Runtime.reset=install,reset
  Cache._hoennPtbrFonts=stop
  mod.events:on('game.ready',invalidate)
  mod.hooks:wrap('core.quit_to_launcher',function(nextFn,...) stop();return nextFn(...) end)
  invalidate()
  return stop
end
