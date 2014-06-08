local function SetPhysColor(ply, tab)
	local col = Vector(math.Clamp(tonumber(tab[1]), 0.01, 1), math.Clamp(tonumber(tab[2]), 0.01, 1), math.Clamp(tonumber(tab[3]), 0.01, 1))
	ply.PhysColor = col
	ply:SetWeaponColor(col)
end


hook.Add("PlayerInitialSpawn", "InitializePhysgunColor", function(ply)
	if(ply:IsGoldMember()) then
		
		DataBase:Query("SELECT `col` FROM `perp_physcol` WHERE `id`='"..ply:SteamID().."'", function (data)
			if(data and data[1] and data[1][1]) then
				local tbl = string.Explode(",", data[1][1])
				if(#tbl != 3) then return end

				SetPhysColor(ply, tbl)
			end
		end)

	end	
end)

net.Receive("Perp_PhysColor", function( length, ply )
	if(!ply:IsGoldMember()) then return end
	if(ply:GetCash() < PHYSGUN_COLORPRICE) then return end
	
	local tbl = net.ReadTable()
	if(#tbl != 3) then return end

	SetPhysColor(ply, tbl)

	ply:TakeCash(PHYSGUN_COLORPRICE)

	local newtab = {tostring(math.Round(tbl[1], 2)), tostring(math.Round(tbl[2], 2)), tostring(math.Round(tbl[3], 2))}
	local qstring = string.Implode(",", newtab)
	DataBase:Query("REPLACE INTO `perp_physcol` (`id`, `col`) VALUES ('".. ply:SteamID() .."', '".. qstring .."')")
end)