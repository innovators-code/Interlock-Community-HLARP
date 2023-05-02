
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()

	self:SetSize(parent:GetWide() * 0.4, parent:GetTall())
	self:Dock(RIGHT)
	self:DockMargin(0, ScrH() * 0.05, 0, 0)

	self.VBar:SetWide(0)

	-- entry setup
	local suppress = {}
	hook.Run("CanCreateCharacterInfo", suppress)

	if (!suppress.time) then
		local format = ix.option.Get("24hourTime", false) and "%A, %B %d, %Y. %H:%M" or "%A, %B %d, %Y. %I:%M %p"

		self.time = self:Add("DLabel")
		self.time:SetFont("ixMediumFont")
		self.time:SetTall(28)
		self.time:SetContentAlignment(5)
		self.time:Dock(TOP)
		self.time:SetTextColor(color_white)
		self.time:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.time:DockMargin(0, 0, 0, 32)
		self.time:SetText(ix.date.GetFormatted(format))
		self.time.Think = function(this)
			if ((this.nextTime or 0) < CurTime()) then
				this:SetText(ix.date.GetFormatted(format))
				this.nextTime = CurTime() + 0.5
			end
		end
	end

	if (!suppress.name) then
		self.name = self:Add("ixLabel")
		self.name:Dock(TOP)
		self.name:DockMargin(0, 0, 0, 8)
		self.name:SetFont("ixMenuButtonHugeFont")
		self.name:SetContentAlignment(5)
		self.name:SetTextColor(color_white)
		self.name:SetPadding(8)
		self.name:SetScaleWidth(true)
	end

	if (!suppress.description) then
		self.description = self:Add("DLabel")
		self.description:Dock(TOP)
		self.description:DockMargin(0, 0, 0, 8)
		self.description:SetFont("ixMenuButtonFont")
		self.description:SetTextColor(color_white)
		self.description:SetContentAlignment(5)
		self.description:SetMouseInputEnabled(true)
		self.description:SetCursor("hand")

		self.description.Paint = function(this, width, height)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, width, height)
		end

		self.description.OnMousePressed = function(this, code)
			if (code == MOUSE_LEFT) then
				ix.command.Send("CharDesc")

				if (IsValid(ix.gui.menu)) then
					ix.gui.menu:Remove()
				end
			end
		end

		self.description.SizeToContents = function(this)
			if (this.bWrap) then
				-- sizing contents after initial wrapping does weird things so we'll just ignore (lol)
				return
			end

			local width, height = this:GetContentSize()

			if (width > self:GetWide()) then
				this:SetWide(self:GetWide())
				this:SetTextInset(16, 8)
				this:SetWrap(true)
				this:SizeToContentsY()
				this:SetTall(this:GetTall() + 16) -- eh

				-- wrapping doesn't like middle alignment so we'll do top-center
				self.description:SetContentAlignment(8)
				this.bWrap = true
			else
				this:SetSize(width + 16, height + 16)
			end
		end
	end

	if (!suppress.characterInfo) then
		self.characterInfo = self:Add("Panel")
		self.characterInfo.list = {}
		self.characterInfo:Dock(TOP) -- no dock margin because this is handled by ixListRow
		self.characterInfo.SizeToContents = function(this)
			local height = 0

			for _, v in ipairs(this:GetChildren()) do
				if (IsValid(v) and v:IsVisible()) then
					local _, top, _, bottom = v:GetDockMargin()
					height = height + v:GetTall() + top + bottom
				end
			end

			this:SetTall(height)
		end

		hook.Run("CreateCharacterInfo", self.characterInfo)
		self.characterInfo:SizeToContents()
	end

	-- no need to update since we aren't showing the attributes panel
	if (!suppress.attributes) then
		local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (character) then
			self.attributes = self:Add("ixCategoryPanel")
			self.attributes:SetText(L("attributes"))
			self.attributes:Dock(TOP)
			self.attributes:DockMargin(0, 0, 0, 8)

			local boost = character:GetBoosts()
			local bFirst = true

			for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
				local attributeBoost = 0

				if (boost[k]) then
					for _, bValue in pairs(boost[k]) do
						attributeBoost = attributeBoost + bValue
					end
				end

				local bar = self.attributes:Add("ixAttributeBar")
				bar:Dock(TOP)

				if (!bFirst) then
					bar:DockMargin(0, 3, 0, 0)
				else
					bFirst = false
				end

				local value = character:GetAttribute(k, 0)

				if (attributeBoost) then
					bar:SetValue(value - attributeBoost or 0)
				else
					bar:SetValue(value)
				end

				local maximum = v.maxValue or ix.config.Get("maxAttributes", 100)
				bar:SetMax(maximum)
				bar:SetReadOnly()
				bar:SetText(Format("%s [%.1f/%.1f] (%.1f%%)", L(v.name), value, maximum, value / maximum * 100))

				if (attributeBoost) then
					bar:SetBoost(attributeBoost)
				end
			end

			self.attributes:SizeToContents()
		end
	end

	
	local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	local left = vgui.Create("DPanel", parent)
	left:SetSize(parent:GetWide() * 0.6, parent:GetTall())
	left:Dock(LEFT)
	left:DockMargin(0, ScrH() * 0.05, 0, 0)
	left.Paint = function(this, w, h)
		if ( character ) then
			draw.DrawText("ARMOR", "InterlockFont30", w / 2 - 400, 100, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(LocalPlayer():Armor(), "InterlockFont80", w / 2 - 400, 130, Color(0, 100, 200), TEXT_ALIGN_LEFT)
			draw.DrawText("HEALTH", "InterlockFont30", w / 2 + 400, 100, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText(LocalPlayer():Health(), "InterlockFont80", w / 2 + 400, 130, Color(0, 200, 150), TEXT_ALIGN_RIGHT)

			draw.DrawText("HUNGER", "InterlockFont20", w / 2 - 400, 30, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(character:GetHunger(), "InterlockFont20-Light", w / 2 - 400, 50, color_white, TEXT_ALIGN_LEFT)

			draw.DrawText(string.upper(ix.currency.plural), "InterlockFont20", w / 2 + 400, 30, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText(character:GetMoney()..ix.currency.symbol, "InterlockFont20-Light", w / 2 + 400, 50, color_white, TEXT_ALIGN_RIGHT)

			draw.DrawText(string.upper("age"), "InterlockFont30", w / 2 - 400, 250, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(character:GetAge(), "InterlockFont25-Light", w / 2 - 400, 280, color_white, TEXT_ALIGN_LEFT)
		end
	end

	local ply = LocalPlayer()
	-- ixModelPanel
	if not ( IsValid(self.model) ) then
		self.model = left:Add("ixModelPanel")
		self.model:SetModel(ply:GetModel(), ply:GetSkin(), ply:GetBodyGroups())
		self.model:Dock(FILL)
		self.model:DockMargin(10, 10, 10, 10)
		self.model:SetFOV(80)
		self.model.OnMouseReleased = function(this, key)
			if (key == MOUSE_RIGHT) then
				self:OnSubpanelRightClick()
			end
		end

		timer.Simple(0, function()
            if not ( IsValid(self.model) ) then
                return
            end

            local ent = self.model.Entity

            if not ( ent:GetModel() == ply:GetModel() ) then
                self.model:SetModel(ply:GetModel())
            end

            if ( IsValid(ent) ) then
                for k, v in pairs(ply:GetBodyGroups()) do
                    ent:SetBodygroup(v.id, ply:GetBodygroup(v.id))
                end
            end
        end)
	else
		timer.Simple(0, function()
            if not ( IsValid(self.model) ) then
                return
            end

            local ent = self.model.Entity

            if not ( ent:GetModel() == ply:GetModel() ) then
                self.model:SetModel(ply:GetModel())
            end

            self.model:Dock(FILL)
			self.model:DockMargin(10, 10, 10, 10)
			self.model:SetFOV(80)

            if ( IsValid(ent) ) then
                for k, v in pairs(ply:GetBodyGroups()) do
                    ent:SetBodygroup(v.id, ply:GetBodygroup(v.id))
                    ent:SetSkin(ply:GetSkin())
                end
            end
        end)
	end

	hook.Run("CreateCharacterInfoCategory", self, left)
end

function PANEL:Update(character)
	if (!character) then
		return
	end

	local faction = ix.faction.indices[character:GetFaction()]
	local class = ix.class.list[character:GetClass()]

	if (self.name) then
		self.name:SetText(character:GetName())

		if (faction) then
			self.name.backgroundColor = ColorAlpha(faction.color, 150) or Color(0, 0, 0, 150)
		end

		self.name:SizeToContents()
	end

	if (self.description) then
		self.description:SetText(character:GetDescription())
		self.description:SizeToContents()
	end

	if (self.class) then
		-- don't show class label if the class is the same name as the faction
		if (class and class.name != faction.name) then
			self.class:SetLabelText(L("class"))
			self.class:SetText(L(class.name))
			self.class:SizeToContents()
		else
			self.class:SetVisible(false)
		end
	end

	if (self.model) then
		self.model:SetModel(character:GetModel())
		timer.Simple(0, function()
			if (IsValid(self.model)) then
                for k, v in pairs(character:GetPlayer():GetBodyGroups()) do
                    self.model.Entity:SetBodygroup(v.id, character:GetPlayer():GetBodygroup(v.id))
                    self.model.Entity:SetSkin(character:GetPlayer():GetSkin())
                end
			end
		end)
	end

	hook.Run("UpdateCharacterInfo", self.characterInfo, character)

	self.characterInfo:SizeToContents()

	hook.Run("UpdateCharacterInfoCategory", self, character)
end

function PANEL:OnSubpanelRightClick()
	properties.OpenEntityMenu(LocalPlayer())
end

vgui.Register("ixCharacterInfo", PANEL, "DScrollPanel")

hook.Add("CreateMenuButtons", "ixCharInfo", function(tabs)
	tabs["you"] = {
		buttonColor = team.GetColor(LocalPlayer():Team()),
		Create = function(info, container)
			container.infoPanel = container:Add("ixCharacterInfo")
		end,
		OnSelected = function(info, container)
			container.infoPanel:Update(LocalPlayer():GetCharacter())
		end
	}
end)
