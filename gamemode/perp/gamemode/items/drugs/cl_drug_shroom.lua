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
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then
	//SERVER SHIT IS FOR SERVER ONLY, NICE TRY!
else

	local TransitionTime = 6
	local TimeLasting = 60

	local function MakeEffects ()
		if !GAMEMODE.ShroomStart then return end
		
		local End = GAMEMODE.ShroomStart + TimeLasting + TransitionTime * 2
		
		if End < CurTime() then return end
	
		local shroom_tab = {}
		shroom_tab["$pp_colour_addr"] = 0
		shroom_tab["$pp_colour_addg"] = 0
		shroom_tab["$pp_colour_addb"] = 0
		shroom_tab["$pp_colour_mulr"] = 0
		shroom_tab["$pp_colour_mulg"] = 0
		shroom_tab["$pp_colour_mulb"] = 0
		
		local TimeGone = CurTime() - GAMEMODE.ShroomStart
		
		if TimeGone < TransitionTime then
			local s = GAMEMODE.ShroomStart
			local e = s + TransitionTime
			local c = CurTime()
			local pf = (c-s) / (e-s)
				
			shroom_tab["$pp_colour_colour"] =   1 - pf * 0.37
			shroom_tab["$pp_colour_brightness"] = -pf * 0.15
			shroom_tab["$pp_colour_contrast"] = 1 + pf * 1.57

			DrawColorModify(shroom_tab) 
			DrawSharpen(8.32, 1.03 * pf)
		elseif TimeGone > TransitionTime + TimeLasting then
			local e = End
			local s = e - TransitionTime
			local c = CurTime()
			local pf = 1 - (c - s) / (e - s)
				
			shroom_tab["$pp_colour_colour"] = 1 - pf * 0.37
			shroom_tab["$pp_colour_brightness"] = -pf * 0.15
			shroom_tab["$pp_colour_contrast"] = 1 + pf * 1.57
			
			DrawColorModify(shroom_tab) 
			DrawSharpen(8.32, 1.03 * pf)
		else
			shroom_tab["$pp_colour_colour"] = 0.63
			shroom_tab["$pp_colour_brightness"] = -0.15
			shroom_tab["$pp_colour_contrast"] = 2.57

			DrawColorModify(shroom_tab) 
			DrawSharpen(8.32,1.03)
		end
	end
	hook.Add("RenderScreenspaceEffects", "uwuwuwuw", MakeEffects)

	function ITEM.OnUse ( slotID )	
		return true
	end
	
	function ITEM.OnDrop ( )
		return false
	end
	
end

GM:RegisterItem(ITEM)
