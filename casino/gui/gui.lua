local components = require("component")
local gpu = components.gpu
local event = require("event")
local thread = require("thread")
local br = require("/lib/braille")
local font = require("/gui/font")


--Максимальные высота и ширина экрана
local maxWidth, maxHeight = gpu.getResolution()

--Областью нажатия
local areaClickList = {}

--Функция отрисовки формы
function drawForm(form)
    --Обновление списка области нажатий
    --areaClickList = {}
    --Проверка на наличие элементов
    if form == nil then
        return
    end

    --Текущие координаты начала отрисовки
    local currentX, currentY = 0, 0

    for k = 1, #form do
        --Проверка на существование предыдущих элементов
        if k ~= 1 then
            --[[СТОЛБЕЦ]]
            --Установливаем начальные координаты отрисовки div
            local prevDiv = form[k - 1]
    
            currentX = 0
            currentY = prevDiv.coords[4]
        end

        drawDiv(form[k],currentX, currentY)
    end

    --Создание потока для обработки кликов
    --thread.create(clickPerform)
end

--Отрисовка div
function drawDiv(div, currentX, currentY, isVisible)
    local currentDiv = div

    if isVisible == nil then
        isVisible = true
    end

    --Удалени из области видимости
    if currentDiv.isVisible ~= true or isVisible ~= true then
        for k, v in pairs(currentDiv.controls) do
            local control = v
            
            if control.typeControl == "div" then
                drawDiv(control, nil, nil, false)
            elseif control.typeControl == "counter" then
                removeArea(control,"Up")
                removeArea(control,"Down")
            else
                removeArea(control)
            end

        end
        return
    end

    currentX = currentX or currentDiv.coords[1]
    currentY = currentY or currentDiv.coords[2]

    --Текущие высота и ширина
    local currentWidth, currentHeight

    --Автоматическое задание ширины и высоты
    if currentDiv.width == 0 and currentDiv.height == 0 then
        --[[.....]]
    else
        currentWidth = currentDiv.width + currentDiv.padding[2] + currentDiv.padding[4]
        currentHeight = currentDiv.height + currentDiv.padding[1] + currentDiv.padding[3]
    end
    --------------
    --Отрисовка div
    --------------
    if currentDiv.width ~= 0 and currentDiv.height ~= 0 then
        --Установка цвета
        setColors(currentDiv)
        --Отрисовка div
        gpu.fill(currentX, currentY, currentDiv.width, currentDiv.height, " ")
    end

    --Устанавливаем координаты для элемента
    setCoordinates({currentX, currentY, currentX + currentWidth, currentY + currentHeight}, currentDiv)
    ---------------
    --Отрисовка элементов
    ---------------
    if #currentDiv.controls ~= 0 then
        --Начальные точки отрисовки элемента
        local currentXDiv, currentYDiv

        currentXDiv = currentDiv.coords[1] + currentDiv.controls[1].margin[4] + 1 + currentDiv.padding[4]
        currentYDiv = currentDiv.coords[2] + currentDiv.controls[1].margin[1] + 1 + currentDiv.padding[1]
    
        for i = 1,#currentDiv.controls do
            local control = currentDiv.controls[i]
            if i > 1 then
                if currentDiv.typeDiv == "column" then
                    local prevControl = currentDiv.controls[i-1]
                    currentXDiv = currentDiv.coords[1] + control.margin[4] + 1 + currentDiv.padding[4]
                    currentYDiv = prevControl.coords[4] + prevControl.margin[3] + control.margin[1] --+ currentDiv.padding[1]
                end
    
                if currentDiv.typeDiv == "row" then
                    local prevControl = currentDiv.controls[i-1]
                    currentXDiv = prevControl.coords[3] + prevControl.margin[2] + control.margin[4] + currentDiv.padding[4]
                    currentYDiv = currentDiv.coords[2] + control.margin[1] + 1 + currentDiv.padding[1]
                end
            end

            if control.typeControl == "button" then
                drawButton(currentDiv.controls[i], currentXDiv, currentYDiv)
            elseif control.typeControl == "div" then
                drawDiv(currentDiv.controls[i], currentXDiv, currentYDiv)
            elseif control.typeControl == "label" then
                drawLabel(currentDiv.controls[i], currentXDiv, currentYDiv)
            elseif control.typeControl == "counter" then
                drawCounter(currentDiv.controls[i], currentXDiv, currentYDiv, currentDiv.colorBackground)
            elseif control.typeControl == "image" then
                drawImage(currentDiv.controls[i], currentXDiv, currentYDiv, currentDiv.colorBackground)
            elseif control.typeControl == "textbox" then
                drawTextBox(currentDiv.controls[i], currentXDiv, currentYDiv)
            end
        end
    end
end

function drawLabel(control, currentXDiv, currentYDiv, parentColorBackround)
    if currentXDiv == nil or currentYDiv == nil then
        currentXDiv = control.coords[1]
        currentYDiv = control.coords[2]
    end
    
    if control.isVisible == true then
        -------------------
        --Отрисовка элемента
        -------------------
        setColors(control)
        --Начальные точки внутреннего контента элемента
        local xContent, yContent
        xContent = currentXDiv + control.padding[4]
        yContent = currentYDiv + control.padding[1]

        --Ширина и высота элемента
        local controlWidth, controlHeight

        if control.width ~= 0 and control.height ~= 0 then
            controlWidth = control.width + control.padding[2] + control.padding[4]
            controlHeight = control.height + control.padding[1] + control.padding[3]
        else
            controlWidth = #control.text + control.padding[2] + control.padding[4]
            controlHeight = 1 + control.padding[1] + control.padding[3]
        end

        --Устанавливаем координаты для элемента
        setCoordinates({currentXDiv, currentYDiv, currentXDiv + controlWidth, currentYDiv + controlHeight}, control)

        gpu.fill(currentXDiv, currentYDiv, controlWidth, controlHeight, ' ')

        --Отрисовка текста
        
        if control.text ~= "" then
            
            if control.limitChars ~= nil then
                control.text = control.text:sub(1, control.limitChars)
            end

            if control.isDefault then
                gpu.set(xContent, yContent, control.text)
            else
                font.drawString(control.text, xContent, yContent)
            end
        end
    end
end

function drawImage(control, currentXDiv, currentYDiv, parentColorBackround)
    if currentXDiv == nil or currentYDiv == nil then
        currentXDiv = control.coords[1]
        currentYDiv = control.coords[2]
    end

    if control.isVisible == true then
        -------------------
        --Отрисовка элемента
        -------------------
        --Начальные точки внутреннего контента элемента
        local xContent, yContent
        xContent = currentXDiv + control.padding[4]
        yContent = currentYDiv + control.padding[1]

        control.x = xContent - 1
        control.y = yContent - 1
        
        if control.colorBackground == nil then
            control.colorBackground = parentColorBackround
        end

        setColors(control)

        control:drawImage()

        --[=[
        while true do
            for i = 1, 4 do
                control.nameFile = tostring(i)
                os.sleep(0.035)
                control:drawImage()
            end
        end

        --]=]


        --Ширина и высота элемента
        local controlWidth, controlHeight = control.width, control.height

        if control.width ~= 0 and control.height ~= 0 then
            controlWidth = control.width + control.padding[2] + control.padding[4]
            controlHeight = control.height + control.padding[1] + control.padding[3]
        else
            controlWidth = #control.text + control.padding[2] + control.padding[4]
            controlHeight = 1 + control.padding[1] + control.padding[3]
        end

        --Устанавливаем координаты для элемента
        setCoordinates({control.x, control.y, control.x + controlWidth, control.y + controlHeight}, control)

        if control.colorFrame ~= nil then
            control:drawFrame(control.colorFrame)
        end
        
        --Добавление в область нажатия
        if control.onClick ~= nil then
            addArea(control, control.coords[1], control.coords[2], control.coords[3], control.coords[4], control.onClick)
        end

    end
end

function drawButton(control,currentXDiv,currentYDiv)
    if currentXDiv == nil or currentYDiv == nil then
        currentXDiv = control.coords[1]
        currentYDiv = control.coords[2]
    end

    if control.isVisible == true then
        -------------------
        --Отрисовка элемента
        -------------------
        setColors(control)
        --Начальные точки внутреннего контента элемента
        local xContent, yContent
        xContent = currentXDiv + control.padding[4]
        yContent = currentYDiv + control.padding[1]

        --Ширина и высота элемента
        local controlWidth, controlHeight

        if control.width ~= 0 and control.height ~= 0 then
            controlWidth = control.width + control.padding[2] + control.padding[4]
            controlHeight = control.height + control.padding[1] + control.padding[3]
        else
            controlWidth = #control.text + control.padding[2] + control.padding[4]
            controlHeight = 1 + control.padding[1] + control.padding[3]
        end

        --Устанавливаем координаты для элемента
        setCoordinates({currentXDiv, currentYDiv, currentXDiv + controlWidth, currentYDiv + controlHeight}, control)

        --If braille
        if control.typeButton == "braille" then
            br.render(control.braille, xContent, yContent)
        else
            gpu.fill(currentXDiv, currentYDiv, controlWidth, controlHeight, ' ')
        end

        if control.colorFrame ~= nil then
            control:drawFrame(control.colorFrame)
        end

        --Отрисовка текста
        if control.text ~= "" then
            if control.limitChars ~= nil then
                control.text = control.text:sub(1, control.limitChars)
            end

            if control.isDefault then
                gpu.set(xContent, yContent, control.text)
            else
                font.drawString(control.text, xContent, yContent)
            end
        end

        

        --Добавление в область нажатия
        if control.onClick ~= nil then
            addArea(control, control.coords[1], control.coords[2], control.coords[3], control.coords[4], control.onClick)
        end
    end
end

function drawTextBox(control, currentXDiv, currentYDiv)
    if currentXDiv == nil or currentYDiv == nil then
        currentXDiv = control.coords[1]
        currentYDiv = control.coords[2]
    end

    if control.isVisible == true then
        -------------------
        --Отрисовка элемента
        -------------------
        setColors(control)
        --Начальные точки внутреннего контента элемента
        local xContent, yContent
        xContent = currentXDiv + control.padding[4]
        yContent = currentYDiv + control.padding[1]

        --Ширина и высота элемента
        local controlWidth, controlHeight

        if control.width ~= 0 and control.height ~= 0 then
            controlWidth = control.width + control.padding[2] + control.padding[4]
            controlHeight = control.height + control.padding[1] + control.padding[3]
        else
            controlWidth = #control.text + control.padding[2] + control.padding[4]
            controlHeight = 1 + control.padding[1] + control.padding[3]
        end

        --Устанавливаем координаты для элемента
        setCoordinates({currentXDiv, currentYDiv, currentXDiv + controlWidth, currentYDiv + controlHeight}, control)

        
        gpu.fill(currentXDiv, currentYDiv, controlWidth, controlHeight, ' ')

        --Отрисовка границы
        gpu.setForeground(control.colorBorder)

        local border = br.matrix(controlWidth * 2, controlHeight * 6)
        br.line(border, 1, 1, 1, controlHeight * 6)
        br.line(border, controlWidth * 2, 1, controlWidth * 2, controlHeight * 6)

        br.line(border, 1, 1, controlWidth * 2, 1)
        br.line(border, 1, controlHeight * 6, controlWidth * 2, controlHeight * 6)

        br.render(border, currentXDiv, currentYDiv)

        gpu.setForeground(control.colorForeground)

        --Отрисовка текста
        if control.text ~= "" then
            gpu.set(xContent, yContent, control.text)
        end

        --Добавление в область нажатия
        if control.onClick ~= nil then
            addArea(control, control.coords[1], control.coords[2], control.coords[3], control.coords[4], control.onClick)
        end
    end
end

function drawCounter(control,currentXDiv ,currentYDiv, color)
    if currentXDiv == nil or currentYDiv == nil then
        currentXDiv = control.coords[1]
        currentYDiv = control.coords[2]
    else
        currentXDiv = currentXDiv - 1
    end
    
    if color == nil then
        color = 0x000000
    end

    if control.isVisible == true then
        -------------------
        --Отрисовка элемента
        -------------------
        setColors(control)
        --gpu.setBackground(color)
        --Начальные точки внутреннего контента элемента
        local xContent, yContent
        xContent = currentXDiv + control.padding[4]
        yContent = currentYDiv + control.padding[1]

        --Ширина и высота элемента
        local controlWidth, controlHeight

        if control.width ~= 0 and control.height ~= 0 then
            controlWidth = control.width + control.padding[2] + control.padding[4]
            controlHeight = control.height + control.padding[1] + control.padding[3]
        else
            controlWidth = #control.text + control.padding[2] + control.padding[4]
            controlHeight = 1 + control.padding[1] + control.padding[3]
        end

        --Стрелка вверх
        gpu.setForeground(control.colorArrow)
        local xArrow, yArrow
        xArrow = xContent
        yArrow = currentYDiv + math.floor(controlHeight / 2) - 2

        
        gpu.fill(xArrow + 3, yArrow, 1, 1, "█")
        gpu.fill(xArrow + 2, yArrow, 1, 1, "▄")

        gpu.fill(xArrow + 4, yArrow, 1, 1, "▄")
        gpu.fill(xArrow + 1, yArrow + 1, 5, 1, "▀")

        --Добавление в область нажатия Стрелки Вверх
        addArea(control, xArrow, yArrow, xArrow + 6, yArrow + 2, control.upClick, "Up")

        --Стрелка вниз
        yArrow = yArrow + 2

        gpu.fill(xArrow + 1, yArrow, 5, 1, "▀")
        gpu.fill(xArrow + 2, yArrow, 3, 1, "█")
        gpu.fill(xArrow + 3, yArrow + 1, 1, 1, "▀")

        --Добавление в область нажатия Стрекли Вниз
        addArea(control, xArrow, yArrow, xArrow + 6, yArrow + 2, control.downClick, "Down")

        gpu.setForeground(control.colorForeground)

        --Область для значения
        local widthAreaValue, heightAreaValue
        widthAreaValue = control.width - 6
        heightAreaValue = control.height 

        local xAreaValue, yAreaValue, x2AreaValue, y2AreaValue
        xAreaValue = xContent + 7
        yAreaValue = currentYDiv + math.floor(controlHeight / 2) - math.floor(heightAreaValue / 2)

        x2AreaValue = xAreaValue + widthAreaValue
        y2AreaValue = yAreaValue +heightAreaValue

        local brWidth = widthAreaValue * 2
        local brHeight = heightAreaValue * 4

        --Отрисовка рамки области значений

        areaValue = br.matrix(brWidth, brHeight)
        br.line(areaValue, 1, 1, brWidth, 1)
        br.line(areaValue, 1, brHeight, brWidth, brHeight)
        br.line(areaValue, 1, 1, 1, brHeight)
        br.line(areaValue, brWidth, 1, brWidth, brHeight)

        gpu.setForeground(control.colorBorder)
        gpu.setBackground(control.backgroundColorArea)
        gpu.fill(xAreaValue, yAreaValue, widthAreaValue, heightAreaValue, ' ')
        control.areaProperties = {xAreaValue, yAreaValue, widthAreaValue, heightAreaValue, areaValue}

        br.render(areaValue,xAreaValue, yAreaValue)

        --Отрисовка значения
        local value = tostring(control.value)
        local xValue, yValue

        xValue = xAreaValue + 2 --math.floor(widthAreaValue / 2) - math.floor(#value / 2) - 1
        yValue = yAreaValue + math.floor(heightAreaValue / 2) - 1

        gpu.setForeground(control.colorValue)
        
        local numbers = font.getNumbers()

        xValue = xValue -- math.floor(#tostring(control.value) * 3 / 2) + 1

        font.drawNumber(control.value, xValue, yValue)

        control.coordsValue = {xValue, yValue}

        --Устанавливаем координаты для элемента
        setCoordinates({currentXDiv, currentYDiv, currentXDiv + controlWidth, currentYDiv + controlHeight}, control)
    end
end

--Функция задания текущего цвета
function setColors(control)
    gpu.setBackground(control.colorBackground)
    gpu.setForeground(control.colorForeground)
end

--Функция установки координат для элемента
function setCoordinates(coords, control)
    control.coords = coords
end

--Очистка экрана
function clearScreen()
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    local width, height = gpu.getResolution()
    gpu.fill(0, 0, width + 1, height, ' ')
end

function isAreaExists(control, extra)
    if areaClickList == nil then
        return
    end

    if extra == nil then
        extra = ""
    end

    for i = 1, #areaClickList do
        local areaClick = areaClickList[i]
        if areaClick.nameControl == (control.nameControl .. extra) then
            return true
        end
    end

    return false
end

function removeArea(control, extra)
    if areaClickList == nil then
        return
    end

    if extra == nil then
        extra = ""
    end

    if isAreaExists(control, extra) then
        local posTable = {}
        for i = 1, #areaClickList do
            local areaClick = areaClickList[i]
            local nameControl = control.nameControl .. extra
            if areaClick.nameControl == nameControl then
                table.insert(posTable, i)
            end
        end

        for i = #posTable, 1, -1 do
            table.remove(areaClickList, posTable[i])
        end
    end

    
end

function addArea(control, x1, y1, x2, y2, func, extra)
    if extra == nil then
        extra = ""
    end

    removeArea(control, extra)
    
    local controlArea = {
        coords = {x1, y1, x2, y2},
        func = func,
        nameControl = control.nameControl .. extra
    }
    table.insert(areaClickList, controlArea)
end

function getAreaList()
    return areaClickList
end





