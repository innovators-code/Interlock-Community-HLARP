AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "Weapon_danger_akm_rifle.deploy",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_deploy.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.magrelease",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_magrelease.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.Magout",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_magout.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.Magin",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_magin.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.bolt",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_boltback.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.bolt2",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/ak47_boltrelease.wav"
})

sound.Add({
    name = "Weapon_danger_akm_rifle.rattle",
    channel = CHAN_ITEM,
    volume = 1.0,
    sound = "weapons/rifle_rattle.wav"
})

SWEP.Base = "ls_base"

SWEP.PrintName = "AKM"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/w_akm_inss.mdl"
SWEP.ViewModel = "models/weapons/v_akm_inss.mdl"
SWEP.ViewModelFOV = 70

SWEP.LowerAngles = Angle(15, -10, -7)
SWEP.LowerAngles2 = Angle(15, -10, -7)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_SMG1.Reload"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "weapons/ins_ak47.wav"
SWEP.Primary.Recoil = 0.2
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.028
SWEP.Primary.Delay = RPM(600)

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
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.95 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.1 -- movement speed effect on spread (additonal)

SWEP.DoEmptyReloadAnim = true
SWEP.ViewModelOffset = Vector(1, 0, -1)

SWEP.IronsightsPos = Vector(-3.79, 0, 1.51)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.8
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 4

SWEP.IronsightsRecoilRecoveryRate = 1
SWEP.IronsightsRecoilYawTarget = 0
SWEP.IronsightsRecoilYawMax = 0.2
SWEP.IronsightsRecoilYawMin = 0
SWEP.IronsightsRecoilPitchMultiplier = 0.2

SWEP.UseIronsightsRecoil = true

if ( CLIENT ) then
    local WorldModel = ClientsideModel(SWEP.WorldModel)

    WorldModel:SetSkin(0)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if ( IsValid(_Owner) ) then
            local offsetVec = Vector(14, -2, 1)
            local offsetAng = Angle(20, 0, 180)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if not ( boneid ) then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not ( matrix ) then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(1)

            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end