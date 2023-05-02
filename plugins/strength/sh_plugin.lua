local PLUGIN = PLUGIN

PLUGIN.name = "Strength"
PLUGIN.description = "Adds a strength."
PLUGIN.author = "Chessnut"

if ( SERVER ) then
    function PLUGIN:GetPlayerPunchDamage(ply, damage, context)
        if ( ply:GetCharacter() ) then
            context.damage = context.damage + ( ply:GetCharacter():GetAttribute("attribute_strength", 0) * ix.config.Get("strengthMultiplier") )
        end
    end

    function PLUGIN:PlayerThrowPunch(ply, trace)
        if ( ply:GetCharacter() and IsValid(trace.Entity) and trace.Entity:IsPlayer() ) then
            ply:GetCharacter():UpdateAttrib("attribute_strength", 0.001)
        end
    end
end

ix.config.Add("strengthMultiplier", 0.3, "The strength multiplier scale", nil, {
    data = {min = 0, max = 1.0, decimals = 1},
    category = "Strength"
})