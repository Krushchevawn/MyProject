function PLAYER:AddToWarehouse(iItemID, iAmount)
	if(not self.PlayerWarehouse[iItemID]) then
		self.PlayerWarehouse[iItemID] = 0
	end
	
	if(iAmount == 0) then return false end
	if(self:GetItemCount(iItemID) < 1) then return end
	
	self.PlayerWarehouse[iItemID] = self.PlayerWarehouse[iItemID] + iAmount
	
	if(self:GetItemCount(iItemID) - iAmount < 1) then
		if(ITEM_DATABASE[iItemID].Holster) then
			ITEM_DATABASE[iItemID].Holster(self)
		end
	end
	
	self:TakeItemByID(iItemID, iAmount)
	
	umsg.Start("perp2_warehouse_insert", self)
		umsg.Short(iItemID)
		umsg.Short(iAmount)
		umsg.Bool(true)
	umsg.End()
	
	self:SaveWarehouseSingle(iItemID)
	self:Save()
	
	return true
end

function PLAYER:TakeFromWarehouse(iItemID, iAmount)
	if(not self.PlayerWarehouse[iItemID]) then return false end
	if(self.PlayerWarehouse[iItemID] < 1) then return false end
	
	local iAmount = math.Clamp(iAmount, 0, self.PlayerWarehouse[iItemID])
	
	self.PlayerWarehouse[iItemID] = self.PlayerWarehouse[iItemID] - iAmount
	
	self:GiveItem(iItemID, iAmount)

	umsg.Start("perp2_warehouse_delete", self)
		umsg.Short(iItemID)
		umsg.Short(iAmount)
		umsg.Bool(true)
	umsg.End()
	
	self:SaveWarehouseSingle(iItemID)
	self:Save()
	
	return true
end
	
function PLAYER:WarehouseFullUpdate()
	umsg.Start("perp2_warehouse_wipe", self)
	umsg.End()
	
	for k, v in pairs(self.PlayerWarehouse) do
		if(v != 0) then
			umsg.Start("perp2_warehouse_insert", self)
				umsg.Short(k)
				umsg.Short(v)
				umsg.Bool(false)
			umsg.End()
		end
	end
end

local function PlayerAddToWarehouse(objPl, strC, tblArgs)
	local iItem = tonumber(tblArgs[1])
	local iAmount = math.abs(tblArgs[2])
	
	if(iItemID == 103) then
		return
	end
	
	if(objPl:GetItemCount(iItem) < 1) then
		//objPl:Notify("You do not have this item.")
		return
	end
	
	objPl:AddToWarehouse(iItem, math.Clamp(iAmount, 0, objPl:GetItemCount(iItem)))
end
concommand.Add("perp_wh_add", PlayerAddToWarehouse)

local function PlayerTakeFromWarehouse(objPl, strC, tblArgs)
	local iItem = tonumber(tblArgs[1])
	local iAmount = math.abs(tblArgs[2])
	
	if(not objPl:CanHoldItem(iItem, iAmount)) then
		objPl:Notify("You do not have enough free inventory room.")
		return
	end
	
	objPl:TakeFromWarehouse(iItem, iAmount)
end
concommand.Add("perp_wh_take", PlayerTakeFromWarehouse)

local function PlayerRequestUpdate(objPl)
	objPl:WarehouseFullUpdate()
end
concommand.Add("perp_warehouserequestupdate", PlayerRequestUpdate)

function PLAYER:PutSpawnedIntoWarehouse()
	for k, v in pairs(ents.GetAll()) do
		if(v.ReturnToWarehouse and v.ReturnToWarehouseOwner == self:SteamID() and v.ReturnToWarehouseID) then
			print("Returning item #" .. v.ReturnToWarehouseID .. " for player " .. self:Nick() .. " to warehouse.")
			
			if(not self.PlayerWarehouse[v.ReturnToWarehouseID]) then
				self.PlayerWarehouse[v.ReturnToWarehouseID] = 0
			end
			
			self.PlayerWarehouse[v.ReturnToWarehouseID] = self.PlayerWarehouse[v.ReturnToWarehouseID] + 1
			
			v:Remove()
		end
	end
end


function PLAYER:SaveWarehouse()
	local strSteamID = self:SteamID()
	for iItem, iAmount in pairs(self.PlayerWarehouse) do
		if(iAmount < 1) then
			DataBase:Query("DELETE FROM `perp_warehouse` WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'")
		else
			DataBase:Query("SELECT * FROM `perp_warehouse` WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'", function( tbl )
				if(#tbl == 0) then
					DataBase:Query("INSERT INTO `perp_warehouse` (`steamid`, `itemid`, `amount`) VALUES('" ..strSteamID.. "', '" ..iItem.. "', '" ..iAmount.. "')")
				else
					DataBase:Query("UPDATE `perp_warehouse` SET `amount`='" ..iAmount.. "' WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'")
				end
			end )
		end
	end
end

function PLAYER:SaveWarehouseSingle(iItem)
	if(not iItem) then return end
	local strSteamID = self:SteamID()
	local iAmount = self.PlayerWarehouse[iItem]
	
	if(iAmount < 1) then
		DataBase:Query("DELETE FROM `perp_warehouse` WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'")
	else
		DataBase:Query("SELECT * FROM `perp_warehouse` WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'", function( tbl )
			if(#tbl == 0) then
				DataBase:Query("INSERT INTO `perp_warehouse` (`steamid`, `itemid`, `amount`) VALUES('" ..strSteamID.. "', '" ..iItem.. "', '" ..iAmount.. "')")
			else
				DataBase:Query("UPDATE `perp_warehouse` SET `amount`='" ..iAmount.. "' WHERE `steamid`='" ..strSteamID.. "' AND `itemid`='" ..iItem.. "'")
			end
		end )
	end
end

function PLAYER:LoadWarehouse()
	DataBase:Query("SELECT * FROM `perp_warehouse` WHERE `steamid`='" .. self:SteamID() .. "'", function( tbl )
		for strKey, tblValue in pairs(tbl) do
			local strSteamID = tblValue[1]
			local strItem = tblValue[2]
			local strAmount = tblValue[3]
			
			self.PlayerWarehouse[tonumber(strItem)] = tonumber(strAmount)
		end
	end )
end