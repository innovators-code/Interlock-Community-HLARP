--[[
    Helix Plugin made by Ghost
    https://steamcommunity.com/id/GhostL0L
--]]

local PANEL = {}

function PANEL:Init()
    self:SetDraggable(false)
    self:SetSizable(false)
    self:SetBackgroundBlur(true)
    self:SetSize(512, 512)
    self:Center()
    self:MakePopup()
end

function PANEL:Populate(title, text)
    self:SetTitle("\""..title.."\"")

    self.htmlPanel = self:Add("HTML")
    self.htmlPanel:SetHTML(text)
    self.htmlPanel:SetWrap(true)
end

function PANEL:PerformLayout()
    if (IsValid(self.htmlPanel)) then
        self.htmlPanel:StretchToParent(4, 28, 4, 30)
    end
    
    DFrame.PerformLayout(self)
end

vgui.Register("ixViewBook", PANEL, "DFrame")