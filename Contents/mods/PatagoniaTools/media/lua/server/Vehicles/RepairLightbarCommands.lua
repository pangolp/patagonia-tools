local Commands = {}

function Commands.repairLightbar(player, args)
    local vehicle = getVehicleById(args.vehicle)

    if vehicle then
        local part = vehicle:getPartById("lightbar")
        if not part then
            noise('no such part lightbar')
            return
        end

        player:sendObjectChange('removeItemType', { type = 'Base.LightBulb', count = 20 })

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
    if module == 'vehicle' and command == 'repairLightbar' then
        Commands.repairLightbar(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
