local Commands = {}

function Commands.repairEngineQuality(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = vehicle:getPartById("Engine")
        if not part then
            noise('no such part Engine')
            return
        end

        -- Usar mínimo 2 piezas, máximo según disponibilidad
        local partsToUse = args.numberOfParts
        local done = 0
        local currentQuality = vehicle:getEngineQuality()
        local newQuality = currentQuality

        for i=1, partsToUse do
            newQuality = newQuality
            done = done + 1
            if newQuality >= 100 then
                newQuality = 100
                break
            end
        end

        if done > 0 then
            player:sendObjectChange('removeItemType', { type = 'Base.EngineParts', count = done })
            part:repair()
        end

        player:sendObjectChange('mechanicActionDone', {
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
