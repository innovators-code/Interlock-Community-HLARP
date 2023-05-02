local PLUGIN = PLUGIN

util.AddNetworkString("ixCinematicMessage")
function ix.ops.cinematicIntro(message)
    net.Start("ixCinematicMessage")
        net.WriteString(message)
    net.Broadcast()
end

concommand.Add("ix_ops_cinemessage", function(ply, cmd, args)
    if not ( ply:IsSuperAdmin() ) then return end
    
    ix.ops.cinematicIntro(args[1] or "")
end)

function ix.util.IsEmpty(vector, ignore) -- findpos and isempty are from darkrp
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end

function ix.util.FindEmptyPos(pos, ignore, distance, step, area)
    if ix.util.IsEmpty(pos, ignore) and ix.util.IsEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do -- alternate in direction
            local k = j * i

            -- Look North/South
            if ix.util.IsEmpty(pos + Vector(k, 0, 0), ignore) and ix.util.IsEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            -- Look East/West
            if ix.util.IsEmpty(pos + Vector(0, k, 0), ignore) and ix.util.IsEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            -- Look Up/Down
            if ix.util.IsEmpty(pos + Vector(0, 0, k), ignore) and ix.util.IsEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

util.AddNetworkString("ixScenePVS")
util.AddNetworkString("ixScenePVSOff")

net.Receive("ixScenePVS", function(len, ply)
    ply.ixScenePVSPosition = net.ReadVector()
end)

net.Receive("ixScenePVSOff", function(len, ply)
    ply.ixScenePVSPosition = nil
end)

function PLUGIN:SetupPlayerVisibility(ply)
    if ( ply.ixScenePVSPosition and isvector(ply.ixScenePVSPosition) ) then
        AddOriginToPVS(ply.ixScenePVSPosition)
    end
end