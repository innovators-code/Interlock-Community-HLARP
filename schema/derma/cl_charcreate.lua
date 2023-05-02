local padding = ScreenScale(16)

-- create character panel
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()
    local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
    local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
    local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

    self:ResetPayload(true)

    self.factionButtons = {}
    self.repopulatePanels = {}

    -- faction selection subpanel
    self.factionPanel = self:AddSubpanel("faction", true)
    self.factionPanel:SetTitle("")
    self.factionPanel.OnSetActive = function()
        -- if we only have one faction, we are always selecting that one so we can skip to the description section
        if (#self.factionButtons == 1) then
            self:SetActiveSubpanel("description", 0)
        end
    end

    local factionBack = self.factionPanel:Add("ixMenuButton")
    factionBack:SetText("Return to Main Menu")
    factionBack:SetFont("InterlockFont30")
    factionBack:SetContentAlignment(5)
    factionBack:Dock(BOTTOM)
    factionBack:SizeToContents()
    factionBack.DoClick = function()
        self.progress:DecrementProgress()

        self:SetActiveSubpanel("faction", 0)
        self:SlideDown()

        parent.mainPanel:Undim()
    end

    local proceed = self.factionPanel:Add("ixMenuButton")
    proceed:SetText("proceed")
    proceed:SetFont("InterlockFont30")
    proceed:SetContentAlignment(5)
    proceed:Dock(BOTTOM)
    proceed:SizeToContents()
    proceed.DoClick = function()
        self.progress:IncrementProgress()

        self:Populate()
        self:SetActiveSubpanel("description")
    end

    local modelList = self.factionPanel:Add("Panel")
    modelList:Dock(RIGHT)
    modelList:SetSize(halfWidth + padding * 2, halfHeight)

    self.factionButtonsPanel = self.factionPanel:Add("ixCharMenuButtonList")
    self.factionButtonsPanel:SetWide(halfWidth)
    self.factionButtonsPanel:Dock(FILL)

    -- character customization subpanel
    self.description = self:AddSubpanel("description")
    self.description:SetTitle("")

    local paddingPanel = self.description:Add("Panel")
    paddingPanel:Dock(FILL)
    paddingPanel.Paint = function(panel, w, h)
    end

    self.description.descriptionPanel = paddingPanel:Add("DScrollPanel")
    self.description.descriptionPanel:Dock(FILL)
    self.description.descriptionPanel:DockMargin(20, 20, 20, 20)

    local buttons = self.description:Add("Panel")
    buttons:Dock(BOTTOM)
    buttons:SetTall(proceed:GetTall())

    local back = buttons:Add("ixMenuButton")
    back:SetText("return")
    back:SetFont("InterlockFont30")
    back:SetContentAlignment(4)
    back:Dock(LEFT)
    back:SizeToContents()
    back:SetWide(self.description:GetWide() / 2)
    back.DoClick = function()
        self.progress:DecrementProgress()

        if (#self.factionButtons == 1) then
            factionBack:DoClick()
        else
            self:SetActiveSubpanel("faction")
        end
    end

    local create = buttons:Add("ixMenuButton")
    create:SetText("finish")
    create:SetFont("InterlockFont30")
    create:SetContentAlignment(6)
    create:Dock(RIGHT)
    create:SizeToContents()
    create:SetWide(self.description:GetWide() / 2)
    create.DoClick = function()
        if ( self:VerifyProgression("description") ) then
            self:SendPayload()
        end
    end

    self.description.attributesPanel = self.description:Add("DScrollPanel")
    self.description.attributesPanel:SetSize(halfWidth / 2, self.description:GetTall())
    self.description.attributesPanel:Dock(LEFT)
    self.description.attributesPanel.Paint = function(panel, w, h)
    end

    local attrTitle = self.description.attributesPanel:Add("DLabel")
    attrTitle:SetText("Character Statistics")
    attrTitle:SetFont("InterlockFontShadow30")
    attrTitle:SetContentAlignment(5)
    attrTitle:SizeToContents()
    attrTitle:Dock(TOP)
    attrTitle:DockMargin(20, 20, 20, -10) -- will this work?

    local previewModel = self.description.attributesPanel:Add("ixModelPanel")
    previewModel:Dock(FILL)
    previewModel:SetModel("models/error.mdl")
    previewModel:SetFOV(modelFOV - 10)

    -- creation progress panel
    self.progress = self:Add("ixSegmentedProgress")
    self.progress:SetBarColor(ix.config.Get("color"))
    self.progress:SetSize(parent:GetWide(), 0)
    self.progress:SizeToContents()
    self.progress:SetPos(0, parent:GetTall() - self.progress:GetTall())

    -- setup payload hooks
    self:AddPayloadHook("model", function(value)
        local faction = ix.faction.indices[self.payload.faction]

        if (faction) then
            local model = faction:GetModels(LocalPlayer())[value]

            -- assuming bodygroups
            if (istable(model)) then
                previewModel:SetModel(model[1], model[2] or 0, model[3])
            else
                previewModel:SetModel(model)
            end
        end
    end)

    -- setup character creation hooks
    net.Receive("ixCharacterAuthed", function()
        timer.Remove("ixCharacterCreateTimeout")
        self.awaitingResponse = false

        local id = net.ReadUInt(32)
        local indices = net.ReadUInt(6)
        local charList = {}

        for _ = 1, indices do
            charList[#charList + 1] = net.ReadUInt(32)
        end

        ix.characters = charList

        self:SlideDown()

        if (!IsValid(self) or !IsValid(parent)) then
            return
        end

        if (LocalPlayer():GetCharacter()) then
            parent.mainPanel:Undim()
            parent:ShowNotice(2, L("charCreated"))
        elseif (id) then
            self.bMenuShouldClose = true

            net.Start("ixCharacterChoose")
                net.WriteUInt(id, 32)
            net.SendToServer()
        else
            self:SlideDown()
        end
    end)

    net.Receive("ixCharacterAuthFailed", function()
        timer.Remove("ixCharacterCreateTimeout")
        self.awaitingResponse = false

        local fault = net.ReadString()
        local args = net.ReadTable()

        self:SlideDown()

        parent.mainPanel:Undim()
        parent:ShowNotice(3, L(fault, unpack(args)))
    end)
end

function PANEL:SendPayload()
    if (self.awaitingResponse or !self:VerifyProgression()) then
        return
    end

    self.awaitingResponse = true

    timer.Create("ixCharacterCreateTimeout", 10, 1, function()
        if (IsValid(self) and self.awaitingResponse) then
            local parent = self:GetParent()

            self.awaitingResponse = false
            self:SlideDown()

            parent.mainPanel:Undim()
            parent:ShowNotice(3, L("unknownError"))
        end
    end)

    self.payload:Prepare()

    net.Start("ixCharacterCreate")
    net.WriteUInt(table.Count(self.payload), 8)

    for k, v in pairs(self.payload) do
        net.WriteString(k)
        net.WriteType(v)
    end

    net.SendToServer()
end

function PANEL:OnSlideUp()
    self:ResetPayload()
    self:Populate()
    self.progress:SetProgress(1)

    -- the faction subpanel will skip to next subpanel if there is only one faction to choose from,
    -- so we don't have to worry about it here
    self:SetActiveSubpanel("faction", 0)
end

function PANEL:OnSlideDown()
end

function PANEL:ResetPayload(bWithHooks)
    if (bWithHooks) then
        self.hooks = {}
    end

    self.payload = {}

    -- TODO: eh..
    function self.payload.Set(payload, key, value)
        self:SetPayload(key, value)
    end

    function self.payload.AddHook(payload, key, callback)
        self:AddPayloadHook(key, callback)
    end

    function self.payload.Prepare(payload)
        self.payload.Set = nil
        self.payload.AddHook = nil
        self.payload.Prepare = nil
    end
end

function PANEL:SetPayload(key, value)
    self.payload[key] = value
    self:RunPayloadHook(key, value)
end

function PANEL:AddPayloadHook(key, callback)
    if (!self.hooks[key]) then
        self.hooks[key] = {}
    end

    self.hooks[key][#self.hooks[key] + 1] = callback
end

function PANEL:RunPayloadHook(key, value)
    local hooks = self.hooks[key] or {}

    for _, v in ipairs(hooks) do
        v(value)
    end
end

function PANEL:GetContainerPanel(name)
    -- smort
    if ( name == "attributes" ) then
        return self.description
    end

    return self.description.descriptionPanel
end

function PANEL:AttachCleanup(panel)
    self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Populate()
    if not ( self.bInitialPopulate ) then
        -- setup buttons for the faction panel
        -- TODO: make this a bit less janky
        local lastSelected

        for _, v in pairs(self.factionButtons) do
            if (v:GetSelected()) then
                lastSelected = v.faction
            end

            if (IsValid(v)) then
                v:Remove()
            end
        end

        self.factionButtons = {}

        for _, v in SortedPairs(ix.faction.teams) do
            if (ix.faction.HasWhitelist(v.index)) then
                local button = self.factionButtonsPanel:Add("ixMenuSelectionButton")
                button:SetBackgroundColor(v.color or color_white)
                button:SetText(L(v.name):utf8upper())
                button:SizeToContents()
                button:SetContentAlignment(4)
                button:SetButtonList(self.factionButtons)
                button.faction = v.index
                button.OnSelected = function(panel)
                    local faction = ix.faction.indices[panel.faction]
                    local models = faction:GetModels(LocalPlayer())

                    self.payload:Set("faction", panel.faction)
                    self.payload:Set("model", math.random(1, #models))
                end

                if ((lastSelected and lastSelected == v.index) or (!lastSelected and v.isDefault)) then
                    button:SetSelected(true)
                    lastSelected = v.index
                end
            end
        end
    end

    -- remove panels created for character vars
    for i = 1, #self.repopulatePanels do
        self.repopulatePanels[i]:Remove()
    end

    self.repopulatePanels = {}

    -- payload is empty because we attempted to send it - for whatever reason we're back here again so we need to repopulate
    if (!self.payload.faction) then
        for _, v in pairs(self.factionButtons) do
            if (v:GetSelected()) then
                v:SetSelected(true)
                break
            end
        end
    end

    self.factionButtonsPanel:SizeToContents()

    local zPos = 1

    -- set up character vars
    for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
        if (!v.bNoDisplay and k != "__SortedIndex") then
            local container = self:GetContainerPanel(v.category or "description")

            if (v.ShouldDisplay and v:ShouldDisplay(container, self.payload) == false) then
                continue
            end

            local panel

            -- if the var has a custom way of displaying, we'll use that instead
            if (v.OnDisplay) then
                panel = v:OnDisplay(container, self.payload, self)
            elseif (isstring(v.default)) then
                panel = container:Add("ixTextEntry")
                panel:Dock(TOP)
                panel:SetFont("InterlockFont32")
                panel:SetUpdateOnType(true)
                panel.OnValueChange = function(this, text)
                    self.payload:Set(k, text)
                end
            end

            if (IsValid(panel)) then
                -- add label for entry
                local label = container:Add("DLabel")
                if ( k != "attributes" ) then
                    label:SetFont("InterlockFont32")
                    label:SetText(L(k):utf8upper())
                    label:SizeToContents()
                    label:DockMargin(0, 16, 0, 2)
                    label:Dock(TOP)
                end

                -- we need to set the docking order so the label is above the panel
                if ( k != "attributes" ) then
                    label:SetZPos(zPos - 1)
                end
                panel:SetZPos(zPos)

                if ( k != "attributes" ) then
                    self:AttachCleanup(label)
                end
                if ( k == "attributes" ) then
                    label:Remove()
                end
                self:AttachCleanup(panel)

                if (v.OnPostSetup) then
                    v:OnPostSetup(panel, self.payload, self)
                end

                zPos = zPos + 2
            end
        end
    end

    if not ( self.bInitialPopulate ) then
        self.progress:SetVisible(false) -- don't show the stupid progress segments
    end

    self.bInitialPopulate = true
end

function PANEL:VerifyProgression(name)
    for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
        if (name ~= nil and (v.category or "description") != name) then
            continue
        end

        local value = self.payload[k]

        if (!v.bNoDisplay or v.OnValidate) then
            if (v.OnValidate) then
                local result = {v:OnValidate(value, self.payload, LocalPlayer())}

                if (result[1] == false) then
                    self:GetParent():ShowNotice(3, L(unpack(result, 2)))
                    return false
                end
            end

            self.payload[k] = value
        end
    end

    return true
end

local gradient = surface.GetTextureID("vgui/gradient-d")
function PANEL:Paint(width, height)
	surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 50))
	surface.SetTexture(gradient)
	surface.DrawTexturedRect(0, 0, width, height)
	surface.SetDrawColor(40, 40, 40, 150)
	surface.SetTexture(gradient)
	surface.DrawTexturedRect(0, 0, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")