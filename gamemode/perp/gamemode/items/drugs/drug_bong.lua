local ITEM 					= {}

ITEM.ID 					= 65
ITEM.Reference 				= "drug_bong"

ITEM.Name 					= '"Tobacco" Water Pipe'
ITEM.Description 			= "Disclaimer: For use with tobacco products only."

ITEM.Weight 				= 30
ITEM.Cost					= 500

ITEM.MaxStack 				= 6

ITEM.InventoryModel = "models/katharsmodels/contraband/waterpijp/waterpijp.mdl"
ITEM.ModelCamPos = Vector(48, 0, 28)
ITEM.ModelLookAt = Vector(-100, 0, 10)
ITEM.ModelFOV = 70
ITEM.WorldModel 			= "models/katharsmodels/contraband/waterpijp/waterpijp.mdl"

ITEM.RestrictedSelling	 	= false // Used for drugs and the like. So we can't sell it.

ITEM.EquipZone 				= nil											
ITEM.PredictUseDrop			= true // If this isn't true, the server will tell the client when something happens to us based on the server's OnUse

if SERVER then

	function ITEM.OnUse (Player)	
		if !Player:HasItem("drug_pot") then
			return false
		end
		
		Player:TakeItemByID(13, 1)
		Player:EmitSound("perp2/smoke.mp3")
		
		Player:GiveItem(65, 1, true)
		
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
	local TransitionTime = 6
	local TimeLasting = 60

	function ITEM.MakeEffects ()
		if !GAMEMODE.WeedStart then return end
		
		local End = GAMEMODE.WeedStart + TimeLasting + TransitionTime * 2
		
		if End < CurTime() then return end

		local tab = {}
		tab["$pp_colour_addr"] = 0
		tab["$pp_colour_addg"] = 0
		tab["$pp_colour_addb"] = 0
		tab["$pp_colour_mulr"] = 0
		tab["$pp_colour_mulg"] = 0
		tab["$pp_colour_mulb"] = 0
		
		if End > CurTime() then
			if GAMEMODE.WeedStart + TransitionTime > CurTime() then
				local s = GAMEMODE.WeedStart
				local e = s + TransitionTime
				local c = CurTime()
				local pf = (c-s) / (e-s)
				
				tab["$pp_colour_colour"] =   1 - pf * 0.3
				tab["$pp_colour_brightness"] = -pf * 0.11
				tab["$pp_colour_contrast"] = 1 + pf * 1.62
				DrawMotionBlur(0.03, pf * .77, 0)
			elseif End - TransitionTime < CurTime() then
			
				local e = End
				local s = e - TransitionTime
				local c = CurTime()
				local pf = 1 - (c-s) / (e-s)
				
				tab["$pp_colour_colour"] = 1 - pf * 0.3
				tab["$pp_colour_brightness"] = -pf * 0.11
				tab["$pp_colour_contrast"] = 1 + pf * 1.62
				DrawMotionBlur(0.03, pf * .77, 0)
			else
				tab[ "$pp_colour_colour" ] = 0.77
				tab[ "$pp_colour_brightness" ] = -0.11
				tab[ "$pp_colour_contrast" ] = 2.62
				DrawMotionBlur(0.03, .77, 0)
			end
			
			DrawColorModify(tab) 
		end
	end
	hook.Add("RenderScreenspaceEffects", "ITEM.MakeEffects_Weed", ITEM.MakeEffects)

	function ITEM.OnUse (Player)	
		if !LocalPlayer():HasItem("drug_pot") then
			LocalPlayer():Notify('You need something to use with this.')
			return false
		end
		
		LocalPlayer():TakeItemByID(13, 1)
		ITEM.DoBong ()
		
		return true
	end
	
	function ITEM.DoBong ()
		surface.PlaySound('perp/bong.mp3')
		
		timer.Simple(3, function () GAMEMODE.WeedStart = CurTime() end)
	end
	usermessage.Hook('perp_i_bong', ITEM.DoBong)
	
	function ITEM.OnDrop ( )
		return true
	end
	
end
GM:RegisterItem(ITEM)
