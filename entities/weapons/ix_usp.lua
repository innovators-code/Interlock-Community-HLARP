AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "Weapon_RTBusp.MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_mag_out_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.MagRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_mag_release_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_mag_in_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.MagFutz",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_mag_futz_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.SlidePull",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_slide_pull_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.SlideRelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_slide_release_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.Draw",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rtbusp/pistol_draw_01.wav"
})

sound.Add({
    name = "Weapon_RTBusp.Fire",
    channel = CHAN_USER_BASE + 10,
    volume = 1.0,
    sound = {
        "weapons/rtbusp/pistol_fire_player_01.wav",
        "weapons/rtbusp/pistol_fire_player_02.wav",
        "weapons/rtbusp/pistol_fire_player_03.wav",
        "weapons/rtbusp/pistol_fire_player_04.wav",
        "weapons/rtbusp/pistol_fire_player_05.wav",
        "weapons/rtbusp/pistol_fire_player_06.wav",
    }
})

SWEP.Base = "ls_base"

SWEP.PrintName = "USP Match"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "revolver"

SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModel = "models/weapons/c_rtb_usp.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles = Angle(0, -5, -5)
SWEP.LowerAngles2 = Angle(0, -5, -5)

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_Pistol.Reload"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "Weapon_RTBusp.Fire"
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
SWEP.ViewModelOffset = Vector(0, 0, 1)

SWEP.IronsightsPos = Vector(-3.438, -5, 1.579)
SWEP.IronsightsAng = Angle(0.137, -0.758, 1.473)
SWEP.IronsightsFOV = 0.9
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1.5

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.1
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.3

SWEP.Attachments = {
    suppressor = {
        Cosmetic = {
            Model = "models/weapons/tfa_ins2/upgrades/a_suppressor_sec.mdl",
            Bone = "Barrel",
            Pos = Vector(0, 5.5, 0.35),
            Ang = Angle(0, -90, 0),
            Scale = 0.5,
            Skin = 0,
            Material = "",
        },
        ModSetup = function(e)
            e.Primary.Sound = "weapons/usp/usp1.wav"
            e.Primary.Recoil = 0.2
            e.Primary.Damage = 3
            e.Primary.Cone = 0 -- laser beam
            e.IronsightsRecoilPitchMultiplier = 2
        end,
        ModCleanup = function(e)
            e.Primary.Sound = "Weapon_RTBusp.Fire"
            e.Primary.Recoil = 0.6
            e.Primary.Damage = 9
            e.Primary.Cone = 0.018
            e.IronsightsRecoilPitchMultiplier = 0.3
        end,
        NeedsHDR = false,
        Behaviour = "suppressor",
    },
}