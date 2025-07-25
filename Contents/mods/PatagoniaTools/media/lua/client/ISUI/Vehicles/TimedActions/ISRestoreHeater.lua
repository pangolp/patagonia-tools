require "TimedActions/ISBaseTimedAction"

ISRestoreHeater = ISBaseTimedAction:derive("ISRestoreHeater")

function ISRestoreHeater:isValid()
    return true
end

function ISRestoreHeater:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISRestoreHeater:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())

    if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Dismantle")
    end

    self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function ISRestoreHeater:start()
    self.item:setJobType(getText("IGUI_Restore_Heater"))
    self:setActionAnim("Disassemble")
    self:setOverrideHandModels(self.item, nil)
    self.sound = self.character:playSound("Dismantle")
end

function ISRestoreHeater:stop()
    if self.item then
        self.item:setJobDelta(0)
    end

    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.stop(self)
end

function ISRestoreHeater:perform()
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0)

    local args = {
        vehicle = self.vehicle:getId()
    }

    sendClientCommand(self.character, 'vehicle', 'repairHeater', args)
end

function ISRestoreHeater:new(character, part, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.item = item
    o.maxTime = time
    o.jobType = getText("IGUI_Restore_Heater")
    return o
end
