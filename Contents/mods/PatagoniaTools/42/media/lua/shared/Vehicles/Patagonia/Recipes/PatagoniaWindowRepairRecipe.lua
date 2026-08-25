require "Vehicles/Patagonia/PatagoniaRepairRegistry"

local doorWindowParts = { "WindowFrontLeft", "WindowFrontRight",
                          "WindowMiddleLeft", "WindowMiddleRight",
                          "WindowRearLeft",  "WindowRearRight" }

local windshieldParts = { "Windshield", "WindshieldRear" }

local screwdriverHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SCREWDRIVER) or item:getType() == "Screwdriver" end,
    nameFullType = "Base.Screwdriver",
}

local function isCracked(part)
    return part:getInventoryItem() ~= nil and part:getCondition() < 100
end

local function isMissing(part)
    return part:getInventoryItem() == nil
end

PatagoniaRepair.register({
    id             = "repairWindowsDoor",
    partIds        = doorWindowParts,
    appliesTo      = isCracked,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairWindow",
    warningKey     = "Tooltip_vehicle_RepairGlassWarning",

    professions = {
        { perk = "Mechanics", level = 2 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.DuctTape",    count = 2 },
        { fullType = "Base.BrokenGlass", count = 2 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 800,
})

PatagoniaRepair.register({
    id             = "buildWindowsDoor",
    partIds        = doorWindowParts,
    appliesTo      = isMissing,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildWindow",
    warningKey     = "Tooltip_vehicle_BuildGlassWarning",

    professions = {
        { perk = "Glassmaking", level = 3 },
        { perk = "Mechanics",   level = 3 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.GlassPanel",  count = 1 },
        { fullType = "Base.BrokenGlass", count = 3 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1200,
})

-- Repair = base "unit" cost. Leaves the windshield at 100%, so it is not cheap.
PatagoniaRepair.register({
    id             = "repairWindshield",
    partIds        = windshieldParts,
    appliesTo      = isCracked,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairWindshield",
    warningKey     = "Tooltip_vehicle_RepairGlassWarning",

    professions = {
        { perk = "Mechanics",   level = 3 },
        { perk = "Glassmaking", level = 2 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.GlassPanel",  count = 1 },
        { fullType = "Base.DuctTape",    count = 3 },
        { fullType = "Base.BrokenGlass", count = 2 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 900,
})

-- Build from scratch = exactly double the repair (materials + time). Guaranteed
-- path to 100% when no part exists, using only vanilla skills/materials.
PatagoniaRepair.register({
    id             = "buildWindshield",
    partIds        = windshieldParts,
    appliesTo      = isMissing,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildWindshield",
    warningKey     = "Tooltip_vehicle_BuildGlassWarning",

    professions = {
        { perk = "Mechanics",   level = 5 },
        { perk = "Glassmaking", level = 4 },
    },

    handTool = screwdriverHandTool,

    materials = {
        { fullType = "Base.GlassPanel",  count = 2 },
        { fullType = "Base.DuctTape",    count = 6 },
        { fullType = "Base.BrokenGlass", count = 4 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1800,
})
