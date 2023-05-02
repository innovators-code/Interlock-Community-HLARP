FACTION.name = "Bird"
FACTION.description = "A regular bird surviving on scrap and food."
FACTION.color = Color(128, 128, 128, 255)
FACTION.isDefault = false

FACTION.models = {
    "models/crow.mdl",
    "models/pigeon.mdl",
}

function FACTION:OnSpawn(ply)
    local char = ply:GetCharacter()
    local inventory = char:GetInventory()
    timer.Simple(0.1, function()
        local hull = Vector(10, 10, 10)
        ply:SetHull(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
        ply:SetHullDuck(-Vector(hull.x / 2, hull.y / 2, 0), Vector(hull.x / 2, hull.y / 2, hull.z))
        ply:SetViewOffset(Vector(0, 0, 10))
        ply:SetViewOffsetDucked(Vector(0, 0, 10))
        ply:SetCurrentViewOffset(Vector(0, 10, 0))
        if ( ix.config.Get("birdInventory", true) ) then
            inventory:SetSize(2, 1)
        end
        if ( CLIENT ) then return end
        ply:SetWalkSpeed(25)
        ply:SetRunSpeed(50)
        ply:SetMaxHealth(ix.config.Get("birdHealth", 2))
        ply:SetHealth(ix.config.Get("birdHealth", 2))
        ply:Give("ix_bird")
        ply:StripWeapon("ix_hands")
    end)
end

FACTION_BIRD = FACTION.index