
local CREDITS = {
    {"Alex Grist", "76561197979205163", {"creditLeadDeveloper", "creditManager"}},
    {"Igor Radovanovic", "76561197990111113", {"creditLeadDeveloper", "creditUIDesigner"}},
    {"Jaydawg", "76561197970371430", {"creditTester"}}
}

local CONFLICTCREDITS = {
    {"Riggs.mackay", "76561197963057641", {"Founder", "Lead Developer", "Mapper"}},
    {"Apsys / Skay", "76561198373309941", {"Developer", "Code Assist"}},
    {"Scotnay", "76561197996534315", {"Ex Developer", "Code Assist"}},
    {"Mike White", "76561199172557482", {"UI Designer"}},
}

local CONFLICTADMINCREDITS = {
    {"S-P", "76561198968235942", {"Roleplay Director", "Administrator"}},
    {"Echoloveation", "76561198083610422", {"Administrator"}},
    {"OverwatchVoice", "76561198366800808", {"Administrator"}},
}

local SPECIALS = {
    {
        {"Luna", "76561197988658543"},
        {"Rain GBizzle", "76561198036111376"}
    },
    {
        {"Black Tea", "76561197999893894"}
    }
}

local MISC = {
    {"nebulous", "Staff members finding bugs and providing input"},
    {"Contributors", "Ongoing support from various developers via GitHub"},
    {"NutScript", "Providing the base framework to build upon"},
}

local url = "https://gethelix.co/"
local discordurl = "https://discord.gg/"
local padding = 16

-- nametag
PANEL = {}

function PANEL:Init()
    self.name = self:Add("DLabel")
    self.name:SetFont("ixMenuButtonFontThick")

    self.avatar = self:Add("AvatarImage")
end

function PANEL:SetName(name)
    self.name:SetText(name)
end

function PANEL:SetFont(font)
    surface.SetFont(tostring(font))
    local _, height = surface.GetTextSize("W@")

    self.name:SetTall(height)
    self.name:SetFont(tostring(font))
end

function PANEL:SetAvatar(steamid)
    self.avatar:SetSteamID(steamid, 64)
end

function PANEL:PerformLayout(width, height)
    self.name:SetPos(width - self.name:GetWide(), 0)
    self.avatar:MoveLeftOf(self.name, padding * 0.5)
end

function PANEL:SizeToContents()
    self.name:SizeToContents()

    local tall = self.name:GetTall()
    self.avatar:SetSize(tall, tall)
    self:SetSize(self.name:GetWide() + self.avatar:GetWide() + padding * 0.5, self.name:GetTall())
end

vgui.Register("ixCreditsNametag", PANEL, "Panel")

-- name row
PANEL = {}

function PANEL:Init()
    self:DockMargin(0, padding, 0, 0)
    self:Dock(TOP)

    self.nametag = self:Add("ixCreditsNametag")

    self.tags = self:Add("DLabel")
    self.tags:SetFont("ixMenuButtonFont")

    self:SizeToContents()
end

function PANEL:SetName(name)
    self.nametag:SetName(name)
end

function PANEL:SetAvatar(steamid)
    self.nametag:SetAvatar(steamid)
end

function PANEL:SetTags(tags)
    for i = 1, #tags do
        tags[i] = L(tags[i])
    end

    self.tags:SetText(table.concat(tags, "\n"))
end

function PANEL:Paint(width, height)
    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawRect(width * 0.5 - 1, 0, 1, height)
end

function PANEL:PerformLayout(width, height)
    self.nametag:SetPos(width * 0.5 - self.nametag:GetWide() - padding, 0)
    self.tags:SetPos(width * 0.5 + padding, 0)
end

function PANEL:SizeToContents()
    self.nametag:SizeToContents()
    self.tags:SizeToContents()

    self:SetTall(math.max(self.nametag:GetTall(), self.tags:GetTall()))
end

function PANEL:SetFont(font)
    surface.SetFont(font)
    local _, height = surface.GetTextSize("W@")

    self.nametag:SetTall(height)
    self.nametag:SetFont(font)
    self.tags:SetTall(height)
    self.tags:SetFont(font)
end

vgui.Register("ixCreditsRow", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
    self.left = {}
    self.right = {}
end

function PANEL:AddLeft(name, steamid)
    local nametag = self:Add("ixCreditsNametag")
    nametag:SetName(name)
    nametag:SetAvatar(steamid)
    nametag:SizeToContents()

    self.left[#self.left + 1] = nametag
end

function PANEL:AddRight(name, steamid)
    local nametag = self:Add("ixCreditsNametag")
    nametag:SetName(name)
    nametag:SetAvatar(steamid)
    nametag:SizeToContents()

    self.right[#self.right + 1] = nametag
end

function PANEL:PerformLayout(width, height)
    local y = 0

    for _, v in ipairs(self.left) do
        v:SetPos(width * 0.25 - v:GetWide() * 0.5, y)
        y = y + v:GetTall() + padding
    end

    y = 0

    for _, v in ipairs(self.right) do
        v:SetPos(width * 0.75 - v:GetWide() * 0.5, y)
        y = y + v:GetTall() + padding
    end

    if (IsValid(self.center)) then
        self.center:SetPos(width * 0.5 - self.center:GetWide() * 0.5, y)
    end
end

function PANEL:SizeToContents()
    local heightLeft, heightRight, centerHeight = 0, 0, 0

    if (#self.left > #self.right) then
        local center = self.left[#self.left]
        centerHeight = center:GetTall()

        self.center = center
        self.left[#self.left] = nil
    elseif (#self.right > #self.left) then
        local center = self.right[#self.right]
        centerHeight = center:GetTall()

        self.center = center
        self.right[#self.right] = nil
    end

    for _, v in ipairs(self.left) do
        heightLeft = heightLeft + v:GetTall() + padding
    end

    for _, v in ipairs(self.right) do
        heightRight = heightRight + v:GetTall() + padding
    end

    self:SetTall(math.max(heightLeft, heightRight) + centerHeight)
end

vgui.Register("ixCreditsSpecials", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
    local cs = self:Add("DLabel", self)
    cs:SetFont("InterlockTitleFont")
    cs:SetTextColor(ix.config.Get("color"))
    cs:SetText("Conflict")
    cs:SetContentAlignment(5)
    cs:Dock(TOP)
    cs:SizeToContents()
    cs:SetMouseInputEnabled(false)
    cs:SetCursor("hand")

    local cs = self:Add("DLabel", self)
    cs:SetFont("InterlockTitleFont")
    cs:SetTextColor(ix.config.Get("color"))
    cs:SetText("Studios")
    cs:SetContentAlignment(5)
    cs:Dock(TOP)
    cs:SizeToContents()
    cs:SetMouseInputEnabled(false)
    cs:SetCursor("hand")

    local linknotice = self:Add("DLabel", self)
    linknotice:SetFont("ixMenuButtonFontSmall")
    linknotice:SetTextColor(Color(200, 200, 200, 255))
    linknotice:SetText("Helix Framework")
    linknotice:SetContentAlignment(5)
    linknotice:Dock(TOP)
    linknotice:SizeToContents()

    local link = self:Add("DLabel", self)
    link:SetFont("ixMenuMiniFont")
    link:SetTextColor(ix.config.Get("color"))
    link:SetText(url)
    link:SetContentAlignment(5)
    link:Dock(TOP)
    link:SizeToContents()
    link:SetMouseInputEnabled(true)
    link:SetCursor("hand")
    link.OnMousePressed = function()
        gui.OpenURL(url)
    end

    local linknotice = self:Add("DLabel", self)
    linknotice:SetFont("ixMenuButtonFontSmall")
    linknotice:SetTextColor(Color(200, 200, 200, 255))
    linknotice:SetText("Discord Server")
    linknotice:SetContentAlignment(5)
    linknotice:Dock(TOP)
    linknotice:SizeToContents()

    local link = self:Add("DLabel", self)
    link:SetFont("ixMenuMiniFont")
    link:SetTextColor(ix.config.Get("color"))
    link:SetText(discordurl)
    link:SetContentAlignment(5)
    link:Dock(TOP)
    link:SizeToContents()
    link:SetMouseInputEnabled(true)
    link:SetCursor("hand")
    link.OnMousePressed = function()
        gui.OpenURL(discordurl)
    end

    local confcontri = self:Add("ixLabel")
    confcontri:SetFont("ixMenuButtonFont")
    confcontri:SetText(L("Conflict Studios Contributors"):utf8upper())
    confcontri:SetTextColor(ix.config.Get("color"))
    confcontri:SetDropShadow(1)
    confcontri:SetKerning(8)
    confcontri:SetContentAlignment(5)
    confcontri:DockMargin(0, padding * 2, 0, padding)
    confcontri:Dock(TOP)
    confcontri:SizeToContents()

    for k, v in ipairs(CONFLICTCREDITS) do
        local rowconf = self:Add("ixCreditsRow")
        rowconf:SetName(v[1])
        rowconf:SetAvatar(v[2])
        rowconf:SetTags(v[3])
        rowconf:SizeToContents()
    end

    local confstaff = self:Add("ixLabel")
    confstaff:SetFont("ixMenuButtonFont")
    confstaff:SetText(L("Conflict Studios Administration Team"):utf8upper())
    confstaff:SetTextColor(ix.config.Get("color"))
    confstaff:SetDropShadow(1)
    confstaff:SetKerning(8)
    confstaff:SetContentAlignment(5)
    confstaff:DockMargin(0, padding * 2, 0, padding)
    confstaff:Dock(TOP)
    confstaff:SizeToContents()

    for k, v in ipairs(CONFLICTADMINCREDITS) do
        local rowconf = self:Add("ixCreditsRow")
        rowconf:SetName(v[1])
        rowconf:SetAvatar(v[2])
        rowconf:SetTags(v[3])
        rowconf:SizeToContents()
    end

    local specialhelix = self:Add("ixLabel")
    specialhelix:SetFont("ixMenuButtonFont")
    specialhelix:SetText(L("Thanks to helix this project is possible."):utf8upper())
    specialhelix:SetTextColor(ix.config.Get("color"))
    specialhelix:SetDropShadow(1)
    specialhelix:SetKerning(8)
    specialhelix:SetContentAlignment(5)
    specialhelix:DockMargin(0, padding * 2, 0, padding)
    specialhelix:Dock(TOP)
    specialhelix:SizeToContents()

    for _, v in ipairs(CREDITS) do
        local row = self:Add("ixCreditsRow")
        row:SetName(v[1])
        row:SetAvatar(v[2])
        row:SetTags(v[3])
        row:SizeToContents()
    end

    local specialList = self:Add("ixCreditsSpecials")
    specialList:DockMargin(0, padding, 0, 0)
    specialList:Dock(TOP)

    for _, v in ipairs(SPECIALS[1]) do
        specialList:AddLeft(v[1], v[2])
    end

    for _, v in ipairs(SPECIALS[2]) do
        specialList:AddRight(v[1], v[2])
    end

    specialList:SizeToContents()

    -- less more padding if there's a center column nametag
    if (IsValid(specialList.center)) then
        specialList:DockMargin(0, padding, 0, padding)
    end

    for _, v in ipairs(MISC) do
        local title = self:Add("DLabel")
        title:SetFont("ixMenuButtonFontThick")
        title:SetText(v[1])
        title:SetContentAlignment(5)
        title:SizeToContents()
        title:DockMargin(0, padding, 0, 0)
        title:Dock(TOP)

        local description = self:Add("DLabel")
        description:SetFont("ixSmallTitleFont")
        description:SetText(v[2])
        description:SetContentAlignment(5)
        description:SizeToContents()
        description:Dock(TOP)
    end

    self:Dock(TOP)
    self:SizeToContents()
end

function PANEL:SizeToContents()
    local height = padding

    for _, v in pairs(self:GetChildren()) do
        local _, top, _, bottom = v:GetDockMargin()
        height = height + v:GetTall() + top + bottom
    end

    self:SetTall(height)
end

vgui.Register("ixCredits", PANEL, "Panel")

hook.Add("PopulateHelpMenu", "ixCredits", function(tabs)
    tabs["credits"] = function(container)
        container:Add("ixCredits")
    end
end)