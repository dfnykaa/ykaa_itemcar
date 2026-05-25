Config = {}

Config.Framework = "esx" -- "esx" or "qb"

Config.Vehicle = {
    Full = true, -- Full tuning          
    VehiclePlate = true, -- Enable vehicle plate name        
    NameVehiclePlate = 'YOUR PLATE', -- Plate name
    VehicleStore = 'G' -- Key to store the vehicle (Don't Touch!!!)
}

Config.CarItems = {
    ['Bf400'] = 'bf400'
}

-- ["bf400"] = { -- Add this to ox_inventory - data - items.lua
--    label = "BF400",
--    weight = 10,
--    stack = true,
--    client = {
--        export = "ykaa_itemcar.useItemCar"
--    }
-- },
