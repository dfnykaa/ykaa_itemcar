local spawnedVehicle = nil
local currentItem = nil
local isMonitoring = false

exports('useItemCar', function(data, slot)
    local itemName = data?.item?.name or data?.name
    if not itemName then return end

    local vehicleModel = Config.CarItems[itemName] or itemName
    
    TriggerEvent('ykaa_itemcar:spawnVehicle', vehicleModel, itemName)
end)

RegisterNetEvent('ykaa_itemcar:spawnVehicle', function(model, itemName)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local hash = GetHashKey(model)


    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    spawnedVehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
    
    currentItem = itemName
    TriggerServerEvent('ykaa_itemcar:removeItem', itemName)

    if Config.Vehicle.Full then
        SetVehicleModKit(spawnedVehicle, 0)
        SetVehicleMod(spawnedVehicle, 11, GetNumVehicleMods(spawnedVehicle, 11) - 1, false)
        SetVehicleMod(spawnedVehicle, 13, GetNumVehicleMods(spawnedVehicle, 13) - 1, false)
        ToggleVehicleMod(spawnedVehicle, 18, true)
        
        SetVehicleHandlingFloat(spawnedVehicle, 'CHandlingData', 'fInitialDriveForce', 0.8)
        SetVehicleHandlingFloat(spawnedVehicle, 'CHandlingData', 'fDriveInertia', 1.0)
        SetVehicleEnginePowerMultiplier(spawnedVehicle, 20.0)
    end

    StartVehicleMonitor()
end)

function StartVehicleMonitor()
    if isMonitoring then return end
    isMonitoring = true
    
    Citizen.CreateThread(function()
        local textUiOpen = false
        while spawnedVehicle ~= nil do
            local sleep = 500
            local playerPed = PlayerPedId()
            
            if IsPedInVehicle(playerPed, spawnedVehicle, false) then
                sleep = 0
                if not textUiOpen then
                    exports.ox_lib:showTextUI('[G] - Return vehicle', {
                        position = 'right-center',
                        icon = 'car'
                    })
                    textUiOpen = true
                end

                if IsControlJustReleased(0, 47) then
                    TriggerServerEvent('ykaa_itemcar:returnItem', currentItem)
                    DeleteVehicle(spawnedVehicle)
                    spawnedVehicle = nil
                    currentItem = nil
                    exports.ox_lib:hideTextUI()
                    textUiOpen = false
                    break 
                end
            else
                if textUiOpen then
                    exports.ox_lib:hideTextUI()
                    textUiOpen = false
                end
            end
            Wait(sleep)
        end
        isMonitoring = false
    end)
end