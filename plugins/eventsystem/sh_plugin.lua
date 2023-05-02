--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Event System"
PLUGIN.description = "Creates a full Event System."
PLUGIN.author = "Riggs.mackay"

ix.event = ix.event or {}
ix.event.music = ix.event.music or {}
ix.event.ambient = ix.event.ambient or {}

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

--[[---------------------------------------------------------------------------
    Configuration
---------------------------------------------------------------------------]]--

ix.event.music = {}
ix.event.ambient = {
    ["Soundscapes"] = {
        {"Bighit Far 1", "interlock/ambient/soundscapes/bighit_far1.ogg"},
        {"Bighit Far 2", "interlock/ambient/soundscapes/bighit_far2.ogg"},
        {"Bighit Far 3", "interlock/ambient/soundscapes/bighit_far3.ogg"},
        {"Bighit Far 4", "interlock/ambient/soundscapes/bighit_far4.ogg"},
        {"Bighit Far 5", "interlock/ambient/soundscapes/bighit_far5.ogg"},
        {"Bighit Far 6", "interlock/ambient/soundscapes/bighit_far6.ogg"},
        {"Bighit Far 7", "interlock/ambient/soundscapes/bighit_far7.ogg"},
        {"Bighit Far 8", "interlock/ambient/soundscapes/bighit_far8.ogg"},
        {"Bighit Far 9", "interlock/ambient/soundscapes/bighit_far9.ogg"},
        {"Bighit Far 10", "interlock/ambient/soundscapes/bighit_far10.ogg"},
        {"Bighit Far 11", "interlock/ambient/soundscapes/bighit_far11.ogg"},
        {"Bighit Far 12", "interlock/ambient/soundscapes/bighit_far12.ogg"},
        {"Bighit Far 13", "interlock/ambient/soundscapes/bighit_far13.ogg"},
        {"Bighit Far 14", "interlock/ambient/soundscapes/bighit_far14.ogg"},
        {"Bighit Far 15", "interlock/ambient/soundscapes/bighit_far15.ogg"},
        {"Bighit Far 16", "interlock/ambient/soundscapes/bighit_far16.ogg"},
        {"Bighit Far 17", "interlock/ambient/soundscapes/bighit_far17.ogg"},
        {"Bighit Far 18", "interlock/ambient/soundscapes/bighit_far18.ogg"},
        {"Bighit Far 19", "interlock/ambient/soundscapes/bighit_far19.ogg"},
        {"Metal Creak 1", "interlock/ambient/soundscapes/metalcreak1.ogg"},
        {"Metal Creak 2", "interlock/ambient/soundscapes/metalcreak2.ogg"},
        {"Metal Creak 3", "interlock/ambient/soundscapes/metalcreak3.ogg"},
        {"Metal Creak 4", "interlock/ambient/soundscapes/metalcreak4.ogg"},
    },
    ["Combine"] = {
        {"Strider Distant 1", "interlock/ambient/combine/strider_distant_01.ogg"},
        {"Strider Distant 2", "interlock/ambient/combine/strider_distant_02.ogg"},
        {"Strider Distant 3", "interlock/ambient/combine/strider_distant_03.ogg"},
        {"Strider Distant 4", "interlock/ambient/combine/strider_distant_04.ogg"},
        {"Strider Distant 5", "interlock/ambient/combine/strider_distant_05.ogg"},
        {"Strider Distant 6", "interlock/ambient/combine/strider_distant_06.ogg"},
        {"Strider Distant 7", "interlock/ambient/combine/strider_distant_07.ogg"},
        {"Strider Distant 8", "interlock/ambient/combine/strider_distant_08.ogg"},
        {"Strider Distant 9", "interlock/ambient/combine/strider_distant_09.ogg"},
        {"Strider Distant 10", "interlock/ambient/combine/strider_distant_10.ogg"},
        {"Strider Distant 11", "interlock/ambient/combine/strider_distant_11.ogg"},
        {"Strider Distant 12", "interlock/ambient/combine/strider_distant_12.ogg"},
        {"Strider Distant 13", "interlock/ambient/combine/strider_distant_13.ogg"},
        {"Strider Distant 14", "interlock/ambient/combine/strider_distant_14.ogg"},
        {"Strider Distant 15", "interlock/ambient/combine/strider_distant_15.ogg"},
        {"Strider Distant 16", "interlock/ambient/combine/strider_distant_16.ogg"},
        {"Vault 1", "interlock/ambient/citadel/1.ogg"},
        {"Vault 2", "interlock/ambient/citadel/2.ogg"},
        {"Vault 3", "interlock/ambient/citadel/3.ogg"},
        {"Vault 4", "interlock/ambient/citadel/4.ogg"},
        {"Vault 5", "interlock/ambient/citadel/5.ogg"},
    },
    ["Creatures"] = {
        {"Moan Wet 1", "interlock/ambient/creatures/idle_moan_wet_01.ogg"},
        {"Moan Wet 2", "interlock/ambient/creatures/idle_moan_wet_02.ogg"},
        {"Moan Wet 3", "interlock/ambient/creatures/idle_moan_wet_03.ogg"},
        {"Moan Wet 4", "interlock/ambient/creatures/idle_moan_wet_04.ogg"},
        {"Moan Wet 5", "interlock/ambient/creatures/idle_moan_wet_05.ogg"},
        {"Moan Wet 6", "interlock/ambient/creatures/idle_moan_wet_06.ogg"},
        {"Moan Wet 7", "interlock/ambient/creatures/idle_moan_wet_07.ogg"},
        {"Moan Wet 8", "interlock/ambient/creatures/idle_moan_wet_08.ogg"},
        {"Moan Wet 9", "interlock/ambient/creatures/idle_moan_wet_09.ogg"},
        {"Moan Wet 10", "interlock/ambient/creatures/idle_moan_wet_10.ogg"},
        {"Moan Wet 11", "interlock/ambient/creatures/idle_moan_wet_11.ogg"},
        {"Moan Wet 12", "interlock/ambient/creatures/idle_moan_wet_12.ogg"},
        {"Moan Wet 13", "interlock/ambient/creatures/idle_moan_wet_13.ogg"},
        {"Moan Wet 14", "interlock/ambient/creatures/idle_moan_wet_14.ogg"},
    },
    ["Distant Exterior"] = {
        {"Machine Gun 1", "interlock/ambient/gunfire/amb_combine_distant_gunfire_mg_01.ogg"},
        {"Machine Gun 2", "interlock/ambient/gunfire/amb_combine_distant_gunfire_mg_02.ogg"},
        {"Machine Gun 3", "interlock/ambient/gunfire/amb_combine_distant_gunfire_mg_03.ogg"},
        {"Machine Gun 4", "interlock/ambient/gunfire/amb_combine_distant_gunfire_mg_04.ogg"},
        {"Machine Gun 5", "interlock/ambient/gunfire/amb_combine_distant_gunfire_mg_05.ogg"},
        {"Rifle 1", "interlock/ambient/gunfire/amb_combine_distant_gunfire_rifle_01.ogg"},
        {"Rifle 2", "interlock/ambient/gunfire/amb_combine_distant_gunfire_rifle_02.ogg"},
        {"Rifle 3", "interlock/ambient/gunfire/amb_combine_distant_gunfire_rifle_03.ogg"},
    },
    ["Distant Interior"] = {
        {"Machine Gun 1", "interlock/ambient/gunfire/amb_interior_combat_distant_mg_01.ogg"},
        {"Machine Gun 2", "interlock/ambient/gunfire/amb_interior_combat_distant_mg_02.ogg"},
        {"Machine Gun 3", "interlock/ambient/gunfire/amb_interior_combat_distant_mg_03.ogg"},
        {"Machine Gun 4", "interlock/ambient/gunfire/amb_interior_combat_distant_mg_04.ogg"},
        {"Machine Gun 5", "interlock/ambient/gunfire/amb_interior_combat_distant_mg_05.ogg"},
        {"Rifle 1", "interlock/ambient/gunfire/amb_interior_combat_distant_rifle_01.ogg"},
        {"Rifle 2", "interlock/ambient/gunfire/amb_interior_combat_distant_rifle_02.ogg"},
        {"Rifle 3", "interlock/ambient/gunfire/amb_interior_combat_distant_rifle_03.ogg"},
        {"Suppressor Short", "interlock/ambient/gunfire/amb_interior_combat_distant_supressor_01.ogg"},
        {"Suppressor Medium", "interlock/ambient/gunfire/amb_interior_combat_distant_supressor_02.ogg"},
        {"Suppressor Long", "interlock/ambient/gunfire/amb_interior_combat_distant_supressor_03.ogg"},
        {"Gunfire 1", "interlock/ambient/gunfire/gun_far1.ogg"},
        {"Gunfire 2", "interlock/ambient/gunfire/gun_far2.ogg"},
        {"Gunfire 3", "interlock/ambient/gunfire/gun_far3.ogg"},
        {"Gunfire 4", "interlock/ambient/gunfire/gun_far4.ogg"},
    },
    ["Near Interior"] = {
        {"Machine Gun 1", "interlock/ambient/gunfire/amb_interior_combat_near_mg_01.ogg"},
        {"Machine Gun 2", "interlock/ambient/gunfire/amb_interior_combat_near_mg_02.ogg"},
        {"Machine Gun 3", "interlock/ambient/gunfire/amb_interior_combat_near_mg_03.ogg"},
        {"Machine Gun 4", "interlock/ambient/gunfire/amb_interior_combat_near_mg_04.ogg"},
        {"Machine Gun 5", "interlock/ambient/gunfire/amb_interior_combat_near_mg_05.ogg"},
        {"Rifle 1", "interlock/ambient/gunfire/amb_interior_combat_near_rifle_01.ogg"},
        {"Rifle 2", "interlock/ambient/gunfire/amb_interior_combat_near_rifle_02.ogg"},
        {"Rifle 3", "interlock/ambient/gunfire/amb_interior_combat_near_rifle_03.ogg"},
        {"Suppressor Short", "interlock/ambient/gunfire/amb_interior_combat_near_supressor_01.ogg"},
        {"Suppressor Medium", "interlock/ambient/gunfire/amb_interior_combat_near_supressor_02.ogg"},
        {"Suppressor Long", "interlock/ambient/gunfire/amb_interior_combat_near_supressor_03.ogg"},
    },
}