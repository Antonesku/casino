require("controls/control")
local component = require("component")
local gpu = component.gpu
local br = require("lib/braille")

--Класс кнопки
Button = {}

--Наследование
setmetatable(Button ,{__index = Control}) 

function Button:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.onClick = nil
    properties.isActive = isActive or true
    properties.typeControl = "button"
    properties.typeButton = "common"
    properties.braille = nil
    properties.colorFrame = nil
    properties.isDefault = false

    function properties:drawFrame(color)
        local x, y = properties.coords[1], properties.coords[2]
        --Цвет фона
        gpu.setBackground(properties.colorBackground)
        gpu.setForeground(color)

        local width, height = properties.width * 2 + properties.padding[2] * 2 + properties.padding[4] * 2, 
        properties.height * 4 + properties.padding[1] * 4  + properties.padding[3] * 4

        local border = br.matrix(width, height)

        br.line(border, 1, 1, width, 1)
        br.line(border, 1, height, width, height)

        br.line(border, 1, 1, 1, height)
        br.line(border, width, 1, width, height)

        br.render(border, x, y)

        gpu.setForeground(properties.colorForeground)

        --gpu.fill(x - 1, y, properties.width + 2, 1, "▄")
        --gpu.fill(x - 1, y + properties.height + 1, properties.width + 2, 1, "▀")

        --gpu.fill(x - 1, y + 1, 1, properties.height, "█")
        --gpu.fill(x + properties.width, y + 1, 1, properties.height , "█")
    end

    setmetatable(properties, self)
	self.__index = self
	return properties
end


