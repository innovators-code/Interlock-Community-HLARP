local PLUGIN = PLUGIN

local red = Color(255, 0, 0, 255)
local green = Color(0, 240, 0, 255)
local col = Color(255,255,255,120)
local dotToggleTime = 0
local hitgroups = {
    [HITGROUP_GENERIC] = "generic",
    [HITGROUP_HEAD] = "head",
    [HITGROUP_CHEST] = "chest",
    [HITGROUP_STOMACH] = "stomach",
    [HITGROUP_LEFTARM] = "leftarm",
    [HITGROUP_RIGHTARM] = "rightarm",
    [HITGROUP_LEFTLEG] = "leftleg",
    [HITGROUP_RIGHTLEG] = "rightleg",
    [HITGROUP_GEAR] = "belt"
}

function PLUGIN:HUDPaint()
    if LocalPlayer():IsAdmin() and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP then
        local onDuty = ix.option.Get("admin_onduty") or false

        if onDuty then
            draw.SimpleText("OBSERVER MODE", "ixMediumFont", 20, 10, col)
        else
            draw.SimpleText("OBSERVER MODE (OFF DUTY! YOU WILL NOT VIEW INBOUND REPORTS!)", "ixMediumFont", 20, 10, red)
        end

        local staffOn = 0

        for v,k in pairs(player.GetAll()) do
            if k:IsAdmin() then
                staffOn = staffOn + 1
            end
        end

        draw.SimpleText(staffOn.." STAFF ONLINE", "ixSmallFont", ScrW() * .5, 10, col, TEXT_ALIGN_CENTER)

        if OPS_LIGHT then
            draw.SimpleText("LIGHT ON", "ixSmallFont", ScrW() * .5, 30, col, TEXT_ALIGN_CENTER)
        end

        draw.SimpleText("TOTAL REPORTS: " ..#ix.ops.Reports, "ixSmallFont", 20, 30, col)

        local totalClaimed = 0
        for v,k in pairs(ix.ops.Reports) do
            if k[3] then
                totalClaimed = totalClaimed + 1

                if k[3] == LocalPlayer() then
                    if IsValid(k[1]) then
                        draw.SimpleText("REPORTEE: "..k[1]:SteamName().." ("..k[1]:Name()..")", "ixSmallFont", 20, 80, green)
                    else
                        draw.SimpleText("REPORTEE IS INVALID! CLOSE THIS REPORT.", "ixSmallFont", 20, 80, green)
                    end
                end
            end
        end

        draw.SimpleText("CLAIMED REPORTS: " ..totalClaimed, "ixSmallFont", 20, 50, col)

        if LocalPlayer():IsAdmin() and ix.option.Get("admin_esp") then
            draw.SimpleText("ENTCOUNT: "..#ents.GetAll(), "ixSmallFont", 20, 100, col)
            draw.SimpleText("PLAYERCOUNT: "..#player.GetAll(), "ixSmallFont", 20, 120, col)

            if ix.Dispatch then
                local ccode = ix.Dispatch.CityCodes[ix.Dispatch.GetCityCode()]
                draw.SimpleText("CITYCODE: "..ccode[1], "ixSmallFont", 20, 140, ccode[2])
            end

            local y = 160

            for v,k in pairs(ix.faction.indices) do
                draw.SimpleText(team.GetName(v)..": "..#team.GetPlayers(v), "ixSmallFont", 20, y, col)
                y = y + 20
            end

            for v,k in pairs(player.GetAll()) do
                if k ==  LocalPlayer() then continue end
                
                local pos = (k:GetPos() + k:OBBCenter()):ToScreen()
                local col = team.GetColor(k:Team())


                if k:IsAdmin() and k:GetMoveType() == MOVETYPE_NOCLIP and k:GetNoDraw() then
                    draw.SimpleText("** In Observer Mode **", "ixSmallFont", pos.x, pos.y, Color(255, 0, 0), TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(k:Name(), "ixSmallFont", pos.x, pos.y, col, TEXT_ALIGN_CENTER)
                end

                draw.SimpleText(k:SteamName(), "ixSmallFont", pos.x, pos.y + 15, ix.config.Get("color"), TEXT_ALIGN_CENTER)
            end
        end

        if CUR_SNAPSHOT then
            local snapData = ix.ops.Snapshots[CUR_SNAPSHOT]
            ix.ops.Snapshots[CUR_SNAPSHOT].VictimNeatName = ix.ops.Snapshots[CUR_SNAPSHOT].VictimNeatName or ((IsValid(snapData.Victim) and snapData.Victim:IsPlayer()) and (snapData.VictimNick.." ("..snapData.Victim:SteamName()..")") or snapData.VictimID)
            ix.ops.Snapshots[CUR_SNAPSHOT].InflictorNeatName = ix.ops.Snapshots[CUR_SNAPSHOT].InflictorNeatName or ((IsValid(snapData.Inflictor) and snapData.Inflictor:IsPlayer()) and (snapData.InflictorNick.." ("..snapData.Inflictor:SteamName()..")") or snapData.InflictorID)

            draw.SimpleText("VIEWING SNAPSHOT #"..CUR_SNAPSHOT.." (CLOSE WITH F1)", "ixSmallFont", 250, 100, col)
            draw.SimpleText("VICTIM: "..snapData.VictimNeatName.." ["..snapData.VictimID.."]", "ixSmallFont", 250, 120, Color(255, 0, 0))
            draw.SimpleText("ATTACKER: "..snapData.InflictorNeatName.." ["..snapData.InflictorID.."]", "ixSmallFont", 250, 140, Color(0, 255, 0))

            for v,k in pairs(ix.ops.SnapshotEnts) do
                local pos = (k:GetPos() + k:OBBCenter()):ToScreen()
                local col = k:GetColor()

                draw.SimpleText(k.IsVictim and snapData.VictimNeatName or snapData.InflictorNeatName, "ixSmallFont", pos.x, pos.y, col, TEXT_ALIGN_CENTER)

                if not k.IsVictim then
                    draw.SimpleText("WEP: "..snapData.AttackerClass, "ixSmallFont", pos.x, pos.y + 20, col, TEXT_ALIGN_CENTER)
                    draw.SimpleText("HP: "..snapData.InflictorHealth, "ixSmallFont", pos.x, pos.y + 40, col, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText("HITGROUP: "..hitgroups[snapData.VictimHitGroup], "ixSmallFont", pos.x, pos.y + 20, col, TEXT_ALIGN_CENTER)
                end
            end
        end

        if ix.ops.eventManager and ix.ops.eventManager.GetEventMode() and ix.ops.eventManager.GetSequence() then
            local symb = "•"

            if dotToggleTime < CurTime() then
                symb = ""

                if dotToggleTime + 1 < CurTime() then
                    dotToggleTime = CurTime() + 1
                end
            end

            draw.SimpleText(symb.." LIVE (CURRENT SEQUENCE: "..ix.ops.eventManager.GetSequence()..")", "ixSmallFont", ScrW() - 20, 20, red, TEXT_ALIGN_RIGHT)
        end
    end
end

function PLUGIN:ShouldHideBars()
    if LocalPlayer():IsAdmin() and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP then
        return true
    end
end

local letterboxFde = 0
local textFde = 0
local holdTime
function PLUGIN:HUDPaintBackground()
    if ix.ops.cinematicIntro and LocalPlayer():Alive() then
        local ft = FrameTime()
        local maxTall =  ScrH() * .12

        if holdTime and holdTime + 6 < CurTime() then
            letterboxFde = math.Clamp(letterboxFde - ft * .5, 0, 1)
            textFde = math.Clamp(textFde - ft * .3, 0, 1)

            if letterboxFde == 0 then
                ix.ops.cinematicIntro = false
            end
        elseif holdTime and holdTime + 4 < CurTime() then
            textFde = math.Clamp(textFde - ft * .3, 0, 1)
        else
            letterboxFde = math.Clamp(letterboxFde + ft * .5, 0, 1)

            if letterboxFde == 1 then
                textFde = math.Clamp(textFde + ft * .1, 0, 1)
                holdTime = holdTime or CurTime()
            end
        end

        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, ScrW(), (maxTall * letterboxFde))
        surface.DrawRect(0, (ScrH() - (maxTall * letterboxFde)) + 1, ScrW(), maxTall)

        draw.SimpleText(ix.ops.cinematicTitle, "ixSubTitleFont", 50, ScrH() - maxTall / 2, ColorAlpha(color_white, (255 * textFde)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        letterboxFde = 0
        textFde = 0
        holdTime = nil
    end
end