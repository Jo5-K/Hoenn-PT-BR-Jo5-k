-- Run from the mod directory; requires no engine, ROM, graphics or other mod.
local function read(path) local f=assert(io.open(path,'rb'));local s=f:read('*a');f:close();return s end
local fonts={}
local mod={read=function(_,p) return read(p) end,content={font={register=function(_,id,value) fonts[id]=value end}},assets={path=function(_,p) return p end}}
local layout=assert(loadfile('layout.lua'))()(mod)
assert(fonts.ttf.file=='fonts/HoennCompact.ttf' and fonts.ttf.size==16)
assert(layout.clean('MÃE nÃo nÍvel São Ícaro')=='MÃE não nível São Ícaro')
local strings=0
for en,text in pairs(layout.data.strings) do
 local rule=assert(layout.data.budgets[en]);local n=0
 for line in (text..'\n'):gmatch('(.-)\n') do n=n+1;assert(layout.width(line)<=rule.width,en..': horizontal overflow') end
 assert(n<=rule.lines,en..': vertical overflow')
 strings=strings+1
end
local items=0
for id,text in pairs(layout.data.items) do
 local n=0;for line in (text..'\n'):gmatch('(.-)\n') do n=n+1;assert(layout.width(line)<=109,id..': bag width') end
 assert(n<=3,id..': bag height');items=items+1
end
local cases={
 {{t='text',s=string.rep('nÃo cabe ',80)},{t='eos'}},
 {{t='text',s='Olá '},{t='player'},{t='text',s=', este item será seu: '},{t='strvar',n=1},{t='text',s='.'},{t='eos'}},
 {{t='ext',cmd=1,args={2}},{t='text',s=string.rep('Água e ação. ',30)},{t='para'},{t='text',s='Fim.'},{t='eos'}},
 {{t='text',s=string.rep('Ó',100)},{t='eos'}},
}
local function semantic(ir)
 local out={};for _,node in ipairs(ir) do
  if node.t=='text' then out[#out+1]=layout.clean(node.s):gsub('%s','')
  elseif node.t~='nl' and node.t~='para' and node.t~='scroll' then out[#out+1]=node.t..':'..tostring(node.n or node.cmd or '') end
 end;return table.concat(out)
end
for _,original in ipairs(cases) do
 local ir=layout.dialogue(original);assert(semantic(original)==semantic(ir),'reflow changed text/control/placeholder contents')
 assert(ir[#ir].t=='eos')
 local col=0
 for _,node in ipairs(ir) do
  if node.t=='text' then col=col+layout.width(node.s:gsub('%s+$',''));assert(col<=208,'dialogue width overflow')
  elseif node.t=='nl' or node.t=='scroll' or node.t=='para' then col=0
  elseif node.t=='player' or node.t=='rival' then col=col+42
  elseif node.t=='strvar' or node.t=='dynamic' or node.t=='ph' then col=col+96 end
 end
end
local names=assert(loadfile('lang/hoenn/names.lua'))()
local source={};for n=0,5 do source[#source+1]={t='dynamic',n=n} end;source[#source+1]={t='eos'}
local memoCount=0
for _,key in ipairs({'gText_XNature','gText_XNatureMetAtYZ','gText_XNatureHatchedAtYZ','gText_XNatureMetSomewhereAt','gText_XNatureHatchedSomewhereAt','gText_XNatureProbablyMetAt','gText_XNatureObtainedInTrade','gText_XNatureFatefulEncounter'}) do
 local ir=assert(layout.memo(key,source))
 for english,portuguese in pairs(names.nature_names) do
  for _,nature in ipairs({english,portuguese}) do
   local values={[0]='',[1]='',[2]=nature,[3]='100',[4]="AQUARINTOLABIRINTO D'ÁGUA",[5]=''}
   local lines={''}
   for _,node in ipairs(ir) do
    if node.t=='text' then lines[#lines]=lines[#lines]..node.s
    elseif node.t=='dynamic' then lines[#lines]=lines[#lines]..values[node.n]
    elseif node.t=='nl' then lines[#lines+1]='' end
   end
   assert(#lines<=3,key..': memo height')
   for _,line in ipairs(lines) do assert(layout.width(line)<=144,key..': memo width') end
   memoCount=memoCount+1
  end
 end
end
assert(not layout.memo('gText_XNatureMetAtYZ',{{t='text',s='Different dynamic contract'}}))
print(('PASS: %d context strings, %d item records, %d memo cases; reflow preserves text/placeholders; no engine access'):format(strings,items,memoCount))
