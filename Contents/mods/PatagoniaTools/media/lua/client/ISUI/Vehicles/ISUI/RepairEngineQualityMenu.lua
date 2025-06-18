local originalDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

-- Enable the option to repair engine quality.
function ISVehicleMechanics:doPartContextMenu(part, x, y)
    originalDoPartContextMenu(self, part, x, y)
    if part:getId() == "Engine" and not VehicleUtils.RequiredKeyNotFound(part, self.chr) then
        local playerObj = getSpecificPlayer(self.playerNum)
        local vehicle = part:getVehicle()

        local _engineCondition = (part:getCondition() == 100)
        local _mechanicPerkLevel = (playerObj:getPerkLevel(Perks.Mechanics) <= 10)
        local _hasWrench = (playerObj:getInventory():getNumberOfItem("Base.Wrench", false, true) >= 1)
        local _needEngineParts = (playerObj:getInventory():getNumberOfItem("EngineParts", false, true) >= ((math.floor(((100 - vehicle:getEngineQuality()) / 2))) + 1))
        local _engineQuality = (vehicle:getEngineQuality() < 100)

        if _engineCondition and _mechanicPerkLevel and _hasWrench and _needEngineParts and _engineQuality then
            local option = self.context:addOption(getText("IGUI_RepairEngineQuality"), playerObj, ISVehicleMechanics.onRepairEngineQuality, part)
            self:doMenuTooltip(part, option, "repairenginequality")
        else
            local option = self.context:addOption(getText("IGUI_RepairEngineQuality"), playerObj, ISVehicleMechanics.onRepairEngineQuality, part)
            self:doMenuTooltip(part, option, "repairenginequality")
            option.notAvailable = true
        end
    end
end

function ISVehicleMechanics.onRepairEngineQuality(playerObj, part)

    if playerObj:getVehicle() then
        ISVehicleMenu.onExit(playerObj)
    end

    local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
    local item = typeToItem["Base.Wrench"][1]
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)

    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))

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
        ISTimedActionQueue.add(ISRepairEngineQuality:new(playerObj, part, item, time))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    else
        ISTimedActionQueue.add(ISRepairEngineQuality:new(playerObj, part, item, time))
    end
end

local originalDoMenuTooltip = ISVehicleMechanics.doMenuTooltip

function ISVehicleMechanics:doMenuTooltip(part, option, lua, name)
    originalDoMenuTooltip(self, part, option, lua, name)

    if lua == "repairenginequality" then
        local vehicle = part:getVehicle()
        local tooltip = ISToolTip:new()
        tooltip:initialise()
        tooltip:setVisible(false)
        tooltip.description = getText("Tooltip_craft_Needs") .. " : <LINE>"
        option.toolTip = tooltip

        local rgb = ISVehicleMechanics.ghs
        if vehicle:getEngineQuality() >= 100 then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. " " .. getText("Tooltip_Vehicle_EngineQualityFull") .. " <LINE>"
        end

        local requiredLevel = 10
        if self.chr:getPerkLevel(Perks.Mechanics) < requiredLevel then
            rgb = ISVehicleMechanics.bhs
        end

        tooltip.description = tooltip.description .. " " .. rgb .. getText("IGUI_perks_Mechanics") .. " " .. self.chr:getPerkLevel(Perks.Mechanics) .. "/" .. requiredLevel .. " <LINE>"

        local item = InventoryItemFactory.CreateItem("Base.Wrench")
        if not self.chr:getInventory():contains("Wrench") then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. item:getDisplayName() .. " 0/1 <LINE>"
        else
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.ghs .. item:getDisplayName() .. " 1/1 <LINE>"
        end

        if part:getCondition() < 100 then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. getText("Tooltip_Engine_Condition") .. " <LINE>"
        else
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.ghs .. getText("Tooltip_Engine_Condition") .. " <LINE>"
        end

        local _enginePartsInInventory = self.chr:getInventory():getNumberOfItem("Base.EngineParts", false, true)
        local _partsCount = (math.floor(((100 - vehicle:getEngineQuality()) / 2)) + 1)
        local _engineParts = InventoryItemFactory.CreateItem("Base.EngineParts")

        if _enginePartsInInventory >= _partsCount then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.ghs .. _engineParts:getDisplayName() .. " " .. _enginePartsInInventory .. "/" ..  _partsCount .." <LINE>"
        else
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. _engineParts:getDisplayName() .. " " .. _partsCount .. "/" ..  _enginePartsInInventory .." <LINE>"
        end
        tooltip.description = tooltip.description .. " " .. "<RGB:0,1,1>" .. " " .. getText("Tooltip_vehicle_RepairEngineQualityWarning")
    end
end
