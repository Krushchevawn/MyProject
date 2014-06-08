local ITEM 					= {}

ITEM.ID 					= 107
ITEM.Reference 				= "item_gascan"

ITEM.Name 					= "Gas Can"
ITEM.Description			= "Use while aiming on a vehicle to refill a quarter of its tank."

ITEM.Weight 				= 5
ITEM.Cost					= 800

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/props_junk/gascan001a.mdl"
ITEM.ModelCamPos 				= Vector(40, 0, 6)
ITEM.ModelLookAt 				= Vector(0, 0, 0)
ITEM.ModelFOV 					= 70
ITEM.WorldModel 			= "models/props_junk/gascan001a.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse ( Player )	
		if(Player:GetEyeTrace().Entity:IsVehicle()) then
			local owner = Player:GetEyeTrace().Entity:GetSharedEntity("owner")
			local fuel = owner:GetFuel()
			local fuelgive = 0
			local FuelMax = 10000;
			if(fuel >= FuelMax) then 
				Player:Notify("The tank is full!")
				return false 
			end
			if FuelMax - fuel < 2500 then 
				local Total = FuelMax - fuel
				fuelgive = Total
			else
				fuelgive = 2500
			end
			owner:AddFuel(fuelgive, true);
			Player:EmitSound("ambient/water/water_spray3.wav")
			return true
		end
		return false
	end
	
	function ITEM.OnDrop ( Player )
		return true
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else

	function ITEM.OnUse ( slotID )		
		return false
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)