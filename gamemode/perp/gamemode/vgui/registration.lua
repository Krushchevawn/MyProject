
local AccountCreationScreen;

function GetCreateAccountCommand ( )
	vgui.Create("perp2_intro"):EnableCreation();
	GAMEMODE.ShowedIntro = true;
end

function ShowRegisterForm ( )
	local W, H = 250, 185;
	
	AccountCreationScreen = vgui.Create("DFrame")
	AccountCreationScreen:SetPos(ScrW() * .5 - W * .5, ScrH() * .5 - H * .5)
	AccountCreationScreen:SetSize(W, H)
	AccountCreationScreen:SetTitle("Pulsar Effect Site Account Creation")
	AccountCreationScreen:SetVisible(true)
	AccountCreationScreen:SetDraggable(false)
	AccountCreationScreen:ShowCloseButton(false)
	AccountCreationScreen:MakePopup()
	AccountCreationScreen:SetAlpha(GAMEMODE.GetGUIAlpha());
	AccountCreationScreen:SetSkin("perp2")
	
	function PopRequest ( ) 
		local PanelSize = W * .5 - 7.5;
		local UsCash = vgui.Create("DPanelList", AccountCreationScreen);
		UsCash:EnableHorizontal(false)
		UsCash:EnableVerticalScrollbar(true)
		UsCash:SetPos(5, 50);
		UsCash:SetSize(PanelSize, 20);
		UsCash:StretchToParent(5, 30, 5, 5);
		UsCash:SetPadding(5);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("Login Name:");
		UsCash:AddItem(UserNamel);
		
		UserName = vgui.Create("DTextEntry", UsCash);
		UserName:SetPos(80, 30);
		UserName:SetSize(100, 20);
		UserName:SetText(string.gsub(LocalPlayer():Nick(), " ", ""));
		UsCash:AddItem(UserName);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("Login Password:");
		UsCash:AddItem(UserNamel);
		
		UserPass = vgui.Create("DTextEntry", UsCash);
		UserPass:SetPos(80, 30);
		UserPass:SetSize(100, 20);
		UserPass:SetText("Password");
		UsCash:AddItem(UserPass);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local SubmitButton = vgui.Create("DButton", UsCash);
		SubmitButton:SetPos(80, 30);
		SubmitButton:SetSize(100, 20);
		SubmitButton:SetText("Register");
		
		local function MonitorColors ( )
			local Text = UserPass:GetValue();
			
			if string.find(Text, ' ') or string.find(Text, '"') or string.find(Text, "'") or string.find(Text, " ") or string.len(Text) < 5 or string.len(Text) > 32 then
				UserPass:SetTextColor(Color(255, 0, 0, 255));
			else
				OverallOkay = true;
				
				for i = 1, string.len(Text) do
					StringToCheck = string.lower(string.sub(Text, i, i));
					
					local IsOkay = false;
					
					for k, v in pairs(VALID_CHARACTERS) do
						if v == StringToCheck then
							IsOkay = true;
							break;
						end
					end
					
					if !IsOkay then
						OverallOkay = false;
					end
				end
				
				if OverallOkay then
					UserPass:SetTextColor(Color(0, 0, 0, 255));
				else
					UserPass:SetTextColor(Color(255, 0, 0, 255));
				end
			end
			
			local Text = UserName:GetValue();
			
			if string.find(Text, ' ') or string.find(Text, '"') or string.find(Text, "'") or string.find(Text, " ") or string.len(Text) < 3 or string.len(Text) > 32 then
				UserName:SetTextColor(Color(255, 0, 0, 255));
			else
				OverallOkay = true;
				
				for i = 1, string.len(Text) do
					StringToCheck = string.lower(string.sub(Text, i, i));
					
					local IsOkay = false;
					
					for k, v in pairs(VALID_CHARACTERS) do
						if v == StringToCheck then
							IsOkay = true;
							break;
						end
					end
					
					if !IsOkay then
						OverallOkay = false;
					end
				end
				
				if OverallOkay then
					UserName:SetTextColor(Color(0, 0, 0, 255));
				else
					UserName:SetTextColor(Color(255, 0, 0, 255));
				end
			end
		end
		hook.Add('Think', 'MonColors', MonitorColors);
		
		function SubmitButton:DoClick ( )
			RunConsoleCommand('pe_reg', UserName:GetValue(), UserPass:GetValue());
			UsCash:Remove();
			hook.Remove('Think', 'MonColors', MonitorColors);
			PopLoading();
		end
		
		UsCash:AddItem(SubmitButton);
	end
	
	function PopLoading ( )		
		local PanelSize = W * .5 - 7.5;
		local UsCash = vgui.Create("DPanelList", AccountCreationScreen);
		UsCash:EnableHorizontal(false)
		UsCash:EnableVerticalScrollbar(true)
		UsCash:SetPos(5, 50);
		UsCash:SetSize(PanelSize, 20);
		UsCash:StretchToParent(5, 30, 5, 5);
		UsCash:SetPadding(5);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);

		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("                               Loading...");
		UsCash:AddItem(UserNamel);
	end
	
	PopRequest();
end

local function KillAccountForm ( )
	if AccountCreationScreen then 
		AccountCreationScreen:Remove();
	end
	
	ShowRulesConfirmation();
end
usermessage.Hook('pe_close_reg', KillAccountForm);

local function GetRestoreAccountCommand ( )
	if AccountCreationScreen then 
		AccountCreationScreen:Remove();
	end
	
	ShowRegisterForm();
end
usermessage.Hook('pe_restore_reg', GetRestoreAccountCommand);
