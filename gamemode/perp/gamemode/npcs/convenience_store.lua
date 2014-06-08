


local NPC = {};

NPC.Name = "Ching's Convenience Store";
NPC.ID = 18;

//NPC.Model = Model("models/players/PERP2/m_5_06.mdl");
NPC.Model = Model(PERPGetModelPath(1, 5, 6))

NPC.Invisible = false; // Used for ATM Machines, Casino Tables, etc.

NPC.Location ={ 
	Vector(-7495.572754, -6607.649414, 72.0313),
	Vector(10413.614258, 13254, 67),
};
NPC.Angles = {Angle(0, 90, 0), Angle(0, 90, 0)} ;
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;

function NPC.OnTalk ( )
	GAMEMODE.DialogPanel:SetDialog("Welcome to " .. NPC.Name .. "\n\nWhat can I do for ya?");
	
	NPC.MakeDialogButtons();
	
	GAMEMODE.DialogPanel:Show();
end

function NPC.MakeDialogButtons ( )
	GAMEMODE.DialogPanel:AddDialog("Browse the store", function() GAMEMODE.OpenShop(3) GAMEMODE.DialogPanel:Hide() end )
	GAMEMODE.DialogPanel:AddDialog("Enter the lottery", function() RunConsoleCommand("perp_l_s") end)
	GAMEMODE.DialogPanel:AddDialog("Nothing", LEAVE_DIALOG)
end

function NPC.BuyTickets( num )
	local totalCost = num * COST_FOR_LOTTO	
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Oh I can't afford that.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Lets do it!", function() RunConsoleCommand('perp_l_e', num) GAMEMODE.DialogPanel:Hide() end)
		GAMEMODE.DialogPanel:AddDialog("I changed my mind.", LEAVE_DIALOG)
	end
end

function NPC.BuyTicketsCustom()
	ShowBankWindow("Lotto Tickets", "How many tickets?", "purchase", NPC.BuyTickets)
end

usermessage.Hook("perp_lotto_store", function( um )
	GAMEMODE.DialogPanel:SetDialog("You currently have " .. um:ReadLong() .. " out of a total " .. um:ReadLong() .. " tickets.\n\nWhat would you like to do?" );
	GAMEMODE.DialogPanel:AddDialog("Buy 1 ticket", function() NPC.BuyTickets( 1 ) end)
	GAMEMODE.DialogPanel:AddDialog("Buy 5 tickets", function() NPC.BuyTickets( 5 ) end)
	GAMEMODE.DialogPanel:AddDialog("Buy 10 tickets", function() NPC.BuyTickets( 10 ) end)
	GAMEMODE.DialogPanel:AddDialog("Different Amount", NPC.BuyTicketsCustom )	
	GAMEMODE.DialogPanel:AddDialog("Nothing", LEAVE_DIALOG)
end )

GAMEMODE:LoadNPC(NPC);