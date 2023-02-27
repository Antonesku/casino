local computer = require("computer")
local component = require("component")
local event = require("event")
local thread = require("thread")

local detect = {}
local motionSensor = component.motion_sensor
local entityDetector = component.os_entdetector

motionSensor.setSensitivity(1.5)


local function detectOn()
    while true do
        event.pull("motion")

        local playerList = entityDetector.scanPlayers(64)

        if playerList ~= nil then
            for i = 1, #playerList do
                computer.addUser(playerList[i].name)
            end
        end

        os.sleep(5)
    end
end

detect.onDetect = function()
    local thrd = thread.create(detectOn)
end

return detect

