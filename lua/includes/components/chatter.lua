---@class CChatter
TTTBots.Components.Chatter = TTTBots.Components.Chatter or {}

local lib = TTTBots.Lib
---@class CChatter
local BotChatter = TTTBots.Components.Chatter

function BotChatter:New(bot)
    local newChatter = {}
    setmetatable(newChatter, {
        __index = function(t, k) return BotChatter[k] end,
    })
    newChatter:Initialize(bot)

    local dbg = lib.GetConVarBool("debug_misc")
    if dbg then
        print("Initialized Chatter for bot " .. bot:Nick())
    end

    return newChatter
end

function BotChatter:Initialize(bot)
    -- print("Initializing")
    bot.components = bot.components or {}
    bot.components.Chatter = self

    self.componentID = string.format("Chatter (%s)", lib.GenerateID()) -- Component ID, used for debugging

    self.tick = 0                                                      -- Tick counter
    self.bot = bot
end

function BotChatter:SayRaw(text)
    self.bot:Say(text)
end

local RADIO = {
    quick_traitor = "%s is a Traitor!",
    quick_suspect = "%s acts suspicious."
}
function BotChatter:QuickRadio(msgName, msgTarget)
    hook.Run("TTTPlayerRadioCommand", self.bot, msgName, msgTarget)
    local txt = RADIO[msgName]
    if not txt then ErrorNoHalt("Unknown message type " .. msgName) end
    self.bot:Say(string.format(txt, msgTarget:Nick()))
end

--- A generic wrapper for when an event happens, to be implemented further in the future
---@param event_name string
---@param args table<any> A table of arguments passed to the event
function BotChatter:On(event_name, args)
    local dvlpr = lib.GetConVarBool("debug_misc")
    if dvlpr then
        print(string.format("Event %s called with %d args.", event_name, #args))
    end
end

function BotChatter:Think()

end
