--- This file is a base behavior meta file. It is not used in code, and is merely present for Intellisense and prototyping.
---@meta

TTTBots.Behaviors = TTTBots.Behaviors or {}

---@class BDefib
TTTBots.Behaviors.Defib = {}

local lib = TTTBots.Lib

---@class BDefib
local Defib = TTTBots.Behaviors.Defib
Defib.Name = "Defib"
Defib.Description = "Use the defibrillator on a corpse."
Defib.Interruptible = true
Defib.WeaponClasses = { "weapon_ttt_defibrillator" }

---@enum BStatus
local STATUS = {
    RUNNING = 1,
    SUCCESS = 2,
    FAILURE = 3,
}

---Get the closest revivable corpse to our bot
---@param bot any
---@param allyOnly boolean
---@return Player? closest
---@return any? ragdoll
function Defib.GetCorpse(bot, allyOnly)
    local closest, rag = TTTBots.Lib.GetClosestReviable(bot, allyOnly or true)
    if not closest then return end

    local canSee = lib.CanSeeArc(bot, rag:GetPos() + Vector(0, 0, 16), 120)
    if canSee then
        return closest, rag
    end
end

function Defib.HasDefib(bot)
    for i, class in pairs(Defib.WeaponClasses) do
        if bot:HasWeapon(class) then return true end
    end

    return false
end

function Defib.GetDefib(bot)
    for i, class in pairs(Defib.WeaponClasses) do
        local wep = bot:GetWeapon(class)
        if IsValid(wep) then return wep end
    end
end

function Defib.ValidateCorpse(bot, corpse)
    return lib.IsValidBody(corpse or bot.defibRag)
end

function Defib.Validate(bot)
    if bot.preventDefib then return false end -- just an extra feature to prevent defibbing

    -- cant defib without defib
    local hasDefib = Defib.HasDefib(bot)
    if not hasDefib then return false end

    -- re-use existing
    local hasCorpse = Defib.ValidateCorpse(bot, bot.defibRag)
    if hasCorpse then return true end

    -- get new target
    local corpse, rag = Defib.GetCorpse(bot, true)
    if not corpse then return false end

    -- one last valid check
    return Defib.ValidateCorpse(bot, rag)
end

function Defib.OnStart(bot)
    bot.defibTarget, bot.defibRag = Defib.GetCorpse(bot, true)

    return STATUS.RUNNING
end

---@param bot Player
function Defib.OnRunning(bot)
    local inventory, loco = bot:BotInventory(), bot:BotLocomotor()
    if not (inventory and loco) then return STATUS.FAILURE end

    local defib = Defib.GetDefib(bot)
    local target = bot.defibTarget
    local rag = bot.defibRag
    if not (IsValid(target) and IsValid(rag) and IsValid(defib)) then return STATUS.FAILURE end
    local ragPos = rag:GetPos()

    loco:SetGoal(ragPos)
    loco:LookAt(ragPos)

    if loco:IsCloseEnough(ragPos) then
        inventory:PauseAutoSwitch()
        bot:SetActiveWeapon(defib)
        loco:StartAttack()
    else
        loco:StopAttack()
        inventory:ResumeAutoSwitch()
    end

    return STATUS.RUNNING
end

function Defib.OnSuccess(bot) end

function Defib.OnFailure(bot) end

--- Called when the behavior succeeds or fails. Useful for cleanup, as it is always called once the behavior is a) interrupted, or b) returns a success or failure state.
---@param bot Player
function Defib.OnEnd(bot)
    bot.defibTarget, bot.defibRag = nil, nil
    local inventory, loco = bot:BotInventory(), bot:BotLocomotor()
    if not (inventory and loco) then return end

    loco:StopAttack()
    inventory:ResumeAutoSwitch()
end
