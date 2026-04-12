Config = {}

Config.Framework = "esx" -- esx/qb framework

Config.Vehicle = {
    Full = true, -- Full tuning
    VehicleStore = 'G', -- Key to store the vehicle (G by default)

}

Config.CarItems = {
    ['Bf400'] = 'bf400',

}

-- ["bf400"] = { -- Add this to ox_inventory - data - items.lua
--    label = "BF400",
--    weight = 10,
--    stack = true,
--    client = {
--        export = "ykaa_itemcar.useItemCar"
--    }
-- },