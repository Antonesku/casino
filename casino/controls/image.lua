require("controls/control")
require("/img/PIXdraw")
local component = require("component")
local gpu = component.gpu

--Класс labe
Image = {}

--Наследование
setmetatable(Image ,{__index = Control}) 

function Image:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.isVisible = isVisible or true
    properties.typeControl = "label"
    properties.nameFile = ""
    properties.x = 0
    properties.y = 0
    properties.typeControl = "image"
    properties.colorBackground = nil
    properties.colorFrame = nil
    properties.onClick = nil

    function properties:drawImage()
        properties.width, properties.height = drawPIX("img/"..properties.nameFile..".pix", properties.x, properties.y,properties.colorBackground)
    end

    function properties:drawFrame(color)
        --Цвет фона
        gpu.setBackground(properties.colorBackground)
        gpu.setForeground(color)

        gpu.fill(properties.x - 1, properties.y, properties.width + 2, 1, "▄")
        gpu.fill(properties.x - 1, properties.y + properties.height + 1, properties.width + 2, 1, "▀")

        gpu.fill(properties.x - 1, properties.y + 1, 1, properties.height, "█")
        gpu.fill(properties.x + properties.width, properties.y + 1, 1, properties.height , "█")
    end

    function properties:removeFrame()
        gpu.setForeground(properties.colorBackground)

        gpu.fill(properties.x - 1, properties.y, properties.width + 2, 1, "▄")
        gpu.fill(properties.x - 1, properties.y + properties.height + 1, properties.width + 2, 1, "▀")

        gpu.fill(properties.x - 1, properties.y + 1, 1, properties.height, "█")
        gpu.fill(properties.x + properties.width, properties.y + 1, 1, properties.height , "█")
    end

    setmetatable(properties, self)
	self.__index = self
	return properties
end


