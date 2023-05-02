AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Scrap AK"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.ViewModelFOV = 70

SWEP.LowerAngles = Angle(15, -10, -7)
SWEP.LowerAngles2 = Angle(15, -10, -7)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "darky_rust.ak74u-deploy"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "darky_rust.ak74u-attack"
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(450)

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.7 -- multiply
SWEP.Spread.CrouchMod = 0.8 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.1 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-6.115, -6.896, 3.703)
SWEP.IronsightsAng = Angle(-0.3, 0.012, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.2
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.3

SWEP.UseIronsightsRecoil = true