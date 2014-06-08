local ITEM 					= {}

ITEM.ID 					= 69
ITEM.Reference 				= "drug_cocaine"

ITEM.Name 					= 'Cocaine'
ITEM.Description 			= 'Drugs are bad -WHO GIVES A SHIT??'

ITEM.Weight 				= 5
ITEM.GoodWeight         = 5 --Cocaine kills people

ITEM.Cost					= 250

ITEM.MaxStack 				= 50

ITEM.InventoryModel 		= "models/cocn.mdl"
ITEM.ModelCamPos = Vector(8, 0, 5);
ITEM.ModelLookAt = Vector(0, 0, 0);
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/cocn.mdl"

ITEM.RestrictedSelling	 	= true // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse (objPl)	
		umsg.Start("toggleCocaine", objPl)
			umsg.Bool(true)
		umsg.End()
		
		timer.Create(objPl:SteamID() .. "EndCocaine", 80, 1, function()
			if(IsValid(objPl)) then
				umsg.Start("toggleCocaine", objPl)
					umsg.Bool(false)
				umsg.End()
			end
		end)
		
		return true
	end
	
	hook.Add("PlayerDeath", "PlayerDeathCocaine", function(Player)
		timer.Remove(Player:SteamID() .. "EndCocaine")
		
		umsg.Start("toggleCocaine", Player)
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
	//CLIENT SHIT IS FOR CLIENT FILE ONLY
end

GM:RegisterItem(ITEM)

