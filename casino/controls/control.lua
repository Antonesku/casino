require("controls/id")
--Базовый класс для элементов управления
Control = {}

--Конструктор класса
function Control:new(width, height, padding, margin, colorBackground, colorForeground, coords, typeControl)
	local properties = {}
        properties.id = initId()
        properties.width = width or 0
        properties.height = height or 0
        properties.padding =  padding or {0, 0, 0, 0}
        properties.margin = margin or {0, 1 ,0 ,0} 
        properties.colorBackground = colorBackground or 0xFFFFFF 
        properties.colorForeground = colorForeground or 0x000000
        properties.coords = coords or {0, 0, 0, 0}
        properties.typeControl = nil or typeControl
        properties.isVisible = true
        properties.nameControl = ""

    --Методы класса
    --Id
    --[=[
    function properties:getId()
        return properties.id
    end

    --Ширина
    function properties:getWidth()
        return properties.width
    end

    function properties:setWidth(width)
        properties.width = width
    end

    --Высота
    function properties:getHeight()
        return properties.height
    end

    function properties:setHeight(height)
        properties.height = height
    end

    --Внутренние отступы
    function properties:getPadding()
        return properties.padding
    end

    function properties:setPadding(padding)
        properties.padding = padding
    end

    --Внешние отступы
    function properties:getMargin()
        return properties.margin
    end

    function properties:setMargin(margin)
        properties.margin = margin
    end

    --Цвет фона
    function properties:getBackgroundColor()
        return properties.colorBackground
    end

    function properties:setBackgroundColor(color)
        properties.colorBackground = color
    end

    --Цвет текста
    function properties:getForegroundColor()
        return properties.colorForeground
    end

    function properties:setForegroundColor(color)
        properties.colorForeground = color
    end

    --Координаты
    function properties:getCoordinates()
        return properties.coords
    end

    function properties:setCoordinates(coords)
        properties.coords = coords
    end
    --]=]


	setmetatable(properties, self)
	self.__index = self
	return properties
end

