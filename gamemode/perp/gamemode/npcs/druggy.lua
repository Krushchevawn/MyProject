


local NPC = {};

NPC.Name = "Druggy";
NPC.ID = 16;

//NPC.Model = Model("models/players/PERP2/m_9_02.mdl");
NPC.Model = Model(PERPGetModelPath(1, 9, 2))

NPC.Invisible = false; // Used for ATM Machines, Casino Tables, etc.

NPC.Location = Vector( -10857.0312, -9273.7529, 72.0313); 
NPC.Angles = Angle(0, 180, 0);
NPC.ShowChatBubble = "Normal";

NPC.Sequence = 3;

// This is always local player.
function NPC.OnTalk ( )
	if LocalPlayer():Team() == TEAM_CITIZEN then
		GAMEMODE.DialogPanel:SetDialog("< Glances Around >\n\nHey, what can I get for ya?")
		
		GAMEMODE.DialogPanel:AddDialog("I got some product to sell...", NPC.BuyStuff)
		GAMEMODE.DialogPanel:AddDialog("Got anything good?", NPC.SellStuff)
	else
		GAMEMODE.DialogPanel:SetDialog("Hello.")
		
		GAMEMODE.DialogPanel:AddDialog("Err... Hello.", LEAVE_DIALOG)
	end
	
	GAMEMODE.DialogPanel:Show()
end

function NPC.BuyStuff ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
	
	if (ID == 1 || ID == 2 || ID == 3 || ID == 4 or ID == 5 or ID == 6) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I got some spare cash. What are you trying to sell?")
		
		GAMEMODE.DialogPanel:AddDialog("I made some meth the other day and I need to sell it.", NPC.BuyStuff_Meth)
		GAMEMODE.DialogPanel:AddDialog("I have a lot of weed that needs a buyer.", NPC.BuyStuff_Weed)
		GAMEMODE.DialogPanel:AddDialog("I got some mighty muscle that I need to get rid off..", NPC.BuyStuff_MM)
		GAMEMODE.DialogPanel:AddDialog("I need to get all this LSD off my back.", NPC.BuyStuff_Lsd)
		GAMEMODE.DialogPanel:AddDialog("I wanna dump all this shroomy stuff.", NPC.BuyStuff_Shroom)
		GAMEMODE.DialogPanel:AddDialog("I'm drowning in my cocaine please buy some.", NPC.BuyStuff_Cocaine)
		
		
		
		GAMEMODE.DialogPanel:AddDialog("Nevermind.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Naw, I don't have enough cash at the moment, sorry. Come back by later and we can work out a deal.")
		
		GAMEMODE.DialogPanel:AddDialog("Alright, I'll stop by later.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_Meth ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 2) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[10].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_Meth_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_Meth_Confirm ( )
	RunConsoleCommand("perp_sd_m")
	
	local totalEarned = ITEM_DATABASE[10].Cost * LocalPlayer():GetItemCount(10)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 10) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end

function NPC.BuyStuff_Weed ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 1) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[13].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_Weed_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_Weed_Confirm ( )
	RunConsoleCommand("perp_sd_w")
	
	local totalEarned = ITEM_DATABASE[13].Cost * LocalPlayer():GetItemCount(13)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 13) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end

function NPC.BuyStuff_MM ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 3) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[67].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_MM_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_MM_Confirm ( )
	RunConsoleCommand("perp_sd_mm")
	
	local totalEarned = ITEM_DATABASE[67].Cost * LocalPlayer():GetItemCount(67)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 67) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end

function NPC.BuyStuff_Lsd ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 4) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[66].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_Lsd_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_Shroom ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 5) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[78].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_Shroom_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end



function NPC.BuyStuff_Lsd_Confirm ( )
	RunConsoleCommand("perp_sd_lsd")
	
	local totalEarned = ITEM_DATABASE[66].Cost * LocalPlayer():GetItemCount(66)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 66) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end

function NPC.BuyStuff_Shroom_Confirm ( )
	RunConsoleCommand("perp_sd_shroom")
	
	local totalEarned = ITEM_DATABASE[78].Cost * LocalPlayer():GetItemCount(78)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 78) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end

function NPC.BuyStuff_Cocaine ( )
	local ID = GetSharedInt('perp_druggy_buy', 0)
		
	if (ID == 6) then
		GAMEMODE.DialogPanel:SetDialog("Yah, I'll buy some of that. " .. DollarSign() .. ITEM_DATABASE[69].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Sounds reasonable.", NPC.BuyStuff_Cocaine_Confirm)
		GAMEMODE.DialogPanel:AddDialog("Are you joking?", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry man, I have plenty of that shit. Not enough demand around here. Come back later.")
		
		GAMEMODE.DialogPanel:AddDialog("Fine, I'll be back.", LEAVE_DIALOG)
	end
end

function NPC.BuyStuff_Cocaine_Confirm ( )
	RunConsoleCommand("perp_sd_cocaine")
	
	local totalEarned = ITEM_DATABASE[69].Cost * LocalPlayer():GetItemCount(69)
	
	LocalPlayer():GiveCash(totalEarned)
	
	for k, v in pairs(GAMEMODE.PlayerItems) do
		if (v.ID == 69) then
			GAMEMODE.PlayerItems[k] = nil
			GAMEMODE.InventoryBlocks_Linear[k]:GrabItem()
		end
	end
	
	GAMEMODE.DialogPanel:SetDialog("Thanks, man. Here's your " .. DollarSign() .. totalEarned .. ".")
	GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
end




function NPC.SellStuff ( )
	local ID = GetSharedInt('perp_druggy_sell', 0)
	
	if (ID == 1) then
		GAMEMODE.DialogPanel:SetDialog("Yah man, I got some seeds. You interested? " .. DollarSign() .. ITEM_DATABASE[14].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Yah, I'll take some.", NPC.SellStuff_Weed)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
	
		GAMEMODE.DialogPanel:AddDialog("Naw man, sorry.", LEAVE_DIALOG)
	elseif (ID == 2) then
		GAMEMODE.DialogPanel:SetDialog("Yah man, I got some LSD. You interested? " .. DollarSign() .. ITEM_DATABASE[66].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Yah, I'll take some.", NPC.SellStuff_LSD)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
		GAMEMODE.DialogPanel:AddDialog("Naw man, sorry.", LEAVE_DIALOG)
	elseif (ID == 3) then
		GAMEMODE.DialogPanel:SetDialog("Yah man, I got some mighty muscle. You interested? " .. DollarSign() .. ITEM_DATABASE[67].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Yah, I'll take some.", NPC.SellStuff_MM)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
		GAMEMODE.DialogPanel:AddDialog("Naw man, sorry.", LEAVE_DIALOG)
	elseif (ID == 4) then
		GAMEMODE.DialogPanel:SetDialog("Yah man, I got some shrooms. You interested? " .. DollarSign() .. ITEM_DATABASE[78].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Yah, I'll take some.", NPC.SellStuff_Shroom)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
		GAMEMODE.DialogPanel:AddDialog("Naw man, sorry.", LEAVE_DIALOG)
	elseif (ID == 5) then
		GAMEMODE.DialogPanel:SetDialog("Yah man, I got some cocaine. You interested? " .. DollarSign() .. ITEM_DATABASE[68].Cost .. " each.")
		
		GAMEMODE.DialogPanel:AddDialog("Yah, I'll take some.", NPC.SellStuff_Cocaine)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
		GAMEMODE.DialogPanel:AddDialog("Naw man, sorry.", LEAVE_DIALOG)
		
		
	else
		GAMEMODE.DialogPanel:SetDialog("Sorry, I got nothing today. The people around here are druggies, I tell ya.")
		
		GAMEMODE.DialogPanel:AddDialog("You and your conspiracy theories...", LEAVE_DIALOG)
		GAMEMODE.DialogPanel:AddDialog("Jeez, why do you never sell what I want.", NPC.Threat)
		GAMEMODE.DialogPanel:AddDialog("Damnit, alright. I'll stop by later.", LEAVE_DIALOG)
	end
end

function NPC.SellStuff_Weed ( )
	GAMEMODE.DialogPanel:SetDialog("How many do you need?")
		
	GAMEMODE.DialogPanel:AddDialog("One ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 1 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(1) end)
	GAMEMODE.DialogPanel:AddDialog("Two ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 2 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(2) end)
	GAMEMODE.DialogPanel:AddDialog("Three ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 3 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(3) end)
	GAMEMODE.DialogPanel:AddDialog("Four ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 4 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(4) end)
	GAMEMODE.DialogPanel:AddDialog("Five ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 5 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(5) end)
	GAMEMODE.DialogPanel:AddDialog("Ten ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 10 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(10) end)
	GAMEMODE.DialogPanel:AddDialog("Twenty ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 20 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(20) end)
	GAMEMODE.DialogPanel:AddDialog("Fifty ( " .. DollarSign() .. ITEM_DATABASE[14].Cost * 50 .. " )", function ( ) NPC.SellStuff_Weed_Confirm(50) end)
	GAMEMODE.DialogPanel:AddDialog("Nevermind", LEAVE_DIALOG)
end

function NPC.SellStuff_LSD ( )
	GAMEMODE.DialogPanel:SetDialog("How many do you need?")
		
	GAMEMODE.DialogPanel:AddDialog("One ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 1 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(1) end)
	GAMEMODE.DialogPanel:AddDialog("Two ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 2 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(2) end)
	GAMEMODE.DialogPanel:AddDialog("Three ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 3 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(3) end)
	GAMEMODE.DialogPanel:AddDialog("Four ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 4 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(4) end)
	GAMEMODE.DialogPanel:AddDialog("Five ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 5 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(5) end)
	GAMEMODE.DialogPanel:AddDialog("Ten ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 10 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(10) end)
	GAMEMODE.DialogPanel:AddDialog("Twenty ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 20 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(20) end)
	GAMEMODE.DialogPanel:AddDialog("Fifty ( " .. DollarSign() .. ITEM_DATABASE[66].Cost * 50 .. " )", function ( ) NPC.SellStuff_Lsd_Confirm(50) end)
	GAMEMODE.DialogPanel:AddDialog("Nevermind", LEAVE_DIALOG)
end

function NPC.SellStuff_MM ( )
	GAMEMODE.DialogPanel:SetDialog("How many do you need?")
		
	GAMEMODE.DialogPanel:AddDialog("One ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 1 .. " )", function ( ) NPC.SellStuff_MM_Confirm(1) end)
	GAMEMODE.DialogPanel:AddDialog("Two ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 2 .. " )", function ( ) NPC.SellStuff_MM_Confirm(2) end)
	GAMEMODE.DialogPanel:AddDialog("Three ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 3 .. " )", function ( ) NPC.SellStuff_MM_Confirm(3) end)
	GAMEMODE.DialogPanel:AddDialog("Four ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 4 .. " )", function ( ) NPC.SellStuff_MM_Confirm(4) end)
	GAMEMODE.DialogPanel:AddDialog("Five ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 5 .. " )", function ( ) NPC.SellStuff_MM_Confirm(5) end)
	GAMEMODE.DialogPanel:AddDialog("Ten ( " .. DollarSign(f) .. ITEM_DATABASE[67].Cost * 10 .. " )", function ( ) NPC.SellStuff_MM_Confirm(10) end)
	GAMEMODE.DialogPanel:AddDialog("Twenty ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 20 .. " )", function ( ) NPC.SellStuff_MM_Confirm(20) end)
	GAMEMODE.DialogPanel:AddDialog("Fifty ( " .. DollarSign() .. ITEM_DATABASE[67].Cost * 50 .. " )", function ( ) NPC.SellStuff_MM_Confirm(50) end)
	GAMEMODE.DialogPanel:AddDialog("Nevermind", LEAVE_DIALOG)
end

function NPC.SellStuff_Shroom ( )
	GAMEMODE.DialogPanel:SetDialog("How many do you need?")
		
	GAMEMODE.DialogPanel:AddDialog("One ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 1 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(1) end)
	GAMEMODE.DialogPanel:AddDialog("Two ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 2 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(2) end)
	GAMEMODE.DialogPanel:AddDialog("Three ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 3 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(3) end)
	GAMEMODE.DialogPanel:AddDialog("Four ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 4 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(4) end)
	GAMEMODE.DialogPanel:AddDialog("Five ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 5 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(5) end)
	GAMEMODE.DialogPanel:AddDialog("Ten ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 10 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(10) end)
	GAMEMODE.DialogPanel:AddDialog("Twenty ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 20 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(20) end)
	GAMEMODE.DialogPanel:AddDialog("Fifty ( " .. DollarSign() .. ITEM_DATABASE[78].Cost * 50 .. " )", function ( ) NPC.SellStuff_Shroom_Confirm(50) end)
	GAMEMODE.DialogPanel:AddDialog("Nevermind", LEAVE_DIALOG)
end

function NPC.SellStuff_Cocaine ( )
	GAMEMODE.DialogPanel:SetDialog("How many do you need?")
		
	GAMEMODE.DialogPanel:AddDialog("One ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 1 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(1) end)
	GAMEMODE.DialogPanel:AddDialog("Two ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 2 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(2) end)
	GAMEMODE.DialogPanel:AddDialog("Three ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 3 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(3) end)
	GAMEMODE.DialogPanel:AddDialog("Four ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 4 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(4) end)
	GAMEMODE.DialogPanel:AddDialog("Five ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 5 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(5) end)
	GAMEMODE.DialogPanel:AddDialog("Ten ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 10 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(10) end)
	GAMEMODE.DialogPanel:AddDialog("Twenty ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 20 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(20) end)
	GAMEMODE.DialogPanel:AddDialog("Fifty ( " .. DollarSign() .. ITEM_DATABASE[68].Cost * 50 .. " )", function ( ) NPC.SellStuff_Cocaine_Confirm(50) end)
	GAMEMODE.DialogPanel:AddDialog("Nevermind", LEAVE_DIALOG)
end




function NPC.SellStuff_Weed_Confirm ( num )
	local totalCost = num * ITEM_DATABASE[14].Cost
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Ahh, I can't afford that.", LEAVE_DIALOG)	
	elseif (!LocalPlayer():CanHoldItem(14, num)) then
		GAMEMODE.DialogPanel:AddDialog("Nevermind, I don't think I can hold that many.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
		
		LocalPlayer():TakeCash(totalCost)
		LocalPlayer():GiveItem(14, num)
		
		RunConsoleCommand('perp_bd_w', num)
	end
end

function NPC.SellStuff_Lsd_Confirm ( num )
	local totalCost = num * ITEM_DATABASE[66].Cost
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Ahh, I can't afford that.", LEAVE_DIALOG)	
	elseif (!LocalPlayer():CanHoldItem(66, num)) then
		GAMEMODE.DialogPanel:AddDialog("Nevermind, I don't think I can hold that many.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
		
		LocalPlayer():TakeCash(totalCost)
		LocalPlayer():GiveItem(66, num)
		
		RunConsoleCommand('perp_bd_lsd', num)
	end
end

function NPC.SellStuff_MM_Confirm ( num )
	local totalCost = num * ITEM_DATABASE[67].Cost
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Ahh, I can't afford that.", LEAVE_DIALOG)	
	elseif (!LocalPlayer():CanHoldItem(67, num)) then
		GAMEMODE.DialogPanel:AddDialog("Nevermind, I don't think I can hold that many.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
		
		LocalPlayer():TakeCash(totalCost)
		LocalPlayer():GiveItem(67, num)
		
		RunConsoleCommand('perp_bd_mm', num)
	end
end

function NPC.SellStuff_Shroom_Confirm ( num )
	local totalCost = num * ITEM_DATABASE[78].Cost
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Ahh, I can't afford that.", LEAVE_DIALOG)	
	elseif (!LocalPlayer():CanHoldItem(78, num)) then
		GAMEMODE.DialogPanel:AddDialog("Nevermind, I don't think I can hold that many.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
		
		LocalPlayer():TakeCash(totalCost)
		LocalPlayer():GiveItem(78, num)
		
		RunConsoleCommand('perp_bd_shroom', num)
	end
end

function NPC.SellStuff_Cocaine_Confirm ( num )
	local totalCost = num * ITEM_DATABASE[68].Cost
	
	GAMEMODE.DialogPanel:SetDialog("That'll be " .. DollarSign() .. totalCost .. ".")
	
	if (LocalPlayer():GetCash() < totalCost) then
		GAMEMODE.DialogPanel:AddDialog("Ahh, I can't afford that.", LEAVE_DIALOG)	
	elseif (!LocalPlayer():CanHoldItem(68, num)) then
		GAMEMODE.DialogPanel:AddDialog("Nevermind, I don't think I can hold that many.", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:AddDialog("Thanks!", LEAVE_DIALOG)
		
		LocalPlayer():TakeCash(totalCost)
		LocalPlayer():GiveItem(68, num)
		
		RunConsoleCommand('perp_bd_cocaine', num)
	end
end



function NPC.Threat()
	if(GetSharedInt('perp_druggy_nextthreat') < CurTime()) then
		GAMEMODE.DialogPanel:SetDialog("So.. you're telling me that I should sell something else? Well ....")
			
		GAMEMODE.DialogPanel:AddDialog("I'm telling you to sell me seeds. If you don't I'll fuck you over. You heard me?", function ( ) NPC.ThreatFinish(14) end)
		GAMEMODE.DialogPanel:AddDialog("I'm telling you to sell me mighty muscles. If you don't I'll fuck you over. You heard me?", function ( ) NPC.ThreatFinish(67) end)
		GAMEMODE.DialogPanel:AddDialog("I'm telling you to sell me LSD. If you don't I'll fuck you over. You heard me?", function ( ) NPC.ThreatFinish(66) end)
		GAMEMODE.DialogPanel:AddDialog("I'm telling you to sell me Shrooms. If you don't I'll fuck you over. You heard me?", function ( ) NPC.ThreatFinish(78) end)
		GAMEMODE.DialogPanel:AddDialog("I'm telling you to gimme sum cocaine you fathead.", function ( ) NPC.ThreatFinish(68) end)
		GAMEMODE.DialogPanel:AddDialog("No, I am just kidding..", LEAVE_DIALOG)
	else
		GAMEMODE.DialogPanel:SetDialog("What? I am a professional and indeed, I don't always sell what you want. Now shut the hell up. Deal with it.")

		GAMEMODE.DialogPanel:AddDialog("...", LEAVE_DIALOG)
	end
end

function NPC.ThreatFinish(iDrug)
	RunConsoleCommand("perp_bd_thr", iDrug)
	
	GAMEMODE.DialogPanel:SetDialog("Yes yes fine fine.. Now calm down you idiot.")
	
	GAMEMODE.DialogPanel:AddDialog("Love u! <give kiss>", LEAVE_DIALOG)
	GAMEMODE.DialogPanel:AddDialog("FFFF.", LEAVE_DIALOG)
end

if SERVER then
	function GAMEMODE.RandomizeDruggyValues ( )
		SetSharedInt('perp_druggy_sell', math.random(0, 5))
		SetSharedInt('perp_druggy_buy', math.random(0, 6))
		SetSharedInt('perp_druggy_nextthreat', CurTime())
	end
	timer.Create('perp_druggy', 600, 0, function() GAMEMODE.RandomizeDruggyValues() end)
	GAMEMODE.RandomizeDruggyValues()
	
	local function Threat(objPl, strC, tblArgs)
		if(GetSharedInt('perp_druggy_nextthreat') < CurTime()) then
			timer.Create('perp_druggy', 600, 0, function() GAMEMODE.RandomizeDruggyValues() end)
			
			local iDrug = tonumber(tblArgs[1])
			
			local iNum = 0
			if(iDrug == 14) then
				iNum = 1
			elseif(iDrug == 67) then
				iNum = 3
			elseif(iDrug == 66) then
				iNum = 2
			elseif(iDrug == 78) then
				iNum = 4
			elseif(iDrug == 68) then
				iNum = 5
			end
			
			SetSharedInt('perp_druggy_sell', iNum)
			
			SetSharedInt('perp_druggy_nextthreat', CurTime() + math.random(300, 600))
		end
	end
	concommand.Add("perp_bd_thr", Threat)
	
	local function buyWeed ( Player, CMD, Args )
		if (!Args[1]) then return end
		
		local toBuy = tonumber(Args[1])
		local totalCost = toBuy * ITEM_DATABASE[14].Cost
		
		if (toBuy <= 0) then return end
		if (Player:GetCash() < totalCost) then return end
		if (GetSharedInt('perp_druggy_sell', 0) != 1) then return end
		if (!Player:CanHoldItem(14, toBuy)) then return end
		
		Player:TakeCash(totalCost, true)
		Player:GiveItem(14, toBuy)
		Player:Save()
	end
	concommand.Add("perp_bd_w", buyWeed)
	
	local function buyLSD ( Player, CMD, Args )
		if (!Args[1]) then return end
		
		local toBuy = tonumber(Args[1])
		local totalCost = toBuy * ITEM_DATABASE[66].Cost
		
		if (toBuy <= 0) then return end
		if (Player:GetCash() < totalCost) then return end
		if (GetSharedInt('perp_druggy_sell', 0) != 2) then return end
		if (!Player:CanHoldItem(66, toBuy)) then return end
		
		Player:TakeCash(totalCost, true)
		Player:GiveItem(66, toBuy)
		Player:Save()
	end
	concommand.Add("perp_bd_lsd", buyLSD)
	
	local function buyMM ( Player, CMD, Args )
		if (!Args[1]) then return end
		
		local toBuy = tonumber(Args[1])
		local totalCost = toBuy * ITEM_DATABASE[67].Cost
		
		if (toBuy <= 0) then return end
		if (Player:GetCash() < totalCost) then return end
		if (GetSharedInt('perp_druggy_sell', 0) != 3) then return end
		if (!Player:CanHoldItem(67, toBuy)) then return end
		
		Player:TakeCash(totalCost, true)
		Player:GiveItem(67, toBuy)
		Player:Save()
	end
	concommand.Add("perp_bd_mm", buyMM)
	
	local function buyShroom ( Player, CMD, Args )
		if (!Args[1]) then return end
		
		local toBuy = tonumber(Args[1])
		local totalCost = toBuy * ITEM_DATABASE[78].Cost
		
		if (toBuy <= 0) then return end
		if (Player:GetCash() < totalCost) then return end
		if (GetSharedInt('perp_druggy_sell', 0) != 4) then return end
		if (!Player:CanHoldItem(78, toBuy)) then return end
		
		Player:TakeCash(totalCost, true)
		Player:GiveItem(78, toBuy)
		Player:Save()
	end
	concommand.Add("perp_bd_shroom", buyShroom)
	
	local function buyCocaine ( Player, CMD, Args )
		if (!Args[1]) then return end
		
		local toBuy = tonumber(Args[1])
		local totalCost = toBuy * ITEM_DATABASE[68].Cost
		
		if (toBuy <= 0) then return end
		if (Player:GetCash() < totalCost) then return end
		if (GetSharedInt('perp_druggy_sell', 0) != 5) then return end
		if (!Player:CanHoldItem(68, toBuy)) then return end
		
		Player:TakeCash(totalCost, true)
		Player:GiveItem(68, toBuy)
		Player:Save()
	end
	concommand.Add("perp_bd_cocaine", buyCocaine)
	
	
	
	
	
	
	
	local function sellWeed ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 1) then return end
	
		local num = Player:GetItemCount(13)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 13) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[13].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_w", sellWeed)
	
	local function sellMeth ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 2) then return end
	
		local num = Player:GetItemCount(10)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 10) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[10].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_m", sellMeth)
	
	
	local function sellMM ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 3) then return end
	
		local num = Player:GetItemCount(67)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 67) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[67].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_mm", sellMM)
	
	local function sellLSD ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 4) then return end
	
		local num = Player:GetItemCount(66)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 66) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[66].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_lsd", sellLSD)
	
	local function sellShroom ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 5) then return end
	
		local num = Player:GetItemCount(78)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 78) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[78].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_shroom", sellShroom)
	
	local function sellCocaine ( Player )
		if (GetSharedInt('perp_druggy_buy', 0) != 6) then return end
	
		local num = Player:GetItemCount(69)
		
		if (num == 0) then return end
		
		for k, v in pairs(Player.PlayerItems) do
			if (v.ID == 69) then
				Player.PlayerItems[k] = nil
			end
		end
		
		Player:GiveCash(num * ITEM_DATABASE[69].Cost, true)
		
		Player:Save()
	end
	concommand.Add("perp_sd_cocaine", sellCocaine)
end

GAMEMODE:LoadNPC(NPC);