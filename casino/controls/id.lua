--Присвоение id элементам
local idControl = 0

--Функция присвоения id
function initId()
    idControl = idControl + 1
    return (idControl - 1)
end
