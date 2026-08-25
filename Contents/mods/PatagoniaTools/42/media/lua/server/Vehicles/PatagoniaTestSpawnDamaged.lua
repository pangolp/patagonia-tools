-- TEST ONLY -- delete this file when the vehicle repair testing is finished.
--
-- Every vehicle that spawns is set up so the ONLY things below 100% are the
-- parts this mod repairs. That way the overall condition should climb to 100%
-- once all the mod repairs are done, which is what we want to verify.
--
--   * Engine  -> condition stays 100 (the quality repair requires it) but the
--                engine QUALITY is lowered, so the engine-quality repair shows up.
--   * Heater, GloveBox, lightbar, TruckBed/TruckBedOpen -> condition lowered.
--   * Everything else -> forced to 100.

local MOD_PARTS = { "Heater", "GloveBox", "lightbar", "TruckBed", "TruckBedOpen" }
local DAMAGED_CONDITION = 30
local ENGINE_QUALITY = 40

local function onSpawnVehicleEnd(vehicle)
    if not vehicle then return end

    -- 1) Force every part to full so only the mod parts hold the condition down.
    for i = 0, vehicle:getPartCount() - 1 do
        local part = vehicle:getPartByIndex(i)
        if part then
            part:setCondition(100)
            vehicle:transmitPartCondition(part)
        end
    end

    -- 2) Damage the body parts the mod repairs.
    for _, id in ipairs(MOD_PARTS) do
        local part = vehicle:getPartById(id)
        if part then
            part:setCondition(DAMAGED_CONDITION)
            vehicle:transmitPartCondition(part)
        end
    end

    -- 3) Engine: keep condition at 100, drop the quality. Recompute power from
    --    the new quality like Vehicles.Create.Engine does.
    local engine = vehicle:getPartById("Engine")
    if engine then
        engine:setCondition(100)
        vehicle:transmitPartCondition(engine)
    end
    local qualityBoosted = math.min(100, ENGINE_QUALITY * 1.6)
    local qualityModifier = math.max(0.6, qualityBoosted / 100)
    local enginePower = vehicle:getScript():getEngineForce() * qualityModifier
    local engineLoudness = vehicle:getEngineLoudness()
    vehicle:setEngineFeature(ENGINE_QUALITY, engineLoudness, enginePower)
end

Events.OnSpawnVehicleEnd.Add(onSpawnVehicleEnd)
