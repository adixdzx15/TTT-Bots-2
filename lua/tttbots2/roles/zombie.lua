if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_ZOMBIE then return false end
local allyTeams = {
    [TEAM_NECROMANCER] = true,
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
local traitor = TTTBots.RoleData.New("zombie", TEAM_NECROMANCER)
traitor:SetDefusesC4(false)
traitor:SetPlantsC4(false)
traitor:SetCanHaveRadar(false)
traitor:SetCanCoordinate(true)
traitor:SetStartsFights(true)
traitor:SetTeam(TEAM_NECROMANCER)
traitor:SetUsesSuspicion(false)
traitor:SetBTree(TTTBots.Behaviors.DefaultTrees.traitor)
traitor:SetAlliedTeams(allyTeams)
traitor:SetCanSnipe(true)
traitor:SetLovesTeammates(true)
TTTBots.Roles.RegisterRole(traitor)

return true

