--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/
    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

ix.cityCode = ix.cityCode or {}
ix.cityCode.codes = ix.cityCode.codes or {}

--[[---------------------------------------------------------------------------
    City Code List
---------------------------------------------------------------------------]]--

ix.cityCode.codes = {
    ["void"] = {
        color = Color(0, 0, 0),
        name = "Emergency Code: Void",
        description = [[This an Alyx Code used during a certain sequence. We're using this as a final result that ends in all citizens immediately being amputated or brainwashed. There is full discretion on this verdict. Once this waiver is enacted, it is used as an absolute final solution for sociostability.
        These codes are enacted during times of crisis and can be paired with Waivers. However they're necessarily bound towards these waivers, it's an entirely separate code of operation.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsSuperAdmin() ) then -- Code will most likely be used for events, so we'll make it superadmin only.
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = "interlock/music/halflife/alyx/60-cauterizer.ogg",
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/dispatch/07_10007.ogg",
                db = 120,
                volume = 1.5,
            })
            for k, v in ipairs(player.GetAll()) do
                util.ScreenShake(v:GetPos(), 5, 5, 5, 64)
            end
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/void_sinister.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/void_sinister.wav",
                delay = 10,
            })
            timer.Create("void_ambience1", 20, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/void_alarm.wav",
                })

                for k, v in ipairs(player.GetAll()) do
                    util.ScreenShake(v:GetPos(), 5, 5, 5, 64)
                end

                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/void_alarm_faar.wav",
                    delay = 3,
                })

                timer.Simple(3, function()
                    for k, v in ipairs(player.GetAll()) do
                        util.ScreenShake(v:GetPos(), 1, 5, 5, 64)
                    end
                end)
            end)
            ix.dispatch.announce("Alert ground units. Alert command units. Emergency Code: Void.")
        end,
        OnEnd = function()
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
            })
            for k, v in ipairs(player.GetAll()) do
                util.ScreenShake(v:GetPos(), 5, 5, 5, 64)
            end
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/void_sinister.wav",
            })
            ix.event.StopSoundGlobal("interlock/ambient/alarms/void_alarm.wav")
            ix.event.StopSoundGlobal("interlock/ambient/alarms/void_alarm_faar.wav")
            ix.event.StopSoundGlobal("interlock/music/halflife/alyx/60-cauterizer.ogg")
            ix.dispatch.announce("Alert ground units, Emergency Code: Void has now been lifted.")
            timer.Remove("void_ambience1")
        end,
    },
    ["jw"] = {
        color = Color(250, 0, 0),
        name = "Judgement Waiver",
        description = [[Civil Protection Officers are given full rights to hand out amputations for any crime at their own discretion (If they so wish to essentially). "Capital prosecution is discretionary". Naturally any petty crimes can be tolerated as maximum punishment by the system and therefore Civil Protection are allowed to act on Citizens during this waiver.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineSupervisor() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 90,
            })
            ix.event.EmitShake(5, 5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 80,
                delay = 0.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 0.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 70,
                delay = 1,
            })
            ix.event.EmitShake(5, 5, 0.5, 1)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 60,
                delay = 1.5,
            })
            ix.event.EmitShake(5, 5, 0.5, 1.5)
            ix.event.PlaySoundGlobal({
                sound = "plats/crane/vertical_stop.wav",
                volume = 0.4,
                pitch = 50,
                delay = 2,
            })
            ix.event.EmitShake(5, 5, 0.5, 2)
            ix.event.PlaySoundGlobal({
                sound = "ambient/weather/thunder1.wav",
                volume = 1,
                delay = 3,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/weather/thunder1.wav",
                volume = 1,
                delay = 3,
            })
            ix.event.EmitShake(7, 5, 5, 3)
            ix.event.PlaySoundGlobal({
                sound = table.Random({
                    "interlock/music/halflife/lw/endangered specimen.ogg",
                    "interlock/music/halflife/hl2/35 singularity.ogg",
                    "interlock/music/halflife/bm/bms - uc.ogg",
                }),
                volume = 0.4,
            })
            ix.dispatch.announce("Attention, all ground-protection teams, Judgement Waiver now in effect. Capital prosecution is discretionary.", nil, 4)
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav",
                delay = 4,
            })
            ix.dispatch.announce("Judgement Waiver is still on-going. Capital prosecution is discretionary.", nil, 30)
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
                delay = 30,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens2.wav",
                pitch = 80,
                delay = 32,
            })
            ix.event.PlaySoundGlobal({
                sound = "ambient/levels/citadel/citadel_5sirens.wav",
                pitch = 80,
                delay = 40,
            })

            timer.Create("jw_ambience1", 10, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/jw_alarm.wav",
                    volume = 0.8,
                })
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/jw_alarm_faar.wav",
                    volume = 0.5,
                    delay = 4,
                })
                ix.event.EmitShake(3, 3, 4, 0.5)
                ix.event.EmitShake(2, 2, 5, 4.5)
            end)

            timer.Create("jw_ambience2", 30, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_5sirens2.wav",
                    pitch = 80,
                })
                ix.event.EmitShake(1, 1, 5)
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/citadel/citadel_5sirens.wav",
                    pitch = 80,
                    delay = 8,
                })
                ix.event.EmitShake(1, 1, 5, 8)
            end)

            timer.Create("jw_ambience3", 5, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = table.Random({
                        "ambient/levels/streetwar/apc_distant1.wav",
                        "ambient/levels/streetwar/apc_distant2.wav",
                        "ambient/levels/streetwar/apc_distant3.wav",
                        "ambient/levels/streetwar/gunship_distant1.wav",
                        "ambient/levels/streetwar/gunship_distant2.wav",
                        "ambient/levels/streetwar/heli_distant1.wav",
                        "ambient/levels/streetwar/marching_distant1.wav",
                        "ambient/levels/streetwar/marching_distant2.wav",
                        "ambient/machines/aircraft_distant_flyby1.wav",
                        "ambient/machines/aircraft_distant_flyby3.wav",
                        "ambient/machines/heli_pass1.wav",
                        "ambient/machines/heli_pass2.wav",
                        "ambient/machines/heli_pass_distant1.wav",
                        "ambient/machines/heli_pass_quick1.wav",
                        "ambient/machines/heli_pass_quick2.wav",
                        "interlock/ambient/echoes/echoes_dropship.ogg",
                        "interlock/ambient/battle/chopper_1.ogg",
                        "interlock/ambient/battle/chopper_2.ogg",
                        "interlock/ambient/battle/citizen_1.ogg",
                        "interlock/ambient/battle/dropship_1.ogg",
                        "interlock/ambient/battle/dropship_2.ogg",
                        "interlock/ambient/battle/dropship_3.ogg",
                        "interlock/ambient/battle/hunter_1.ogg",
                        "interlock/ambient/battle/hunter_2.ogg",
                        "interlock/ambient/battle/jet_1.ogg",
                        "interlock/ambient/battle/jet_2.ogg",
                        "interlock/ambient/battle/jet_3.ogg",
                        "interlock/ambient/battle/shotgun_1.ogg",
                        "interlock/ambient/battle/soldier_1.ogg",
                        "interlock/ambient/battle/strider_1.ogg",
                        "interlock/ambient/battle/strider_2.ogg",
                        "interlock/ambient/battle/strider_3.ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/distant_battle_gunfire0"..math.random(1,7)..".ogg",
                        "interlock/ambient/gunfire/gun_far1.ogg",
                        "interlock/ambient/gunfire/gun_far2.ogg",
                        "interlock/ambient/gunfire/gun_far3.ogg",
                        "interlock/ambient/gunfire/gun_far4.ogg",
                    }),
                    volume = 0.2,
                })
            end)

            timer.Create("jw_ambience4", 300, 0, function()
                ix.dispatch.announce("Judgement Waiver is still on-going. Capital prosecution is discretionary.")
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/dispatch_alarm.wav",
                })
            end)
        end,
        OnEnd = function()
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
            })

            timer.Remove("jw_ambience1")
            timer.Remove("jw_ambience2")
            timer.Remove("jw_ambience3")
            timer.Remove("jw_ambience4")
        end,
    },
    ["aj"] = {
        color = Color(250, 250, 0),
        name = "Autonomous Judgement",
        description = [[Civil Protection Units are to conduct independent sentencing against civil violators. Instead of reporting in crimes, they're to sentence criminals at their own accord. "Sentencing is now discretionary." Working at your own discretion.
        This means that Civil Pros do not need Dispatch or a Higher Rank to tell them otherwise about sentencing, when this is enacted Civil Pros are expected to arrest/punish immediately if they so wish to.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineSupervisor() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = "plats/tram_hit1.wav",
                db = 120,
                volume = 0.5,
            })
            ix.event.PlaySoundGlobal({
                sound = "doors/door_metal_large_chamber_close1.wav",
                db = 120,
                volume = 0.75,
                delay = 0.5,
            })
            ix.event.PlaySoundGlobal({
                sound = "plats/platform_citadel_ring.wav",
                db = 120,
                volume = 1,
                delay = 1,
            })
            ix.event.PlaySoundGlobal({
                sound = "plats/platform_citadel_ring.wav",
                db = 120,
                volume = 1,
                pitch = 90,
                delay = 2,
            })
            ix.event.PlaySoundGlobal({
                sound = table.Random({
                    "interlock/music/halflife/alyx/21 Deployed and Designated to Prosecute.ogg",
                    "interlock/music/community/stalker/clearsky3remix3.mp3",
                    "interlock/music/halflife/ez2/11 not your average cop.ogg",
                    "interlock/music/halflife/lw/uprising.ogg",
                    "interlock/music/modernwarfare/mw2/15_the_hornets_nest.mp3",
                }),
                volume = 0.4,
            })
            ix.event.EmitShake(1, 5, 5)

            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav",
                db = 120,
                volume = 1,
            })
            ix.dispatch.announce("Attention, all ground-protection teams, Autonomous Judgement is now in effect. Sentencing is now discretionary. Code, AMPUTATE, ZERO, CONFIRM.")

            timer.Create("aj_ambience1", 30, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/aj_alarm.wav",
                    volume = 0.8,
                })
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/aj_alarm_faar.wav",
                    volume = 0.5,
                    delay = 4,
                })
                ix.event.EmitShake(2, 2, 4, 0.5)
                ix.event.EmitShake(1, 1, 5, 4.5)
            end)

            timer.Create("aj_ambience2", 7, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = table.Random({
                        "ambient/levels/streetwar/apc_distant1.wav",
                        "ambient/levels/streetwar/apc_distant2.wav",
                        "ambient/levels/streetwar/apc_distant3.wav",
                        "ambient/levels/streetwar/gunship_distant1.wav",
                        "ambient/levels/streetwar/gunship_distant2.wav",
                        "ambient/levels/streetwar/heli_distant1.wav",
                        "ambient/levels/streetwar/marching_distant1.wav",
                        "ambient/levels/streetwar/marching_distant2.wav",
                        "ambient/machines/aircraft_distant_flyby1.wav",
                        "ambient/machines/aircraft_distant_flyby3.wav",
                        "ambient/machines/heli_pass1.wav",
                        "ambient/machines/heli_pass2.wav",
                        "ambient/machines/heli_pass_distant1.wav",
                        "ambient/machines/heli_pass_quick1.wav",
                        "ambient/machines/heli_pass_quick2.wav",
                        "interlock/ambient/echoes/echoes_dropship.ogg",
                        "interlock/ambient/battle/chopper_1.ogg",
                        "interlock/ambient/battle/chopper_2.ogg",
                        "interlock/ambient/battle/citizen_1.ogg",
                        "interlock/ambient/battle/dropship_1.ogg",
                        "interlock/ambient/battle/dropship_2.ogg",
                        "interlock/ambient/battle/dropship_3.ogg",
                        "interlock/ambient/battle/hunter_1.ogg",
                        "interlock/ambient/battle/hunter_2.ogg",
                        "interlock/ambient/battle/jet_1.ogg",
                        "interlock/ambient/battle/jet_2.ogg",
                        "interlock/ambient/battle/jet_3.ogg",
                        "interlock/ambient/battle/shotgun_1.ogg",
                        "interlock/ambient/battle/soldier_1.ogg",
                        "interlock/ambient/battle/strider_1.ogg",
                        "interlock/ambient/battle/strider_2.ogg",
                        "interlock/ambient/battle/strider_3.ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/city_battle"..math.random(1,19)..".ogg",
                        "interlock/ambient/gunfire/distant_battle_gunfire0"..math.random(1,7)..".ogg",
                        "interlock/ambient/gunfire/gun_far1.ogg",
                        "interlock/ambient/gunfire/gun_far2.ogg",
                        "interlock/ambient/gunfire/gun_far3.ogg",
                        "interlock/ambient/gunfire/gun_far4.ogg",
                    }),
                    volume = 0.2,
                })
            end)
        end,
        OnEnd = function()
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
            })
            ix.event.StopSoundGlobal("interlock/ambient/alarms/aj_alarm.wav")
            ix.event.StopSoundGlobal("interlock/ambient/alarms/aj_alarm_faar.wav")
            timer.Remove("aj_ambience1")
            timer.Remove("aj_ambience2")
        end,
    },
    ["curfew"] = {
        color = Color(250, 250, 250),
        name = "Curfew",
        description = [[A curfew is independent from Judgement Waiver and is not tied directly to it. Curfews mean necessarily what it says on the box. All citizens are to return to their housing block and their apartments, they may not leave until this procedure is over. This is publicly announced towards all Citizens and can be used by the City Administrator or CPF Commander to organise citizens.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = table.Random({
                    "interlock/music/halflife/alyx/06 insubordinate relocation.ogg",
                    "interlock/music/halflife/alyx/05 engage quell inquire.ogg",
                    "interlock/music/modernwarfare/mw1/16_zakhaevs_exchange.mp3",
                }),
                volume = 0.4
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/air_raid.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/combine/strider_distant_"..Schema:ZeroNumber(math.random(1,16), 2)..".ogg",
                db = 120,
                volume = 0.5,
                delay = math.random(1,5),
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/combine/strider_distant_"..Schema:ZeroNumber(math.random(1,16), 2)..".ogg",
                db = 120,
                volume = 0.5,
                delay = math.random(1,5),
            })
            ix.dispatch.announce("Attention all citizens, the curfew has started. Please do not leave your homes until the curfew is over.")

            timer.Create("curfew_ambience1", 90, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/air_raid.wav",
                    volume = 0.1,
                })
            end)

            timer.Create("curfew_ambience2", 300, 0, function()
                ix.dispatch.announce("Attention all citizens, the curfew is still on-going. Please do not leave your homes until the curfew is over.")
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/dispatch_alarm.wav",
                    volume = 0.5,
                })
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/air_raid.wav",
                    volume = 0.2,
                })
            end)
        end,
        OnEnd = function()
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/alarms/dispatch_alarm.wav",
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/combine/strider_distant_"..Schema:ZeroNumber(math.random(1,16), 2)..".ogg",
                db = 120,
                volume = 0.5,
                delay = math.random(1,5),
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/ambient/combine/strider_distant_"..Schema:ZeroNumber(math.random(1,16), 2)..".ogg",
                db = 120,
                volume = 0.5,
                delay = math.random(1,5),
            })
            ix.dispatch.announce("Attention all citizens, the curfew has been lifted. You may now leave your homes.")

            timer.Remove("curfew_ambience1")
            timer.Remove("curfew_ambience2")
        end,
    },
    ["unrest"] = {
        color = Color(0, 250, 250),
        name = "Local Unrest Procedure",
        description = [[Also known as Turmoil. This is a City Code which is enacted during rioting and otherwise unrest. Locals have caused disturbance as well as other problems which also may include Resistance movements. Unrest Procedure Code is usually enacted mostly during riots or otherwise malcompliance from the citizen populace.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav",
                db = 120,
                volume = 1.5,
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/music/halflife/hl1/05 cavern ambience.ogg",
                volume = 0.4,
                pitch = 80 + math.random(-10,10),
            })
            ix.dispatch.announce("Attention, community: Unrest Procedure Code is now in effect. INNOCULATE, SHIELD, PACIFY. Code: PRESSURE, SWORD, STERILIZE.")

            timer.Create("unrest_ambience1", 10, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = table.Random({
                        "ambient/levels/streetwar/apc_distant1.wav",
                        "ambient/levels/streetwar/apc_distant2.wav",
                        "ambient/levels/streetwar/apc_distant3.wav",
                        "ambient/levels/streetwar/gunship_distant1.wav",
                        "ambient/levels/streetwar/gunship_distant2.wav",
                        "ambient/levels/streetwar/heli_distant1.wav",
                        "ambient/levels/streetwar/marching_distant1.wav",
                        "ambient/levels/streetwar/marching_distant2.wav",
                        "ambient/machines/heli_pass1.wav",
                        "ambient/machines/heli_pass2.wav",
                        "ambient/machines/heli_pass_distant1.wav",
                        "ambient/machines/heli_pass_quick1.wav",
                        "ambient/machines/heli_pass_quick2.wav",
                        "interlock/ambient/combine/strider_distant_"..Schema:ZeroNumber(math.random(1,16), 2)..".ogg",
                    }),
                    volume = 0.3,
                })
            end)
            timer.Create("unrest_ambience2", 30, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "ambient/levels/prison/inside_battle"..math.random(1,9)..".wav",
                    volume = 0.2,
                })
            end)
            timer.Create("unrest_ambience3", 20, 0, function()
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/basement_alarm.wav",
                    volume = 0.8,
                })
                ix.event.PlaySoundGlobal({
                    sound = "interlock/ambient/alarms/basement_alarm_faar.wav",
                    volume = 0.6,
                    delay = 4,
                })
            end)
        end,
        OnEnd = function()
            timer.Remove("unrest_ambience1")
            timer.Remove("unrest_ambience2")
            timer.Remove("unrest_ambience3")
        end,
    },
    ["idcheck"] = {
        color = Color(100, 100, 100),
        name = "Priority Identification Check",
        description = [[Inspection Positions. All citizens are to return to their housing block or meet at a Civil Protection checkpoint to be led to an inspection position, therefore they're searched on body and their residential block. They're checked for their identification and any contraband. All suspects are to be arrested and taken in for interrogation.]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
            ix.event.PlaySoundGlobal({
                sound = "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav",
                db = 120,
                volume = 1.5,
            })
            ix.event.PlaySoundGlobal({
                sound = "interlock/music/halflife/hl1/02 vague voices.ogg",
                volume = 0.4,
                pitch = 80 + math.random(-10,10),
            })
            ix.dispatch.announce("Attention, please: All citizens in local residential block, assume your inspection-positions.")

            for k, v in pairs(player.GetAll()) do
                if ( v:IsCitizen() and ( v:HasItem("coupon") or v:HasItem("id") ) ) then
                    v:ChatNotify(table.Random({
                        "I should return to my housing block or meet a Civil Protection officer to be led to an inspection position.",
                        "I should probably return to my housing block.",
                        "I need to meet a Civil Protection officer to be led to an inspection position.",
                        "I need to return to my housing block.",
                    }))
                end
            end
        end,
        OnEnd = function()
        end,
    },
    ["codetwelve"] = {
        color = Color(250, 250, 250),
        name = "Code Twelve",
        description = [[]],
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnStart = function()
        end,
        OnEnd = function()
        end,
    },
}

-- You never know when you need it, Github copilot wrote this.
--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetAll()
    Desc: Returns a table of all codes.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetAll()
    return ix.cityCode.codes
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetCurrent()
    Desc: Returns the current code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetCurrent()
    return GetGlobalString("ixCityCode", "codetwelve")
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.Get()
    Desc: Returns a table of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.Get(id)
    return ix.cityCode.codes[id]
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetColor()
    Desc: Returns a color of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetColor(id)
    return ix.cityCode.codes[id].color
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetName()
    Desc: Returns a name of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetName(id)
    return ix.cityCode.codes[id].name
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetDescription()
    Desc: Returns a description of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetDescription(id)
    return ix.cityCode.codes[id].description
end

--[[---------------------------------------------------------------------------
    Name: ix.cityCode.GetAccess()
    Desc: Returns a access function of a specific code.
---------------------------------------------------------------------------]]--

function ix.cityCode.GetAccess(id)
    return ix.cityCode.codes[id].OnCheckAccess
end
