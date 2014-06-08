--Fix Elevator bugging
--Ice Tea
 
local inbutton = {}
local outbutton = {}
 
 
hook.Add( "PlayerUse", "PreventNexusElevatorBreaking", function( ply, ent )
        if(string.find(ent:GetClass(), "door") and !(ent:GetClass()=="item_doorbuster")) then     
                if(ent.NextDoorUse and ent.NextDoorUse > CurTime()) then
                        return false
                end
                ent.NextDoorUse = CurTime() + 2
        elseif(ent:GetClass() == "func_button") then
                for k,v in pairs( inbutton ) do
                        if v == ent then
                                if v:GetPos():Distance( outbutton[k]:GetPos() ) < 100 then
                                        return false
                                end
                                break
                        end
                end
               
                for k,v in pairs( outbutton ) do
                        if v == ent then
                                if v:GetPos():Distance( inbutton[k]:GetPos() ) < 100 then
                                        return false
                                end
                                break
                        end
                end
        end
end )
 
hook.Add( "InitPostEntity", "FindNexusEleButtons", function()
       
        timer.Simple( 10, function()
        for k,v in pairs( ents.FindByClass( "func_button" ) ) do
 
                if v and v:IsValid() then
               
                        if v:GetPos() == Vector( -7418.0000, -9516.9902, 122.0000 ) then
                                inbutton[1] = v
                        elseif v:GetPos() == Vector( -7418.0000, -9516.9902, 127.0000 ) then
                                inbutton[2] = v
                        elseif v:GetPos() == Vector( -7418.0000, -9516.9902, 131.0000 ) then
                                inbutton[3] = v
                        elseif v:GetPos() == Vector( -7418.0000, -9516.9902, 135.0000 ) then
                                inbutton[4] = v
                        elseif v:GetPos() == Vector( -7441.6099, -9493.2695, 136.3700 ) then
                                outbutton[1] = v
                        elseif v:GetPos() == Vector( -7441.6099, -9492.7197, 529.8800 ) then
                                outbutton[2] = v
                        elseif v:GetPos() == Vector( -7441.6201, -9492.4902, 1808.1801 ) then
                                outbutton[3] = v
                        elseif v:GetPos() == Vector( -7441.6201, -9491.6201, 3854.9600 ) then
                                outbutton[4] = v
                        end
               
                end
       
        end
        end )
 
end )