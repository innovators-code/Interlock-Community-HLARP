FACTION.name = "Dispatch"
FACTION.description = "An Administration AI."
FACTION.color = Color(30, 70, 230)
FACTION.isDefault = false

FACTION.models = {"models/player/combine_soldier_prisonguard.mdl"}

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

function FACTION:GetDefaultName(ply)
    return "OW:c3.SCN", true
end

function FACTION:OnTransfered(ply)
    local char = ply:GetCharacter()

    char:SetName(self:GetDefaultName())
    char:SetModel(self.models[1])
end

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
end

FACTION_DISPATCH = FACTION.index
