AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Nail"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/items/crossbowrounds.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        self.nail = ents.Create("prop_dynamic")
        self.nail:SetModel("models/crossbow_bolt.mdl")
        self.nail:SetPos(self:GetPos())
        self.nail:SetAngles(self:GetAngles())
        self.nail:Spawn()
        self.nail:SetParent(self)

        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    
        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_nail")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveNails()
        return entity
    end
else
    function ENT:Draw()
        -- do not draw model
    end
end