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
	//SERVER SHIT IS FOR SERVER ONLY, NICE TRY!
else

	function ITEM.OnUse ( slotID )		
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
	if(_G["LSD_DRUG_HTML"]) then
		_G["LSD_DRUG_HTML"]:Remove()
		_G["LSD_DRUG_HTML"] = nil
	end
	
	local bILikeLSD = false
	local tblLsdEffects = {}
	tblLsdEffects[1] = false
	tblLsdEffects[2] = false
	tblLsdEffects[3] = false
	tblLsdEffects[4] = false
	
	local function MakeEffects ()
		if(not bILikeLSD) then
		if(_G["LSD_DRUG_HTML"]) then
			_G["LSD_DRUG_HTML"]:Remove()
			_G["LSD_DRUG_HTML"] = nil
		end
		return end
		
		local iEffectTime = CurTime() - iEffectTime
		
	if(iEffectTime > 10) then
		tblLsdEffects[1] = true
	end
	if(iEffectTime > 20) then
		tblLsdEffects[2] = true
	end
	if(iEffectTime > 30) then
		tblLsdEffects[3] = true
	end
	if(iEffectTime > 40) then
		tblLsdEffects[4] = true
	end
	
	DrawBloom(0.5, 0.25, iEffectTime / 30, 3, 2, 3, 255, 255, 255)
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = math.sin(CurTime() * 2) + 1 * 1
	tab[ "$pp_colour_mulg" ] = math.sin(CurTime() * 3) + 1 * 1
       tab[ "$pp_colour_mulb" ] = math.sin(CurTime() * 4) + 1 * 1	   
	   
	if(tblLsdEffects[1] == true) then
	tab[ "$pp_colour_colour" ] = math.sin(CurTime() * 5)
	end
	if(tblLsdEffects[2] == true) then
		tab[ "$pp_colour_addr" ] = 0.4
	end
	if(tblLsdEffects[3] == true) then
		DrawSharpen(math.tan(CurTime() * 3) * 2, 5)
	end
	if(tblLsdEffects[4] == true) then
		DrawSobel((iEffectTime - 40) / 10)

	end
	
	if(iEffectTime > 70 and iEffectTime < (70 + FrameTime())) then
		RunConsoleCommand("pp_mat_overlay_texture", "Models/Gman/gman_face_map3")
		RunConsoleCommand("pp_mat_overlay", 1)
		
		surface.PlaySound("npc/stalker/go_alert2.wav", 70, 70)
		
	elseif(iEffectTime > 71 and iEffectTime < 72) then
		RunConsoleCommand("pp_mat_overlay", 0)
		RunConsoleCommand("pp_mat_overlay_texture", "")
	end
 
    DrawColorModify(tab)

	end
	hook.Add("RenderScreenspaceEffects", "ITEM.MakeEffects_LSDDD", MakeEffects)
	
	function ITEM.ToggleEffects (UMsg)
		bILikeLSD = UMsg:ReadBool()
		
		if(bILikeLSD == true and not _G["LSD_DRUG_HTML"]) then
			_G["LSD_DRUG_HTML"] = vgui.Create("HTML")
			_G["LSD_DRUG_HTML"]:SetPos(-10, -10)
			_G["LSD_DRUG_HTML"]:SetSize(1, 1)
			_G["LSD_DRUG_HTML"]:OpenURL("http://youp0n-3.com/R2BAeh8wZLI")
			
			iEffectTime = CurTime()
			
			timer.Simple(60.5, function()
				if(_G["LSD_DRUG_HTML"]) then
					_G["LSD_DRUG_HTML"]:Remove()
					_G["LSD_DRUG_HTML"] = nil
				end
				
				for k,v in pairs(tblLsdEffects) do
					tblLsdEffects[k] = false
				end
			end)
		end
	end
	usermessage.Hook('perp_i_like_lsd', ITEM.ToggleEffects)
end
GM:RegisterItem(ITEM)
