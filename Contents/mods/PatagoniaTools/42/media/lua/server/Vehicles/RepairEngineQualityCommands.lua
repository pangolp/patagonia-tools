local Commands = {}

function Commands.repairEngineQuality(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = vehicle:getPartById("Engine")
        if not part then
            noise('no such part Engine')
            return
        end

        local currentQuality = vehicle:getEngineQuality()
        local available = player:getInventory():getNumberOfItem("Base.EngineParts", false, true)
        -- La cuenta: cada pieza de motor restaura 2 puntos de calidad
        -- (mismo cálculo que el menú y el tooltip).
        local partsNeeded = math.floor((100 - currentQuality) / 2) + 1
        local done = math.min(args.numberOfParts or partsNeeded, partsNeeded, available)

        if done > 0 then
            local newQuality = math.min(100, currentQuality + (done * 2))

            -- Recalcular potencia y ruido según la nueva calidad, igual que
            -- Vehicles.Create.Engine (vanilla). setFeatures ESCALA el ruido, así
            -- que hay que pasar el ruido BASE del script; getEngineLoudness ya
            -- viene escalado y se re-escalaría en cada reparación.
            local qualityBoosted = math.min(100, newQuality * 1.6)
            local qualityModifier = math.max(0.6, qualityBoosted / 100)
            local enginePower = vehicle:getScript():getEngineForce() * qualityModifier
            local engineLoudness = (vehicle:getScript():getEngineLoudness() or 100) * (SandboxVars.ZombieAttractionMultiplier or 1)

            vehicle:setEngineFeature(newQuality, engineLoudness, enginePower)
            -- setEngineFeature no transmite: sincronizar el motor a los clientes.
            vehicle:transmitEngine()

            PatagoniaVehicleCommandUtil.removeItems(player, 'Base.EngineParts', done)
            part:repair()
        end

        player:sendObjectChange(IsoObjectChange.MECHANIC_ACTION_DONE, {
            success = (done > 0),
            vehicleId = vehicle:getId(),
            partId = part:getId(),
            itemId = -1,
            installing = true
        })
    else
        noise('no such vehicle id='..tostring(args.vehicle))
    end
end

local function OnClientCommand(module, command, player, args)
    if module == 'vehicle' and command == 'repairEngineQuality' then
        Commands.repairEngineQuality(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
