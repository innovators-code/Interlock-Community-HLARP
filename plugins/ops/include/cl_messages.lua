ix.ops = ix.ops or {}
ix.ops.Reports = ix.ops.Reports or {}
ix.ops.Log = ix.ops.Log or {}

function ix.ops.NewLog(msg, isMe)
    table.insert(ix.ops.Log, {
        message = msg,
        isMe = isMe or false,
        time = CurTime()
    })

    if not isMe then
        OPS_LASTMSG_CLOSE = false
    end
end

local uniqueReportKey = 0
net.Receive("opsReportMessage", function()
    local reportId = net.ReadUInt(16)
    local msgId = net.ReadUInt(4)

    if msgId == 1 then
        LocalPlayer():Notify("Report submitted for review. Thank you for doing your part in keeping the community clean. Report ID: #"..reportId..".")
        LocalPlayer():Notify("If you have any further requests or info for us, just send another report by pressing F2.")

        ix.ops.NewLog({Color(50, 205, 50), "(#"..reportId..") Report submitted", color_white, " message: "..(ix_reportMessage or "")}, true)
        ix.ops.CurReport = reportId
        uniqueReportKey = uniqueReportKey + 1

        local urkCopy = uniqueReportKey + 0
        timer.Simple(360, function()
            if ix.ops.CurReport and urkCopy == uniqueReportKey and not ix.ops.CurReportClaimed then
                LocalPlayer():Notify("Apologies for the delay in processing your report. We will resolve your report as soon as possible.")
                ix.ops.NewLog({"(#"..reportId..") Apologies for the delay in processing your report. We will resolve your report as soon as possible"}, false)

                if ix_userReportMenu and IsValid(ix_userReportMenu) then
                    ix_userReportMenu:SetupUI()
                end
            end
        end)

        timer.Simple(1, function()
            if ix.ops.CurReport then
                ix.ops.DaleRead(ix_reportMessage or "")
            end
        end)
    elseif msgId == 2 then
        LocalPlayer():Notify("Your report has been updated. Thank you for keeping us informed. Report ID: #"..reportId..".")
        ix.ops.NewLog({"(#"..reportId..") Report updated: "..ix_reportMessage or ""}, true)

        timer.Simple(1, function()
            if ix.ops.CurReport then
                ix.ops.DaleRead(ix_reportMessage or "")
            end
        end)
    elseif msgId == 3 then
        local claimer = net.ReadEntity()

        if IsValid(claimer) then
            LocalPlayer():Notify("Your report has been claimed for review by a game moderator ("..claimer:SteamName()..").")
            ix.ops.NewLog({Color(255, 140, 0), "(#"..reportId..") Report claimed for review by a game moderator ("..claimer:SteamName()..") and currently under review"}, false)
        end

        ix.ops.CurReportClaimed = true
    elseif msgId == 4 then
        local claimer = net.ReadEntity()

        if IsValid(claimer) then
            LocalPlayer():Notify("Your report has been closed by a game moderator ("..claimer:SteamName().."). We hope we have managed to resolve your issue.")
            ix.ops.NewLog({Color(240, 0, 0), "(#"..reportId..") Report closed by a game moderator ("..claimer:SteamName()..")"}, false)
        else
            ix.ops.NewLog({Color(240, 0, 0), "(#"..reportId..") Report closed by a game moderator"}, false)
        end

        ix.ops.CurReport = nil
        ix.ops.CurReportClaimed = nil
    end

    if ix_userReportMenu and IsValid(ix_userReportMenu) then
        ix_userReportMenu:SetupUI()
    end
end)

net.Receive("opsReportAdminMessage", function()
    local claimer = net.ReadEntity()
    local msg = net.ReadString()

    if IsValid(claimer) and ix.ops.CurReport then
        LocalPlayer():Notify("A game moderator has replied to your report. Press F2 to view it.")
        ix.ops.NewLog({"(#"..ix.ops.CurReport..") ", "Game moderator reply", " ("..claimer:SteamName().."): ", color_white, msg}, false)

        if ix_userReportMenu and IsValid(ix_userReportMenu) then
            ix_userReportMenu:SetupUI()
        end
    end
end)

local newReportCol = Color(173, 255, 47)
local claimedReportCol = Color(147, 112, 219)

net.Receive("opsNewReport", function()
    local sender = net.ReadEntity()
    local reportId = net.ReadUInt(16)
    local message = net.ReadString()

    if not IsValid(sender) then return end

    if ix.option.Get("admin_onduty") then
        chat.AddText(newReportCol, "[NEW REPORT] [#"..reportId.."] ", sender:SteamName(), " (", sender:Name(), "): ", message)
        surface.PlaySound("buttons/blip1.wav")

        if WinToast then
               WinToast.Show("New report [#"..reportId.."] from "..sender:SteamName(), message)
        end
    end

    ix.ops.Reports[reportId] = {sender, message}

    if ix_reportMenu and IsValid(ix_reportMenu) then
        ix_reportMenu:ReloadReports()
    end
end)

net.Receive("opsReportUpdate", function()
    local sender = net.ReadEntity()
    local reportId = net.ReadUInt(16)
    local message = net.ReadString()

    if not IsValid(sender) then return end

    if ix.option.Get("admin_onduty") then
        if ix.ops.Reports[reportId] and ix.ops.Reports[reportId][3] and ix.ops.Reports[reportId][3] == LocalPlayer() then
            chat.AddText(claimedReportCol, "[REPORT UPDATE] [#"..reportId.."] ", sender:SteamName(), " (", sender:Name(), "): ", message)
            surface.PlaySound("buttons/blip1.wav")

            if WinToast then
                WinToast.Show("Report updated [#"..reportId.."]", message)
            end
        end
    end

    if ix.ops.Reports and ix.ops.Reports[reportId] then
        ix.ops.Reports[reportId][2] = ix.ops.Reports[reportId][2].." + "..message
    end
end)

net.Receive("opsReportClaimed", function()
    local claimer = net.ReadEntity()
    local reportId = net.ReadUInt(16)

    if not IsValid(claimer) then return end

    if ix.option.Get("admin_onduty") then
        if LocalPlayer() == claimer then
            chat.AddText(claimedReportCol, "[REPORT] [#"..reportId.."] claimed by "..claimer:SteamName())
        else
            chat.AddText(newReportCol, "[REPORT] [#"..reportId.."] claimed by "..claimer:SteamName())
        end
    end

    if ix.ops.Reports and ix.ops.Reports[reportId] then
        ix.ops.Reports[reportId][3] = claimer
    end

    if ix_reportMenu and IsValid(ix_reportMenu) then
        ix_reportMenu:ReloadReports()
    end
end)

net.Receive("opsReportClosed", function()
    local closer = net.ReadEntity()
    local reportId = net.ReadUInt(16)

    if not IsValid(closer) or closer == Entity(0) then
        if ix.ops.Reports and ix.ops.Reports[reportId] and (not ix.ops.Reports[reportId][3] or not IsValid(ix.ops.Reports[reportId][3])) then
            chat.AddText(newReportCol, "[REPORT] [#"..reportId.."] closed by Dale")
        end
    else
        if ix.option.Get("admin_onduty") then
            if ix.ops.Reports and ix.ops.Reports[reportId] and (not ix.ops.Reports[reportId][3] or not IsValid(ix.ops.Reports[reportId][3])) then
                chat.AddText(newReportCol, "[REPORT] [#"..reportId.."] closed by "..closer:SteamName())
            elseif LocalPlayer() and LocalPlayer() == closer then
                chat.AddText(claimedReportCol, "[REPORT] [#"..reportId.."] closed by "..closer:SteamName())
            end
        end
    end

    ix.ops.Reports[reportId] = nil

    if ix_reportMenu and IsValid(ix_reportMenu) then
        ix_reportMenu:ReloadReports()
    end
end)

net.Receive("opsReportDaleReplied", function()
    local reportId = net.ReadUInt(8)

    if ix.ops.Reports and ix.ops.Reports[reportId] then
        ix.ops.Reports[reportId][4] = true
    end

    if ix_reportMenu and IsValid(ix_reportMenu) then
        ix_reportMenu:ReloadReports()
    end
end)

net.Receive("opsReportSync", function()
    ix.ops.Reports = net.ReadTable() or {}
end)

net.Receive("opsGiveWarn", function()
    local reason = net.ReadString()
    local template = "You have received a warning from a Game Moderator for a violation of the server rules.\nReason: "..reason.."\nPlease read the server rules again before continuing. Repeated offences will be punished by a ban."
    local id = "warn_"..os.time()

    ix.menuMessage.Add(id, "Warning Notice", template, Color(238, 210, 2), "https://panel.impulse-community.com/index.php?t=violations", "View more details")
    ix.menuMessage.Save(id)
end)

net.Receive("opsGiveOOCBan", function()
    local time = net.ReadUInt(16)
    local endTime =  os.time() + time
    local endDate = os.date("%H:%M:%S - %d/%m/%Y", endTime)
    local template = "You have an active OOC communication timeout for a violation of the server rules.\nExpiry time: "..endDate
    local id = "oocban_"..endDate

    ix.menuMessage.Add(id, "OOC Timeout Notice", template, Color(179, 58, 58), impulse.Config.RulesURL, "Read the rules", endTime)
    ix.menuMessage.Save(id)
end)

net.Receive("opsGetRecord", function()
    local warns = net.ReadUInt(8)
    local bans = net.ReadUInt(8)
    local curScore = cookie.GetNumber("ops-record-badsportscore", 0)
    local score = 0

    score = score + (bans * 2)
    score = score + warns

    if warns > 3 then
        score = score + 1
    end

    local col = Color(238, 210, 2)
    if score > 9 then
        col = Color(179, 58, 58)
    end

    local template = "You have a poor disciplinary record that consists of "..warns.." warnings and "..bans.." bans.\nPlease take time to read the server rules before continuing as further violations will result in a long-term or possibly permanent suspension."

    if curScore != score and score > 3 then
        ix.menuMessage.Remove("badsport")
        ix.menuMessage.Add("badsport", "Poor Disciplinary Record Notice", template, col, "https://panel.impulse-community.com/index.php?t=violations", "View more details")
    end

    cookie.Set("ops-record-badsportscore", score)
end)