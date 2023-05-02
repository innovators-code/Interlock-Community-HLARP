local PLUGIN = PLUGIN

local factionIgnore = {
    [FACTION_OTA] = true,
    [FACTION_DISPATCH] = true,
    [FACTION_EVENT] = true,
}
function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( char ) and ( timer.Exists(char:GetID()..".HungerTimer") ) then
        timer.Remove(char:GetID()..".HungerTimer")
    end

    if ( oldChar ) and ( timer.Exists(oldChar:GetID()..".HungerTimer") ) then
        timer.Remove(oldChar:GetID()..".HungerTimer")
    end

    timer.Simple(0, function()
        if not ( ply:IsValid() or ply:Alive() or char ) then return end
        if ( factionIgnore[char:GetFaction()] ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

        timer.Create(char:GetID()..".HungerTimer", ix.config.Get("hungerTime", 120), 0, function()
            if not ( ply:IsValid() or ply:Alive() ) then return end
            if ( factionIgnore[char:GetFaction()] ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

            if ( char:GetHunger() == 0 ) then
                ply:TakeDamage(5)
                ply:EmitSound("npc/barnacle/barnacle_digesting"..math.random(1,2)..".wav", 50, 100, 0.5)
            else
                local amount = 1
                if ( ply:KeyDown(IN_SPEED) ) then
                    amount = amount * 2
                end
                char:SetHunger(math.Clamp(char:GetHunger() - amount, 0, 100))
            end
        end)
    end)
end

function PLUGIN:PlayerDisconnected(ply)
    local char = ply:GetCharacter()
    if ( char ) and ( timer.Exists(char:GetID()..".HungerTimer") ) then
        timer.Remove(char:GetID()..".HungerTimer")
    end
end