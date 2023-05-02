AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Stun Baton"
SWEP.Category = "IX:HLA RP"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "melee"

SWEP.WorldModel = "models/hla/w_stunstick.mdl"
SWEP.ViewModel = "models/hla/c_stunstick.mdl"
SWEP.ViewModelFOV = 52

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "weapons/stunstick/stunstick_swing1.wav"
SWEP.Primary.ImpactSound = "weapons/stunstick/stunstick_impact2.wav"
SWEP.Primary.ImpactEffect = "StunstickImpact"
SWEP.Primary.FlashTime = 1
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.7
SWEP.Primary.Range = 75

function SWEP:Initialize()
    self:SetMode(1)
    self:GetOwner():SetNWInt("ixStunstickMode", 1)
    self:GetOwner():SetNWBool("ixStunModeActive", nil)
end

function SWEP:ExtraDataTables()
    self:NetworkVar("Int", 5, "Mode")
end

function SWEP:ExtraHolster()
    self:GetOwner():StopSound("ambient/machines/combine_shield_touch_loop1.wav")
    self:SetMode(1)
    self:GetOwner():SetNWInt("ixStunstickMode", 1)
    self:GetOwner():SetNWBool("ixStunModeActive", nil)
end

function SWEP:OnRemove()
    if ( IsValid(self:GetOwner()) ) then
        self:GetOwner():StopSound("ambient/machines/combine_shield_touch_loop1.wav")
    end
end

function SWEP:OnLowered()
    self:SetMode(1)
    self:GetOwner():SetNWInt("ixStunstickMode", 1)
    self:GetOwner():SetNWBool("ixStunModeActive", nil)
    self:GetOwner():StopSound("ambient/machines/combine_shield_touch_loop1.wav")
end

function SWEP:PrePrimaryAttack()
    local mode = self:GetMode()

    if ( mode == 1 ) then
        self.Primary.Damage = 3
        self.Primary.ImpactEffect = nil
        self.Primary.FlashTime = 0.2
        self.Primary.Sound = Sound("WeaponFrag.Roll")
        self.Primary.ImpactSound = Sound("physics/plastic/plastic_barrel_impact_bullet1.wav")
    elseif ( mode == 2 ) then
        self.Primary.Damage = 6
        self.Primary.FlashTime = 0.8

        self.Primary.ImpactEffect = "StunstickImpact"
        self.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
        self.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
    elseif ( mode == 3 ) then
        self.Primary.Damage = 10
        self.Primary.FlashTime = 1.1

        self.Primary.ImpactEffect = "StunstickImpact"
        self.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
        self.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
        
        local data = {}
            data.start = self:GetOwner():GetShootPos()
            data.endpos = data.start + self:GetOwner():GetAimVector() * 84
            data.filter = {self, self:GetOwner()}
        local trace = util.TraceLine(data)
        local entity = trace.Entity

        if ( SERVER ) then
            if ( entity:IsValid() and entity:IsPlayer() and entity:Alive() ) and not ( entity:IsCombine() or IsValid(entity.ixRagdoll) ) then
                entity:SetRagdolled(true, 20)
            end
        end
    end

    if ( self:GetOwner():GetModel():find("combine_heavy_trooper") ) then
        local data = {}
            data.start = self:GetOwner():GetShootPos()
            data.endpos = data.start + self:GetOwner():GetAimVector() * 84
            data.filter = {self, self:GetOwner()}
        local trace = util.TraceLine(data)
        local entity = trace.Entity

        if (SERVER and IsValid(entity)) then
            local direction = self:GetOwner():GetAimVector() * (300 + (self:GetOwner():GetCharacter():GetAttribute("str", 0) * 3))
            direction.z = 0
            entity:SetVelocity(direction)
            self.Primary.Damage = 80
        end
    end
end

function SWEP:SecondaryAttack()
    if ( self:GetOwner():KeyDown(IN_WALK) ) then
        local oldMode = self:GetMode()
        local newMode = oldMode + 1

        if ( newMode > 3 ) then
            newMode = 1
            self:GetOwner():SetNWBool("ixStunModeActive", nil)
            self:GetOwner():StopSound("ambient/machines/combine_shield_touch_loop1.wav")
        end

        if ( SERVER ) then
            self:SetMode(newMode)
            self:GetOwner():SetNWInt("ixStunstickMode", newMode)

            local seq = "deactivatebaton"

            if ( newMode > 1 ) then
                self:GetOwner():EmitSound("weapons/stunstick/spark3.wav", 80, math.random(90, 110))
                seq = "activatebaton"
            else
                self:GetOwner():EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 80, math.random(90, 110))
            end

            if ( newMode == 3 ) then
                self:GetOwner():EmitSound("ambient/energy/whiteflash.wav", 70, 80, 0.3)
                timer.Simple(3, function()
                    self:GetOwner():SetNWBool("ixStunModeActive", true)
                    self:GetOwner():EmitSound("ambient/energy/zap"..math.random(1,9)..".wav", 70, 90, 0.3)
                    self:GetOwner():EmitSound("ambient/machines/combine_shield_touch_loop1.wav", 70, 90, 0.3)
                end)
            end

            if ( self:GetOwner():GetModel():find("police") ) then
                self:GetOwner():ForceSequence(seq, nil, nil, true)
            end
        end

        return self:SetNextSecondaryFire(CurTime() + 3)
    end

    self:GetOwner():LagCompensation(true)

    local trace = {}
    trace.start = self:GetOwner():GetShootPos()
    trace.endpos = trace.start + self:GetOwner():GetAimVector() * 72
    trace.filter = self:GetOwner()
    trace.mins = Vector(-7, -7, -30)
    trace.maxs = Vector(8, 8, 10)

    local tr = util.TraceHull(trace)
    local ent = tr.Entity
    self:GetOwner():LagCompensation(false)

    if ( SERVER and ent and IsValid(ent) ) then
        if ent:IsPlayer() then
            self:GetOwner():EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")
            local direction = self:GetOwner():GetAimVector() * 330
            direction.z = 0

            ent:SetVelocity(direction)

            self:SetNextSecondaryFire(CurTime() + 2)
        end
    end
end

-- based on NS sunstick effects:

local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")

local color_glow = Color(128, 128, 128)

function SWEP:ExtraDrawWorldModel()
    self:DrawModel()
    local mode = self:GetMode()

    if not ( mode or mode < 2 ) then return end

    local size

    if ( mode == 2 ) then
        size = math.Rand(4.0, 6.0)
    elseif ( mode == 3 ) and ( self:GetOwner():GetNWBool("ixStunModeActive") ) then
        size = math.Rand(6.5, 7.5)
    else
        size = 0
    end

    local glow = math.Rand(0.6, 0.8) * 255
    local color = Color(glow, glow, glow)
    local attachment = self:GetAttachment(1)
    local attachment2 = self:GetAttachment(2)

    if ( attachment ) then
        local position = attachment.Pos

        render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
        render.DrawSprite(position, size * 2, size * 2, color)

        render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
        render.DrawSprite(position, size, size + 3, color_glow)
    end

    if ( attachment2 ) then
        local position = attachment2.Pos

        render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
        render.DrawSprite(position, size * 2, size * 2, color)

        render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
        render.DrawSprite(position, size, size + 3, color_glow)
    end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME = "sparkrear"

function SWEP:PostDrawViewModel()
    local mode = self:GetMode()

    if not ( mode or mode < 2 ) then return end

    local vm = LocalPlayer():GetViewModel()

    if not ( IsValid(vm) ) then return end

    cam.Start3D(EyePos(), EyeAngles())
        local size

        if ( mode == 2 ) then
            size = math.Rand(4.0, 6.0)
        elseif ( mode == 3 ) then
            if not ( self:GetOwner():GetNWBool("ixStunModeActive") ) then
                size = 0
            else
                size = math.Rand(6.5, 7.5)
            end
        else
            size = 0
        end

        local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2)*20)

        STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)

        render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

        local attachment = vm:GetAttachment(vm:LookupAttachment(BEAM_ATTACH_CORE_NAME))

        if ( attachment ) then
            render.DrawSprite(attachment.Pos, size * 6, size * 16, color)
        end
    cam.End3D()
end