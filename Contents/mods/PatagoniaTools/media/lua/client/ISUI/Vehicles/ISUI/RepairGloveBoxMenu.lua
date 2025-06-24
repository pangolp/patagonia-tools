local originalDoPartContextMenu = ISVehicleMechanics.doPartContextMenu

local function predicateNeedle(item)
    return item:hasTag("Needle") or item:getType() == "Needle"
end

local function predicateDrainableUsesInt(item, count)
    return item:getDrainableUsesInt() >= count
end

local function comparatorDrainableUsesInt(item1, item2)
    return item1:getDrainableUsesInt() - item2:getDrainableUsesInt()
end

local function getThreadWithMostUses(container)
    return container:getBestTypeEvalRecurse("Base.Thread", comparatorDrainableUsesInt)
end

function ISVehicleMechanics:doPartContextMenu(part, x, y)
    originalDoPartContextMenu(self, part, x, y)

    if (part:getId() == "GloveBox" and not VehicleUtils.RequiredKeyNotFound(part, self.chr)) then
        local playerObj = getSpecificPlayer(self.playerNum)
        local vehicle = part:getVehicle()

        local option = self.context:addOption(getText("IGUI_Repair_Glove_Box"), playerObj, ISVehicleMechanics.onRepairGloveBox, part)
        self:doMenuTooltip(part, option, "repair_glove_box")
    end
end

function ISVehicleMechanics.onRepairGloveBox(playerObj, part)

    if playerObj:getVehicle() then
        ISVehicleMenu.onExit(playerObj)
    end

    local item = playerObj:getInventory():getFirstTypeEvalArgRecurse("Base.Thread", predicateDrainableUsesInt, 10)
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateNeedle, true)

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
        ISTimedActionQueue.add(ISRepairGloveBox:new(playerObj, part, item, time))
        ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    else
        ISTimedActionQueue.add(ISRepairGloveBox:new(playerObj, part, item, time))
    end
end

local originalDoMenuTooltip = ISVehicleMechanics.doMenuTooltip

function ISVehicleMechanics:doMenuTooltip(part, option, lua, name)
    originalDoMenuTooltip(self, part, option, lua, name)

    if lua == "repair_glove_box" then
        local vehicle = part:getVehicle()
        local tooltip = ISToolTip:new()
        tooltip:initialise()
        tooltip:setVisible(false)
        tooltip.description = ""
        option.toolTip = tooltip

        if (part:getCondition() >= 100) then
            tooltip.description = string.format("%s %s <LINE>", tooltip.description, getText("Tooltip_part_full"))
            tooltip.description = string.format("%s <RGB:0,1,1> %s <LINE>", tooltip.description, getText("Tooltip_vehicle_Repair_Glove_Box"))
            tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools", tooltip.description)
            option.notAvailable = true
            return
        else
            tooltip.description = tooltip.description .. getText("Tooltip_craft_Needs") .. " : <LINE>"
        end

        local tailoringLevel = 8
        if self.chr:getPerkLevel(Perks.Tailoring) < tailoringLevel then
            rgb = ISVehicleMechanics.bhs
            option.notAvailable = true
        else
            rgb = ISVehicleMechanics.ghs
        end

        tooltip.description = tooltip.description .. " " .. rgb .. getText("IGUI_perks_Tailoring") .. " " .. self.chr:getPerkLevel(Perks.Tailoring) .. "/" .. tailoringLevel .. " <LINE>"

        if self.chr:getInventory():containsEvalRecurse(predicateNeedle) then
            tooltip.description = tooltip.description .. "<RGB:0,1,0> " .. getItemNameFromFullType("Base.Needle") .. " 1 / 1" .. " <LINE>"
        else
            tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.Needle") .. " 0 / 1" .. " <LINE>"
            option.notAvailable = true
        end

        local thread = getThreadWithMostUses(self.chr:getInventory())

        if thread then
            local threadUseLeft = thread:getDrainableUsesInt()
            if threadUseLeft >= 10 then
                tooltip.description = tooltip.description .. "<RGB:0,1,0> " .. getItemNameFromFullType("Base.Thread") .. " " .. getText("ContextMenu_Uses") .. " " .. threadUseLeft .. " / " .. 10 .. " <LINE>"
            else
                tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.Thread") .. " " .. getText("ContextMenu_Uses") .. " " .. threadUseLeft .. " / " .. 10 .. " <LINE>"
                option.notAvailable = true
            end
        else
            tooltip.description = tooltip.description .. "<RGB:1,0,0> " .. getItemNameFromFullType("Base.Thread") .. " 0 / 10" .. " <LINE>"
            option.notAvailable = true
        end

        local _leatherStripsInInventory = self.chr:getInventory():getNumberOfItem("LeatherStrips", false, true)
        local _leatherStripsRequired = 10

        if _leatherStripsInInventory >= _leatherStripsRequired then
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.ghs .. getItemNameFromFullType("Base.LeatherStrips") .. " " .. _leatherStripsInInventory .. "/" ..  _leatherStripsRequired .." <LINE>"
        else
            tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. getItemNameFromFullType("Base.LeatherStrips") .. " " .. _leatherStripsInInventory .. "/" ..  _leatherStripsRequired .." <LINE>"
            option.notAvailable = true
        end

        tooltip.description = string.format("%s <RGB:0,1,1> %s <LINE>", tooltip.description, getText("Tooltip_vehicle_Repair_Glove_Box"))
        tooltip.description = string.format("%s <RGB:1,1,1>Mod: Patagonia tools.", tooltip.description)
    end
end
