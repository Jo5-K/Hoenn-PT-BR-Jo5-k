package.path=assert(arg[1], 'engine root required')..'/?.lua;'..package.path
local hostio,hostloadfile=io,loadfile
local root=assert(arg[2], 'mod root required')..'/'
local files={}
local p=hostio.popen('find '..string.format("'%s'",root:gsub("'","'\"'\"'"))..' -type f')
for f in p:lines() do local h=assert(hostio.open(f,'rb'));files['mods/hoenn_ptbr_jo5k/'..f:sub(#root+1)]=h:read('*a');h:close() end;p:close()
local fs={
 read=function(path) return files[path] end,
 write=function(path,s) files[path]=s;return true end,
 createDirectory=function() return true end,
 getInfo=function(path) if files[path] then return {type='file',size=#files[path]} end;for k in pairs(files) do if k:sub(1,#path+1)==path..'/' then return {type='directory'} end end end,
 getDirectoryItems=function(path) local seen,out={},{};for k in pairs(files) do if k:sub(1,#path+1)==path..'/' then local c=k:sub(#path+2):match('^[^/]+');if c and not seen[c] then seen[c]=true;out[#out+1]=c end end end;return out end,
 load=function(path) return loadstring(files[path] or '',path) end,
}
local G=require('src.core.GameVersion');G.set(arg[3] or 'emerald')
local data={generation=3,gen3Text=assert(hostloadfile(assert(arg[4], 'Emerald cache root required')..'/data/generated/gba/scripts/text.lua'))(),strings={}}
local cache=arg[4]..'/data/generated/gba/'
data.gen3Items=assert(hostloadfile(cache..'items/pack.lua'))()
data.gen3Moves=assert(hostloadfile(cache..'pokemon/battle_moves.lua'))()
data.gen3Moves.names=assert(hostloadfile(cache..'pokemon/move_names.lua'))()
data.gen3RomText={}
local loader=require('src.mods.Loader').new({fs=fs,generation=3,version=arg[3] or 'emerald',dev=false})
local ok,err=loader:load(data)
print('RESULT',ok,err)
for _,s in ipairs(loader:status()) do print('STATUS',s.id,s.state,s.error) end
for _,e in ipairs(loader.errors) do print('ERROR',e) end
local n=0;for _ in pairs(loader.content.text.ops) do n=n+1 end; print('TEXT OPS',n)
for _,s in ipairs(data.gen3Text['g3:081dc881']) do if s.s then print('MERGED',s.s) end end
print('TARGET',loader:_target('text',loader.content.text.spec))

print('ITEM',data.gen3Items.items[13].name,data.gen3Items.items[13].description)
print('MOVE',data.gen3Moves.names[33])
for _,key in ipairs({'gText_MenuBag','gText_MenuSave','gText_Birch_Welcome','gNatureNamePointers[3]'}) do
 local out={};for _,seg in ipairs(data.gen3Text[key]) do if seg.s then out[#out+1]=seg.s end end;print('UI',key,table.concat(out,' / '))
end
print('STRINGS',data.strings['OVERGROW'])

assert(ok,table.concat(loader.errors,'; '))
assert(#loader.errors==0,table.concat(loader.errors,'; '))
local mod=assert(loader.mods.hoenn_ptbr_jo5k)
if (arg[3] or 'emerald')=='firered' then
 assert(mod.state~='loaded');assert(n==0);print('PASS: FRLG excluded by manifest')
else
 assert(mod.state=='loaded',mod.state)
 assert(n>8000, 'dialogues were not applied')
 assert(data.gen3Items.items[13].name=='POÇÃO')
 assert(data.gen3Items.items[13].price==300)
 assert(data.gen3Items.items[13].description:find('20 PS',1,true))
 assert(data.gen3Moves.names[33]=='INVESTIDA')
 assert(loader.mods.gen3_frlg_pt_br_mod==nil)
 print('PASS: standalone native loader, no external mod installed, descriptions and item/move labels loaded')
end

if (arg[3] or 'emerald') ~= 'firered' and data.gen3Font then
 assert(data.gen3Font.ttf and data.gen3Font.ttf.file:match('HoennCompact.ttf$'))
 local layoutChunk=assert(loadfile(root..'layout.lua'))()
 local layout=layoutChunk({read=function(_,path) return files['mods/hoenn_ptbr_jo5k/'..path] end,content={}})
 local checked,controlled=0,0
 local overflow={}
 for key in pairs(loader.content.text.ops) do
  local ir=data.gen3Text[key]
  if not key:match('^gText_XNature') then
   local col=0
   for _,node in ipairs(ir or {}) do
    if node.t=='text' then
     local value=node.s:gsub('%s+$','')
     col=col+layout.width(value)
     if col>208 then overflow[key]=col end
    elseif node.t=='nl' or node.t=='scroll' or node.t=='para' then col=0
    elseif node.t=='player' or node.t=='rival' then col=col+42
    elseif node.t=='strvar' or node.t=='ph' then col=col+(key=='gText_XMinYDotZSec' and 20 or 96)
    elseif node.t=='ext' then controlled=controlled+1 end
   end
  end
  checked=checked+1
 end
 local errors={};for k,v in pairs(overflow) do errors[#errors+1]=k..':'..v end
 table.sort(errors)
 if #errors>0 then print('OVERFLOW_KEYS',#errors,table.concat(errors,'; ',1,math.min(20,#errors))) end
 assert(#errors==0,'translated line too wide')
 local count=0
 for id,item in pairs(data.gen3Items.items) do
  if id>0 and item.name~='????????' and item.description~='?????' then
   local lines=0
   for line in (item.description..'\n'):gmatch('(.-)\n') do
    lines=lines+1;assert(layout.width(line)<=109,item.name..': item description width')
   end
   assert(lines<=3,item.name..': item description height');count=count+1
  end
 end
 for _,key in ipairs({'gText_XNatureMetAtYZ','gText_XNatureHatchedAtYZ','gText_XNatureProbablyMetAt'}) do
  local found=false;for _,node in ipairs(data.gen3Text[key]) do if node.t=='text' and node.s:find('Nv.',1,true) then found=true end end;assert(found,key..': translated memo missing')
 end
 print(('PASS: %d installed text overrides checked for width; %d native item descriptions fit; font + dynamic memo registered'):format(checked,count))
end
