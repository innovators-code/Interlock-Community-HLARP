-- Item Statistics

ITEM.name = "Cooking Stove"
ITEM.description = "A cooking stove that can be placed."
ITEM.category = "Cooking"

-- Item Configuration

ITEM.model = "models/props_c17/furnitureStove001a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 4
ITEM.height = 3
ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, 0),
	fov = 20.22
}

-- Item Functions

ITEM.functions.place = {
	name = "Place",
	icon = "icon16/wrench.png",
    OnRun = function(item)
        local ply = item.player
        local trace = ply:GetEyeTraceNoCursor()
    
        if ( trace.HitPos:Distance(ply:GetShootPos() ) <= 192 ) then
            local deployable = ents.Create("ix_stove")
            deployable:SetPos(trace.HitPos)
            deployable:Spawn()
            
            if ( IsValid(itemEntity) ) then
                local physicsObject = itemEntity:GetPhysicsObject()
                
                deployable:SetPos( itemEntity:GetPos() )
                deployable:SetAngles( itemEntity:GetAngles() )
                
                if ( IsValid(physicsObject) ) then
                    if not ( physicsObject:IsMoveable() ) then
                        physicsObject = deployable:GetPhysicsObject()
                        
                        if ( IsValid(physicsObject) ) then
                            physicsObject:EnableMotion(false)
                        end
                    end
                end
            else
                deployable:SetPos(trace.HitPos + (deployable:GetPos() - deployable:NearestPoint(trace.HitPos - (trace.HitNormal * 512))))
            end
        else
            ply:Notify("You cannot place a cooking stove that far away!")
            
            return false
        end
    end
}