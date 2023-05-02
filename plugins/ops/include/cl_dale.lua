ix.ops = ix.ops or {}
ix.ops.Reports = ix.ops.Reports or {}

local strFind = string.find
local closeMsg = "If I've managed to solve your issue please say 'solved' to close the report."

local function doSay(message)
    ix.ops.NewLog({"(#"..ix.ops.CurReport..") ", "Automated reply", Color(172, 103, 0), " (Dale)", color_white, ": ", Color(208, 201, 198), message}, false)

    if ix_userReportMenu and IsValid(ix_userReportMenu) then
        ix_userReportMenu:SetupUI()
    end
end

function ix.ops.DaleRead(message)
    if ix.ops.CurReportClaimed then
        return
    end

    message = string.Trim(message, " ")
    message = string.Replace(message, "\n", "")
    message = string.upper(message)

    local messageNoPunc = string.Replace(message, ".", "")
    messageNoPunc = string.Replace(messageNoPunc, "?", "")
    messageNoPunc = string.Replace(messageNoPunc, ",", "")
    messageNoPunc = string.Replace(messageNoPunc, "!", "")

    if messageNoPunc == "SOLVED" and ix.ops.CurReport and OPS_LASTMSG_CLOSE then
        doSay("Thanks for your report! Have a great day!")

        net.Start("opsReportDaleClose")
        net.SendToServer()
        return
    end

    for v,k in pairs(ix.util.autoModDict) do
        local msg = (k.IgnorePunc or false) and messageNoPunc or message

        if k.Specific then
            for a,term in pairs(k.Terms) do
                if term == msg then
                    if k.Command then LocalPlayer():ConCommand(k.Command) end
                    return ix.ops.DaleSay(k.Reply, k.RequestClose or false)
                end
            end
        elseif k.TermsTogether then
            local tempTerms = {}

            for a,term in pairs(k.Terms) do
                for g,h in pairs(string.Explode(" ", msg, false)) do
                    if h == term then
                        tempTerms[term] = true
                    end
                end
            end

            local fail = false
            for a,b in pairs(k.Terms) do
                if not tempTerms[b] then
                    fail = true
                    break
                end
            end

            if fail then
                continue
            end

            if k.Command then LocalPlayer():ConCommand(k.Command) end
            return ix.ops.DaleSay(k.Reply, k.RequestClose or false)
        else
            for a,term in pairs(k.Terms) do
                if string.find(msg, term, nil, true) then
                    if k.Command then LocalPlayer():ConCommand(k.Command) end
                    return ix.ops.DaleSay(k.Reply, k.RequestClose or false)
                end
            end
        end
    end
end

function ix.ops.DaleSay(message, requestClose)
    if ix.ops.CurReport then
        LocalPlayer():Notify("A game moderator has replied to your report. Press F2 to view it.")
        doSay(message)

        if requestClose then
            timer.Simple(3, function()
                if ix.ops.CurReport then
                    doSay(closeMsg)
                    OPS_LASTMSG_CLOSE = true
                end
            end)
        end

        net.Start("opsReportDaleRepliedDo")
        net.SendToServer()
    end
end