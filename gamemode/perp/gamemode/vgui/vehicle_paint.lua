function GM.ShowPaintView (ID)
	if(!VEHICLE_DATABASE[ID]) then return end
	local curcar = VEHICLE_DATABASE[ID]
	local curcol

	local DynCarWindow = vgui.Create( "DFrame" )
	DynCarWindow:SetSize( ScrW(), ScrH() )
	DynCarWindow:Center()
	DynCarWindow:SetTitle( "" )
	DynCarWindow:MakePopup()
	DynCarWindow:SetDraggable(false)
	DynCarWindow.Paint = function()
	    draw.RoundedBox(0, 0, 0, DynCarWindow:GetWide(), DynCarWindow:GetTall(), Color(20, 20, 20, 255))
	end

	local Car = vgui.Create( "DModelPanel", DynCarWindow )
	Car:SetSize( DynCarWindow:GetWide() - 200, DynCarWindow:GetTall() - 80)
	Car:SetPos(ScrW()/2 - Car:GetWide()/2, ScrH()/2 - Car:GetTall()/2)
	Car:SetCamPos( Vector(200, 100, 50) )
	//Car:SetLookAt( Vector(0, 10, 0) )
	//Car.Paint = function()
	   //draw.RoundedBox(0, 0, 0, Car:GetWide(), Car:GetTall(), Color(0, 200, 200))
	//end

	local Title = Label("")
	Title:SetParent(DynCarWindow)
	Title:SetFont("RealtorFont")
	Title:SetColor(Color(255, 255, 255))
	Title:SetPos(DynCarWindow:GetWide()/2, 20)

	local PaintList = vgui.Create("DPanelList", DynCarWindow)
	PaintList:EnableHorizontal(true)
	PaintList:EnableVerticalScrollbar(false)
	PaintList:SetPadding(5)
	PaintList:SetSpacing(8)
	PaintList:SetPos(10, 60)
	PaintList:SetSize( 200, 250 )

	local MyBank = Label("")
	MyBank:SetParent(DynCarWindow)
	MyBank:SetFont("RealtorFont")
	MyBank:SetColor(Color(255, 255, 255))
	MyBank:SetPos(ScrW() - 200, DynCarWindow:GetTall() - 60)

	local Purchase = vgui.Create("DButton", DynCarWindow)
	Purchase:SetSize(150, 50)
	Purchase:SetFont("Default")
	Purchase:SetPos(ScrW() - 200, ScrH() - 80)
	Purchase:SetText("Paint it!")

	local function DealerCommaValue( amount )
		local formatted = amount
		while true do  
			formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )
			if ( k==0 ) then
				break
			end
		end
		return formatted
	end

	DynCarWindow.UpdateInfo = function()
		local curcol = 1

		Car:SetColor(Color(255, 255, 255, 255))

		Car:SetModel( curcar.PaintJobs[1].model )

		Title:SetText(curcar.Name)
		MyBank:SetText("Cost: $" .. DealerCommaValue(curcar.PaintJobCost))

		Title:SizeToContents()
		MyBank:SizeToContents()

		Title:CenterHorizontal()
		MyBank:CenterHorizontal()

		Purchase:SetDisabled(false)

		PaintList:Clear()
		for k,v in pairs(curcar.PaintJobs) do
			local pbutton = vgui.Create("DButton")
			local size = 25
			pbutton:SetText("")
			pbutton:SetSize(size,size)
			pbutton:SetTooltip(v.name)
			pbutton.Paint = function()
				draw.RoundedBox(0, 0, 0, size, size, v.color)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawOutlinedRect(0, 0, size, size)
			end
			pbutton.DoClick = function()
				if(Car:GetEntity():GetModel() != v.model) then
					Car:SetModel(v.model)
				end
				if(curcar.DynamicPaint) then
					Car:SetColor(v.color)
				else
					Car:GetEntity():SetSkin(v.skin)
				end
				curcol = k
			end
			PaintList:AddItem(pbutton)
		end
		PaintList:CenterHorizontal()


		function Purchase.DoClick()
			if LocalPlayer():GetCash() >= curcar.PaintJobCost then
				LocalPlayer():TakeCash(curcar.PaintJobCost, true)
				RunConsoleCommand("perp_v_s", curcol)
				
				//GAMEMODE.Vehicles[curcar.ID][1] = tonumber(curcol)
				DynCarWindow:Remove()
			end
		end
	end
	DynCarWindow:UpdateInfo()
end