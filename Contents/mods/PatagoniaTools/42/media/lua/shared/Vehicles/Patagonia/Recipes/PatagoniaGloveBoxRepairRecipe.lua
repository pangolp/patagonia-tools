require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Migrated from the old hand-written RepairGloveBox trio. Repair-only (no part item).
-- Upholstery job: needle in hand, thread consumed, leather as material.
local needleHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SEWING_NEEDLE) or item:getType() == "Needle" end,
    nameFullType = "Base.Needle",
}

PatagoniaRepair.register({
    id             = "repairGloveBox",
    partIds        = { "GloveBox" },
    appliesTo      = function(part) return part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_Repair_Glove_Box",
    warningKey     = "Tooltip_vehicle_Repair_Glove_Box",

    -- Accessed from the engine bay; its own area is an interior seat area.
    pathArea = "Engine",

    professions = {
        { perk = "Tailoring", level = 8 },
    },

    handTool  = needleHandTool,
    drainable = { fullType = "Base.Thread", uses = 10, nameFullType = "Base.Thread" },

    materials = {
        { fullType = "Base.LeatherStrips", count = 10 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1000,
})
