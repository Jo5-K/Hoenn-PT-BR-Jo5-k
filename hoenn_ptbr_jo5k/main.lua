return function(mod)
  local game=require('src.core.GameVersion').get()
  if game~='emerald' and game~='ruby' and game~='sapphire' then return end
  local function module(name)
    return assert(loadstring(assert(mod:read(name..'.lua')), '@hoenn_ptbr_jo5k/'..name..'.lua'))()
  end
  local shared=module('shared')(mod) -- Fail visibly before applying any translation.
  -- API3's source-string text facade rejects printer controls. Keep the
  -- owner's native IR accessors for text only, preserving pause/placeholder
  -- objects instead of serializing or stripping them. Writes remain tracked
  -- by the loader and disappear on unload, as in the previous translation.
  local loader=mod.game.mods
  local own=assert(loader.mods.hoenn_ptbr_jo5k)
  local content=setmetatable({
    text=loader:_contentApi(own,loader.content.text),
    rom_text=loader:_contentApi(own,loader.content.rom_text),
  },{__index=mod.content})
  local translation=setmetatable({content=content},{__index=mod})
  local stats=module('hoenn')(translation,game,shared)
  local labels=shared.catalog('start_menu')
  mod.hooks:wrap('ui.start_menu.items',function(nextFn,owner,items)
    local rows=nextFn(owner,items)
    for _,item in ipairs(rows or {}) do
      if labels[item.id] then item.label=labels[item.id] end
    end
    return rows
  end)
  local ok,shutdown=pcall(module('fonts'),mod,shared)
  if not ok then mod.log:info('Hoenn PT-BR: fontes nativas preservadas (%s)',tostring(shutdown)) end
  mod.exports.sharedVersion=shared.version
  mod.exports.fontsActive=ok
  mod.exports.shutdown=ok and shutdown or function() end
  return stats
end
