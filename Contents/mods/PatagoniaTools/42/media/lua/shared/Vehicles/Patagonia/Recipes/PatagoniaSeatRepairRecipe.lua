require "Vehicles/Patagonia/PatagoniaRepairRegistry"

local seatParts = { "SeatFrontLeft", "SeatFrontRight",
                    "SeatMiddleLeft", "SeatMiddleRight",
                    "SeatRearLeft",  "SeatRearRight" }

local needleHandTool = {
    matches      = function(item) return item:hasTag(ItemTag.SEWING_NEEDLE) or item:getType() == "Needle" end,
    nameFullType = "Base.Needle",
}

PatagoniaRepair.register({
    id             = "repairSeats",
    partIds        = seatParts,
    appliesTo      = function(part) return part:getInventoryItem() ~= nil and part:getCondition() < 100 end,
    mode           = "repair",
    displayNameKey = "IGUI_Patagonia_RepairSeats",
    warningKey     = "Tooltip_vehicle_RepairSeatsWarning",

    professions = {
        { perk = "Tailoring", level = 4 },
    },

    handTool = needleHandTool,

    drainable = {
        fullType     = "Base.Thread",
        uses         = 8,
        nameFullType = "Base.Thread",
    },

    materials = {
        { fullType = "Base.LeatherStrips", count = 4 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1000,
})

PatagoniaRepair.register({
    id             = "buildSeats",
    partIds        = seatParts,
    appliesTo      = function(part) return part:getInventoryItem() == nil end,
    mode           = "install",
    displayNameKey = "IGUI_Patagonia_BuildSeats",
    warningKey     = "Tooltip_vehicle_BuildSeatsWarning",

    professions = {
        { perk = "Tailoring", level = 7 },
        { perk = "Mechanics", level = 3 },
    },

    handTool = needleHandTool,

    drainable = {
        fullType     = "Base.Thread",
        uses         = 20,
        nameFullType = "Base.Thread",
    },

    materials = {
        { fullType = "Base.LeatherStrips", count = 10 },
        { fullType = "Base.SheetMetal",    count = 3 },
        { fullType = "Base.MetalBar",      count = 2 },
    },

    actionAnim = "VehicleWorkOnMid",
    time       = 1500,
})
