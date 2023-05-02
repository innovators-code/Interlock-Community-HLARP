
util.AddNetworkString("ixBodygroupView")
util.AddNetworkString("ixBodygroupTableSet")

ix.log.AddType("bodygroupEditor", function(ply, target)
    return string.format("%s has changed %s's bodygroups.", ply:GetName(), target:GetName())
end)

net.Receive("ixBodygroupTableSet", function(length, ply)
    if (!ix.command.HasAccess(ply, "CharEditBodygroup")) then
        return
    end

    local target = net.ReadEntity()

    if (!IsValid(target) or !target:IsPlayer() or !target:GetCharacter()) then
        return
    end

    local bodygroups = net.ReadTable()

    local groups = {}

    for k, v in pairs(bodygroups) do
        target:SetBodygroup(tonumber(k) or 0, tonumber(v) or 0)
        groups[tonumber(k) or 0] = tonumber(v) or 0
    end

    target:GetCharacter():SetData("groups", groups)
    target:GetCharacter():Save()

    ix.log.Add(ply, "bodygroupEditor", target)
end)
