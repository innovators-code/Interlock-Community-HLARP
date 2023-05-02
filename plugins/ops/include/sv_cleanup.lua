ix.ops = ix.ops or {}

function ix.ops.cleanupPlayer(ply)
    for v,k in ipairs(ents.GetAll()) do
        local owner = k:GetOwner()

        if owner == ply then
            k:Remove()
        end
    end
end

function ix.ops.cleanupAll()
    for v,k in ipairs(ents.GetAll()) do
        local owner = k:GetOwner()

        if owner then
            k:Remove()
        end
    end
end

function ix.ops.clearDecals()
    for v,k in pairs(player.GetAll()) do
        k:ConCommand("r_cleardecals")
    end
end