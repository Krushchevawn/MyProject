
local TOPSCREEN_OVERLAY = surface.GetTextureID("PERP3/VGUI/topscreen_overlay1");
local cState = 0;

function GM:DrawTopScreenOverlay()
	
	local scrW, scrH = ScrW(), ScrH();
	local traced = {}
	traced.start = LocalPlayer():GetPos()
	traced.endpos = LocalPlayer():GetPos()+Vector(0,0,700)
	traced.mask = MASK_NPCWORLDSTATIC
	local tr=util.TraceLine(traced)
	
	if tr.HitWorld then
		cState = math.Approach(cState,255,5)
		surface.SetDrawColor(0, 0, 0, cState);
	else
		cState = math.Approach(cState,0,5)
		surface.SetDrawColor(0, 0, 0, cState);
	end;
	
	surface.SetTexture(TOPSCREEN_OVERLAY);
	surface.DrawTexturedRect(0, 0, scrW, scrH);
	surface.DrawTexturedRect(0, 0, scrW, scrH);
end;

function GM:InitPostEntity ( )
	self.Initialized = true;

	
	RunConsoleCommand("password", "");
	
	// If we have already received notification from server of status, lets act on it.
	RunConsoleCommand("perp_lp");
	
	GAMEMODE.GatherInvalidNames();
	
	// Make our emitters;
	GLOBAL_EMITTER = ParticleEmitter(Vector(0, 0, -5000));
	GLOBAL_EMITTER:SetNearClip(50, 200);
	SMOKE_EMITTER = ParticleEmitter(Vector(0, 0, -5000));
	SMOKE_EMITTER:SetNearClip(50, 200);
	
	GAMEMODE.HUD = vgui.Create("perp2_blood");
	GAMEMODE.Phone = vgui.Create("perp2_phone");
	GAMEMODE.HUD = vgui.Create("perp2_hud");
	GAMEMODE.Radar = vgui.Create("perp_radar")
	
	GAMEMODE.InventoryPanel = vgui.Create("perp2_inventory");
	GAMEMODE.InventoryPanel:SetVisible(false);
	GAMEMODE.DialogPanel = vgui.Create("perp2_dialog");
	GAMEMODE.DialogPanel:SetVisible(false);
	
	GAMEMODE.WarehousePanel = vgui.Create("perp2_warehouse")
	

	
	GAMEMODE.CurrentLoadStatus = 1;
	if (!game.SinglePlayer()) then
		GAMEMODE.LoadScreen = vgui.Create("perp2_loading");
	end
	
	LocalPlayer().Stamina = 100;
	
	// buddies
	GAMEMODE.Buddies = {};
	
	if (file.Exists("perp_buddies.txt", "DATA")) then
		local loadBuddies = file.Read("perp_buddies.txt");
		
		local explodedBuddies = string.Explode("\n", loadBuddies);
		
		for k, v in pairs(explodedBuddies) do
			local miniSplit = string.Explode("\t", v);
			
			if (#miniSplit == 3) then
				if (tostring(tonumber(miniSplit[2])) == tostring(miniSplit[2])) then
					table.insert(GAMEMODE.Buddies, {miniSplit[1], miniSplit[2], miniSplit[3]});
					
					RunConsoleCommand("perp_ab", miniSplit[2]);
				end
			end
		end
	end
end

function GM:ShutDown ( )
	
end

GM.PlayerNamesForReport = {};
function GM.FindPlayerNamesForReports ( )
	for k, v in pairs(GAMEMODE.PlayerNamesForReport) do
		if (!v[1] || !IsValid(v[1]) || !v[1]:IsPlayer()) then
			if (v[4]) then
				if (CurTime() - v[4] > (60 * 5)) then
					GAMEMODE.PlayerNamesForReport[k] = nil;
				end
			else
				v[1] = nil;
				v[4] = CurTime();
			end
		end
	end

	for k, v in pairs(player.GetAll()) do
		if (v != LocalPlayer()) then
			local hasData = false;
			
			for k, l in pairs(GAMEMODE.PlayerNamesForReport) do
				if (l[1] == v) then
					hasData = true;
					break;
				end
			end
			
			if (!hasData && v:GetRPName() != "John Doe") then
				table.insert(GAMEMODE.PlayerNamesForReport, {v, v:GetRPName(), v:UniqueID()});
			end
		end
	end
end
timer.Create("GM.FindPlayerNamesForReports", 1, 0, function() GAMEMODE.FindPlayerNamesForReports() end)

function GM:HUDPaint ( ) return self.DrawTopScreenOverlay(); end

function GM:HUDWeaponPickedUp ( ) end
function GM:HUDItemPickedUp ( ) end
function GM:HUDAmmoPickedUp ( ) end
function GM:HUDDrawPickupHistory ( ) end
function GM:GravGunPunt ( ) return false; end

function GM:PlayerFootstep( ply, pos, foot, newsound, volume, rf ) 
	if (ply:IsInside()) then return; end
	if (!GAMEMODE.SnowOnGround) then return; end

	local randSound = math.random(1, 6)
	ply.lastFootSound = self.lastFootSound or 1;
	
	while (randSound == ply.lastFootSound) do
		randSound = math.random(1, 6);
	end
	
	ply.lastFootSound = randSound;
	
	sound.Play(Sound("player/footsteps/snow" .. randSound .. ".wav"), pos, 65);
	return true
end

// We do it like this because the real hook way doesn't work... Still...
function GM.DoShouldDraw ( Type )
	if (Type == "CHudAmmo" or Type == "CHudSecondaryAmmo" or Type == "CHudHealth" or Type == "CHudSuit" or Type == "CHudBattery" or Type == "CHudCrosshair") then
		return false;
	end;
end
hook.Add("HUDShouldDraw", "GM.DoShouldDraw", GM.DoShouldDraw);

function GM.FetchOrgData ( )
	if (LocalPlayer():GetSharedInt("org", 0) != 0 && !GAMEMODE.OrganizationData[LocalPlayer():GetSharedInt("org", 0)]) then
		hook.Remove("Think", "FetchOrgData");
		RunConsoleCommand("perp_rod", LocalPlayer():GetSharedInt("org", 0));
	end
end
hook.Add("Think", "FetchOrgData", GM.FetchOrgData);

function DefaultRenderScreenspaceEffects( )
    local default = {}
    default[ "$pp_colour_addr" ]        = 0
    default[ "$pp_colour_addg" ]        = 0
    default[ "$pp_colour_addb" ]        = 0
    default[ "$pp_colour_brightness" ]  = 0
    default[ "$pp_colour_contrast" ]    = 1
    default[ "$pp_colour_colour" ]      = math.Clamp( LocalPlayer():Health() / 100, 0, 1 )
    default[ "$pp_colour_mulr" ]        = 0
    default[ "$pp_colour_mulg" ]        = 0
    default[ "$pp_colour_mulb" ]        = 0
     
    DrawColorModify( default )
end
hook.Add("RenderScreenspaceEffects", "DefaultRenderScreenspaceEffects", DefaultRenderScreenspaceEffects);

function GM:PlayerNoClip ( Player )
	return Player:IsSuperAdmin() or game.SinglePlayer();
end

/*
function GM.ReceiveLog()
	local logtype = net.ReadString()
	local log = net.ReadString()
	GAMEMODE.AddLog(logtype, log)
end
net.Receive("perp_log", GM.ReceiveLog)*/