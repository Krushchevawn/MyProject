function GM.CruiseControlBindPress(objPl, strBind, bPressed)
	if(!LocalPlayer():InVehicle()) then return end
	
	if(bPressed) then
		if(strBind == "invnext") then
			RunConsoleCommand("perp_cc_down")
		elseif(strBind == "invprev") then
			RunConsoleCommand("perp_cc_up")
		end
	end
end
hook.Add("PlayerBindPress", "CruiseControlBindPress", GM.CruiseControlBindPress)