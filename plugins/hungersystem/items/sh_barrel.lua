-- Item Statistics

ITEM.name = "Cooking Barrel"
ITEM.description = "A cooking barrel that can be placed."
ITEM.category = "Cooking"

-- Item Configuration

ITEM.model = "models/props_phx/empty_barrel.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 2
ITEM.height = 3
ITEM.iconCam = {
	pos = Vector(-201.07, -11.91, 34.35),
	ang = Angle(3.48, 3.46, 0),
	fov = 10.74
}

-- Item Functions

ITEM.functions.place = {
	name = "Place",
	icon = "icon16/wrench.png",
    OnRun = function(item)
        local ply = item.player
        local trace = ply:GetEyeTraceNoCursor()
    
        if ( trace.HitPos:Distance(ply:GetShootPos() ) <= 192 ) then
            local deployable = ents.Create("ix_barrel")
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
            ply:Notify("You cannot place a cooking barrel that far away!")
            
            return false
        end
    end
}