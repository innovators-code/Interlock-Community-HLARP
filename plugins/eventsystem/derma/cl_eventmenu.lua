local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetTitle("")
    self:Center()

    self:SetAlpha(0)
    self:AlphaTo(255, 1)
    self:MakePopup()
end

function PANEL:OnRemove()
    self:SetAlpha(255)
    self:AlphaTo(0, 1)
end

vgui.Register("ixEvent.MainMenu", PANEL, "DFrame")