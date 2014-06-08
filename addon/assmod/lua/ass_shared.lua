--If you don't understand that people are assigned these specific numbers as a rank and changing them won't change them automagicly, don't touch them.
--Feel free to jam whatever ranks, varibles or whatever. This is meant for someone with an understanding of lua to be able to easly add ranks and with the pretenses that many things are staticly scripted and the permissions for those things could be open to abuse.
--However, as long as you adjust ASS_LVL_TEMPADMIN as the base admin level and keep ASS_LVL_SERVER_OWNER as the highest rank you should be okay.

ASS_LVL_SERVER_OWNER	= 0
ASS_LVL_DVL				= 1
//ASS_LVL_LEAD_ADMIN		= 2
ASS_LVL_SUPER_ADMIN		= 3
ASS_LVL_ADMIN			= 4
ASS_LVL_TEMPADMIN		= 5
ASS_LVL_MOD				= 6
ASS_LVL_GOLD			= 7
ASS_LVL_RESPECTED		= 8
ASS_LVL_GUEST			= 10
ASS_LVL_BANNED			= 255

ASS_RANKS = {0, 1, 3, 4, 5, 6, 7, 8, 10, 255}

ASS_RANKNAMES = {}
ASS_RANKNAMES[0] = "Server Owner"
ASS_RANKNAMES[1] = "Developer"
ASS_RANKNAMES[3] = "Super Admin"
ASS_RANKNAMES[4] = "Admin"
ASS_RANKNAMES[5] = "Temp Admin"
ASS_RANKNAMES[6] = "Moderator"
ASS_RANKNAMES[7] = "Gold Member"
ASS_RANKNAMES[8] = "VIP"
ASS_RANKNAMES[10] = "Guest"
ASS_RANKNAMES[255] = "Banned"

LevelIcon = {}
LevelIcon[0] = "icon16/lightning.png"
LevelIcon[1] = "icon16/user_edit.png"
LevelIcon[3] = "icon16/shield.png"
LevelIcon[4] = "icon16/asterisk_yellow.png"
LevelIcon[5] = "icon16/award_star_gold_3.png"
LevelIcon[6] = "icon16/user_orange.png"
LevelIcon[7] = "icon16/star.png"
LevelIcon[8] = "icon16/user_add.png"
LevelIcon[10] = "icon16/user_gray.png"
LevelIcon[255] = "icon16/user_delete.png"

ASS_VERSION = "Assmod 2.30"

function ASS_Init_Shared()

	local PLAYER = FindMetaTable("Player")
	function PLAYER:IsOwner()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_SERVER_OWNER	or (SERVER and !self:IsValid()) end
	function PLAYER:IsDVL()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_DVL	end
	function PLAYER:IsSuperAdmin()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_SUPER_ADMIN	end
	function PLAYER:IsAdmin()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_ADMIN		end
	function PLAYER:IsTempAdmin()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_TEMPADMIN	end

	function PLAYER:IsModerator()		return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_MOD	end
	function PLAYER:IsOperator()		return self:IsModerator()	end
	
	function PLAYER:IsGoldMember()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_GOLD	end
	function PLAYER:IsRespected()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_RESPECTED	end
	function PLAYER:IsVIP()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= ASS_LVL_RESPECTED	end

	function PLAYER:IsGuest()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) >= ASS_LVL_GUEST && self:GetSharedInt("ASS_isAdmin", 5) < ASS_LVL_BANNED end
	function PLAYER:IsUnwanted()	return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) >= ASS_LVL_BANNED end

	function PLAYER:GetLevel()		return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST)						end
	function PLAYER:HasLevel(n)		return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= n						end

	function PLAYER:IsBetterOrSame(PL2)
		if(!PL2:IsValid()) then return false end
		return self:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST) <= PL2:GetSharedInt("ASS_isAdmin", ASS_LVL_GUEST)	
	end
	function PLAYER:GetTAExpiry(n)		return self:GetSharedFloat("ASS_tempAdminExpiry")	end
	function PLAYER:AssId()		return self:GetSharedString("ASS_AssID")	end
	PLAYER = nil

end

function IncludeSharedFile( S )
	
	if (SERVER) then
		AddCSLuaFile(S)
	end
	
	include(S)

end

function LevelToString( LEVEL, TIME )

	if (LEVEL <= ASS_LVL_SERVER_OWNER) then					return "Owner";
	elseif (LEVEL <= ASS_LVL_DVL) then						return "Co-Owner";
	//elseif (LEVEL <= ASS_LVL_LEAD_ADMIN) then				return "Lead Admin";
	elseif (LEVEL <= ASS_LVL_SUPER_ADMIN) then				return "Super Admin";
	elseif (LEVEL <= ASS_LVL_ADMIN) then					return "Admin";
	elseif (LEVEL <= ASS_LVL_TEMPADMIN) then				if (TIME) then return "Admin for " .. TIME else return "Temp Admin" end
	elseif (LEVEL <= ASS_LVL_MOD) then					return "Moderator";
	elseif (LEVEL <= ASS_LVL_GOLD) then						return "Gold Member"
	elseif (LEVEL <= ASS_LVL_RESPECTED) then				return "VIP"
	elseif (LEVEL >= ASS_LVL_GUEST && LEVEL < ASS_LVL_BANNED) then		return "Guest"
	else
		return "Banned";	
	end
end

function ASS_FormatText( TEXT )

	if (CLIENT) then
		TEXT = string.Replace(TEXT, "%assmod%", ASS_VERSION )

		TEXT = string.Replace(TEXT, "%cl_time%", os.date("%H:%M:%S") )
		TEXT = string.Replace(TEXT, "%cl_date%",  os.date("%d/%b/%Y") )
		TEXT = string.Replace(TEXT, "%cl_timedate%", os.date("%H:%M:%S") .. " " ..  os.date("%d/%b/%Y") )

		TEXT = string.Replace(TEXT, "%sv_time%", GetGlobalString("ServerTime") )
		TEXT = string.Replace(TEXT, "%sv_date%", GetGlobalString("ServerDate") )
		TEXT = string.Replace(TEXT, "%sv_timedate%", GetGlobalString("ServerTime") .. " " .. GetGlobalString("ServerDate") )

		TEXT = string.Replace(TEXT, "%hostname%", GetGlobalString( "ServerName" ) )
		TEXT = string.gsub(TEXT, "%%%&([%w_]+)%%", GetConVarString)
	end
	if (SERVER) then
	
		TEXT = string.Replace(TEXT, "%map%", game.GetMap() )
		TEXT = string.Replace(TEXT, "%gamemode%", gmod.GetGamemode().Name )

		TEXT = string.gsub(TEXT, "%%@([%w_]+)%%", GetConVarString)
	
	end
	
	TEXT = ASS_RunPluginFunction("FormatText", TEXT, TEXT)


	return TEXT
	
end

--Functions Garry removed we should still be using..
function NullEntity()
	return NULL
end

--Overv's Serverside chat.AddText
if SERVER then
    chat = { }
    function chat.AddText( ... )
    	local arg = {...}
        if ( type( arg[1] ) == "Player" ) then ply = arg[1] end
         
        umsg.Start( "AddText", ply )
            umsg.Short( #arg )
            for _, v in pairs( arg ) do
                if ( type( v ) == "string" ) then
                    umsg.String( v )
                elseif ( type ( v ) == "table" ) then
                    umsg.Short( v.r )
                    umsg.Short( v.g )
                    umsg.Short( v.b )
                    umsg.Short( v.a )
                end
            end
        umsg.End( )
    end
else
    usermessage.Hook( "AddText", function( um )
        local argc = um:ReadShort( )
        local args = { }
        for i = 1, argc / 2, 1 do
            table.insert( args, Color( um:ReadShort( ), um:ReadShort( ), um:ReadShort( ), um:ReadShort( ) ) )
            table.insert( args, um:ReadString( ) )
        end
         
        chat.AddText( unpack( args ) )
    end )
end

IncludeSharedFile("ass_plugins.lua")
IncludeSharedFile("ass_debug.lua")
IncludeSharedFile("ass_config.lua")
