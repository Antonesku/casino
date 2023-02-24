local component = require("component")
local gpu = component.gpu
local event = require("event")

--Игрок
--local playerName
--local _, _, _, _, _, playerName = event.pull("touch")

local slots = {}

--Список линий
local linesList = {
    {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [3] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 3
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 3
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [4] = {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [5] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [6] = {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [7] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 3
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 3
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [8] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [9] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 3
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 3
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [10] = {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [11] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [12] = {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [13] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [14] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [15] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 3
        },
        {
            numberColumn = 3,
            numberRow = 2
        },
        {
            numberColumn = 4,
            numberRow = 3
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [16] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [17] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 2
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 2
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    },
    [18] = {
        {
            numberColumn = 1,
            numberRow = 1
        },
        {
            numberColumn = 2,
            numberRow = 3
        },
        {
            numberColumn = 3,
            numberRow = 1
        },
        {
            numberColumn = 4,
            numberRow = 3
        },
        {
            numberColumn = 5,
            numberRow = 1
        },
    },
    [19] = {
        {
            numberColumn = 1,
            numberRow = 3
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 3
        },
    },
    [20] = {
        {
            numberColumn = 1,
            numberRow = 2
        },
        {
            numberColumn = 2,
            numberRow = 1
        },
        {
            numberColumn = 3,
            numberRow = 3
        },
        {
            numberColumn = 4,
            numberRow = 1
        },
        {
            numberColumn = 5,
            numberRow = 2
        },
    }
}

--Список выпадающих элементов
local listSlots ={
    coal = {
        chance = 100,
        coef3x = 10,
        coef4x = 20,
        coef5x = 80
    },
    nickel = {
        chance = 100,
        coef3x = 10,
        coef4x = 20,
        coef5x = 80
    },
    glowstone = {
        chance = 100,
        coef3x = 10,
        coef4x = 20,
        coef5x = 80
    },
    redstone = {
        chance = 55,
        coef3x = 15,
        coef4x = 25,
        coef5x = 100
    },
    lazur = {
        chance = 55,
        coef3x = 15,
        coef4x = 25,
        coef5x = 100
    },
    diamond = {
        chance = 45,
        coef3x = 20,
        coef4x = 40,
        coef5x = 200
    },
    emerald = {
        chance = 45,
        coef3x = 20,
        coef4x = 40,
        coef5x = 200
    },
    uranium = {
        chance = 35,
        coef3x = 30,
        coef4x = 50,
        coef5x = 300
    },
    redDiamond = {
        chance = 35,
        coef3x = 30,
        coef4x = 50,
        coef5x = 300
    },
    iridium = {
        chance = 17,
        coef3x = 40,
        coef4x = 100,
        coef5x = 400
    },
    matter = {
        chance = 17,
        coef3x = 40,
        coef4x = 100,
        coef5x = 400
    },
    controller = {
        chance = 1,
        coef3x,
        coef4x,
        coef5x
    },
    generator = {
        chance = 4,
        coef3x = 50,
        coef4x = 500,
        coef5x = 1000
    }
}

--Ну, а хули
local function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
      reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

--Ну, а хули 2
local function getKeysTable(inputTable)
    local tbl = {}
    for k, v in pairs(inputTable) do
        table.insert(tbl, k)
    end

    return tbl
end




--Вероятность выпадения одних и тех же слотов
local function getSlotsChances()
    local slotsChances = {}

    local lenghtListSlots = 0
    
    for k,v in pairs(listSlots) do
        lenghtListSlots = lenghtListSlots + 1
    end

    local counter = 1
    for k, v in pairs(listSlots) do
        local slot = v

        if counter == 1 then
            table.insert(slotsChances, slot.chance)
        else
            for j = 1, #slotsChances do
                if slot.chance == slotsChances.chance then
                    break
                end
    
                if j == #slotsChances then
                    table.insert(slotsChances, slot.chance)
                end
            end
        end
        
        counter = counter + 1
    end

    table.sort (slotsChances, function (a, b) return (a > b) end)
    return ReverseTable(slotsChances)
end

--Массив шанса выпадения всех слотов
local slotsChances = getSlotsChances()

local function getSlotsForChance(chance)
    local slots = {}

    local lenghtListSlots = 0

    for k, v in pairs(listSlots) do
        lenghtListSlots = lenghtListSlots + 1
    end

    local counter = 1
    for k, v in pairs(listSlots) do
        local slot = v

        if slot.chance == chance then
            slots[k] = slot
        end
        counter = counter + 1
    end

    return slots
end

--Генерация слота
local function generateSlot()
    local chance = math.random(1,100)

    local chances = {}

    local slotsChances = getSlotsChances()

    for i = 1, #slotsChances do
        local slots = getSlotsForChance(slotsChances[i])

        local chancesItem = {slotsChances[i], slots}
        table.insert(chances, chancesItem)
    end

    local s = chances[1]

    for i = 1, #chances do
        local chancesItem = chances[i]

        if chance <= chancesItem[1] then

            local lenghtChancesItem = 0
            for k,v in pairs(chancesItem[2]) do
                lenghtChancesItem = lenghtChancesItem + 1
            end

            local rand = math.random(1, lenghtChancesItem)

            local counter = 1
            for k,v in pairs(chancesItem[2]) do
                if counter == rand then
                    return {[k] = v}
                end

                counter = counter + 1
            end
       end
    end

    return nil
end



local function getSlotForMatrix(matrix, numberColumn, numberRow)
    return matrix[numberColumn][numberRow]
end

local function addSlotSequence(sequence, slot, coords)
    local item = {}
    table.insert(item, slot)
    table.insert(item, coords)

    table.insert(sequence, item)

end

local function getSlotsNameLine(matrix, line)
    local slotsNames = {}

    for i = 1, #line do
        local numberColumn, numberRow = line[i].numberColumn, line[i].numberRow
        local currentSlot = getSlotForMatrix(matrix, numberColumn, numberRow)

        if i == 1 then
            table.insert(slotsNames, getKeysTable(currentSlot)[1])
        else
            local isFinding = false
            for j = 1, #slotsNames do
                if slotsNames[j] == getKeysTable(currentSlot)[1] then
                    isFinding = true
                    break
                end
            end

            if isFinding ~= true then
                table.insert(slotsNames, getKeysTable(currentSlot)[1])
            end
        end
    end

    return slotsNames
end

local function getWinning(bet, winLines)
    local winning = 0

    for k, v in pairs(winLines) do -- sequence
        local sequence = v
        local lenghtSequnce = #sequence

        local key = "coef" .. tostring(lenghtSequnce) .. "x"
        local coef = 0

        for m, n in pairs(sequence) do -- sequence items
            local slot = n[1]
            
            if getKeysTable(slot)[1] ~= "controller" then
                coef = slot[getKeysTable(slot)[1]][key]
                break
            end
        end

        winning = winning + (bet * coef)
    end

    return winning
end

local function getWinLines(matrix, countLines)
    local winLines = {}

    if countLines > #linesList then
        countLines = 1
    end

    for i = 1, countLines do
        local line = linesList[i]

        --Одна линия
        for j = 1, #getSlotsNameLine(matrix,line) do
            local slotName = getSlotsNameLine(matrix, line)[j]

            if slotName ~= "controller" then
                local prevSlot = getSlotForMatrix(matrix, line[1].numberColumn, line[1].numberRow)
                local sequence = {}

                for k = 1, #line do
                    local numberColumn, numberRow = line[k].numberColumn, line[k].numberRow
                    local currentSlot = getSlotForMatrix(matrix, numberColumn, numberRow)
                    local currentSlotName, prevSlotName = getKeysTable(currentSlot)[1], getKeysTable(prevSlot)[1]

                    if k == 1 then
                        if (currentSlotName == slotName or currentSlotName == "controller")  then
                            --table.insert(sequence, currentSlot)
                            addSlotSequence(sequence, currentSlot, {numberColumn, numberRow})
                        end
                    else
                        if (currentSlotName == "controller") then
                            addSlotSequence(sequence, currentSlot, {numberColumn, numberRow})
                            --table.insert(sequence, currentSlot)
                        else
                            if #sequence == 0 and currentSlotName == slotName then
                                addSlotSequence(sequence, currentSlot, {numberColumn, numberRow})
                                --table.insert(sequence, currentSlot)
                            elseif currentSlotName == slotName and (prevSlotName == slotName or prevSlotName == "controller")  then
                                --table.insert(sequence, currentSlot)
                                addSlotSequence(sequence, currentSlot, {numberColumn, numberRow})
                            elseif #sequence < 3 and k <= 3 then
                                sequence = {}
                            elseif #sequence >= 3 then
                                break
                            else
                                sequence = {}
                            end
                        end
                    end
                    
                    prevSlot = currentSlot
                end

                if #sequence >= 3 then
                    table.insert(winLines, sequence)
                else
                    sequence = {}
                end
            end
        end
    end

    --[=[
    for m, n in pairs(winLines) do --winlines
        print("-----")
        for k, v in pairs(n) do --sequence
                local slot = v[1]
                --print(getKeysTable(slot)[1])
                local coords = v[2]
                print(getKeysTable(slot)[1] .. " " .. coords[1] .. " " .. coords[2])
        end
    end

    print("Ставка: 1. Вы играли: " .. tostring(getWinning(1, winLines)))
    --]=]

    return winLines
end




--Генерация матрицы
local function createMatrix()
    local matrix = {}

    for i = 1, 5 do
        matrix[i] = {}
        for j = 1, 3 do
            matrix[i][j] = generateSlot()
        end
    end

    return matrix
end

slots.start = function(bet, countLines)
    local matrix = createMatrix()
    local winLines = getWinLines(matrix, countLines)
    local winning = getWinning(bet, winLines)
    local matrixNamesSlots = {}
    local winLinesCoords = {}

    for i = 1, #matrix do
        matrixNamesSlots[i] = {}
        for j = 1, #matrix[i] do
            matrixNamesSlots[i][j] = getKeysTable(matrix[i][j])[1]
        end
    end

    for i = 1, #winLines do
        local sequence = winLines[i]
        local coords = {}

        for j = 1, #sequence do
            table.insert(coords, sequence[j][2])
        end

        table.insert(winLinesCoords, coords)
    end





    --[=[
    print("-----------")
    for j = 1, #matrix[1] do
        local row = ""

        for i = 1, #matrix do
            for k, v in pairs(matrix[i][j]) do
                row = row .. string.sub(k,1,5) .. "\t"
            end
        end
        print(row)
    end
--]=]
    return matrixNamesSlots, winLinesCoords, winning
end


--local matrix = createMatrix()

--[=[matrix[1][2] = {
    uranium = {
        chance = 55,
        coef3x,
        coef4x,
        coef5x
    }
}
matrix[2][2] = {
    lazur = {
        chance = 80,
        coef3x,
        coef4x,
        coef5x
    }
}
matrix[3][2] = {
    controller = {
        chance = 15,
        coef3x,
        coef4x,
        coef5x
    }
}
matrix[4][2] = {
    generator = {
        chance = 4,
        coef3x,
        coef4x,
        coef5x
    }
}
matrix[5][2] = {
    controller = {
        chance = 15,
        coef3x,
        coef4x,
        coef5x
    }
}
--]=]

return slots