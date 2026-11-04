-- Installed resource dependency: FRLG stays incompatible/inactive in Hoenn.
-- This bridge reads only this whitelist; it never executes the upstream entry.
return function(mod)
  local loader = assert(mod.game and mod.game.mods, 'Hoenn PT-BR: gerenciador de mods indisponível')
  local dep = loader.mods['gen3_frlg_pt-br_mod']
  assert(dep and dep.manifest, 'Hoenn PT-BR requer o mod gen3_frlg_pt-br_mod instalado (0.1.6+)')
  local a,b,c = tostring(dep.manifest.version):match('^(%d+)%.(%d+)%.(%d+)')
  assert(a and (tonumber(a)>0 or tonumber(b)>1 or tonumber(b)==1 and tonumber(c)>=6),
    'Hoenn PT-BR requer FRLG PT-BR 0.1.6 ou posterior')
  local allowed = {}
  for _,name in ipairs({'strings','strings_by_english','move_names','item_names','item_descriptions','trainer_class_names','species_metrics','start_menu'}) do
    allowed['lang/'..name..'.lua'] = true
  end
  for _,name in ipairs({'latin_normal_fg','latin_normal_shadow','latin_small_fg','latin_small_shadow'}) do
    allowed['assets/gen3-export/chrome/fonts/'..name..'.png'] = true
  end
  allowed['fonts/latin_widths.lua'],allowed['fonts/latin_small_widths.lua'] = true,true
  local S = {version=dep.manifest.version, fs=loader.fs}
  function S.read(path)
    assert(allowed[path], 'Recurso compartilhado não permitido: '..tostring(path))
    return assert(loader.fs.read(dep.path..'/'..path), 'Recurso FRLG ausente: '..path)
  end
  function S.catalog(name)
    local path='lang/'..name..'.lua'
    local value=assert(loadstring(S.read(path),'@FRLG/'..path))()
    assert(type(value)=='table','Catálogo FRLG inválido: '..name)
    return value
  end
  return S
end
