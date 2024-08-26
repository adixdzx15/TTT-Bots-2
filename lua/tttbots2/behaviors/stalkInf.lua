---wrapper class for Infected role (necessary, because developer did not bother creating different roles for vastly different playstyle)
---@class BStalkInf
TTTBots.Behaviors.StalkInf = {}

local lib = TTTBots.Lib

---@class Bot
---@field StalkTarget Player? The target to stalk
---@field StalkScore number The isolation score of the target

---@class BStalkInf
local StalkInf = TTTBots.Behaviors.StalkInf
StalkInf.Name = "StalkInf"
StalkInf.Description = "Either stalk a player (or random player) and ultimately kill them or just go full berserk"
StalkInf.Interruptible = true
--- Validate the behavior before we can start it (or continue running)
--- Returning false when the behavior was just running will still call OnEnd.
---@param bot Bot
---@return boolean
function StalkInf.Validate(bot)
    if INFECTEDS[bot] then
        return TTTBots.Behaviors.Stalk.Validate(bot)
    else
        return TTTBots.Behaviors.Ravage.Validate(bot)
    end
    end


--- Called when the behavior is started. Useful for instantiating one-time variables per cycle. Return STATUS.RUNNING to continue running.
---@param bot Bot
---@return BStatus
function StalkInf.OnStart(bot)
    if INFECTEDS[bot] then
        return TTTBots.Behaviors.Stalk.OnStart(bot)
    else
        return TTTBots.Behaviors.Ravage.OnStart(bot)
    end
end

--- Called when OnStart or OnRunning returns STATUS.RUNNING. Return STATUS.RUNNING to continue running.
---@param bot Bot
---@return BStatus
function StalkInf.OnRunning(bot)
    if INFECTEDS[bot] then
        return TTTBots.Behaviors.Stalk.OnRunning(bot)
    else
        return TTTBots.Behaviors.Ravage.OnRunning(bot)
    end
end

--- Called when the behavior returns a success state. Only called on success, however.
---@param bot Bot
function StalkInf.OnSuccess(bot)
    if INFECTEDS[bot] then
        TTTBots.Behaviors.Stalk.OnSuccess(bot)
    else
        TTTBots.Behaviors.Ravage.OnSuccess(bot)
    end
end

--- Called when the behavior returns a failure state. Only called on failure, however.
---@param bot Bot
function StalkInf.OnFailure(bot)
    if INFECTEDS[bot] then
        TTTBots.Behaviors.Stalk.OnFailure(bot)
    else
        TTTBots.Behaviors.Ravage.OnFailure(bot)
    end
end

--- Called when the behavior succeeds or fails. Useful for cleanup, as it is always called once the behavior is a) interrupted, or b) returns a success or failure state.
---@param bot Bot
function StalkInf.OnEnd(bot)
    if INFECTEDS[bot] then
        TTTBots.Behaviors.Stalk.OnEnd(bot)
    else
        TTTBots.Behaviors.Ravage.OnEnd(bot)
    end
end
