local Commands = {}

function Commands.repairHeater(player, args)
    local vehicle = getVehicleById(args.vehicle)

    if vehicle then
        local part = vehicle:getPartById("Heater")
        if not part then
            noise('no such part heater')
            return
        end

        player:sendObjectChange('removeItemType', { type = 'Base.Aluminum', count = 5 })
        player:sendObjectChange('removeItemType', { type = 'Base.ElectronicsScrap', count = 10 })
        player:sendObjectChange('removeItemType', { type = 'Radio.ElectricWire', count = 3 })

        part:repair()

        player:sendObjectChange('mechanicActionDone', {
            success = true,
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
    if module == 'vehicle' and command == 'repairHeater' then
        Commands.repairHeater(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
