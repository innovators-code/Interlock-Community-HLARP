local PANEL = {}

function PANEL:Init()
    self.IsMenuMessage = true
end

function PANEL:SetMessage(uid)
    self.Message = ix.menuMessage.Data[uid]
    self.Message.colour = ColorAlpha(self.Message.colour, 170)

    self.desc = vgui.Create("DLabel", self)
    self.desc:Dock(FILL)
    self.desc:DockMargin(70, 40, 0, 0)
    self.desc:SetFont("Font-Elements22-Shadow")
    self.desc:SetWrap(true)
    self.desc:SetContentAlignment(7)
    self.desc:SetText(self.Message.message)

    self.close = vgui.Create("DImageButton", self)
    self.close:Dock(RIGHT)
    self.close:DockMargin(0, 40, 10, 10)
    self.close:SetSize(50, 50)
    self.close:SetImage("litenetwork/icons/x.png")

    local panel = self
    function self.close:DoClick()
        panel:Remove()

        if panel.OnClosed then
            panel.OnClosed()
        end
    end

    if self.Message.url then
        self.url = vgui.Create("DLabel", self)
        self.url:SetPos(50, self:GetTall() - 20)
        self.url:SetTextColor(Color(0, 97, 175))
        self.url:SetFont("Font-Elements22-Shadow")
        self.url:SetText(self.Message.urlText or "Find out more...")
        self.url:SetURL(self.Message.url)
        self.url:SetCursor("hand")
        self.url:SetMouseInputEnabled(true)
        self.url:SizeToContents()
        self.url.url = self.Message.url

        function self.url:DoClick()
            gui.OpenURL(self.url)
        end
    end
end

local gradient = Material("vgui/gradient-l")
local icon = Material("litenetwork/icons/warning.png")
local bodyCol = Color(30, 30, 30, 190)
function PANEL:Paint(w,h)
    surface.SetDrawColor(bodyCol)
    surface.DrawRect(0, 0, w, h)

    if self.Message then
        surface.SetDrawColor(self.Message.colour)
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, 0, w, 30)
        surface.SetDrawColor(ColorAlpha(self.Message.colour, 50))
        surface.DrawRect(0, 0, w, 30)

        draw.SimpleText(self.Message.title, "Font-Elements22-Shadow", 10, 16, nil, nil, TEXT_ALIGN_CENTER)

        surface.SetMaterial(icon)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(10, 40, 50, 50)
    end
end

vgui.Register("ixMenuMessage", PANEL, "DPanel")