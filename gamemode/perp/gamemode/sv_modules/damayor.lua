
function SaveCityMayorSettings()
	local tblSaved = {}
	tblSaved["innercity_speedlimit_i"] = GetSharedInt("innercity_speedlimit_i")
	tblSaved["innercity_speedlimit_o"] = GetSharedInt("innercity_speedlimit_o")
	tblSaved["tax_sales"] = GetSharedInt("tax_sales")
	tblSaved["tax_income"] = GetSharedInt("tax_sales")
	tblSaved["ticket_price"] = GetSharedInt("ticket_price")
	
	tblSaved["cop_max"] = GAMEMODE.MaximumCops
	tblSaved["cop_pay"] = GAMEMODE.JobPaydayInfo[TEAM_POLICE][2]
	tblSaved["cop_cars"] = GAMEMODE.MaxCopCars 
	
	tblSaved["swat_max"] = GAMEMODE.MaximumSWAT
	tblSaved["swat_pay"] = GAMEMODE.JobPaydayInfo[TEAM_SWAT][2]
	tblSaved["swat_cars"] = GAMEMODE.MaxSWATVans 
	
	tblSaved["dispatcher_pay"] = GAMEMODE.JobPaydayInfo[TEAM_DISPATCHER][2]
	
	tblSaved["fire_max"] = GAMEMODE.MaximumFireMen
	tblSaved["fire_pay"] = GAMEMODE.JobPaydayInfo[TEAM_FIREMAN][2]
	tblSaved["fire_cars"] = GAMEMODE.MaxFireTrucks 
	
	tblSaved["medic_max"] = GAMEMODE.MaximumParamedic
	tblSaved["medic_pay"] = GAMEMODE.JobPaydayInfo[TEAM_PARAMEDIC][2]
	tblSaved["medic_cars"] = GAMEMODE.MaxAmbulances 
	
	tblSaved["secret_max"] = GAMEMODE.MaximumSecretService
	tblSaved["secret_pay"] = GAMEMODE.JobPaydayInfo[TEAM_SECRET_SERVICE][2]
	tblSaved["secret_cars"] = GAMEMODE.MaxStretch 
	
	file.Write("perp3/mayorsettings.txt", util.TableToKeyValues(tblSaved))
end

function LoadCityMayorSettings()
	if(not file.Exists("perp3/mayorsettings.txt", "DATA")) then return end
	local tblSaved = util.KeyValuesToTable(file.Read("perp3/mayorsettings.txt", "DATA"))
	
	SetSharedInt("innercity_speedlimit_i", tblSaved["innercity_speedlimit_i"] or 50)
	SetSharedInt("innercity_speedlimit_o", tblSaved["innercity_speedlimit_o"] or 100)
	SetSharedInt("tax_sales", tblSaved["tax_sales"] or 0)
	SetSharedInt("tax_sales", tblSaved["tax_income"] or 0)
	
	SetSharedInt("ticket_price", tblSaved["ticket_price"] or 50)
	
	GAMEMODE.MaximumCops = tblSaved["cop_max"] or 0
	GAMEMODE.JobPaydayInfo[TEAM_POLICE][2] = tblSaved["cop_pay"] or 0
	GAMEMODE.MaxCopCars  = tblSaved["cop_cars"] or 0
	
	GAMEMODE.MaximumSWAT = tblSaved["swat_max"] or 0
	GAMEMODE.JobPaydayInfo[TEAM_SWAT][2] = tblSaved["swat_pay"] or 0
	GAMEMODE.MaxSWATVans = tblSaved["swat_cars"] or 0
	
	GAMEMODE.JobPaydayInfo[TEAM_DISPATCHER][2] = tblSaved["dispatcher_pay"] or 0
	
	GAMEMODE.MaximumFireMen = tblSaved["fire_max"] or 0
	GAMEMODE.JobPaydayInfo[TEAM_FIREMAN][2] = tblSaved["fire_pay"] or 0
	GAMEMODE.MaxFireTrucks = tblSaved["fire_cars"] or 0
	
	GAMEMODE.MaximumParamedic = tblSaved["medic_max"] or 0
	GAMEMODE.JobPaydayInfo[TEAM_PARAMEDIC][2] = tblSaved["medic_pay"] or 0
	GAMEMODE.MaxAmbulances  = tblSaved["medic_cars"] or 0
	
	GAMEMODE.MaximumSecretService = tblSaved["secret_max"] or 0
	GAMEMODE.JobPaydayInfo[TEAM_SECRET_SERVICE][2] = tblSaved["secret_pay"] or 0
	GAMEMODE.MaxStretch  = tblSaved["secret_cars"] or 0
end
hook.Add("InitPostEntity", "LoadCityMayorSettings", LoadCityMayorSettings)



function GM.SendCityInfoToMayor()
	for k, v in pairs(player.GetAll()) do
		if(v:Team() == TEAM_MAYOR) then
			GAMEMODE.SendJobInformation(v)
			GAMEMODE.SendJobInformation2(v)
			GAMEMODE.SendJobInformation3(v)
		end
	end
end

function GM.SendCityInfo()
	for k, v in pairs(player.GetAll()) do
		GAMEMODE.SendJobInformation(v)
		GAMEMODE.SendJobInformation2(v)
		GAMEMODE.SendJobInformation3(v)
	end
end

local function SendCityInfoPlayerInitSpawn(objPl)
	GAMEMODE.SendJobInformation(objPl)
	GAMEMODE.SendJobInformation2(objPl)
	GAMEMODE.SendJobInformation3(objPl)
end
hook.Add("PlayerInitialSpawn", "SendCityInfoPlayerInitSpawn", SendCityInfoPlayerInitSpawn)

local bRecentChanges = false

timer.Create("SendCityInfoTimer", 3, 0, function()
	if(bRecentChanges) then
		GAMEMODE.SendCityInfo()
		bRecentChanges = false
		
		SaveCityMayorSettings()
	end
end)

local function IsMayor(p)
	return p:Team() == TEAM_MAYOR
end

local iLastAnnounce = CurTime()
local function AnnounceMayorChanges(objPl)
	if(iLastAnnounce > CurTime()) then return end
	iLastAnnounce = CurTime() + 10
	
	if(IsMayor(objPl)) then
		for k, v in pairs(player.GetAll()) do
			v:Notify("The mayor has restated the local government laws and limits. Use a law book to see what's different.")
		end
	end
end
concommand.Add("perp_m_ann_ch", AnnounceMayorChanges)

--[[
City Speed Limits
]]

local function perp_m_sl_i(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		SetSharedInt("innercity_speedlimit_i", math.Clamp(tonumber(tblArgs[1]), 20, 120))
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_sl_i", perp_m_sl_i) // - Inner city speed limit

local function perp_m_sl_o(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		SetSharedInt("innercity_speedlimit_o", math.Clamp(tonumber(tblArgs[1]), 20, 120))
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_sl_o", perp_m_sl_o) // - Outter city speed limit

--[[
city funds
perp_m_t_s - Sales Tax Rate
perp_m_t_i - Income Tax Rate
]]
local function perp_m_t_s(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		SetSharedInt("tax_sales", math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxTax_Sales))
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_t_s", perp_m_t_s) // - Sales Tax Rat

local function perp_m_t_i(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		SetSharedInt("tax_income", math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxTax_Income))
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_t_i", perp_m_t_i) // - Income Tax Rate

local function perp_m_t_i(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		SetSharedInt("ticket_price", math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxTicketPrice))
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_ticket_p", perp_m_t_i) // - Income Tax Rate

--[[
law enforcement
perp_m_e_c - Max police officer employment
perp_m_p_c - Max officer salary
perp_m_v_c - Max Squar car Upkeep
perp_m_e_s - Max swat team employees
perp_m_p_s - Max swat member salary
perp_m_v_s - Max swat van upkeep
perp_m_p_d - Dispatcher salary
]]

local function perp_m_e_c(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaximumCops = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxEmployment_Police)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_e_c", perp_m_e_c) // - Max police officer employment

local function perp_m_p_c(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_POLICE][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_Police)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_c", perp_m_p_c) // - Max officer salary

local function perp_m_v_c(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaxCopCars = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxVehicles_Police)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_v_c", perp_m_v_c) // - Max cop car Upkeep

local function perp_m_e_s(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaximumSWAT = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxEmployment_SWAT)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_e_s", perp_m_e_s) // - Max swat team employees

local function perp_m_p_s(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_SWAT][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_SWAT)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_s", perp_m_p_s) // - Max swat member salary

local function perp_m_v_s(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaxSWATVans = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxVehicles_SWAT)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_v_s", perp_m_v_s) // - Max swat van upkeep

local function perp_m_p_d(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_DISPATCHER][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_Dispatcher)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_d", perp_m_p_d) // - Dispatcher salary

--[[
civil services
perp_m_e_f - Fireman Employment
perp_m_p_f - Fireman Salary
perp_m_v_f - Fire Engine Upkeep
perp_m_e_m - Paramedic Employment
perp_m_p_m - Paramedic Salary
perp_m_v_m - Ambulance Upkeep
]]

local function perp_m_e_f(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaximumFireMen = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxEmployment_Fire)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_e_f", perp_m_e_f) // - Fireman Employment

local function perp_m_p_f(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_FIREMAN][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_Fireman)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_f", perp_m_p_f) // - Fireman Salary

local function perp_m_v_f(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaxFireTrucks = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxVehicles_Fire)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_v_f", perp_m_v_f) // - Fire Engine Upkeep

local function perp_m_e_m(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaximumParamedic = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxEmployment_Medic)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_e_m", perp_m_e_m) // - Paramedic Employment

local function perp_m_p_m(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_PARAMEDIC][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_Paramedic)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_m", perp_m_p_m) // - Paramedic Salary

local function perp_m_v_m(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaxAmbulances = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxVehicles_Medic)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_v_m", perp_m_v_m) // - Ambulance Upkeep

--[[
secret service
perp_m_e_ss - Max secret service employment
perp_m_p_ss - Max secret service agent salary
perp_m_v_ss - Max limousine upkeep
--]]

local function perp_m_e_ss(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaximumSecretService = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxEmployment_SecretService)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_e_ss", perp_m_e_ss) // - Max secret service employment

local function perp_m_p_ss(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.JobPaydayInfo[TEAM_SECRET_SERVICE][2] = math.Clamp(tonumber(tblArgs[1]), 50, GAMEMODE.MaxPayDay_SecretService)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_p_ss", perp_m_p_ss) // - Max secret service agent salary

local function perp_m_v_ss(objPl, _, tblArgs)
	if(IsMayor(objPl)) then
		GAMEMODE.MaxStretch = math.Clamp(tonumber(tblArgs[1]), 0, GAMEMODE.MaxVehicles_SecretService)
		
		bRecentChanges = true
	end
end
concommand.Add("perp_m_v_ss", perp_m_v_ss) // - Max limousine upkeep
