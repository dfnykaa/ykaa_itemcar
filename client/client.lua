local activeVehicles = {}
local isMonitoring = false
local textUiOpen = false

RegisterCommand('returnitemcar', function()
    local playerPed = PlayerPedId()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    
    if currentVehicle ~= 0 and activeVehicles[currentVehicle] then
        local itemToReturn = activeVehicles[currentVehicle]
        
        TriggerServerEvent('ykaa_itemcar:returnItem', itemToReturn)
        DeleteVehicle(currentVehicle)
        
        activeVehicles[currentVehicle] = nil
        
        if textUiOpen then
            exports.ox_lib:hideTextUI()
            textUiOpen = false
        end
    end
end, false)

RegisterKeyMapping('returnitemcar', 'Return Item Vehicle', 'keyboard', 'g')

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

    local spawnedVehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
    
    activeVehicles[spawnedVehicle] = itemName
    TriggerServerEvent('ykaa_itemcar:removeItem', itemName)

    if Config.Vehicle.VehiclePlate then
        SetVehicleNumberPlateText(spawnedVehicle, string.upper(Config.Vehicle.NameVehiclePlate))
    end

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
        local uiText = string.format('[G] - Return vehicle', Config.Vehicle.VehicleStoreText)

        while next(activeVehicles) ~= nil do
            local playerPed = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            
            if currentVehicle ~= 0 and activeVehicles[currentVehicle] then
                if not textUiOpen then
                    exports.ox_lib:showTextUI(uiText, {
                        position = 'right-center',
                        icon = 'car'
                    })
                    textUiOpen = true
                end
            else
                if textUiOpen then
                    exports.ox_lib:hideTextUI()
                    textUiOpen = false
                end
            end
            Wait(100)
        end
        
        if textUiOpen then
            exports.ox_lib:hideTextUI()
            textUiOpen = false
        end
        isMonitoring = false
    end)
end
