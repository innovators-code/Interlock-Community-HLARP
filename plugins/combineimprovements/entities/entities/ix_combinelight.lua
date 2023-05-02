local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Combine Light"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_light001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_combinelight")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveCombineLights()
        return entity
    end
else
	local dist = 2000 * 2000

    function ENT:Think()
		if ( LocalPlayer():GetPos():DistToSqr(self:GetPos()) > dist ) then
			return
		end

        local dlight = DynamicLight(self:EntIndex())
        if ( dlight ) then
            local r, g, b, a = self:GetColor()
            dlight.Pos = self:GetPos()
            dlight.r = 125
            dlight.g = 200
            dlight.b = 255
            dlight.Brightness = 0
            dlight.Size = 800
            dlight.Decay = 5
            dlight.DieTime = CurTime() + 0.1
        end
    end
end
