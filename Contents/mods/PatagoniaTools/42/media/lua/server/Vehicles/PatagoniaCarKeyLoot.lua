-- Adds blank car keys to mechanic shops and house garages so the create-car-key
-- recipe has a reliable loot source. (Base.CarKey already spawns in vanilla loot,
-- this just makes it findable in the thematic places.)
--
-- B42 loot injection: hook OnPreDistributionMerge and append "Item", weight pairs
-- to the target ProceduralDistributions container's items list.

local CARKEY_WEIGHTS = {
    -- Mechanic shops
    MechanicSpecial      = 10,
    MechanicShelfMisc    = 8,
    MechanicTools        = 6,
    ToolCabinetMechanics = 8,
    StoreShelfMechanics  = 6,
    -- House garages
    GarageMechanics      = 10,
    GarageTools          = 6,
    -- Gas stations
    GasStoreSpecial      = 8,
    GasStorageMechanics  = 8,
    -- Car dealerships / auto stores (dealers keep lots of keys)
    CarDealerDesk        = 20,
    CarDealerFilingCabinet = 20,
    CarSupplyTools       = 6,
}

local added = false

local function addCarKeyLoot()
    if added then return end
    added = true
    for container, weight in pairs(CARKEY_WEIGHTS) do
        local dist = ProceduralDistributions.list[container]
        if dist and dist.items then
            table.insert(dist.items, "CarKey")
            table.insert(dist.items, weight)
        end
    end
end

Events.OnPreDistributionMerge.Add(addCarKeyLoot)
