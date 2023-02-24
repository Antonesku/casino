local component = require("component")
local gpu = component.gpu
local event = require("event")
require("gui/gui")
local font = require("/gui/font")
--Подключение библиотеки элементов управления
local controls = require("controls/conrollib")
local br = require("lib/braille")
local db = require("database")
local sG = require("slot")
local tF = require("transfer")
local thread = require("thread")

--Таймер
local timer

--Никнейм игрока
local nicknameUser = nil
local nicknameTap

--Текущий пользователь
local currentUser

local indexBalance = 1
local balance = {
    {
        name = "Уголь"
    },
    {
        name = "Алмазы"
    },
    {
        name = "Материя"
    }
}

--Инициализация формы == Список div
mainForm = {}
local areaClickList = getAreaList()

--Функция добавления элемента в список контейнеров
function addDiv(div)
    table.insert(mainForm, div)
end

--Функция добавления элементов управления в контейнер
function addControl(div, control)
    table.insert(div.controls, control)
end

function fillMainForm()
    ---------------------
    --Основной div
    ---------------------
    local mainDiv = Div:new()
        mainDiv.width = 161
        mainDiv.height = 51
        mainDiv.colorBackground = 0x000000
        mainDiv.typeDiv = "column"
        addDiv(mainDiv)
        -----------------------
        --Содержимое mainDiv
        -----------------------
        --Верхняя часть
        local topDiv = Div:new()
        topDiv.width = 161
        topDiv.height = 42
        topDiv.typeDiv = "row"
        topDiv.nameControl = "topDiv"
        topDiv.colorBackground = 800080--0x708090

        addControl(mainDiv, topDiv)

        --Div авторизации
        local signInDiv = Div:new()
        signInDiv.width = 45
        signInDiv.height = 41
        signInDiv.colorBackground = 0x2F4F4F
        signInDiv.typeDiv = "column"
        signInDiv.nameControl = "signInDiv"
        signInDiv.margin = {-1,0,0,-1}
        signInDiv.isVisible = true

        --Кнопка авторизации
        local btnSignIn = Button:new()
        btnSignIn.nameControl = "btnSignIn"
        btnSignIn.width = 17
        btnSignIn.height = 2
        btnSignIn.padding = {2,0,1,4}
        btnSignIn.margin = {15,0,0,11}
        btnSignIn.text = "Начать игру"
        btnSignIn.isDefault = true
        btnSignIn.onClick = showInformPanel

        addControl(signInDiv, btnSignIn)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {3,0,1,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "Правила игры размещены на картине"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {0,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "Если закончились ресурсы в системе,"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {0,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "нашли ошибку или баг, обращайтесь"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {0,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "к Antonesku"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {1,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "P.S. Автор не располагает большим"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {0,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "количеством ресурсов, поэтому сильно"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {0,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "не увлекайтесь :3"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Label 
        local lbl1 = Label:new()
        lbl1.width = 40
        lbl1.height = 1
        lbl1.margin = {1,0,0,5}
        lbl1.nameControl = "lbl1"
        lbl1.text = "ЧТОБЫ НАЧАТЬ ВОЙДИТЕ И НАЖМИТЕ 'SPIN'"
        lbl1.colorBackground = signInDiv.colorBackground
        lbl1.colorForeground = 0xFFF0F5
        lbl1.isDefault = true

        addControl(signInDiv, lbl1)

        --Div панели информации
        local informDiv = Div:new()
        informDiv.width = 45
        informDiv.height = 41
        informDiv.colorBackground = 0x2F4F4F
        informDiv.typeDiv = "column"
        informDiv.nameControl = "informDiv"
        informDiv.margin = {-1,0,0,-2}
        informDiv.isVisible = false
        informDiv.padding = {0,0,0,0}

        addControl(topDiv, informDiv)
        addControl(topDiv, signInDiv)

        --Label никнейма игрока
        local nicknameLabel = Label:new()
        nicknameLabel.width = 40
        nicknameLabel.height = 2
        nicknameLabel.margin = {1,0,-1,3}
        nicknameLabel.nameControl = "nicknameLabel"
        nicknameLabel.text = "Hi, Antonesku"
        nicknameLabel.limitChars = 13
        nicknameLabel.colorBackground = informDiv.colorBackground
        nicknameLabel.colorForeground = 0xFFF0F5
        nicknameLabel.isDefault = true

        addControl(informDiv, nicknameLabel)

        --border под никнеймом
        local borderNickname = Button:new()
        borderNickname.width = 38
        borderNickname.height = 1
        borderNickname.nameControl = "borderNickname"
        borderNickname.typeButton = "braille"
        borderNickname.colorBackground = informDiv.colorBackground
        borderNickname.margin = {0,0,0,2}
        do
            local matrix = br.matrix(borderNickname.width * 2, borderNickname.height * 6)
            br.line(matrix, 1, math.floor(borderNickname.height * 6 / 2), borderNickname.width * 2, math.floor(borderNickname.height * 6 / 2))
            borderNickname.braille = matrix
        end
        borderNickname.nameControl = "borderNickname"
        borderNickname.colorForeground = 0xFFD700

        addControl(informDiv, borderNickname)

        --Div для баланса
        local balanceDiv = Div:new()
        balanceDiv.typeDiv = "row"
        balanceDiv.width = 35
        balanceDiv.height = 5
        balanceDiv.margin = {0,0,0,0}
        balanceDiv.colorBackground = informDiv.colorBackground
        balanceDiv.nameControl = "balanceDiv"

        addControl(informDiv, balanceDiv)

        --Div выбора валюты
        local balanceChoseDiv = Div:new()
        balanceChoseDiv.nameControl = "balanceChoseDiv"
        balanceChoseDiv.width = 8
        balanceChoseDiv.height = balanceDiv.height
        balanceChoseDiv.colorBackground = balanceDiv.colorBackground
        balanceChoseDiv.typeDiv = "column"

        addControl(balanceDiv, balanceChoseDiv)

        --Кнопка смены валюты "Вверх"
        local btnUpCurrency = Button:new()
        btnUpCurrency.nameControl = "btnUpCurrency"
        btnUpCurrency.width = 6
        btnUpCurrency.height = 2
        btnUpCurrency.typeButton = "braille"
        btnUpCurrency.colorBackground = balanceChoseDiv.colorBackground
        btnUpCurrency.margin = {-1,0,0,0}
        btnUpCurrency.onClick = setBalanceUp
        do
            local matrix = br.matrix(10,6)

            br.line(matrix, 5, 1, 6, 1)
            br.line(matrix, 5, 2, 6, 2)
            br.line(matrix, 3, 3, 8, 3)
            br.line(matrix, 3, 4, 8, 4)
            br.line(matrix, 1, 5, 10, 5)
            br.line(matrix, 1, 6, 10, 6)

            btnUpCurrency.braille = matrix
        end

        btnUpCurrency.colorForeground = 0xFAEBD7

        addControl(balanceChoseDiv, btnUpCurrency)


        --Картинка текущей валюты
        local currencyImage = Image:new()
        currencyImage.nameFile = "emeraldsmall"
        currencyImage.colorBackground = informDiv.colorBackground
        currencyImage.colorFrame = 0xC0C0C0
        currencyImage.margin = {0,0,0,0}
        currencyImage.nameControl = "currencyImage"

        addControl(balanceDiv, currencyImage)

        --Кнопка смены валюты "Вниз"
        local btnDownCurrency = Button:new()
        btnDownCurrency.nameControl = "btnDownCurrency"
        btnDownCurrency.width = 6
        btnDownCurrency.height = 2
        btnDownCurrency.typeButton = "braille"
        btnDownCurrency.colorBackground = balanceChoseDiv.colorBackground
        btnDownCurrency.margin = {0,0,0,0}
        btnDownCurrency.onClick = setBalanceDown
        do
            local matrix = br.matrix(10,6)

            br.line(matrix, 1, 1, 10, 1)
            br.line(matrix, 1, 2, 10, 2)
            br.line(matrix, 3, 3, 8, 3)
            br.line(matrix, 3, 4, 8, 4)
            br.line(matrix, 5, 5, 6, 5)
            br.line(matrix, 5, 6, 6, 6)

            btnDownCurrency.braille = matrix
        end

        btnDownCurrency.colorForeground = btnUpCurrency.colorForeground

        addControl(balanceChoseDiv, btnDownCurrency)

        --"Баланс"
        local balanceLabel = Label:new()
        balanceLabel.width = 23
        balanceLabel.height = 2
        balanceLabel.margin = {0,0,0,3}
        balanceLabel.nameControl = "balanceLabel"
        balanceLabel.text = "Баланс"
        balanceLabel.limitChars = 13
        balanceLabel.colorBackground = informDiv.colorBackground
        balanceLabel.colorForeground = 0xFFF0F5
        balanceLabel.isDefault = true

        addControl(balanceDiv, balanceLabel)

        --Название валюты
        local nameCurrencyLabel = Label:new()
        nameCurrencyLabel.width = 23
        nameCurrencyLabel.height = 2
        nameCurrencyLabel.margin = {1,0,0,-23}
        nameCurrencyLabel.nameControl = "nameCurrencyLabel"
        nameCurrencyLabel.text = "Эмы"
        nameCurrencyLabel.limitChars = 20
        nameCurrencyLabel.colorBackground = informDiv.colorBackground
        nameCurrencyLabel.colorForeground = 0xFFF0F5
        nameCurrencyLabel.isDefault = true

        addControl(balanceDiv, nameCurrencyLabel)

        --Текущий баланс
        local currentBalanceLabel = Label:new()
        currentBalanceLabel.width = 23
        currentBalanceLabel.height = 2
        currentBalanceLabel.margin = {2,0,0,-23}
        currentBalanceLabel.nameControl = "currentBalanceLabel"
        currentBalanceLabel.text = "1253.234"
        currentBalanceLabel.limitChars = 20
        currentBalanceLabel.colorBackground = informDiv.colorBackground
        currentBalanceLabel.colorForeground = 0xFFF0F5
        currentBalanceLabel.isDefault = true

        addControl(balanceDiv, currentBalanceLabel)

        --border под балансом
        local borderBalance = Button:new()
        borderBalance.width = 38
        borderBalance.height = 1
        borderBalance.nameControl = "borderBalance"
        borderBalance.typeButton = "braille"
        borderBalance.colorBackground = informDiv.colorBackground
        borderBalance.margin = {1,0,0,3}
        do
            local matrix = br.matrix(borderBalance.width * 2, borderBalance.height * 6)
            br.line(matrix, 1, math.floor(borderBalance.height * 6 / 2), borderBalance.width * 2, math.floor(borderBalance.height * 6 / 2))
            borderBalance.braille = matrix
        end
        borderBalance.nameControl = "borderNickname"
        borderBalance.colorForeground = 0xFFD700

        addControl(informDiv, borderBalance)
        
        --label
        local labelSum = Label:new()
        labelSum.nameControl = "labelSum"
        labelSum.width = 15
        labelSum.height = 1
        labelSum.isDefault = true
        labelSum.text = "Кол-во ресурсов"
        labelSum.colorBackground = informDiv.colorBackground
        labelSum.margin = {1,0,0,2}
        labelSum.colorForeground = 0xFFFFFF

        addControl(informDiv, labelSum)

        --Counter для вывода
        local counterOutput = Counter:new()
        counterOutput.nameControl = "counterOutput"
        counterOutput.width = 44
        counterOutput.height = 4
        counterOutput.minValue = 0
        counterOutput.value = 0
        counterOutput.maxValue = 100000
        counterOutput.step = 0
        counterOutput.colorBackground = informDiv.colorBackground
        counterOutput.margin = {0,0,0,2}
        counterOutput.backgroundColorArea = 0x483D8B
        counterOutput.colorForeground = 0xC0C0C0
        counterOutput.colorArrow = informDiv.colorBackground
        counterOutput.colorBorder = 0xE6E6FA
        counterOutput.margin = {1,0,0,-4}

        addControl(informDiv, counterOutput)

        --Panel calculate

        local panelCalculate = Div:new()
        panelCalculate.nameControl = "panelCalculate"
        panelCalculate.width = 40
        panelCalculate.height = 3
        panelCalculate.typeDiv = "row"
        panelCalculate.colorBackground = informDiv.colorBackground
        panelCalculate.margin = {1,0,2,1}
        panelCalculate.padding = {-1,0,0,0}

        addControl(informDiv, panelCalculate)

        --Кнопка +1
        local addOneBtn = Button:new()
        addOneBtn.width = 3 
        addOneBtn.height = 1
        addOneBtn.text = "+1"
        addOneBtn.padding = {1,1,1,1}
        addOneBtn.isDefault = true
        addOneBtn.nameControl = "addOneBtn"
        addOneBtn.colorFrame = 0xF0FFFF
        addOneBtn.onClick = addOne
        addOneBtn.colorBackground = 0x4682B4
        addOneBtn.colorForeground = 0xFFFFFF

        addControl(panelCalculate, addOneBtn)

        --Кнопка +10
        local addTenBtn = Button:new()
        addTenBtn.width = 3 
        addTenBtn.height = 1
        addTenBtn.text = "+10"
        addTenBtn.padding = {1,1,1,1}
        addTenBtn.isDefault = true
        addTenBtn.nameControl = "addTenBtn"
        addTenBtn.colorFrame = addOneBtn.colorFrame
        addTenBtn.margin = {0,0,0,0}
        addTenBtn.onClick = addTen
        addTenBtn.colorBackground = 0x4682B4
        addTenBtn.colorForeground = addOneBtn.colorForeground

        addControl(panelCalculate, addTenBtn)

        --Кнопка +100
        local addHundredBtn = Button:new()
        addHundredBtn.width = 3 
        addHundredBtn.height = 1
        addHundredBtn.text = "+100"
        addHundredBtn.padding = {1,2,1,1}
        addHundredBtn.isDefault = true
        addHundredBtn.nameControl = "addHundredBtn"
        addHundredBtn.colorFrame = addOneBtn.colorFrame
        addHundredBtn.margin = {0,0,0,1}
        addHundredBtn.onClick = addHundred
        addHundredBtn.colorBackground = 0x4682B4
        addHundredBtn.colorForeground = addOneBtn.colorForeground
        

        addControl(panelCalculate, addHundredBtn)

        --Кнопка -1
        local minusOneBtn = Button:new()
        minusOneBtn.width = 3 
        minusOneBtn.height = 1
        minusOneBtn.text = "-1"
        minusOneBtn.padding = {1,1,1,1}
        minusOneBtn.isDefault = true
        minusOneBtn.nameControl = "minusOneBtn"
        minusOneBtn.colorFrame = addOneBtn.colorFrame
        minusOneBtn.margin = {0,0,0,2}
        minusOneBtn.onClick = minusOne
        minusOneBtn.colorBackground = 0x4682B4
        minusOneBtn.colorForeground = addOneBtn.colorForeground
        

        addControl(panelCalculate, minusOneBtn)

        --Кнопка -10
        local minusTenBtn = Button:new()
        minusTenBtn.width = 3 
        minusTenBtn.height = 1
        minusTenBtn.text = "-10"
        minusTenBtn.padding = {1,1,1,1}
        minusTenBtn.isDefault = true
        minusTenBtn.nameControl = "minusTenBtn"
        minusTenBtn.colorFrame = addOneBtn.colorFrame
        minusTenBtn.margin = {0,0,0,1}
        minusTenBtn.onClick = minusTen
        minusTenBtn.colorBackground = 0x4682B4
        minusTenBtn.colorForeground = addOneBtn.colorForeground

        addControl(panelCalculate, minusTenBtn)

        --Кнопка -100
        local minusHundredBtn = Button:new()
        minusHundredBtn.width = 3 
        minusHundredBtn.height = 1
        minusHundredBtn.text = "-100"
        minusHundredBtn.padding = {1,2,1,1}
        minusHundredBtn.isDefault = true
        minusHundredBtn.nameControl = "minusHundredBtn"
        minusHundredBtn.colorFrame = addOneBtn.colorFrame
        minusHundredBtn.margin = {0,0,0,1}
        minusHundredBtn.onClick = minusHundred
        minusHundredBtn.colorBackground = 0x4682B4
        minusHundredBtn.colorForeground = addOneBtn.colorForeground

        addControl(panelCalculate, minusHundredBtn)

        --border под counter balance
        local borderCounterBalance = Button:new()
        borderCounterBalance.width = 38
        borderCounterBalance.height = 1
        borderCounterBalance.nameControl = "borderCounterBalance"
        borderCounterBalance.typeButton = "braille"
        borderCounterBalance.colorBackground = informDiv.colorBackground
        borderCounterBalance.margin = {0,0,0,3}
        do
            local matrix = br.matrix(borderCounterBalance.width * 2, borderCounterBalance.height * 6)
            br.line(matrix, 1, math.floor(borderCounterBalance.height * 6 / 2), borderCounterBalance.width * 2, math.floor(borderCounterBalance.height * 6 / 2))
            borderCounterBalance.braille = matrix
        end
        borderCounterBalance.nameControl = "borderCounterBalance"
        borderCounterBalance.colorForeground = 0xFFD700

        addControl(informDiv, borderCounterBalance)

        --Div output/input
        local divManipulation = Div:new()
        divManipulation.nameControl = "divManipulation"
        divManipulation.width = 40
        divManipulation.height = 3
        divManipulation.typeDiv = "row"
        divManipulation.colorBackground = informDiv.colorBackground
        divManipulation.margin = {1,0,2,1}
        divManipulation.padding = {-1,0,0,0}

        addControl(informDiv, divManipulation)

        --Кнопка пополнения
        local buttonInput = Button:new()
        buttonInput.nameControl = "buttonInput"
        buttonInput.width = 15
        buttonInput.height = 1
        buttonInput.text = "Пополнить"
        buttonInput.colorBackground = 0xA52A2A
        buttonInput.colorForeground = 0xFFFFFF
        buttonInput.margin = {1,7,0,0}
        buttonInput.padding = {1,0,1,1}
        buttonInput.colorFrame = 0xC0C0C0
        buttonInput.isDefault = true
        buttonInput.onClick = addBalance

        addControl(divManipulation, buttonInput)

        --Кнопка вывода
        local buttonOutput = Button:new()
        buttonOutput.nameControl = "buttonOutput"
        buttonOutput.width = 15
        buttonOutput.height = 1
        buttonOutput.text = "Вывести"
        buttonOutput.colorBackground = 0xA52A2A
        buttonOutput.colorForeground = 0xFFFFFF
        buttonOutput.margin = {1,0,0,0}
        buttonOutput.padding = {1,0,1,1}
        buttonOutput.colorFrame = 0xC0C0C0
        buttonOutput.isDefault = true
        buttonOutput.onClick = outBalance

        addControl(divManipulation, buttonOutput)

        --border информационной панели
        local borderInform = Button:new()
        borderInform.width = 1
        borderInform.height = 41
        borderInform.nameControl = "borderInform"
        borderInform.typeButton = "braille"
        borderInform.colorBackground = 0xA0522D
        borderInform.margin = {-1,0,0,0}
        do
            local matrix = br.matrix(borderInform.width * 2, borderInform.height * 4)
            br.line(matrix, 1, 1, 1, borderInform.height * 4)
            br.line(matrix, 2, 1, 2, borderInform.height * 4)
            borderInform.braille = matrix
        end
        borderInform.nameControl = "borderInform"
        borderInform.colorForeground = 0xDCDCDC

        addControl(topDiv, borderInform)

        --border нижней панели
        local borderFooter = Button:new()
        borderFooter.width = 161
        borderFooter.height = 1
        borderFooter.nameControl = "borderFooter"
        borderFooter.typeButton = "braille"
        borderFooter.colorBackground = 0x778899
        borderFooter.margin = {-1,0,0,-1}
        do
            local matrix = br.matrix(borderFooter.width * 2, borderFooter.height * 4)
            br.line(matrix, 1, 1, borderFooter.width * 2, 1)
            br.line(matrix, 1, 2, borderFooter.width * 2, 2)
            borderFooter.braille = matrix
        end
        borderFooter.nameControl = "borderFooter"
        borderFooter.colorForeground = 0xDCDCDC

        --------------------------------
        --Нижняя часть
        --------------------------------
        local footerDiv = Div:new()
        footerDiv.nameControl = "footerDiv"
        footerDiv.width = 161
        footerDiv.height = 29
        footerDiv.typeDiv = "row"
        footerDiv.colorBackground = 0x6A5ACD

        borderFooter.colorBackground = footerDiv.colorBackground
        addControl(mainDiv, borderFooter)

        addControl(mainDiv, footerDiv)

        --Div для линий
        local footerLinesDiv = Div:new()
        footerLinesDiv.nameControl = "footerLinesDiv"
        footerLinesDiv.width = 28
        footerLinesDiv.height = 4
        footerLinesDiv.typeDiv = "column"
        footerLinesDiv.colorBackground = footerDiv.colorBackground
        footerLinesDiv.margin = {0,0,0,6}

        addControl(footerDiv, footerLinesDiv)

        --Label "Линии"
        local labelCountLines = Label:new()
        labelCountLines.width = 28
        labelCountLines.height = 1
        labelCountLines.margin = {-1,0,0,6}
        labelCountLines.nameControl = "labelCountLines"
        labelCountLines.text = "Линии"
        labelCountLines.limitChars = 13
        labelCountLines.colorBackground = footerLinesDiv.colorBackground
        labelCountLines.colorForeground = 0xFFF0F5
        labelCountLines.isDefault = true

        addControl(footerLinesDiv, labelCountLines)

        --Counter для линий
        local counterLines = Counter:new()
        counterLines.nameControl = "counterLines"
        counterLines.width = 16
        counterLines.height = 4
        counterLines.minValue = 1
        counterLines.value = 1
        counterLines.maxValue = 20
        counterLines.step = 1
        counterLines.colorBackground = footerLinesDiv.colorBackground
        counterLines.margin = {1,0,0,0}
        counterLines.backgroundColorArea = 0x9400D3
        counterLines.colorForeground = 0xC0C0C0
        counterLines.colorArrow = 0xE6E6FA
        counterLines.colorBorder = 0xFDF5E6
        counterLines.onChange = calculateBet

        addControl(footerLinesDiv, counterLines)

        --Div для Ставки
        local footerBetDiv = Div:new()
        footerBetDiv.nameControl = "footerBetDiv"
        footerBetDiv.width = 30
        footerBetDiv.height = 29
        footerBetDiv.typeDiv = "column"
        footerBetDiv.colorBackground = footerDiv.colorBackground
        footerBetDiv.margin = {-1,0,0,0}

        addControl(footerDiv, footerBetDiv)

        --Label "Ставка"
        local labelBet = Label:new()
        labelBet.width = 28
        labelBet.height = 2
        labelBet.margin = {0,0,0,6}
        labelBet.nameControl = "labelBet"
        labelBet.text = "Ставка"
        labelBet.limitChars = 13
        labelBet.colorBackground = footerLinesDiv.colorBackground
        labelBet.colorForeground = 0xFFF0F5
        labelBet.isDefault = true

        addControl(footerBetDiv, labelBet)

        --Counter для ставок
        local counterBet = Counter:new()
        counterBet.nameControl = "counterBet"
        counterBet.width = 23
        counterBet.height = 4
        counterBet.value = 0.01
        counterBet.minValue = 0.01
        counterBet.colorBackground = footerBetDiv.colorBackground
        counterBet.margin = {0,0,0,0}
        counterBet.backgroundColorArea = counterLines.backgroundColorArea
        counterBet.colorForeground = 0xC0C0C0
        counterBet.colorArrow = 0xE6E6FA
        counterBet.colorBorder = counterLines.colorBorder
        counterBet.values = {0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1}
        counterBet.onChange = calculateBet

        addControl(footerBetDiv, counterBet)

        --Div для Общей ставки
        local footerTotalBet = Div:new()
        footerTotalBet.nameControl = "footerTotalBet"
        footerTotalBet.width = 30
        footerTotalBet.height = 29
        footerTotalBet.typeDiv = "column"
        footerTotalBet.colorBackground = footerDiv.colorBackground
        footerTotalBet.margin = {-1,0,0,10}

        addControl(footerDiv, footerTotalBet)

        --Label "Общая Ставка"
        local labelTotalBet = Label:new()
        labelTotalBet.width = 15
        labelTotalBet.height = 2
        labelTotalBet.margin = {0,0,0,0}
        labelTotalBet.nameControl = "labelTotalBet"
        labelTotalBet.text = "Общая ставка"
        labelTotalBet.colorBackground = footerLinesDiv.colorBackground
        labelTotalBet.colorForeground = 0xFFF0F5
        labelTotalBet.isDefault = true

        addControl(footerTotalBet, labelTotalBet)

        --Label число общей ставки
        local labelTotalBetCount = Label:new()
        labelTotalBetCount.width = 15
        labelTotalBetCount.height = 2
        labelTotalBetCount.margin = {1,0,0,0}
        labelTotalBetCount.nameControl = "labelTotalBetCount"
        labelTotalBetCount.text = "0.01"
        labelTotalBetCount.limitChars = 13
        labelTotalBetCount.colorBackground = footerLinesDiv.colorBackground
        labelTotalBetCount.colorForeground = 0xFFF0F5
        labelTotalBetCount.isDefault = false

        addControl(footerTotalBet, labelTotalBetCount)

        --Div для выигрыша
        local winningDiv = Div:new()
        winningDiv.nameControl = "winningDiv"
        winningDiv.width = 30
        winningDiv.height = 29
        winningDiv.typeDiv = "column"
        winningDiv.colorBackground = footerDiv.colorBackground
        winningDiv.margin = {-1,0,0,0}

        addControl(footerDiv, winningDiv)

        --Label "Выигрыш"
        local labelWinning = Label:new()
        labelWinning.width = 15
        labelWinning.height = 2
        labelWinning.margin = {0,0,0,0}
        labelWinning.nameControl = "labelWinning"
        labelWinning.text = "Выигрыш"
        labelWinning.colorBackground = footerLinesDiv.colorBackground
        labelWinning.colorForeground = 0xFFF0F5
        labelWinning.isDefault = true

        addControl(winningDiv, labelWinning)

        --Label число выигрыша
        local countWinning = Label:new()
        countWinning.width = 15
        countWinning.height = 2
        countWinning.margin = {1,0,0,0}
        countWinning.nameControl = "countWinning"
        countWinning.text = "0"
        countWinning.limitChars = 7
        countWinning.colorBackground = footerLinesDiv.colorBackground
        countWinning.colorForeground = 0xFFF0F5
        countWinning.isDefault = false

        addControl(winningDiv, countWinning)

        --Div для слотов
        local slotsDiv = Div:new()
        slotsDiv.width = 115
        slotsDiv.height = 41
        slotsDiv.nameControl = "slotsDiv"
        slotsDiv.typeDiv = "row"
        slotsDiv.colorBackground = 800080
        slotsDiv.margin = {1, 0, 0, 1}

        addControl(topDiv, slotsDiv)

        --Div для столбца слотов
        local columnSlotsDiv = Div:new()
        columnSlotsDiv.width = 21
        columnSlotsDiv.height = 30
        columnSlotsDiv.nameControl = "columnSlotsDiv"
        columnSlotsDiv.typeDiv = "column"
        columnSlotsDiv.colorBackground = slotsDiv.colorBackground
        columnSlotsDiv.padding = {0,0,0,-2}
        columnSlotsDiv.margin = {-1,4,0,0}

        addControl(slotsDiv, columnSlotsDiv)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Div для столбца слотов
        local columnSlotsDiv = Div:new()
        columnSlotsDiv.width = 25
        columnSlotsDiv.height = 30
        columnSlotsDiv.nameControl = "columnSlotsDiv"
        columnSlotsDiv.typeDiv = "column"
        columnSlotsDiv.colorBackground = slotsDiv.colorBackground
        columnSlotsDiv.padding = {0,0,0,-2}
        columnSlotsDiv.margin = {-1,0,0,0}

        addControl(slotsDiv, columnSlotsDiv)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Div для столбца слотов
        local columnSlotsDiv = Div:new()
        columnSlotsDiv.width = 25
        columnSlotsDiv.height = 30
        columnSlotsDiv.nameControl = "columnSlotsDiv"
        columnSlotsDiv.typeDiv = "column"
        columnSlotsDiv.colorBackground = slotsDiv.colorBackground
        columnSlotsDiv.padding = {0,0,0,-2}
        columnSlotsDiv.margin = {-1,0,0,0}

        addControl(slotsDiv, columnSlotsDiv)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Div для столбца слотов
        local columnSlotsDiv = Div:new()
        columnSlotsDiv.width = 25
        columnSlotsDiv.height = 30
        columnSlotsDiv.nameControl = "columnSlotsDiv"
        columnSlotsDiv.typeDiv = "column"
        columnSlotsDiv.colorBackground = slotsDiv.colorBackground
        columnSlotsDiv.padding = {0,0,0,-2}
        columnSlotsDiv.margin = {-1,0,0,0}

        addControl(slotsDiv, columnSlotsDiv)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Div для столбца слотов
        local columnSlotsDiv = Div:new()
        columnSlotsDiv.width = 25
        columnSlotsDiv.height = 30
        columnSlotsDiv.nameControl = "columnSlotsDiv"
        columnSlotsDiv.typeDiv = "column"
        columnSlotsDiv.colorBackground = slotsDiv.colorBackground
        columnSlotsDiv.padding = {0,0,0,-2}
        columnSlotsDiv.margin = {-1,0,0,0}

        addControl(slotsDiv, columnSlotsDiv)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --Изображение слота
        local slotImage = Image:new()
        slotImage.nameControl = "slotImage"
        slotImage.nameFile = "glowstone"
        slotImage.margin =  {0, 0, 3, 2}
        slotImage.colorBackground = slotsDiv.colorBackground
        slotImage.colorFrame = nil

        addControl(columnSlotsDiv, slotImage)

        --error label
        local labelError = Label:new()
        labelError.nameControl = "labelError"
        labelError.height = 1
        labelError.width = 115
        labelError.text = ""
        labelError.colorForeground = 0xFF0000
        labelError.colorBackground = slotsDiv.colorBackground
        labelError.isDefault = true
        labelError.margin = {37, 0, 0, -114}

        addControl(topDiv, labelError)

        --Изображение Кнопки
        local spinImage = Image:new()
        spinImage.nameControl = "slotImage"
        spinImage.nameFile = "spin"
        spinImage.width = 15
        spinImage.height = 5
        spinImage.colorBackground = slotsDiv.colorBackground
        spinImage.colorFrame = nil
        spinImage.margin = {1,0,0,0}
        spinImage.colorForeground = 0xC0C0C0
        spinImage.colorBackground = footerDiv.colorBackground
        spinImage.onClick = spin

        addControl(footerDiv, spinImage)
end



getControl = function(nameControl, div)
    local control
    if div == nil then
        div = mainForm[1]
    end

    for i = 1, #div.controls do
        local currentControl = div.controls[i]

        if currentControl.nameControl == nameControl then
            control = currentControl
            break
        end

        if currentControl.typeControl == "div" then
            control = getControl(nameControl, currentControl)
            if control ~= nil then
                break
            end
        end
    end

    return control
end

function getParent(control)
    local parent
    for i = 1, #mainForm do
        for k, v in pairs(mainForm[i].controls) do
            local currentControl = v
            if currentControl.nameControl == control.nameControl then
                parent = mainForm[i]
                break
            end
        end
    end

    return parent
end

function getCalcuteCoords(control)
    local height, width
    height = control.coords[2] + control.height + control.padding[1] + control.padding[3]
    width = control.coords[1] + control.width + control.padding[2] + control.padding[4]

    if control.text ~= nil then
        height = height + 1
    end

    local x2 = control.coords[1] + width
    local y2 = control.coords[2] + height

    return {control.coords[1], control.coords[2], x2, y2}
end

function getResetCoords(control)
    return{control.coords[1], control.coords[2],control.coords[1], control.coords[2]}
end

function refreshControl(control)
    for i = 1, #mainForm do
        for j = 1, #mainForm[i].controls do
            local currentControl = mainForm[i].controls[j]
            if currentControl.nameControl == control.nameControl then
                mainForm[i].controls[j] = control
                break
            end
        end
    end

end

--Удалить область нажатия
function removeAreaClick(control)
    for i = 1, #areaClickList do
        areaClick = areaClickList[i]

        if areaClick.nameControl == control.nameControl then
            table.remove(areaClickList, i)
            break
        end
    end
end

function setTimer(isNotExists)
    local second = 128
    if isNotExists then
        timer = event.timer(second, resetTimer)
        return
    end

    if timer ~= nil then
        event.cancel(timer)
        timer = event.timer(second, resetTimer)
    end
end

function setSleep(second)
    os.sleep(second)
end

--Обработка нажатий
function clickPerform()
    while true do
        local _, _, x, y, _, nick = event.pull("touch", _, _, _, _, nicknameUser)
        clearMsg()
        nicknameTap = nick

        if timer ~= nil then
            setTimer()
        end
        --gpu.setForeground(0xFFFFFF)
        --gpu.setBackground(0x000000)

        matchCoord(x, y)
    end
end

--Сравнить
function matchCoord(x, y)
    if areaClickList ~= nil then
        for i = 1,#areaClickList do
            local areaClick = areaClickList[i]

            if x >= areaClick.coords[1] and x <= areaClick.coords[3] - 1  and
                y >= areaClick.coords[2] and y <= areaClick.coords[4] - 1 then
                areaClick.func()
                break
            end
        end
    end
end

function showInformPanel()
    nicknameUser = nicknameTap
    currentUser = db.getUser(nicknameUser)

    local nicknameLabel = getControl("nicknameLabel")
    nicknameLabel.text = "Hi, "..currentUser.nickname

    local informPanel = getControl("informDiv")
    local signInDiv = getControl("signInDiv")
    signInDiv.isVisible = false

    informPanel.isVisible = true
    informPanel.coords = signInDiv.coords
    informPanel.coords[1] = informPanel.coords[1] + 1
    informPanel.width = informPanel.width - 1

    local balanceDiv = getControl("balanceDiv")

    setBalance()
    
    drawDiv(informPanel)
    drawDiv(signInDiv)

    if timer ~= nil then
        setTimer()
    else
        setTimer(true)
    end
end

function clearMsg()
    local errorLabel = getControl("labelError")
    errorLabel.text = ""

    drawLabel(errorLabel)
end

function showErrow(errorMsg)
    local errorLabel = getControl("labelError")
    errorLabel.colorForeground = 0xFF0000
    errorLabel.text = errorMsg

    drawLabel(errorLabel)
end

function showResult(msg)
    
    local errorLabel = getControl("labelError")
    errorLabel.colorForeground = 0x7CFC00
    errorLabel.text = msg

    drawLabel(errorLabel)
end

function changeCounterOutputValue(count)
    local counter = getControl("counterOutput")
    
    if count >= 0 then
        counter.value = counter.value + count
        drawCounter(counter)
        return
    else
        if counter.value + count >= 0 then
            counter.value = counter.value + count
            drawCounter(counter)
            return
        end
    end
end

function addOne()
    changeCounterOutputValue(1)
end

function addTen()
    changeCounterOutputValue(10)
end

function addHundred()
    changeCounterOutputValue(100)
end

function minusOne()
    changeCounterOutputValue(-1)
end

function minusTen()
    changeCounterOutputValue(-10)
end

function minusHundred()
    changeCounterOutputValue(-100)
end

function setBalance()
    local nameCurrency = getControl("nameCurrencyLabel")
    local balanceCount = getControl("currentBalanceLabel")
    local currencyImage = getControl("currencyImage")
    local balanceDiv = getControl("balanceDiv")
    local count = 0

    if indexBalance > #balance then
        indexBalance = 1
    else
        if indexBalance < 1 then
            indexBalance = #balance
        else
            indexBalance = indexBalance
        end
    end

    nameCurrency.text = balance[indexBalance].name
    if indexBalance == 1 then
        count = db.getCoalCount(currentUser)
        currencyImage.nameFile = "coalsmall"
    elseif indexBalance == 2 then
        currencyImage.nameFile = "diamondsmall"
        count = db.getDiamondCount(currentUser)
    elseif indexBalance == 3 then
        currencyImage.nameFile = "mattersmall"
        count = db.getMatterCount(currentUser)
    end

    local count, ost = math.modf(count)
    if ost == 0 then
        balanceCount.text = tostring(count)
    else
        balanceCount.text = tostring(count) .. "." .. tostring(ost):sub(3,4)
    end
    

    drawDiv(balanceDiv)

end

function setBalanceUp()
    indexBalance = indexBalance + 1
    setBalance()
end

function setBalanceDown()
    indexBalance = indexBalance - 1
    setBalance()
end

function resetTimer()
    nicknameUser = nil
    currentUser = nil

    local informPanel = getControl("informDiv")
    local signInDiv = getControl("signInDiv")
    signInDiv.isVisible = true
    signInDiv.coords = getCalcuteCoords(signInDiv)

    informPanel.isVisible = false
    informPanel.coords = getResetCoords(informPanel)
    timer = nil
    clearMsg()
    drawForm(mainForm)
    
end

local function spinColumnSlots(columnDiv, times, columnNumber, matrixNamesSlots)
    if timer ~= 0 then
        for i = 1, times do
            local nameF, _ = math.modf(math.random(1,4))

            columnDiv.controls[1].nameFile = tostring(nameF)
            columnDiv.controls[2].isVisible = false
            columnDiv.controls[3].isVisible = false

            drawDiv(columnDiv)
            setSleep(0.000000001)
        end
    end

    for j = 1, 3 do
        columnDiv.controls[j].nameFile = matrixNamesSlots[columnNumber][j]
        columnDiv.controls[j].isVisible = true
        columnDiv.controls[j].colorFrame = nil
    end

    drawDiv(columnDiv)
end

function spin()
    if currentUser == nil then
        showErrow("Пожалуйста, войдите в аккаунт!")
        return
    end
    local bet = getControl("counterBet").value
    local totalBet = tonumber(getControl("labelTotalBetCount").text)
    local lines = getControl("counterLines").value
    local winningLabel = getControl("countWinning")
    local slotsDiv = getControl("slotsDiv")
    local matrixNamesSlots, winLinesCoords, winning = sG.start(bet,lines)
    local balance = tonumber(getControl("currentBalanceLabel").text)
    local balnceLabel = getControl("currentBalanceLabel")

    if balance < totalBet then
        showErrow("Недостаточно ресурсов на счету!")
        return
    else
        if indexBalance == 1 then --Уголь
            db.removeCoal(currentUser, totalBet)
        elseif indexBalance == 2 then --Алмазы
            db.removeDiamond(currentUser, totalBet)
        elseif indexBalance == 3 then --Материя
            db.removeMatter(currentUser, totalBet)
        end
    
        setBalance()
    end

    local t1 = thread.create(spinColumnSlots, slotsDiv.controls[1], 0, 1, matrixNamesSlots)
    local t2 = thread.create(spinColumnSlots, slotsDiv.controls[2], 1, 2, matrixNamesSlots)
    local t3 = thread.create(spinColumnSlots, slotsDiv.controls[3], 1, 3, matrixNamesSlots)
    local t4 = thread.create(spinColumnSlots, slotsDiv.controls[4], 2, 4, matrixNamesSlots)
    local t5 = thread.create(spinColumnSlots, slotsDiv.controls[5], 2, 5, matrixNamesSlots)

    thread.waitForAll({t1,t2,t3,t4,t5})

    if winning > 0 then
        if indexBalance == 1 then --Уголь
            db.addCoal(currentUser, winning)
        elseif indexBalance == 2 then --Алмазы
            db.addDiamond(currentUser, winning)
        elseif indexBalance == 3 then --Материя
            db.addMatter(currentUser, winning)
        end
    
        setBalance()
    end

    winningLabel.text = tostring(winning)
    drawLabel(winningLabel)

    if winLinesCoords ~= nil then
        setSleep(0.3)

        for i = 1, #winLinesCoords do

            for j = 1, #winLinesCoords[i] do
                local columnNumber, rowNumber = winLinesCoords[i][j][1], winLinesCoords[i][j][2]

                slotsDiv.controls[columnNumber].controls[rowNumber].colorFrame = 0xFF4500

                local x, y = slotsDiv.controls[columnNumber].controls[rowNumber].coords[1], slotsDiv.controls[columnNumber].controls[rowNumber].coords[2]
                drawImage(slotsDiv.controls[columnNumber].controls[rowNumber], x + 1, y + 1)
            end

            setSleep(1)

            for j = 1, #winLinesCoords[i] do
                local columnNumber, rowNumber = winLinesCoords[i][j][1], winLinesCoords[i][j][2]

                slotsDiv.controls[columnNumber].controls[rowNumber].colorFrame = nil
                slotsDiv.controls[columnNumber].controls[rowNumber]:removeFrame()
            end
        end
    end
end

--Пополнение баланса
function addBalance()
    local counterOutput = getControl("counterOutput")
    local count = counterOutput.value
    local addingCount, remains, errorMsg

    if count == 0 then
        return
    end

    if indexBalance == 1 then --Уголь
        addingCount, remains, errorMsg = tF.transferIn("minecraft:coal", count)

        if addingCount > 0 then
            db.addCoal(currentUser, addingCount)
        end
    elseif indexBalance == 2 then --Алмазы
        addingCount, remains, errorMsg = tF.transferIn("minecraft:diamond", count)

        if addingCount > 0 then
            db.addDiamond(currentUser, addingCount)
        end
    elseif indexBalance == 3 then --Материя
        addingCount, remains, errorMsg = tF.transferIn("ic2:misc_resource", count)

        if addingCount > 0 then
            db.addMatter(currentUser, addingCount)
        end
    end

    setBalance()

    if errorMsg ~= nil then
        if addingCount > 0 then
            showErrow(errorMsg .. "! Добавлено: " .. tostring(addingCount))
        else
            showErrow(errorMsg)
        end
        
        return
    else
        showResult("Успешно добавлено: " .. tostring(addingCount))
    end

    setSleep(1)
end

--Вывод средств
function outBalance()
    local counterOutput = getControl("counterOutput")
    local count = counterOutput.value
    local addingCount, remains, errorMsg
    local balanceCount = getControl("currentBalanceLabel")

    if count > tonumber(balanceCount.text) then
        showErrow("Недостаточно ресурсов на балансе!")
        return
    end

    if indexBalance == 1 then --Уголь
        addingCount, remains, errorMsg = tF.transferOut("minecraft:coal", count)

        if addingCount > 0 then
            db.removeCoal(currentUser, addingCount)
        end
    elseif indexBalance == 2 then --Алмазы
        addingCount, remains, errorMsg = tF.transferOut("minecraft:diamond", count)

        if addingCount > 0 then
            db.removeDiamond(currentUser, addingCount)
        end
    elseif indexBalance == 3 then --Материя
        addingCount, remains, errorMsg = tF.transferOut("ic2:misc_resource", count)

        if addingCount > 0 then
            db.removeMatter(currentUser, addingCount)
        end
    end

    setBalance()

    if addingCount == count then
        showResult("Успешно выведено!")
        setSleep(1)
        return
    end

    if errorMsg ~= nil then
        if addingCount > 0 then
            showErrow(errorMsg .. " Выведено: " .. tostring(addingCount))
        else
            showErrow(errorMsg)
        end
        return
    else
        showResult("Успешно выведено!")
    end

    setSleep(1)

end

--Расчет ставки
function calculateBet()
    local labelTotalBetCount = getControl("labelTotalBetCount")
    local counterBet = getControl("counterBet")
    local counterLines = getControl("counterLines")

    local lines = counterLines.value
    local bet = counterBet.value
    local totalBet = bet * lines

    labelTotalBetCount.text = tostring(totalBet)

    drawLabel(labelTotalBetCount)
end

--Инициализация
fillMainForm()
