AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base_shotgun"

SWEP.PrintName = "Bolt Action Rifle"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_boltrifle.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_boltrifle.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadShellSound = "darky_rust.bolt-rifle-deploy"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "darky_rust.bolt-rifle-attack"
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 38
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = RPM(60)
SWEP.PenetrationScale = 3

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0 -- multiply
SWEP.Spread.CrouchMod = 0 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 2 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-3.582, -5, 2.579)
SWEP.IronsightsAng = Angle(-0.52, 1, 0)
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
