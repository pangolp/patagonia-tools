require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Migrated from the old hand-written RestoreLightbar trio. Repair-only (no part item).
-- Electrical job: screwdriver in hand, light bulbs as material. Part id is lowercase.
local screwdriverHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SCREWDRIVER) or item:getType() == "Screwdriver" end,
    nameFullType = "Base.Screwdriver",
}

PatagoniaRepair.register({
    id             = "repairLightbar",
    partIds        = { "lightbar" },
    appliesTo      = function(part) return part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_Lightbar",
    warningKey     = "Tooltip_vehicle_RestoreLightbarWarning",

    -- Accessed from the engine bay.
    pathArea = "Engine",

    professions = {
        { perk = "Electricity", level = 8 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.LightBulb", count = 20 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1000,
})
