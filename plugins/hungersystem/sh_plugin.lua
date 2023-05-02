local PLUGIN = PLUGIN

PLUGIN.name = "Hunger System"
PLUGIN.author = "Riggs.mackay"
PLUGIN.description = "Adds a Hunger System, simliar to the Apex Gamemode."

ix.config.Add("hungerTime", 300, "How many seconds between each time a player's needs are calculated", nil, {
    data = {min = 60, max = 1800},
    category = "Hunger System"
})

ix.char.RegisterVar("hunger", {
    field = "hunger",
    fieldType = ix.type.number,
    default = 100,
    isLocal = true,
    bNoDisplay = true
})

ix.util.Include("sv_hooks.lua")

ix.command.Add("CharSetHunger", {
    description = "Set character's hunger",
    adminOnly = true,
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        char:SetHunger(level or 100)
        ply:Notify(char:GetName().."'s hunger was set to "..( level or 100 ))
    end
})

ix.command.Add("SetHunger", {
    description = "Set character's hunger",
    adminOnly = true,
    arguments = {ix.type.character, bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, char, level)
        char:SetHunger(level or 100)
        ply:Notify(char:GetName().."'s hunger was set to "..( level or 100 ))
    end
})

local stoveEntities = {
    ["ix_barrel"] = true,
    ["ix_bucket"] = true,
    ["ix_stove"] = true,
}

local ENTITY = FindMetaTable("Entity")
function ENTITY:IsStove()
    return stoveEntities[self:GetClass()]
end


if ( CLIENT ) then
    PLUGIN.fire = Material("particles/fire1") 
    PLUGIN.nextFrame = CurTime()
    PLUGIN.curFrame = 0

    function PLUGIN:Think()
        if ( PLUGIN.nextFrame < CurTime() ) then
            PLUGIN.nextFrame = CurTime() + 0.05 * ( 1 - FrameTime() )
            PLUGIN.curFrame = PLUGIN.curFrame + 1
            PLUGIN.fire:SetFloat("$frame", PLUGIN.curFrame % 22)
        end
    end
end