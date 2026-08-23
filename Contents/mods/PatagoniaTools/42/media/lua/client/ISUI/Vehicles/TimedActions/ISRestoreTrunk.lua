require "TimedActions/ISBaseTimedAction"

ISRestoreTrunk = ISBaseTimedAction:derive("ISRestoreTrunk")

function ISRestoreTrunk:isValid()
    return true
end

function ISRestoreTrunk:waitToStart()
    self.character:faceThisObject(self.vehicle)
    return self.character:shouldBeTurning()
end

function ISRestoreTrunk:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())
    self.item:setJobType(getText("IGUI_RestoreTrunk"))

    if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("BlowTorch")
    end

    self.character:setMetabolicTarget(Metabolics.HeavyWork);
end

function ISRestoreTrunk:start()
    self.item = self.character:getPrimaryHandItem()
    self:setActionAnim("BlowTorch")
    self:setOverrideHandModels(self.item, nil)
    self.sound = self.character:playSound("BlowTorch")
end

function ISRestoreTrunk:stop()
    if self.item then
        self.item:setJobDelta(0)
    end

    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.stop(self)
end

function ISRestoreTrunk:perform()
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end

    ISBaseTimedAction.perform(self)

    for i=1,10 do
        self.item:Use()
    end

    self.item:setJobDelta(0)

    local _skill = 10
    local _numberOfParts = 5

    local args = {
        vehicle = self.vehicle:getId(),
        skillLevel = _skill,
        numberOfParts = _numberOfParts,
        item = self.item
    }

    sendClientCommand(self.character, 'vehicle', 'restoreTrunk', args)
end

function ISRestoreTrunk:new(character, part, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = part:getVehicle()
    o.part = part
    o.item = item
    o.maxTime = time
    o.jobType = getText("IGUI_RestoreTrunk")
    return o
end
