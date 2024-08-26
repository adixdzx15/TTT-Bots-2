if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_INFECTED then return false end
local allyTeams = {
    [TEAM_INFECTED] = true
}
local _bh = TTTBots.Behaviors
local _prior = TTTBots.Behaviors.PriorityNodes
local bTree = {
    _prior.FightBack,
    _bh.StalkInf,
    -- _prior.Minge,
    _prior.Investigate,
    _prior.Patrol
}
local infected = TTTBots.RoleData.New("infected", TEAM_INFECTED)
infected:SetDefusesC4(false)
infected:SetPlantsC4(false)
infected:SetCanHaveRadar(true)
infected:SetCanCoordinate(false)
infected:SetStartsFights(true)
infected:SetTeam(TEAM_INFECTED)
infected:SetUsesSuspicion(false)
infected:SetBTree(bTree)
infected:SetAlliedTeams(allyTeams)
infected:SetCanSnipe(false)
TTTBots.Roles.RegisterRole(infected)

return true
