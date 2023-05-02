AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "ixOrdRifle.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {
        "interlock/player/weapons/combine_ar/fire01.wav",
        "interlock/player/weapons/combine_ar/fire02.wav",
        "interlock/player/weapons/combine_ar/fire03.wav",
        "interlock/player/weapons/combine_ar/fire04.wav",
    },
})

SWEP.Base = "ls_base"

SWEP.PrintName = "Pulse Carbine"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/w_ordinalrifle.mdl"
SWEP.ViewModel = "models/weapons/c_ordinalrifle.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(5, -10, -10)
SWEP.LowerAngles2 = Angle(5, -10, -10)

SWEP.Slot = 2
SWEP.SlotPos = 70

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "ar2_reload_push.wav"
SWEP.EmptySound = "ar2_reload_rotate.wav"

SWEP.Primary.Sound = "ixOrdRifle.Fire"
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 22
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Delay = RPM(400)
SWEP.Primary.Tracer = "AR2Tracer"
SWEP.PenetrationScale = 1.5

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.03
SWEP.Spread.IronsightsMod = 0.5
SWEP.Spread.CrouchMod = 0.5
SWEP.Spread.AirMod = 1.4
SWEP.Spread.RecoilMod = 0.1
SWEP.Spread.VelocityMod = 0.16

SWEP.UseIronsightsRecoil = false

SWEP.IronsightsPos = Vector(-3.175, 5, 0)
SWEP.IronsightsAng = Angle(1.417, 0, 0)
SWEP.IronsightsFOV = 0.65
SWEP.IronsightsSensitivity = 0.6
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 1
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"
