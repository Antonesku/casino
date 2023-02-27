require("gui/gui")
local detect = require("detect")

----------------------------------
--Не знаю, как ты сюда попал, но даже не пытайся понять, что здесь написано
--Или ты сумасшедший?
----------------------------------

--Подключение форм
require ("forms/mainform")

clearScreen()

--Отрисовка основной формы
drawForm(mainForm)

--Добавление в пользователи ПК
detect.onDetect()

--detectOn()

--Обработка нажатий
clickPerform()




