local Framework = nil

if Config.Framework == "esx" then
    Framework = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qb" then
    Framework = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('ykaa_itemcar:removeItem', function(itemName)
    local src = source
    if not itemName then return end

    if Config.Framework == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeInventoryItem(itemName, 1)
        end
    elseif Config.Framework == "qb" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem(itemName, 1)
            TriggerClientEvent('ykaa_itemcar:client:ItemBox', src, Framework.Shared.Items[itemName], "remove")
        end
    end
end)

RegisterNetEvent('ykaa_itemcar:returnItem', function(itemName)
    local src = source
    if not itemName then return end

    if Config.Framework == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(itemName, 1)
        end
    elseif Config.Framework == "qb" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem(itemName, 1)
            TriggerClientEvent('ykaa_itemcar:client:ItemBox', src, Framework.Shared.Items[itemName], "add")
        end
    end
end)
