AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "Weapon_Sandstorm_MP7_1",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/m9_fp.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7_2",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/m9_suppressed_fp.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_empty.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7_1",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/m9_fp.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7_2",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/m9_suppressed_fp.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Empty",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_empty.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magrelease.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magin.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magout.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_boltback.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_boltrelease.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magrelease.wav"
})
sound.Add({
    name = "Weapon_Sandstorm_MP7.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magrelease.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magin.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magout.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Boltback",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_boltback.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Boltrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_boltrelease.wav"
})

sound.Add({
    name = "Weapon_Sandstorm_MP7.Magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_magrelease.wav"
})

SWEP.Base = "ls_base"

SWEP.PrintName = "MP7"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "smg"

SWEP.WorldModel = "models/weapons/w_mp7_sandstorm.mdl"
SWEP.ViewModel = "models/weapons/v_mp7_sandstorm.mdl"
SWEP.ViewModelFOV = 55

SWEP.LowerAngles = Angle(5, -5, -5)
SWEP.LowerAngles2 = Angle(5, -5, -5)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_SMG1.Reload"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "weapons/tfa_ins_sandstorm_mp7/mp5k_fp.wav"
SWEP.Primary.Recoil = 0.18 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 9.4
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.038
SWEP.Primary.Delay = RPM(875)

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.95 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.1 -- movement speed effect on spread (additonal)

SWEP.DoEmptyReloadAnim = true
SWEP.ViewModelOffset = Vector(1, 0, -1)

SWEP.IronsightsPos = Vector(-3.03, 0, 1.6)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.2
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.5

SWEP.UseIronsightsRecoil = true

if ( CLIENT ) then
    local WorldModel = ClientsideModel(SWEP.WorldModel)

    WorldModel:SetSkin(0)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if ( IsValid(_Owner) ) then
            local offsetVec = Vector(4, -2, -3)
            local offsetAng = Angle(10, 0, 180)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if not ( boneid ) then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not ( matrix ) then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(1.3)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end