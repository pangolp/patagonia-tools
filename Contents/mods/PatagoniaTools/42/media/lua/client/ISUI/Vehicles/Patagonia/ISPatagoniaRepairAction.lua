require "TimedActions/ISBaseTimedAction"

ISPatagoniaRepairAction = ISBaseTimedAction:derive("ISPatagoniaRepairAction")

function ISPatagoniaRepairAction:isValid()
    return true
end

function ISPatagoniaRepairAction:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISPatagoniaRepairAction:update()
    self.character:faceThisObject(self.vehicle)
    if self.item then
        self.item:setJobDelta(self:getJobDelta())
    end
    self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function ISPatagoniaRepairAction:start()
    if self.item then
        self.item:setJobType(self.jobType)
        self:setOverrideHandModels(self.item, nil)
    end
    self:setActionAnim(self.recipe.actionAnim or "VehicleWorkOnMid")
end

function ISPatagoniaRepairAction:stop()
    if self.item then
        self.item:setJobDelta(0)
    end
    ISBaseTimedAction.stop(self)
end

function ISPatagoniaRepairAction:perform()
    ISBaseTimedAction.perform(self)

    local drainable = self.recipe.drainable
    if self.item and drainable and drainable.uses then
        for _ = 1, drainable.uses do
            self.item:Use()
        end
        self.item:setJobDelta(0)
    end

    sendClientCommand(self.character, 'vehicle', 'patagoniaRepair', {
        vehicle  = self.vehicle:getId(),
        recipeId = self.recipe.id,
        partId   = self.part:getId(),
    })
end

function ISPatagoniaRepairAction:new(character, part, recipe, item)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle   = part:getVehicle()
    o.part      = part
    o.recipe    = recipe
    o.item      = item
    o.maxTime   = recipe.time or 1000
    o.jobType   = getText(recipe.displayNameKey)
    return o
end
