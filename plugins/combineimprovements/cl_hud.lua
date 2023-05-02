--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

local colors = {
    ["white"] = Color(200, 200, 200),
    ["blue"] = Color(100, 160, 250),
    ["yellow"] = Color(200, 200, 0),
    ["red"] = Color(250, 50, 50),
    ["orange"] = Color(250, 100, 0),
    ["green"] = Color(100, 250, 100),
}

local direction = {
    [0] = "N",
    [45] = "NE",
    [90] = "E",
    [135] = "SE",
    [180] = "S",
    [225] = "SW",
    [270] = "W",
    [315] = "NW",
    [360] = "N",
}

ix.display = ix.display or {}
ix.display.messages = ix.display.messages or {}
ix.display.messageID = ix.display.messageID or 0
ix.display.randomMessages = {
    "Updating biosignal co-ordinates...",
    "Parsing heads-up display and data arrays...",
    "Working deconfliction with other ground assets...",
    "Transmitting physical transition vector...",
    "Sending commdata to dispatch...",
    "Sensoring proximity...",
    "Regaining equalization modules...",
    "Encoding network messages...",
    "Idle connection...",
    "Pinging loopback...",
    "Analyzing Overwatch protocols...",
    "Filtering incoming messages...",
    "Synchronizing database records...",
    "Appending all data to black box...",
    "Establishing DC link...",
    "Checking exodus protocol status...",
    "Updating data connections...",
    "Looking up main protocols...",
    "Updating Translation Matrix...",
    "Establishing connection with overwatch...",
    "Opening up aura scanners...",
    "Establishing Clockwork protocols...",
    "Looking up active fireteam control centers...",
    "Command uplink established...",
    "Inititaing self-maintenance scan...",
    "Scanning for active biosignals...",
    "Updating cid registry link...",
    "Establishing variables for connection hooks...",
    "Creating socket for incoming connection...",
    "Updating squad uplink interface...",
    "Validating memory replacement integrity...",
    "Visual uplink status code: GREEN...",
    "Refreshing primary database connections...",
    "Creating ID's for internal structs...",
    "Dumping cache data and renewing from external memory...",
    "Updating squad statuses...",
    "Looking up front end codebase changes...",
    "Software status nominal...",
    "Querying database for new recruits... RESPONSE: OK",
    "Establishing connection to long term maintenance procedures...",
    "Looking up CP-5 Main...",
    "Updating railroad activity monitors...",
    "Caching new response protocols...",
    "Calculating the duration of patrol...",
    "Caching internal watch protocols...",
}

function ix.display.AddDisplay(message, color, soundBool, soundString)
    local ply = LocalPlayer()
    if not ( ply:GetCharacter() ) then return end

    if not ( ply:IsCombine() or ply:IsDispatch() ) then return end

    ix.display.messageID = ix.display.messageID + 1
    message = "<:: "..string.upper(message)

    local data = {
        message = "",
        bgCol = color or colors["white"],
    }

    table.insert(ix.display.messages, data)

    if ( #ix.display.messages > 4 ) then
        table.remove(ix.display.messages, 1)
    end

    local i = 1
    local id = "ix.display.messages.ID."..ix.display.messageID

    timer.Create(id, 0.01, #message + 1, function()
        data.message = string.sub(message, 1, i + 2)
        i = i + 3

        if ( data.message == #message ) then
            timer.Remove(id)
        end
    end)

    if ( soundBool == true ) then
        ply:EmitSound(soundString or "npc/roller/code2.wav")
    end
end

local nextMessage = 0
local lastMessage = ""
function PLUGIN:Think()
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()
    if not ( IsValid(ply) and ply:Alive() and char ) then return end

    if ( IsValid(ix.display.menu) or IsValid(ix.display.characterMenu) ) then return end

    if ( ( nextMessage or 0 ) < CurTime() ) then
        local message = ix.display.randomMessages[math.random(1, #ix.display.randomMessages)]

        if not ( message == ( lastMessage or "" ) ) then
            ix.display.AddDisplay(message, nil, false)
            lastMessage = message
        end

        nextMessage = CurTime() + 10
    end
end

local bootMessages = {
    "opening file K:/civilprotectionBoot128.xyz", -- 1
    "1...", -- 2
    "2...", -- 3
    "3...", -- 4
    "4...", -- 5
    "5...", -- 6
    "done", -- 7
    "opening file K:/radioSystem64.xyz", -- 8
    "1...", -- 9
    "2...", -- 10
    "3...", -- 11
    "4...", -- 12
    "done", -- 13
    "opening file K:/visorSystem48.xyz", -- 14
    "1...", -- 15
    "2...", -- 16
    "done", -- 17
    "opening file K:/vitalSystem16.xyz", -- 18
    "1...", -- 19
    "1...", -- 20
    "error..!", -- 21
    "error on file vitalSystem16.xyz", -- 22
    "line "..math.random(1,9999).." patched..", -- 23
    "line "..math.random(1,9999).." patched..", -- 24
    "line "..math.random(1,9999).." patched..", -- 25
    "opening file K:/vitalSystem16.xyz", -- 26
    "1...", -- 27
    "2...", -- 28
    "3...", -- 29
    "done", -- 30
    "running K:/civilprotectionBoot128.xyz", -- 31
    "systems initialized..", -- 32
    "systems nominal..!", -- 33
    "finalizing interface..", -- 34
    "1...", -- 35
    "2...", -- 36
    "interface loaded..", -- 37
    "welcome back unit" -- 38
}

local waitcmds = {
    [1] = true,
    [8] = true,

    [14] = true,
    [18] = true,
    [19] = true,

    [20] = true,
    [21] = true,
    [22] = true,
    [26] = true,

    [31] = true,

    [35] = true,
    [37] = true,
    [38] = true,
}

local bootMessageID = 0
local nextBootMessage
local bootStart = 1
local bootDone = 0
local startTime
local bootLinesData = {}
local function DrawBootSequence()
    if ( bootDone ) and ( bootDone < CurTime() ) then
        startTime = nil
        return true
    end

    for i = 1, 1000 do
        bootLinesData[i] = bootLinesData[i] or {
            alpha = math.random(20, 30),
            posY = i * 6 - 10,
        }

        bootLinesData[i].alpha = Lerp(FrameTime() / 100, bootLinesData[i].alpha, math.random(1, 3))
        bootLinesData[i].posY = Lerp(FrameTime() / 100, bootLinesData[i].posY, i * 6 - math.random(1, 100))

        draw.RoundedBox(0, 0, bootLinesData[i].posY, ScrW(), 2, ColorAlpha(team.GetColor(LocalPlayer():Team()), bootLinesData[i].alpha))
    end

    if ( bootStart == 1 ) then
        surface.PlaySound("interlock/ui/hacking_sphere_appear_01.ogg")
        bootStart = 0
    end

    local x, y = 5, 5
    startTime = startTime or CurTime()

    surface.SetDrawColor(team.GetColor(LocalPlayer():Team()))
    surface.SetMaterial(ix.util.GetMaterial("interlock/combine_logo.png"))
    surface.DrawTexturedRect(ScrW() - 350, ScrH() - 350, 350, 350)

    if ( startTime + 0.2 < CurTime() ) then
        draw.SimpleText("<:: UNIT INTERFACE BOOT SYSTEM ACTIVATED! INITIALIZING...", "CombineFont40", x, y, team.GetColor(LocalPlayer():Team()))
    end

    if ( startTime + 1 < CurTime() ) then
        if not ( bootDone ) and (not nextBootMessage or nextBootMessage < CurTime()) then
            bootMessageID = bootMessageID + 1

            surface.PlaySound("interlock/ui/hacking_puzzle_tripmine_ring_0"..math.random(1,7)..".ogg")

            if not ( bootMessages[bootMessageID] ) then
                bootDone = CurTime() + math.random(1.0,2.0)
                surface.PlaySound("interlock/ui/hacking_puzzle_tripmine_success_01.ogg")
            end

            if ( bootMessages[45] ) then
                bootMessages[45] = "welcome back "..LocalPlayer():Nick()
            end

            local wait = math.random(0.1, 0.3)

            if ( waitcmds[bootMessageID] ) then
                if ( string.find(bootMessages[bootMessageID], "opening") or string.find(bootMessages[bootMessageID], "running") or string.find(bootMessages[bootMessageID], "error") ) then
                    surface.PlaySound("interlock/ui/hacking_sphere_failure_beep_01.ogg")
                end
                wait = wait + math.random(0.5, 2.0)
            end

            nextBootMessage = CurTime() + wait
        end

        for i = 1, bootMessageID do
            local bootMessage = bootMessages[i]

            if ( bootMessage ) then
                draw.SimpleText(bootMessage, "CombineFont20", x, (y + 20) + (20 * i))     
            end
        end
    end
end

local scanLineData = {}
local unitData = {}
local oaskID = Schema:ZeroNumber(math.random(1,99999), 5)
local staticDelay = 0
local deathValid = false

local otasquadcols = {
    ["SUNDOWN"] = Color(255, 0, 0),
    ["MONSOON"] = Color(0, 140, 255),
    ["SWORD"] = Color(255, 255, 255),
    ["HUNTER"] = Color(0, 255, 0)
}
function PLUGIN:HUDPaint()
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()
    
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if ( ix.util.hudDisabled or ix.ops.cinematicIntro or not ix.config.Get("hudEnabled", true) ) then return end
    if ( ply:GetLocalVar("interlock_showhud", false) ) then return end

    if not ( ply:IsValid() ) then return end
    if not ( char and ( ply:IsCombine() or ply:IsDispatch() ) ) then return end

    -- Death Screen
    if not ( ply:Alive() ) then
        if not ( deathValid == true ) then
            surface.PlaySound("ambient/energy/whiteflash.wav")
            surface.PlaySound("ambient/energy/powerdown2.wav")
            deathValid = true
        end
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
        draw.SimpleText("SIGNAL LOST", "CombineFontBlur80", ScrW() / 2, ScrH() / 2 + math.random(-1.0,1.0), colors["red"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("UNIT "..ply:Nick().." DOWN", "CombineFont30", ScrW() / 2, ScrH() / 2 + 40 + math.random(-1.0,1.0), colors["red"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if ( ( staticDelay or 0 ) < CurTime() ) then
            surface.PlaySound("ambient/levels/prison/radio_random"..math.random(1,15)..".wav")
            staticDelay = CurTime() + math.random(1.0,2.0)
        end
        return
    else
        deathValid = false
    end

    -- Boot Sequence
    if ( ix.option.Get("bootSequence", true) ) then
        if not ( DrawBootSequence() ) then
            return
        end
    end

    -- Night Vision Scanlines
    if ( char:GetData("ixNightvision") ) then
        for i = 1, 1000 do
            scanLineData[i] = scanLineData[i] or {
                alpha = math.random(10, 20),
                posY = i * 6 - 10,
            }

            scanLineData[i].alpha = Lerp(FrameTime() / 100, scanLineData[i].alpha, math.random(1, 3))
            scanLineData[i].posY = Lerp(FrameTime() / 100, scanLineData[i].posY, i * 6 - math.random(1, 100))

            draw.RoundedBox(0, 0, scanLineData[i].posY, ScrW(), 2, ColorAlpha(team.GetColor(ply:Team()), scanLineData[i].alpha))
        end
    end

    -- Compass
    if ( ix.option.Get("compass", true) ) then
        local ang = ply:EyeAngles()
        local width = ScrW() * 0.25
        local m = 1
        local spacing = (width * m) / 360
        local lines = width / spacing
        local rang = math.Round(ang.y)
        local comX = ScrW() / 2

        for i = (rang - (lines / 2)) % 360, ((rang - (lines / 2)) % 360) + lines do
            local x = (comX + (width / 2)) - ((i - ang.y - 180) % 360) * spacing

            if i % 30 == 0 and i > 0 then
                local text = direction[360 - (i % 360)] and direction[360 - (i % 360)] or 360 - (i % 360)

                draw.DrawText(text, "CombineFont20", x, 5, colors["white"], TEXT_ALIGN_CENTER)
            end
        end
    end

    -- Top Left Corner
    for i = 1, #ix.display.messages do
        local msgData = ix.display.messages[i]
        msgData.y = msgData.y or 0

        surface.SetFont("CombineFont20")
        local w, h = surface.GetTextSize(msgData.message)

        x, y = 10, ((i - 1) * h) + 5

        msgData.y = Lerp(0.05, msgData.y, y)

        draw.DrawText(msgData.message, "CombineFont20", x, msgData.y, msgData.bgCol or color_white)
    end
    
    local ccode = ix.cityCode.Get(ix.cityCode.GetCurrent()).name or "Unknown"
    local ccodeclr = ix.cityCode.Get(ix.cityCode.GetCurrent()).color or color_white
    local sstatus = ix.socioStatus.Get(ix.socioStatus.GetCurrent()).name or "Unknown"
    local sstatusclr = ix.socioStatus.Get(ix.socioStatus.GetCurrent()).color or color_white
    
    draw.DrawText("<::", "CombineFont20", 10, 105, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText(StormFox2.Time.TimeToString(), "CombineFont20", 30, 105, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText("<::", "CombineFont20", 10, 125, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText(Schema:GetSchedule(), "CombineFont20", 30, 125, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText("<::", "CombineFont20", 10, 145, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText(ccode, "CombineFont20", 30, 145, ccodeclr, TEXT_ALIGN_LEFT)
    draw.DrawText("<::", "CombineFont20", 10, 165, colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText(sstatus, "CombineFont20", 30, 165, sstatusclr, TEXT_ALIGN_LEFT)

    local id = LocalPlayer():GetArea()
    if ( id ) then
        local area = ix.area.stored[id]
        local aclr = area.properties.color or color_white
        
        draw.DrawText("<::", "CombineFont20", 10, 185, colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(id, "CombineFont20", 30, 185, aclr, TEXT_ALIGN_LEFT)
    end

    -- Top Right Corner
    if ( ix.option.Get("unitStatus", true) ) then
        local unitSpacing = 0
        for k, v in pairs(player.GetAll()) do
            if ( v:IsValid() and char and v:IsCombine() ) then
                if ( LocalPlayer():Team() == v:Team() ) then
                    local name = string.Replace(v:Nick(), "c17:", "")
                    name = string.Replace(v:Nick(), "OTA:c17.", "")

                    unitData[v] = {
                        name = name,
                        steamid = v:SteamID64(),
                        color = colors["white"],
                    }

                    draw.DrawText("::>", "CombineFont25", ScrW() - 10, 5 + unitSpacing, colors["white"], TEXT_ALIGN_RIGHT)
                    if not ( v:Alive() ) then
                        draw.DrawText("K.I.A", "CombineFont25", ScrW() - 40, 5 + unitSpacing, colors["red"], TEXT_ALIGN_RIGHT)
                    else
                        draw.DrawText("ACTIVE", "CombineFont25", ScrW() - 40, 5 + unitSpacing, colors["green"], TEXT_ALIGN_RIGHT)
                    end

                    draw.DrawText(unitData[v].name.." | ", "CombineFont25", ScrW() - 120, 5 + unitSpacing, colors["white"], TEXT_ALIGN_RIGHT)
                    unitSpacing = unitSpacing + 20
                end
            end
        end
    end

    -- Bottom Left Corner
    if ( ix.option.Get("unitInformation", true) ) then
        local sanityVar = char:GetSanity() / 100
        local sanity = "Sane"
        if ( sanityVar < 0.2 ) then
            sanity = "Insane"
        elseif ( sanityVar < 0.4 ) then
            sanity = "Disturbed"
        elseif ( sanityVar < 0.6 ) then
            sanity = "Demented"
        else
            sanity = "Sane"
        end

        local textClass = ix.class.list[char:GetClass()].name
        if ( !textClass ) or ( textClass == "" ) then
            textClass = "Unknown"
        end

        draw.DrawText("<:: COGNITIVE STATUS: "..string.upper(sanity), "CombineFont40", 10, ScrH() - 100, colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText("<:: "..ply:Nick(), "CombineFont40", 10, ScrH() - 140, colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText("<:: "..textClass, "CombineFont40", 10, ScrH() - 180, colors["white"], TEXT_ALIGN_LEFT)

        draw.DrawText(math.Clamp(ply:Health(), 0, 999), "CombineFont60", 100, ScrH() - 60, colors["red"], TEXT_ALIGN_RIGHT)
        draw.DrawText("VITALS", "CombineFont30", 110, ScrH() - 40, colors["red"], TEXT_ALIGN_LEFT)

        draw.DrawText(math.Clamp(ply:Armor(), 0, 999), "CombineFont60", 320, ScrH() - 60, colors["blue"], TEXT_ALIGN_RIGHT)
        draw.DrawText("PCV", "CombineFont30", 330, ScrH() - 40, colors["blue"], TEXT_ALIGN_LEFT)

        draw.DrawText(math.Clamp(math.Round(ply:GetNetVar("attribute_stamina", 100), 0), 0, 100), "CombineFont60", 490, ScrH() - 60, colors["yellow"], TEXT_ALIGN_RIGHT)
        draw.DrawText("EXERTION", "CombineFont30", 500, ScrH() - 40, colors["yellow"], TEXT_ALIGN_LEFT)

        if not ( ply:Team() == FACTION_OTA ) then
            draw.DrawText(math.Clamp(char:GetHunger(), 0, 100), "CombineFont60", 740, ScrH() - 60, colors["green"], TEXT_ALIGN_RIGHT)
            draw.DrawText("NUTRITION", "CombineFont30", 750, ScrH() - 40, colors["green"], TEXT_ALIGN_LEFT)
        end
    end

    -- Bottom Middle
    if ( ix.option.Get("batonStatus", true) ) then
        local wep = ply:GetActiveWeapon()
        if ( wep and IsValid(wep) ) and ( wep:GetClass() == "ix_stunstick" and ply:IsWepRaised() ) then
            local mode = wep:GetMode()
            if ( mode == 1 ) then
                draw.SimpleText("Baton Status: Grounded", "CombineFont30", ScrW() / 2, ScrH() / 1.5 + 40, colors["blue"], TEXT_ALIGN_CENTER)
            elseif ( mode == 2 ) then
                draw.SimpleText("Baton Status: Pacify", "CombineFont30", ScrW() / 2, ScrH() / 1.5 + 40, colors["yellow"], TEXT_ALIGN_CENTER)
            elseif ( mode == 3 ) then
                draw.SimpleText("Baton Status: Stun Mode", "CombineFont30", ScrW() / 2, ScrH() / 1.5 + 40, colors["red"], TEXT_ALIGN_CENTER)
            end
        end
    end

    if ( ply:Team() == FACTION_OTA ) then
        if ( PLUGIN.OTASquads[ply:SteamID()] ) then
            local addition = ( ply:Nick():upper():find("ORDINAL") and " - Stabilization Team Leader" ) or ""
            draw.DrawText("<:: "..PLUGIN.OTASquads[ply:SteamID()]..addition, "CombineFont40", 10, ScrH() - 220, otasquadcols[PLUGIN.OTASquads[ply:SteamID()]], TEXT_ALIGN_LEFT)
        end
    end
end

net.Receive("ixStartBootSequence", function()
    bootDone = nil
    bootMessageID = 0
    nextBootMessage = nil
end)