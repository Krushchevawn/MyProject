local function GetPaydayCommand ( UMsg )
	local TO_EARN = UMsg:ReadShort()
	local TO_EARN_TEXT = UMsg:ReadString()
	
	LocalPlayer():GiveBank(TO_EARN, true)
	
	if(!GAMEMODE.Options_ShowPaydayInfo:GetBool()) then return; end
	LocalPlayer():Notify("You have earned $".. TO_EARN .. " " .. TO_EARN_TEXT .. " It has been sent to your bank account.")
end
usermessage.Hook("perp_payday", GetPaydayCommand);