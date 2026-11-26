-- Independent API 2 content mod: the manifest gates Ruby/Sapphire/Emerald.
-- No mod.game, loader internals, external resource provider or engine require.
return function(mod)
  local compile = loadstring or load
  assert(type(compile) == 'function', 'Hoenn PT-BR: compilador Lua indisponível')
  local function module(path)
    local source = assert(mod:read(path), 'Hoenn PT-BR: arquivo ausente: ' .. path)
    local chunk, err = compile(source, '@hoenn_ptbr_jo5k/' .. path)
    assert(chunk, err)
    return chunk()
  end
  local shared = module('shared.lua')(mod)
  local layout = module('layout.lua')(mod)
  return module('hoenn.lua')(mod, 'hoenn', shared, layout)
end
