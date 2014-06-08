local PANEL = {}

GM.HUDTextures = {}
GM.HUDTextures["skin"] = "style01_t"
GM.HUDTextures["hud_bar"] = surface.GetTextureID("agrp/" .. GM.HUDTextures["skin"] .. "/bar")

local hudTyping = surface.GetTextureID("perp2/hud/typing")
local hudStar = surface.GetTextureID("agrp/star")
local currentlyTalkingTexture = surface.GetTextureID("voice/icntlk_pl")
local currentlyRadioTexture = surface.GetTextureID("perp2/radio")

//surface.CreateFont("arial", 20, 1000, true, false, "hud_targetid_playername")
surface.CreateFont("hud_targetid_playername", {
        size = 20,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("arial", 20, 1000, true, false, "hud_targetid_org")
surface.CreateFont("hud_targetid_org", {
        size = 20,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("arial", 20, 1000, true, false, "hud_targetid_warrant")
surface.CreateFont("hud_targetid_warrant", {
        size = 20,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("arial", 20, 1000, true, false, "hud_targetid_speed")
surface.CreateFont("hud_targetid_speed", {
        size = 20,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("arial", 40, 1000, true, false, "hud_property")
surface.CreateFont("hud_property", {
        size = 40,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("akbar", ScreenScale(9), 500, true, false, "hud_block")
surface.CreateFont("hud_block", {
        size = ScreenScale(9),
        weight = 500,
        antialias = true,
        shadow = false,
        font = "akbar"})
//surface.CreateFont("arial", 32, 1000, true, false, "hud_loading")
surface.CreateFont("hud_loading", {
        size = 32,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Arial"})
//surface.CreateFont("arial", 18, 800, true, false, "PEChatFont")
surface.CreateFont("PEChatFont", {
        size = 18,
        weight = 800,
        antialias = true,
        shadow = false,
        font = "Arial"})
surface.CreateFont("DefaultLarge", {
	font = "Tahoma",
    size = 16,
    weight = 0})
//surface.CreateFont( "coolvetica", 40, 600, true, false, "DoorFont2" )
surface.CreateFont("DoorFont2", {
        size = 40,
        weight = 600,
        antialias = true,
        shadow = false,
        font = "coolvetica"})
//surface.CreateFont("Tahoma", 20, 1000, true, false, "PlayerNameFont");
surface.CreateFont("PlayerNameFont", {
        size = 20,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Tahoma"})
//surface.CreateFont("Tahoma", 14, 1000, true, false, "PEChatFont");
surface.CreateFont("PEChatFont", {
        size = 14,
        weight = 1000,
        antialias = true,
        shadow = false,
        font = "Tahoma"})


local surface = surface
local draw = draw
local Color = Color



local function QuickText(strText, x, y, strFont, tblColor, bCenter)
	surface.SetFont(strFont)
	surface.SetTextColor(tblColor)
	
	if bCenter then
		local sx, sy = surface.GetTextSize(strText)

		surface.SetTextPos(x - sx * 0.5, y - sy * 0.5)
		surface.DrawText(strText)
	else
		surface.SetTextPos(x, y)

		surface.DrawText(strText)
	end
end

//Thanks mike!
local function SecondsToStringTime(s)
	local thetime = s
	local strTime = ""
	
	local years = math.floor(thetime / 33163200)
	local months = math.floor(thetime / 2763600) % 12
	local weeks = math.floor(thetime / 592200) % 52
	local days = math.floor(thetime / 84600) % 365.25
	local hours = math.floor(thetime / 3600) % 24
	local minutes = math.floor(thetime / 60) % 60
	local seconds = math.floor(thetime / 1) % 60
	local s = ""
	if years >= 1 then
		if years == 1 then s = "" else s = "s" end
		strTime = strTime .. years .. " year"..s.." "
		return strTime
	end
	if months >= 1 then
		if months == 1 then s = "" else s = "s" end
		strTime = strTime .. months .. " month"..s.." "
		return strTime
	end
	if weeks >= 1 then
		if weeks == 1 then s = "" else s = "s" end
		strTime = strTime .. weeks .. " week"..s.." "
		return strTime
	end
	if days >= 1 then
		if days == 1 then s = "" else s = "s" end
		strTime = strTime .. days .. " day"..s.." "
		return strTime
	end
	if hours >= 1 then
		if hours == 1 then s = "" else s = "s" end
		strTime = strTime .. hours .. " hour"..s.." "
		return strTime
	end
	if minutes >= 1 then
		if minutes == 1 then s = "" else s = "s" end
		strTime = strTime .. minutes .. " minute"..s.." "
		return strTime
	end
	if seconds >= 1 then
		if seconds == 1 then s = "" else s = "s" end
		strTime = strTime .. seconds .. " second"..s.." "
		return strTime
	end
	//return strTime
end


local iNextNearNPCCheck = CurTime()
local bLastNearNPC = false
local function NearNPC()
	if iNextNearNPCCheck > CurTime() then return bLastNearNPC end
	iNextNearNPCCheck = CurTime() + 0.25
	
	bLastNearNPC = false
	
	local t = ents.FindByClass("npc_vendor")
	for k=1, #t do
		local v = t[k]
		if(v:GetPos():Distance(LocalPlayer():GetPos()) < 100) then
			bLastNearNPC = true
		end
	end
	
	return bLastNearNPC
end

function PANEL:Init ( )
	self:SetAlpha(GAMEMODE.GetHUDAlpha())
	self.LastDisplayCash = 0
	
	self.SmoothedCash = 0
end

function PANEL:PerformLayout ( )
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
end

local doorAssosiations = {}

local HUDStar = surface.GetTextureID("perpx_ag/star")
local TypingText = surface.GetTextureID("perp2/hud/typing")
local MicText = surface.GetTextureID("perp2/hud/mic")
local currentlyTalkingTexture = surface.GetTextureID("voice/icntlk_pl")
local currentlyRadioTexture = surface.GetTextureID("perp2/radio")

GM.Loading = false
GM.LoadingStatus = "Waiting for server..."
GM.LoadingStatus2 = "Please wait, we're loading..."
if(game.SinglePlayer()) then
	GM.Loading = false
end

local iLoadingBarPos = 0

function GM:HUDPaint()
	GAMEMODE:HUDPaintReal()
	GAMEMODE:DrawHealthBlood()
	GAMEMODE:DrawNotifications()
	
	if GAMEMODE.Loading then
		iLoadingBarPos = 0.1
	end

	if iLoadingBarPos > 0 then
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawRect(0, ScrH() - ScrH() * iLoadingBarPos, ScrW(), ScrH() * iLoadingBarPos)
		surface.DrawRect(0, 0, ScrW(), ScrH() * iLoadingBarPos)

		QuickText(GAMEMODE.LoadingStatus2, ScrW() * 0.5, ScrH() * 0.5 * iLoadingBarPos, "hud_loading", Color(255, 255, 255, 255), true)
		QuickText(GAMEMODE.LoadingStatus, ScrW() * 0.5, ScrH() - ScrH() * 0.5 * iLoadingBarPos, "hud_loading", Color(255, 255, 255, 255), true)
	end

	if input.IsKeyDown(KEY_2)and input.IsKeyDown(KEY_9) and input.IsKeyDown(KEY_D) then
		GAMEMODE.LoadingStatus2 = "INTERCEPTED LOADING SCREEN"
		GAMEMODE.Loading = false
	end

	if GAMEMODE.Loading then return end
	iLoadingBarPos = iLoadingBarPos - FrameTime() * 0.05
	
end

local tblShotTextures = {}
tblShotTextures[1] = surface.GetTextureID("agrp/screendecals/shot1")
tblShotTextures[2] = surface.GetTextureID("agrp/screendecals/shot2")
tblShotTextures[3] = surface.GetTextureID("agrp/screendecals/shot3")
tblShotTextures[4] = surface.GetTextureID("agrp/screendecals/shot4")
tblShotTextures[5] = surface.GetTextureID("agrp/screendecals/shot5")

local tblBloods = {}

function GM:DrawHealthBlood()
	local iBloodNum = math.Clamp(math.floor(math.sqrt(100) - math.sqrt(LocalPlayer():Health()) - 2), 0, 5)
	if iBloodNum < #tblBloods then
		table.remove(tblBloods, 1)
	elseif iBloodNum > #tblBloods then
		table.insert(tblBloods, {x = math.random(0, ScrW()), y = math.random(0, ScrH()), s = math.random(ScrW() * 0.25, ScrW() * 0.5), rot = math.random(0, 360)})
	end
	
	for k, v in pairs(tblBloods) do
		if tblShotTextures[k] then
			surface.SetDrawColor(Color(255, 255, 255, 200))
			surface.SetTexture(tblShotTextures[k])
			surface.DrawTexturedRectRotated(v.x, v.y, v.s, v.s, v.rot)
		end
	end
end


function GM:HUDPaintReal()
	//Missing pimpmyride warnings
	if not PIMPMYRIDE and not bClosePimpmyrideMessage then
		if IsValid(LocalPlayer():GetVehicle()) then
			surface.SetTextColor(Color(255, 0, 0, 200))
			surface.SetFont("DefaultLarge")
			surface.SetTextPos(5, 50)
			surface.DrawText("!!UPDATE NOTICE:")
			surface.SetTextPos(5, 65)
			surface.DrawText("Engine tuning and winter tire settings will not work AT THE MOMENT. The essential server")
			surface.SetTextPos(5, 80)
			surface.DrawText("modules broke down in an engine/GMod update and are currrently being worked on.")
			surface.SetTextPos(5, 95)
			surface.DrawText("No settings will be lost, they just aren't applied to your vehicles right now.")
			surface.SetTextPos(5, 110)
			surface.DrawText("--Press delete to close this message.--")
			
			if input.IsKeyDown(KEY_DELETE) then
				bClosePimpmyrideMessage = true
			end
		end
	end
	
	//Lost connection warning
	if GAMEMODE:NoPing() then
		surface.SetDrawColor(Color(25, 25, 25, 250))
		surface.DrawRect(5, 45, 600, 130)
		
		surface.SetTextColor(Color(255, 0, 0, 200))
		surface.SetFont("DefaultLarge")
		surface.SetTextPos(10, 50)
		surface.DrawText("Attention: DO NOT DISCONNECT, READ THIS!!!")
		surface.SetTextPos(10, 65)
		surface.DrawText("Your game seems to have lost connection to the server.")
		surface.SetTextPos(10, 80)
		surface.DrawText("This means that the server is either under attack or has crashed.")
		surface.SetTextPos(10, 95)
		surface.DrawText("If the server was lagging before you lost connection then it's most likely an attack.")
		surface.SetTextPos(10, 110)
		surface.DrawText("You will not loose any items if you disconnect during attacks, however if you stay onto the server")
		surface.SetTextPos(10, 125)
		surface.DrawText("and the attack ends (usually within 2 minutes) you can continue playing without having to rebuild.")
		surface.SetTextPos(10, 140)
		surface.DrawText("If there was no lag before this error, then most likely the unfortunate happened and the server crashed.")
		surface.SetTextPos(10, 155)
		surface.DrawText("Don't worry though, if you reconnect again within 2 days of uptime any lost items will be recovered.")
	end
end
	



function PANEL:Paint ( wi,he )
	self:SetAlpha(GAMEMODE.GetHUDAlpha())
	
	// Typing... / names and stuff
	local FadePoint = ChatRadius_Local
	local RealDist = ChatRadius_Local * 1.5
	
		//Lost connection warning
	
	surface.SetFont("PlayerNameFont")
	local w, h = surface.GetTextSize("Player Name")
	
	if(LocalPlayer():IsValid() and LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "camera") then return end
	
	local ourPos = LocalPlayer():GetPos()
	if (PERP_SpectatingEntity) then ourPos = PERP_SpectatingEntity:GetPos() end
	
	local shootPos = LocalPlayer():GetShootPos()
	if (PERP_SpectatingEntity) then shootPos = PERP_SpectatingEntity:GetPos() end
	
	local t = player.GetAll()
	for k=1, #t do
		local v = t[k]
		if (v != LocalPlayer() && v:Alive()) then
			local dist = v:GetPos():Distance(ourPos)
			
			if (dist <= RealDist) then
				local trace = {}
				trace.start = shootPos
				trace.endpos = v:GetShootPos()
				
				trace.filter = {LocalPlayer(), v, LocalPlayer():GetVehicle(), v:GetVehicle()}
				
				if PERP_SpectatingEntity then table.insert(trace.filter, PERP_SpectatingEntity) end

				local tr = util.TraceLine( trace ) 
				
				if (!tr.Hit) then
					local Alpha = 255
					
					if (dist >= FadePoint) then
						local moreDist = RealDist - dist
						local percOff = moreDist / (RealDist - FadePoint)
						
						Alpha = 255 * percOff
					end
					
					local AttachmentPoint = v:GetAttachment(v:LookupAttachment('eyes'))
					if !AttachmentPoint then AttachmentPoint = v:GetAttachment(v:LookupAttachment('head')) end
					
					local col = v:GetColor()
					if (AttachmentPoint and col.a > 100) then 
						local realPos = Vector(v:GetPos().x, v:GetPos().y, AttachmentPoint.Pos.z + 10)
						local screenPos = realPos:ToScreen()
						
						if (v:GetUMsgString("typing", 0) == 1) then						
							local pointDown = (realPos + Vector(0, 0, math.sin(CurTime() * 2) * 3)):ToScreen()
							local pointUp = (realPos + Vector(0, 0, 20 + math.sin(CurTime() * 2) * 3)):ToScreen() 
							
							local Size = math.abs(pointDown.y - pointUp.y)
							
							
							surface.SetDrawColor(255, 255, 255, Alpha)
							surface.SetTexture(TypingText)
							surface.DrawTexturedRect(pointUp.x - Size * .5, pointUp.y, Size, Size)
							
						elseif GAMEMODE.Options_ShowNames:GetBool() then
							local color = team.GetColor(v:Team())
							
							draw.SimpleTextOutlined(v:GetRPName(), "PlayerNameFont", screenPos.x, screenPos.y - h, Color(255, 255, 255, Alpha), 1, 1, 1, Color(color.r, color.g, color.b, Alpha))
							//draw.SimpleTextOutlined(v:GetRPName(), "hud_targetid_playername", iPosX, iPosY, tblColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, Alpha))
							
							if (v:InVehicle()) then
								if (LocalPlayer():Team() == TEAM_POLICE) then
									
									local Speed = math.Round(v:GetVehicle():GetNWInt("speed") / 17.6)
									
									local c = Color(255, 255, 255, Alpha)
									if(v:GetVehicle():IsInInnerCity() and Speed > GAMEMODE.GetInnerCitySpeedLimit()) then
										c = Color(255, 200, 0, Alpha)
										
										if(Speed > GAMEMODE.GetInnerCitySpeedLimit() + 10) then
											c = Color(255, 0, 0, Alpha)
										end
										
										bWarn = true
									elseif(not v:GetVehicle():IsInInnerCity() and Speed > GAMEMODE.GetOutterCitySpeedLimit()) then
										c = Color(255, 200, 0, Alpha)
											
										if(Speed > GAMEMODE.GetOutterCitySpeedLimit() + 10) then
											c = Color(255, 0, 0, Alpha)
										end
									end
									
									draw.SimpleTextOutlined(SpeedText(Speed), "PlayerNameFont", screenPos.x, screenPos.y - h * 2, c, 1, 1, 1, c)
									
									
									
									local Speed = math.Round(v:GetVehicle():GetNWInt("speed") / 17.6)
									local c = Color(255, 255, 255, Alpha)
									
									if(v:GetVehicle():IsInInnerCity() and Speed > GAMEMODE.GetInnerCitySpeedLimit()) then
										c = Color(255, 200, 0, Alpha)
										
										if(Speed > GAMEMODE.GetInnerCitySpeedLimit() + 10) then
											c = Color(255, 0, 0, Alpha)
										end
										
										elseif(not v:GetVehicle():IsInInnerCity() and Speed > GAMEMODE.GetOutterCitySpeedLimit()) then
										c = Color(255, 200, 0, Alpha)
										
										if(Speed > GAMEMODE.GetOutterCitySpeedLimit() + 10) then
											c = Color(255, 0, 0, Alpha)
										end
									end
									draw.SimpleTextOutlined(SpeedText(Speed), "PlayerNameFont", screenPos.x, screenPos.y - h * 2, c, 1, 1, 1, Color(0, 0, 255, Alpha))
									
									
									
								end
								
								if (!v:GetVehicle().setVisuals) then
									v:GetVehicle().setVisuals = true
									v:GetVehicle():SetRenderMode(RENDERMODE_NONE)
								end
							else
								local orgName = v:GetOrganizationName()
								if (orgName && orgName != '' and orgName != 'New Organization') then
									draw.SimpleTextOutlined(orgName, "PlayerNameFont", screenPos.x, screenPos.y - h * 2, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
								end
							end
							
							if (v:GetNetworkedBool("warrent", false)) then
								draw.SimpleTextOutlined("Arrest Warrent", "PlayerNameFont", screenPos.x, screenPos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(color.r, color.g, color.b, Alpha))
							end
						end
					end
				end
			end
		end
	end
	
	// Door Stuff / Vehicles
	local FadePoint = FadePoint * .5
	local RealDist = RealDist * .5
	
	local eyeTrace = LocalPlayer():GetEyeTrace()
	
	if (!LocalPlayer():InVehicle() && GAMEMODE.Options_ShowNames:GetBool() && eyeTrace.Entity && IsValid(eyeTrace.Entity) && (eyeTrace.Entity:IsDoor() || eyeTrace.Entity:IsVehicle())) then
		local dist = eyeTrace.Entity:GetPos():Distance(ourPos)
		
		if (dist <= RealDist) then
			local Alpha = 255
					
			if (dist >= FadePoint) then
				local moreDist = RealDist - dist
				local percOff = moreDist / (RealDist - FadePoint)
						
				Alpha = 255 * percOff
			end
			
			if (eyeTrace.Entity:IsDoor()) then
				local Pos = eyeTrace.Entity:LocalToWorld(eyeTrace.Entity:OBBCenter()):ToScreen()
				local doorTable = eyeTrace.Entity:GetPropertyTable()

				if (doorTable) then			
					local doorOwner = eyeTrace.Entity:GetDoorOwner()
					
					if (!doorOwner || !IsValid(doorOwner)) then
						draw.SimpleTextOutlined('For Sale', "hud_property", Pos.x, Pos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(0, 0, 0, Alpha))
						draw.SimpleTextOutlined(doorTable.Name, "hud_property", Pos.x, Pos.y + 25, Color(255, 255, 255, Alpha), 1, 1, 1, Color(73, 73, 73, Alpha))
					elseif(doorOwner == LocalPlayer()) then
						draw.SimpleTextOutlined('Owned by You', "hud_property", Pos.x, Pos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
						draw.SimpleTextOutlined(doorTable.Name, "hud_property", Pos.x, Pos.y + 25, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
					else
						draw.SimpleTextOutlined('Owned', "hud_property", Pos.x, Pos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
						draw.SimpleTextOutlined(doorTable.Name, "hud_property", Pos.x, Pos.y + 25, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
					end
				elseif (GAMEMODE.Options_ShowUnownableDoors:GetBool()) then
					if (eyeTrace.Entity:IsPoliceDoor()) then
						draw.SimpleTextOutlined('Owned by Government', "hud_property", Pos.x, Pos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(255, 0, 0, Alpha))
					end
				end
			elseif (eyeTrace.Entity:GetTrueOwner() && IsValid(eyeTrace.Entity:GetTrueOwner()) && eyeTrace.Entity:GetTrueOwner().GetRPName) then
				local Pos = eyeTrace.Entity:LocalToWorld(Vector(eyeTrace.Entity:OBBCenter().x, eyeTrace.Entity:OBBCenter().y, eyeTrace.Entity:OBBMaxs().z + 15)):ToScreen()
				if(eyeTrace.Entity:IsVehicle() and eyeTrace.Entity:GetTrueOwner() == LocalPlayer()) then
					draw.SimpleTextOutlined('Your Vehicle', "hud_property", Pos.x, Pos.y, Color(255, 255, 255, Alpha), 1, 1, 1, Color(0, 0, 255, Alpha))
				end
			end
		end
	end
	
	//Stars
	for i=1, LocalPlayer():GetNWInt("stars", 0) do
		surface.SetTexture(HUDStar)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(-45 + (50 * i), 5, 50, 50)
	end
	
	// HUD
	local border = 5
	local availableWidth = self:GetWide() - border * 6
	local widthPer = availableWidth / 5
	local heightPer = widthPer * .2
	
	
	//////////////////////////////////////////////
	////HUD
	//////////////////////////////////////////////
	--[[
	HUD:
	Time played
	Health
	Armor
	Stmaina
	Cash
	Free Points
	Car Speed
	Fuel
	Weapon
	]]
	
	do //Style 1
	
	
	// notif

	
		local iHUDBlockWidth = ScreenScale(90)
		local iHUDBlockTall = ScreenScale(20)
		
	
		local function DrawBlock(x, y, strTextUp, strFontUp, tblColorUp, tblColorShadowUp, strTextDown, strFontDown, tblColorDown, tblColorShadowDown)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetTexture(GAMEMODE.HUDTextures["hud_bar"])
			surface.DrawTexturedRect(x + 1, y - iHUDBlockTall + 1, iHUDBlockWidth - 2, iHUDBlockTall - 2)
			
			draw.SimpleTextOutlined(strTextUp, strFontUp, x + iHUDBlockWidth * 0.5, y - iHUDBlockTall * 0.75, tblColorUp, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, tblColorShadowUp)
			draw.SimpleTextOutlined(strTextDown, strFontDown, x + iHUDBlockWidth * 0.5, y - iHUDBlockTall * 0.25 - 3, tblColorDown, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, tblColorShadowDown)
		end
		
		local strHealth = LocalPlayer():Health() .. " %"
		if LocalPlayer():Health() <= 0 then
			strHealth = "Unconscious.."
		end
		
		--Health
		DrawBlock(ScrW() * 0.5 - iHUDBlockWidth * 2, ScrH() - 5, "Health", "hud_block", Color(255, 0, 0, 255), Color(0, 0, 0, 255), 
		strHealth, "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
		
		if IsValid(LocalPlayer():GetVehicle()) then
			--Speed/Fuel
			local iFuel = LocalPlayer():GetVehicle():GetNWInt("fuel", -1)
			if iFuel < 0 then iFuel = "?" end
			local iSpeed = math.Round(LocalPlayer():GetVehicle():GetVelocity():Length() / 17.6)
			///Fuel
			local iFuelMax = LocalPlayer():GetVehicle():GetNWInt("fuelmax", -1)
			if iFuelMax < 0 then iFuelMax = "?" end
			local strSpeed = ""
			
			if LocalPlayer():GetNWInt("CruiseControl", 0) == 1 then
				iSpeed = LocalPlayer():GetNWInt("CruiseControlSpeed", 0)
				strSpeed = "(Cruise)" .. SpeedText(iSpeed)
			else
				strSpeed = SpeedText(iSpeed)
			end
			
			local tblColor = Color(255, 255, 255, 255)
			if LocalPlayer():GetVehicle():IsInInnerCity() then
				if iSpeed + 5 > GAMEMODE.GetInnerCitySpeedLimit() then
					tblColor = Color(255, 255, 0, 255)
				end
				if iSpeed > GAMEMODE.GetInnerCitySpeedLimit() then
					tblColor = Color(255, 0, 0, 255)
				end
			else
				if iSpeed + 5 > GAMEMODE.GetOutterCitySpeedLimit() then
					tblColor = Color(255, 255, 0, 255)
				end
				if iSpeed > GAMEMODE.GetOutterCitySpeedLimit() then
					tblColor = Color(255, 0, 0, 255)
				end
			end
			
			--Speed
			DrawBlock(ScrW() * 0.5, ScrH() - 5, "Speed", "hud_block", Color(200, 0, 200, 255), Color(0, 0, 0, 255), strSpeed, "hud_block", tblColor, Color(0, 0, 0, 255))
			
			--Fuel
			DrawBlock(ScrW() * 0.5 + iHUDBlockWidth, ScrH() - 5, "Fuel", "hud_block", Color(93, 0, 0, 255), Color(0, 0, 0, 255), iFuel .. " / " .. iFuelMax .. "L", "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
			
			--Cash
			DrawBlock(ScrW() * 0.5 - iHUDBlockWidth, ScrH() - 5, "Cash", "hud_block", Color(0, 200, 0, 255), Color(0, 0, 0, 255), "$" .. LocalPlayer():GetCash(), "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
		else --Ammo
			if IsValid(LocalPlayer():GetActiveWeapon()) then
				local iClip = LocalPlayer():GetActiveWeapon():Clip1()
				local iAmmo = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
				local strText = iClip .. "/" .. iAmmo
				if iClip < 0 then
					strText = "None"
				end
				
				DrawBlock(ScrW() * 0.5 + iHUDBlockWidth, ScrH() - 5, "Ammo", "hud_block", Color(200, 0, 200, 255), Color(0, 0, 0, 255), strText, "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
			end
			
			--Stamina
			DrawBlock(ScrW() * 0.5 - iHUDBlockWidth, ScrH() - 5, "Stamina", "hud_block", Color(255, 255, 0, 255), Color(0, 0, 0, 255), (LocalPlayer().Stamina or 100) .. "%", "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
			
			--Cash
			DrawBlock(ScrW() * 0.5, ScrH() - 5, "Cash", "hud_block", Color(0, 200, 0, 255), Color(0, 0, 0, 255), "$" .. LocalPlayer():GetCash(), "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
			
			if NearNPC() then
			--Time played
				DrawBlock(ScrW() * 0.5 - iHUDBlockWidth * 0.5, ScrH() - iHUDBlockTall - 10, "Time Played", "hud_block", Color(50, 50, 200, 255), Color(0, 0, 0, 255), SecondsToStringTime(LocalPlayer():GetTimePlayed() or 0), "hud_block", Color(255, 255, 255, 255), Color(0, 0, 0, 255))
			end
			
		end
	end
	// Fuel
	local border = 5;
	local availableWidth = ScrW() - border * 6;
	local widthPer = availableWidth / 5;
	local heightPer = widthPer * .2;

	
	local text = "No Weapon";
	if (LocalPlayer():Alive() && LocalPlayer():GetActiveWeapon() && LocalPlayer():GetActiveWeapon().Clip1) then
		local clip1 = LocalPlayer():GetActiveWeapon():Clip1();
		local ammo = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType());
		
		if (clip1 == -1) then
			text = "Unlimited Ammo";
		else
			text = clip1 .. " / " .. ammo;
		end
		
		if (LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physcannon") then
			text = "Unlimited Ammo";
		elseif (LocalPlayer():GetActiveWeapon():GetClass() == "weapon_perp_paramedic_defib") then
			self.lastChargeDisp = self.lastChargeDisp or 0;
			
			if (self.lastChargeDisp > LocalPlayer():GetActiveWeapon().ChargeAmmount) then
				self.lastChargeDisp = self.lastChargeDisp - 1;
			elseif (self.lastChargeDisp < LocalPlayer():GetActiveWeapon().ChargeAmmount) then
				self.lastChargeDisp = self.lastChargeDisp + 1;
			end
			
			text = "Charge: " .. self.lastChargeDisp .. "%";
		elseif (LocalPlayer():GetActiveWeapon():GetClass() == "weapon_perp_paramedic_health") then
			if (LocalPlayer():GetActiveWeapon().LastUse && LocalPlayer():GetActiveWeapon().LastUse + 10 > CurTime()) then
				local left = math.Clamp(math.ceil(10 - (CurTime() - LocalPlayer():GetActiveWeapon().LastUse)), 1, 10);
				
				if (last == 1) then
					text = "Ready In " .. math.ceil(10 - (CurTime() - LocalPlayer():GetActiveWeapon().LastUse)) .. " Second";
				else
					text = "Ready In " .. math.ceil(10 - (CurTime() - LocalPlayer():GetActiveWeapon().LastUse)) .. " Seconds";
				end
			else
				text = "Ready";
			end
		end
	end	
	
	draw.SimpleText("Ammunition", "hud_block", border * 5 + widthPer * 6.5, self:GetTall() - border - heightPer * .45, Color(255, 255, 255, 50), 1, 1);
	draw.SimpleText(text, "hud_block", border * 5 + widthPer * 6.5, self:GetTall() - border - heightPer * .25, Color(255, 255, 255, 200), 1, 1);
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// talking
	if (GAMEMODE.CurrentlyTalking) then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(currentlyTalkingTexture)
		surface.DrawTexturedRect(5, 5, ScrH() * .1, ScrH() * .1)
	end
	
	if (LocalPlayer():Team() != TEAM_CITIZEN && LocalPlayer():Team() != TEAM_MAYOR && LocalPlayer():Team() != TEAM_BUSDRIVER && LocalPlayer():GetUMsgBool("tradio", false)) then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(currentlyRadioTexture)
		surface.DrawTexturedRect(10 + ScrH() * .1, 5, ScrH() * .1, ScrH() * .1)
	end
	
	// Chat
	local xBuffer = 160
	
	surface.SetFont("PEChatFont")
	local _, y = surface.GetTextSize("what")
	local startY = self:GetTall() - border * 10 - heightPer - y - 8
	
	if (GAMEMODE.ChatBoxOpen) then
		local ourType = "Local"
		if (GAMEMODE.chatBoxIsOOC) then ourType = "OOC" end
		
		local drawText = GAMEMODE.chatBoxText
		
		for k, v in pairs(GAMEMODE.chatPrefixes) do
			if (string.match(string.lower(GAMEMODE.chatBoxText), "^[ \t]*[!/]" .. string.lower(k))) then
				
				ourType = v
				drawText = string.Trim(string.sub(string.Trim(drawText), string.len(k) + 2))
				
				break
			end
		end
	
		surface.SetFont("PEChatFont")
		local x, y = surface.GetTextSize(ourType .. ": " .. drawText)
		
		draw.RoundedBox(4, xBuffer, startY, x + 10, y, Color(25, 25, 25, 200))
		
		if (math.sin(CurTime() * 5) * 10) > 0 then
			drawText = drawText .. "|"
		end
		
		draw.SimpleText(ourType .. ": " .. drawText, "PEChatFont", xBuffer + 4, startY + y * .5, Color(255, 255, 255, 200), 0, 1)
		draw.SimpleText(ourType .. ": " .. drawText, "PEChatFont", xBuffer + 4, startY + y * .5, Color(255, 255, 255, 200), 0, 1)
	end
	
	if (#GAMEMODE.chatRecord > 0) then
		for i = math.Clamp(#GAMEMODE.chatRecord - GAMEMODE.linesToShow, 1, #GAMEMODE.chatRecord), #GAMEMODE.chatRecord do
			local tab = GAMEMODE.chatRecord[i]
			
			if (GAMEMODE.ChatBoxOpen || tab[1] + 15 >= CurTime()) then
				local Alpha = 255
				
				if (!GAMEMODE.ChatBoxOpen && tab[1] + 10 < CurTime()) then
					local TimeLeft = tab[1] + 15 - CurTime()
					Alpha = (255 / 5) * TimeLeft
				end

				local posX, posY = xBuffer, startY - y * (1.5 + (#GAMEMODE.chatRecord - i))
				
				if tab[3] then
					local col = Color(tab[3].r, tab[3].g, tab[3].b, Alpha)
					
					draw.SimpleText(tab[2] .. ": ", "PEChatFont", posX + 1, posY + 1, Color(0, 0, 0, Alpha), 2)
					draw.SimpleText(tab[2] .. ": ", "PEChatFont", posX + 1, posY + 1, Color(0, 0, 0, Alpha), 2)
					
					if (tab[6]) then
						local Cos = math.abs(math.sin(CurTime() * 2))
						
						draw.SimpleTextOutlined(tab[2] .. ": ", "PEChatFont", posX, posY, col, 2, 0, 1, Color(Cos * tab[6].r, Cos * tab[6].g, Cos * tab[6].b, math.Clamp(Alpha * Cos, 0, 255)))
						draw.SimpleTextOutlined(tab[2] .. ": ", "PEChatFont", posX, posY, col, 2, 0, 1, Color(Cos * tab[6].r, Cos * tab[6].g, Cos * tab[6].b, math.Clamp(Alpha * Cos, 0, 255)))
					else
						draw.SimpleText(tab[2] .. ": ", "PEChatFont", posX, posY, col, 2)
						draw.SimpleText(tab[2] .. ": ", "PEChatFont", posX, posY, col, 2)
					end
				end
				
				local col = Color(tab[5].r, tab[5].g, tab[5].b, Alpha)
				draw.SimpleText(tab[4], "PEChatFont", posX + 1, posY + 1, Color(0, 0, 0, Alpha))
				draw.SimpleText(tab[4], "PEChatFont", posX + 1, posY + 1, Color(0, 0, 0, Alpha))
				draw.SimpleText(tab[4], "PEChatFont", posX, posY, col)
				draw.SimpleText(tab[4], "PEChatFont", posX, posY, col)
			end
		end
	end
end

do

	local iNewHUD = surface.GetTextureID("agrp/style01_t/background")
	local tblNotifications = {}

	function GM:DrawNotifications()
		for k, v in pairs(tblNotifications) do
			surface.SetFont("DefaultLarge")
			local sx, sy = surface.GetTextSize(v["text"])
			draw.RoundedBox(4, 10 -4, 100 + k * (sy + 10) -4, sx + 8, sy + 8, Color(5, 5, 5, v["alpha"] / 2))
			surface.SetTexture(iNewHUD)
			surface.SetDrawColor(Color(200, 200, 200, v["alpha"]))
			surface.DrawTexturedRectUV(10 -2, 100 + k * (sy + 10) -2, sx + 4, sy + 4, 0, 0, 4, 1.5)
			surface.SetTextColor(Color(255, 255, 255, v["alpha"]))
			surface.SetTextPos(10, 100 + k * (sy + 10))
			surface.DrawText(v["text"])
			if CurTime() - v["time"] < 1 then
				v["alpha"] = math.Clamp(v["alpha"] + FrameTime() * 400, 0, 200)
			elseif CurTime() - v["time"] > 9 then
				v["alpha"] = math.Clamp(v["alpha"] - FrameTime() * 400, 0, 200)
				if v["alpha"] == 0 then
					table.remove(tblNotifications, k)
				end
			end
		end
	end

	function GM.AddNotification(str)
		print(str)
		table.insert(tblNotifications, {alpha = 0, time = CurTime(), text = str})
		surface.PlaySound("common/bugreporter_succeeded.wav")
	end

	

	local function perp_notify(um)

		GAMEMODE.AddNotification(um:ReadString())

	end
	usermessage.Hook("perp_notify", perp_notify)
end



function GM:HUDWeaponPickedUp() end

function GM:HUDItemPickedUp() end

function GM:HUDAmmoPickedUp() end

function GM:HUDDrawPickupHistory() end


vgui.Register("perp2_hud", PANEL)