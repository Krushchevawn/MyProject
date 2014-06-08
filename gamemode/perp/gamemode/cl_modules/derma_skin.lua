SKIN = {}
SKIN.CustomColor1 = Color(40, 40, 40, 255)

SKIN.PrintName 		 =  "lolrpomg fuck off Skin"
SKIN.Author 		 =  "Maurits yar yar har har"
SKIN.DermaVersion	 =  1

SKIN.bg_color 					 =  Color(50, 50, 50, 200)//Color(100, 100, 100, 186)
SKIN.bg_color_sleep 			 =  Color(70, 70, 70, 200)//Color(80, 80, 80, 186)
SKIN.bg_color_dark				 =  Color(40, 40, 40, 200)//Color(60, 60, 60, 186)
SKIN.bg_color_bright			 =  Color(80, 80, 80, 200)//Color(120, 120, 120, 186)

SKIN.fontFrame					 =  "Default"

SKIN.control_color 				 =  Color(50, 50, 50, 200)
SKIN.control_color_highlight	 =  Color(80, 80, 80, 200)
SKIN.control_color_active 		 =  Color(70, 70, 70, 200)
SKIN.control_color_bright 		 =  Color(100, 100, 100, 200)
SKIN.control_color_dark 		 =  Color(30, 30, 30, 200)

SKIN.bg_alt1 					 =  Color(50, 50, 50, 200)
SKIN.bg_alt2 					 =  Color(55, 55, 55, 200)

SKIN.listview_hover				 =  Color(40, 40, 40, 200)
SKIN.listview_selected			 =  Color(70, 70, 100, 200)

SKIN.text_bright				 =  Color(255, 255, 255, 200) //Color(255, 255, 255, 200)
SKIN.text_normal				 =  Color(220, 220, 220, 200) //Color(200, 200, 200, 200)
SKIN.text_dark					 =  Color(200, 200, 200, 200) //Color(80, 80, 80, 200)
SKIN.text_highlight				 =  Color(255, 255, 255, 200) //Color(255, 20, 20, 200)

SKIN.texGradientUp				 =  Material("gui/gradient_up")
SKIN.texGradientDown			 =  Material("gui/gradient_down")

SKIN.combobox_selected			 =  SKIN.listview_selected

SKIN.panel_transback			 =  Color(255, 255, 255, 50)
SKIN.tooltip					 =  Color(200, 200, 200, 225)

SKIN.colPropertySheet 			 =  Color(50, 50, 50, 255)//Color(230, 230, 230, 200)
SKIN.colTab			 			 =  Color(50, 50, 50, 255) //Color(255, 255, 255, 255)
SKIN.colTabInactive				 =  Color(40, 40, 40, 200)
SKIN.colTabShadow				 =  Color(20, 20, 20, 255)
SKIN.colTabText		 			 =  Color(255, 255, 255, 225)
SKIN.colTabTextInactive			 =  Color(150, 150, 150, 155)
SKIN.fontTab					 =  "Default"

SKIN.colCollapsibleCategory		 =  Color(100, 100, 100, 100)

SKIN.colCategoryText			 =  Color(200, 200, 186, 225)
SKIN.colCategoryTextInactive	 =  Color(100, 100, 120, 155)
SKIN.fontCategoryHeader			 =  "TabLarge"

SKIN.colNumberWangBG			 =  Color(255, 186, 150, 200)
SKIN.colTextEntryBG				 =  Color(255, 255, 255, 200)
SKIN.colTextEntryBorder			 =  Color(127, 157, 185, 200)
SKIN.colTextEntryText			 =  Color(0, 0, 0, 200)
SKIN.colTextEntryTextHighlight	 =  Color(100, 100, 100, 200)

SKIN.colMenuBG					 =  Color(150, 150, 150, 250)
SKIN.colMenuBorder				 =  Color(55, 55, 55, 255)

SKIN.colButtonText				 =  Color(255, 255, 255, 255)
SKIN.colButtonTextDisabled		 =  Color(170, 170, 170, 200)
SKIN.colButtonBorder			 =  Color(40, 40, 40, 255)
SKIN.colButtonBorderHighlight	 =  Color(60, 60, 60, 255)
SKIN.colButtonBorderShadow		 =  Color(0, 0, 0, 0)
SKIN.fontButton					 =  "Default"
SKIN.GwenTexture	= Material( "gwenskin/GModDefault.png" )

local iNewHUD = surface.GetTextureID("agrp/style01_t/background")
local iTexGradient = surface.GetTextureID("gui/gradient_up")

local surface = surface
local draw = draw
local math = math

//

/*--------------------------------------------------------- 
   DrawGenericBackground
--------------------------------------------------------- */
function SKIN:DrawGenericBackground(x, y, w, h, color)

	draw.RoundedBox(4, x, y, w, h, color)

end

/*--------------------------------------------------------- 
   DrawButtonBorder
--------------------------------------------------------- */
function SKIN:DrawButtonBorder(x, y, w, h, depressed)

	if(!depressed) then
	
		//Highlight
		surface.SetDrawColor(self.colButtonBorderHighlight)
		surface.DrawRect(x + 1, y + 1, w - 2, 1)
		surface.DrawRect(x + 1, y + 1, 1, h - 2)
		
		//Corner
		surface.DrawRect(x + 2, y + 2, 1, 1)
	
		//Shadow
		surface.SetDrawColor(self.colButtonBorderShadow)
		surface.DrawRect(w - 2, y + 2, 1, h - 2)
		surface.DrawRect(x + 2, h - 2, w - 2, 1)
		
	else
	
		local col = self.colButtonBorderShadow
	
		for i = 1, 5 do
		
			surface.SetDrawColor(col.r, col.g, col.b, (255 - i * (255/5)))
			surface.DrawOutlinedRect(i, i, w - i, h - i)
		
		end
		
	end	

	surface.SetDrawColor(self.colButtonBorder)
	surface.DrawOutlinedRect(x, y, w, h)

end

/*--------------------------------------------------------- 
   DrawDisabledButtonBorder
--------------------------------------------------------- */
function SKIN:DrawDisabledButtonBorder(x, y, w, h, depressed)

	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawOutlinedRect(x, y, w, h)
	
end


/*--------------------------------------------------------- 
	Frame
--------------------------------------------------------- */
function SKIN:PaintFrame(panel, w, h)	
	draw.RoundedBox(8, 0, 0, panel:GetWide(), panel:GetTall(), Color(5, 5, 5, 180))
	surface.SetTexture(iNewHUD)
	surface.SetDrawColor(Color(240, 240, 240, 255))
	surface.DrawTexturedRectUV(2, 2, panel:GetWide() - 4, panel:GetTall() - 4, 2, 2, 2, 2)
	
	surface.SetTexture(iTexGradient)
	surface.SetDrawColor(0, 0, 0, 220)
	surface.DrawTexturedRect(0, -panel:GetTall() * 0.3, panel:GetWide(), panel:GetTall() * 1.3, 90)
end

function SKIN:LayoutFrame(panel)

	panel.lblTitle:SetFont(self.fontFrame)
	
	panel.btnClose:SetPos(panel:GetWide() - 22, 4)
	panel.btnClose:SetSize(18, 18)
	
	panel.lblTitle:SetPos(8, 2)
	panel.lblTitle:SetSize(panel:GetWide() - 25, 20)

end


/*--------------------------------------------------------- 
	Button
--------------------------------------------------------- */
function SKIN:PaintButton(panel, w, h)

	local w, h = panel:GetSize()

	if(panel.m_bBackground) then
	
		local col = self.control_color
		
		if(panel:GetDisabled()) then
			col = self.control_color_dark
		elseif(panel.Depressed) then
			col = self.control_color_active
		elseif(panel.Hovered) then
			col = self.control_color_highlight
		end
		
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
		panel:DrawFilledRect()
	
	end

end
function SKIN:PaintOverButton(panel)

	local w, h = panel:GetSize()
	
	if(panel.m_bBorder) then
		if(panel:GetDisabled()) then
			self:DrawDisabledButtonBorder(0, 0, w, h)
		else
			self:DrawButtonBorder(0, 0, w, h, panel.Depressed)
		end
	end

end


function SKIN:SchemeButton(panel)

	panel:SetFont(self.fontButton)
	
	if(panel:GetDisabled()) then
		panel:SetTextColor(self.colButtonTextDisabled)
	else
		panel:SetTextColor(self.colButtonText)
	end
	
	DLabel.ApplySchemeSettings(panel)

end

/*--------------------------------------------------------- 
	SysButton
--------------------------------------------------------- */
function SKIN:PaintPanel(panel, w, h)

	if(panel.m_bPaintBackground) then
	
		local w, h = panel:GetSize()
		self:DrawGenericBackground(0, 0, w, h, self.panel_transback)
		
	end	

end

/*--------------------------------------------------------- 
	SysButton
--------------------------------------------------------- */
function SKIN:PaintSysButton(panel, w, h)

	self:PaintButton(panel)
	self:PaintOverButton(panel) //Border

end

function SKIN:SchemeSysButton(panel)

	panel:SetFont("Marlett")
	DLabel.ApplySchemeSettings(panel)
	
end


/*--------------------------------------------------------- 
	ImageButton
--------------------------------------------------------- */
function SKIN:PaintImageButton(panel, w, h)

	self:PaintButton(panel)

end

/*--------------------------------------------------------- 
	ImageButton
--------------------------------------------------------- */
function SKIN:PaintOverImageButton(panel, w, h)

	self:PaintOverButton(panel)

end
function SKIN:LayoutImageButton(panel)

	if(panel.m_bBorder) then
		panel.m_Image:SetPos(1, 1)
		panel.m_Image:SetSize(panel:GetWide() - 2, panel:GetTall() - 2)
	else
		panel.m_Image:SetPos(0, 0)
		panel.m_Image:SetSize(panel:GetWide(), panel:GetTall())
	end

end

/*--------------------------------------------------------- 
	PanelList
--------------------------------------------------------- */
function SKIN:PaintPanelList(panel, w, h)
	local color = self.bg_color_dark
	if(panel.m_bBackground) then
		draw.RoundedBox(4, 0, 0, panel:GetWide(), panel:GetTall(), SKIN.CustomColor1)
	end

end

/*--------------------------------------------------------- 
	ScrollBar
--------------------------------------------------------- */
function SKIN:PaintVScrollBar(panel, w, h)
	local color = self.bg_color
	surface.SetDrawColor(Color(100, 100, 100, 255))
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

end
function SKIN:LayoutVScrollBar(panel)

	local Wide = panel:GetWide()
	local Scroll = panel:GetScroll() / panel.CanvasSize
	local BarSize = panel:BarScale() * (panel:GetTall() - (Wide * 2))
	local Track = panel:GetTall() - (Wide * 2) - BarSize
	Track = Track + 1
	
	Scroll = Scroll * Track
	
	panel.btnGrip:SetPos(0, Wide + Scroll)
	panel.btnGrip:SetSize(Wide, BarSize)
	
	panel.btnUp:SetPos(0, 0, Wide, Wide)
	panel.btnUp:SetSize(Wide, Wide)
	
	panel.btnDown:SetPos(0, panel:GetTall() - Wide, Wide, Wide)
	panel.btnDown:SetSize(Wide, Wide)

end

/*--------------------------------------------------------- 
	ScrollBarGrip
--------------------------------------------------------- */
function SKIN:PaintScrollBarGrip(panel, w, h)

	surface.SetDrawColor(self.control_color.r, self.control_color.g, self.control_color.b, self.control_color.a)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

	self:DrawButtonBorder(0, 0, panel:GetWide(), panel:GetTall())

end


/*--------------------------------------------------------- 
	ScrollBar
--------------------------------------------------------- */
function SKIN:PaintMenu(panel, w, h)

	surface.SetDrawColor(self.colMenuBG)
	panel:DrawFilledRect(0, 0, w, h)

end
function SKIN:PaintOverMenu(panel, w, h)

	surface.SetDrawColor(self.colMenuBorder)
	panel:DrawOutlinedRect(0, 0, w, h)

end
function SKIN:LayoutMenu(panel)

end

/*--------------------------------------------------------- 
	ScrollBar
--------------------------------------------------------- */
function SKIN:PaintMenuOption(panel, w, h)

	if(panel.m_bBackground and panel.Hovered) then
	
		local col = nil
		
		if(panel.Depressed) then
			col = self.control_color_bright
		else
			col = self.control_color_active
		end
		
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	
	end
	
end
function SKIN:LayoutMenuOption(panel, w, h)

	//This is totally messy. :/

	panel:SizeToContents()

	panel:SetWide(panel:GetWide() + 30)
	
	local w = math.max(panel:GetParent():GetWide(), panel:GetWide())

	panel:SetSize(w, 18)
	
	if(panel.SubMenuArrow) then
	
		panel.SubMenuArrow:SetSize(panel:GetTall(), panel:GetTall())
		panel.SubMenuArrow:CenterVertical()
		panel.SubMenuArrow:AlignRight()
		
	end
	
end
function SKIN:SchemeMenuOption(panel)

	panel:SetFGColor(40, 40, 40, 255)
	
end

/*--------------------------------------------------------- 
	TextEntry
--------------------------------------------------------- */
function SKIN:PaintTextEntry(panel, w, h)

	if(panel.m_bBackground) then
	
		surface.SetDrawColor(self.colTextEntryBG)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	
	end
	
	panel:DrawTextEntryText(panel.m_colText, panel.m_colHighlight, panel.m_colCursor)
	
	if(panel.m_bBorder) then
	
		surface.SetDrawColor(self.colTextEntryBorder)
		surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())
	
	end

	
end
function SKIN:SchemeTextEntry(panel)

	panel:SetTextColor(self.colTextEntryText)
	panel:SetHighlightColor(self.colTextEntryTextHighlight)
	panel:SetCursorColor(Color(0, 0, 100, 255))

end

/*--------------------------------------------------------- 
	Label
--------------------------------------------------------- */
function SKIN:PaintLabel(panel, w, h)
	return false
end

function SKIN:SchemeLabel(panel)

	local col = nil

	if(panel.Hovered and panel:GetTextColorHovered()) then
		col = panel:GetTextColorHovered()
	else
		col = panel:GetTextColor()
	end
	
	if(col) then
		panel:SetFGColor(col.r, col.g, col.b, col.a)
	else
		panel:SetFGColor(200, 200, 200, 255)
	end

end

function SKIN:LayoutLabel(panel)

	panel:ApplySchemeSettings()
	
	if(panel.m_bAutoStretchVertical) then
		panel:SizeToContentsY()
	end
	
end

/*--------------------------------------------------------- 
	CategoryHeader
--------------------------------------------------------- */
function SKIN:PaintCategoryHeader(panel, w, h)
		
end

function SKIN:SchemeCategoryHeader(panel)
	
	panel:SetTextInset(5)
	panel:SetFont(self.fontCategoryHeader)
	
	if(panel:GetParent():GetExpanded()) then
		panel:SetTextColor(self.colCategoryText)
	else
		panel:SetTextColor(self.colCategoryTextInactive)
	end
	
end

/*--------------------------------------------------------- 
	CategoryHeader
--------------------------------------------------------- */
function SKIN:PaintCollapsibleCategory(panel, w, h)
	
	draw.RoundedBox(4, 0, 0, panel:GetWide(), panel:GetTall(), self.colCollapsibleCategory)
	
end

/*--------------------------------------------------------- 
	Tab
--------------------------------------------------------- */
function SKIN:PaintTab(panel, w, h)

	//This adds a little shadow to the right which helps define the tab shape .. 
	draw.RoundedBox(4, 0, 0, panel:GetWide(), panel:GetTall() + 8, self.colTabShadow)
	
	if(panel:GetPropertySheet():GetActiveTab() == panel) then
		draw.RoundedBox(4, 1, 0, panel:GetWide() - 2, panel:GetTall() + 8, self.colTab)
	else
		draw.RoundedBox(4, 0, 0, panel:GetWide() - 1, panel:GetTall() + 8, self.colTabInactive)
	end
	
end
function SKIN:SchemeTab(panel)

	panel:SetFont(self.fontTab)

	local ExtraInset = 10

	if(panel.Image) then
		ExtraInset = ExtraInset + panel.Image:GetWide()
	end
	
	panel:SetTextInset(ExtraInset)
	panel:SizeToContents()
	panel:SetSize(panel:GetWide() + 10, panel:GetTall() + 8)
	
	local Active = panel:GetPropertySheet():GetActiveTab() == panel
	
	if(Active) then
		panel:SetTextColor(self.colTabText)
	else
		panel:SetTextColor(self.colTabTextInactive)
	end
	
	panel.BaseClass.ApplySchemeSettings(panel)
		
end

function SKIN:LayoutTab(panel)

	panel:SetTall(22)

	if(panel.Image) then
	
		local Active = panel:GetPropertySheet():GetActiveTab() == panel
		
		local Diff = panel:GetTall() - panel.Image:GetTall()
		panel.Image:SetPos(7, Diff * 0.6)
		
		if(!Active) then
			panel.Image:SetImageColor(Color(170, 170, 170, 155))
		else
			panel.Image:SetImageColor(Color(255, 255, 255, 255))
		end
	
	end	
	
end



/*--------------------------------------------------------- 
	PropertySheet
--------------------------------------------------------- */
function SKIN:PaintPropertySheet(panel, w, h)

	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if(ActiveTab) then Offset = ActiveTab:GetTall() end
	
	//This adds a little shadow to the right which helps define the tab shape .. 
	draw.RoundedBox(4, 0, Offset, panel:GetWide(), panel:GetTall() - Offset, self.colPropertySheet)
	
end


/*--------------------------------------------------------- 
	ListViewLine
--------------------------------------------------------- */
function SKIN:PaintListViewLine(panel, w, h)

	local Col = nil
	
	if(panel:IsSelected()) then
	
		Col = self.listview_selected
		
	elseif(panel.Hovered) then
	
		Col = self.listview_hover
		
	elseif(panel.m_bAlt) then
	
		Col = self.bg_alt2
		
	else
	
		return
				
	end
		
	surface.SetDrawColor(Col.r, Col.g, Col.b, Col.a)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	
end

/*--------------------------------------------------------- 
	Form
--------------------------------------------------------- */
function SKIN:PaintForm(panel, w, h)

	local color = self.bg_color_sleep
	self:DrawGenericBackground(0, 9, panel:GetWide(), panel:GetTall() - 9, SKIN.CustomColor1)

end
function SKIN:SchemeForm(panel)

	panel.Label:SetFont("TabLarge")
	panel.Label:SetTextColor(Color(255, 255, 255, 255))

end
function SKIN:LayoutForm(panel)

end


/*--------------------------------------------------------- 
	MultiChoice
--------------------------------------------------------- */
function SKIN:LayoutMultiChoice(panel)

	panel.TextEntry:SetSize(panel:GetWide(), panel:GetTall())
	
	panel.DropButton:SetSize(panel:GetTall(), panel:GetTall())
	panel.DropButton:SetPos(panel:GetWide() - panel:GetTall(), 0)
	
	panel.DropButton:SetZPos(1)
	panel.DropButton:SetDrawBackground(false)
	panel.DropButton:SetDrawBorder(false)
	
	panel.DropButton:SetTextColor(Color(30, 100, 200, 255))
	panel.DropButton:SetTextColorHovered(Color(50, 150, 255, 255))
	
end


/*
NumberWangIndicator
*/

function SKIN:DrawNumberWangIndicatorText(panel, wang, x, y, number, alpha)

	local alpha = math.Clamp(alpha ^ 0.5, 0, 1) * 255
	local col = self.text_dark
	
	//Highlight round numbers
	local dec = (wang:GetDecimals() + 1) * 10
	if(number / dec == math.ceil(number / dec)) then
		col = self.text_highlight
	end

	draw.SimpleText(number, "Default", x, y, Color(col.r, col.g, col.b, alpha))
	
end



function SKIN:PaintNumberWangIndicator(panel, w, h)
	
	/*
	
		Please excuse the crudeness of this code.
	
	*/

	if(panel.m_bTop) then
		surface.SetMaterial(self.texGradientUp)
	else
		surface.SetMaterial(self.texGradientDown)
	end
	
	surface.SetDrawColor(self.colNumberWangBG)
	surface.DrawTexturedRect(0, 0, panel:GetWide(), panel:GetTall())
	
	local wang = panel:GetWang()
	local CurNum = math.floor(wang:GetFloatValue())
	local Diff = CurNum - wang:GetFloatValue()
		
	local InsetX = 3
	local InsetY = 5
	local Increment = wang:GetTall()
	local Offset = Diff * Increment
	local EndPoint = panel:GetTall()
	local Num = CurNum
	local NumInc = 1
	
	if(panel.m_bTop) then
	
		local Min = wang:GetMin()
		local Start = panel:GetTall() + Offset
		local End = Increment * - 1
		
		CurNum = CurNum + NumInc
		for y = Start, Increment * - 1, End do
	
			CurNum = CurNum - NumInc
			if(CurNum < Min) then break end
					
			self:DrawNumberWangIndicatorText(panel, wang, InsetX, y + InsetY, CurNum, y / panel:GetTall())
		
		end
	
	else
	
		local Max = wang:GetMax()
		
		for y = Offset - Increment, panel:GetTall(), Increment do
			
			self:DrawNumberWangIndicatorText(panel, wang, InsetX, y + InsetY, CurNum, 1 - ((y + Increment) / panel:GetTall()))
			
			CurNum = CurNum + NumInc
			if(CurNum > Max) then break end
		
		end
	
	end
	

end

function SKIN:LayoutNumberWangIndicator(panel)

	panel.Height = 200

	local wang = panel:GetWang()
	local x, y = wang:LocalToScreen(0, wang:GetTall())
	
	if(panel.m_bTop) then
		y = y - panel.Height - wang:GetTall()
	end
	
	panel:SetPos(x, y)
	panel:SetSize(wang:GetWide() - wang.Wanger:GetWide(), panel.Height)

end

/*--------------------------------------------------------- 
	CheckBox
--------------------------------------------------------- */
function SKIN:PaintCheckBox(panel, w, h)

	if ( panel:GetChecked() ) then
	
		if ( panel:GetDisabled() ) then
			self.tex.CheckboxD_Checked( 0, 0, w, h )
		else
			self.tex.Checkbox_Checked( 0, 0, w, h )
		end
		
	else
	
		if ( panel:GetDisabled() ) then
			self.tex.CheckboxD( 0, 0, w, h )
		else
			self.tex.Checkbox( 0, 0, w, h )
		end
		
	end	

end

function SKIN:SchemeCheckBox(panel)

	panel:SetTextColor(Color(0, 0, 0, 255))
	
end



/*--------------------------------------------------------- 
	Slider
--------------------------------------------------------- */
function SKIN:PaintSlider(panel, w, h)

end


/*--------------------------------------------------------- 
	NumSlider
--------------------------------------------------------- */
function SKIN:PaintNumSlider(panel, w, h)

	local w, h = panel:GetSize()
	
	self:DrawGenericBackground(0, 0, w, h, Color(255, 255, 255, 20))
	
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(3, h/2, w - 6, 1)
	
end


/*--------------------------------------------------------- 
	NumSlider
--------------------------------------------------------- */
function SKIN:PaintComboBoxItem(panel, w, h)

	if(panel.Depressed) then
		local col = self.combobox_selected
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
		panel:DrawFilledRect()
	end

end

function SKIN:SchemeComboBoxItem(panel)
	panel:SetTextColor(Color(0, 0, 0, 255))
end

/*--------------------------------------------------------- 
	ComboBox
--------------------------------------------------------- */
function SKIN:PaintComboBox(panel, w, h)
	
	surface.SetDrawColor(255, 255, 255, 255)
	panel:DrawFilledRect()
		
	surface.SetDrawColor(0, 0, 0, 255)
	panel:DrawOutlinedRect()
	
end

/*--------------------------------------------------------- 
	ScrollBar
--------------------------------------------------------- */
function SKIN:PaintBevel(panel, w, h)

	local w, h = panel:GetSize()

	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawOutlinedRect(0, 0, w - 1, h - 1)
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawOutlinedRect(1, 1, w - 1, h - 1)

end


/*--------------------------------------------------------- 
	Tree
--------------------------------------------------------- */
function SKIN:PaintTree(panel, w, h)
	local color = self.bg_color_bright
	if(panel.m_bBackground) then
		surface.SetDrawColor(SKIN.CustomColor1)
		panel:DrawFilledRect()
	end

end



/*--------------------------------------------------------- 
	TinyButton
--------------------------------------------------------- */
function SKIN:PaintTinyButton(panel, w, h)

	if(panel.m_bBackground) then
	
		surface.SetDrawColor(255, 255, 255, 255)
		panel:DrawFilledRect()
	
	end
	
	if(panel.m_bBorder) then

		surface.SetDrawColor(0, 0, 0, 255)
		panel:DrawOutlinedRect()
	
	end

end

function SKIN:SchemeTinyButton(panel)

	panel:SetFont("Default")
	
	if(panel:GetDisabled()) then
		panel:SetTextColor(Color(0, 0, 0, 50))
	else
		panel:SetTextColor(Color(0, 0, 0, 255))
	end
	
	DLabel.ApplySchemeSettings(panel)
	
	panel:SetFont("DefaultSmall")

end

/*--------------------------------------------------------- 
	TinyButton
--------------------------------------------------------- */
function SKIN:PaintTreeNodeButton(panel, w, h)

	if(panel.m_bSelected) then

		surface.SetDrawColor(50, 200, 255, 150)
		panel:DrawFilledRect()
	
	elseif(panel.Hovered) then

		surface.SetDrawColor(255, 255, 255, 100)
		panel:DrawFilledRect()
	
	end
	
	

end

function SKIN:SchemeTreeNodeButton(panel)

	DLabel.ApplySchemeSettings(panel)

end

/*--------------------------------------------------------- 
	Tooltip
--------------------------------------------------------- */
function SKIN:PaintTooltip(panel, w, h)

	local w, h = panel:GetSize()
	
	DisableClipping(true)
	
	//This isn't great, but it's not like we're drawing 1000's of tooltips all the time
	for i = 1, 4 do
	
		local BorderSize = i*2
		local BGColor = Color(0, 0, 0, (255 / i) * 0.3)
		
		self:DrawGenericBackground(BorderSize, BorderSize, w, h, BGColor)
		panel:DrawArrow(BorderSize, BorderSize)
		self:DrawGenericBackground(-BorderSize, BorderSize, w, h, BGColor)
		panel:DrawArrow(-BorderSize, BorderSize)
		self:DrawGenericBackground(BorderSize, -BorderSize, w, h, BGColor)
		panel:DrawArrow(BorderSize, -BorderSize)
		self:DrawGenericBackground(-BorderSize, -BorderSize, w, h, BGColor)
		panel:DrawArrow(-BorderSize, -BorderSize)
		
	end


	self:DrawGenericBackground(0, 0, w, h, self.tooltip)
	panel:DrawArrow(0, 0)

	DisableClipping(false)
end
derma.DefineSkin("perpx", "Skin for *gaming PERPX", SKIN)



function cutLength ( str, pW, font )
	surface.SetFont(font)
	
	local sW = pW - 40
	
	for i = 1, string.len(str) do
		local sStr = string.sub(str, 1, i)
		local w, h = surface.GetTextSize(sStr)
		
		if(w > pW or (w > sW and string.sub(str, i, i) == " ")) then
			local cutRet = cutLength(string.sub(str, i + 1), pW, font)
			
			local returnTable = {sStr}
			
			for k, v in pairs(cutRet) do
				returnTable[#returnTable+1] = v
			end
			
			return returnTable
		end
	end
	
	return {str}
end

SKIN.fontLabel 					= "DefaultSmall"
SKIN.fontLargeLabel 			= "DefaultLarge"

derma.RefreshSkins()
PERPX_SKIN = SKIN
PERPX_SKIN.fontLabel = "Default"
PERPX_SKIN.fontLargeLabel = "DefaultLarge"