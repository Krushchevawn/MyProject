/////////////////////////////////////////
// � 2011-2012 D3lux - D3lux-Gaming    //
//    All rights reserved    		   //
/////////////////////////////////////////
// This material may not be  		   //
//   reproduced, displayed,  		   //
//  modified or distributed  		   //
// without the express prior 		   //
// written permission of the 		   //
//   the copyright holder.  		   //
//		D3lux-Gaming.com   			   //
/////////////////////////////////////////

if SERVER then
	local classToUpkeep ={}
	classToUpkeep[TEAM_POLICE] = GM.UpkeepCost_PoliceCar
	classToUpkeep[TEAM_FIREMAN] = GM.UpkeepCost_Firetruck
	classToUpkeep[TEAM_SWAT] = GM.UpkeepCost_SWATVan
	classToUpkeep[TEAM_MEDIC] = GM.UpkeepCost_Ambulance
	classToUpkeep[TEAM_SECRET_SERVICE] = GM.UpkeepCost_Stretch
	
	local times = 0

	local function GivePaydayCash ( )
		GAMEMODE.CityBudget_LastExpenses = 0
		
		local numPlayers = table.Count(player.GetAll())
		GAMEMODE.GiveCityMoney(numPlayers * FREE_CASH_PER_PLAYER)
		
		// Pass out the citizen's money first!
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == TEAM_CITIZEN) then
				local TO_EARN = 50;
				local TO_EARN_TEXT = "from your unemployment check.";
				if (v:IsGoldMember()) then
					TO_EARN = TO_EARN * 1.50;
				elseif (v:IsVIP()) then
					TO_EARN = TO_EARN * 1.25;
				end
				
				local taxTaken = math.floor(TO_EARN * GAMEMODE.GetTaxRate_Income())
				GAMEMODE.GiveCityMoney(taxTaken)
				TO_EARN = TO_EARN - taxTaken
				TO_EARN_TEXT = TO_EARN_TEXT .. " (" .. GAMEMODE.GetTaxRate_Income_Text() .. " Income Tax)"
				
				v:GiveBank(TO_EARN, true)
				umsg.Start("perp_payday", v); umsg.Short(TO_EARN); umsg.String(TO_EARN_TEXT); umsg.End();
			end
		end
		
		// find all the gov vehicles and subtract their upkeep
		for _, each in pairs(ents.FindByClass("prop_vehicle_jeep")) do
			if (each.vehicleTable.RequiredClass && classToUpkeep[each.vehicleTable.RequiredClass]) then
				GAMEMODE.CityBudget = GAMEMODE.CityBudget - classToUpkeep[each.vehicleTable.RequiredClass]
				GAMEMODE.CityBudget_LastExpenses = GAMEMODE.CityBudget_LastExpenses + classToUpkeep[each.vehicleTable.RequiredClass]
			end
		end
		
		// Now to pay the government officials...
		local totalCost = 0
		local totalCostIn = 0
		for k, v in pairs(player.GetAll()) do
			if (v:Team() != TEAM_CITIZEN) then
				local TO_EARN = GAMEMODE.JobPaydayInfo[v:Team()][2]
				if (v:IsGoldMember())  then
					TO_EARN = TO_EARN * 1.50;
				elseif (v:IsVIP()) then
					TO_EARN = TO_EARN * 1.25;
				end
			
				totalCost = totalCost + TO_EARN;
				totalCostIn = totalCostIn + math.floor(TO_EARN * GAMEMODE.GetTaxRate_Income())
			end
		end
		
		if (GAMEMODE.CityBudget < (totalCost - totalCostIn)) then
			for k, v in pairs(player.GetAll()) do
				if (v:Team() != TEAM_CITIZEN) then
					v:Notify("The city did not have enough funds to pay you.")
					
					return
				end
			end
		end
		
		GAMEMODE.CityBudget = GAMEMODE.CityBudget - totalCost + totalCostIn
		GAMEMODE.CityBudget_LastExpenses = GAMEMODE.CityBudget_LastExpenses + totalCost
		GAMEMODE.CityBudget_LastIncome = GAMEMODE.CityBudget_LastIncome + totalCostIn
		
		GAMEMODE.SendCityInfoToMayor()
		GAMEMODE.CityBudget_LastIncome = 0
		
		for k, v in pairs(player.GetAll()) do
			if (v:Team() != TEAM_CITIZEN) then
				local TO_EARN = GAMEMODE.JobPaydayInfo[v:Team()][2]
				local TO_EARN_TEXT = GAMEMODE.JobPaydayInfo[v:Team()][1];
				if v:IsGoldMember() then
					TO_EARN = TO_EARN * 1.50;
				elseif (v:IsVIP()) then
					TO_EARN = TO_EARN * 1.25;
				end
				
				TO_EARN = TO_EARN - math.floor(TO_EARN * GAMEMODE.GetTaxRate_Income())
				TO_EARN_TEXT = TO_EARN_TEXT .. " (" .. GAMEMODE.GetTaxRate_Income_Text() .. " Income Tax)"
				
				v:GiveBank(TO_EARN, true);
				umsg.Start("perp_payday", v); umsg.Short(TO_EARN); umsg.String(TO_EARN_TEXT); umsg.End();
			end
		end
		times = times + 1
		if(times % 10 == 0) then
			local firemans = team.GetPlayers( TEAM_FIREMAN )
			local fires = ents.FindByClass("ent_fire")
			if( #firemans == 0 and #fires > 0 ) then
				for k, v in pairs(ents.FindByClass("ent_fire")) do
					v:Remove()
				end
				for k, v in pairs(player.GetAll()) do
					v:Notify( "Since there are no Firemen on, all fires have been extinguished!")
				end
			end
		end
	end
	timer.Create("PayDaySystem", 60, 0, function() GivePaydayCash() end)
	
else

	local function GetPaydayCommand ( UMsg )
		local TO_EARN = UMsg:ReadShort();
		local TO_EARN_TEXT = UMsg:ReadString();

		LocalPlayer():GiveBank(TO_EARN, true);
		
		if (!GAMEMODE.Options_ShowPaydayInfo:GetBool()) then return; end
		LocalPlayer():Notify("You have earned " .. DollarSign() .. TO_EARN .. " " .. TO_EARN_TEXT .. " It has been sent to your bank account.");
	end
	usermessage.Hook("perp_payday", GetPaydayCommand);
	
end
