require "TimedActions/ISBaseTimedAction"

ISRepairEngineQuality = ISBaseTimedAction:derive("ISRepairEngineQuality")

function ISRepairEngineQuality:isValid()
    return true
end

function ISRepairEngineQuality:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISRepairEngineQuality:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())
    self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function ISRepairEngineQuality:start()
    self.item:setJobType(getText("IGUI_RepairEngineQuality"))
    self:setActionAnim("VehicleWorkOnMid")
end

function ISRepairEngineQuality:stop()
    self.item:setJobDelta(0)
    ISBaseTimedAction.stop(self)
end

function ISRepairEngineQuality:perform()
    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0)

    local _skill = self.character:getPerkLevel(Perks.Mechanics) - (self.vehicle:getScript():getEngineRepairLevel() + 2)
    local _numberOfParts = (math.floor((100 - self.vehicle:getEngineQuality()) / 2) + 1)
    local _currentQuality = self.vehicle:getEngineQuality()

    local args = {
        vehicle = self.vehicle:getId(),
        currentQuality = _currentQuality,
        skillLevel = _skill,
        numberOfParts = _numberOfParts
    }

    sendClientCommand(self.character, 'vehicle', 'repairEngineQuality', args)
end

function ISRepairEngineQuality:new(character, part, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.item = item
    o.maxTime = time
    o.jobType = getText("IGUI_RepairEngineQuality")
    return o
end
