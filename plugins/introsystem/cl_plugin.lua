--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

net.Receive("ixIntroStart", function()
    LocalPlayer().ixIntroState = true

    LocalPlayer().ixIntroOrigin = nil
    LocalPlayer().ixIntroAngles = nil
    LocalPlayer().ixIntroFOV = nil
    LocalPlayer().ixIntroStage = 1
    LocalPlayer().ixIntroStageDelay = CurTime() + 20
end)

local outputText = ""
local textPos = 1
local nextTime = 0
function PLUGIN:HUDPaint()
    local ply = LocalPlayer()

    if ( LocalPlayer().ixIntroState ) then
        local introTable = ix.intro.config[game.GetMap()].view

        if not ( introTable[ply.ixIntroStage] ) then return end

        draw.DrawText(introTable[ply.ixIntroStage][4] or "", "InterlockFont30-Light", ScrW() / 2, ScrH() - 100 , color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PLUGIN:CalcView(ply, origin, angles, fov)
    if ( ply.ixIntroState ) then
        if not ( ply.ixIntroStage ) then
            ply.ixIntroStage = 1
        end

        if not ( ply.ixIntroStageDelay ) then
            ply.ixIntroStageDelay = CurTime() + 20
        end

        local introTable = ix.intro.config[game.GetMap()].view
        if not ( introTable[ply.ixIntroStage] ) then return end

        if not ( ply.ixIntroOrigin or ply.ixIntroAngles or ply.ixIntroFOV ) then
            ply.ixIntroOrigin = introTable[ply.ixIntroStage][1][1]
            ply.ixIntroAngles = introTable[ply.ixIntroStage][1][2]
            ply.ixIntroFOV = introTable[ply.ixIntroStage][3][1]

            net.Start("ixIntroStarted")
                net.WriteVector(introTable[ply.ixIntroStage][1][1])
            net.SendToServer()
        end

        ply.ixIntroOrigin = LerpVector(FrameTime() * 0.2, ply.ixIntroOrigin, introTable[ply.ixIntroStage][2][1])
        ply.ixIntroAngles = LerpAngle(FrameTime() * 0.2, ply.ixIntroAngles, introTable[ply.ixIntroStage][2][2])
        ply.ixIntroFOV = Lerp(FrameTime() * 0.2, ply.ixIntroFOV, introTable[ply.ixIntroStage][3][2])

        if ( ply.ixIntroStageDelay < CurTime() ) then
            ply.ixIntroStage = ply.ixIntroStage + 1
            ply.ixIntroStageDelay = CurTime() + 20

            if ( introTable[ply.ixIntroStage] ) then
                ply.ixIntroOrigin = introTable[ply.ixIntroStage][1][1]
                ply.ixIntroAngles = introTable[ply.ixIntroStage][1][2]
                ply.ixIntroFOV = introTable[ply.ixIntroStage][3][1]
                net.Start("ixIntroUpdate")
                    net.WriteVector(introTable[ply.ixIntroStage][1][1])
                net.SendToServer()
            else
                net.Start("ixIntroComplete")
                net.SendToServer()
                ply.ixIntroState = nil
            end
        end

        local view = {}
        view.origin = ply.ixIntroOrigin or origin
        view.angles = ply.ixIntroAngles or angles
        view.fov = ply.ixIntroFOV or 60
        view.drawviewer = true

        return view
    end
end

concommand.Add("conflict_dev_intro_getpos", function(ply)
    local pos = ply:EyePos()

    local introDetails = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    
    SetClipboardText(introDetails)
end)

concommand.Add("conflict_dev_intro_getang", function(ply)
    local ang = ply:GetAngles()

    local introDetails = "Angle("..ang.p..", "..ang.y..", "..ang.r..")"

    SetClipboardText(introDetails)
end)

concommand.Add("conflict_dev_intro_getposang", function(ply)
    local pos = ply:EyePos()
    local ang = ply:GetAngles()

    local introDetails = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    introDetails = introDetails..",\nAngle("..ang.p..", "..ang.y..", "..ang.r..")"

    SetClipboardText(introDetails)
end)

concommand.Add("conflict_dev_intro_end", function(ply)
    ply.ixIntroState = nil
end)