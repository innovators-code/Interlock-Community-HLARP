AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Semi Automatic Rifle"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_sar.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_sar.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "darky_rust.sar-deploy"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "darky_rust.sar-attack"
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.038
SWEP.Primary.Delay = RPM(343)

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.2
SWEP.Spread.IronsightsMod = 0.3 -- multiply
SWEP.Spread.CrouchMod = 0.6 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.1 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-5.18, -2.985, 2.519)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.3

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.1

SWEP.UseIronsightsRecoil = true
