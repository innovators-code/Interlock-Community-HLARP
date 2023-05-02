concommand.Add("ix_ops_eventmanager", function(ply)
    if not ply:IsEventAdmin() then
        return
    end

    local c = table.Count(ix.ops.eventManager.sequences)

    net.Start("ixOpsEMMenu")
    net.WriteUInt(c, 8)

    for v,k in pairs(ix.ops.eventManager.sequences) do
        net.WriteString(v)    
    end

    net.Send(ply)
end)