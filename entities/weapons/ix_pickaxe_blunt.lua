AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Blunt Pickaxe"
SWEP.Category = "IX:HLA RP"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "melee2"

SWEP.WorldModel = "models/weapons/hl2meleepack/w_pickaxe.mdl"
SWEP.ViewModel = "models/weapons/hl2meleepack/v_pickaxe.mdl"
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
SWEP.Primary.Delay = 0.8
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

function SWEP:PrePrimaryAttack()
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("misscenter1"))
end

function SWEP:MeleeHitFallback(tr)
    if ( tr ) then
        local ent = tr.Entity
        if ( IsValid(ent) and ent:GetClass() == "ix_mining_rock" ) then
            ent:SetNWInt("ixHits", ent:GetNWInt("ixHits") + 1)
            if ( ent:GetNWInt("ixHits", 0) >= 13 ) then
                if ( math.random(1,5) == 1 ) then
                    if not ( self:GetOwner():GetCharacter():GetInventory():Add("crafting_metalore") ) then
                        self:GetOwner():Notify("You don't have the space to hold metal ore.")
                        ix.item.Spawn("crafting_metalore", tr.HitPos)
                    else
                        self:GetOwner():Notify("You have gained metal ore.")
                    end
                else
                    if not ( self:GetOwner():GetCharacter():GetInventory():Add("crafting_rock") ) then
                        self:GetOwner():Notify("You don't have the space to hold stone.")
                        ix.item.Spawn("crafting_rock", tr.HitPos)
                    else
                        self:GetOwner():Notify("You have gained stone.")
                    end
                end
                ent:SetNWInt("ixHits", 0)
                ent:EmitSound("physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav")
            else
                ent:EmitSound("physics/concrete/concrete_impact_hard"..math.random(1,3)..".wav")
                if ( ent:GetNWInt("ixHits", 0) == 1 ) then
                    self:GetOwner():Notify("12 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 2 ) then
                    self:GetOwner():Notify("11 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 3 ) then
                    self:GetOwner():Notify("10 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 4 ) then
                    self:GetOwner():Notify("9 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 5 ) then
                    self:GetOwner():Notify("8 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 6 ) then
                    self:GetOwner():Notify("7 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 7 ) then
                    self:GetOwner():Notify("6 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 8 ) then
                    self:GetOwner():Notify("5 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 9 ) then
                    self:GetOwner():Notify("4 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 10 ) then
                    self:GetOwner():Notify("3 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 11 ) then
                    self:GetOwner():Notify("2 hits remaining.")
                elseif ( ent:GetNWInt("ixHits", 0) == 12 ) then
                    self:GetOwner():Notify("1 hit remaining.")

                end
            end
        end
    end
end