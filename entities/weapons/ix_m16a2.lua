AddCSLuaFile()

local function RPM(rpm)
    return 60 / rpm
end

sound.Add({
    name = "bocw_m16.magout",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/bocw_m16/m16_magout.wav"
})

sound.Add({
    name = "bocw_m16.magin",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/bocw_m16/m16_magin.wav"
})

sound.Add({
    name = "bocw_m16.boltback",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/bocw_m16/m16_boltback.wav"
})
sound.Add({
    name = "bocw_m16.boltrelease",
    channel = CHAN_ITEM,
    volume = VOL_NORM,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/bocw_m16/m16_boltrelease.wav"
})

SWEP.Base = "ls_base"

SWEP.PrintName = "M16A2"
SWEP.Category = "IX:HLA RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "ar2"

SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModel = "models/weapons/v_bocw_m16.mdl"
SWEP.ViewModelFOV = 70

SWEP.LowerAngles = Angle(15, -10, -7)
SWEP.LowerAngles2 = Angle(15, -10, -7)

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = "Weapon_SMG1.Reload"
SWEP.EmptySound = "Weapon_Pistol.Empty"

SWEP.Primary.Sound = "weapons/bocw_m16/wz_fire.wav"
SWEP.Primary.Recoil = 0.2
SWEP.Primary.Damage = 15
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.016
SWEP.Primary.Delay = RPM(700)

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20

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
SWEP.ViewModelOffset = Vector(1, 1, 0)

SWEP.IronsightsPos = Vector(-4.641, 0, 0.4)
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
    local WorldModel = ClientsideModel("models/weapons/w_bocw_m16.mdl")

    WorldModel:SetSkin(0)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if ( IsValid(_Owner) ) then
            local offsetVec = Vector(4, -1, -6)
            local offsetAng = Angle(0, 0, 180)
            
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

SWEP.Attachments = {
    extendedmagazine = {
        ModSetup = function(e)
            e.Primary.ClipSize = 30
            e.Primary.DefaultClip = 30
            e.Primary.Cone = 0.026
        end,
        ModCleanup = function(e)
            e.Primary.ClipSize = 20
            e.Primary.DefaultClip = 20
            e.Primary.Cone = 0.016
        end,
        NeedsHDR = false,
        Behaviour = "magazine",
    },
}