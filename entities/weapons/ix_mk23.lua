AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "TFA_INS2.MK23.1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "weapons/tfa_ins2/mk23/m45_fp.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.2",
    channel = CHAN_WEAPON,
    volume = 0.4,
    soundlevel = 40,
    sound = "weapons/tfa_ins2/mk23/m45_suppressed_fp.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Boltback",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/boltback.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Boltrelease",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/boltrelease.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Boltslap",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/boltslap.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Empty",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/empty.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.MagHit",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/maghit.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Magin",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/magin.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Magout",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/magout.wav",
})

sound.Add({
    name = "TFA_INS2.MK23.Magrelease",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/tfa_ins2/mk23/magrelease.wav",
})

SWEP.Base = "ls_base"

SWEP.PrintName = "MK23"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "revolver"

SWEP.WorldModel = "models/weapons/tfa_ins2/w_mk23.mdl"
SWEP.ViewModel = "models/weapons/tfa_ins2/c_mk23.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles = Angle(0, -5, -5)
SWEP.LowerAngles2 = Angle(0, -5, -5)

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "TFA_INS2.MK23.Magout"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "TFA_INS2.MK23.1"
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.018
SWEP.Primary.Delay = RPM(400)

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.008
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.9
SWEP.Spread.CrouchMod = 1
SWEP.Spread.AirMod = 2
SWEP.Spread.RecoilMod = 0
SWEP.Spread.VelocityMod = 1.025

SWEP.DoEmptyReloadAnim = false
SWEP.UseIronsightsRecoil = true
SWEP.ViewModelOffset = Vector(1, 5, -1)

SWEP.IronsightsPos = Vector(-3.4, -5, 1.3)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.5

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.1
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.3

local constant = Angle(-0.000, -0.001, 0.000)

local function FormatViewModelAttachment(nFOV, vOrigin, bFrom)
    local vEyePos = EyePos()
    local aEyesRot = EyeAngles()
    local vOffset = vOrigin - vEyePos
    local vForward = aEyesRot:Forward()

    local nViewX = math.tan(nFOV * math.pi / 360)

    if (nViewX == 0) then
        vForward:Mul(vForward:Dot(vOffset))
        vEyePos:Add(vForward)

        return vEyePos
    end

    -- FIXME: LocalPlayer():GetFOV() should be replaced with EyeFOV() when it's binded
    local nWorldX = math.tan(LocalPlayer():GetFOV() * math.pi / 360)

    if (nWorldX == 0) then
        vForward:Mul(vForward:Dot(vOffset))
        vEyePos:Add(vForward)

        return vEyePos
    end

    local vRight = aEyesRot:Right()
    local vUp = aEyesRot:Up()

    if (bFrom) then
        local nFactor = nWorldX / nViewX
        vRight:Mul(vRight:Dot(vOffset) * nFactor)
        vUp:Mul(vUp:Dot(vOffset) * nFactor)
    else
        local nFactor = nViewX / nWorldX
        vRight:Mul(vRight:Dot(vOffset) * nFactor)
        vUp:Mul(vUp:Dot(vOffset) * nFactor)
    end

    vForward:Mul(vForward:Dot(vOffset))

    vEyePos:Add(vRight)
    vEyePos:Add(vUp)
    vEyePos:Add(vForward)

    return vEyePos
end

function SWEP:PostDrawViewModel(vm, weapon, ply)
    local attachment = vm:GetAttachment(vm:LookupAttachment("flashlight"))
    local offsetAng = vm:WorldToLocalAngles(attachment.Ang)

    local diff = offsetAng - constant
    local dir = (vm:GetAngles() + diff):Forward()

    local tr = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = FormatViewModelAttachment(self.ViewModelFOV, ply:GetShootPos() + dir * 56756, true),
        filter = {ply},
        mask = MASK_SHOT
    })

    if not ( self:HasAttachment("laser") ) then return end

    cam.Start3D()
        render.SetMaterial(Material("sprites/bluelaser1"))
        render.DrawBeam(attachment.Pos, tr.HitPos, 2, 0, 12.5, Color(255, 0, 0, 255))
        local Size = math.random() * 1.35
        render.SetMaterial(Material("sprites/light_glow02_add_noz"))
        render.DrawQuadEasy(tr.HitPos, (EyePos() - tr.HitPos):GetNormal(), Size, Size, Color(255,0,0,255), 0)
    cam.End3D()
end

SWEP.Attachments = {
    suppressor = {
        Cosmetic = {
            Model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl",
            Bone = "A_Suppressor",
            Pos = Vector(0, 0, 0),
            Ang = Angle(0, 90, 0),
            Scale = 0.5,
            Skin = 0,
            Material = "",
        },
        ModSetup = function(e)
            e.Primary.Sound = "TFA_INS2.MK23.2"
            e.Primary.Recoil = 0.3
            e.Primary.Damage = 6
            e.Primary.Cone = 0.01
        end,
        ModCleanup = function(e)
            e.Primary.Sound = "TFA_INS2.MK23.1"
            e.Primary.Recoil = 0.6
            e.Primary.Damage = 9
            e.Primary.Cone = 0.018
        end,
        NeedsHDR = false,
        Behaviour = "suppressor",
    },
    laser = {
        NeedsHDR = false,
        Behaviour = "laser_sight",
        ModSetup = function(e)
            if ( e:HasAttachment("suppressor") ) then
                e:TakeAttachment("suppressor")
            end
            
            e.Primary.Sound = "TFA_INS2.MK23.1"
            e.Primary.Recoil = 0.7
            e.Primary.Damage = 9
            e.Primary.Cone = 0 -- laser beam
        end,
        ModCleanup = function(e)
            e.Primary.Sound = "TFA_INS2.MK23.1"
            e.Primary.Recoil = 0.6
            e.Primary.Damage = 9
            e.Primary.Cone = 0.018
        end,
    },
}