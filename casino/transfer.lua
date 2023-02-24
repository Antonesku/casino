local component = require("component")
local tp = component.transposer
local errorMsg = nil
local transfer = {}

if tp == nil then
    errorMsg = "Не подключен транспозер"
    return
end

transfer.transferIn = function(nameItem, count)
    local sidePlayer, sideMeInterface = 1, 0
    local sizePlayerInv = tp.getInventorySize(sidePlayer)
    local sizeMeInterface = tp.getInventorySize(sideMeInterface)
    local startCountItems = count
    local addingItems = 0

    if sizePlayerInv == nil then
        errorMsg = "Встаньте на транспозер"
        return addingItems, count, errorMsg
    end

    for i = 1, sizePlayerInv do
        
        local currentSlot = i 
        local currentItem = tp.getStackInSlot(sidePlayer, currentSlot)

        if currentItem ~= nil then
            if currentItem.name == nameItem then
                local countItemInStack = currentItem.size 
                local err
                
                if count >= countItemInStack then
                    --local status = xpcall(tp.transferItem(sidePlayer, sideMeInterface, countItemInStack, currentSlot, sizeMeInterface), err)
                    local status = pcall(tp.transferItem, sidePlayer, sideMeInterface, count, currentSlot, sizeMeInterface)

                    if status ~= true then
                        errorMsg = "Встаньте на транспозер"
                        return addingItems, count, errorMsg
                    end

                    count = count - countItemInStack
                    addingItems = startCountItems - count
                else
                    --local status = xpcall(tp.transferItem(sidePlayer, sideMeInterface, count, currentSlot, sizeMeInterface), err)
                    local status = pcall(tp.transferItem, sidePlayer, sideMeInterface, count, currentSlot, sizeMeInterface)


                    if status ~= true then
                        errorMsg = "Встаньте на транспозер"
                        return addingItems, count, errorMsg
                    end
                    
                    count = count - count
                    addingItems = startCountItems - count
                    return addingItems, count
                end
            end
        end
    end

    addingItems = startCountItems - count

    if count ~= 0 then
        errorMsg = "У вас недостаточно средств"
    end

    return addingItems, count, errorMsg
end

transfer.transferOut = function(nameItem, count)
    local sidePlayer, sideMeInterface = 1, 0
    local sizePlayerInv = tp.getInventorySize(sidePlayer)
    local sizeMeInterface = tp.getInventorySize(sideMeInterface)
    local startCountItems = count
    local addingItems = 0

    if sizePlayerInv == nil then
        errorMsg = "Встаньте на транспозер"
        return addingItems, count, errorMsg
    end

    for i = 1, sizeMeInterface do
        local currentSlot = i
        local currentItem = tp.getStackInSlot(sideMeInterface, currentSlot)

        if currentItem ~= nil then
            if currentItem.name == nameItem then
                while count ~= 0 do
                    currentItem = tp.getStackInSlot(sideMeInterface, currentSlot)

                    if currentItem == nil then
                        break
                    end
                    
                    local countItemInStack = currentItem.size
                    local countItems

                    if count <= countItemInStack then
                        countItems = count
                    else
                        countItems = countItemInStack 
                    end

                    local playerSlot = nil
                    for j = 1, sizePlayerInv do
                        local currentSlotPlayer = j
                        local currentItemPlayer = tp.getStackInSlot(sidePlayer, currentSlotPlayer)

                        if currentItemPlayer == nil then
                            playerSlot = currentSlotPlayer
                            break
                        end

                    end

                    if playerSlot == nil then
                        errorMsg = "Освободите место в инвентаре"
                        return addingItems, count, errorMsg
                    end

                    local status = pcall(tp.transferItem, sideMeInterface, sidePlayer, countItems, currentSlot, playerSlot)
                    
                    if status ~= true then
                        errorMsg = "Встаньте на транспозер"
                        return addingItems, count, errorMsg
                    end
                    count = count - countItems
                    addingItems = addingItems + countItems
                end
            end
        end
    end

    addingItems = startCountItems - count

    if count ~= 0 then
        errorMsg = "Недостаточно средств в системе"
    end

    return addingItems, count, errorMsg
end

return transfer











