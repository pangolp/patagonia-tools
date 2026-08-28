require "Vehicles/Patagonia/PatagoniaRepairRegistry"

local seatParts = { "SeatFrontLeft", "SeatFrontRight",
                    "SeatMiddleLeft", "SeatMiddleRight",
                    "SeatRearLeft",  "SeatRearRight" }

local needleHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SEWING_NEEDLE) or item:getType() == "Needle" end,
    nameFullType = "Base.Needle",
}

-- Repair = base "unit" cost. Build below is exactly double it (materials, thread
-- uses, time), sharing the same material families so the doubling is clean.
PatagoniaRepair.register({
    id             = "repairSeats",
    partIds        = seatParts,
    appliesTo      = function(part) return part:getInventoryItem() ~= nil and part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairSeats",
    warningKey     = "Tooltip_vehicle_RepairSeatsWarning",

    -- Seat area is inside the vehicle; walk beside it instead of climbing in.
    pathAdjacent   = true,

    professions = {
        { perk = "Mechanics", level = 2 },
        { perk = "Tailoring", level = 4 },
    },

    handTool = needleHandTool,

    drainable = {
        fullType     = "Base.Thread",
        uses         = 8,
        nameFullType = "Base.Thread",
    },

    materials = {
        { fullType = "Base.LeatherStrips", count = 5 },
        { fullType = "Base.SheetMetal",    count = 1 },
        { fullType = "Base.MetalBar",      count = 1 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1000,
})

-- Build from scratch = exactly double the repair (materials, thread, time). Skills a
-- bit higher than repair, but not doubled.
PatagoniaRepair.register({
    id             = "buildSeats",
    partIds        = seatParts,
    appliesTo      = function(part) return part:getInventoryItem() == nil end,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildSeats",
    warningKey     = "Tooltip_vehicle_BuildSeatsWarning",

    -- Seat area is inside the vehicle; walk beside it instead of climbing in.
    pathAdjacent   = true,

    professions = {
        { perk = "Mechanics", level = 4 },
        { perk = "Tailoring", level = 6 },
    },

    handTool = needleHandTool,

    drainable = {
        fullType     = "Base.Thread",
        uses         = 16,
        nameFullType = "Base.Thread",
    },

    materials = {
        { fullType = "Base.LeatherStrips", count = 10 },
        { fullType = "Base.SheetMetal",    count = 2 },
        { fullType = "Base.MetalBar",      count = 2 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 2000,
})
