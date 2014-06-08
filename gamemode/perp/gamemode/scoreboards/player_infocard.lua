
// This content was derived  //
// from original garry's mod //
//         content.          //
///////////////////////////////

 
include( "admin_buttons.lua" )

local PANEL = {}

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Init()

	self.InfoLabels = {}
	self.InfoLabels[ 1 ] = {}
	self.InfoLabels[ 2 ] = {}
	
	self.btnKick = vgui.Create( "PlayerKickButton", self )
	self.btnBan = vgui.Create( "PlayerBanButton", self )
	self.btnPBan = vgui.Create( "PlayerPermBanButton", self )
	self.btnSpectate = vgui.Create( "PlayerSpectateButton", self )
	self.btnBlacklist = vgui.Create( "PlayerBlacklistButton", self )
	self.btnRename = vgui.Create( "PlayerForceRenameButton", self )
	self.btnSlay = vgui.Create( "PlayerSlayButton", self )
	
	self.btnBlacklistFromSerious 	= vgui.Create( "PlayerBlacklistFromSeriousButton", self )
	
	self.scrollerTime = vgui.Create( "DNumSlider", self )
	self.scrollerTime:SetDecimals(0);
	self.scrollerTime:SetValue(24);
	self.scrollerTime:SetMin(1);
	self.scrollerTime:SetMax(720);
	self.scrollerTime:SetWide(100);
	self.scrollerTime:SetText("Punishment Time ( Hours )");
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:SetInfo( column, k, v )

	if ( !v || v == "" ) then v = "N/A" end

	if ( !self.InfoLabels[ column ][ k ] ) then
	
		self.InfoLabels[ column ][ k ] = {}
		self.InfoLabels[ column ][ k ].Key 	= Label("", self)
		self.InfoLabels[ column ][ k ].Value 	= Label("", self)
		self.InfoLabels[ column ][ k ].Key:SetText( k )
		self.InfoLabels[ column ][ k ].Key:SetColor(Color(0, 0, 0, 100))
		self.InfoLabels[ column ][ k ].Value:SetColor(Color(0, 70, 0, 200))
		self:InvalidateLayout()
	
	end
	
	self.InfoLabels[ column ][ k ].Value:SetText( v )
	return true

end


/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	self:UpdatePlayerData()

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
local titles = {};
titles[0] = "Owner";
titles[1] = "Co-Owner";
titles[3] = "Super Admin";
titles[4] = "Admin";
titles[5] = "Temp Admin";
titles[6] = "Moderator";
titles[7] = "Gold Member";
titles[8] = "VIP";
titles[10] = "Guest";
titles[255] = "Banned";


local IDsToClass = {};
IDsToClass[TEAM_CITIZEN] = "Citizen";
IDsToClass[TEAM_POLICE] = "Police Officer";
IDsToClass[TEAM_SECRET_SERVICE] = "SS Agent";
IDsToClass[TEAM_SWAT] = "SWAT Officer";
IDsToClass[TEAM_MAYOR] = "Mayor";
IDsToClass[TEAM_FIREMAN] = "Fireman";
IDsToClass[TEAM_MEDIC] = "Medic";
IDsToClass[TEAM_DISPATCHER] = "Dispatch";
IDsToClass[TEAM_BUSDRIVER] = "Bus Driver";
IDsToClass[TEAM_ROADSERVICE] = "Road Crew Worker";

function PANEL:UpdatePlayerData()

	if (!self.Player) then return end
	if ( !self.Player:IsValid() ) then return end
	
	self:SetInfo( 1, "SteamID:", self.Player:SteamID())
	self:SetInfo( 1, "UniqueID:", self.Player:UniqueID() )
	self:SetInfo( 1, "Steam Name:", self.Player:Nick() )
	self:SetInfo( 1, "RP Name:", self.Player:GetRPName() )
	
	
	if (titles[self.Player:GetAccessLevel()]) then
		self:SetInfo(1, "Position: ", titles[self.Player:GetAccessLevel()]);
		if (self.Player:SteamID() == "STEAM_0:0:0") then
			self:SetInfo(1, "Position: ", "Programmer");
		end;
	else
		self:SetInfo(1, "Position: ", "Unknown Access");
	end
		
	if (self.Player:Team() && IDsToClass[self.Player:Team()]) then
		self:SetInfo(1, "Class: ", IDsToClass[self.Player:Team()]);
	else
		self:SetInfo(1, "Class: ", "Unknown Class");
	end
	
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()


end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.PlayerUpdate && self.PlayerUpdate > CurTime() ) then return end
	self.PlayerUpdate = CurTime() + 0.25
	
	self:UpdatePlayerData()
	
	self.scrollerTime:SetText("Punishment Time ( Hours ) - " .. (self.scrollerTime:GetValue() / 24) .. " Days");

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()	

	local x = 5

	for colnum, column in pairs( self.InfoLabels ) do
	
		local y = 0
		local RightMost = 0
	
		for k, v in pairs( column ) do
	
			v.Key:SetPos( x, y )
			v.Key:SizeToContents()
			
			v.Value:SetPos( x + 70 , y )
			v.Value:SizeToContents()
			
			y = y + v.Key:GetTall() + 2
			
			RightMost = math.max( RightMost, v.Value.x + v.Value:GetWide() )
		
		end
		
		//x = RightMost + 10
		x = x + 300
	
	end
	
	if ( !self.Player || !LocalPlayer():IsModerator() ) then 
	
		self.btnKick:SetVisible( false )
		self.btnBan:SetVisible( false )
		self.btnPBan:SetVisible( false )
		self.btnSpectate:SetVisible( false )
		self.btnBlacklist:SetVisible( false )
		self.btnBlacklistFromSerious:SetVisible( false )
		self.btnRename:SetVisible( false )
	
	else
	
		self.btnKick:SetVisible( true )
		self.btnBan:SetVisible( true )
		self.btnSpectate:SetVisible( true )
		self.btnBlacklist:SetVisible( true )
		self.btnBlacklistFromSerious:SetVisible( true )
		self.btnRename:SetVisible( true )
	
		local sizeOButton = 60;
	
		self.btnBlacklistFromSerious:SetPos( self:GetWide() - (sizeOButton + 4) * 5, 80 )
		self.btnBlacklistFromSerious:SetSize( sizeOButton, 20 )
		
		self.btnRename:SetPos( self:GetWide() - (sizeOButton + 4) * 6, 80 )
		self.btnRename:SetSize( sizeOButton, 20 )
		
		self.btnBlacklist:SetPos( self:GetWide() - (sizeOButton + 4) * 4, 80 )
		self.btnBlacklist:SetSize( sizeOButton, 20 )
	
		self.btnSpectate:SetPos( self:GetWide() - (sizeOButton + 4) * 3, 80 )
		self.btnSpectate:SetSize( sizeOButton, 20 )
	
		self.btnKick:SetPos( self:GetWide() - (sizeOButton + 4) * 2, 80 )
		self.btnKick:SetSize( sizeOButton, 20 )

		self.btnBan:SetPos( self:GetWide() - (sizeOButton + 4) * 1, 80 )
		self.btnBan:SetSize( sizeOButton, 20 )
		
		self.btnSlay:SetPos( self:GetWide() - (sizeOButton + 4) * 7, 80 )
		self.btnSlay:SetSize( sizeOButton, 20 )
		
		if (LocalPlayer():IsSuperAdmin()) then
			self.btnPBan:SetPos( self:GetWide() - (sizeOButton + 4) * 8, 80 )
			self.btnPBan:SetSize( sizeOButton, 20 )
			self.btnPBan:SetVisible( true )
		else
			self.btnPBan:SetVisible( false )
		end
	
	end
	
	self.scrollerTime:SetPos(self:GetWide() - 305, 5);
	self.scrollerTime:SetSize(300, 30);
end

function PANEL:Paint()
	return true
end


vgui.Register( "ScorePlayerInfoCard", PANEL, "Panel" )