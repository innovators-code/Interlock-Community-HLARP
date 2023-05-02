
local PANEL = {}

-- changelogs panel

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "backgroundFraction", "BackgroundFraction", FORCE_NUMBER)

function PANEL:Init()
    local parent = self:GetParent()
    local padding = self:GetPadding()
    local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
    local halfHeight = parent:GetTall() * 0.5 - (padding * 2)

    self.animationTime = 1
    self.backgroundFraction = 1

    -- main panel
    self.panel = self:AddSubpanel("main")
    self.panel:SetTitle("changelogs")
    self.panel.OnSetActive = function()
        self:CreateAnimation(self.animationTime, {
            index = 2,
            target = {backgroundFraction = 1},
            easing = "outQuint",
        })
    end

    -- button list
    local controlList = self.panel:Add("Panel")
    controlList:Dock(LEFT)
    controlList:SetSize(halfWidth, halfHeight)

    local back = controlList:Add("ixMenuButton")
    back:Dock(BOTTOM)
    back:SetText("return")
    back:SizeToContents()
    back.DoClick = function()
        self:SlideDown()
        parent.mainPanel:Undim()
    end

    local scrollPanel = self.panel:Add("DScrollPanel")
    scrollPanel:Dock(FILL)

    for k, v in pairs(Schema.changelogs) do
        local changelogTitle = scrollPanel:Add("DLabel")
        changelogTitle:SetText(k)
        changelogTitle:SetFont("InterlockFontShadow60")
        changelogTitle:SizeToContents()
        changelogTitle:Dock(TOP)

        for _, i in pairs(v) do
            
            local changelogText = scrollPanel:Add("DLabel")
            --changelogText:SetText("⏺ "..i)
            changelogText:SetText("        ".. i)
            changelogText:SetFont("InterlockFontShadow25")
            changelogText:SetContentAlignment(1)
            changelogText:SizeToContents()
            changelogText:Dock(TOP)
        end
    end
end

function PANEL:OnSlideUp()
    self.bActive = true
end

function PANEL:OnSlideDown()
    self.bActive = false
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(150, 150, 150, 255)
    surface.SetMaterial(ix.util.GetMaterial("interlock/images/alyx/4.jpg"))
    surface.DrawTexturedRect(0, 0, width, height)

    ix.util.DrawBlur(self, 3)
end

vgui.Register("ixCharMenuChangelogs", PANEL, "ixCharMenuPanel")