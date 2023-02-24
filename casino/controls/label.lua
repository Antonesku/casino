require("controls/control")

--Класс labe
Label = {}

--Наследование
setmetatable(Label ,{__index = Control}) 

function Label:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.isVisible = isVisible or true
    properties.typeControl = "label"
    properties.limitChars = nil
    properties.isDefault = false


    setmetatable(properties, self)
	self.__index = self
	return properties
end


