local function predicateScrewdriver(item)
    return item:hasTag("Screwdriver") or item:getType() == "Screwdriver"
end

local originalDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

function ISVehicleMechanics:doPartContextMenu(part, x, y)
    originalDoPartContextMenu(self, part, x, y)

    if (part:getId() == "lightbar" and not VehicleUtils.RequiredKeyNotFound(part, self.chr)) then
        self.context = ISContextMenu.get(self.playerNum, x + self:getAbsoluteX(), y + self:getAbsoluteY())
        local playerObj = getSpecificPlayer(self.playerNum)
        local vehicle = part:getVehicle()

        local option = self.context:addOption(getText("IGUI_Lightbar"), playerObj, ISVehicleMechanics.onRestoreLightbar, part)
        self:doMenuTooltip(part, option, "restore_lightbar")
    end
end

function ISVehicleMechanics.onRestoreLightbar(playerObj, part)

    if playerObj:getVehicle() then
        ISVehicleMenu.onExit(playerObj)
    end

    local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
    local item = typeToItem["Base.Screwdriver"][1]
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)

    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), "Engine"))

    local engineCover = nil
    local doorPart = part:getVehicle():getPartById("EngineDoor")
    if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() and not doorPart:getDoor():isOpen() then
        engineCover = doorPart
    end

    local time = 1000
    if engineCover then
        if engineCover:getDoor():isLocked() and VehicleUtils.RequiredKeyNotFound(engineCover, playerObj) then
            ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, engineCover))
        end
        ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
        ISTimedActionQueue.add(ISRestoreLightbar:new(playerObj, part, item, time))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    else
        ISTimedActionQueue.add(ISRestoreLightbar:new(playerObj, part, item, time))
    end
end

local originalDoMenuTooltip = ISVehicleMechanics.doMenuTooltip

function ISVehicleMechanics:doMenuTooltip(part, option, lua, name)
    originalDoMenuTooltip(self, part, option, lua, name)

    if lua == "restore_lightbar" then
        local vehicle = part:getVehicle()
        local tooltip = ISToolTip:new()
        tooltip:initialise()
        tooltip:setVisible(false)
        tooltip.description = ""
        option.toolTip = tooltip

        if (part:getCondition() >= 100) then
            tooltip.description = string.format("%s %s <LINE>", tooltip.description, getText("Tooltip_part_full"))
            tooltip.description = string.format("%s <RGB:0,1,1> %s <LINE>", tooltip.description, getText("Tooltip_vehicle_RestoreLightbarWarning"))
            tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools", tooltip.description)
            option.notAvailable = true
            return
        else
            tooltip.description = tooltip.description .. getText("Tooltip_craft_Needs") .. " : <LINE>"
        end

        local electricityLevel = 8
        if self.chr:getPerkLevel(Perks.Electricity) < electricityLevel then
            rgb = ISVehicleMechanics.bhs
            option.notAvailable = true
        else
            rgb = ISVehicleMechanics.ghs
        end

        tooltip.description = tooltip.description .. " " .. rgb .. getText("IGUI_perks_Electricity") .. " " .. self.chr:getPerkLevel(Perks.Electricity) .. "/" .. electricityLevel .. " <LINE>"

        if self.chr:getInventory():containsEvalRecurse(predicateScrewdriver) then
            tooltip.description = tooltip.description .. "<RGB:0,1,0> " .. getItemNameFromFullType("Base.Screwdriver") .. " 1 / 1" .. " <LINE>"
        else
            tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.Screwdriver") .. " 0 / 1" .. " <LINE>"
            option.notAvailable = true
        end

        local _lightBulbInInventory = self.chr:getInventory():getNumberOfItem("Base.LightBulb", false, true)
        local _lightBulbRequired = 20

        if _lightBulbInInventory >= _lightBulbRequired then
            rgb = ISVehicleMechanics.ghs
        else
            rgb = ISVehicleMechanics.bhs
            option.notAvailable = true
        end

        tooltip.description = tooltip.description .. " " .. rgb .. getItemNameFromFullType("Base.LightBulb") .. " " .. _lightBulbInInventory .. "/" .. _lightBulbRequired .. " <LINE>"

        tooltip.description = string.format("%s <RGB:0,1,1> %s <LINE>", tooltip.description, getText("Tooltip_vehicle_RestoreLightbarWarning"))
        tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools.", tooltip.description)
    end
end
