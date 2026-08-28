require "Vehicles/Patagonia/PatagoniaRepairRegistry"

-- Single side doors (front / middle / rear, left & right). Their part item is a
-- FrontCarDoor / RearCarDoor variant, resolved per vehicle by createPartInventoryItem.
local singleDoorParts = { "DoorFrontLeft",  "DoorFrontRight",
                          "DoorMiddleLeft", "DoorMiddleRight",
                          "DoorRearLeft",   "DoorRearRight" }

-- Double rear door (van tailgate). Uses the RearCarDoorDouble item variant, so it
-- needs roughly double the metal of a single door and a bit more skill.
local doubleDoorParts = { "DoorRear" }

-- Wrench to bolt the panel on/off (same tool vanilla door install/uninstall uses)...
local wrenchHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.WRENCH) or item:getType() == "Wrench" end,
    nameFullType = "Base.Wrench",
}

-- ...and a blow torch whose fuel is spent welding the metalwork. Repair spends the
-- base amount, building spends exactly double (see below).
local function blowTorch(uses)
    return { fullType = "Base.BlowTorch", uses = uses, nameFullType = "Base.BlowTorch" }
end

local function isCracked(part)
    return part:getInventoryItem() ~= nil and part:getCondition() < 100
end

local function isMissing(part)
    return part:getInventoryItem() == nil
end

-- ---------------------------------------------------------------------------
-- Single side door. Repair = base "unit" cost; leaves the door at 100%.
-- ---------------------------------------------------------------------------
PatagoniaRepair.register({
    id             = "repairDoorSingle",
    partIds        = singleDoorParts,
    appliesTo      = isCracked,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairDoor",
    warningKey     = "Tooltip_vehicle_RepairDoorWarning",

    professions = {
        { perk = "Mechanics",    level = 3 },
        { perk = "MetalWelding", level = 2 },
    },

    handTool  = wrenchHandTool,
    drainable = blowTorch(4),

    materials = {
        { fullType = "Base.SheetMetal", count = 2 },
        { fullType = "Base.MetalBar",   count = 1 },
    },

    welding    = true,
    actionAnim = "BlowTorch",
    time       = 900,
})

-- Build from scratch = exactly double the repair (materials, torch fuel, time).
-- Skills a bit higher than repair, but not doubled.
PatagoniaRepair.register({
    id             = "buildDoorSingle",
    partIds        = singleDoorParts,
    appliesTo      = isMissing,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildDoor",
    warningKey     = "Tooltip_vehicle_BuildDoorWarning",

    professions = {
        { perk = "Mechanics",    level = 5 },
        { perk = "MetalWelding", level = 4 },
    },

    handTool  = wrenchHandTool,
    drainable = blowTorch(8),

    materials = {
        { fullType = "Base.SheetMetal", count = 4 },
        { fullType = "Base.MetalBar",   count = 2 },
    },

    welding    = true,
    actionAnim = "BlowTorch",
    time       = 1800,
})

-- ---------------------------------------------------------------------------
-- Double rear (van) door. Bigger panel: ~double a single door's metal and a
-- touch more skill. Same repair-unit / double-for-build rule applies.
-- ---------------------------------------------------------------------------
PatagoniaRepair.register({
    id             = "repairDoorDouble",
    partIds        = doubleDoorParts,
    appliesTo      = isCracked,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairDoorDouble",
    warningKey     = "Tooltip_vehicle_RepairDoorWarning",

    professions = {
        { perk = "Mechanics",    level = 4 },
        { perk = "MetalWelding", level = 3 },
    },

    handTool  = wrenchHandTool,
    drainable = blowTorch(6),

    materials = {
        { fullType = "Base.SheetMetal", count = 4 },
        { fullType = "Base.MetalBar",   count = 2 },
    },

    welding    = true,
    actionAnim = "BlowTorch",
    time       = 1200,
})

PatagoniaRepair.register({
    id             = "buildDoorDouble",
    partIds        = doubleDoorParts,
    appliesTo      = isMissing,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildDoorDouble",
    warningKey     = "Tooltip_vehicle_BuildDoorWarning",

    professions = {
        { perk = "Mechanics",    level = 6 },
        { perk = "MetalWelding", level = 5 },
    },

    handTool  = wrenchHandTool,
    drainable = blowTorch(12),

    materials = {
        { fullType = "Base.SheetMetal", count = 8 },
        { fullType = "Base.MetalBar",   count = 4 },
    },

    welding    = true,
    actionAnim = "BlowTorch",
    time       = 2400,
})
