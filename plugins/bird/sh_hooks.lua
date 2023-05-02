local PLUGIN = PLUGIN

function PLUGIN:SetupMove(ply, mv, cmd)
    if ( ply:Team() == FACTION_BIRD and not ply:OnGround() ) then
        local speed = ix.config.Get("birdFlightSpeed", 50)
        local angs = mv:GetAngles()
        if ( cmd:KeyDown(IN_JUMP) ) then
            angs.p = -30
            mv:SetVelocity(angs:Forward() * (200 * ((speed / 100) + 1)))
        elseif ( cmd:KeyDown(IN_DUCK) ) then
            angs.p = 30
            mv:SetVelocity(angs:Forward() * (200 * ((speed / 100) + 1)))
        else
            angs.p = 10
            mv:SetVelocity(angs:Forward() * (250 * ((speed / 100) + 1)))
        end
    end
end

function PLUGIN:GetPlayerPainSound(ply)
    if ( ply:Team() == FACTION_BIRD ) then
        return "npc/crow/pain"..math.random(1,2)..".wav"
    end
end

function PLUGIN:GetPlayerDeathSound(ply)
    if ( ply:Team() == FACTION_BIRD ) then
        return "npc/crow/die"..math.random(1,2)..".wav"
    end
end

local randomBirdWords = {
    "Chirp",
    "Caw",
    "Squawk",
    "Cheep",
}
function PLUGIN:PlayerMessageSend(ply, chatType, text, anonymous, receivers, rawText)
    if ( ply and IsValid(ply) and ply:Team() == FACTION_BIRD ) then
        if ( chatType == "ic" or chatType == "w" or chatType == "y" ) then
            return table.Random(randomBirdWords)
        end
    end
end