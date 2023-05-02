AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Tapping Kit"
SWEP.Category = "IX:HLA RP"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HoldType = "knife"

SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
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
SWEP.Primary.Delay = 1.3
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.3

function SWEP:PrePrimaryAttack()
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("stab_miss"))
end

function SWEP:MeleeHitFallback(tr)
    if ( tr ) then
        local ent = tr.Entity
        if ( IsValid(ent) and ent:GetClass() == "ix_mining_tree_rubber" ) then
            ent:SetNWInt("ixincisions", ent:GetNWInt("ixincisions") + 1)
            if ( ent:GetNWInt("ixincisions", 0) >= 18 ) then
                if not ( self:GetOwner():GetCharacter():GetInventory():Add("crafting_rubber_natural") ) then
                    self:GetOwner():Notify("You don't have the space to hold a container of natural rubber.")
                    ix.item.Spawn("crafting_rubber_natural", tr.HitPos)
                else
                    self:GetOwner():Notify("You have gained a container worth of natural rubber.")
                end
                ent:SetNWInt("ixincisions", 0)
                ent:EmitSound("physics/wood/wood_box_break"..math.random(1,2)..".wav")
            else
                ent:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1,5)..".wav")
                if ( ent:GetNWInt("ixincisions", 0) == 1 ) then
                    self:GetOwner():Notify("17 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 2 ) then
                    self:GetOwner():Notify("16 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 3 ) then
                    self:GetOwner():Notify("15 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 4 ) then
                    self:GetOwner():Notify("14 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 5 ) then
                    self:GetOwner():Notify("13 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 6 ) then
                    self:GetOwner():Notify("12 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 7 ) then
                    self:GetOwner():Notify("11 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 8 ) then
                    self:GetOwner():Notify("10 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 9 ) then
                    self:GetOwner():Notify("9 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 10 ) then
                    self:GetOwner():Notify("8 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 11 ) then
                    self:GetOwner():Notify("7 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 12 ) then
                    self:GetOwner():Notify("6 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 13 ) then
                    self:GetOwner():Notify("5 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 14 ) then
                    self:GetOwner():Notify("4 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 15 ) then
                    self:GetOwner():Notify("3 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 16 ) then
                    self:GetOwner():Notify("2 incisions remaining.")
                elseif ( ent:GetNWInt("ixincisions", 0) == 17 ) then
                    self:GetOwner():Notify("1 incision remaining.")
                end
            end
        end
    end
end
