
ITEM.name = "Pin"
ITEM.description = "A pin used to hang up papers on the walls."
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.category = "Tools"

local function MakeNail(Ent1, Ent2, Bone1, Bone2, forcelimit, Pos, Ang)
    local constraint = constraint.Weld(Ent1, Ent2, Bone1, Bone2, forcelimit, false)

    constraint.Type = "Nail"
    constraint.Pos = Pos
    constraint.Ang = Ang

    Pos = Ent1:LocalToWorld(Pos)
    Ent1:GetPhysicsObject():EnableMotion(false)

    local nail = ents.Create("ix_nail")
    nail:SetModel("models/crossbow_bolt.mdl")
    nail:SetPos(Pos)
    nail:SetAngles(Ang)
    nail:SetParentPhysNum(Bone1)
    nail:SetParent(Ent1)
    nail:Spawn()
    nail:Activate()

    constraint:DeleteOnRemove(nail)

    return constraint, nail
end

ITEM.functions.use = {
    OnRun = function(itemTable)
        local client = itemTable.player
        local trace = client:GetEyeTrace()

        if (!IsValid(trace.Entity) or trace.Entity:IsPlayer()) then
            return false
        end

        if (!util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then
            return false
        end

        local data = {}
            data.start = trace.HitPos
            data.endpos = trace.HitPos + (client:GetAimVector() * 16.0)
            data.filter = {client, trace.Entity}
        local trTwo = util.TraceLine(data)

        if (trTwo.Hit and !trTwo.Entity:IsPlayer()) then
            local forcelimit = "100"
            local vOrigin = trace.HitPos - (client:GetAimVector() * 8.0)
                vOrigin = trace.Entity:WorldToLocal(vOrigin)
            local vDirection = client:GetAimVector():Angle()

            -- Stupid workaround for the entity not freezing due to being held
            local weapon = client:GetActiveWeapon()
            if (weapon:GetClass() == "ix_hands" and weapon:IsHoldingObject()) then
                weapon:DropObject(false)
            end

            local constraint, _ = MakeNail(trace.Entity, trTwo.Entity, trace.PhysicsBone, trTwo.PhysicsBone, forcelimit, vOrigin, vDirection)

            if (!IsValid(constraint)) then
                return false
            end
        end
    end,
    OnCanRun = function(itemTable)
        local trace = itemTable.player:GetEyeTraceNoCursor()
        return IsValid(trace.Entity) and !trace.Entity:IsPlayer()
    end
}
