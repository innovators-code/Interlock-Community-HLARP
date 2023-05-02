local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Barrel"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP (Cooking)"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_phx/empty_barrel.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetNetVar("active", false)
        
        self.loopsound = CreateSound(self, "ambient/fire/fire_small1.wav")
        self.loopsound:Stop()

        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(true)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_barrel")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        --Schema:SaveCombineLights()
        return entity
    end

    function ENT:OnRemove()
        if ( self.loopsound ) then
            self.loopsound:Stop()
        end
    end
else
    function ENT:Initialize()
        self.emitter = ParticleEmitter(self:GetPos())
        self.emittime = CurTime()
    end

    local dist = 2000 * 2000

    function ENT:Think()
        if ( LocalPlayer():GetPos():DistToSqr(self:GetPos()) > dist ) then
            return
        end

        if ( self:GetNetVar("active") ) then
            local dlight = DynamicLight(self:EntIndex())
            if ( dlight ) then
                local r, g, b, a = self:GetColor()
                dlight.Pos = self:GetPos()
                dlight.r = 255
                dlight.g = 170
                dlight.b = 0
                dlight.Brightness = 0
                dlight.Size = 256
                dlight.Decay = 1024
                dlight.DieTime = CurTime() + 0.1
            end
        end
    end

    local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
    function ENT:DrawTranslucent()
        if ( self:GetNetVar("active") ) then
            local firepos = self:GetPos() + ( self:GetUp() * 30 )
            
            -- Fire
            render.SetMaterial(PLUGIN.fire)
            render.DrawBeam(firepos, firepos + self:GetUp() * 50, 40, 0.99, 0, color_white)

            -- Glow
            local size = 20 + math.sin(RealTime() * 15) * 15
            render.SetMaterial(GLOW_MATERIAL)
            render.DrawSprite(firepos + self:GetUp() * 12, size, size, Color(255, 162, 76, 255))
            
            if ( self.emittime < CurTime() ) then
                local smoke = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), firepos)
                smoke:SetVelocity(Vector(0, 0, 150))
                smoke:SetDieTime(math.random(0.6, 2.3))
                smoke:SetStartAlpha(math.random(150, 200))
                smoke:SetEndAlpha(0)
                smoke:SetStartSize(math.random(0, 5))
                smoke:SetEndSize(math.random(33, 55))
                smoke:SetRoll(math.random(180, 480))
                smoke:SetRollDelta(math.random(-3, 3))
                smoke:SetColor(Color(50, 50, 50, 255))
                smoke:SetGravity(Vector(0, 0, 10))
                smoke:SetAirResistance(200)
                
                self.emittime = CurTime() + 0.1
            end
        end
    end
end