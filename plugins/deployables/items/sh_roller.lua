local PLUGIN = PLUGIN

ITEM.name = "Roller Mine"
ITEM.model = "models/roller.mdl"
ITEM.description = "A rollermine."
ITEM.category = "Tools"

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        local trace = ply:GetEyeTraceNoCursor()
        if ( trace.HitPos:Distance(ply:GetShootPos()) <= 192 ) then
            local deployable = ents.Create("npc_rollermine")
            deployable:SetPos(trace.HitPos)
            deployable:SetMaxHealth(50)
            deployable:SetHealth(50)
            deployable:AddEntityRelationship(ply, D_LI, 99)
            deployable:Spawn()

            local physicsObject = deployable:GetPhysicsObject()
            if ( IsValid(physicsObject) ) then
                physicsObject:Wake()
                physicsObject:EnableMotion(false)
                timer.Simple(0.1, function() physicsObject:EnableMotion(true) end)
            end
            if ( IsValid(deployable) ) then
                deployable:SetAngles(Angle(0, ply:EyeAngles().yaw + 360, 0))
            end
        else
            ply:Notify("You cannot place a rollermine that far away!")
            return false
        end
    end
}
