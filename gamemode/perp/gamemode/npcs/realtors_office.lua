local NPC = {};

NPC.Name = "Realtor";
NPC.ID = 3;

//NPC.Model = Model("models/players/PERP2/f_1_02.mdl");
NPC.Model = Model(PERPGetModelPath(2, 1, 2))

NPC.Location = Vector(-7580.03, -7815.23, 72.0313);
NPC.Angles = Angle(0, 0, 0.000000);
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;

local weps = {"ak47", "deagle", "fiveseven", "glock", "molotov", "shotgun", "uzi", "m4a1", "mp5" }

function NPC.OnTalk ( )
	local bFound = false
	for k, v in pairs(weps) do
		if(LocalPlayer():GetActiveWeapon():GetClass():find(v)) then
			bFound = true
		end
	end
	
	if(bFound) then
		if(LocalPlayer():Team() == TEAM_CITIZEN) then
			GAMEMODE.DialogPanel:SetDialog("Holy fuck, why are you pointing a gun at me!?!?")
		
			GAMEMODE.DialogPanel:AddDialog("HANDS UP! THIS IS A ROBBERY! GIVE ME ALL YOUR MONEY!", function()
			RunConsoleCommand("perp_realtor_rob")
			
			
			end)
			GAMEMODE.DialogPanel:AddDialog("Nice gun eh, I just wanted to show it off.", LEAVE_DIALOG)
			
			GAMEMODE.DialogPanel:Show()
		else
			GAMEMODE.DialogPanel:SetDialog("Why are you pointing a gun at me? I don't think your boss is gonna like this..")
		
			GAMEMODE.DialogPanel:AddDialog("Sorry I just wanted to make sure it's still shiny.", LEAVE_DIALOG)
			
			GAMEMODE.DialogPanel:Show()

		end
	else
		GAMEMODE.MakeRealtorScreen()
	end
end

function NPC.RealtorNoMoney()
	GAMEMODE.DialogPanel:SetDialog("I'm sorry, but someone else already robbed us recently. We have no money.")
	
	GAMEMODE.DialogPanel:AddDialog("Oh.. OK I was just kidding anyways..", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show()
end
usermessage.Hook("derp_realtor_nomoney", NPC.RealtorNoMoney)

function NPC.RealtorGiveMoney()
	GAMEMODE.DialogPanel:SetDialog("Woa woa p-please don't kill me here I am trying to get all your money together.. p-p-please don't kill me!")
	
	GAMEMODE.DialogPanel:AddDialog("YOU BETTER HURRY THE FUCK UP!", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show()
end
usermessage.Hook("derp_realtor_givemoney", NPC.RealtorGiveMoney)

function NPC.RealtorTimer()
	GAMEMODE.DialogPanel:SetDialog("You can only attempt to rob the bank every 15 minutes.")
	
	GAMEMODE.DialogPanel:AddDialog("Okay, fine I'll come back later.", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show()
end
usermessage.Hook("derp_realtor_timer", NPC.RealtorTimer)

function NPC.AlreadyGettingRobbed()
	GAMEMODE.DialogPanel:SetDialog("HEY, IM ALREADY GETTING ROBBED. STOP!")
	
	GAMEMODE.DialogPanel:AddDialog("Okay. I'll be back later", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show()
end
usermessage.Hook("derp_realtor_robbed", NPC.AlreadyGettingRobbed)

function NPC.NoCopsOn()
	GAMEMODE.DialogPanel:SetDialog("Money isn't free! You can't rob with no cops on.")
	
	GAMEMODE.DialogPanel:AddDialog("Okay. I'll be back later", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show()
end
usermessage.Hook("derp_realtor_nocops", NPC.NoCopsOn)

GAMEMODE:LoadNPC(NPC);

if(SERVER) then
	function GAMEMODE.RealtorRobAddTimer ( )
		SetSharedInt('perp_realtor_money', math.Clamp(GetSharedInt("perp_realtor_money") + math.random(60, 100), 1, 35000))
	end
	timer.Create('perp_realtor_money', 30, 0, function() GAMEMODE.RealtorRobAddTimer() end)
	
	local function Alarm(objNPC)
		if(objNPC.AlarmSound) then return end
		
		objNPC.AlarmSound = CreateSound(objNPC, "ambient/alarms/alarm1.wav")
		objNPC.AlarmSound:Play()
	end
	
	local function RealtorRob(objPl, _, tblArgs)
		if(objPl:Team() != TEAM_CITIZEN) then return end
		
		if(team.NumPlayers(TEAM_POLICE) == 0 and team.NumPlayers(TEAM_SWAT) == 0) then
			umsg.Start("derp_realtor_nocops", objPl)
			umsg.End()
			return
		end
		
		if (GetSharedBool("perp_bank_robbing_timer")) then
			umsg.Start("derp_realtor_timer", objPl)
			umsg.End()
		else
			local objNPC
			for k, v in pairs(ents.FindByClass("npc_vendor")) do
				if (v.NPCID == 3) then
					objNPC = v
				end
			end
			
			if(objNPC:GetPos():Distance(objPl:GetPos()) > 2000) then return end
			local bFound = false
			for k, v in pairs(weps) do
				if(IsValid(objPl:GetActiveWeapon()) and objPl:GetActiveWeapon():GetClass():find(v)) then
					bFound = true
				end
			end
			
			if(not bFound) then return end
			
			objPl:ConCommand("say /y HANDS UP! THIS IS A ROBBERY! GIVE ME ALL YOUR MONEY!")
			if(GetSharedInt("perp_realtor_money") > 2000) then
				umsg.Start("derp_realtor_givemoney", objPl)
				umsg.End()
				objPl:Notify("Bank robbery started, if you leave the bank, you will not be paid");
				
				timer.Simple(math.random(30, 60), function()
					
					if(objNPC.AlarmSound) then
						objNPC.AlarmSound:Stop()
						objNPC.AlarmSound = nil
					end
					
					if ( !IsValid(objPl) || !objPl:Alive() ) then return; end
					
					bFound = false;
					for k, v in pairs(weps) do
						if(IsValid(objPl:GetActiveWeapon()) and objPl:GetActiveWeapon():GetClass():find(v)) then
							bFound = true
						end
					end
					
					if (objNPC:GetPos():Distance(objPl:GetPos()) > 2000) then
						objPl:Notify("You left the bank before the realtor could give you the money.")
					elseif ( !objPl:GetSharedBool("warrent", false) ) then
						objPl:Notify("You were arrested before the realtor could give you the money.");
					elseif ( !objPl:Alive() ) then
						objPl:Notify("You are unconcious before the realtor could give you the money.");
					elseif ( !bFound ) then
						objPl:Notify("You put away your weapon before the realtor could give you the money.");
					else
						objPl:GiveCash(GetSharedInt("perp_realtor_money"))
						objPl:Notify("You have successfully robbed the bank and made $" .. GetSharedInt("perp_realtor_money") ..", now GET OUT!")
						SetSharedInt("perp_realtor_money", 0)
					end
				end)
				Alarm(objNPC)
							
				objPl:Warrant("Robbing the bank");
				for k, v in pairs(player.GetAll()) do
					if(v:Team() != TEAM_CITIZEN) then
						v:Notify(objPl:GetRPName() .. " is attempting to rob the bank!")
					end
				end
			else
				umsg.Start("derp_realtor_nomoney", objPl)
				umsg.End()
				
				for k, v in pairs(player.GetAll()) do
					if(v:Team() != TEAM_CITIZEN) then
						v:Notify(objPl:GetRPName() .. " is attempting to rob the bank!")
					end
				end
				objPl:Warrant("Robbing the bank");
				
				objPl:Notify("Bank rob failed, not enough money in the bank!")
			end
			SetSharedBool("perp_bank_robbing_timer", true)
			timer.Simple(900, function() SetSharedBool("perp_bank_robbing_timer", false) end)
		end
	end
	concommand.Add("perp_realtor_rob", RealtorRob)
end