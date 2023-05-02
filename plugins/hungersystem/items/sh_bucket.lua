-- Item Statistics

ITEM.name = "Cooking Bucket"
ITEM.description = "A cooking bucket that can be placed."
ITEM.category = "Cooking"

-- Item Configuration

ITEM.model = "models/props_junk/MetalBucket01a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 200, 0),
	ang = Angle(0, 270, 0),
	fov = 6.14
}

-- Item Functions

ITEM.functions.place = {
	name = "Place",
	icon = "icon16/wrench.png",
    OnRun = function(item)
        local ply = item.player
        local trace = ply:GetEyeTraceNoCursor()
    
        if ( trace.HitPos:Distance(ply:GetShootPos() ) <= 192 ) then
            local deployable = ents.Create("ix_bucket")
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
            ply:Notify("You cannot place a cooking bucket that far away!")
            
            return false
        end
    end
}