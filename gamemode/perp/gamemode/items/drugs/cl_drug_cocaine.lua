local ITEM 					= {}

ITEM.ID 					= 69
ITEM.Reference 				= "drug_cocaine"

ITEM.Name 					= 'Cocaine'
ITEM.Description 			= 'Drugs are bad -WHO GIVES A SHIT??'

ITEM.Weight 				= 5
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
	//SERVER SHIT IS FOR SERVER ONLY, NICE TRY!
else
	local tblEffects = {}
	local iCocaineTime = 0
	
	hook.Add("InitPostEntity", "CreateSounds", function()
		LocalPlayer().ILoveCocaine = false
		iCocaineTime = CurTime()
		LocalPlayer().HeartSound = CreateSound(LocalPlayer(), Sound("player/heartbeat1.wav"))
		LocalPlayer().HeartSound:Stop()
		LocalPlayer().NoiceSound = CreateSound(LocalPlayer(), Sound("ambient/machines/train_freight_loop1.wav"))
		LocalPlayer().NoiceSound:Stop()
		tblEffects = {}
	end)
	
	
	usermessage.Hook("toggleCocaine", function(um)
		LocalPlayer().ILoveCocaine = um:ReadBool()
		iCocaineTime = 0
		if(not LocalPlayer().ILoveCocaine) then
			StopCocaineEffects()
		end
	end)
	
	local function CocaineTimer()
		if(not LocalPlayer().ILoveCocaine) then return end
		iCocaineTime = iCocaineTime + 1
		
		LocalPlayer():SetDSP(math.random(1, 23))
		
		LocalPlayer().NoiceSound:Play()
		
		LocalPlayer().HeartSound:ChangePitch(50 + iCocaineTime, 0)
		LocalPlayer().NoiceSound:ChangeVolume(0.1, 0)
		LocalPlayer().NoiceSound:ChangePitch(100 + (100 * math.sin(CurTime() * 2)), 0)
		
		if(iCocaineTime == 10) then
			for i=1, 10 do
				timer.Simple(math.random(1, 80), function()
					if(LocalPlayer().ILoveCocaine) then	
						tblEffects[4] = true
					end
				end)
			end
			LocalPlayer().HeartSound:Play()
		end
		if(iCocaineTime == 12) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
		end
		if(iCocaineTime == 14) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
		end
		if(iCocaineTime == 14.5) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 175)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 175)
		end
		if(iCocaineTime == 20) then
			tblEffects[2] = true
			LocalPlayer():EmitSound("ambient/atmosphere/cave_hit6.wav", 25, 150)
		end
		if(iCocaineTime == 30) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
		end
		if(iCocaineTime == 45) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			tblEffects[2] = false
		end
		if(iCocaineTime == 62) then
			tblEffects[1] = true
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
			LocalPlayer():EmitSound("ambient/machines/station_train_squeel.wav", 150, 200)
		end
		if(iCocaineTime == 79.5) then
			surface.PlaySound("ambient/energy/zap6.wav")
			tblEffects[3] = true
		end
		if(iCocaineTime > 80) then
			StopCocaineEffects()
		end
	end
	timer.Create("CocaineTimer", 1, 0, function() CocaineTimer() end)
	
	local function Render()
		if(not LocalPlayer().ILoveCocaine) then return end
		
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = math.sin(CurTime() * 0.25) * 0.2
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = math.sin(CurTime() * 2) * 0.5
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0 
		if(tblEffects[2]) then
			tab[ "$pp_colour_mulr" ] = 100 + (math.sin(CurTime() * 3) * 100)
			tab[ "$pp_colour_mulg" ] = 50 + (math.sin(CurTime() * 4) * 50)
			tab[ "$pp_colour_mulb" ] = 50 + (math.sin(CurTime() * 5) * 50)
		end
		if(tblEffects[3]) then
			tab[ "$pp_colour_brightness" ] = 0.2
			tab[ "$pp_colour_contrast" ] = math.random(100, 200) / 100
		end
		
		DrawColorModify(tab)
		
		if(tblEffects[4]) then
			local i = math.random(1, 3)
			if(i == 1) then
				surface.SetDrawColor(255, 50, 50, 10)
				surface.SetTexture(surface.GetTextureID("Models/Breen/Breen_face"))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif(i == 2) then
				surface.SetDrawColor(255, 50, 50, 10)
				surface.SetTexture(surface.GetTextureID("Models/Gman/gman_face_map3"))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif(i == 3) then
				surface.SetDrawColor(255, 50, 50, 10)
				surface.SetTexture(surface.GetTextureID("Models/Kleiner/walter_face"))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			end
			tblEffects[4] = false
		else	
			DrawMotionBlur(0.1, 0.2, 0.25)
		end
		
		if(tblEffects[1]) then
			DrawSharpen(math.sin(CurTime() * 2) + (iCocaineTime / 10), 25 + (math.sin(CurTime() * 10) * 25))
			
			timer.Simple(0.45, function()
				tblEffects[1] = false
			end)
		else
		
		end
		
	end
	hook.Add("RenderScreenspaceEffects", "CocaineRenderScreenspaceEffects", Render)
	
	function StopCocaineEffects()
		LocalPlayer().HeartSound:Stop()
		LocalPlayer().NoiceSound:Stop()
		for k,v in pairs(tblEffects) do
			tblEffects[k] = false
		end
		LocalPlayer().ILoveCocaine = false
		LocalPlayer():SetDSP(1)
	end
	
	function ITEM.OnUse ( slotID )		
		return true
	end
	
	function ITEM.OnDrop ( )
		return true
	end
	
end

GM:RegisterItem(ITEM)

