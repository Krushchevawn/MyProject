
local PANEL = {};

	local parseRules = function ( Results, whereTo, Size )
		if (!whereTo) then return; end
		
		local explodedResults = string.Explode("\n", Results);
		
		for k, v in pairs(explodedResults) do
			local isHeader = string.sub(v, 1, 1) == ":";
			
			local font = PERPX_SKIN.fontLabel;
			if (isHeader) then
				font = PERPX_SKIN.fontLargeLabel;
				v = string.sub(v, 2);
			end
			
			local splitResults = cutLength(v, Size, font);
			
			for _, txt in pairs(splitResults) do
				local UserNamel = vgui.Create("DLabel", whereTo);
				UserNamel:SetPos(80, 30);
				UserNamel:SetSize(100, 20);
				
				if (isHeader) then
					UserNamel:SetText(":" .. txt);
					UserNamel:SetColor(Color(255, 255, 255, 255));
				else
					UserNamel:SetText(txt);
				end
				
				whereTo:AddItem(UserNamel);
			end
		end
	end

function PANEL:Init ( )
	self:SetTitle("Help");
	self:ShowCloseButton(true);
	self:SetDraggable(false);
	self:SetSkin("perpx")
	
	self:SetAlpha(GAMEMODE.GetGUIAlpha());
	
	self:MakePopup()
		
	self.PropertySheet = vgui.Create("DPropertySheet", self);
	
	self.RulesList = vgui.Create("DPanelList", self);
	self.RulesList:EnableHorizontal(false)
	self.RulesList:EnableVerticalScrollbar(true)
	self.RulesList:SetPadding(5);
	self.RulesList:SetPadding(5);
	self.RulesList:SetSpacing(-5);
	
	self.ChatList = vgui.Create("DPanelList", self);
	self.ChatList:EnableHorizontal(false)
	self.ChatList:EnableVerticalScrollbar(true)
	self.ChatList:SetPadding(5);
	self.ChatList:SetPadding(5);
	self.ChatList:SetSpacing(-5);
	
	self.FAQList = vgui.Create("DPanelList", self);
	self.FAQList:EnableHorizontal(false)
	self.FAQList:EnableVerticalScrollbar(true)
	self.FAQList:SetPadding(5);
	self.FAQList:SetPadding(5);
	self.FAQList:SetSpacing(-5);
	
	self.LawsList = vgui.Create("DPanelList", self);
	self.LawsList:EnableHorizontal(false)
	self.LawsList:EnableVerticalScrollbar(true)
	self.LawsList:SetPadding(5);
	self.LawsList:SetPadding(5);
	self.LawsList:SetSpacing(-5);
		
	self.OptionsList = vgui.Create("DPanelList", self);
	self.OptionsList:EnableHorizontal(false)
	self.OptionsList:EnableVerticalScrollbar(true)
	self.OptionsList:SetPadding(5);
	self.OptionsList:SetPadding(5);
	self.OptionsList:SetSpacing(5);
		
	self.ReportList = vgui.Create("DPanelList", self);
	self.ReportList:EnableHorizontal(true)
	self.ReportList:EnableVerticalScrollbar(true)
	self.ReportList:SetPadding(5);
	self.ReportList:SetPadding(5);
	self.ReportList:SetSpacing(5);
	
	self.DonateMenu = vgui.Create("DPanelList", self);
	self.DonateMenu:EnableVerticalScrollbar(true)
	self.DonateMenu:SetPadding(20);
	self.DonateMenu:SetPadding(20);
	self.DonateMenu:SetSpacing(20);
	
	self.PropertySheet:AddSheet("Rules List", self.RulesList);
	self.PropertySheet:AddSheet("Chat Help", self.ChatList);
	self.PropertySheet:AddSheet("F.A.Q.", self.FAQList)
	self.PropertySheet:AddSheet("Laws", self.LawsList)
	self.PropertySheet:AddSheet("Options", self.OptionsList);
	self.PropertySheet:AddSheet("Donate", self.DonateMenu);
	
	local viptext = vgui.Create("DLabel", self.DonateMenu)
	viptext:SetColor(Color(0,120,200,255))
	viptext:SetFont("SkillsFont")
	viptext:SetText("Welcome, Want to donate to help our server stay up click below")
	viptext:SizeToContents()
	
	local vipbutton = vgui.Create( "DButton", self.DonateMenu )
	vipbutton:SetSize( 100, 50 )
	vipbutton:SetText( "Donate" )
	vipbutton.DoClick = function( button )
		self:Close()
		local D = vgui.Create("DFrame")
		D:SetPos(50,50)
		D:SetTitle("Donate")
		D:SetDraggable(false)
		D:SetSize(ScrW() - 100, ScrH() - 100)
		D:MakePopup()

		local HTMLPurch = vgui.Create("HTML", D)
		HTMLPurch:SetPos(20, 30)
		HTMLPurch:SetSize(D:GetWide() - 40, D:GetTall() - 40)
		HTMLPurch:OpenURL(URL_Donate)
	end
	
	local vipdisc = vgui.Create("DLabel", self.VipMenu)
	vipdisc:SetColor(Color(200,200,200,255))
	vipdisc:SetFont("SkillsFont")
	vipdisc:SetText([[Rewards for geting VIP: 
	 - Physgun
	 - Blue name in scoreboard
	 - 25% more pay
	 - 30 prop limit instead of 20
	 - Access to VIP car dealership
	 - $20k cash Instant
	 - Grow up to 10 pots
	 - SWATJob (Unlocked)
	 
	 Rewards for geting Gold:
	 - Physgun
	 - Gold name on scoreboard
	 - 50% more pay
	 - Access to Gold and Vip car dealership
	 - Max genes raised to 15 
	 - $25k cash Instant 
	 - SwatJob (Unlocked)
         - BusDriver (Unlocked)
         - TaxiDriver (Unlocked)
         - RoadCrew (Unlocked) 		
	 - Custom Physgun color.
	
	Donations will not be refunded.]])
	vipdisc:SizeToContents()
	
	self.DonateMenu:AddItem(viptext)
	self.DonateMenu:AddItem(vipbutton)
	self.DonateMenu:AddItem(vipdisc)
	
	self:SetSize(ScrW() * .5, ScrH() * .5);
	self:SetPos(ScrW() * .25, ScrH() * .25);
	
	if GAMEMODE.ChatList then
		parseRules(GAMEMODE.ChatList, self.ChatList, self:GetWide() - 50)
	else
		http.Fetch(URL_CHAT, function(r)
			if self && self.Remove then 
				GAMEMODE.ChatList = r;
				parseRules(r, self.ChatList, self:GetWide() - 50);
			end
		end)
	end
	
	if GAMEMODE.Rules then
		parseRules(GAMEMODE.Rules, self.RulesList, self:GetWide() - 50)
	else
		http.Fetch(URL_RULES, function(r)
			if self && self.Remove then 
				GAMEMODE.Rules = r
				parseRules(r, self.RulesList, self:GetWide() - 50)
			end
		end)
	end
	
	if GAMEMODE.FAQ then
		parseRules(GAMEMODE.FAQ, self.FAQList, self:GetWide() - 50)
	else
		http.Fetch(URL_FAQ, function(r)
			if self && self.Remove then 
				GAMEMODE.FAQ = r
				parseRules(r, self.FAQList, self:GetWide() - 50)
			end
		end)
	end
	
	if GAMEMODE.LAWS then
		parseRules(GAMEMODE.LAWS, self.LawsList, self:GetWide() - 50)
	else
		http.Fetch(URL_LAWS, function(r)
			if self && self.Remove then 
				GAMEMODE.LAWS = r
				parseRules(r, self.LawsList, self:GetWide() - 50)
			end
		end)
	end
		
	// Report tab
	if (LocalPlayer():HasBlacklist('a')) then
		self.ReportList:EnableHorizontal(false);
		self.LabelOfReport = vgui.Create('perp2_reportbl_warn', self.ReportList);
		self.ReportList:AddItem(self.LabelOfReport);
	else
		self.LabelOfReport = vgui.Create("DLabel", self.ReportList);
		self.LabelOfReport:SetText("This report will send a text log of the last 100 messages.");
		self.ReportList:AddItem(self.LabelOfReport);
		self.LabelOfReport:SetSize(self:GetWide() * .5, 20);
		
		self.ReportButton = vgui.Create("DButton", self.ReportList);
		self.ReportButton:SetText("Report Player");
		function self.ReportButton.DoClick ( )
			GAMEMODE.LastReportPlayer = GAMEMODE.LastReportPlayer or 0;
			
			if (GAMEMODE.LastReportPlayer > CurTime()) then
				LocalPlayer():Notify("You must wait another " .. math.ceil(GAMEMODE.LastReportPlayer - CurTime()) .. " seconds before reporting another player.");
				return;
			end
			
			if (self.reportListInfo[self.OffenderList:GetSelectedLine()] && self.ruleBrokenInfo[self.RuleList:GetSelectedLine()]) then
				if (LocalPlayer():IsAdmin()) then
					GAMEMODE.LastReportPlayer = CurTime() + 5;
				elseif (LocalPlayer():IsVIP()) then
					GAMEMODE.LastReportPlayer = CurTime() + 30;
				else
					GAMEMODE.LastReportPlayer = CurTime() + 60;
				end
				
				RunConsoleCommand("perp_r_p", self.reportListInfo[self.OffenderList:GetSelectedLine()], self.ruleBrokenInfo[self.RuleList:GetSelectedLine()], self.AdditionalComments:GetValue());
			end
		end
		self.ReportList:AddItem(self.ReportButton);
		self.ReportButton:SetSize(self:GetWide() * .45, 20);
		
		self.AdditionalComments = vgui.Create("DTextEntry", self.ReportList);
		self.AdditionalComments:SetText("Additional Comments (Keep This Short)");
		self.ReportList:AddItem(self.AdditionalComments);
		self.AdditionalComments:SetSize(self:GetWide() * .98, 20);

		self.OffenderList = vgui.Create("DListView", self.ReportList)
		self.OffenderList:SetMultiSelect(false);
		self.OffenderList:AddColumn("Select Offender");
		
		self.reportListInfo = {};
		
		for k, v in pairs(GAMEMODE.PlayerNamesForReport) do
			if (v[1] && IsValid(v[1])) then
				self.reportListInfo[tonumber(self.OffenderList:AddLine(v[2]):GetID())] = v[3];
			elseif (v[4]) then
				if (CurTime() - v[4] > 60) then
					local mins = math.floor(math.ceil(CurTime() - v[4]) / 60);
					
					if (mins == 1) then
						self.reportListInfo[tonumber(self.OffenderList:AddLine(v[2] .. " [Left " .. math.floor(math.ceil(CurTime() - v[4]) / 60) .. " Minute Ago]"):GetID())] = v[3];
					else
						self.reportListInfo[tonumber(self.OffenderList:AddLine(v[2] .. " [Left " .. math.floor(math.ceil(CurTime() - v[4]) / 60) .. " Minutes Ago]"):GetID())] = v[3];
					end
				else
					self.reportListInfo[tonumber(self.OffenderList:AddLine(v[2] .. " [Left " .. math.ceil(CurTime() - v[4]) .. " Seconds Ago]"):GetID())] = v[3];
				end
			end
		end
		
		self.RuleList = vgui.Create("DListView", self.ReportList)
		self.RuleList:SetMultiSelect(false);
		self.RuleList:AddColumn("Select Rule Broken");
		
		self.ruleBrokenInfo = {};
		
		for i = 1, 41 do
			self.ruleBrokenInfo[tonumber(self.RuleList:AddLine("Rule #" .. tostring(i)):GetID())] = i;
		end
		
		self.ReportList:PerformLayout();
		
		self.OffenderList:SetPos(5, 55);
		self.RuleList:SetPos(10 + self:GetWide() * .67, 55);
		
		self.OffenderList:SetHeight(self:GetTall() * .8 - 55);
		self.OffenderList:SetWide(self:GetWide() * .67);
		
		self.RuleList:SetHeight(self:GetTall() * .8 - 55);
		self.RuleList:SetWide(self:GetWide() * .28);
		
		self.ReportList:Remove()
	end
	
	GAMEMODE.LoadOptionsList(self.OptionsList);
end

function PANEL:PerformLayout ( )
	self:SetSize(ScrW() * .5, ScrH() * .5);
	self:SetPos(ScrW() * .25, ScrH() * .25);
	
	self.BaseClass.PerformLayout(self);
	
	self.PropertySheet:StretchToParent(5, 30, 5, 5)
end

vgui.Register("perp2_help", PANEL, "DFrame");