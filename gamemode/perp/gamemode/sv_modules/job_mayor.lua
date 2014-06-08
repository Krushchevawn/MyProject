GM.CityBudget = 5000
GM.CityBudget_LastIncome = 0
GM.CityBudget_LastExpenses = 0

GM.JobPaydayInfo[TEAM_MAYOR] = {"for serving as the mayor of this fine town.", 175}

local function StartMayorVote()
	print("MAYOR VOTE")
	if(GAMEMODE.MayorElection) then return end
	
	local numRunningForMayor = {}
	for k, v in pairs(player.GetAll()) do
		if (v.RunningForMayor) then
			table.insert(numRunningForMayor, v)
		end
	end
	if(#numRunningForMayor < 2) then return end
	//Msg("Starting mayor election with " .. #numRunningForMayor .. " contestants.\n")
	
	umsg.Start("perp_mayor_election")
		umsg.Short(#numRunningForMayor)
		
		for k, v in pairs(numRunningForMayor) do
			v.NumVotes = 0
			umsg.Entity(v)
		end
	umsg.End()
	
	GAMEMODE.MayorElection = CurTime() + 30
	GAMEMODE.TotalVotesCounted = 0
	GAMEMODE.VotesNeeded = table.Count(player.GetAll())
	timer.Create("GM.MonitorMayorVotes", 1, 0, function() GAMEMODE.MonitorMayorVotes() end)
end


local iLastSignup = CurTime()
function GM.Mayor_SignUp ( Player )
	if (Player:HasBlacklist(GAMEMODE.teamToBlacklist[TEAM_MAYOR])) then return end
	if (Player:Team() != TEAM_CITIZEN) then return end
	if (!Player:NearNPC(1)) then return end
	if (Player:GetSharedBool("warrent", false)) then return end
	if(iLastSignup > CurTime()) then Player:Notify("Please try again in two seconds.") return end
	iLastSignup = CurTime() + 2
	
	if (Player.RunningForMayor) then
		Player.RunningForMayor = nil
	else
		Player.RunningForMayor = true
	end
	
	if(GAMEMODE.MayorElection) then return end
	
	local numRunningForMayor = {}
	for k, v in pairs(player.GetAll()) do
		if (v.RunningForMayor) then
			table.insert(numRunningForMayor, v)
		end
	end
	
	if (#numRunningForMayor >= GAMEMODE.PeopleRequired_Mayor) then
		StartMayorVote()
	end
	timer.Create("ForceMayorVote", 180, 1, function() StartMayorVote() end)

end
concommand.Add("perp_g_b", GM.Mayor_SignUp)

function GM.MonitorMayorVotes ( )
	if (!GAMEMODE.MayorElection) then
		timer.Remove("GM.MonitorMayorVotes")
		return
	end
	
	if (GAMEMODE.TotalVotesCounted < GAMEMODE.VotesNeeded && GAMEMODE.MayorElection > CurTime()) then return end
	
	//Msg("Counting mayor votes... ")
	
	GAMEMODE.TotalVotesCounted = nil
	GAMEMODE.VotesNeeded = nil
	GAMEMODE.MayorElection = nil
	
	local largestVote_Count = -1
	local largestVote_Player
	
	for k, v in pairs(player.GetAll()) do
		v.MayorVoteCounted = nil
		
		if (v.RunningForMayor && v.NumVotes > largestVote_Count) then
			largestVote_Count = v.NumVotes
			largestVote_Player = v
			
			v.RunningForMayor = nil
			v.NumVotes = nil
		end
	end
	
	if (!largestVote_Player || !IsValid(largestVote_Player)) then
		//Msg("No mayor was chosen.\n")
	return end
	
	//Msg(largestVote_Player:Nick() .. " [ " .. largestVote_Player:GetRPName() .. " ] won election.\n")
	
	umsg.Start("perp_mayor_end")
		umsg.Entity(largestVote_Player)
		umsg.Short(largestVote_Count)
	umsg.End()
	
	
	for k,v in pairs(player.GetAll()) do
		v.RunningForMayor = nil
	end
	
	largestVote_Player:StripMains()
	largestVote_Player:SetTeam(TEAM_MAYOR)
	largestVote_Player.JobModel = JOB_MODELS[TEAM_MAYOR]
	largestVote_Player:SetModel(largestVote_Player.JobModel)
end

function GM.ReceivePlayerVote ( Player, Cmd, Args )
	if (!Player) then return end
	if (!Args[1]) then return end
	if (Player.MayorVoteCounted) then return end
	if (!GAMEMODE.MayorElection) then return end
	
	Player.MayorVoteCounted = true
	
	local votedFor_UID = Args[1]
	
	local votedFor_Player
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == votedFor_UID) then
			votedFor_Player = v
			break
		end
	end
	if (!votedFor_Player) then return end
	if (!votedFor_Player.RunningForMayor) then return end
	
	votedFor_Player.NumVotes = votedFor_Player.NumVotes + 1
	GAMEMODE.TotalVotesCounted = GAMEMODE.TotalVotesCounted + 1
end
concommand.Add("perp_g_v", GM.ReceivePlayerVote)

function GM.ReceiveDemoteCommand ( Player, Cmd, Args )
	if (!Player) then return end
	if (!Args[1] || !Args[2]) then return end
	if (Player:Team() != TEAM_MAYOR) then return end
	if (Player.NextDemoteAllowed && Player.NextDemoteAllowed > CurTime()) then return end
	Player.NextDemoteAllowed = CurTime() + 59
	
	local toChangeUID = Args[1]
	local reason = Args[2]
	
	local toChangePlayer
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toChangeUID) then
			toChangePlayer = v
			break
		end
	end
	if (!toChangePlayer) then Player:Notify("Could not find player.") return end
	if (Player == toChangePlayer) then return end
	
	if (toChangePlayer:Team() == TEAM_CITIZEN) then
		Player:Notify("You cannot demote a citizen.")
	return end
	
	if( toChangePlayer:DemoteFromJob() ) then
		Player:Notify("Player demoted.");
		toChangePlayer:Notify("You have been demoted by the mayor for '" .. reason .. "'");
	else
		Player:Notify("Error demoting player!");
	end
end
concommand.Add("perp_g_d", GM.ReceiveDemoteCommand)

function GM.ReceiveWarrentCommand ( Player, Cmd, Args )
	if (!Player) then return end
	if (!Args[1] || !Args[2]) then return end
	if (Player:Team() != TEAM_MAYOR and not game.SinglePlayer()) then return end
	if (Player.NextWarrentAllowed && Player.NextWarrentAllowed > CurTime()) then return end
	Player.NextWarrentAllowed = CurTime() + 9
	
	local toChangeUID = Args[1]
	local reason = Args[2]
	
	local toChangePlayer
	for k, v in pairs(player.GetAll()) do
		if (v:UniqueID() == toChangeUID) then
			toChangePlayer = v
			break
		end
	end
	if (!toChangePlayer) then Player:Notify("Could not find player.") return end
	if (toChangePlayer == Player) then return end
	
	if (toChangePlayer:IsGovernmentOfficial()) then
		Player:Notify("You cannot warrent a government official.")
	return end
	
	if (toChangePlayer:GetSharedBool("warrent", false)) then
		Player:Notify("That player is already warrented.")
	return end
	
	toChangePlayer:Warrant(reason)
	Player:Notify("Player warrented.")
	
	for k, v in pairs(team.GetPlayers(TEAM_POLICE)) do
		v:Notify(toChangePlayer:GetRPName() .. " has been warrented.")
	end
	

end
concommand.Add("perp_g_w", GM.ReceiveWarrentCommand)

local function MonitorPlayerWarrents ( )
	for k, v in pairs(player.GetAll()) do
		if (v.UnwarrentTime && v.UnwarrentTime < CurTime()) then
			v:SetSharedBool("warrent", false);
			v.UnwarrentTime = nil;
			
	
			for k, v in pairs(team.GetPlayers(TEAM_POLICE)) do
				v:Notify(toChangePlayer:GetRPName() .. "'s warrant has expired.");
			end
			
			for k, v in pairs(team.GetPlayers(TEAM_SWAT)) do
				v:Notify(toChangePlayer:GetRPName() .. "'s warrant has expired.");
			end
			
			for k, v in pairs(team.GetPlayers(TEAM_DISPATCHER)) do
				v:Notify(toChangePlayer:GetRPName() .. "'s warrant has expired.");
			end
		end
	end
end
hook.Add("Think", "MonitorPlayerWarrents", MonitorPlayerWarrents);
