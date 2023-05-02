local PLUGIN = PLUGIN

PLUGIN.name = "Sanity"
PLUGIN.author = "Scotnay"
PLUGIN.description = "Adds in a simple sanity system that can effect how you perceive the world!"

ix.util.Include( "cl_hooks.lua" )
ix.util.Include( "sv_hooks.lua" )
ix.util.Include( "sh_meta.lua" )

PLUGIN.noSanity = {
    [FACTION_OTA] = true,
    [FACTION_DISPATCH] = true,
    [FACTION_EVENT] = true,
}

function PLUGIN:CheckSanity( character )
    local faction = character:GetFaction()
    return PLUGIN.noSanity[ faction ]
end

function Schema:CheckSanity( character )
    local faction = character:GetFaction()
    return PLUGIN.noSanity[ faction ]
end

ix.command.Add("SetSanity", {
    adminOnly = true,
    description = "Set the sanity of a character.",
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, target, sanity)
        target:SetSanity(sanity or 100)
    end
})
