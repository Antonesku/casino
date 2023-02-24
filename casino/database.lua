local component = require("component")

local database = {}

--Компонент БД
local dbCmp
    do
        local components = component.list("filesystem")

        for k,v in pairs(components) do
            local cmp = component.proxy(k)

            if (cmp.spaceTotal() > 10000000) then
                dbCmp = cmp
                break
            end
        end

        if dbCmp == nil then
            print("Не подключен RAID")
        end
    end

--База данных пользователей
local dbUsers = {}


--Список аккаунтов
local accauntList

local function removeSymblosFromString(str, symbols)
    for i = 1, #str do
        for j = 1, #symbols do
            if str:sub(i,i) == symbols[j] then
                if i == 1 then 
                    str = str:sub(2,#str)
                else
                    str = str:sub(1, i) .. str:sub(i + 1, #str)
                end
                break
            end
        end
    end

    return str
end

local function getLenghtTable(tbl)
    local lenght = 0
    for k, v in pairs(tbl) do
        lenght = lenght + 1
    end

    return lenght
end

local function getItemTable(tbl, index)
    local lenght = getLenghtTable(tbl)
    local counter = 0

    for k, v in pairs(tbl) do
        counter = counter + 1

        if counter == index then
            return k, v
        end
    end

    return nil
end

local function getLastItemTable(tbl)
    local lenght = getLenghtTable(tbl)
    local counter = 0

    for k, v in pairs(tbl) do
        counter = counter + 1

        if counter == lenght then
            return k, v
        end
    end

    return nil
end

local function convertTableToSting(tbl)
    local count = 0
    local lenght = getLenghtTable(tbl)
    local str = "{"
    
    for k, v in pairs(tbl) do
        count = count + 1

        str = str .. tostring(k) .. "="
        local value = v
        if type(value) == "table" then
            value = convertTableToSting(value)
        end

        str = str .. tostring(value)

        if count ~= lenght then
            str = str .. ","
        end
    end
    str = str .. "}"

    return str
end

local function split(str, sep)
    local result = {}
    for currentStr in str:gmatch("([^"..sep.."]+)") do
        table.insert(result, currentStr)
    end

    return result
end

local function getFirstArray(str)
    local result
    local countOpen, countClose = 0, 0

    for i = 1, #str do
        local currentChar = str:sub(i, i)

        if currentChar == "{" then
            countOpen = countOpen + 1
        end

        if currentChar == "}" then
            countClose = countClose + 1
        end

        if countOpen == countClose then
            result = str:sub(2, i - 1)
            break
        end
    end

    return result
end

local function typeConversionValue(value)
    if tonumber(value) ~= nil then
        value = tonumber(value)
    end

    if value == "true" then
        value = true
    end

    if value == "false" then
        value = false 
    end

    return value
end

local function typeConversionKey(key)
    key = removeSymblosFromString(key, {",","{"})

    if tonumber(key) ~= nil then
        key = tonumber(key)
    end

    return key
end

local function convertStringToTable(str)
    local tbl = {}

    while #str ~= 0 do
        local key
        local charAfterEqual
        local value

        if str:find("(=+)") ~= nil then
            key = str:sub(1, str:find("(=+)") - 1)
            charAfterEqual =str:sub(#key + 2, #key + 2)
            --print("DDDD", key, charAfterEqual)
        else
            break
        end

        if charAfterEqual == "{" then
            str = str:sub(#key + 2, #str)
            --print("inpt", str)
            local tblStr = getFirstArray(str)

            --print("tblADD:", key)
            
            tbl[typeConversionKey(key)] = convertStringToTable(tblStr)
            str = str:sub(#tblStr + 4, #str)
            --print("k", tblStr)
        else
            --print("inpt", str)
            local endPosValue
            if str:find("(,+)") ~= nil then
                endPosValue = str:find("(,+)")
            else
                endPosValue = #str + 1
            end

            value = str:sub(#key + 2, endPosValue - 1)
            value = typeConversionValue(value)

            --print("varADD:", key, " - ", value)
            tbl[typeConversionKey(key)] = value
            str = str:sub(endPosValue + 1, #str)
            --print("cunc", str)
        end
    end

    return tbl
end

local function initDbUsers()
    local file = dbCmp.open("dbUsers", "r")
    local fileSize = dbCmp.size("dbUsers")

    local str = dbCmp.read(file, fileSize)

    dbUsers = convertStringToTable(str)

    dbCmp.close(file)
end

--Подключиться к файлу БД
local connect = function()
    if dbCmp.exists("dbUsers") ~= true then
        local file = dbCmp.open("dbUsers", "ab")
        dbCmp.write(file,"")
        dbCmp.close(file)
    end

    initDbUsers()
end

local function isUserExist(nickname)

end

--Добавить пользователя
local function addUser(nickname)
    local user = {
        nickname = nickname,
        balance = {
            countDiamond = 0,
            countEm = 0,
            countCoal = 0,
            countMatter =0
        }
    }

    table.insert(dbUsers, user)

    local file = dbCmp.open("dbUsers", "w")
    local strTable = convertTableToSting(dbUsers)

    dbCmp.write(file, strTable)
    dbCmp.close(file)

    return user
end

database.getUser = function(nickname)
    local isFinding = false
    local user
    for i = 1, #dbUsers do
        local currentUser = dbUsers[i]
        if currentUser.nickname == nickname then
            isFinding = true
            user = currentUser
            break
        end
    end

    if isFinding ~= true then
        user = addUser(nickname)
    end

    return user
end

database.refreshBalance = function(user)
    local isFinding = false
    for i = 1, #dbUsers do
        local currentUser = dbUsers[i]
        if currentUser.nickname == user.nickname then
            isFinding = true
            dbUsers[i] = user
            break
        end
    end

    if isFinding then
        local file = dbCmp.open("dbUsers", "w")
        local strTable = convertTableToSting(dbUsers)

        dbCmp.write(file, strTable)
        dbCmp.close(file)
    end
end

database.addCoal = function(user, count)
    user.balance.countCoal = user.balance.countCoal + count
    database.refreshBalance(user) 
end

database.addDiamond = function(user, count)
    user.balance.countDiamond = user.balance.countDiamond + count
    database.refreshBalance(user) 
end

database.addMatter = function(user, count)
    user.balance.countMatter = user.balance.countMatter + count
    database.refreshBalance(user) 
end

database.removeCoal = function(user, count)
    user.balance.countCoal = user.balance.countCoal - count
    database.refreshBalance(user) 
end

database.removeDiamond = function(user, count)
    user.balance.countDiamond = user.balance.countDiamond - count
    database.refreshBalance(user) 
end

database.removeMatter = function(user, count)
    user.balance.countMatter = user.balance.countMatter - count
    database.refreshBalance(user) 
end


database.getCoalCount = function(user)
    for i = 1, #dbUsers do
        local currentUser = dbUsers[i]
        if currentUser.nickname == user.nickname then
            return currentUser.balance.countCoal
        end
    end

    return nil
end

database.getDiamondCount = function(user)
    for i = 1, #dbUsers do
        local currentUser = dbUsers[i]
        if currentUser.nickname == user.nickname then
            return currentUser.balance.countDiamond
        end
    end

    return nil
end

database.getMatterCount = function(user)
    for i = 1, #dbUsers do
        local currentUser = dbUsers[i]
        if currentUser.nickname == user.nickname then
            return currentUser.balance.countMatter
        end
    end

    return nil
end

connect()

return database










