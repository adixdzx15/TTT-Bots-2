if not TTTBots.Lib.IsTTT2() then return false end
if not ROLE_GLUTTON then return false end
local allyTeams = {
    [TEAM_TRAITOR] = true,
    [TEAM_JESTER or 'jesters'] = true,
}

local traitor = TTTBots.RoleData.New("glutton", TEAM_TRAITOR)
traitor:SetDefusesC4(false)
traitor:SetPlantsC4(false)
traitor:SetCanHaveRadar(false)
traitor:SetCanCoordinate(true)
traitor:SetStartsFights(true)
traitor:SetTeam(TEAM_TRAITOR)
traitor:SetUsesSuspicion(false)
traitor:SetBTree(TTTBots.Behaviors.DefaultTrees.traitor) -- TODO: add corpse interaction
traitor:SetAlliedTeams(allyTeams)
traitor:SetCanSnipe(true)
traitor:SetLovesTeammates(true)
TTTBots.Roles.RegisterRole(traitor)

return true
