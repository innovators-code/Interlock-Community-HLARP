--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Intro System"
PLUGIN.description = "A system for introducing players to the server."
PLUGIN.author = "Riggs.mackay, Scotnay"

-- Define tables
ix.intro = ix.intro or {}
ix.intro.config = ix.intro.config or {}

ix.intro.config.transitionSounds = {
    "interlock/startup/amb_startup_boomlight_01.ogg",
    "interlock/startup/amb_startup_boomlight_02.ogg",
    "interlock/startup/amb_startup_boomlight_03.ogg",
    "interlock/startup/amb_startup_boomlight_04.ogg",
    "interlock/startup/amb_startup_boomlight_05.ogg",
    "interlock/startup/amb_startup_boomlight_06.ogg",
    "interlock/startup/amb_startup_boomlight_07.ogg",
    "interlock/startup/amb_startup_boomlight_08.ogg",
    "interlock/startup/amb_startup_boomlight_09.ogg",
    "interlock/startup/amb_startup_boomlight_10.ogg",
    "interlock/startup/amb_startup_boomlight_11.ogg",
}

-- Map Config for Intro System
ix.util.IncludeDir(PLUGIN.folder.."/maps", true)

-- Include Core Files for Intro System, don't touch these files.
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")