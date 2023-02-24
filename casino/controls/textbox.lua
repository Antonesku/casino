require("controls/control")
local event = require("event")
local component = require("component")
local gpu = component.gpu

--Класс кнопки
TextBox = {}

--Наследование
setmetatable(TextBox ,{__index = Control}) 

function TextBox:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.onClick = nil
    properties.isActive = isActive or true
    properties.typeControl = "textbox"
    properties.colorBorder = 0x000000
    properties.isFocus = false

    function properties:handle()
        
    end

        
    setmetatable(properties, self)
	self.__index = self
	return properties
end


