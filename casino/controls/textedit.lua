require("controls/control")

--Класс labe
TextEdit = {}

--Наследование
setmetatable(TextEdit ,{__index = Control}) 

function TextEdit:new()
    local properties = Control:new()
    properties.text = text or ""
    properties.isVisible = isVisible or true
    properties.typeControl = "textedit"

    setmetatable(properties, self)
	self.__index = self
	return properties
end


