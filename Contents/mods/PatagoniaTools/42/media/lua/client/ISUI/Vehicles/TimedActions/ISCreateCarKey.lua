require "TimedActions/ISBaseTimedAction"

ISCreateCarKey = ISBaseTimedAction:derive("ISCreateCarKey")

function ISCreateCarKey:isValid()
    return true
end

function ISCreateCarKey:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISCreateCarKey:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())

    if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("Dismantle")
    end

    self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function ISCreateCarKey:start()
    self.item:setJobType(getText("IGUI_CreateCarKey"))
    self:setActionAnim("Disassemble")
    self:setOverrideHandModels(self.item, nil)
    self.sound = self.character:playSound("Dismantle")
end

function ISCreateCarKey:stop()
    if self.item then
        self.item:setJobDelta(0)
    end

    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.stop(self)
end

function ISCreateCarKey:perform()
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.perform(self)
    self.item:setJobDelta(0)

    local args = {
        vehicle = self.vehicle:getId()
    }

    sendClientCommand(self.character, 'vehicle', 'createCarKey', args)
end

function ISCreateCarKey:new(character, part, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.item = item
    o.maxTime = time
    o.jobType = getText("IGUI_CreateCarKey")
    return o
end
