require "Vehicles/Patagonia/PatagoniaRepairRecipes"
require "ISUI/Vehicles/Patagonia/ISPatagoniaRepairAction"

local function tooltipTag(recipe)
    return "patagonia_repair_" .. recipe.id
end

local function drainableHasUses(item, count)
    return item:getCurrentUses() >= count
end

local function drainableUsesComparator(item1, item2)
    return item1:getCurrentUses() - item2:getCurrentUses()
end

local function findDrainable(inv, recipe)
    if not recipe.drainable then return nil end
    return inv:getBestTypeEvalRecurse(recipe.drainable.fullType, drainableUsesComparator)
end

local function meetsRequirements(chr, recipe)
    local inv = chr:getInventory()

    for _, prof in ipairs(recipe.professions or {}) do
        if chr:getPerkLevel(Perks.FromString(prof.perk)) < prof.level then
            return false
        end
    end

    if recipe.handTool and not inv:containsEvalRecurse(recipe.handTool.matches) then
        return false
    end

    if recipe.drainable then
        local best = findDrainable(inv, recipe)
        if not best or best:getCurrentUses() < recipe.drainable.uses then
            return false
        end
    end

    for _, mat in ipairs(recipe.materials or {}) do
        if inv:getNumberOfItem(mat.fullType, false, true) < mat.count then
            return false
        end
    end

    return true
end

local function line(desc, color, text)
    return desc .. " " .. color .. text .. " <LINE>"
end

local function buildTooltip(chr, recipe, option)
    local tooltip = ISToolTip:new()
    tooltip:initialise()
    tooltip:setVisible(false)
    tooltip.description = ""
    option.toolTip = tooltip

    tooltip.description = tooltip.description .. getText("Tooltip_craft_Needs") .. " : <LINE>"

    local inv = chr:getInventory()
    local ghs = ISVehicleMechanics.ghs
    local bhs = ISVehicleMechanics.bhs

    for _, prof in ipairs(recipe.professions or {}) do
        local lvl = chr:getPerkLevel(Perks.FromString(prof.perk))
        local ok = lvl >= prof.level
        tooltip.description = line(tooltip.description, ok and ghs or bhs,
            getText("IGUI_perks_" .. prof.perk) .. " " .. lvl .. "/" .. prof.level)
    end

    if recipe.handTool then
        local has = inv:containsEvalRecurse(recipe.handTool.matches)
        tooltip.description = line(tooltip.description, has and "<RGB:0,1,0>" or "<RGB:1,0,0>",
            getItemNameFromFullType(recipe.handTool.nameFullType) .. " " .. (has and 1 or 0) .. " / 1")
    end

    if recipe.drainable then
        local best = findDrainable(inv, recipe)
        local uses = best and best:getCurrentUses() or 0
        local ok = uses >= recipe.drainable.uses
        tooltip.description = line(tooltip.description, ok and "<RGB:0,1,0>" or "<RGB:1,0,0>",
            getItemNameFromFullType(recipe.drainable.nameFullType) .. " " .. getText("ContextMenu_Uses")
            .. " " .. uses .. " / " .. recipe.drainable.uses)
    end

    for _, mat in ipairs(recipe.materials or {}) do
        local have = inv:getNumberOfItem(mat.fullType, false, true)
        local ok = have >= mat.count
        tooltip.description = line(tooltip.description, ok and ghs or bhs,
            getItemNameFromFullType(mat.fullType) .. " " .. have .. "/" .. mat.count)
    end

    if recipe.warningKey then
        tooltip.description = string.format("%s <RGB:0,1,1> %s <LINE>", tooltip.description, getText(recipe.warningKey))
    end
    tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools", tooltip.description)
end

function ISVehicleMechanics.onPatagoniaRepair(playerObj, part, recipe)
    if playerObj:getVehicle() then
        ISVehicleMenu.onExit(playerObj)
    end

    local item = nil
    if recipe.drainable then
        item = playerObj:getInventory():getFirstTypeEvalArgRecurse(recipe.drainable.fullType, drainableHasUses, recipe.drainable.uses)
        if item then ISVehiclePartMenu.toPlayerInventory(playerObj, item) end
    end
    if recipe.handTool then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), recipe.handTool.matches, true)
    end

    local vehicle = part:getVehicle()
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, vehicle, part:getArea()))

    local door = nil
    local doorPart = vehicle:getPartById((part:getId():gsub("Seat", "Door")))
    if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
        door = doorPart
    end

    if door then
        if door:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(door, playerObj) then
            ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, door))
        end
        ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, vehicle, door))
        ISTimedActionQueue.add(ISPatagoniaRepairAction:new(playerObj, part, recipe, item))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, vehicle, door))
    else
        ISTimedActionQueue.add(ISPatagoniaRepairAction:new(playerObj, part, recipe, item))
    end
end

local originalDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

function ISVehicleMechanics:doPartContextMenu(part, x, y)
    originalDoPartContextMenu(self, part, x, y)

    local recipe = PatagoniaRepair.getForPart(part:getId())
    if not recipe then return end
    if VehicleUtils.RequiredKeyNotFound(part, self.chr) then return end
    if part:getCondition() >= 100 then return end

    local playerObj = getSpecificPlayer(self.playerNum)
    local option = self.context:addOption(getText(recipe.displayNameKey), playerObj, ISVehicleMechanics.onPatagoniaRepair, part, recipe)
    self:doMenuTooltip(part, option, tooltipTag(recipe))
    if not meetsRequirements(self.chr, recipe) then
        option.notAvailable = true
    end
end

local originalDoMenuTooltip = ISVehicleMechanics.doMenuTooltip

function ISVehicleMechanics:doMenuTooltip(part, option, lua, name)
    originalDoMenuTooltip(self, part, option, lua, name)

    for _, recipe in pairs(PatagoniaRepair.recipes) do
        if lua == tooltipTag(recipe) then
            buildTooltip(self.chr, recipe, option)
            return
        end
    end
end
