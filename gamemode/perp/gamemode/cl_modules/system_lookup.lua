concommand.Add( "perp_lookup", function( ply, cmd, args )

    if not LocalPlayer():IsAdmin() then return end
  
    local find = string.lower( tostring( args[1] ) )
    
    print( "Looking up: " .. find )
    
    for k,v in pairs( player.GetAll() ) do
    
        if string.find( string.lower( v:Nick() ), find ) or string.find( string.lower( v:GetRPName() ), find ) then

            print( "Steam Name: " .. v:Nick() )
            print( "RP Name: " .. v:GetRPName() )
            print( "SteamID: " .. v:SteamID() )
            print( "Job: " .. team.GetName( v:Team() ) )
            print( "--------------\n" )
        
        end
        
    end

end )