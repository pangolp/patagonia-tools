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
    end
    -- Do NOT setOverrideHandModels: vanilla vehicle-work actions leave it alone so the
    -- equipped tool shows and the animation plays normally (overriding it with the
    -- drainable broke the anim).
    self:setActionAnim(self.recipe.actionAnim or "VehicleWorkOnMid")
end

function ISPatagoniaRepairAction:stop()
    if self.item then
        self.item:setJobDelta(0)
    end
    ISBaseTimedAction.stop(self)
end

function ISPatagoniaRepairAction:perform()
    if self.item then
        self.item:setJobDelta(0)
    end
    ISBaseTimedAction.perform(self)

    local drainable = self.recipe.drainable
    if self.item and drainable and drainable.uses then
        for _ = 1, drainable.uses do
            self.item:Use()
        end
    end

    sendClientCommand(self.character, 'vehicle', 'patagoniaRepair', {
        vehicle  = self.vehicle:getId(),
        recipeId = self.recipe.id,
        partId   = self.part:getId(),
    })
end

function ISPatagoniaRepairAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    return self.maxTime
end

function ISPatagoniaRepairAction:new(character, part, recipe, item)
    -- Use the base constructor (like vanilla ISRepairEngine) so the action's
    -- internals (self.action, adjusted maxTime, progress bar, ...) are set up.
    local o = ISBaseTimedAction.new(self, character)
    o.part      = part
    o.vehicle   = part:getVehicle()
    o.recipe    = recipe
    o.item      = item
    o.maxTime   = recipe.time or 1000
    o.jobType   = getText(recipe.displayNameKey)
    -- Don't cancel the repair if the character is still settling from the walk (the
    -- pathToVehicleAdjacent used for seats can finish mid-step, which otherwise
    -- stop()s the action right after start). Same as vanilla ISOpenVehicleDoor.
    o.stopOnWalk = false
    o.stopOnRun  = false
    return o
end

-- ---------------------------------------------------------------------------
-- Path-to-vehicle-area that can never freeze the queue.
--
-- Vanilla ISPathFindAction:pathToVehicleArea polls the Java pathfinder and only
-- ends on Succeeded/Failed. In some setups (seen in MP, and for interior areas)
-- it returns neither — it just keeps "working" forever, so the whole action queue
-- froze and the repair never started. This subclass adds a tick timeout: if the
-- walk hasn't resolved in time, it force-completes so the repair runs in place.
-- When the path DOES resolve, it behaves exactly like the vanilla one (walks over).
-- ---------------------------------------------------------------------------
ISPatagoniaPathToArea = ISPathFindAction:derive("ISPatagoniaPathToArea")

function ISPatagoniaPathToArea:update()
    self.pgTicks = (self.pgTicks or 0) + 1
    if self.pgTicks >= (self.pgTimeout or 200) then
        self:forceComplete()
        return
    end
    ISPathFindAction.update(self)
end

-- Builds the timed action (mirrors ISPathFindAction:pathToVehicleArea but on this
-- subclass, so our update() with the timeout is used).
function ISPatagoniaPathToArea:toArea(character, vehicle, areaId, timeoutTicks)
    local o = ISPathFindAction.pathToVehicleArea(self, character, vehicle, areaId)
    o.pgTimeout = timeoutTicks or 200
    return o
end
