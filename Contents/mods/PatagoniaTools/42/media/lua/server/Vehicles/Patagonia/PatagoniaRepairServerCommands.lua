require "Vehicles/Patagonia/PatagoniaRepairRecipes"

local Commands = {}

function Commands.patagoniaRepair(player, args)
    local recipe = PatagoniaRepair.recipes[args.recipeId]
    if not recipe then
        noise('patagoniaRepair: unknown recipe id=' .. tostring(args.recipeId))
        return
    end

    local vehicle = getVehicleById(args.vehicle)
    if not vehicle then
        noise('patagoniaRepair: no such vehicle id=' .. tostring(args.vehicle))
        return
    end

    local part = vehicle:getPartById(args.partId)
    if not part then
        noise('patagoniaRepair: no such part id=' .. tostring(args.partId))
        return
    end

    if not PatagoniaRepair.recipeCoversPart(recipe, part:getId()) or not PatagoniaRepair.appliesTo(recipe, part) then
        noise('patagoniaRepair: part ' .. tostring(args.partId) .. ' not valid for ' .. tostring(args.recipeId))
        return
    end

    for _, mat in ipairs(recipe.materials or {}) do
        PatagoniaVehicleCommandUtil.removeItems(player, mat.fullType, mat.count)
    end

    local installedItemId = -1
    if recipe.mode == "install" then
        local item
        if recipe.installItem then
            item = instanceItem(recipe.installItem)
            if item then part:setInventoryItem(item, player:getPerkLevel(Perks.Mechanics)) end
        else
            item = VehicleUtils.createPartInventoryItem(part)
        end
        if not item then
            noise('patagoniaRepair: could not create item for part ' .. tostring(args.partId))
            return
        end
        item:setConditionNoSound(item:getConditionMax())
        part:setCondition(100)
        vehicle:transmitPartItem(part)
        vehicle:transmitPartCondition(part)
        installedItemId = item:getID()
    else
        part:repair()
    end

    local installTable = part:getTable("install")
    if installTable and installTable.complete then
        VehicleUtils.callLua(installTable.complete, vehicle, part)
    end

    player:sendObjectChange(IsoObjectChange.MECHANIC_ACTION_DONE, {
        success = true,
        vehicleId = vehicle:getId(),
        partId = part:getId(),
        itemId = installedItemId,
        installing = true
    })
end

local function OnClientCommand(module, command, player, args)
    if module == 'vehicle' and command == 'patagoniaRepair' then
        Commands.patagoniaRepair(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
