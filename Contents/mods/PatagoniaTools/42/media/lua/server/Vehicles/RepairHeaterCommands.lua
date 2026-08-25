local Commands = {}

function Commands.repairHeater(player, args)
    local vehicle = getVehicleById(args.vehicle)

    if vehicle then
        local part = vehicle:getPartById("Heater")
        if not part then
            noise('no such part heater')
            return
        end

        PatagoniaVehicleCommandUtil.removeItems(player, 'Base.Aluminum', 5)
        PatagoniaVehicleCommandUtil.removeItems(player, 'Base.ElectronicsScrap', 10)
        PatagoniaVehicleCommandUtil.removeItems(player, 'Radio.ElectricWire', 3)

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
    if module == 'vehicle' and command == 'repairHeater' then
        Commands.repairHeater(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
