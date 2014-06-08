local ITEM 					= {}

ITEM.ID 					= 78
ITEM.Reference 				= "drug_shroom"

ITEM.Name = '"Magic" Mushrooms'
ITEM.Description = "I wouldn't eat these by themselves... Use to eat. Drop to plant."

ITEM.Weight 				= 10
ITEM.Cost					= 200

ITEM.MaxStack 				= 10

ITEM.InventoryModel 		= "models/fungi/sta_skyboxshroom1.mdl"
ITEM.ModelCamPos = Vector(16, 30, 20)
ITEM.ModelLookAt = Vector(0, 0, 14)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/fungi/sta_skyboxshroom1.mdl"

ITEM.RestrictedSelling	 	= true // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= false // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse ( Player )		
		Player:SendLua([[surface.PlaySound('perp/eating.mp3') timer.Simple(math.random(3, 7), function () GAMEMODE.ShroomStart = CurTime() end)]])
		return true
	end
	
	function ITEM.OnDrop ( Player )
		local Trace = Player:GetEyeTrace()
		if(Trace.HitPos:Distance(Player:GetPos()) > 200) then return end
		
		local NumShroomsAlready = 0
		for k, v in pairs(ents.FindByClass('shroom')) do
			if v:GetTable().maker and v:GetTable().maker == Player:SteamID() then
				NumShroomsAlready = NumShroomsAlready + 1
			end
		end
		
		local iCanHave = 10
		if(Player:IsGoldMember() or Player:IsVIP()) then
			iCanHave = iCanHave * 2
		end
		
		if NumShroomsAlready >= iCanHave then
			Player:Notify("It looks like the soil can't handle any more vegitation.")
			return false
		end
		
		if Trace.HitWorld and Trace.MatType == MAT_DIRT and GetVectorTraceUp(Trace.HitPos).HitSky then
			local Shroom = ents.Create('ent_shroom')
			Shroom:SetPos(Trace.HitPos)
			Shroom:Spawn()
			Shroom:GetTable().maker = Player:SteamID()
			Shroom:GetTable().ItemSpawner = Player:SteamID()
			Shroom:GetTable().Owner = Player
			
			Player:TakeItemByID(78, 1, true)
			
			return false
		else
			Player:Notify("You must plant these in soil!")
			
			return false
		end
		
		return false
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else
	//CLIENT SHIT
end

GM:RegisterItem(ITEM)
