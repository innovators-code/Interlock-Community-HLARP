AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "Weapon_Glock.Fire",
    channel = CHAN_USER_BASE + 10,
    volume = 1.0,
    sound = "eftglock/glock17fire.wav",
})

SWEP.Base = "ls_base"

SWEP.PrintName = "Glock 17"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "revolver"

SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.ViewModel = "models/weapons/c_glock.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(10, -10, -10)
SWEP.LowerAngles2 = Angle(10, -10, -10)

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "eftglock/glock17reload.wav"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "Weapon_Glock.Fire"
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.015
SWEP.Primary.Delay = RPM(600)

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

SWEP.DoEmptyReloadAnim = true
SWEP.UseIronsightsRecoil = false
SWEP.ViewModelOffset = Vector(0, 0, 0)

SWEP.IronsightsPos = Vector(-3.26, -8.04, 1.08)
SWEP.IronsightsAng = Angle(1.406, 2.65, 0.7)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.5

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.1
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.3
