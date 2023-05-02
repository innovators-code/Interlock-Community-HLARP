--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** void_alarmCopryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Combine Improvements"
PLUGIN.description = "Adds alot of features, additions, updates to the Combine Factions."
PLUGIN.author = "Riggs.mackay"
PLUGIN.credits = "DoopieWop, Scotnay"

PLUGIN.dispatchCooldown = 600
PLUGIN.dispatchLines = {
    {
        message = "Citizen Reminder: a civilized society demands swift and targeted oversight. Prohibit fellow citizens from threatening the community.",
        soundFile = "interlock/dispatch/07_10002.ogg",
    },
    {
        message = "Citizen reminder: Inaction is conspiracy. Report counter-behavior to a Civil-Protection team immediately.",
        soundFile = "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav",
    },
    {
        message = "Citizen notice: Failure to co-operate will result in permanent off-world relocation.",
        soundFile = "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav",
    },
}

PLUGIN.OTASquads = {
    ["STEAM_0:0:195901781"] = "SUNDOWN",    --PTV
    ["STEAM_0:0:61672347"] = "SUNDOWN",     --Echoloveation
    ["STEAM_0:1:1395956"] = "SUNDOWN",      --Riggs
    ["STEAM_0:1:229154681"] = "SUNDOWN",    --Bore
    ["STEAM_0:0:20320092"] = "SUNDOWN",     --Adamski e
    ["STEAM_0:0:419613166"] = "SUNDOWN",    --hyper

    ["STEAM_0:0:99431795"] = "SUNDOWN",     --deefoursee
    ["STEAM_0:1:91589611"] = "MONSOON",     --Bread
    ["STEAM_0:1:562672934"] = "MONSOON",    --Darkshadowbuzz
    ["STEAM_0:0:567933763"] = "MONSOON",    --Rysche
    ["STEAM_0:0:174143741"] = "MONSOON",    --Lee West
    ["STEAM_0:0:222077083"] = "MONSOON",    --zachun
    ["STEAM_0:1:465730962"] = "MONSOON",    --Egocentrism

    ["STEAM_0:1:206522106"] = "SWORD",      --Skay
    ["STEAM_0:1:117769029"] = "SWORD",      --bonk&½
    ["STEAM_0:0:229400758"] = "SWORD"       --Tea
}

PLUGIN.combineRadioOn = {
    "interlock/player/combine/radio/combine_radio_on_01.ogg",
    "interlock/player/combine/radio/combine_radio_on_02.ogg",
    "interlock/player/combine/radio/combine_radio_on_03.ogg",
    "interlock/player/combine/radio/combine_radio_on_04.ogg",
    "interlock/player/combine/radio/combine_radio_on_05.ogg",
}

PLUGIN.combineRadioOff = {
    "interlock/player/combine/radio/combine_radio_off_01.ogg",
    "interlock/player/combine/radio/combine_radio_off_02.ogg",
    "interlock/player/combine/radio/combine_radio_off_04.ogg",
    "interlock/player/combine/radio/combine_radio_off_05.ogg",
    "interlock/player/combine/radio/combine_radio_off_06.ogg",
    "interlock/player/combine/radio/combine_radio_off_07.ogg",
}

PLUGIN.digitsToWords = {
    [0] = "zero",
    [1] = "one",
    [2] = "two",
    [3] = "three",
    [4] = "four",
    [5] = "five",
    [6] = "six",
    [7] = "seven",
    [8] = "eight",
    [9] = "nine",
}

PLUGIN.taglines = {
    "APEX",
    "BLADE",
    "DASH",
    "DEFENDER",
    "GHOST",
    "GRID",
    "HELIX",
    "HUNTER",
    "HURRICANE",
    "ION",
    "JET",
    "JUDGE",
    "JURY",
    "MACE",
    "NOVA",
    "QUICKSAND",
    "RANGER",
    "RAZOR",
    "SAVAGE",
    "SPEAR",
    "SWIFT",
    "STINGER",
    "STORM",
    "SUNDOWN",
    "SWORD",
    "UNIFORM",
    "VAMP",
    "VICE",
    "VICTOR",
    "WINDER",
    "XRAY",
    "ZONE",
    "ECHO",
    "HERO",
    "KING",
    "QUICK",
    "ROLLER",
    "STICK",
    "UNION",
    "YELLOW",
    "LEADER",
    "HAMMER"
}

PLUGIN.locations = {
    ["metropolice"] = {
        ["404 Zone"] = "npc/metropolice/vo/404zone.wav",
        ["Canal Block"] = "npc/metropolice/vo/canalblock.wav",
        ["Condemned Zone"] = "npc/metropolice/vo/condemnedzone.wav",
        ["Control Section"] = "npc/metropolice/vo/controlsection.wav",
        ["Deserviced Area"] = "npc/metropolice/vo/deservicedarea.wav",
        ["Distribution Block"] = "npc/metropolice/vo/distributionblock.wav",
        ["External Jurisdiction"] = "npc/metropolice/vo/externaljurisdiction.wav",
        ["Stabilization Jurisdiction"] = "npc/metropolice/vo/stabilizationjurisdiction.wav",
        ["High Priority Region"] = "npc/metropolice/vo/highpriorityregion.wav",
        ["Industrial Zone"] = "npc/metropolice/vo/industrialzone.wav",
        ["Infested Zone"] = "npc/metropolice/vo/infestedzone.wav",
        ["Outland Zone"] = "npc/metropolice/vo/outlandzone.wav",
        ["Production Block"] = "npc/metropolice/vo/productionblock.wav",
        ["Politicontrol Section"] = "npc/metropolice/vo/politicontrol_section.wav",
        ["Repurposed Area"] = "npc/metropolice/vo/repurposedarea.wav",
        ["Residential Block"] = "npc/metropolice/vo/residentialblock.wav",
        ["Production Block"] = "npc/metropolice/vo/stormsystem.wav",
        ["Canal Block"] = "npc/metropolice/vo/terminalrestrictionzone.wav",
        ["Transit Block"] = "npc/metropolice/vo/transitblock.wav",
        ["Waste River"] = "npc/metropolice/vo/wasteriver.wav",
        ["Workforce Intake Hub"] = "npc/metropolice/vo/workforceintake.wav",
    },
    ["dispatch"] = {
        ["404 Zone"] = "npc/overwatch/radiovoice/404zone.wav",
        ["Canal Block"] = "npc/overwatch/radiovoice/canalblock.wav",
        ["Condemned Zone"] = "npc/overwatch/radiovoice/condemnedzone.wav",
        ["Control Section"] = "npc/overwatch/radiovoice/controlsection.wav",
        ["Deserviced Area"] = "npc/overwatch/radiovoice/deservicedarea.wav",
        ["Distribution Block"] = "npc/overwatch/radiovoice/distributionblock.wav",
        ["External Jurisdiction"] = "npc/overwatch/radiovoice/externaljurisdiction.wav",
        ["Stabilization Jurisdiction"] = "npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
        ["High Priority Region"] = "npc/overwatch/radiovoice/highpriorityregion.wav",
        ["Industrial Zone"] = "npc/overwatch/radiovoice/industrialzone.wav",
        ["Infested Zone"] = "npc/overwatch/radiovoice/infestedzone.wav",
        ["Outland Zone"] = "npc/overwatch/radiovoice/outlandzone.wav",
        ["Production Block"] = "npc/overwatch/radiovoice/productionblock.wav",
        ["Politicontrol Section"] = "npc/overwatch/radiovoice/politicontrol_section.wav",
        ["Repurposed Area"] = "npc/overwatch/radiovoice/repurposedarea.wav",
        ["Residential Block"] = "npc/overwatch/radiovoice/residentialblock.wav",
        ["Production Block"] = "npc/overwatch/radiovoice/stormsystem.wav",
        ["Canal Block"] = "npc/overwatch/radiovoice/terminalrestrictionzone.wav",
        ["Transit Block"] = "npc/overwatch/radiovoice/transitblock.wav",
        ["Waste River"] = "npc/overwatch/radiovoice/wasteriver.wav",
        ["Workforce Intake Hub"] = "npc/overwatch/radiovoice/workforceintake.wav",
    },
}

ix.visor = ix.visor or {}
ix.dispatch = ix.dispatch or {}

ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_hud.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_visor.lua")
ix.util.Include("sh_citycodes.lua")
ix.util.Include("sh_sociostatus.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sv_citycodes.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_sociostatus.lua")

player_manager.AddValidModel("CombineSoldierHands", "models/police.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/police.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/combine/combine_heavy.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/cultist/hl_a/combine_heavy/npc/combine_heavy_trooper.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/cultist/hl_a/combine_commander/npc/combine_commander.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_elite_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_hlalyx_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_soldier_prisonguard_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/ninja/combine/combine_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/ninja/combine/combine_soldier_prisonguard.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/ninja/combine/combine_super_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/ninja/combine/combinonew.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_super_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldier_prisonguard.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_hlalyx_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_soldier_prisonguard_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/combine_soldiers_redone_playermodels/combine_elite_soldier_redone.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/combine/combine_hla_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/combine/combine_soldier.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/combine/combine_soldier_prisonguard.mdl")
player_manager.AddValidModel("CombineSoldierHands", "models/hla/combine/combine_super_soldier.mdl")
player_manager.AddValidHands("CombineSoldierHands", "models/weapons/c_arms_combine.mdl", 0, "0000000")

ix.lang.AddTable("english", {
    optVisor = "Visor",
    optdVisor = "Wether or not you want to show the visor on your hud.",

    optBootSequence = "Boot Sequence",
    optdBootSequence = "Wether or not you want to have the boot sequence.",

    optBatonStatus = "Baton Status",
    optdBatonStatus = "Wether or not you want to show the baton status on your hud.",

    optUnitStatus = "Unit Status",
    optdUnitStatus = "Wether or not you want to show the unit status on your hud.",

    optUnitInformation = "Unit Information",
    optdUnitInformation = "Wether or not you want to show the unit information on your hud.",

    optCompass = "Compass",
    optdCompass = "Wether or not you want to show the compass on your hud.",
})

ix.option.Add("visor", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.option.Add("bootSequence", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.option.Add("batonStatus", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.option.Add("unitStatus", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.option.Add("unitInformation", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.option.Add("compass", ix.type.bool, true, {
    category = "Combine Improvements",
    default = true,
})

ix.config.Add("shoveTime", 20, "How long should a character be unconscious after being knocked out?", nil, {
    data = {min = 5, max = 60},
})

local PLAYER = FindMetaTable("Player")

function PLAYER:AddDisplay(message, color, soundBool)
    if ( SERVER ) then
        net.Start("ixDisplaySend")
            net.WriteString(message)
            net.WriteColor(color or color_white)
            net.WriteBool(soundBool or false)
        net.Send(self)
    else
        ix.display.AddDisplay(message, color or color_white, soundBool or false)
    end
end

function ix.dispatch.announce(text, target, delay)
    if ( delay ) then
        if not ( isnumber(delay) ) then return end
        timer.Simple(delay, function()
            if ( CLIENT ) then
                chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(255, 40, 40), "Overwatch broadcasts: "..text)
            elseif ( SERVER ) then
                if ( target and IsValid(target) ) then
                    net.Start("ixDispatchSend")
                        net.WriteString(text)
                    net.Send(target)
                else
                    net.Start("ixDispatchSend")
                        net.WriteString(text)
                    net.Broadcast()
                end
            end
        end)
    else
        if ( CLIENT ) then
            chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(255, 40, 40), "Overwatch broadcasts: "..text)
        elseif ( SERVER ) then
            if ( target and IsValid(target) ) then
                net.Start("ixDispatchSend")
                    net.WriteString(text)
                net.Send(target)
            else
                net.Start("ixDispatchSend")
                    net.WriteString(text)
                net.Broadcast()
            end
        end
    end
end

function ix.util.GetAllCombine()
    local combine = {}

    for _, v in ipairs(player.GetAll()) do
        if ( v:IsCombine() ) then
            table.insert(combine, v)
        end
    end

    return combine
end

function ix.util.GetAllSupervisors()
    local svs = {}

    for k, v in ipairs(player.GetAll()) do
        if ( v:IsCombineCommand() ) then
            table.insert(svs, v)
        end
    end

    return svs
end

function ix.util.GetAllCPs()
    local cps = {}

    for _, v in ipairs(player.GetAll()) do
        if ( v:Team() == FACTION_CP ) then
            table.insert(cps, v)
        end
    end

    return cps
end

function ix.util.GetAllOTA()
    local irts = {}

    for _, v in ipairs(player.GetAll()) do
        if ( v:Team() == FACTION_OTA ) then
            table.insert(irts, v)
        end
    end

    return irts
end
