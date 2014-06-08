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
	//SERVER SHIT IS FOR SERVER ONLY, NICE TRY!
else
	local function SetHulkBuildBonePositions()
		for k,v in pairs(player.GetAll()) do
			if(v:GetSharedInt("HULK") == 1) then
				v.HulkON = true
				local tblBones = {}
				tblBones["ValveBiped.Bip01_Spine"] = Vector(1.5, 1.5, 1.5)
				tblBones["ValveBiped.Bip01_L_Hand"] = Vector(2, 2, 1.5)
				tblBones["ValveBiped.Bip01_R_Foot"] = Vector(2.5, 2.5, 1.5)
				tblBones["ValveBiped.Bip01_Head1"] = Vector(0.7, 0.7, 0.7)
				v.BuildBonePositions = function(objPl, iNumBones, iNumPhysBones)
					for strBone, vScale in pairs(tblBones) do
						local iBoneID = objPl:LookupBone(strBone)
						if(iBoneID and iBoneID != 0) then
							local mBoneMatrix = objPl:GetBoneMatrix(iBoneID)
							if(mBoneMatrix) then
								mBoneMatrix:Scale(vScale)
								objPl:SetBoneMatrix(iBoneID, mBoneMatrix)
							end
						end
					end
				end
			else
				if(v.HulkON) then
					v.BuildBonePositions = function(objPl, iNumBones, iNumPhysBones) end
					v.HulkON = false
				end
			end
		end
	end
	timer.Create("SetHulkBuildBonePositions", 0.2, 0, function() SetHulkBuildBonePositions() end)
	
	function ITEM.OnUse ( slotID )		
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)
