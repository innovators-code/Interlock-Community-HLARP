AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

SWEP.Base = "ls_base"

SWEP.PrintName = "357 Magnum"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "revolver"

SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles2 = Angle(0, -5, -7)

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_357.Reload"
SWEP.EmptySound = "Weapon_357.Empty"

SWEP.Primary.Sound = "Weapon_357.Single"
SWEP.Primary.Recoil = 4.8 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = RPM(60)

SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.9 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.03 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.7, 0, 0.56)
SWEP.IronsightsAng = Angle(0.2, -0.201, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2