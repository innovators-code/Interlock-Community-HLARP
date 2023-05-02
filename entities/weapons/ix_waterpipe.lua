AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "Waterpipe Shotgun"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_waterpipe.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_waterpipe.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(10, -5, -5)
SWEP.LowerAngles2 = Angle(10, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadShellSound = "darky_rust.waterpipe-shotgun-deploy"
SWEP.EmptySound = "Weapon_Shotun.Empty"

SWEP.Primary.Sound = "darky_rust.waterpipe-shotgun-attack"
SWEP.Primary.Recoil = 5
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 12
SWEP.Primary.Cone = 0.069
SWEP.Primary.Delay = RPM(80)

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.1
SWEP.Spread.Max = 1
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-5.16, -2.421, 2.68)
SWEP.IronsightsAng = Angle(2.338, 0.975, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15