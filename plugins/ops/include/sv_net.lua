util.AddNetworkString("ixOpsEMMenu")
util.AddNetworkString("ixOpsEMPushSequence")
util.AddNetworkString("ixOpsEMUpdateEvent")
util.AddNetworkString("ixOpsEMPlaySequence")
util.AddNetworkString("ixOpsEMStopSequence")
util.AddNetworkString("ixOpsEMClientsideEvent")
util.AddNetworkString("ixOpsEMIntroCookie")
util.AddNetworkString("ixOpsEMPlayScene")
util.AddNetworkString("ixOpsEMEntAnim")

net.Receive("ixOpsEMPushSequence", function(len, ply)
    if (ply.nextOpsEMPush or 0) > CurTime() then return end
    ply.nextOpsEMPush = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()
    local seqEventCount = net.ReadUInt(16)
    local events = {}

    print("[ops-em] Starting pull of "..seqName.." (by "..ply:SteamName().."). Total events: "..seqEventCount.."")

    for i=1, seqEventCount do
        local dataSize = net.ReadUInt(16)
        local eventData = pon.decode(net.ReadData(dataSize))

        table.insert(events, eventData)
        print("[ops-em] Got event "..i.."/"..seqEventCount.." ("..eventData.Type..")")
    end

    ix.ops.eventManager.sequences[seqName] = events

    print("[ops-em] Finished pull of "..seqName..". Ready to play sequence!")

    if IsValid(ply) then
        ply:Notify("Push completed.")
    end
end)

net.Receive("ixOpsEMPlaySequence", function(len, ply)
    if (ply.nextOpsEMPlay or 0) > CurTime() then return end
    ply.nextOpsEMPlay = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()

    if not ix.ops.eventManager.sequences[seqName] then
        return ply:Notify("Sequence does not exist on server (push first).")
    end

    if ix.ops.eventManager.GetSequence() == seqName then
        return ply:Notify("Sequence already playing.")
    end

    ix.ops.eventManager.PlaySequence(seqName)

    print("[ops-em] Playing sequence "..seqName.." (by "..ply:SteamName()..").")
    ply:Notify("Playing sequence "..seqName..".")
end)

net.Receive("ixOpsEMStopSequence", function(len, ply)
    if (ply.nextOpsEMStop or 0) > CurTime() then return end
    ply.nextOpsEMStop = CurTime() + 1

    if not ply:IsEventAdmin() then
        return
    end

    local seqName = net.ReadString()

    if not ix.ops.eventManager.sequences[seqName] then
        return ply:Notify("Sequence does not exist on server (push first).")
    end

    if ix.ops.eventManager.GetSequence() != seqName then
        return ply:Notify("Sequence not playing.")
    end

    ix.ops.eventManager.StopSequence(seqName)

    print("[ops-em] Stopping sequence "..seqName.." (by "..ply:SteamName()..").")
    ply:Notify("Stopped sequence "..seqName..".")
end)

net.Receive("ixOpsEMIntroCookie", function(len, ply)
    if ply.usedIntroCookie or not ix.ops.eventManager.GetEventMode() then
        return
    end
    
    ply.usedIntroCookie = true

    ply:AllowScenePVSControl(true)

    timer.Simple(900, function()
        if IsValid(ply) then
            ply:AllowScenePVSControl(false)
        end
    end)
end)