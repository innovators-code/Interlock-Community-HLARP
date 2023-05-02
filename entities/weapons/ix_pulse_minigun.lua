AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "ixPulseMinigun.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {
        "interlock/player/weapons/combine_mg/fire01.wav",
        "interlock/player/weapons/combine_mg/fire02.wav",
        "interlock/player/weapons/combine_mg/fire03.wav",
        "interlock/player/weapons/combine_mg/fire04.wav"
    },
})

SWEP.Base = "ls_base"

SWEP.PrintName = "Pulse Minigun"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_suppressor.mdl"
SWEP.ViewModel = "models/weapons/c_suppressor.mdl"
SWEP.ViewModelFOV = 70

SWEP.LowerAngles = Angle(10, -10, -10)
SWEP.LowerAngles2 = Angle(10, -10, -10)

SWEP.Slot = 2
SWEP.SlotPos = 73

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "ar2_reload_push.wav"
SWEP.EmptySound = "ar2_reload_rotate.wav"

SWEP.Primary.Sound = "ixPulseMinigun.Fire"
SWEP.Primary.Recoil = 0.4
SWEP.Primary.Damage = 16
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.03
SWEP.Primary.Delay = RPM(600)
SWEP.Primary.Tracer = "AR2Tracer"
SWEP.PenetrationScale = 5

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 130
SWEP.Primary.DefaultClip = 130

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.03
SWEP.Spread.IronsightsMod = 0.5
SWEP.Spread.CrouchMod = 0.5
SWEP.Spread.AirMod = 2
SWEP.Spread.RecoilMod = 0.2
SWEP.Spread.VelocityMod = 2

SWEP.UseIronsightsRecoil = true
SWEP.ViewModelOffset = Vector(1, 0, -2)

SWEP.IronsightsPos = Vector(-3.8, -5, -0.6)
SWEP.IronsightsAng = Angle(2.494, 2.138, -8.811)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.6
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 4

function SWEP:PrimaryAttack()
    if not self:CanShoot() then return end

    local clip = self:Clip1()

    if self.Primary.Burst and clip >= 3 then
        self:SetBursting(true)
        self.Burst = 3

        local delay = CurTime() + ((self.Primary.Delay * 3) + (self.Primary.BurstEndDelay or 0.3))
        self:SetNextPrimaryFire(delay)
        self:SetReloadTime(delay)
    elseif clip >= 1 then
        self:TakePrimaryAmmo(1)

        self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self:CalculateSpread())

        self:AddRecoil()
        self:ViewPunch()

        self:EmitSound(self.Primary.Sound)

        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        self:SetReloadTime(CurTime() + self.Primary.Delay)
    else
        self:EmitSound(self.EmptySound)
        self:Reload()
        self:SetNextPrimaryFire(CurTime() + 1)
    end
end