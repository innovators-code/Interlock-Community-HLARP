local PLAYER = FindMetaTable("Player")

function ix.ops.eventManager.GetEventMode()
    return GetGlobalBool("opsEventMode", false)
end

function ix.ops.eventManager.GetSequence()
    local val = GetGlobalString("opsEventSequence", "")

    if val == "" then
        return
    end

    return val
end

function ix.ops.eventManager.SetEventMode(val)
    return SetGlobalBool("opsEventMode", val)
end

function ix.ops.eventManager.SetSequence(val)
    return SetGlobalString("opsEventSequence", val)
end

function ix.ops.eventManager.GetCurEvents()
    return ix_OpsEM_CurEvents
end

function PLAYER:IsEventAdmin()
    return self:IsSuperAdmin() or (self:IsAdmin() and ix.ops.eventManager.GetEventMode())
end

if SERVER then
    concommand.Add("ix_ops_eventmode", function(ply, cmd, args)
        if not IsValid(ply) or ply:IsSuperAdmin() then
            if args[1] == "1" then
                ix.ops.eventManager.SetEventMode(true)
                print("[ops-em] Event mode ON")
            else
                ix.ops.eventManager.SetEventMode(false)
                print("[ops-em] Event mode OFF")
            end
        end
    end)
end