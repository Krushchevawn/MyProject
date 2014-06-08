local NPC = {}

NPC.Name = "Road Services"
NPC.ID = 24

//NPC.Model = Model("models/players/perp2/m_2_06.mdl")
NPC.Model = Model(PERPGetModelPath(1, 2, 6))


NPC.Location = Vector( 612.867737, 4477.929199, 72.0313)
NPC.Angles = Angle(0, 90, 0)

NPC.ShowChatBubble = "VIP"

NPC.Sequence = 3;

// This is always local player.
function NPC.OnTalk ( )
	if LocalPlayer():Team() == TEAM_ROADSERVICE then
		GAMEMODE.DialogPanel:SetDialog("Hello, can I help you?")
		
		GAMEMODE.DialogPanel:AddDialog("Are there any trucks available?", NPC.Trucks)
		GAMEMODE.DialogPanel:AddDialog("This job is too much for me. I'm here to quit.", NPC.QuitJob)
		GAMEMODE.DialogPanel:AddDialog("No. Just having a look around.", LEAVE_DIALOG)
	elseif LocalPlayer():Team() == TEAM_MAYOR then
		GAMEMODE.DialogPanel:SetDialog("Can I help you, Mr. Mayor?")
		
		GAMEMODE.DialogPanel:AddDialog("Not that I know of...", LEAVE_DIALOG)
	elseif LocalPlayer():Team() == TEAM_CITIZEN then
		GAMEMODE.DialogPanel:SetDialog("Hello. Are you here for a checkup?")
		
		GAMEMODE.DialogPanel:AddDialog("I'm actually interested in becoming a road service worker.", NPC.Hire)
		GAMEMODE.DialogPanel:AddDialog("No. Just having a look around.", LEAVE_DIALOG)
	elseif LocalPlayer():Team() == TEAM_FIREMAN then
		GAMEMODE.DialogPanel:SetDialog("Thank you for protecting us from the ravages of fire!")
		
		GAMEMODE.DialogPanel:AddDialog("You're quite welcome, sir.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Hello.")
		
		GAMEMODE.DialogPanel:AddDialog("Hi...", LEAVE_DIALOG)
	end
	
	GAMEMODE.DialogPanel:Show()
end

function NPC.QuitJob ( )
	LEAVE_DIALOG()
	
	RunConsoleCommand('perp_rs_q')	
end

function NPC.Hire ( )
	local FiremanNumber = team.NumPlayers(TEAM_ROADSERVICE)
	
	if (FiremanNumber >= GAMEMODE.MaximumRoadService) then
		GAMEMODE.DialogPanel:SetDialog("We have more help than we currently need, sorry.\n\n(This class is full. Try again later.)")
		
		GAMEMODE.DialogPanel:AddDialog("Alright. I'll check back in later, then.", LEAVE_DIALOG)	
	elseif (LocalPlayer():HasBlacklist(GAMEMODE.teamToBlacklist[TEAM_ROADSERVICE])) then
		local expires = LocalPlayer():HasBlacklist(GAMEMODE.teamToBlacklist[TEAM_ROADSERVICE])
		
		if (expires == 0) then
			GAMEMODE.DialogPanel:SetDialog("I don't think I can trust you after what happened last time.\n\n(You are permanently blacklisted from this occupation.)")
		elseif (GAMEMODE.Options_EuroStuff:GetBool()) then
			GAMEMODE.DialogPanel:SetDialog("I don't think I can trust you after what happened last time.\n\n(You are currently blacklisted from this occupation. Expires on " .. os.date("%B %d, 20%y at %H:%M", expires) .. ".)")
		else
			GAMEMODE.DialogPanel:SetDialog("I don't think I can trust you after what happened last time.\n\n(You are currently blacklisted from this occupation. Expires on " .. os.date("%B %d, 20%y at %I:%M %p", expires) .. ".)")
		end
		
		GAMEMODE.DialogPanel:AddDialog("Oh, right...", LEAVE_DIALOG)	
	elseif (LocalPlayer():GetTimePlayed() < GAMEMODE.RequiredTime_RoadService * 60 * 60 or !LocalPlayer():IsGoldMember()) then
		GAMEMODE.DialogPanel:SetDialog("Sorry, but it appears that you are not qualified for this position.\n\n(You need at least " .. GAMEMODE.RequiredTime_RoadService .. " hours of play time and GOLD to be a road worker.)")
		
		GAMEMODE.DialogPanel:AddDialog("Alright. I'll check back in later, then.", LEAVE_DIALOG)	
	elseif (GAMEMODE.IsRunningForMayor) then
		GAMEMODE.DialogPanel:SetDialog("Business laws state that we cannot hire mayor nominees. Sorry.\n\n(You cannot be a road service worker while running for mayor.)")
		
		GAMEMODE.DialogPanel:AddDialog("Ahh, yes. I wouldn't have the time.", LEAVE_DIALOG)	
	else
		GAMEMODE.DialogPanel:SetDialog("Yes, you seem qualified.\n\n(If you abuse your new-found power, you will be blacklisted and possibly banned.)")
		
		RunConsoleCommand('perp_rs_j')
		
		GAMEMODE.DialogPanel:AddDialog("Thank you. I'll be sure to attend to any who need some help.", LEAVE_DIALOG)			
	end
end

function NPC.Trucks ( )
	local numFireCars = 0
	
	for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
		local vT = lookForVT(v)
		
		if (vT && vT.RequiredClass == TEAM_ROADSERVICE && v:GetSharedEntity("owner", nil) != LocalPlayer()) then
			numFireCars = numFireCars + 1
		end
	end
	
	if (!LocalPlayer():IsGoldMember() && numFireCars >= GAMEMODE.MaxRoadServiceTrucks) then
		GAMEMODE.DialogPanel:SetDialog("Sorry, but all of the trucks have been taken out on duty.\n\n(All trucks are taken wait until someone who is using one quits the job or get Gold benefits.)")
				
		GAMEMODE.DialogPanel:AddDialog("Okay, I'll check back later.", LEAVE_DIALOG)	
	else
		GAMEMODE.DialogPanel:SetDialog("Sure, here are the keys.\n\n(Your truck can be found right next to you.)")
		
		RunConsoleCommand('perp_rs_c')
		
		GAMEMODE.DialogPanel:AddDialog("Thank you, sir!", LEAVE_DIALOG)		
	end
end

GAMEMODE:LoadNPC(NPC)