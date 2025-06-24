require "TimedActions/ISBaseTimedAction"

ISRepairGloveBox = ISBaseTimedAction:derive("ISRepairGloveBox")

function ISRepairGloveBox:isValid()
    return true
end

function ISRepairGloveBox:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISRepairGloveBox:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())
    self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function ISRepairGloveBox:start()
    self.item:setJobType(getText("IGUI_Repair_Glove_Box"))
    self:setActionAnim("VehicleWorkOnMid")
    self:setOverrideHandModels(self.item, nil)
end

function ISRepairGloveBox:stop()
    if self.item then
        self.item:setJobDelta(0)
    end
    ISBaseTimedAction.stop(self)
end

function ISRepairGloveBox:perform()

    ISBaseTimedAction.perform(self)

    for i = 1, 10 do
        self.item:Use()
    end

    self.item:setJobDelta(0)

    local args = {
        vehicle = self.vehicle:getId()
    }

    sendClientCommand(self.character, 'vehicle', 'repairGloveBox', args)
end

function ISRepairGloveBox:new(character, part, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.item = item
    o.maxTime = time
    o.jobType = getText("IGUI_Repair_Glove_Box")
    return o
end
