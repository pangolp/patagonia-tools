require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Engine cover / hood. The vehicle part id is "EngineDoor"; its item is an
-- EngineDoor variant resolved per vehicle by createPartInventoryItem (same path
-- the door build uses). Metalwork loadout like the doors and trunk: blow torch +
-- welding mask, with the blow-torch animation. Materials mirror the old CraftHood
-- recipe (sheet metal + welding rods).
local hoodParts = { "EngineDoor" }

local function isCracked(part)
    return part:getInventoryItem() ~= nil and part:getCondition() < 100
end

local function isMissing(part)
    return part:getInventoryItem() == nil
end

local function blowTorch(uses)
    return { fullType = "Base.BlowTorch", uses = uses, nameFullType = "Base.BlowTorch" }
end

-- Repair a dented hood back to 100%. Half the metal of a fresh build.
PatagoniaRepair.register({
    id             = "repairHood",
    partIds        = hoodParts,
    appliesTo      = isCracked,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairHood",
    warningKey     = "Tooltip_vehicle_RepairHoodWarning",

    professions = {
        { perk = "Mechanics",    level = 4 },
        { perk = "MetalWelding", level = 3 },
    },

    welding   = true,
    drainable = blowTorch(6),

    materials = {
        { fullType = "Base.SheetMetal",  count = 5 },
        { fullType = "Base.WeldingRods", count = 1 },
    },

    actionAnim = "BlowTorch",
    time       = 1000,
})

-- Build a brand-new hood where none is installed. Material cost mirrors the old
-- CraftHood recipe (10 sheet metal + welding rods); more skill and torch fuel.
PatagoniaRepair.register({
    id             = "buildHood",
    partIds        = hoodParts,
    appliesTo      = isMissing,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildHood",
    warningKey     = "Tooltip_vehicle_BuildHoodWarning",

    professions = {
        { perk = "Mechanics",    level = 6 },
        { perk = "MetalWelding", level = 4 },
    },

    welding   = true,
    drainable = blowTorch(12),

    materials = {
        { fullType = "Base.SheetMetal",  count = 10 },
        { fullType = "Base.WeldingRods", count = 1 },
    },

    actionAnim = "BlowTorch",
    time       = 2000,
})
