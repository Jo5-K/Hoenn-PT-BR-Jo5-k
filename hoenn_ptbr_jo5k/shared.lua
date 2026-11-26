-- All resources are part of this ZIP. FireRed is a build-time source only.
return function(mod)
  local compile = loadstring or load
  local allowed = {
    strings = true, strings_by_english = true, item_names = true,
    item_descriptions = true, move_names = true, trainer_class_names = true,
    species_metrics = true, start_menu = true,
  }
  local cache = {}
  local shared = { version = 'embedded-frlg-0.1.7' }
  function shared.catalog(name)
    assert(allowed[name], 'Hoenn PT-BR: catálogo não permitido: ' .. tostring(name))
    if not cache[name] then
      local path = 'lang/shared/' .. name .. '.lua'
      local source = assert(mod:read(path), 'Hoenn PT-BR: recurso interno ausente: ' .. path)
      local chunk, err = compile(source, '@' .. path)
      assert(chunk, err)
      local value = chunk()
      assert(type(value) == 'table', 'Hoenn PT-BR: catálogo inválido: ' .. path)
      cache[name] = value
    end
    return cache[name]
  end
  return shared
end
