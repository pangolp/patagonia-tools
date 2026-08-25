local Commands = {}

function Commands.restoreTrunk(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = (vehicle:getPartById("TruckBedOpen") or (vehicle:getPartById("TruckBed")))
        if not part then
            noise('no such part truck bed')
            return
        end

        PatagoniaVehicleCommandUtil.removeItems(player, 'Base.SheetMetal', args.numberOfParts)

        part:repair()

        player:sendObjectChange(IsoObjectChange.MECHANIC_ACTION_DONE, {
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
    if module == 'vehicle' and command == 'restoreTrunk' then
        Commands.restoreTrunk(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
