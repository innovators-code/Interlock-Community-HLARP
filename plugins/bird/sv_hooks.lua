local PLUGIN = PLUGIN

function PLUGIN:PrePlayerLoadedCharacter(ply, character, currentChar)
    if ( IsValid(currentChar) and not currentChar:GetFaction() == FACTION_BIRD ) then return end
    ply:ResetHull()
end

function PLUGIN:PlayerSpawn(ply)
    if ( ply:Team() == FACTION_BIRD ) then
        timer.Simple(.1, function()
            ply:SetWalkSpeed(25)
            ply:SetRunSpeed(50)
            ply:SetMaxHealth(ix.config.Get("birdHealth", 2))
            ply:SetHealth(ix.config.Get("birdHealth", 2))
            ply:Give("ix_bird")
            ply:StripWeapon("ix_hands")
            ply:StripWeapon("ix_keys")
        end)
    end
end

function PLUGIN:CanPlayerDropItem(ply, item)
    if ( ply:Team() == FACTION_BIRD ) and !ix.config.Get("birdAllowItemInteract", true) then
        return false
    end
end

function PLUGIN:CanPlayerTakeItem(ply, item)
    if ( ply:Team() == FACTION_BIRD ) and !ix.config.Get("birdAllowItemInteract", true) then
        return false
    end
end