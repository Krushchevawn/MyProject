local ITEM 					= {}

ITEM.ID 					= 67
ITEM.Reference 				= "drug_mightymuscle"

ITEM.Name = 'Mighty Muscle'
ITEM.Description = "A 25 seconds lasting epic boost of hulkyness. Perfect to smash your enemies to hell."

ITEM.Weight 				= 5
ITEM.Cost					= 400

ITEM.MaxStack 				= 15

ITEM.InventoryModel = "models/katharsmodels/syringe_out/syringe_out.mdl"
ITEM.ModelCamPos = Vector(-4, 2, -42)
ITEM.ModelLookAt = Vector(0, 0, 0)
ITEM.ModelFOV = 30
ITEM.WorldModel 			= "models/katharsmodels/syringe_out/syringe_out.mdl"

ITEM.RestrictedSelling	 	= true // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then
	local function HULKPlayerFootstep(objPl, vPos, iFoot, strSound, iVolume, rfPlayers)
		if(objPl:GetSharedInt("HULK") == 0) then return end
		for i=1, 1 do
			objPl:EmitSound("npc/dog/dog_footstep_run" .. math.random(6, 8) .. ".wav", 80, 50)
		end
		return true
	end
	hook.Add("PlayerFootstep", "HULKPlayerFootstep", HULKPlayerFootstep)
	
	local function HULKUndo(objPl)
		if(objPl:GetSharedInt("HULK") < 1) then return end
		
		objPl:SetSharedInt("HULK", 0)
		
		for i=1, 1 do
			objPl:EmitSound("vo/npc/male01/uhoh.wav", 100, 75)
		end
		objPl:SetHealth(objPl:Health() * 0.1)
		objPl:SetColor(Color(255, 255, 255, 255))
		objPl:SetViewOffset(objPl.DefViewOffset)
		objPl:SetViewOffsetDucked(objPl.DefViewOffsetDucked)
	end
	
	local function HULKPlayerDeath(objPl, vPos, iFoot, strSound, iVolume, rfPlayers)
		HULKUndo(objPl)
	end
	hook.Add("PlayerDeath", "HULKPlayerDeath", HULKPlayerDeath)
	
	function ITEM.OnUse ( objPl )		
		if(objPl:GetSharedInt("HULK") > 0) then return false end
		if(IsValid(objPl:GetVehicle())) then return false end
		
		objPl:SetSharedInt("HULK", 1)
		
		objPl.DefViewOffset = objPl:GetViewOffset()
		objPl.DefViewOffsetDucked = objPl:GetViewOffsetDucked()
		
		objPl:EmitSound("npc/dog/dog_pneumatic2.wav", 100, 100)
		timer.Simple(0.8, function()
			if(IsValid(objPl:GetVehicle())) then return false end
		
			if(not IsValid(objPl)) then return end
			objPl:EmitSound("npc/dog/dog_pneumatic1.wav", 100, 100)
		end)
		
		timer.Simple(1, function()
			if(IsValid(objPl:GetVehicle())) then return false end
			
			if(not IsValid(objPl)) then return end
			
			objPl:EmitSound("npc/zombie_poison/pz_throw3.wav", 100, 75)
			objPl:SetHealth(objPl:Health() * 3)
			objPl:SetColor(Color(155, 255, 155, 255))
			objPl:SetViewOffset(Vector(0, 0, 90))
			objPl:SetViewOffsetDucked(Vector(0, 0, 70))
			
			objPl:SetWalkSpeed(170)
			objPl:SetRunSpeed(230)
			
			objPl.HulkStartTime = CurTime()
		end)
		
		timer.Simple(25, function()
			if(not IsValid(objPl)) then return end
			
			HULKUndo(objPl)
		end)
		
		return true
	end
	
	function ITEM.OnDrop ( Player )
		return true
	end
	
	function ITEM.Equip ( Player )

	end
	
	function ITEM.Holster ( Player )

	end
	
else
	//CLIENT SIDE SHIT YEEEAH
end

GM:RegisterItem(ITEM)
