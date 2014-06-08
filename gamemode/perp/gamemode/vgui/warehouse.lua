
local PANEL = {}

function PANEL:Init ( )
	self:SetSize(ScrW() * .5, ScrH() * .5)
	self:SetPos(ScrW() * .25, ScrH() * .25)
	self:SetTitle("Warehouse")
	self:SetAlpha(GAMEMODE.GetGUIAlpha())
	self:SetSkin("perp2")
	self:ShowCloseButton(true)
	self:SetDeleteOnClose(false)
	self:SetDraggable(false)
	self:SetVisible(false)
	
	self.ShouldBuild = false
	
	self.LabelItemList = vgui.Create("DLabel", self)
	self.LabelItemList:SetPos(5, 26)
	self.LabelItemList:SetSize(self:GetWide() * 0.5, 30)
	self.LabelItemList:SetText("Items in warehouse.\nClick on an icon to take the item into your inventory.")
	self.LabelItemList:SetTextColor(Color(5, 5, 5, 255))
	
	self.LabelInv = vgui.Create("DLabel", self)
	self.LabelInv:SetPos(self:GetWide() * 0.5 + 5, 26)
	self.LabelInv:SetSize(self:GetWide() * 0.5, 30)
	self.LabelInv:SetText("Items in inventory.\nClick on an icon to put the item into the warehouse.")
	self.LabelInv:SetTextColor(Color(5, 5, 5, 255))
	
	self.ItemList = vgui.Create("DPanelList", self)
	self.ItemList:StretchToParent(5, 26 + 30, self:GetWide() * 0.5 + 2, 5)
	self.ItemList:EnableHorizontal(true)
	self.ItemList:EnableVerticalScrollbar(true)
	self.ItemList:SetPadding(4)
	
	self.Inventory = vgui.Create("DPanelList", self)
	self.Inventory:StretchToParent(self:GetWide() * 0.5 + 2, 26 + 30, 5, 5)
	self.Inventory:EnableHorizontal(true)
	self.Inventory:EnableVerticalScrollbar(true)
end

function PANEL:Show()
	self:SetVisible(true)
	self:MakePopup()
	RunConsoleCommand("perp_warehouserequestupdate")
end

function PANEL:Build()
	self.ShouldBuild = true
end

function PANEL:Think()
	if(self.ShouldBuild) then
		self.ItemList:Clear(true)
		self.Inventory:Clear(true)
		
		for k, v in pairs(GAMEMODE.PlayerWarehouse) do
			if(v.amount > 0) then
				local spawnicon = vgui.Create("SpawnIcon", self.ItemList)
				spawnicon:SetModel(v.table.InventoryModel)
				spawnicon:SetToolTip("Name: " .. v.table.Name .. "\nAmount: " .. v.amount)
				spawnicon.OnMousePressed = function(self, mc)
					if(mc == MOUSE_LEFT) then
						RunConsoleCommand("perp_wh_take", v.table.ID, 1)
					elseif(mc == MOUSE_RIGHT) then
						RunConsoleCommand("perp_wh_take", v.table.ID, 10)
					end
				end
				spawnicon:InvalidateLayout( true )
				
				self.ItemList:AddItem(spawnicon)
			end
		end
		
		for k, v in pairs(GAMEMODE.PlayerItems) do
			if( v.Table and v.Table.InventoryModel) then
				local spawnicon = vgui.Create("SpawnIcon", self.ItemList)
				spawnicon:SetModel(v.Table.InventoryModel)
				spawnicon:SetToolTip("Name: " .. v.Table.Name .. "\nAmount: " .. v.Quantity)

				spawnicon.OnMousePressed = function(self, mc)
					if(v.Table.ID == 103) then return end
					if(mc == MOUSE_LEFT) then
						RunConsoleCommand("perp_wh_add", v.Table.ID, 1)
					elseif(mc == MOUSE_RIGHT) then
						RunConsoleCommand("perp_wh_add", v.Table.ID, 10)
					end
				end
				spawnicon:InvalidateLayout( true )
				
				self.Inventory:AddItem(spawnicon)
			end
		end
		
		self.ShouldBuild = false
	end
end

vgui.Register("perp2_warehouse", PANEL, "DFrame")