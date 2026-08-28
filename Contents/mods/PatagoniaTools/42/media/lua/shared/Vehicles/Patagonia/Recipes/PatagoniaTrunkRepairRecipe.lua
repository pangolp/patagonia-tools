require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Migrated from the old hand-written RestoreTrunk menu/action/command trio to the
-- data-driven framework. Repair-only (the trunk bed has no removable part item, so
-- there is no build variant). Metalwork loadout matches the door recipes: wrench in
-- hand + blow-torch fuel consumed.
local wrenchHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.WRENCH) or item:getType() == "Wrench" end,
    nameFullType = "Base.Wrench",
}

PatagoniaRepair.register({
    id             = "repairTrunk",
    partIds        = { "TruckBed", "TruckBedOpen" },
    appliesTo      = function(part) return part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_RestoreTrunk",
    warningKey     = "Tooltip_vehicle_RestoreTrunkWarning",

    professions = {
        { perk = "Mechanics",    level = 5 },
        { perk = "MetalWelding", level = 3 },
    },

    handTool  = wrenchHandTool,
    drainable = { fullType = "Base.BlowTorch", uses = 10, nameFullType = "Base.BlowTorch" },

    materials = {
        { fullType = "Base.SheetMetal", count = 5 },
    },

    welding    = true,
    actionAnim = "BlowTorch",
    time       = 1000,
})
