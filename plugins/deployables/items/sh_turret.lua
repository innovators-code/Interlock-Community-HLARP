local PLUGIN = PLUGIN

ITEM.name = "Automated Turret"
ITEM.model = "models/combine_turrets/floor_turret.mdl"
ITEM.description = "A turret standing on three feet with automated targeting capabilities."
ITEM.category = "Tools"

ITEM.width = 2
ITEM.height = 3
ITEM.iconCam = {
    pos = Vector(0, 200, 0),
    ang = Angle(-8.35, 270.6, 0),
    fov = 14.1,
}

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        local trace = ply:GetEyeTraceNoCursor()
        if ( trace.HitPos:Distance(ply:GetShootPos()) <= 192 ) then
            local deployable = ents.Create("npc_turret_floor")
            deployable:SetPos(trace.HitPos)
            deployable:SetMaxHealth(5)
            deployable:SetHealth(5)
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
            ply:Notify("You cannot place a turret that far away!")
            return false
        end
    end
}
