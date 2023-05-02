-- Item Statistics

ITEM.name = "Tinder Box"
ITEM.description = "A box containing a few small logs and a flint and tinder to create a small controlled fire. The fire can be used for cooking certain items."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Functions

ITEM.functions.Use = {
    OnRun = function(item)
        local ply = item.player
        local trace = ply:GetEyeTraceNoCursor()
    
        if ( trace.HitPos:Distance(ply:GetShootPos() ) <= 192 ) then
            local deployable = ents.Create("ix_campfire")
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
            ply:Notify("You cannot create a campfire that far away!")
            
            return false
        end
    end
}