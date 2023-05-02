ix.ops = ix.ops or {}
ix.ops.Snapshots = ix.ops.Snapshots or {}

ix.command.Add("snapshot", {
    description = "Plays the snapshot specified by the snapshot ID.",
    adminOnly = true,
    arguments = {ix.type.number},
    OnRun = function(self, ply, id)
        if not tonumber(id) then
            return ply:Notify("ID must be a number.")
        end

        id = tonumber(id)

        if not ix.ops.Snapshots[id] then
            return ply:Notify("Snapshot could not be found with that ID.")
        end

        ply:Notify("Downloading snapshot #"..id.."...")

        local snapshot = ix.ops.Snapshots[id]
        snapshot = pon.encode(snapshot)
        
        net.Start("opsSnapshot")
        net.WriteUInt(id, 16)
        net.WriteUInt(#snapshot, 32)
        net.WriteData(snapshot, #snapshot)
        net.Send(ply)
    end
})