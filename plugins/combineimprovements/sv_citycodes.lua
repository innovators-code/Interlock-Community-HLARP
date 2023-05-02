--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/
    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.Set()
    Desc: Sets a code.
---------------------------------------------------------------------------]]--

function ix.cityCode.Set(ply, code)
    if ( IsValid(ply) and ply:GetCharacter() ) then
        for k, v in pairs(player.GetAll()) do
            if ( v:IsAdmin() ) then
                MsgC("[INTERLOCK: CITY CODE] " .. ply:Nick() .. " has set the code to " .. ix.cityCode.codes[code].name .. ".\n")
            end
        end
        if ( ix.cityCode.Get(code) and ix.cityCode.Get(code).OnCheckAccess ) then
            if ( ( ix.cityCode.coolDown or 0 ) < CurTime() ) then
                ix.cityCode.coolDown = CurTime() + 3
                if not ( ix.cityCode.Get(code).OnCheckAccess(ply) ) then
                    ply:Notify("You do not have access to change the city code.")
                    return false
                end
            else
                ply:Notify("You must wait before using changing codes.")
                return false
            end
        end
    end

    -- stops all current codes which are active.
    for k, v in pairs(ix.cityCode.GetAll()) do
        if ( ix.cityCode.Get(k) and ix.cityCode.Get(k).OnEnd ) then
            if ( ix.cityCode.GetCurrent() == k ) then
                ix.cityCode.Get(k).OnEnd()
            end
        end
    end

    if ( ix.cityCode.Get(code) and ix.cityCode.Get(code).OnStart ) then
        if not ( ix.cityCode.GetCurrent() == code ) then
            ix.cityCode.Get(code).OnStart()
        end
    end
    
    SetGlobalString("ixCityCode", code)
end

concommand.Add("ix_code_get", function(ply, cmd, args)
    if not ( ply:IsAdmin() or ply:IsDeveloper() or ply:IsCombineCommand() ) then
        ix.log.AddRaw(ply:Nick() .. " has attempted to get the current code status", false)
        return 
    end

    ix.log.AddRaw("The current code status is " .. ix.cityCode.GetCurrent() .. " ( " .. ix.cityCode.Get(ix.cityCode.GetCurrent()).name .. " )" , true)
end)

concommand.Add("ix_code_set", function(ply, cmd, args)
    if not ( ply:IsAdmin() or ply:IsDeveloper() or ply:IsCombineCommand() ) then
        ix.log.AddRaw(ply:Nick() .. " has attempted to set the code to " .. ix.cityCode.Get(args[1]).name, false)
        return 
    end
    
    if not ( args[1] ) then
        MsgC(ix.config.Get("color"), "You haven't provided an argument.Usage: ix_code_set <code>\n")
        for k, v in SortedPairs(ix.cityCode.GetAll()) do
            Msg(k .. "\n")
        end
        return 
    end

    ix.log.AddRaw(ply:Nick() .. " has set the city code to " .. ix.cityCode.Get(args[1]).name, false)
    ix.cityCode.Set(ply, tostring(args[1]) or "codetwelve")  
end)