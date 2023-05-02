net.Receive("ixOpsEMMenu", function()
    local count = net.ReadUInt(8)
    local svSequences = {}

    for i=1, count do
        table.insert(svSequences, net.ReadString())
    end

    if ix_eventmenu and IsValid(ix_eventmenu) then
        ix_eventmenu:Remove()
    end
    
    ix_eventmenu = vgui.Create("ixEventManager")
    ix_eventmenu:SetupPlayer(svSequences)
end)

net.Receive("ixOpsEMUpdateEvent", function()
    local event = net.ReadUInt(10)

    ix_OpsEM_LastEvent = event

    ix_OpsEM_CurEvents = ix_OpsEM_CurEvents or {}
    ix_OpsEM_CurEvents[event] = CurTime()
end)

net.Receive("ixOpsEMClientsideEvent", function()
    local event = net.ReadString()
    local uid = net.ReadString()
    local len = net.ReadUInt(16)
    local prop = pon.decode(net.ReadData(len))

    if not ix.ops.eventManager then
        return
    end

    local sequenceData = ix.ops.eventManager.config.Events[event]

    if not sequenceData then
        return
    end

    if not uid or uid == "" then
        uid = nil
    end

    sequenceData.Do(prop or {}, uid)
end)

net.Receive("ixOpsEMPlayScene", function()
    local scene = net.ReadString()

    if not ix.ops.eventManager.scenes[scene] then
        return print("[ops] Error! Can't find sceneset: "..scene)
    end

    ix.scenes.PlaySet(ix.ops.eventManager.scenes[scene])
end)

local customAnims = customAnims or {}
net.Receive("ixOpsEMEntAnim", function()
    local entid = net.ReadUInt(16)
    local anim = net.ReadString()

    customAnims[entid] = anim

    timer.Remove("opsAnimEnt"..entid)
    timer.Create("opsAnimEnt"..entid, 0.05, 0, function()
        local ent = Entity(entid)

        if IsValid(ent) and customAnims[entid] and ent:GetSequence() == 0 then
            ent:ResetSequence(customAnims[entid])
        end
    end)
end)

net.Receive("ixOpsSMOpen", function()
    vgui.Create("ixStaffManager")
end)