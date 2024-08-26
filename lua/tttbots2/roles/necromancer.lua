if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_NECROMANCER then return false end
local allyTeams = {
    [TEAM_NECROMANCER] = true,
    [TEAM_JESTER or 'jesters'] = true,
}

local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes

local traitor = TTTBots.RoleData.New("necromancer", TEAM_NECROMANCER)
traitor:SetDefusesC4(false)
traitor:SetPlantsC4(false)
traitor:SetCanHaveRadar(false)
traitor:SetCanCoordinate(true)
traitor:SetStartsFights(true)
traitor:SetTeam(TEAM_RAVENOUS)
traitor:SetUsesSuspicion(false)
traitor:SetBTree(TTTBots.Behaviors.DefaultTrees.traitor) -- TODO: add revival aspect
traitor:SetAlliedTeams(allyTeams)
traitor:SetCanSnipe(true)
traitor:SetLovesTeammates(true)
TTTBots.Roles.RegisterRole(traitor)

return true

