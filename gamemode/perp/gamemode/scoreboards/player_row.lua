
// This content was derived  //
// from original garry's mod //
//         content.          //
///////////////////////////////


include("player_infocard.lua"); 

local texGradient = surface.GetTextureID( "gui/center_gradient" )

local texRatings = {}
texRatings[ 'none' ] 		= surface.GetTextureID( "gui/silkicons/user" )
texRatings[ 'smile' ] 		= surface.GetTextureID( "gui/silkicons/emoticon_smile" )
texRatings[ 'bad' ] 		= surface.GetTextureID( "gui/silkicons/exclamation" )
texRatings[ 'love' ] 		= surface.GetTextureID( "gui/silkicons/heart" )
texRatings[ 'artistic' ] 	= surface.GetTextureID( "gui/silkicons/palette" )
texRatings[ 'star' ] 		= surface.GetTextureID( "gui/silkicons/star" )
texRatings[ 'builder' ] 	= surface.GetTextureID( "gui/silkicons/wrench" )

surface.GetTextureID( "gui/silkicons/emoticon_smile" )
local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Size = 36
	self:OpenInfo( false )
	
	self.infoCard	= vgui.Create( "ScorePlayerInfoCard", self )
		
	self.lblName 	= Label("", self)
	self.lblName:SetPaintBackgroundEnabled(false)
	self.lblPing 	= Label("", self)
	self.lblPing:SetPaintBackgroundEnabled(false)
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled( false )
	self.lblPing:SetMouseInputEnabled( false )
	
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	
	self:SetCursor( "hand" )
	
	self.lblName:SetColor( color_white )
	self.lblPing:SetColor( color_white )
	
	self.lblName:SetFont( "ScoreboardPlayerNameBig" )
	self.lblPing:SetFont( "ScoreboardPlayerName" )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	local color = Color( 100, 150, 245, 255 )

	if ( !IsValid( self.Player ) ) then return end
		
	self.lblName:SetColor( Color( 255, 255, 255, 255) )
	if ( self.Player:IsOwner()  && (self.Player:GetSharedBool("disguise", false) != true)) then
		color = Color( 0, 0, 0, 255);
		self.lblName:SetColor(Color(255, 0, 0, 55 + 200 * math.abs(math.sin(CurTime() * 2))))
	elseif ( self.Player:IsSuperAdmin()  && (self.Player:GetSharedBool("disguise", false) != true) ) then
		color = Color( 0, 0, 0, 255);
		self.lblName:SetColor(Color(128, 0, 128, 55 + 200 * math.abs(math.sin(CurTime() * 2))))
	elseif ( self.Player:IsAdmin()  && (self.Player:GetSharedBool("disguise", false) != true) ) then
		color = Color( 0, 0, 0, 255 )
		self.lblName:SetColor(Color(0, 255, 0, 55 + 200 * math.abs(math.sin(CurTime() * 2))))
	elseif ( self.Player:IsModerator()  && (self.Player:GetSharedBool("disguise", false) != true) ) then
		color = Color( 255, 120, 0, 255 )
	elseif ( self.Player:IsGoldMember() ) then
		color = Color( 255, 102, 255, 255 )
	elseif ( self.Player:IsVIP() ) then
		color = Color( 50, 50, 200, 255 )
	elseif ( self.Player:GetFriendStatus() == "friend" ) then
		color = Color( 236, 181, 113, 255 )	
	end
	
	if ( self.Open || self.Size != self.TargetSize ) then
	
		draw.RoundedBox( 4, 0, 16, self:GetWide(), self:GetTall() - 16, color )
		draw.RoundedBox( 4, 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2, Color( 250, 250, 245, 255 ) )
		
		surface.SetTexture( texGradient )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2 ) 
	
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	if ( self.Player == LocalPlayer() ) then
		surface.SetDrawColor( 255, 255, 255, 150 + math.sin(RealTime() * 2) * 50 )
	else
		surface.SetDrawColor( 255, 255, 255, 70 )
	end
	
	if(self.Player:IsAdmin() and self.Player:GetSharedBool("disguise", false) != true) then
		if ( self.Player:IsOwner() && self.Player:GetSharedBool("disguise", false) != true) then
			surface.SetDrawColor( 255, 0, 0, 150 + math.sin(RealTime() * 2) * 50 )
		elseif ( self.Player:IsSuperAdmin() && self.Player:GetSharedBool("disguise", false) != true) then
			surface.SetDrawColor(128, 0, 128, 150 + math.sin(RealTime() * 2) * 50 )
		elseif ( self.Player:IsAdmin() && self.Player:GetSharedBool("disguise", false) != true) then
			surface.SetDrawColor( 0, 255, 0, 150 + math.sin(RealTime() * 2) * 50 )
		end
	else
		surface.SetDrawColor( 255, 255, 255, 70 )
	end
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 )

	return true

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	
	self.infoCard:SetPlayer( ply )
	self.imgAvatar:SetPlayer( ply )
	
	self:UpdatePlayerData()

end

function PANEL:CheckRating( name, count )

	if ( self.Player:GetSharedInt( "Rating."..name, 0 ) > count ) then
		count = self.Player:GetSharedInt( "Rating."..name, 0 )
		self.texRating = texRatings[ name ]
	end
	
	return count

end


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



/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

	if ( !self.Player ) then return end
	if ( !self.Player:IsValid() ) then return end

	if LocalPlayer():IsModerator() then
		self.lblName:SetText( self.Player:Nick() .. " [ " .. self.Player:GetRPName() .. " ]" .. " [ " .. IDsToClass[self.Player:Team()] .. " ] ")
	else
		self.lblName:SetText( self.Player:Nick() )
	end
	
	self.lblPing:SetText( self.Player:Ping() )
end



/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/

function PANEL:ApplySchemeSettings()

	self.lblName:SetFont( "ScoreboardPlayerNameBig" )
	self.lblPing:SetFont( "ScoreboardPlayerName" )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:DoClick( x, y )
	if (!LocalPlayer():IsModerator()) then return; end

	if ( self.Open ) then
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	else
		surface.PlaySound( "ui/buttonclick.wav" )
	end

	self:OpenInfo( !self.Open )
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:OpenInfo( bool )

	if ( bool ) then
		self.TargetSize = 150
	else
		self.TargetSize = 36
	end
	
	self.Open = bool

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Size != self.TargetSize ) then
	
		self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
		self:PerformLayout()
		SCOREBOARD:InvalidateLayout()
	//	self:GetParent():InvalidateLayout()
	
	end
	
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
	
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		
	end

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.imgAvatar:SetPos( 2, 2 )
	self.imgAvatar:SetSize( 32, 32 )

	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 4 )
	self.lblName:MoveRightOf( self.imgAvatar, 8 )
	
	local COLUMN_SIZE = 50
	
	self.lblPing:SetPos( self:GetWide() - COLUMN_SIZE * 1, 4 )
	
	if ( self.Open || self.Size != self.TargetSize ) then
	
		self.infoCard:SetVisible( true )
		self.infoCard:SetPos( 4, self.imgAvatar:GetTall() + 10 )
		self.infoCard:SetSize( self:GetWide() - 8, self:GetTall() - self.lblName:GetTall() - 10 )
	
	else
	
		self.infoCard:SetVisible( false )
	
	end	

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )

	if ( !self.Player:IsValid() || self.Player:Team() == TEAM_CONNECTING ) then return false end
	if ( !row.Player:IsValid() || row.Player:Team() == TEAM_CONNECTING ) then return true end

	if self.Player:GetSharedBool("disguise", false) == true then
		return 7 < row.Player:GetAccessLevel()
	
	elseif row.Player:GetSharedBool("disguise", false) == true then
		return self.Player:GetAccessLevel() < 7
	end
	return self.Player:GetAccessLevel() < row.Player:GetAccessLevel()

end


vgui.Register( "ScorePlayerRow", PANEL, "Button" )