local ITEM 					= {}

ITEM.ID 					= 66
ITEM.Reference 				= "drug_lsd"

ITEM.Name 					= 'LSD'
ITEM.Description 			= "Lucy in the sky .. with diamonds."

ITEM.Weight 				= 5
ITEM.Cost					= 250

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/props_lab/jar01a.mdl"
ITEM.ModelCamPos 			= Vector(100, 2, 6)
ITEM.ModelLookAt 			= Vector(-4, -2, 4)
ITEM.ModelFOV 				= 40
ITEM.WorldModel 			= "models/props_lab/jar01a.mdl"

ITEM.RestrictedSelling	 	= true // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse (Player)
		umsg.Start("perp_i_like_lsd", Player)
			umsg.Bool(true)
		umsg.End()
		
		timer.Create(Player:SteamID() .. "LSDTimer1", 60, 1, function()
			if(IsValid(Player)) then
			umsg.Start("perp_i_like_lsd", Player)
				umsg.Bool(false)
			umsg.End()
			end
		end)
		
		return true
	end
	
	hook.Add("PlayerDeath", "PlayerDeathLSD", function(Player)
		timer.Remove(Player:SteamID() .. "LSDTimer")
		umsg.Start("perp_i_like_lsd", Player)
			umsg.Bool(false)
		umsg.End()
	end)
	
	function ITEM.OnDrop ( Player )
		return true
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else
	//CLIENT SHIT
end
GM:RegisterItem(ITEM)
