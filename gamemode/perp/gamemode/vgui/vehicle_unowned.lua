function GM.ShowDealershipView ( )		
	local W, H = ScrW() * 0.8, ScrH() * 0.8
	
	local DermaPanel = vgui.Create("DFrame")
	DermaPanel:SetPos(ScrW() * .5 - W * .5, ScrH() * .5 - H * .5)
	DermaPanel:SetSize(W, H)
	DermaPanel:SetTitle("Vehicle Dealership - Bank Balance: " .. DollarSign() .. LocalPlayer():GetBank())
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(false)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:SetAlpha(GAMEMODE.GetGUIAlpha())

	local PanelList1 = vgui.Create("DPanelList", DermaPanel)
	PanelList1:EnableHorizontal(false)
	PanelList1:EnableVerticalScrollbar(true)
	PanelList1:StretchToParent(5, 30, 5, 5)
	PanelList1:SetPadding(5)
	PanelList1:SetSpacing(5)
	
	local tbl = {}
	local tblDone = {}
	for k, v in pairs(VEHICLE_DATABASE) do
		table.insert(tbl, v.Cost)
	end
	table.sort(tbl)
	
	for k, v in ipairs(tbl) do
		for t, c in pairs(VEHICLE_DATABASE) do
			if(c.Cost == v and not tblDone[c.ID]) then
				local table = c
				
				if (!table.RequiredClass && !LocalPlayer():HasVehicle(t)) then
					local NewMenu = vgui.Create('perp2_vehicle_unowned_details', PanelList1)
					NewMenu:SetVehicle(table)
					PanelList1:AddItem(NewMenu)
				end
				
				tblDone[c.ID] = true
				tbl[k] = nil
			end
		end
	end

	DermaPanel:MakePopup()
end
