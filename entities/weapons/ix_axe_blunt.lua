AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Blunt Axe"
SWEP.Category = "IX:HLA RP"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "melee2"

SWEP.WorldModel = "models/weapons/hl2meleepack/w_axe.mdl"
SWEP.ViewModel = "models/weapons/hl2meleepack/v_axe.mdl"
SWEP.ViewModelFOV = 65

SWEP.Slot = 0
SWEP.SlotPos = 3

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = "WeaponFrag.Roll"
SWEP.Primary.ImpactSound = "Canister.ImpactHard"
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Delay = 0.9
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

function SWEP:PrePrimaryAttack()
    local vm = self.Owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("misscenter1"))
end

function SWEP:MeleeHitFallback(tr)
    if ( tr ) then
        local ent = tr.Entity
        if ( IsValid(ent) and ent:GetClass() == "ix_mining_tree" ) then
            ent:SetNWInt("ixHits", ent:GetNWInt("ixHits") + 1)
            if ( ent:GetNWInt("ixHits", 0) >= 7 ) then
                if not ( self:GetOwner():GetCharacter():GetInventory():Add("crafting_wood") ) then
                    self:GetOwner():Notify("You don't have the space to hold wood.")
                    ix.item.Spawn("crafting_wood", tr.HitPos)
                else
                    self:GetOwner():Notify("You have gained a piece of wood.")
                end
                ent:SetNWInt("ixHits", 0)
                ent:EmitSound("physics/wood/wood_box_break"..math.random(1,2)..".wav")
            else
                ent:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1,5)..".wav")
                if ( ent:GetNWInt("ixHits", 0) == 1 ) then
                    self:GetOwner():Notify("6 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 2 ) then
                    self:GetOwner():Notify("5 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 3 ) then
                    self:GetOwner():Notify("4 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 4 ) then
                    self:GetOwner():Notify("3 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 5 ) then
                    self:GetOwner():Notify("2 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 6 ) then
                    self:GetOwner():Notify("1 hit remaining.")
                end
            end
        end
    end
end