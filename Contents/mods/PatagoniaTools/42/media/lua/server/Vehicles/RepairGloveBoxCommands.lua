local Commands = {}

function Commands.repairGloveBox(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = vehicle:getPartById("GloveBox")
        if not part then
            noise('no such part glove box')
            return
        end

        player:sendObjectChange('removeItemType', { type = 'Base.LeatherStrips', count = 10 })

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
    if module == 'vehicle' and command == 'repairGloveBox' then
        Commands.repairGloveBox(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
