
local DermaPanel = vgui.Create( "DFrame" )
DermaPanel:SetPos( 300,300 )
DermaPanel:SetSize( 1000, 400 )
DermaPanel:SetTitle( "Blacklists" )
DermaPanel:SetVisible( false )
DermaPanel:SetDraggable( true )
DermaPanel:ShowCloseButton( true )
DermaPanel:SetSkin("perp2")
DermaPanel.Close = function()
	DermaPanel:SetVisible(false)
end


local DList = vgui.Create ( "DListView", DermaPanel )
DList:SetPos(25,25)
DList:SetSize(950,340)
DList:SetMultiSelect(false)
DList:AddColumn("Steam Name")
DList:AddColumn("PERP Name")
DList:AddColumn("SteamID")
DList:AddColumn("Blacklists")

DermaPanel.Init = function()
	DList:Clear()
	RunConsoleCommand("perp_a_getblacklists")
	usermessage.Hook("donerecievingblacklists", function(um)
		for k, v in pairs(player.GetAll()) do
			local st = ""
			local blist = string.Explode(";", v:GetPrivateString("blacklists", ""))
			for _, b in pairs(blist) do
				if(string.Explode(",", b)[1] != "") then
					for l, q in pairs(GAMEMODE.teamToBlacklist) do
						if(q == string.Explode(",", b)[1]) then
							st = st .. team.GetName(l) .. ", "
						end
					end
				end
			end
			DList:AddLine(v:Nick(), v:GetRPName(), v:SteamID(), st)
		end
	end )
end

local button = vgui.Create( "DButton", DermaPanel )
button:SetSize( 100, 20 )
button:SetPos( 870, 370 )
button:SetText( "Manage Player" )
button.DoClick = function( button )
	if(!DList:GetSelectedLine()) then return end
	ManagePlayerBlacklists(DList:GetLine(DList:GetSelectedLine()):GetValue(3))
	DermaPanel:Close()
end

function ManagePlayerBlacklists( steamid )
	if(!steamid) then return end
	local ply
	for k, v in pairs(player.GetAll()) do
		if(v:SteamID() == steamid) then
			ply = v
		end
	end
	if(!ply) then return end
	
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( ScrW()/2 - 300, ScrH()/2 - 200 )
	DermaPanel:SetSize( 600, 400 )
	DermaPanel:SetTitle( ply:Nick() .. "'s blacklists" )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( true )
	DermaPanel:SetSkin("perp2")
	DermaPanel:MakePopup()

	local DList = vgui.Create ( "DListView", DermaPanel )
	DList:SetPos(25,25)
	DList:SetSize(550,340)
	DList:SetMultiSelect(false)
	DList:AddColumn("Prefix")
	DList:AddColumn("Job")
	DList:AddColumn("Time Left")
	
	RunConsoleCommand("perp_a_ostime")
	usermessage.Hook("gettime", function(msg)
		local time = msg:ReadFloat()
		//print(time)
		local st = ""
		local blist = string.Explode(";", ply:GetPrivateString("blacklists", ""))
		table.remove(blist)
		for _, b in pairs(blist) do
			local st = string.Explode(",", b)
			local job = ""
			for l, q in pairs(GAMEMODE.teamToBlacklist) do
				if(q == st[1]) then
					job = team.GetName(l)
				end
			end
			DList:AddLine(st[1], job, math.Round(((st[2] - time) / 60) / 60, 1) .. " hours" )
		end
		
		local button = vgui.Create( "DButton", DermaPanel )
		button:SetSize( 100, 20 )
		button:SetPos( 450, 370 )
		button:SetText( "Un-blacklist" )
		button.DoClick = function( button )
			if !DList:GetSelectedLine() then return end
			local blvalue = 	DList:GetLine(DList:GetSelectedLine()):GetValue(1)
			RunConsoleCommand("perp_a_unblacklist", steamid, blvalue)
		end
	end )
	usermessage.Hook("reloadplayerblacklist", function()
		DermaPanel:Close()
		ManagePlayerBlacklists( steamid )
	end )
end

local Adminpanel = vgui.Create( "DFrame" )
Adminpanel:SetPos( 50,250 )
Adminpanel:SetSize( 200, 100 )
Adminpanel:SetTitle( "Admin" )
Adminpanel:SetVisible( false )
Adminpanel:SetDraggable( true )
Adminpanel:SetSkin("perp2")
Adminpanel:ShowCloseButton( false )


local blbutton = vgui.Create( "DButton", Adminpanel )
blbutton:SetSize( 100, 60 )
blbutton:SetPos( 50, 30 )
blbutton:SetText( "Manage Blacklists" )
blbutton.DoClick = function( button )
    DermaPanel:SetVisible(true)
	DermaPanel:MakePopup()
	DermaPanel:Init()
end


hook.Add("ScoreboardHide", "ManageBlackLists", function()
	Adminpanel:SetVisible(false)
	Adminpanel:MakePopup()
end )

hook.Add("ScoreboardShow", "ManageBlackLists", function()
	if(LocalPlayer():IsAdmin()) then
		Adminpanel:SetVisible(true)
	end
end )

usermessage.Hook("RecievePlayerBlacklists", function(um)
	local ply = um:ReadEntity()
	local st = um:ReadString()
	if(!ply) then return end
	if(!st) then return end
	ply:SetPrivateString("blacklists", st)
end )



