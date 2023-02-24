local components = require("component")
local gpu = components.gpu
local numbers = require("/gui/font")
local br = require("/lib/braille")

require("controls/control")

--Класс counter
Counter = {}

--Наследование
setmetatable(Counter ,{__index = Control}) 

function Counter:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.isVisible = isVisible or true
    properties.isActive = isActive or true
    properties.minValue = 0
    properties.maxValue = 10
    properties.value = 0
    properties.step = 1
    properties.typeControl = "counter"
    properties.colorForeground = 0x000000
    properties.coordsValue = {properties.width, properties.height}
    properties.backgroundColorArea = 0x2F4F4F
    properties.prevValue = 0
    properties.coordsArea = {0, 0, 0, 0}
    properties.colorArrow = 0x000000
    properties.colorBorder = 0x000000
    properties.colorValue = 0xFFFFFF
    properties.values = nil
    properties.index = 1
    properties.onChange = nil

    function properties:upClick()
        if properties.values ~= nil then
            if properties.index == #properties.values then
                --properties.value = properties.values[1]
                --properties.index = 1
            else
                properties.value = properties.values[properties.index + 1]
                properties.index = properties.index + 1
            end
        else
            if properties.value + properties.step <= properties.maxValue then
                properties.value = properties.value + properties.step
                properties.prevValue = properties.value
            end
        end
        

        gpu.setBackground(properties.backgroundColorArea)

        local x

        if(#tostring(properties.minValue)) < #tostring(properties.value) then
            x = properties.coordsValue[1] - math.floor(#tostring(properties.value) * 3 / 2) + 1
        else
            x = properties.coordsValue[1]
        end

        gpu.setForeground(properties.colorBorder)
        gpu.setBackground(properties.backgroundColorArea)
        gpu.fill(properties.areaProperties[1], 
        properties.areaProperties[2],
        properties.areaProperties[3], 
        properties.areaProperties[4], ' ')
        br.render(properties.areaProperties[5], properties.areaProperties[1], properties.areaProperties[2])


        gpu.setForeground(properties.colorValue)
        numbers.drawNumber(properties.value, properties.coordsValue[1], properties.coordsValue[2])

        if properties.onChange ~= nil then
            properties.onChange()
        end
    end

    function properties:downClick()
        if properties.values ~= nil then
            if properties.index == 1 then
                --properties.value = properties.values[#properties.values]
                --properties.index = #properties.values
            else
                properties.value = properties.values[properties.index - 1]
                properties.index = properties.index - 1
            end
        else
            if properties.value - properties.step >= properties.minValue then
                properties.prevValue = properties.value
                properties.value = properties.value - properties.step
            end
        end

        local x

        if(#tostring(properties.minValue)) < #tostring(properties.value) then
            x = properties.coordsValue[1] - math.floor(#tostring(properties.value) * 3 / 2) + 1
        else
            x = properties.coordsValue[1]
        end


        

        gpu.setBackground(properties.backgroundColorArea)

        gpu.setForeground(properties.colorBorder)
        gpu.setBackground(properties.backgroundColorArea)
        gpu.fill(properties.areaProperties[1], 
        properties.areaProperties[2],
        properties.areaProperties[3], 
        properties.areaProperties[4], ' ')
        br.render(properties.areaProperties[5], properties.areaProperties[1], properties.areaProperties[2])

        gpu.setForeground(properties.colorValue)
        numbers.drawNumber(properties.value, properties.coordsValue[1], properties.coordsValue[2])

        local width = properties.areaProperties[3]
        local lenghtValue = #tostring(properties.value)

        local x = properties.areaProperties[1] + math.floor(width / 2) - 1
        x = x - (math.floor(lenghtValue / 2) * 3)


        local y = properties.areaProperties[2] + math.floor(properties.areaProperties[4] / 2)
        y = y - 1

        if properties.onChange ~= nil then
            properties.onChange()
        end
    end

    setmetatable(properties, self)
	self.__index = self
	return properties
end


