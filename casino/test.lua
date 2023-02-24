local component = require("component")
local gpu = component.gpu
--local adapter = component.me_interface
local event = require("event")

local components = component.list()

for k,v in pairs(components) do
    local cmp = component.proxy(k)

    print(v)

    for k,v in pairs(cmp) do
       -- print(k,v)
    end
end

local transposer = component.transposer
for k,v in pairs(transposer) do
    print(k,v)
 end

 local inv1 = 1
 local inv2 = 4

 for i = 1, 35 do 
    transposer.transferItem(inv1, inv2, 1, 1, 2)
 end
 print(transposer.getInventorySize(1))

--print(adapter.getInterfaceConfiguration(1))
--for k,v in pairs(adapter.getInterfaceConfiguration()) do
   -- print(k,v)
 --end

 


