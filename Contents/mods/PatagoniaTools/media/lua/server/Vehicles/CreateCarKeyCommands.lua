local Commands = {}

function Commands.createCarKey(player, args)
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        local part = vehicle:getPartById("Engine")
        if not part then
            noise('no such part Engine')
            return
        end

        player:sendObjectChange('removeItemType', { type = 'Base.CarKey', count = 1 })

        if vehicle:isHotwired() then
            vehicle:setHotwired(false)
        end

        local item = vehicle:createVehicleKey()
        if item then
            player:sendObjectChange("addItem", { item = item })
        end

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
    if module == 'vehicle' and command == 'createCarKey' then
        Commands.createCarKey(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
