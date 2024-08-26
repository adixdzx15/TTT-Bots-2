

---@class BRavage
TTTBots.Behaviors.Ravage = {}

local lib = TTTBots.Lib

---@class Bot
---@field RavageTarget Player? The target to ravage
---@field RavageScore number The isolation score of the target

---@class BRavage
local Ravage = TTTBots.Behaviors.Ravage
Ravage.Name = "Ravage"
Ravage.Description = "Ravage a player (or random player) and ultimately kill them."
Ravage.Interruptible = true


local STATUS = TTTBots.STATUS


---Find the best target to ravage, and return it. This is a pretty expensive function, so don't call it too often.
---@param bot Bot
---@return Player?
---@return number
function Ravage.FindTarget(bot)
    return lib.FindCloseTarget(bot)
end

function Ravage.ClearTarget(bot)
    bot.RavageTarget = nil
end

---Sets the target to target, or if target is nil, then it will find a new target. If you want to clear the target, then see Ravage.ClearTarget.
---@see Ravage.ClearTarget
---@param bot Bot
---@param target Player?
---@param isolationScore number?
function Ravage.SetTarget(bot, target, isolationScore)
    bot.RavageTarget = target or Ravage.FindTarget(bot)
end

function Ravage.GetTarget(bot)
    return bot.RavageTarget
end

---validate if we can attack the bot's target, or the given target if applicable.
---@param bot Bot
---@param target? Player
---@return boolean
function Ravage.ValidateTarget(bot, target)
    local target = target or Ravage.GetTarget(bot)
    local valid = target and IsValid(target) and lib.IsPlayerAlive(target)
    return valid
end

---Should we start ravageing? This is only useful for when we don't already have a target. To make the behavior more varied.
---@param bot Bot
---@return boolean
function Ravage.ShouldStartRavageing(bot)
    -- local chance = math.random(0, 100) <= 2
    return TTTBots.Match.IsRoundActive() -- and chance
end

---Since situations change quickly, we want to make sure we pick the best target for the situation when we can.
---@param bot Bot
function Ravage.CheckForBetterTarget(bot)
    local currentScore = bot.RavageScore or -math.huge
    local alternative, altScore = Ravage.FindTarget(bot)

    if not alternative then return end
    if not Ravage.ValidateTarget(bot, alternative) then return end

    -- check for a difference of at least +1
    if altScore and altScore - currentScore >= 1 then
        Ravage.SetTarget(bot, alternative, altScore)
    end
end

--- Validate the behavior before we can start it (or continue running)
--- Returning false when the behavior was just running will still call OnEnd.
---@param bot Bot
---@return boolean
function Ravage.Validate(bot)
    if not IsValid(bot) then return false end
    return Ravage.ValidateTarget(bot) or Ravage.ShouldStartRavageing(bot)
end

--- Called when the behavior is started. Useful for instantiating one-time variables per cycle. Return STATUS.RUNNING to continue running.
---@param bot Bot
---@return BStatus
function Ravage.OnStart(bot)
    if not Ravage.ValidateTarget(bot) then
        Ravage.SetTarget(bot)
    end
    -- equip special weapon (most mindless killer roles have a special weapon for that purpose)
    local inv = bot.components.inventory ---@type CInventory
    inv.Equip(inv.GetBySlot("WEAPON_SPECIAL"):GetPrintName())
    return STATUS.RUNNING
end

--- Called when OnStart or OnRunning returns STATUS.RUNNING. Return STATUS.RUNNING to continue running.
---@param bot Bot
---@return BStatus
function Ravage.OnRunning(bot)
    -- Ravage.CheckForBetterTarget(bot)
    if not Ravage.ValidateTarget(bot) then return STATUS.FAILURE end
    local target = Ravage.GetTarget(bot)
    local targetPos = target:GetPos()
    local targetEyes = target:EyePos()

    local isClose = bot:Visible(target) and bot:GetPos():Distance(targetPos) <= 150
    local loco = bot:BotLocomotor()
    if not loco then return STATUS.FAILURE end
    loco:SetGoal(targetPos)
    if not isClose then return STATUS.RUNNING end
    loco:LookAt(targetEyes)
    loco:SetGoal()
    bot:SetAttackTarget(target)
    return STATUS.SUCCESS
end

--- Called when the behavior returns a success state. Only called on success, however.
---@param bot Bot
function Ravage.OnSuccess(bot)
end

--- Called when the behavior returns a failure state. Only called on failure, however.
---@param bot Bot
function Ravage.OnFailure(bot)
end

--- Called when the behavior succeeds or fails. Useful for cleanup, as it is always called once the behavior is a) interrupted, or b) returns a success or failure state.
---@param bot Bot
function Ravage.OnEnd(bot)
    Ravage.ClearTarget(bot)
end
