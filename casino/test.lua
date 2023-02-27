local component = require("component")
local gpu = component.gpu
--local adapter = component.me_interface
local event = require("event")
local computer = require("computer")

local components = component.list()

for k,v in pairs(components) do
   print(k,v)
end


local mK = component.motion_sensor
local mS = component.os_entdetector

mK.setSensitivity(2)

while true do
   event.pull("motion")

   --print(mS.scanPlayers(64)[1].name)
   local t = table.pack(computer.users())
   for j,l in pairs (t) do
      print(j,l)
   end

   computer.addUser(mS.scanPlayers(64)[1].name)
   print(computer.users())
end


local a,s,d,w = event.pull("entityDetect", _, _, _, _)
print(a,s,d,w)
 
--[=[]]
for k,v in pairs(mS.scanPlayers(64)) do
print(k,v )
for j,l in pairs (v) do
   print(j,l)
end
end

--print(mS.greet())--]=]

