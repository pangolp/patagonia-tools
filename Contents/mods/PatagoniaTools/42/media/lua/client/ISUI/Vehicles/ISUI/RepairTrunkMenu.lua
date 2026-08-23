local originalDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

local function predicateDrainableUsesInt(item, count)
    return item:getDrainableUsesInt() >= count
end

local function predicateBlowTorch(item)
    return (item:hasTag("BlowTorch") or item:getType() == "BlowTorch") and item:getDrainableUsesInt() >= 10
end

local function predicateWeldingMask(item)
    return item:hasTag("WeldingMask") or item:getType() == "WeldingMask"
end

function ISVehicleMechanics:doPartContextMenu(part, x, y)
    originalDoPartContextMenu(self, part, x, y)

    if (part:getId() == "TruckBed" or part:getId() == "TruckBedOpen") and not VehicleUtils.RequiredKeyNotFound(part, self.chr) then
        local playerObj = getSpecificPlayer(self.playerNum)
        local vehicle = part:getVehicle()

        local _mechanicPerkLevel = (playerObj:getPerkLevel(Perks.Mechanics) <= 10)
        local _sheetMetalInInventory = (playerObj:getInventory():getNumberOfItem("Base.SheetMetal", false, true) >= 5)
        local _isNotRepair = (part:getCondition() < 100)
        local _blowTorchFullyCharged = (playerObj:getInventory():getFirstTypeEvalArgRecurse("Base.BlowTorch", predicateDrainableUsesInt, 10) ~= nil)

        if _mechanicPerkLevel and _sheetMetalInInventory and _isNotRepair and _blowTorchFullyCharged then
            local option = self.context:addOption(getText("IGUI_RestoreTrunk"), playerObj, ISVehicleMechanics.onRestoreTrunk, part)
            self:doMenuTooltip(part, option, "restore_trunk")
        else
            local option = self.context:addOption(getText("IGUI_RestoreTrunk"), playerObj, ISVehicleMechanics.onRestoreTrunk, part)
            self:doMenuTooltip(part, option, "restore_trunk")
            option.notAvailable = true
        end
    end
end

function ISVehicleMechanics.onRestoreTrunk(playerObj, part)
    if playerObj:getVehicle() then
        ISVehicleMenu.onExit(playerObj)
    end

    local item = playerObj:getInventory():getFirstTypeEvalArgRecurse("Base.BlowTorch", predicateDrainableUsesInt, 10)
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true)

    local mask = playerObj:getInventory():getFirstEvalRecurse(predicateWeldingMask)
    if mask then
        ISInventoryPaneContextMenu.wearItem(mask, playerObj:getPlayerNum())
    end

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
        ISTimedActionQueue.add(ISRestoreTrunk:new(playerObj, part, item, time))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    else
        ISTimedActionQueue.add(ISRestoreTrunk:new(playerObj, part, item, time))
    end
end

local originalDoMenuTooltip = ISVehicleMechanics.doMenuTooltip

function ISVehicleMechanics:doMenuTooltip(part, option, lua, name)
    originalDoMenuTooltip(self, part, option, lua, name)

    if lua == "restore_trunk" then
        local vehicle = part:getVehicle()
        local tooltip = ISToolTip:new()
        tooltip:initialise()
        tooltip:setVisible(false)
        tooltip.description = ""
        option.toolTip = tooltip

        if (part:getCondition() >= 100) then
            tooltip.description = string.format("%s %s <LINE>", tooltip.description, getText("Tooltip_part_full"))
            tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools", tooltip.description)
            return
        else
            tooltip.description = tooltip.description .. getText("Tooltip_craft_Needs") .. " : <LINE>"
        end

        local requiredLevel = 10
        if self.chr:getPerkLevel(Perks.Mechanics) < requiredLevel then
            rgb = ISVehicleMechanics.bhs
        else
            rgb = ISVehicleMechanics.ghs
        end

        tooltip.description = tooltip.description .. " " .. rgb .. getText("IGUI_perks_Mechanics") .. " " .. self.chr:getPerkLevel(Perks.Mechanics) .. "/" .. requiredLevel .. " <LINE>"

        if self.chr:getInventory():containsEvalRecurse(predicateWeldingMask) then
            tooltip.description = tooltip.description .. "<RGB:0,1,0> " .. getItemNameFromFullType("Base.WeldingMask") .. " 1 / 1" .. " <LINE>"
        else
            tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.WeldingMask") .. " 0 / 1" .. " <LINE>"
            option.notAvailable = true
        end

        local blowTorch = ISBlacksmithMenu.getBlowTorchWithMostUses(self.chr:getInventory())

        if blowTorch then
            local blowTorchUseLeft = blowTorch:getDrainableUsesInt()
            if blowTorchUseLeft >= 10 then
                tooltip.description = tooltip.description .. "<RGB:0,1,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. " / " .. 10 .. " <LINE>"
            else
                tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. blowTorchUseLeft .. " / " .. 10 .. " <LINE>"
            end
        else
            tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.BlowTorch") .. " 0 / 10" .. " <LINE>"
        end

        local _sheetMetalInInventory = self.chr:getInventory():getNumberOfItem("Base.SheetMetal", false, true)
        local _sheetMetalRequired = 5

        if _sheetMetalInInventory >= _sheetMetalRequired then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.ghs .. getItemNameFromFullType("Base.SheetMetal") .. " " .. _sheetMetalInInventory .. "/" ..  _sheetMetalRequired .." <LINE>"
        else
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. getItemNameFromFullType("Base.SheetMetal") .. " " .. _sheetMetalInInventory .. "/" ..  _sheetMetalRequired .." <LINE>"
        end

        tooltip.description = tooltip.description .. " " .. "<RGB:0,1,1>" .. " " .. getText("Tooltip_vehicle_RestoreTrunkWarning") .. " <LINE>"
        tooltip.description = tooltip.description .. "<RGB:1,1,1>Mod: Patagonia tools"
    end
end
