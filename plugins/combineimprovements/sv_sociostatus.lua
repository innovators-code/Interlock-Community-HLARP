--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/
    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.Set()
    Desc: Sets a code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.Set(ply, code)
    if ( IsValid(ply) and ply:GetCharacter() ) then
        for k, v in pairs(player.GetAll()) do
            if ( v:IsAdmin() ) then
                MsgC("[INTERLOCK: SOCIO STABILITY] " .. ply:Nick() .. " has set the code to " .. ix.socioStatus.Get(code).name .. ".\n")
            end
        end
        if ( ix.socioStatus.Get(code) and ix.socioStatus.Get(code).OnCheckAccess ) then
            if ( ( ix.socioStatus.coolDown or 0 ) < CurTime() ) then
                ix.socioStatus.coolDown = CurTime() + 3
                if not ( ix.socioStatus.Get(code).OnCheckAccess(ply) ) then
                    ply:Notify("You do not have access to change the city code.")
                    return false
                end
            else
                ply:Notify("You must wait before using changing codes.")
                return false
            end
        end
    end
    
    SetGlobalString("ixSocioStatus", code)
end

concommand.Add("ix_status_get", function(ply, cmd, args)
    if not ( ply:IsAdmin() or ply:IsDeveloper() or ply:IsCombineCommand() ) then
        ix.log.AddRaw(ply:Nick() .. " has attempted to get the current socio status status", false)
        return 
    end

    ix.log.AddRaw("The current socio status status is " .. ix.socioStatus.GetCurrent() .. " ( " .. ix.socioStatus.Get(ix.socioStatus.GetCurrent()).name .. " )" , true)
end)

concommand.Add("ix_status_set", function(ply, cmd, args)
    if not ( ply:IsAdmin() or ply:IsDeveloper() or ply:IsCombineCommand() ) then
        ix.log.AddRaw(ply:Nick() .. " has attempted to set the socio status to " .. ix.socioStatus.Get(args[1]).name, false)
        return 
    end

    if not ( args[1] ) then
        MsgC(ix.config.Get("color"), "You haven't provided an argument.Usage: ix_status_set <socio status>\n")
        for k, v in SortedPairs(ix.socioStatus.GetAll()) do
            Msg(k .. "\n")
        end
        return 
    end

    ix.log.AddRaw(ply:Nick() .. " has set the socio status to " .. ix.socioStatus.Get(args[1]).name, false)
    ix.socioStatus.Set(ply, tostring(args[1]) or "stable")  
end)