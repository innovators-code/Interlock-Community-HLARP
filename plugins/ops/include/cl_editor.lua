function ix.ops.eventManager.SequenceLoad(path)
    local fileData = file.Read(path, "DATA")
    local json = util.JSONToTable(fileData)

    if not json or not istable(json) then
        return false, "Corrupted sequence file"
    end

    if not json.Name or not json.Events or not json.FileName then
        return false, "Corrupted sequence file vital metadata"
    end

    ix.ops.eventManager.sequences[json.Name] = json

    return true
end

function ix.ops.eventManager.SequenceSave(name)
    local sequence = ix.ops.eventManager.sequences[name]
    file.Write("helix/"..Schema.folder.."/ops/eventmanager/"..sequence.FileName..".json", util.TableToJSON(sequence, true))
end

function ix.ops.eventManager.SequencePush(name)
    local sequence = ix.ops.eventManager.sequences[name]
    local events = sequence.Events
    local eventCount = table.Count(events)

    print("[ops-em] Starting push of "..name..". (This might take a while)")

    net.Start("ixOpsEMPushSequence")
    net.WriteString(name)
    net.WriteUInt(eventCount, 16)

    for v,k in pairs(events) do
        local edata = pon.encode(k)
        net.WriteUInt(#edata, 16)
        net.WriteData(edata, #edata)

        print("[ops-em] Packaged event "..v.."/"..eventCount.." ("..k.Type..")")
    end

    net.SendToServer()

    print("[ops-em] Push fully sent to server!")
end

function ix.ops.eventManager.GetVersionHash()
    return util.CRC(util.TableToJSON(ix.ops.eventManager.config.Events))
end