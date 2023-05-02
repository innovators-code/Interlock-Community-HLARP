local PANEL = {}

local newReportCol = Color(173, 255, 47)
local claimedReportCol = Color(147, 112, 219)

function PANEL:Init()
    self:SetSize(480, 410)
    self:Center()
    self:SetTitle("ops reports")
    gui.EnableScreenClicker(true)
    self:SetPopupStayAtBack(true)

    local panel = self

    self.status = vgui.Create("DLabel", self)
    self.status:SetTall(50)
    self.status:Dock(TOP)

    function self.status:Paint()
        draw.SimpleText(panel.Status, "ixMediumFont", 5, 5, panel.StatusCol)
        draw.SimpleText("Report queue:", "ixSmallFont", 5, 30, color_white)

        return true
    end

    function self.status:Think()
        local reports = ix.ops.Reports
        local cCount = 0
        local ucCount = 0

        for v,k in pairs(reports) do
            if k[3] and IsValid(k[3]) then
                cCount = cCount + 1

                if k[3] == LocalPlayer() then
                    panel.Status = "Processing report #"..v.."..."
                    panel.StatusCol = claimedReportCol
                    return
                end
            else
                ucCount = ucCount + 1
            end
        end

        if ucCount > 0 then
            panel.Status = ucCount.." report(s) awaiting claim and "..cCount.." in processing..."
            panel.StatusCol = Color(255, 255, 0)
        else
            panel.Status = "No reports waiting."
            panel.StatusCol = Color(0, 255, 0)
        end
    end

    self:ReloadReports()
end

function PANEL:OnClose()
    gui.EnableScreenClicker(false)
end

function PANEL:ReloadReports()
    if IsValid(self.scroll) then
        self.scroll:Remove()
    end

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)

    for v,k in pairs(ix.ops.Reports or {}) do
        local report = self.scroll:Add("DPanel")
        report:SetTall(55)
        report:Dock(TOP)
        report.id = v
        report.data = k

        local id = report.id
        local data = k

        if not report.data[3] then
            local claimBtn =  vgui.Create("DButton", report)
            claimBtn:SetPos(300, 0)
            claimBtn:SetSize(40, 23)
            claimBtn:SetText("Claim")
            claimBtn:SetColor(Color(0, 255, 0))

            function claimBtn:DoClick()
                LocalPlayer():ConCommand("say /rc "..id)
            end
        else
            local replyBtn = vgui.Create("DButton", report)
            replyBtn:SetPos(300, 0)
            replyBtn:SetSize(40, 23)
            replyBtn:SetText("Reply")

            function replyBtn:DoClick()
                local reporteeName = "disconnected"

                if IsValid(report.data[1]) then
                    reporteeName = report.data[1]:SteamName()
                end 

                local i = Derma_StringRequest("ops report reply to "..reporteeName, "Message to send:", nil, function(msg)
                    net.Start("ixChatMessage")
                    net.WriteString('/rmsg '..id..' "'..msg..'"')
                    net.SendToServer()
                end, nil, "Send")
            end
        end

        local viewBtn = vgui.Create("DButton", report)
        viewBtn:SetPos(340, 0)
        viewBtn:SetSize(40, 23)
        viewBtn:SetText("View")

        function viewBtn:DoClick()
            Derma_Message(string.Replace(data[2], "+", "\n").."\n                                                    ", "ops report #"..id.." message", "Close")
        end

        local gotoBtn = vgui.Create("DButton", report)
        gotoBtn:SetPos(380, 0)
        gotoBtn:SetSize(40, 23)
        gotoBtn:SetText("Goto")

        function gotoBtn:DoClick()
            LocalPlayer():ConCommand("say /rgoto "..id)
        end

        local ownsReport = true
        if not report.data[3] or not IsValid(report.data[3]) or report.data[3] != LocalPlayer() then
            gotoBtn:SetDisabled(true)
            ownsReport = false
        end

        local closeBtn =  vgui.Create("DButton", report)
        closeBtn:SetPos(420, 0)
        closeBtn:SetSize(40, 23)
        closeBtn:SetText("Close")
        closeBtn:SetColor(Color(255, 0, 0))

        function closeBtn:DoClick()
            local ownsReport = true
            if not report.data[3] or not IsValid(report.data[3]) or report.data[3] != LocalPlayer() then
                ownsReport = false
            end

            if ownsReport then
                LocalPlayer():ConCommand("say /rcl "..id)
            else
                Derma_Query("You are closing a report you have not claimed!\nDo not close reports that others are working on.","ix", "I'm sure", function()
                    LocalPlayer():ConCommand("say /rcl "..id)
                end, "Take me back!")
            end
        end

        function report:Paint(w, h)
            surface.SetDrawColor(Color(70, 70, 70))
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText("#"..self.id, "ixSmallFont", 3, 4, color_white)

            if self.data[3] then
                local claimerName = "disconnected, close me!"
                local col = Color(255, 255, 0)

                if IsValid(self.data[3]) then
                    claimerName = self.data[3]:SteamName()

                    if self.data[3] == LocalPlayer() then
                        col = claimedReportCol
                    end
                end

                draw.SimpleText("Claimed by: "..claimerName, "ixSmallFont", 25, 4, col)
            else
                if self.data[4] then
                    draw.SimpleText("Unclaimed (Dale replied)", "ixSmallFont", 25, 3, newReportCol)
                else
                    draw.SimpleText("Unclaimed", "ixSmallFont", 25, 3, newReportCol)
                end
            end

            local reporteeName = "disconnected"
            if IsValid(self.data[1]) then
                reporteeName = self.data[1]:SteamName().." ("..self.data[1]:Nick()..")"
            end 

            draw.SimpleText("Submitted by: "..reporteeName, "ixSmallFont", 25, 19, color_white)
            draw.SimpleText("Message: "..self.data[2], "ixSmallFont", 3, 36, color_white)

            return true
        end
    end
end


local wait = 0
hook.Add("Think", "ixReportMenuFastOpen", function()
    if (wait > CurTime()) then return end

    if input.IsKeyDown(KEY_F2) then
        if ix_reportMenu and IsValid(ix_reportMenu) then
            local alpha = ix.option.Get("admin_reportalpha", 130)

            if not ix_reportMenu.changing then
                ix_reportMenu.changing = true

                if ix_reportMenu.hiding then
                    gui.EnableScreenClicker(true)
                    ix_reportMenu:AlphaTo(255, 0.5, 0, function()
                        if not IsValid(ix_reportMenu) then return end
                        ix_reportMenu.changing = false
                        ix_reportMenu.hiding = false
                    end)
                else
                    gui.EnableScreenClicker(false)
                    ix_reportMenu:AlphaTo(alpha, 0.5, 0, function()
                        if not IsValid(ix_reportMenu) then return end
                        ix_reportMenu.changing = false
                        ix_reportMenu.hiding = true
                    end)
                end
            end
        elseif LocalPlayer():IsAdmin() then
            ix_reportMenu = vgui.Create("ixReportMenu")
            wait = CurTime() + 1
        end

        if not LocalPlayer():IsAdmin() and not vgui.CursorVisible() then
            if not ix_userReportMenu or not IsValid(ix_userReportMenu) then
                ix_userReportMenu = vgui.Create("ixUserReportMenu")
            end
        end
    end

    if input.IsKeyDown(KEY_F1) and CUR_SNAPSHOT then
        ix.ops.clearSnapshot()
        LocalPlayer():Notify("Snapshot closed.")
    end
end)

vgui.Register("ixReportMenu", PANEL, "DFrame")