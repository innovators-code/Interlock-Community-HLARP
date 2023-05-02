
local PLUGIN = PLUGIN

PLUGIN.name = "Rappelling"
PLUGIN.description = "Adds rappelling gear into the Schema."
PLUGIN.author = "wowm0d"
PLUGIN.license = [[
Copyright 2022 wowm0d
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
]]

ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

function PLUGIN:StartRappel(ply)
    ply.rappelling = true
    ply.rappelPos = ply:GetPos()

    if ( SERVER ) then
        self:CreateRope(ply)
    end
end

function PLUGIN:EndRappel(ply)
    ply.rappelling = nil

    if ( SERVER ) then
        self:RemoveRope(ply)
    end
end
