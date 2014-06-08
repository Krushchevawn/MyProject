function GM.GetTaxRate_Sales ( ) return GetSharedInt("tax_sales", 0) * 0.01 end
function GM.GetTaxRate_Income ( ) return GetSharedInt("tax_income", 0) * 0.01 end
function GM.GetTaxRate_Income_Text ( ) return GetSharedInt("tax_income", 0) .. "%" end
function GM.GetTaxRate_Sales_Text ( ) return GetSharedInt("tax_sales", 0) .. "%" end

if SERVER then

	function GM.GiveCityMoney ( amount )
		GAMEMODE.CityBudget = GAMEMODE.CityBudget + amount
		GAMEMODE.CityBudget_LastIncome = GAMEMODE.CityBudget_LastIncome + amount
		
		GAMEMODE.SendMayorCityBudgetUpdate()
	end	
	
	function GM.SendMayorCityBudgetUpdate()
		for k, v in pairs(player.GetAll()) do
			if(v:Team() == TEAM_MAYOR) then
				umsg.Start("perp2_mayor_info", v)
				umsg.Long(GAMEMODE.CityBudget)
				umsg.Short(GAMEMODE.CityBudget_LastIncome)
				umsg.Short(GAMEMODE.CityBudget_LastExpenses)
				umsg.End()
			end
		end
	end
	
else

	local function receiveMayorUpdate ( uMsg )
		GAMEMODE.CityBudget = uMsg:ReadLong()
		GAMEMODE.CityBudget_LastIncome = uMsg:ReadShort()
		GAMEMODE.CityBudget_LastExpenses = uMsg:ReadShort()
	end
	usermessage.Hook("perp2_mayor_info", receiveMayorUpdate)

end
