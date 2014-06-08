local ply = nil
 
local t = {start=nil,endpos=nil,mask=MASK_PLAYERSOLID,filter=nil}
local function PlayerNotStuck()
 
    t.start = ply:GetPos()
    t.endpos = t.start
    t.filter = ply
     
    return util.TraceEntity(t,ply).StartSolid == false
     
end
 
local NewPos = nil
local function FindPassableSpace( direction, step )
 
    local i = 0
    while ( i < 100 ) do
        local origin = ply:GetPos()
 
        origin = origin + step * direction
         
        ply:SetPos( origin )
        if ( PlayerNotStuck( ply ) ) then
            NewPos = ply:GetPos()
            return true
        end
        i = i + 1
    end
    return false
end
 
local function UnstuckPlayer( pl )
	if(!pl or pl:InVehicle()) then return false end
    ply = pl
 
    NewPos = ply:GetPos()
    local OldPos = NewPos
     
    if ( !PlayerNotStuck( ply ) ) then
     
        local angle = ply:GetAngles()
         
        local forward = angle:Forward()
        local right = angle:Right()
        local up = angle:Up()
         
        local SearchScale = 1-- Increase and it will unstuck you from even harder places but with lost accuracy. Please, don't try higher values than 12
        if ( !FindPassableSpace(  forward, SearchScale ) )
        then
            if ( !FindPassableSpace(  right, SearchScale ) )
            then
                if ( !FindPassableSpace(  right, -SearchScale ) ) 
                then
                    if ( !FindPassableSpace(  up, SearchScale ) )
                    then
                        if ( !FindPassableSpace(  up, -SearchScale ) )
                        then
                            if ( !FindPassableSpace(  forward, -SearchScale ) )
                            then
                                return false
                                 
                            end
                        end
                    end
                end
            end
        end
         
        if OldPos == NewPos then
            return true -- Not stuck?
        else
            ply:SetPos( NewPos )
            if SERVER and ply and ply:IsValid() and ply:GetPhysicsObject():IsValid() then
                if ply:IsPlayer() then
                    ply:SetVelocity(vector_origin)
                end
                ply:GetPhysicsObject():SetVelocity(vector_origin)
            end
         
            return true
        end
      
    end
     
end
 
local meta= FindMetaTable"Player"

function meta:GetUnStuck()
    return UnstuckPlayer(self)
end

