
local function ShowUserCreationScreen ( )
	local Models = {};
	for k, v in pairs(MODEL_AVAILABLE["m"]) do table.insert(Models, {SEX_MALE, LocalPlayer():GetModelPath("m", k, 1), "m_" .. k .. "_01"}); end
	for k, v in pairs(MODEL_AVAILABLE["f"]) do table.insert(Models, {SEX_FEMALE, LocalPlayer():GetModelPath("f", k, 1), "f_" .. k .. "_01"}); end
	local curModelReference = 1;

	local W, H = 400, 185;
	
	AccountCreationScreen = vgui.Create("DFrame")
	AccountCreationScreen:SetPos(ScrW() * .5 - W * .5, ScrH() * .5 - H * .5)
	AccountCreationScreen:SetSize(W, H)
	AccountCreationScreen:SetTitle("Character Creation")
	AccountCreationScreen:SetVisible(true)
	AccountCreationScreen:SetDraggable(false)
	AccountCreationScreen:ShowCloseButton(false)
	AccountCreationScreen:MakePopup()
	AccountCreationScreen:SetAlpha(GAMEMODE.GetGUIAlpha());
	AccountCreationScreen:SetSkin("perpx")
	
		local PanelSize = W * .5 - 7.5;
		local UsCash = vgui.Create("DPanelList", AccountCreationScreen);
		UsCash:EnableHorizontal(false)
		UsCash:EnableVerticalScrollbar(true)
		UsCash:StretchToParent(130, 30, 5, 5);
		UsCash:SetPadding(5);
		
		local UsCash2 = vgui.Create("DPanelList", AccountCreationScreen);
		UsCash2:EnableHorizontal(false)
		UsCash2:EnableVerticalScrollbar(true)
		UsCash2:SetPos(5, 30);
		UsCash2:SetSize(120, 150);
		UsCash2:SetPadding(5);
		
		local ModelPanel = vgui.Create('DModelPanel', AccountCreationScreen);
		ModelPanel:SetPos(5, 30);
		ModelPanel:SetSize(120, 120);
		ModelPanel:SetFOV(70);
		ModelPanel:SetCamPos(Vector(14, 0, 60));
		ModelPanel:SetLookAt(CAM_LOOK_AT[SEX_MALE]);
		ModelPanel:SetModel(Models[curModelReference][2]);
		function ModelPanel:LayoutEntity( Entity )  end
		local ourModel = Models[curModelReference][3]
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("Character's First Name:");
		UsCash:AddItem(UserNamel);
		
		local LeftButton = vgui.Create("DButton", AccountCreationScreen);
		LeftButton:SetPos(10, H - 30);
		LeftButton:SetSize((110 * .5) - 2.5, 20);
		LeftButton:SetText("<");
		
		function LeftButton:DoClick ( )
			curModelReference = curModelReference - 1;
			if (curModelReference < 1) then
				curModelReference = #Models;
			end
			
			ModelPanel:SetModel(Models[curModelReference][2]);
			ModelPanel:SetLookAt(CAM_LOOK_AT[Models[curModelReference][1]]);
			ourModel = Models[curModelReference][3];
		end
		
		local RightButton = vgui.Create("DButton", AccountCreationScreen);
		RightButton:SetPos(12.5 + (110 * .5), H - 30);
		RightButton:SetSize((110 * .5) - 2.5, 20);
		RightButton:SetText(">");
		
		function RightButton:DoClick ( )
			curModelReference = curModelReference + 1;
			if (curModelReference > #Models) then
				curModelReference = 1;
			end
			
			ModelPanel:SetModel(Models[curModelReference][2]);
			ModelPanel:SetLookAt(CAM_LOOK_AT[Models[curModelReference][1]]);
			ourModel = Models[curModelReference][3];
		end
		
		UserName = vgui.Create("DTextEntry", UsCash);
		UserName:SetPos(80, 30);
		UserName:SetSize(100, 20);
		UserName:SetText("John");
		UsCash:AddItem(UserName);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("Character's Last Name:");
		UsCash:AddItem(UserNamel);
		
		UserPass = vgui.Create("DTextEntry", UsCash);
		UserPass:SetPos(80, 30);
		UserPass:SetSize(100, 20);
		UserPass:SetText("Doe");
		UsCash:AddItem(UserPass);
		
		local UserNamel = vgui.Create("DLabel", UsCash);
		UserNamel:SetPos(80, 30);
		UserNamel:SetSize(100, 20);
		UserNamel:SetText("");
		UsCash:AddItem(UserNamel);
		
		local SubmitButton = vgui.Create("DButton", UsCash);
		SubmitButton:SetPos(80, 30);
		SubmitButton:SetSize(100, 20);
		SubmitButton:SetText("Create User");
		
		UsCash:AddItem(SubmitButton);
		
		local function MonitorColors ( wantReturn )
			local firstName = UserName:GetValue();
			local lastName = UserPass:GetValue();

			local anyInvalid = false;
			
			if !GAMEMODE.IsValidPartialName(firstName) then
				UserName:SetTextColor(Color(255, 0, 0, 255));
				anyInvalid = true;
			else
				UserName:SetTextColor(Color(0, 0, 0, 255));
			end
	
			if !GAMEMODE.IsValidPartialName(lastName) then
				UserPass:SetTextColor(Color(255, 0, 0, 255));
				anyInvalid = true;
			else
				UserPass:SetTextColor(Color(0, 0, 0, 255));
			end
			
			if (!GAMEMODE.IsValidName(firstName, lastName, true)) then
				UserPass:SetTextColor(Color(255, 0, 0, 255));
				UserName:SetTextColor(Color(255, 0, 0, 255));
				anyInvalid = true;
			end
			
			if (anyInvalid) then
				SubmitButton:SetEnabled(false);
			else
				SubmitButton:SetEnabled(true);
			end
			
			if (wantReturn) then
				return !anyInvalid;
			end
		end
		hook.Add('Think', 'MonColors', MonitorColors);
		
		function SubmitButton:DoClick ( )
			if (!MonitorColors(true)) then
				LocalPlayer():Notify("Please fix any fields that may have errors.");
				return;
			end
			
			hook.Remove("Think", 'MonColors');
			AccountCreationScreen:Remove();
			
			RunConsoleCommand("perp_nc", ourModel, UserName:GetValue(), UserPass:GetValue());
		end
end

local rulesOnce = false
function ShowRulesConfirmation ( )
	if (rulesOnce) then return end
	rulesOnce = true
	
	local W, H = ScrW() * .5, ScrH() * .75;
	local X, Y = ScrW() * .5 - W * .5, ScrH() * .5 - H * .5;
	
	local ConfirmRulesScreen = vgui.Create("DFrame")
	ConfirmRulesScreen:SetPos(X, Y)
	ConfirmRulesScreen:SetSize(W, H)
	ConfirmRulesScreen:SetTitle("Rules Confirmation")
	ConfirmRulesScreen:SetVisible(true)
	ConfirmRulesScreen:SetDraggable(false)
	ConfirmRulesScreen:ShowCloseButton(false)
	ConfirmRulesScreen:MakePopup()
	ConfirmRulesScreen:SetAlpha(GAMEMODE.GetGUIAlpha());
	
	local PanelList = vgui.Create("DPanelList", ConfirmRulesScreen);
	PanelList:EnableHorizontal(false)
	PanelList:EnableVerticalScrollbar(true)
	PanelList:SetPos(5, 50);
	PanelList:StretchToParent(5, 30, 5, 30);
	PanelList:SetPadding(5);
	PanelList:SetSpacing(-5);

		http.Fetch(URL_RULES, function(Res2)
			local Results2 = Res2 or ""
			if (!PanelList) then return end
			
			local explodedResults = string.Explode("\n", ":RULES CONFIRMATION\n\n" .. Results2);
			
			for k, v in pairs(explodedResults) do
				local isHeader = string.sub(v, 1, 1) == ":";
				
				local font = PERPX_SKIN.fontLabel;
				if (isHeader) then
					font = PERPX_SKIN.fontLargeLabel;
					v = string.sub(v, 2);
				end
				
				local splitResults = cutLength(v, PanelList:GetWide() - 40, font);
				
				for _, txt in pairs(splitResults) do
					local UserNamel = vgui.Create("DLabel", PanelList);
					UserNamel:SetPos(80, 30);
					UserNamel:SetSize(100, 20);
					
					if (isHeader) then
						UserNamel:SetText(":" .. txt);
						UserNamel:SetColor(Color(255, 255, 255, 255));
					else
						UserNamel:SetText(txt);
					end
					
					PanelList:AddItem(UserNamel);
				end
			end
		end);
		
	
	local SubmitButton = vgui.Create("DButton", ConfirmRulesScreen);
	SubmitButton:SetPos(5, H - 25);
	SubmitButton:SetSize(W * .5 - 7.5, 20);
	SubmitButton:SetText("I Agree ( 10 Seconds )");
	SubmitButton:SetDisabled(true);
	
	timer.Simple(1, function ( ) SubmitButton:SetText("I Agree ( 9 Seconds )"); end);
	timer.Simple(2, function ( ) SubmitButton:SetText("I Agree ( 8 Seconds )"); end);
	timer.Simple(3, function ( ) SubmitButton:SetText("I Agree ( 7 Seconds )"); end);
	timer.Simple(4, function ( ) SubmitButton:SetText("I Agree ( 6 Seconds )"); end);
	timer.Simple(5, function ( ) SubmitButton:SetText("I Agree ( 5 Seconds )"); end);
	timer.Simple(6, function ( ) SubmitButton:SetText("I Agree ( 4 Seconds )"); end);
	timer.Simple(7, function ( ) SubmitButton:SetText("I Agree ( 3 Seconds )"); end);
	timer.Simple(8, function ( ) SubmitButton:SetText("I Agree ( 2 Seconds )"); end);
	timer.Simple(9, function ( ) SubmitButton:SetText("I Agree ( 1 Seconds )"); end);
	timer.Simple(10, function ( ) SubmitButton:SetText("I Agree"); SubmitButton:SetDisabled(false); LOADED_RULES = true; end);
	
	function SubmitButton:DoClick ( )
		if (LOADED_RULES) then
			ConfirmRulesScreen:Remove();
			ShowUserCreationScreen();
		end
	end
	
	local SubmitButton = vgui.Create("DButton", ConfirmRulesScreen);
	SubmitButton:SetPos(10 + (W * .5 - 7.5), H - 25);
	SubmitButton:SetSize(W * .5 - 7.5, 20);
	SubmitButton:SetText("I Disagree");
	
	function SubmitButton:DoClick ( )
		RunConsoleCommand('disconnect');
	end
end

local function startNewChar ( )
	if (GAMEMODE.ShowedIntro) then
		ShowRulesConfirmation();
	else
		vgui.Create("perp2_intro"):EnableRules();
	end
end

usermessage.Hook("perp_newchar", startNewChar);