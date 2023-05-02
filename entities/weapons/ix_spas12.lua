AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "TFA_INS2_SPAS12.1",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/fire.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.2",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/m590_suppressed_fp.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.Draw",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {"weapons/tfa_ins2/spas12/uni_weapon_draw_01.wav", "weapons/tfa_ins2/spas12/uni_weapon_draw_02.wav", "weapons/tfa_ins2/spas12/uni_weapon_draw_03.wav"},
})

sound.Add({
    name = "TFA_INS2_SPAS12.Holster",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/uni_weapon_holster.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.Boltback",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/PumpBack.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.Boltrelease",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/PumpForward.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.ShellInsert",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {"weapons/tfa_ins2/spas12/insertshell-1.wav", "weapons/tfa_ins2/spas12/insertshell-2.wav", "weapons/tfa_ins2/spas12/insertshell-3.wav"},
})

sound.Add({
    name = "TFA_INS2_SPAS12.ShellInsertSingle",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {"weapons/tfa_ins2/spas12/insertshell-1.wav", "weapons/tfa_ins2/spas12/insertshell-2.wav", "weapons/tfa_ins2/spas12/insertshell-3.wav"},
})

sound.Add({
    name = "TFA_INS2_SPAS12.Empty",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/m590_empty.wav",
})

sound.Add({
    name = "TFA_INS2_SPAS12.IronIn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = {"weapons/tfa_ins2/spas12/uni_ads_in_01.wav", "weapons/tfa_ins2/spas12/uni_ads_in_02.wav", "weapons/tfa_ins2/spas12/uni_ads_in_03.wav", "weapons/tfa_ins2/spas12/uni_ads_in_04.wav", "weapons/tfa_ins2/spas12/uni_ads_in_05.wav", "weapons/tfa_ins2/spas12/uni_ads_in_06.wav"},
})

sound.Add({
    name = "TFA_INS2_SPAS12.IronOut",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "weapons/tfa_ins2/spas12/uni_ads_out_01.wav",
})

SWEP.Base = "ls_base_shotgun"

SWEP.PrintName = "SPAS-12"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "shotgun"

SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ViewModel = "models/weapons/tfa_ins2/c_spas12_bri.mdl"
SWEP.ViewModelFOV = 60

SWEP.LowerAngles = Angle(10, -5, -5)
SWEP.LowerAngles2 = Angle(10, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadShellSound = "Weapon_Shotgun.Reload"
SWEP.EmptySound = "Weapon_Shotun.Empty"

SWEP.Primary.Sound = "TFA_INS2_SPAS12.1"
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 9
SWEP.Primary.NumShots = 12
SWEP.Primary.Cone = 0.069
SWEP.Primary.Delay = RPM(80)
SWEP.PenetrationScale = 2

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.DoEmptyReloadAnim = false

SWEP.Spread = {}
SWEP.Spread.Min = 0.069
SWEP.Spread.Max = 0.2
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.ViewModelOffset = Vector(1, 3, -2)

SWEP.IronsightsPos = Vector(-3.619, -5, 2.857)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15