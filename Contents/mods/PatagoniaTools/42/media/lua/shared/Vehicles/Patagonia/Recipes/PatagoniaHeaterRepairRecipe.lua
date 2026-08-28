require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Migrated from the old hand-written RestoreHeater trio. Repair-only (no part item).
-- Electrical job: screwdriver in hand, electronics as materials.
local screwdriverHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SCREWDRIVER) or item:getType() == "Screwdriver" end,
    nameFullType = "Base.Screwdriver",
}

PatagoniaRepair.register({
    id             = "repairHeater",
    partIds        = { "Heater" },
    appliesTo      = function(part) return part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_Restore_Heater",
    warningKey     = "Tooltip_vehicle_RestoreHeaterWarning",

    -- Accessed from the engine bay.
    pathArea = "Engine",

    professions = {
        { perk = "Electricity", level = 8 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.Aluminum",        count = 5 },
        { fullType = "Base.ElectronicsScrap", count = 10 },
        { fullType = "Base.ElectricWire",    count = 3 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1000,
})
