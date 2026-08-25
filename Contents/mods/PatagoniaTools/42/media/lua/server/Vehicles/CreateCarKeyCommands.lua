local Commands = {}

function Commands.createCarKey(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = vehicle:getPartById("Engine")
        if not part then
            noise('no such part Engine')
            return
        end

        PatagoniaVehicleCommandUtil.removeItems(player, 'Base.CarKey', 1)

        -- Si el vehículo tiene puente (activo o roto), quitarlo; si no, no hace
        -- nada. cheatHotwire sincroniza al cliente (marca updateFlags);
        -- setHotwired solo cambia el campo en el servidor y no se transmite.
        if vehicle:isHotwired() or vehicle:isHotwiredBroken() then
            vehicle:cheatHotwire(false, false)
        end

        local item = vehicle:createVehicleKey()
        if item then
            PatagoniaVehicleCommandUtil.addItem(player, item)
        end

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
    if module == 'vehicle' and command == 'createCarKey' then
        Commands.createCarKey(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
