	if(CLIENT) then
	GM.LastInventoryClientChange = CurTime()

	local function InvFix()
		local meta = {}
		meta.__newindex = function(tbl, key, value)
			GAMEMODE.LastInventoryClientChange = CurTime() + 3 + (LocalPlayer():Ping() * 0.001)
			
			rawset(tbl,key,value)
		end
		
		setmetatable(GAMEMODE.PlayerItems, meta)
	end
	hook.Add("InitPostEntity", "InvFix", InvFix)
	
	local function InventorySyncer_ReceiveInventoryCorrection(um)
		if(not GAMEMODE.CurrentLoadStatus or GAMEMODE.CurrentLoadStatus != 3) then return end
		if(GAMEMODE.LastInventoryClientChange > CurTime()) then return end
		
		local iSlot = um:ReadShort()
		local iID = um:ReadShort()
		local iQuantity = um:ReadLong()
		
		if(iQuantity < 1) then
			iQuantity = nil
		end
		if(iID < 1) then
			iID = nil
		end
		
		local iOutOfSync = false
		
		if(not iID or not iQuantity) then
			if(GAMEMODE.PlayerItems[iSlot]) then
				iOutOfSync = 1
			end
			GAMEMODE.PlayerItems[iSlot] = nil
			
			GAMEMODE.InventoryBlocks_Linear[iSlot]:GrabItem()
		else
			if(GAMEMODE.PlayerItems[iSlot]) then
				if(GAMEMODE.PlayerItems[iSlot].ID != iID) then
					GAMEMODE.PlayerItems[iSlot].ID = iID
					
					iOutOfSync = 2
					
					GAMEMODE.PlayerItems[iSlot].Table = ITEM_DATABASE[iID]
					
					GAMEMODE.InventoryBlocks_Linear[iSlot]:GrabItem()
				end
				if(GAMEMODE.PlayerItems[iSlot].Quantity != iQuantity) then
					GAMEMODE.PlayerItems[iSlot].Quantity = iQuantity
					
					iOutOfSync = 3
					
					GAMEMODE.PlayerItems[iSlot].Table = ITEM_DATABASE[iID]
					
					GAMEMODE.InventoryBlocks_Linear[iSlot]:GrabItem()
				end
			else
				iOutOfSync = 4
				
				GAMEMODE.PlayerItems[iSlot] = {}
				GAMEMODE.PlayerItems[iSlot].ID = iID
				GAMEMODE.PlayerItems[iSlot].Quantity = iQuantity
				GAMEMODE.PlayerItems[iSlot].Table = ITEM_DATABASE[iID]
				
				GAMEMODE.InventoryBlocks_Linear[iSlot]:GrabItem()
			end
		end
		
		/*if(iOutOfSync) then
			//LocalPlayer():Notify("[Inventory Sync][ERROR] Updating slot " .. iSlot .. "! (EC " .. iOutOfSync .. ")")
			
			RunConsoleCommand("perp2_sync_warn", iSlot, iOutOfSync)
		end*/
	end
	usermessage.Hook("perp2_invsync_corr", InventorySyncer_ReceiveInventoryCorrection)

end


if(SERVER) then
	function InventorySyncer_ValidateSlot(objPl)
		local tblPlayerItems = objPl.PlayerItems
		
		if(not tblPlayerItems) then return end
		
		for iSlot=3, INVENTORY_WIDTH * INVENTORY_HEIGHT + 2 do
			if(not tblPlayerItems[iSlot] or not tblPlayerItems[iSlot].ID or not tblPlayerItems[iSlot].Quantity) then
				umsg.Start("perp2_invsync_corr", objPl)
					umsg.Short(iSlot)
					umsg.Short(0)
					umsg.Long(0)
				umsg.End()
			else
				umsg.Start("perp2_invsync_corr", objPl)
					umsg.Short(iSlot)
					umsg.Short(tblPlayerItems[iSlot].ID)
					umsg.Long(tblPlayerItems[iSlot].Quantity)
				umsg.End()
			end
		end
	end

	local function InventorySyncer_Timer()
		for k, v in pairs(player.GetAll()) do
			if(v.PlayerItems) then
				InventorySyncer_ValidateSlot(v)
			end
		end
	end
	timer.Create("InventorySyncer_Timer", 2, 0, function() InventorySyncer_Timer() end)

	function InventorySyncer_PlayerWarnAboutOutOfSync(objPl,_, tblArgs)
		local str = "_lite"
		//if(GAMEMODE.IsSerious()) then
			//str = "_serious"
		//end
		
		//filex.Append("perpx" .. str .. "/sync.txt", "Player " .. objPl:Nick() .. "(" .. objPl:SteamID() .. ") inventory out of sync. Slot " .. tblArgs[1] .. ". Location " .. tostring(objPl:GetPos()) .. "! Error code " .. tblArgs[2] .. "\n")
	end
	concommand.Add("perp2_sync_warn", InventorySyncer_PlayerWarnAboutOutOfSync)
end