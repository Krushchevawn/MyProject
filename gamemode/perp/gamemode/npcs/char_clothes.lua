


local NPC = {};

NPC.Name = "Kat's Klothes Kloset";
NPC.ID = 9;

//NPC.Model = Model("models/players/PERP2/m_2_03.mdl");
NPC.Model = Model(PERPGetModelPath(1, 2, 3))

NPC.Invisible = false; // Used for ATM Machines, Casino Tables, etc.

NPC.Location = Vector(  -4950.6147, -6431.3301, 74.0736); 
NPC.Angles = Angle(0, 87.8084, 0);
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;

// This is always local player.
function NPC.OnTalk ( )
	if (LocalPlayer():Team() == TEAM_CITIZEN) then
		GAMEMODE.DialogPanel:SetDialog("Hey! Would you like some new clothes? Or maybe a new color for your physgun?");
		
		GAMEMODE.DialogPanel:AddDialog("I'd like to see your stock, please.", NPC.DoIt)
		GAMEMODE.DialogPanel:AddDialog('How much are your clothes?', NPC.Cost)
		GAMEMODE.DialogPanel:AddDialog("I want to color my physgun.", NPC.Colorphys)
		GAMEMODE.DialogPanel:AddDialog("Nothing. Thanks anyways, though.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("You look fine in that uniform, why would you want new clothes?\n\n(You must be a citizen to use this feature.)");
		
		GAMEMODE.DialogPanel:AddDialog("I agree.", LEAVE_DIALOG)
	end
	
	GAMEMODE.DialogPanel:Show();
end

function NPC.Cost ( )
	GAMEMODE.DialogPanel:SetDialog("To make things easier on everyone, we have managed to change all prices to be the same, right at " .. DollarSign() .. GAMEMODE.ClothesPrice .. ".");
	
	GAMEMODE.DialogPanel:AddDialog("I'd like to see your stock, please.", NPC.DoIt)
	GAMEMODE.DialogPanel:AddDialog("That's outrageous!", LEAVE_DIALOG)
	
	GAMEMODE.DialogPanel:Show();
end

function NPC.DoIt ( )
	if LocalPlayer():GetCash() >= GAMEMODE.ClothesPrice then
		LEAVE_DIALOG();
		LocalPlayer():TakeCash(GAMEMODE.ClothesPrice, true);
		GAMEMODE.Select_Clothes();
	else
		GAMEMODE.DialogPanel:SetDialog("Erm... you don't seem like the kind of person who can afford my designer clothes.");
		
		GAMEMODE.DialogPanel:AddDialog("Well, that's unfriendly.", LEAVE_DIALOG);
	end
end

function NPC.Colorphys()
	if(LocalPlayer():IsGoldMember()) then
		if(LocalPlayer():GetCash() < PHYSGUN_COLORPRICE) then
			GAMEMODE.DialogPanel:SetDialog("It costs $" .. PHYSGUN_COLORPRICE .. " to color your physgun. You don't have enough.")
			GAMEMODE.DialogPanel:AddDialog("Damnit!", LEAVE_DIALOG)
		else
			GAMEMODE.DialogPanel:SetDialog("Sure! That will cost you: $" .. PHYSGUN_COLORPRICE .. ".")
			GAMEMODE.DialogPanel:AddDialog("Alright, get on with it!", function() 
				LEAVE_DIALOG()
				GAMEMODE.SelectPhysColor() 
			end)
			GAMEMODE.DialogPanel:AddDialog("Nah, changed my mind", LEAVE_DIALOG)
		end
	else
		GAMEMODE.DialogPanel:SetDialog("This feature is for GOLD Members only.")
		GAMEMODE.DialogPanel:AddDialog("Oh...", LEAVE_DIALOG)
	end
end

GAMEMODE:LoadNPC(NPC);