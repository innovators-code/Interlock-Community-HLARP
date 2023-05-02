local PANEL = {}

-- remade staff manager
function PANEL:Init()
    self:SetSize(600, 400)
    self:SetTitle("ops staff manager")
    self:Center()
    self:MakePopup()

    local sheet = self:Add("DColumnSheet")
    sheet:Dock(FILL)

    for k, v in pairs(player.GetAll()) do
        if not ( v:IsAdmin() ) then
            continue
        end

        if not ( v:GetCharacter() ) then
            continue
        end

        local char = v:GetCharacter()

        local staffMemberPanel = sheet:Add("DPanel")
        staffMemberPanel:Dock(FILL)
        staffMemberPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        end

        local label = staffMemberPanel:Add("DButton")
        label:SetText("Steam Name: "..v:SteamName())
        label:SetFont("ixGenericFont")
        label:SetPos(10, 5)
        label:SizeToContents()
        label.Paint = function()
        end
        label.DoClick = function()
            ix.util.Notify("Copied Steam Name!")
            SetClipboardText(v:SteamName())
        end

        local label = staffMemberPanel:Add("DButton")
        label:SetText("Roleplay Name: "..char:GetData("originalName", v:Nick()))
        label:SetFont("ixGenericFont")
        label:SetPos(10, 25)
        label:SizeToContents()
        label.Paint = function()
        end
        label.DoClick = function()
            ix.util.Notify("Copied Roleplay Name!")
            SetClipboardText(char:GetData("originalName", v:Nick()))
        end

        local label = staffMemberPanel:Add("DButton")
        label:SetText("SteamID: "..v:SteamID())
        label:SetFont("ixGenericFont")
        label:SetPos(10, 45)
        label:SizeToContents()
        label.Paint = function()
        end
        label.DoClick = function()
            ix.util.Notify("Copied SteamID!")
            SetClipboardText(v:SteamID())
        end

        local label = staffMemberPanel:Add("DButton")
        label:SetText("SteamID64: "..v:SteamID64())
        label:SetFont("ixGenericFont")
        label:SetPos(10, 65)
        label:SizeToContents()
        label.Paint = function()
        end
        label.DoClick = function()
            ix.util.Notify("Copied SteamID64!")
            SetClipboardText(v:SteamID64())
        end

        local label = staffMemberPanel:Add("DLabel")
        label:SetText("Total Reports: "..v:GetReports())
        label:SetFont("ixSmallFont")
        label:SetPos(10, 125)
        label:SizeToContents()

        sheet:AddSheet(v:SteamName(), staffMemberPanel)
    end
end

vgui.Register("ixStaffManager", PANEL, "DFrame")