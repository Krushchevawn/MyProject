
local function HasLos( ent )
    local td = {} 
    td.start = LocalPlayer():GetShootPos()
    td.endpos = ent:GetPos()
    td.mask = 1174421507
    td.filter = { LocalPlayer(), ent }
    
    local trace = util.TraceLine( td )
    if( trace.Fraction == 1 ) then
    return true
    end
    return false
end

hook.Add("HUDPaint", "WeedTimers", function()
    local plants = {}
    for k, ent in pairs( ents.FindByClass("ent_pot") ) do
        table.insert( plants, ent )
    end
    for k, ent in pairs( ents.FindByClass("ent_coca") ) do
        table.insert( plants, ent )
    end
    for k, v in pairs(plants) do
        if(IsValid(v)) then
            if(v:GetPos():Distance(LocalPlayer():GetPos()) < 250) then
                if(HasLos(v) and v.dt.SpawnTime and v:GetTable().GrowthTime) then
                    local percent = math.Clamp((CurTime() - v.dt.SpawnTime) / v:GetTable().GrowthTime, 0, 1)
                    local drawpos = (v:GetPos() + Vector(0,0,15)):ToScreen()
                    draw.RoundedBox( 4, drawpos.x - 52, drawpos.y-6, 104, 22, Color( 175, 175, 175 ) )
                    draw.RoundedBox( 4, drawpos.x - 50, drawpos.y - 3, math.Round(percent * 100), 16, Color( 0, 150, 50 ) )
                    draw.SimpleText( math.Round(percent * 100) .. "%", "ScoreboardPlayerName", drawpos.x, drawpos.y + 6, Color( 255, 255, 255 ), 1, 1 )
                end
            end
        end
    end
end )
