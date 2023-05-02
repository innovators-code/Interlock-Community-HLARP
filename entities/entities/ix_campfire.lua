AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Campfire"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_junk/rock001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetMaterial("models/effects/splode1_sheet")
    
        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end

        self:SpawnProps()
        self:StartFire()
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_campfire")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveCampfire()
        return entity
    end

    function ENT:SpawnProps()
        local rotation1 = Vector(0, 0, 45)
        local angle1 = self:GetAngles()
        angle1:RotateAroundAxis(angle1:Forward(), rotation1.z)
        
        local rotation2 = Vector(90, 0, 45)
        local angle2 = self:GetAngles()
        angle2:RotateAroundAxis(angle2:Up(), rotation2.x)
        angle2:RotateAroundAxis(angle2:Forward(), rotation2.z)
        
        local rotation3 = Vector(180, 0, 45)
        local angle3 = self:GetAngles()
        angle3:RotateAroundAxis(angle3:Up(), rotation3.x)
        angle3:RotateAroundAxis(angle3:Forward(), rotation3.z)
        
        local rotation4 = Vector(270, 0, 45)
        local angle4 = self:GetAngles()
        angle4:RotateAroundAxis(angle4:Up(), rotation4.x)
        angle4:RotateAroundAxis(angle4:Forward(), rotation4.z)
        
        local Up = 16
        
        local wood1 = ents.Create("prop_dynamic")
        wood1:SetPos(self:GetPos() + self:GetUp() * Up)
        wood1:SetAngles(angle1)
        wood1:SetModel("models/props_debris/wood_chunk01b.mdl")
        wood1:Activate()
        wood1:SetParent(self)
        wood1:Spawn()
        wood1:DeleteOnRemove(self)
        
        local wood2 = ents.Create("prop_dynamic")
        wood2:SetPos(self:GetPos() + self:GetUp() * Up)
        wood2:SetAngles(angle2)
        wood2:SetModel("models/props_debris/wood_chunk01b.mdl")
        wood2:Activate()
        wood2:SetParent(self)
        wood2:Spawn()
        wood2:DeleteOnRemove(self)
        
        local wood3 = ents.Create("prop_dynamic")
        wood3:SetPos(self:GetPos() + self:GetUp() * Up)
        wood3:SetAngles(angle3)
        wood3:SetModel("models/props_debris/wood_chunk01b.mdl")
        wood3:Activate()
        wood3:SetParent(self)
        wood3:Spawn()
        wood3:DeleteOnRemove(self)
        
        local wood4 = ents.Create("prop_dynamic")
        wood4:SetPos(self:GetPos() + self:GetUp() * Up)
        wood4:SetAngles(angle4)
        wood4:SetModel("models/props_debris/wood_chunk01b.mdl")
        wood4:Activate()
        wood4:SetParent(self)
        wood4:Spawn()
        wood4:DeleteOnRemove(self)
    end
    
    function ENT:OnRemove()
        self:StopFire()
    end
    
    function ENT:StartFire()
        self:Ignite(1)
        timer.Create(tostring(self:GetCreationID()), 1, 0, function()
            self:Ignite(1)
        end)
    end
    
    function ENT:StopFire()
        timer.Destroy(tostring(self:GetCreationID()))
        self:Extinguish()
    end
else
    function ENT:Initialize()
        self.fireSize = 400
        self.nextFlicker = 0
    end

    function ENT:Draw()
        self:DrawModel()
    end

    function ENT:Think()
        local curTime = CurTime()
        local dlight = DynamicLight(self:EntIndex())
        
        if not ( self.nextFlicker ) then
            self.nextFlicker = curTime + math.random(0.1, 0.15)
        end
        
        if ( dlight ) then
            dlight.Pos = self:GetPos()
            dlight.r = 250
            dlight.g = 255
            dlight.b = 125
            dlight.Brightness = 0
            dlight.Size = self.fireSize
            dlight.Decay = 5
            dlight.DieTime = CurTime() + 0.1
            
            self:Flicker()
        end
    end
    
    function ENT:Flicker()
        local curTime = CurTime()
        
        if ( curTime >= self.nextFlicker ) then
            self.fireSize = math.random(300, 400)
            self.nextFlicker = nil
        end
    end
end