
// This content was derived  //
// from original garry's mod //
//         content.          //
///////////////////////////////

 
 
include( "player_row.lua" )
include( "player_frame.lua" )

local texGradient 	= surface.GetTextureID( "gui/center_gradient" )
local texLogo 		= surface.GetTextureID( "gui/gmod_logo" )


local PANEL = {}
local Disguised = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()

	SCOREBOARD = self
	
	self.Hostname = Label(GetHostName(), self)
	self.Hostname:SetPaintBackgroundEnabled(false)
	
	self.Description = Label("Pulsar Effect Roleplay 3", self)
	self.Description:SetPaintBackgroundEnabled(false)
	
	self.PlayerFrame = vgui.Create( "PlayerFrame", self )
	
	self.PlayerRows = {}

	self:UpdateScoreboard()
	
	// Update the scoreboard every 1 second
	timer.Create( "ScoreboardUpdater", 1, 0, function() self.UpdateScoreboard(self) end)
	
	self.lblPing = Label("Ping", self)
	self.lblPing:SetPaintBackgroundEnabled(false)
	
	self.lblPolice = Label("", self)
	self.lblPolice:SetPaintBackgroundEnabled(false)
	
	self.lblFiremen = Label("", self)
	self.lblFiremen:SetPaintBackgroundEnabled(false)
	
	self.lblMedics = Label("", self)
	self.lblMedics:SetPaintBackgroundEnabled(false)

	self.lblSWAT = Label("", self)
	self.lblSWAT:SetPaintBackgroundEnabled(false)
	
	self.lblDispatcher = Label("", self)
	self.lblDispatcher:SetPaintBackgroundEnabled(false)
	
	self.lblSecretService = Label("", self)
	self.lblSecretService:SetPaintBackgroundEnabled(false)
	
	self.lblMayor = Label("", self)
	self.lblMayor:SetPaintBackgroundEnabled(false)
	
	self.lblBus = Label("", self)
	self.lblBus:SetPaintBackgroundEnabled(false)
	
	self.lblRoad = Label("", self)
	self.lblRoad:SetPaintBackgroundEnabled(false)
	
	self.Hostname:SetColor( Color( 0, 0, 0, 200 ) )
	self.Description:SetColor( color_white )
		
	self.lblPing:SetColor( Color( 0, 0, 0, 200 ) )
	self.lblPolice:SetColor( team.GetColor( TEAM_POLICE ))
	self.lblFiremen:SetColor( team.GetColor( TEAM_FIREMAN ) )
	self.lblMedics:SetColor( team.GetColor( TEAM_MEDIC ) )
	self.lblSWAT:SetColor( team.GetColor( TEAM_SWAT ) )
	self.lblDispatcher:SetColor( team.GetColor( TEAM_DISPATCHER ) )
	self.lblSecretService:SetColor( team.GetColor( TEAM_SECRET_SERVICE ) )
	self.lblMayor:SetColor( team.GetColor( TEAM_MAYOR ) )
	self.lblBus:SetColor( team.GetColor( TEAM_BUSDRIVER ) )
	self.lblRoad:SetColor( team.GetColor( TEAM_ROADSERVICE ) )
	
	self.Hostname:SetFont( "ScoreboardHeader" )
	self.Description:SetFont( "ScoreboardSubtitle" )
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:AddPlayerRow( ply )

	local button = vgui.Create( "ScorePlayerRow", self.PlayerFrame:GetCanvas() )
	button:SetPlayer( ply )
	self.PlayerRows[ ply ] = button

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:GetPlayerRow( ply )

	return self.PlayerRows[ ply ]

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	self.lblPolice:SetText("Officers: " .. team.NumPlayers(TEAM_POLICE) .. " / " .. GAMEMODE.MaximumCops);
	self.lblFiremen:SetText("Firemen: " .. team.NumPlayers(TEAM_FIREMAN) .. " / " .. GAMEMODE.MaximumFireMen);
	self.lblMedics:SetText("Medics: " .. team.NumPlayers(TEAM_MEDIC) .. " / " .. GAMEMODE.MaximumParamedic);
	self.lblSWAT:SetText("SWAT: " .. team.NumPlayers(TEAM_SWAT) .. " / " .. GAMEMODE.MaximumSWAT);
	self.lblDispatcher:SetText("Dispatchers: " .. team.NumPlayers(TEAM_DISPATCHER) .. " / " .. GAMEMODE.MaximumDispatchers);
	self.lblSecretService:SetText("Secret Service: " .. team.NumPlayers(TEAM_SECRET_SERVICE) .. " / " .. GAMEMODE.MaximumSecretService);
	self.lblMayor:SetText("Mayor: " .. team.NumPlayers(TEAM_MAYOR) .. " / " .. 1);
	self.lblBus:SetText("Bus Driver: " .. team.NumPlayers(TEAM_BUSDRIVER) .. " / " ..  GAMEMODE.MaximumBusDrivers);
	self.lblRoad:SetText("Road Crew: " .. team.NumPlayers(TEAM_ROADSERVICE) .. " / " .. GAMEMODE.MaximumRoadService);

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() ) 
	
	// White Inner Box
	draw.RoundedBox( 4, 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4, Color( 230, 230, 230, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4 )
	
	// Sub Header
	draw.RoundedBox( 4, 5, self.Description.y - 3, self:GetWide() - 10, self.Description:GetTall() + 5, Color( 10, 10, 10, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 100, 100, 100, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self.Description:GetTall() + 8 ) 
	
	// Logo!
	surface.SetTexture( texLogo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 128, 128 ) 
	
	
	
	//draw.RoundedBox( 4, 10, self.Description.y + self.Description:GetTall() + 6, self:GetWide() - 20, 12, Color( 0, 0, 0, 50 ) )

end


/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.Hostname:SizeToContents()
	self.Hostname:SetPos( 115, 16 )
	
	self.Description:SizeToContents()
	self.Description:SetPos( 128, 64 )
	
	local iTall = self.PlayerFrame:GetCanvas():GetTall() + self.Description.y + self.Description:GetTall() + 30
	iTall = math.Clamp( iTall, 100, ScrH() * 0.9 )
	local iWide = math.Clamp( ScrW() * 0.8, 700, ScrW() * 0.6 )
	
	self:SetSize( iWide, iTall )
	self:SetPos( (ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 4 )
	
	self.PlayerFrame:SetPos( 5, self.Description.y + self.Description:GetTall() + 20 )
	self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	local y = 0
	
	local PlayerSorted = {}
	
	for k, v in pairs( self.PlayerRows ) do
	
		table.insert( PlayerSorted, v )
		
	end
	
	table.sort( PlayerSorted, function ( a , b) return a:HigherOrLower( b ) end )
	
	for k, v in ipairs( PlayerSorted ) do
	
		v:SetPos( 0, y )	
		v:SetSize( self.PlayerFrame:GetWide(), v:GetTall() )
		
		self.PlayerFrame:GetCanvas():SetSize( self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall() )
		
		y = y + v:GetTall() + 1
	
	end
	
	self.Hostname:SetText( GetHostName() )
	
	self.lblPing:SizeToContents()
	self.lblPing:SetPos( self:GetWide() - 50 - self.lblPing:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblPolice:SizeToContents()
	self.lblPolice:SetPos( self:GetWide() - 75*5 - self.lblPolice:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblDispatcher:SizeToContents()
	self.lblDispatcher:SetPos( self:GetWide() - 75*6.2 - self.lblDispatcher:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblSecretService:SizeToContents()
	self.lblSecretService:SetPos( self:GetWide() - 75*8 - self.lblDispatcher:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblFiremen:SizeToContents()
	self.lblFiremen:SetPos( self:GetWide() - 75*2 - self.lblFiremen:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblMedics:SizeToContents()
	self.lblMedics:SetPos( self:GetWide() - 75*3 - self.lblMedics:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )		
	
	self.lblSWAT:SizeToContents()
	self.lblSWAT:SetPos( self:GetWide() - 75*4 - self.lblSWAT:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	
	self.lblMayor:SizeToContents()
	self.lblMayor:SetPos( self:GetWide() - 40 - self.lblMayor:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 26  )
	
	self.lblBus:SizeToContents()
	self.lblBus:SetPos( self:GetWide() - 75*2 - self.lblMayor:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 26  )
	
	self.lblRoad:SizeToContents()
	self.lblRoad:SetPos( self:GetWide() - 75*3.5 - self.lblMayor:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 26  )

	//self.lblKills:SetFontInternal( "DefaultSmall" )
	//self.lblDeaths:SetFontInternal( "DefaultSmall" )

end

/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

end


function PANEL:UpdateScoreboard( force )

	if ( !force && !self:IsVisible() ) then return end

	for k, v in pairs( self.PlayerRows ) do
	
		if ( !k:IsValid() or (k:IsSuperAdmin() and k:GetSharedBool("hidden", false))) then
		
			v:Remove()
			self.PlayerRows[ k ] = nil
			
		end
		
		if ( k:GetSharedBool("disguise", false) == true && !Disguised[k]) then
			v:Remove()
			self.PlayerRows[ k ] = nil
		end
		
		if (k:GetSharedBool("disguise", false) == false && Disguised[k]) then
			v:Remove()
			self.PlayerRows[k] = nil
			Disguised[k] = nil
		end
	
	end
	
	local PlayerList = player.GetAll()	
	for id, pl in pairs( PlayerList ) do
		
		if (!self:GetPlayerRow( pl ) and !(pl:IsSuperAdmin() and pl:GetSharedBool("hidden", false))) then
		
			self:AddPlayerRow( pl )
			
			if (pl:GetSharedBool("disguise", false)) then
				Disguised[pl] = true
			end
		
		end
		
	end
	
	// Always invalidate the layout so the order gets updated
	self:InvalidateLayout()

end

vgui.Register( "ScoreBoard", PANEL, "Panel" )