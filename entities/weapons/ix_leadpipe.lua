AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Lead Pipe"
SWEP.Category = "IX:HLA RP"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "melee"

SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.ViewModel = "models/weapons/hl2meleepack/v_pipe.mdl"
SWEP.ViewModelFOV = 65

SWEP.Slot = 0
SWEP.SlotPos = 3

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "WeaponFrag.Roll"
SWEP.Primary.ImpactSound = "Canister.ImpactHard"
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.15
SWEP.Primary.Delay = 0.5
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

function SWEP:PrePrimaryAttack()
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("misscenter1"))
end
