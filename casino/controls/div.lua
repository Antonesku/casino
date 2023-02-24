require("controls/control")

--Класс div
Div = {}

--Наследование
setmetatable(Div ,{__index = Control}) 

function Div:new()
    local properties = Control:new()

    properties.typeDiv = typeDiv or "column"
    properties.contentAlign = contentAlign or "center"
    properties.spaceBetween = spaceBetween or 0
    properties.controls = controls or {}
    properties.typeControl = "div"

    --Методы класса
    --Тип контейнера
    --[=[
    function properties:getTypeDiv()
        return properties.typeDiv
    end

    function properties:settypeDiv(typeDiv)
        properties.typeDiv = typeDiv
    end

    --Выравнивание
    function properties:getContentAlign()
        return properties.contentAlign
    end

    function properties:setContentAlign(contentAlign)
        properties.contentAlign = contentAlign
    end

    --Отступы между элементами
    function properties:getSpaceBetween()
        return properties.spaceBetween
    end

    function properties:setSpaceBetween(spaceBetween)
        properties.spaceBetween = spaceBetween
    end

    --Массив элементов
    function properties:getControls()
        return properties.controls
    end

    function properties:setControls(controls)
        properties.controls = controls
    end

    --]=]

    setmetatable(properties, self)
    self.__index = self
    return properties
end





