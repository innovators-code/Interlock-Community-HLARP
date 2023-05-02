--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

function Schema:AddDisplay(message, color, soundBool)
    for k, v in pairs(player.GetAll()) do
        net.Start("ixDisplaySend")
            net.WriteString(message)
            net.WriteColor(color or color_white)
            net.WriteBool(soundBool or false)
        net.Send(v)
    end
end

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( char and ply:IsCombine() and ix.option.Get(ply, "bootSequence", true) ) then
        net.Start("ixStartBootSequence")
        net.Send(ply)
    end
end

function PLUGIN:GetPreferredCarryAngles(ent, ply)
    if ( ent:GetClass() == "combine_mine" ) then return end

    return Angle(0, 0, 0)
end

local allowedCodes = {
    ["codetwelve"] = true,
    ["idcheck"] = true,
    ["unrest"] = false,
    ["aj"] = false,
    ["jw"] = false,
    ["void"] = false,
}
function PLUGIN:InitializedSchema()
    if not ( timer.Exists("ixPasssiveDispatch") ) then
        timer.Create("ixPassiveDispatch", PLUGIN.dispatchCooldown, 0, function()
            if ( Schema:DispatchActive() ) then return end
                
            local randomLine = table.Random(PLUGIN.dispatchLines)
            ix.event.PlaySoundGlobal({
                sound = randomLine.soundFile,
                volume = 0.4,
            })
            ix.dispatch.announce(randomLine.message)
        end)
    end
end

function PLUGIN:PlayerFootstep(ply, pos, foot, sound)
    if ( ply:GetModel():find("combine_heavy_trooper") ) then
        ply:EmitSound("interlock/player/combine/footsteps/charger/foley_step_0"..math.random(1,9)..".ogg", 60, math.random(90, 110), 0.7)
        ply:EmitSound("interlock/player/combine/footsteps/charger/step_layer_bass_0"..math.random(1,5)..".ogg", 90, math.random(90, 110), 0.8)
        ply:EmitSound("interlock/player/combine/footsteps/charger/step_layer_clink_0"..math.random(1,5)..".ogg", 80, math.random(90, 110), 0.6)
        ply:EmitSound(sound, 70, math.random(90, 110), 0.5)

        util.ScreenShake(pos, 1, 1, 1, 512)

        return true
    end
    
    local newSound = ""

    if ( ply:IsCombine() ) then
        if ( ply:GetModel():find("police") ) then
            newSound = "interlock/player/combine/footsteps/metrocop/foley_step_"..Schema:ZeroNumber(math.random(1,9), 2)..".ogg"
        else
            newSound = "interlock/player/combine/footsteps/combine/foley_step_"..Schema:ZeroNumber(math.random(1,9), 2)..".ogg"
        end
    end

    if ( sound:find("dirt") or sound:find("grass") or sound:find("mud") or sound:find("sand") or sound:find("snow") ) then
        sound = "interlock/player/combine/footsteps/common/combine_dirt_step_"..Schema:ZeroNumber(math.random(1,10), 2)..".ogg"
    elseif ( sound:find("gravel") ) then
        sound = "interlock/player/combine/footsteps/common/combine_gravel_step_"..Schema:ZeroNumber(math.random(1,12), 2)..".ogg"
    elseif ( sound:find("chainlink") or sound:find("metalgrate") ) then
        sound = "interlock/player/combine/footsteps/common/combine_metal_walkway_step_"..Schema:ZeroNumber(math.random(1,10), 2)..".ogg"
    elseif ( sound:find("duct") or sound:find("metal") or sound:find("ladder") ) then
        sound = "interlock/player/combine/footsteps/common/combine_metal_solid_step_"..Schema:ZeroNumber(math.random(1,10), 2)..".ogg"
    elseif ( sound:find("wood") ) then
        sound = "interlock/player/combine/footsteps/common/combine_wood_step_"..Schema:ZeroNumber(math.random(1,8), 2)..".ogg"
    else
        sound = "interlock/player/combine/footsteps/common/combine_concrete_step_"..Schema:ZeroNumber(math.random(1,9), 2)..".ogg"
    end

    if not ( ply:WaterLevel() == 0 ) then
        newSound = "ambient/water/water_splash"..math.random(1,3)..".wav"
        sound = "ambient/water/rain_drip"..math.random(1,4)..".wav"
    end

    ply:EmitSound(newSound, 70, math.random(90, 110), 0.5)
    ply:EmitSound(sound, 80, math.random(90, 110), 0.5)

    return true
end

function PLUGIN:DoPlayerDeath(ply, attacker, dmg)
    local location = ply:GetArea()
    if ( location == "" ) then
        location = "unknown location"
    end
    
    if ( ply:IsCombine() ) then
        local sounds = {
            "interlock/player/combine/radio/combine_radio_on_0"..math.random(1,5)..".ogg",
            "npc/overwatch/radiovoice/lostbiosignalforunit.wav"
        }
        local name = string.upper(ply:Nick())

        for k, v in pairs(PLUGIN.taglines) do
            if ( string.find(name, v) ) then
                sounds[#sounds + 1] = "npc/overwatch/radiovoice/"..v..".wav"
            end
        end

        for k, v in pairs(PLUGIN.digitsToWords) do
            if ( string.find(name, "-"..k) ) then
                sounds[#sounds + 1] = "npc/overwatch/radiovoice/"..v..".wav"
            end
        end

        sounds[#sounds + 1] = "interlock/player/combine/radio/combine_radio_off_0"..math.random(1,7)..".ogg"

        for k, v in pairs(player.GetAll()) do
            if ( v:IsCombine() ) then
                ix.util.EmitQueuedSounds(v, sounds, 0, nil, v == ply and 100 or 80)
            end
        end

        for k, v in pairs(player.GetAll()) do
            if not ( v:Team() == ply:Team() ) then
                return
            end

            v:AddDisplay("lost bio-signal for "..ply:Nick().." at "..location.."!", Color(255, 0, 0), true)
        end
        
        Schema:AddWaypoint(ply:GetPos(), "LOST BIO-SIGNAL FOR "..string.upper(ply:Nick()).." AT "..string.upper(location).."!", Color(255, 0, 0), 30, ply)
    end
end

function PLUGIN:PlayerDeath(ply, ent, attacker)
    if ( ply:IsCombine() or ply:IsCA() ) then
        if ( ( nextcpdeath or 0 ) < CurTime() ) then
            if ( ( ix.cityCode.nextDeath or 0 ) < CurTime() ) then
                timer.Simple(math.random(1,5), function()
                    ix.event.PlaySoundGlobal({
                        sound = "interlock/dispatch/07_10000.ogg"
                    })
                    ix.dispatch.announce("Alert. Ground units. Invasive operation of anti-citizen origin. Response code: Engage. Quell. Inquire.")
                end)
                ix.cityCode.nextDeath = CurTime() + 60 * 10
                nextcpdeath = CurTime() + 10
            end
        end
    end
end

function PLUGIN:GetPlayerDeathSound(ply)
    if ( ply:IsCombine() ) then
        local ragdollEntity = ply:GetLocalVar("ixRagdoll")
        if ( IsValid(ragdollEntity) ) then
            ragdollEntity:EmitSound("interlock/player/combine/radio/combine_radio_idle_0"..math.random(1,9)..".ogg")
        end

        local snd = "interlock/player/combine/death/die_"..Schema:ZeroNumber(math.random(1, 10), 2)..".ogg"

        return snd
    end
end

function PLUGIN:GetPlayerPainSound(ply)
    if ( ply:IsCombine() ) then
        local snd = "interlock/player/combine/pain/pain_"..Schema:ZeroNumber(math.random(1, 10), 2)..".ogg"

        return snd
    end
end

function PLUGIN:PlayerHurt(ply, attacker, healthRemaining, damageTaken)
    if ( ply:IsCombine() ) and ( ( ply.ixCombineHurt or 0 ) < CurTime() ) then
        local word = "minor"

        if ( damageTaken >= 75 ) then
            word = "immense"
        elseif ( damageTaken >= 50 ) then
            word = "huge"
        elseif ( damageTaken >= 25 ) then
            word = "large"
        end
        
        for k, v in pairs(player.GetAll()) do
            if not ( v:Team() == ply:Team() ) then return end
            
            Schema:AddDisplay(ply:Nick().." has sustained "..word.." bodily damage!", Color(255, 175, 0), true)
            ply.ixCombineHurt = CurTime() + 20
        end 
    end
end

function PLUGIN:PlayerSetModel(ply)
    if not ( ply:GetModel():find("models/combine_soldiers_redone_playermodels/") or ply:GetModel():find("models/hla/combine/combine_") ) then return end

    ply:GetHands():SetSkin(ply:GetSkin())
    
    for a, b in pairs(ply:GetBodyGroups()) do
        for c, d in pairs(ply:GetHands():GetBodyGroups()) do
            if ( b.name == d.name ) then
                ply:GetHands():SetBodygroup(d.id, ply:GetBodygroup(b.id))
            end
        end
    end
end

local passiveChatter = {
    "npc/overwatch/radiovoice/antifatigueration3mg.wav",
    "npc/overwatch/radiovoice/airwatchcopiesnoactivity.wav",
    "npc/overwatch/radiovoice/preparevisualdownload.wav",
    "npc/overwatch/radiovoice/remindermemoryreplacement.wav",
    "npc/overwatch/radiovoice/reminder100credits.wav",
    "npc/overwatch/radiovoice/teamsreportstatus.wav",
    "npc/overwatch/radiovoice/leadersreportratios.wav",
    "npc/overwatch/radiovoice/accomplicesoperating.wav",

    "npc/combine_soldier/vo/prison_soldier_activatecentral.wav",
    "npc/combine_soldier/vo/prison_soldier_boomersinbound.wav",
    "npc/combine_soldier/vo/prison_soldier_bunker1.wav",
    "npc/combine_soldier/vo/prison_soldier_bunker2.wav",
    "npc/combine_soldier/vo/prison_soldier_bunker3.wav",
    "npc/combine_soldier/vo/prison_soldier_containd8.wav",
    "npc/combine_soldier/vo/prison_soldier_fallback_b4.wav",
    "npc/combine_soldier/vo/prison_soldier_freeman_antlions.wav",
    "npc/combine_soldier/vo/prison_soldier_fullbioticoverrun.wav",
    "npc/combine_soldier/vo/prison_soldier_leader9dead.wav",
    "npc/combine_soldier/vo/prison_soldier_negativecontainment.wav",
    "npc/combine_soldier/vo/prison_soldier_prosecuted7.wav",
    "npc/combine_soldier/vo/prison_soldier_sundown3dead.wav",
    "npc/combine_soldier/vo/prison_soldier_tohighpoints.wav",
    "npc/combine_soldier/vo/prison_soldier_visceratorsa5.wav",

    "interlock/player/combine/radio/combine_radio_idle_01.ogg",
    "interlock/player/combine/radio/combine_radio_idle_02.ogg",
    "interlock/player/combine/radio/combine_radio_idle_03.ogg",
    "interlock/player/combine/radio/combine_radio_idle_04.ogg",
    "interlock/player/combine/radio/combine_radio_idle_05.ogg",
    "interlock/player/combine/radio/combine_radio_idle_06.ogg",
    "interlock/player/combine/radio/combine_radio_idle_07.ogg",
    "interlock/player/combine/radio/combine_radio_idle_08.ogg",
    "interlock/player/combine/radio/combine_radio_idle_09.ogg",
}
function PLUGIN:Tick()
    for k, v in ipairs(ix.util.GetAllCombine()) do
        if ( ( v.nextChatter or 0 ) < CurTime() ) then
            ix.util.EmitQueuedSounds(v, {
                PLUGIN.combineRadioOn[math.random(1, #PLUGIN.combineRadioOn)],
                passiveChatter[math.random(1, #passiveChatter)],
                PLUGIN.combineRadioOff[math.random(1, #PLUGIN.combineRadioOff)],
            }, nil, nil, 40)

            v.nextChatter = CurTime() + math.random(60, 300)
        end
    end
end

function PLUGIN:EntityTakeDamage(ent, dmg)
    if ( dmg:GetDamage() == DMG_DIRECT ) then return end

    if ( ent:IsPlayer() ) then
        if not ( ent:Team() == FACTION_OTA ) then return end

        local d = dmg:GetDamage()
        if ( ent:Armor() >= d ) then
            ent:SetArmor(ent:Armor() - d)
            
            return true
        elseif ( ent:Armor() > 0 ) then
            dmg:SetDamage(d - ent:Armor())
            ent:SetArmor(0)
            ent:TakeDamageInfo(dmg)

            return true
        end
    end
end