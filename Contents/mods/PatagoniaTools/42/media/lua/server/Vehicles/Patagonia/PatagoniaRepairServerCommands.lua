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

    if PatagoniaRepair.getForPart(part:getId()) ~= recipe then
        noise('patagoniaRepair: part ' .. tostring(args.partId) .. ' not valid for ' .. tostring(args.recipeId))
        return
    end

    for _, mat in ipairs(recipe.materials or {}) do
        PatagoniaVehicleCommandUtil.removeItems(player, mat.fullType, mat.count)
    end

    part:repair()

    player:sendObjectChange(IsoObjectChange.MECHANIC_ACTION_DONE, {
        success = true,
        vehicleId = vehicle:getId(),
        partId = part:getId(),
        itemId = -1,
        installing = true
    })
end

local function OnClientCommand(module, command, player, args)
    if module == 'vehicle' and command == 'patagoniaRepair' then
        Commands.patagoniaRepair(player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)
