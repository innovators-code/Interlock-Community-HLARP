
local gradient = surface.GetTextureID("vgui/gradient-l")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)

-- character menu panel
DEFINE_BASECLASS("ixSubpanelParent")
local PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
	self:SetPos(0, 0)

	self.childPanels = {}
	self.subpanels = {}
	self.activeSubpanel = ""

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 255
	self.targetDimAmount = 255
	self.targetScale = 0.9
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
			currentScale = self.targetScale
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnDim()
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

function PANEL:Paint(width, height)
	local amount = self.currentDimAmount
	local bShouldScale = self.currentScale != 1
	local matrix

	-- draw child panels with scaling if needed
	if (bShouldScale) then
		matrix = Matrix()
		matrix:Scale(matrixZScale * self.currentScale)
		matrix:Translate(Vector(
			ScrW() * 0.5 - (ScrW() * self.currentScale * 0.5),
			ScrH() * 0.5 - (ScrH() * self.currentScale * 0.5),
			1
		))

		cam.PushModelMatrix(matrix)
		self.currentMatrix = matrix
	end

	BaseClass.Paint(self, width, height)

	if (bShouldScale) then
		cam.PopModelMatrix()
		self.currentMatrix = nil
	end

	if (amount > 0) then
		local color = Color(0, 0, 0, amount)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, width, height)
	end
end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParent")

-- main character menu panel
PANEL = {}

AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = ScrW() * 0.5
	local halfPadding = padding * 0.5
	local bHasCharacter = #ix.characters > 0

	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:DockPadding(padding, padding, padding, padding)

	/*
	local embeddedvideohtml = self:Add("HTML")
	embeddedvideohtml:SetSize(ScrW() + 200, ScrH() + 200)
	embeddedvideohtml:SetPos(-100, -100)
	embeddedvideohtml:SetHTML([[
		<iframe width="100%" height="100%" src="https://www.youtube.com/embed/6TuhowYXClg
		?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=1&amp;modestbranding=1&amp;fs=1" frameborder="0" allowfullscreen></iframe>
	]])

	embeddedvideohtml:SetVisible(true)
	embeddedvideohtml:MoveToBack()

	-- panel on top of embedded video
	local panel = self:Add("Panel")
	panel:SetSize(ScrW(), ScrH())
	panel:SetPos(0, 0)
	panel:SetVisible(true)
	panel.Paint = function(self, w, h)
		ix.util.DrawBlur(self, 1)

		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawRect(0, 0, w, h)
	end
	*/

	-- titleLabel
	local titleLabel = self:Add("DLabel")
	titleLabel:SetTextColor(Color(255, 255, 255, 255))
	titleLabel:SetFont("ixTitleFont")
	titleLabel:SetText(Schema.name)
	titleLabel:SizeToContents()
	titleLabel:SetPos(100, ScrH() / 2.5)

	-- sub title label
	local subTitleLabel = self:Add("DLabel")
	subTitleLabel:SetTextColor(Color(255, 255, 255, 50))
	subTitleLabel:SetFont("ixSubTitleFont")
	subTitleLabel:SetText(Schema.description)
	subTitleLabel:SizeToContents()
	subTitleLabel:SetPos(100, ScrH() / 2.5 + titleLabel:GetTall())

	-- image panel, top right
	local imagePanel = self:Add("Panel")
	imagePanel:SetSize(ScrW() / 10, ScrW() / 10)
	imagePanel:SetPos(ScrW() - imagePanel:GetWide(), 0)
	imagePanel:SetVisible(true)
	imagePanel.Paint = function(self, w, h)
		ix.util.DrawIcon("interlock/interlock_color.png", color_white, 0, 0, w, h)
	end

	-- button panel list
	self.buttonList = self:Add("Panel")
	self.buttonList:SetSize(ScrW() / 2.5, 70)
	self.buttonList.Paint = function(self, w, h)
		surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 100))
		surface.DrawRect(0, 0, w, h)
	end
	self.buttonList:MoveToFront()

	-- rectangle for the button list
	self.buttonListRect = self:Add("Panel")
	self.buttonListRect:SetSize(140, 70)
	self.buttonListRect:SetPos(self.buttonList:GetWide(), 0)
	self.buttonListRect.Paint = function(self, w, h)
		surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 100))
		draw.NoTexture()
		surface.DrawPoly({
			{x = 0, y = 0},
			{x = 140, y = 0},
			{x = 0, y = 70},
		})
	end
	self.buttonListRect:MoveToFront()

	-- bottom button panel
	self.bottomButtonPanel = self:Add("Panel")
	self.bottomButtonPanel:SetSize(ScrW(), 50)
	self.bottomButtonPanel:SetPos(0, ScrH() - self.bottomButtonPanel:GetTall())
	self.bottomButtonPanel.Paint = function(self, w, h)
		surface.SetDrawColor(ColorAlpha(color_black, 150))
		surface.DrawRect(0, 0, w, h)
	end
	self.bottomButtonPanel:MoveToFront()

	local infoLabel = self.bottomButtonPanel:Add("DLabel")
	infoLabel:SetTextColor(ColorAlpha(ix.config.Get("color"), 25))
	infoLabel:SetFont("ixMenuMiniFont")
	infoLabel:SetText("Powered by Helix Framework")
	infoLabel:SizeToContents()
	infoLabel:SetPos(ScrW() - 250, self.bottomButtonPanel:GetTall() / 4)

	-- info label 2
	local infoLabel2 = self.bottomButtonPanel:Add("DLabel")
	infoLabel2:SetTextColor(ColorAlpha(ix.config.Get("color"), 25))
	infoLabel2:SetFont("ixMenuMiniFont")
	infoLabel2:SetText("Schema by "..Schema.author)
	infoLabel2:SizeToContents()
	infoLabel2:SetPos(ScrW() - 250, self.bottomButtonPanel:GetTall() / 4 * 2)

	-- create character button
	local animspeed1 = 3
	local barStatus1 = 0
	
	local createButton = self.buttonList:Add("ixMenuButton")
	createButton:SetText("Create")
	createButton:SetSize(self.buttonList:GetWide() / 3, self.buttonList:GetTall())
	createButton:SetPos(0, 0)
	createButton:SetFont("InterlockFont30-Light")
	createButton:SetContentAlignment(5)
	createButton.DoClick = function()
		local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
		-- don't allow creation if we've hit the character limit
		if (#ix.characters >= maximum) then
			self:GetParent():ShowNotice(3, L("maxCharacters"))
			return
		end

		self:Dim()
		parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
		parent.newCharacterPanel:SlideUp()
	end

	-- load character button
	local animspeed2 = 3
	local barStatus2 = 0

	self.loadButton = self.buttonList:Add("ixMenuButton")
	self.loadButton:SetText("Load")
	self.loadButton:SetSize(self.buttonList:GetWide() / 3, self.buttonList:GetTall())
	self.loadButton:SetPos(self.buttonList:GetWide() / 3, 0)
	self.loadButton:SetFont("InterlockFont30-Light")
	self.loadButton:SetContentAlignment(5)
	self.loadButton.DoClick = function()
		self:Dim()
		parent.loadCharacterPanel:SlideUp()
	end

	if (!bHasCharacter) then
		self.loadButton:SetDisabled(true)
	end

	self.disconnectButton = self.bottomButtonPanel:Add("ixMenuButton")
	self.disconnectButton:SetText("Disconnect")
	self.disconnectButton:SetSize(self.bottomButtonPanel:GetWide() / 10, self.bottomButtonPanel:GetTall())
	self.disconnectButton:SetPos(0, 0)
	self.disconnectButton:SetFont("InterlockFont30-Light")
	self.disconnectButton:SetContentAlignment(5)
	self.disconnectButton.DoClick = function()
		local pnl = Derma_Query(table.Random({"You tired mate?", "Was it that damn boring?", "You're not even trying?", "Try again Later.", "I.. I can't hold on much longer!"}), "Disconnect", "Yes", function()
			RunConsoleCommand("disconnect")
		end, "No")
		
		--RunConsoleCommand("disconnect")
	end

	self.returnButton = self.buttonList:Add("ixMenuButton")
	self:UpdateReturnButton()
	self.returnButton.DoClick = function()
		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end

	self.discord = self.bottomButtonPanel:Add("ixMenuButton")
	self.discord:SetText(ix.config.Get("communityText", "Discord"))
	self.discord:SetSize(self.bottomButtonPanel:GetWide() / 10 + 40, self.bottomButtonPanel:GetTall())
	self.discord:SetPos(190, 0)
	self.discord:SetFont("InterlockFont30-Light")
	self.discord:SetContentAlignment(5)
	self.discord.DoClick = function()
        gui.OpenURL(ix.config.Get("communityURL", "https://google.com"))
	end
end

function PANEL:UpdateReturnButton(bValue)
	if (bValue != nil) then
		self.bUsingCharacter = bValue
	end

	self.returnButton:SetText(self.bUsingCharacter and "Return" or "Leave")
	self.returnButton:SetSize(self.buttonList:GetWide() / 3, self.buttonList:GetTall())
	self.returnButton:SetPos(self.buttonList:GetWide() / 3 * 2, 0)
	self.returnButton:SetFont("InterlockFont30-Light")
	self.returnButton:SetContentAlignment(5)
end

function PANEL:OnDim()
	-- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
	-- panels overtop slide out of the way
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:OnUndim()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	-- we may have just deleted a character so update the status of the return button
	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:UpdateReturnButton()
end

function PANEL:OnClose()
	for _, v in pairs(self:GetChildren()) do
		if (IsValid(v)) then
			v:SetVisible(false)
		end
	end
end

vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")

-- container panel
PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.loading)) then
		ix.gui.loading:Remove()
	end

	if (IsValid(ix.gui.characterMenu)) then
		if (IsValid(ix.gui.characterMenu.channel)) then
			ix.gui.characterMenu.channel:Stop()
		end

		ix.gui.characterMenu:Remove()
	end

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	-- main menu panel
	self.mainPanel = self:Add("ixCharMenuMain")

	-- new character panel
	self.newCharacterPanel = self:Add("ixCharMenuNew")
	self.newCharacterPanel:SlideDown(0)

	-- load character panel
	self.loadCharacterPanel = self:Add("ixCharMenuLoad")
	self.loadCharacterPanel:SlideDown(0)

    -- load changelogs panel
    self.changelogs = self:Add("ixCharMenuChangelogs")
    self.changelogs:SlideDown(0)

	-- notice bar
	self.notice = self:Add("ixNoticeBar")

	-- finalization
	self:MakePopup()
	self.currentAlpha = 255
	self.volume = 0

	ix.gui.characterMenu = self

	if (!IsValid(ix.gui.intro)) then
		self:PlayMusic()
	end

	hook.Run("OnCharacterMenuCreated", self)
end

function PANEL:PlayMusic()
	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		self.channel = channel

		self:CreateAnimation(audioFadeInTime, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

function PANEL:ShowNotice(type, text)
	self.notice:SetType(type)
	self.notice:SetText(text)
	self.notice:Show()
end

function PANEL:HideNotice()
	if (IsValid(self.notice) and !self.notice:GetHidden()) then
		self.notice:Slide("up", 0.5, true)
	end
end

function PANEL:OnCharacterDeleted(character)
	if (#ix.characters == 0) then
		self.mainPanel.loadButton:SetDisabled(true)
		self.mainPanel:Undim() -- undim since the load panel will slide down
	else
		self.mainPanel.loadButton:SetDisabled(false)
	end

	self.loadCharacterPanel:OnCharacterDeleted(character)
end

function PANEL:OnCharacterLoadFailed(error)
	self.loadCharacterPanel:SetMouseInputEnabled(true)
	self.loadCharacterPanel:SlideUp()
	self:ShowNotice(3, error)
end

function PANEL:IsClosing()
	return self.bClosing
end

function PANEL:Close(bFromMenu)
	self.bClosing = true
	self.bFromMenu = bFromMenu

	local fadeOutTime = animationTime * 8

	self:CreateAnimation(fadeOutTime, {
		index = 1,
		target = {currentAlpha = 0},

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})

	self:CreateAnimation(fadeOutTime - 0.1, {
		index = 10,
		target = {volume = 0},

		Think = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:SetVolume(self.volume * 0.5)
			end
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:Stop()
				panel.channel = nil
			end
		end
	})

	-- hide children if we're already dimmed
	if (bFromMenu) then
		for _, v in pairs(self:GetChildren()) do
			if (IsValid(v)) then
				v:SetVisible(false)
			end
		end
	else
		-- fade out the main panel quicker because it significantly blocks the screen
		self.mainPanel.currentAlpha = 255

		self.mainPanel:CreateAnimation(animationTime * 2, {
			target = {currentAlpha = 0},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.currentAlpha)
			end,

			OnComplete = function(animation, panel)
				panel:SetVisible(false)
			end
		})
	end

	-- relinquish mouse control
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gui.EnableScreenClicker(false)
end

function PANEL:Paint(width, height)
	surface.SetTexture(gradient)
	surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 50))
	surface.DrawTexturedRect(0, 0, width / 2, height)

	if (!ix.option.Get("cheapBlur", false)) then
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawTexturedRect(0, 0, width, height)
		ix.util.DrawBlur(self, Lerp((self.currentAlpha - 200) / 255, 0, 10))
	end
end

function PANEL:PaintOver(width, height)
	if (self.bClosing and self.bFromMenu) then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:OnRemove()
	if (self.channel) then
		self.channel:Stop()
		self.channel = nil
	end
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
	ix.gui.characterMenu:Remove()

	--TODO: REMOVE ME
	ix.gui.characterMenu = vgui.Create("ixCharMenu")
end
