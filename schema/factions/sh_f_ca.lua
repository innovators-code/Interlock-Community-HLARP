FACTION.name = "City Administrator"
FACTION.description = "The administrator of the City."
FACTION.color = Color(30, 180, 110)
FACTION.isDefault = false

FACTION.models = {"models/player/breen.mdl"}

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
end

FACTION_CA = FACTION.index