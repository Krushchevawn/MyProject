
function GM.GetUMsgString ()
	local Entity = net.ReadEntity();
	local ID = net.ReadString()
	local Type = net.ReadInt(16)
	
	if (!Entity || !IsValid(Entity)) then Msg("Failed to receive a Net string.\n"); return; end
	
	Entity.StringRedun = Entity.StringRedun or {};
	
	local Table = {entity = Entity};
	if (Type == 1) then
		Table.value = net.ReadString()
	elseif (Type == 2) then
		Table.value = net.ReadFloat()
	elseif (Type == 3) then
		if (ID == "cash" || ID == "bank" || ID == "fuel") then
			Table.value = net.ReadInt(32)
		else
			Table.value = net.ReadInt(16)
		end
	elseif (Type == 4) then
		Table.value = tobool(net.ReadBit())
	else
		Entity.StringRedun[ID] = nil;
		return
	end
	
	local loadVar = tobool(net.ReadBool())
	
	if (!Entity.StringRedun) then Entity.StringRedun = {}; end
	
	if (loadVar) then
		if (Entity.StringRedun[ID]) then return; end
	end
	
	Entity.StringRedun[ID] = Table;
end
net.Receive("perp_ums", GM.GetUMsgString)

function GM.GetPrivateString ()
	local Entity = LocalPlayer()
	local ID = net.ReadString()
	local Type = net.ReadInt(16)
	
	Entity.StringRedunP = Entity.StringRedunP or {};
	
	local Table = {entity = Entity};
	if (Type == 1) then
		Table.value = net.ReadString();
	elseif (Type == 2) then
		Table.value = net.ReadFloat()
	elseif (Type == 3) then
		if (ID == "cash" || ID == "bank" || ID == "fuel") then
			Table.value = net.ReadInt(32)
		else
			Table.value = net.ReadInt(16)
		end
	elseif (Type == 4) then
		Table.value = tobool(net.ReadBit())
	else
		Entity.StringRedunP[ID] = nil;
		return
	end
	
	Entity.StringRedunP[ID] = Table;
end
net.Receive("perp_ps", GM.GetPrivateString);

function GM.GetStartupVals()
	local Vals = net.ReadTable()
	local TimePlayed 		= Vals["TimePlayed"]
	local Cash 				= Vals["Cash"]
	local BankCash 			= Vals["BankCash"]
	local FuelLeft			= Vals["FuelLeft"]
	local LastCar			= Vals["LastCar"]
	GAMEMODE.CurrentTime 	= Vals["CurrentTime"]
	GAMEMODE.CurrentDay 	= Vals["CurrentDay"]
	GAMEMODE.CurrentMonth 	= Vals["CurrentMonth"]
	GAMEMODE.CurrentYear 	= Vals["CurrentYear"]
	
	GAMEMODE.LoadTime = CurTime();
		
	LocalPlayer():SetPrivateInt("time_played", tonumber(TimePlayed));
	LocalPlayer():SetPrivateInt("cash", Cash);
	LocalPlayer():SetPrivateInt("bank", BankCash);
	LocalPlayer():SetPrivateInt("fuelleft", FuelLeft);
	LocalPlayer():SetPrivateString("lastcar", LastCar);
	
	GAMEMODE.CurrentLoadStatus = 3;
end
net.Receive( "perp_startup", GM.GetStartupVals)

function GM.SetSharedFuel ( UMsg )
	local FuelLeft			= UMsg:ReadShort();
	
	LocalPlayer():SetPrivateInt("fuelleft", FuelLeft);
end
usermessage.Hook("send_fuel", GM.SetSharedFuel);

local opened = false
function GM.OpenInventory ( )
	local newMode = !GAMEMODE.InventoryPanel:IsVisible();
	
	if (GAMEMODE.ShopPanel) then
		GAMEMODE.ShopPanel:Remove();
		GAMEMODE.ShopPanel = nil;
		gui.EnableScreenClicker(false);
		LocalPlayer():ClearForcedEyeAngles();
		
		return;
	end
	
	GAMEMODE.InventoryPanel:SetVisible(newMode);
	gui.EnableScreenClicker(newMode)
	if(!opened) then
		GAMEMODE.InventoryPanel:UpdateMixtures()
		opened = true;
	end
end
usermessage.Hook("perp_inventory", GM.OpenInventory);

function GM.ForceOpenInv ( )
	
	if (GAMEMODE.ShopPanel) then
		GAMEMODE.ShopPanel:Remove();
		GAMEMODE.ShopPanel = nil;
		gui.EnableScreenClicker(false);
		LocalPlayer():ClearForcedEyeAngles();
		
		return;
	end
	
	GAMEMODE.InventoryPanel:SetVisible(true);
	gui.EnableScreenClicker(true)
	
end

function GM.ForceCloseInv ( )
	
	if (GAMEMODE.ShopPanel) then
		GAMEMODE.ShopPanel:Remove();
		GAMEMODE.ShopPanel = nil;
		gui.EnableScreenClicker(false);
		LocalPlayer():ClearForcedEyeAngles();
		
		return;
	end
	
	GAMEMODE.InventoryPanel:SetVisible(false);
	gui.EnableScreenClicker(false)
end


function GM.OpenBuddies ( )
	if (GAMEMODE.InventoryPanel:IsVisible() || GAMEMODE.ShopPanel) then return; end

	GAMEMODE.BuddyPanel = vgui.Create("perp2_buddies");
end
usermessage.Hook("perp_buddies", GM.OpenBuddies);

function GM.OpenHelp ( )
	if (GAMEMODE.InventoryPanel:IsVisible() || GAMEMODE.ShopPanel) then return; end

	GAMEMODE.HelpPanel = vgui.Create("perp2_help");
end
usermessage.Hook("perp_help", GM.OpenHelp);

function GM.OpenOrg ( )
	if (GAMEMODE.InventoryPanel:IsVisible() || GAMEMODE.ShopPanel) then return; end

	if (LocalPlayer():Team() == TEAM_MAYOR) then
		GAMEMODE.MayorPanel = vgui.Create("perp2_mayor_tab");
	else
		GAMEMODE.OrgPanel = vgui.Create("perp2_organization");
	end
end
usermessage.Hook("perp_org", GM.OpenOrg);

local function ForceChangeName ( )
	ShowRenamePanel(true);
end
usermessage.Hook("perp_rename", ForceChangeName);

local function getSRod ( UMsg ) 
	local id = UMsg:ReadShort();
	local str = UMsg:ReadString();
	
	GAMEMODE.OrganizationData[id] = GAMEMODE.OrganizationData[id] or {};
	GAMEMODE.OrganizationData[id][1] = str;
end
usermessage.Hook("perp_srod", getSRod);

local function getRod ( UMsg ) 
	local id = UMsg:ReadShort();
	local str = UMsg:ReadString();
	local motd = UMsg:ReadString();
	local name = UMsg:ReadString();
	local wereLeader = UMsg:ReadBool();
	
	GAMEMODE.OrganizationData[id] = {str, motd, name, wereLeader};
end
usermessage.Hook("perp_rod", getRod);

local function getRodM ( UMsg ) 
	local id = UMsg:ReadShort();
	local name = UMsg:ReadString();
	local uid = UMsg:ReadString();
	
	GAMEMODE.OrganizationMembers[id] = GAMEMODE.OrganizationMembers[id] or {};
	
	table.insert(GAMEMODE.OrganizationMembers[id], {name, uid});
end
usermessage.Hook("perp_rod_m", getRodM);

local function getRodC ( UMsg ) 
	local id = UMsg:ReadShort();
	local uid = UMsg:ReadString();

	if (!GAMEMODE.OrganizationMembers[id]) then return; end
	
	for k, v in pairs(GAMEMODE.OrganizationMembers[id]) do
		if (v[2] == uid) then
			GAMEMODE.OrganizationMembers[id][k] = nil;
			break;
		end
	end
end
usermessage.Hook("perp_rod_c", getRodC);

local function getInvite ( UMsg ) 
	local name = UMsg:ReadString();
	
	if (GAMEMODE.InvitePanel) then
		GAMEMODE.InvitePanel:Remove();
	end
	
	GAMEMODE.InvitePanel = vgui.Create("perp2_invite");
	GAMEMODE.InvitePanel:SetOrg(name);
end
usermessage.Hook("perp_invite", getInvite);

local function stripMain ( )
	for i = 1, 2 do
		if (GAMEMODE.PlayerItems[i]) then
			GAMEMODE.PlayerItems[i] = nil;
			GAMEMODE.InventoryBlocks_Linear[i]:GrabItem();
		end
	end
end
usermessage.Hook('perp_strip_main', stripMain);

local function weArrested ( UMsg )
	local ARREST_TIME = UMsg:ReadShort();
	GAMEMODE.UnarrestTime = CurTime() + ARREST_TIME;
end
usermessage.Hook('perp_arrested', weArrested);

local function weArrested ( UMsg )
	GAMEMODE.UnarrestTime = nil
end
usermessage.Hook('perp_unarrested', weArrested);

function GM.CarAlarm ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	Entity:EmitSound("perp2.5/house_alarm_long.mp3");
end
usermessage.Hook('perp_car_alarm', GM.CarAlarm);

function GM.HouseAlarm ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	Entity:EmitSound("perp2.5/house_alarm_long.mp3");
end
usermessage.Hook('perp_house_alarm', GM.HouseAlarm);

function BombInit ( UMsg )
	local pos = UMsg:ReadVector();
	
	local effectdata = EffectData()
		effectdata:SetOrigin( pos )
	util.Effect( "explosion_car", effectdata )
								
	local effectdata = EffectData()
		effectdata:SetOrigin( pos )
	util.Effect( "Explosion", effectdata, true, true )
end
usermessage.Hook("perp_bomb", BombInit);

local function resetStam ( )
	LocalPlayer().Stamina = 100;
end
usermessage.Hook("perp_reset_stam", resetStam);

local function ReceivePing()
	GAMEMODE.LastPing = CurTime()
end
usermessage.Hook("agrp_ping", ReceivePing)

function GM:NoPing()
	if not GAMEMODE.LastPing then return false end
	return GAMEMODE.LastPing + 5 < CurTime()
end