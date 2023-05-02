FACTION.name = "Event Faction"
FACTION.description = ""
FACTION.color = Color(150, 100, 150, 255)
FACTION.isDefault = false

FACTION.models = {
    "models/kleiner.mdl"
}

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
end

FACTION_EVENT = FACTION.index