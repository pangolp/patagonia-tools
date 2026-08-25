require "Vehicles/Patagonia/PatagoniaRepairRegistry"

PatagoniaRepair.register({
    id             = "repairSeats",
    partIds        = { "SeatFrontLeft", "SeatFrontRight",
                       "SeatMiddleLeft", "SeatMiddleRight",
                       "SeatRearLeft",  "SeatRearRight" },
    displayNameKey = "IGUI_Patagonia_RepairSeats",
    warningKey     = "Tooltip_vehicle_RepairSeatsWarning",

    professions = {
        { perk = "Tailoring", level = 4 },
    },

    handTool = {
        matches      = function(item) return item:hasTag(ItemTag.SEWING_NEEDLE) or item:getType() == "Needle" end,
        nameFullType = "Base.Needle",
    },

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
