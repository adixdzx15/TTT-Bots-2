if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_RAVENOUS then return false end
local allyTeams = {
    [TEAM_RAVENOUS] = true,
    [TEAM_JESTER or 'jesters'] = true,
}

local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes
local bTree = {
    _prior.FightBack,
    _bh.ravage,
    _prior.Investigate,
    _prior.Patrol
}

local traitor = TTTBots.RoleData.New("ravenous", TEAM_RAVENOUS)
traitor:SetDefusesC4(false)
traitor:SetPlantsC4(false)
traitor:SetCanHaveRadar(false)
traitor:SetCanCoordinate(true)
traitor:SetStartsFights(true)
traitor:SetTeam(TEAM_RAVENOUS)
traitor:SetUsesSuspicion(false)
traitor:SetBTree(bTree)
traitor:SetAlliedTeams(allyTeams)
traitor:SetCanSnipe(true)
traitor:SetLovesTeammates(true)
TTTBots.Roles.RegisterRole(traitor)

return true
