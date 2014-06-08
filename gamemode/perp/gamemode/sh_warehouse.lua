
if(CLIENT) then
	GM.PlayerWarehouse = {}
	
	local function WarehouseInsert(um)
		local iItem = um:ReadShort()
		local iAmount = um:ReadShort()
		local bInv = um:ReadBool() or false
		
		if(iAmount == 0) then return end
		
		if(not GAMEMODE.PlayerWarehouse[iItem]) then
			GAMEMODE.PlayerWarehouse[iItem] = {amount = 0, table = ITEM_DATABASE[iItem]}
		end
		
		GAMEMODE.PlayerWarehouse[iItem].amount = GAMEMODE.PlayerWarehouse[iItem].amount + iAmount
		if(bInv) then
			LocalPlayer():TakeItemByID(iItem, iAmount)
			surface.PlaySound("doors/door_metal_large_close2.wav")
		end
		
		
		GAMEMODE.WarehousePanel:Build()
	end
	usermessage.Hook("perp2_warehouse_insert", WarehouseInsert)

	local function WarehouseDelete(um)
		local iItem = um:ReadShort()
		local iAmount = um:ReadShort()
		local bInv = um:ReadBool() or false
		
		if(iAmount == 0) then return end
		
		if(not GAMEMODE.PlayerWarehouse[iItem]) then
			GAMEMODE.PlayerWarehouse[iItem] = {amount = 0, table = ITEM_DATABASE[iItem]}
		end
		
		GAMEMODE.PlayerWarehouse[iItem].amount = GAMEMODE.PlayerWarehouse[iItem].amount - iAmount
		
		if(bInv) then
			LocalPlayer():GiveItem(iItem, iAmount)
			surface.PlaySound("doors/door_metal_thin_close2.wav")
		end
		
		GAMEMODE.WarehousePanel:Build()
	end
	usermessage.Hook("perp2_warehouse_delete", WarehouseDelete)

	local function WarehouseWipe()
		GAMEMODE.PlayerWarehouse = {}
		
		GAMEMODE.WarehousePanel:Build()
	end
	usermessage.Hook("perp2_warehouse_wipe", WarehouseWipe)
end