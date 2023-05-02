--[[---------------------------------------------------------------------------
    Clientside Hooks
---------------------------------------------------------------------------]]--

function Schema:PopulateHelpMenu(tabs)
    tabs["uu guide"] = function(container)
        local uuguide = container:Add("DHTML")
        uuguide:SetTall(ScrH())
        uuguide:Dock(FILL)
        uuguide:OpenURL("https://docs.google.com/document/d/1od3HK2u0x0Xx4rd9ycCEbY9DhcCP0-5es9DbteXt54w/edit")
    end
    tabs["voices"] = function(container)
        local classes = {}

        for k, v in pairs(Schema.voices.classes) do
            if ( v.condition(LocalPlayer()) ) then
                classes[#classes + 1] = k
            end
        end

        if ( #classes < 1 ) then
            local info = container:Add("DLabel")
            info:SetFont("ixSmallFont")
            info:SetText("You do not have access to any voice lines!")
            info:SetContentAlignment(5)
            info:SetTextColor(color_white)
            info:SetExpensiveShadow(1, color_black)
            info:Dock(TOP)
            info:DockMargin(0, 0, 0, 8)
            info:SizeToContents()
            info:SetTall(info:GetTall() + 16)

            info.Paint = function(_, width, height)
                surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", info), 160))
                surface.DrawRect(0, 0, width, height)
            end

            return
        end

        table.sort(classes, function(a, b)
            return a < b
        end)

        local searchEntry = container:Add("ixIconTextEntry")
        searchEntry:Dock(TOP)
        searchEntry:SetEnterAllowed(false)

        local function ListVoices(filter)
            for _, class in ipairs(classes) do
                local category = container:Add("Panel")
                category:Dock(TOP)
                category:DockMargin(0, 0, 0, 8)
                category:DockPadding(8, 8, 8, 8)
                category.Paint = function(_, width, height)
                    surface.SetDrawColor(Color(0, 0, 0, 66))
                    surface.DrawRect(0, 0, width, height)
                end
                category.removeOnFilter = true

                local categoryLabel = category:Add("DLabel")
                categoryLabel:SetFont("ixMediumLightFont")
                categoryLabel:SetText(class:upper())
                categoryLabel:Dock(FILL)
                categoryLabel:SetTextColor(color_white)
                categoryLabel:SetExpensiveShadow(1, color_black)
                categoryLabel:SizeToContents()
                categoryLabel.removeOnFilter = true
                category:SizeToChildren(true, true)

                if ( self.voices and self.voices.stored and self.voices.stored[class] ) then
                    for command, info in SortedPairs(self.voices.stored[class]) do
                        if filter == nil or (command:lower():find(filter:lower()) or info.text:lower():find(filter:lower())) then
                            local title = container:Add("ixMenuButton")
                            title:SetFont("InterlockFont16")
                            title:SetText(command:upper())
                            title:Dock(TOP)
                            title:SetTextColor(ix.config.Get("color"))
                            title:SetSize(container:GetWide(), 18)
                            title.DoClick = function()
                                ix.util.Notify("You have copied: "..tostring(command:upper()))
                                SetClipboardText(tostring(command:upper()))
                            end
                            title.removeOnFilter = true

                            local description = container:Add("DLabel")
                            description:SetFont("ixSmallFont")
                            description:SetText(info.text)
                            description:Dock(TOP)
                            description:SetTextColor(color_white)
                            description:SetExpensiveShadow(1, color_black)
                            description:SetWrap(true)
                            description:SetAutoStretchVertical(true)
                            description:SizeToContents()
                            description:DockMargin(0, 0, 0, 8)
                            description.removeOnFilter = true
                        end
                    end
                end
            end
        end

        searchEntry.OnChange = function(entry)
            local function deepRemove(panel)
                for k, v in pairs(panel:GetChildren()) do
                    if v.removeOnFilter == true then
                        v:Remove()
                    else
                        if v:HasChildren() then deepRemove(v) end
                    end
                end
            end

            deepRemove(container)
            ListVoices(searchEntry:GetValue())
        end

        ListVoices()
    end
end

local blacklistWeapons = {
    ["ix_stunstick"] = true,
    ["ix_crowbar"] = true,
    ["ix_axe"] = true,
    ["ix_axe_blunt"] = true,
    ["ix_pickaxe"] = true,
    ["ix_pickaxe_blunt"] = true,
    ["ix_leadpipe"] = true,
}
local smoothAlpha = 0
function Schema:HUDPaint()
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()
    
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if ( ix.util.hudDisabled or ix.ops.cinematicIntro or not ix.config.Get("hudEnabled", true) ) then return end
    if ( ply:GetLocalVar("interlock_showhud", false) ) then return end
    if not ( IsValid(ply) and ply:Alive() and char ) then return end

    if not ( ply:IsCombine() or ply:IsDispatch() ) then
        local stamina = ply:GetNetVar("attribute_stamina", 100)
        local sanity = ply:GetSanity()

        local staminaColor = Color(200, 180, 0)
        local sanityColor = Color(180, 0, 200)
    
        local staminaAlpha = 255
        local sanityAlpha = 255

        -- i really apologize for this
        if ( stamina >= 80 ) then
            staminaColor = Color(200, 180, 0)
            staminaAlpha = 255
        elseif ( stamina >= 60 and stamina <= 80 ) then
            staminaColor = Color(200, 180, 50)
            staminaAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.4
        elseif ( stamina >= 40 and stamina <= 60 ) then
            staminaColor = Color(200, 180, 100)
            staminaAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.6
        elseif ( stamina >= 20 and stamina <= 40 ) then
            staminaColor = Color(200, 180, 140)
            staminaAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.8
        elseif ( stamina >= 0 and stamina <= 20 ) then
            staminaColor = Color(200, 200, 200)
            staminaAlpha = (150 + math.sin(RealTime() * 5.2) * 100)
        end

        -- same as above but for sanity
        if ( sanity >= 80 ) then
            sanityColor = Color(180, 0, 200)
            sanityAlpha = 255
        elseif ( sanity >= 60 and sanity <= 80 ) then
            sanityColor = Color(180, 50, 200)
            sanityAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.4
        elseif ( sanity >= 40 and sanity <= 60 ) then
            sanityColor = Color(180, 100, 200)
            sanityAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.6
        elseif ( sanity >= 20 and sanity <= 40 ) then
            sanityColor = Color(180, 140, 200)
            sanityAlpha = (150 + math.sin(RealTime() * 5.2) * 100) * 0.8
        elseif ( sanity >= 0 and sanity <= 20 ) then
            sanityColor = Color(200, 200, 200)
            sanityAlpha = (150 + math.sin(RealTime() * 5.2) * 100)
        end
        
        ix.util.DrawIcon("interlock/icons/512/stamina.png", ColorAlpha(staminaColor, staminaAlpha), 5, 5, 25, 25)
        ix.util.DrawIcon("interlock/icons/512/health.png", ColorAlpha(sanityColor, sanityAlpha), 5, 35, 25, 25)
    end

    local weapon = ply:GetActiveWeapon()

    if not ( weapon.DrawAmmo != false ) then return end
    if not ( weapon and IsValid(weapon) ) then return end
    if ( blacklistWeapons[weapon:GetClass()] ) then return end

    local clip = weapon:Clip1() or 0
    local clipMax = weapon:GetMaxClip1()
    local count = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
    local secondary = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
    local font = "InterlockBigAmmoFont"
    local font2 = "InterlockAmmoFont"
    local color = color_white

    if ( weapon:Clip1() > 0 ) and ( ply:IsWepRaised() ) then
        smoothAlpha = Lerp(2 * FrameTime(), smoothAlpha, 255)
    else
        smoothAlpha = Lerp(8 * FrameTime(), smoothAlpha, 0)
    end

    if ( ply:IsCombine() ) then
        font = "CombineFontBlur40"
        font2 = "CombineFontBlur30"
        color = Color(200, 200, 200)
        text = "DAGGERS"
        if ( ply:Team() == FACTION_CP ) then
            text = "VERDICTS"
        end
    end

    if ( secondary > 0 ) then
        if ( count > 0 ) then
            draw.SimpleText(weapon:Clip1(), font, ScrW() - 100, ScrH() - 40, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText(count.." | "..secondary, font2, ScrW() - 90, ScrH() - 40, ColorAlpha(color, smoothAlpha - 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(weapon:Clip1(), font, ScrW() - 90, ScrH() - 40, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText(secondary, font2, ScrW() - 80, ScrH() - 40, ColorAlpha(color, smoothAlpha - 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if ( ply:IsCombine() ) then
            draw.DrawText(language.GetPhrase(weapon:GetPrintName()):upper(), "CombineFontBlur50", ScrW() - 20, ScrH() - 150, ColorAlpha(team.GetColor(ply:Team()), smoothAlpha), TEXT_ALIGN_RIGHT)
            draw.DrawText(text, "CombineFontBlur50", ScrW() - 20, ScrH() - 110, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT)
        end
    elseif not ( secondary > 0 ) then
        if ( count > 0 ) then
            draw.SimpleText(weapon:Clip1(), font, ScrW() - 90, ScrH() - 40, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            draw.SimpleText(count, font2, ScrW() - 80, ScrH() - 40, ColorAlpha(color, smoothAlpha - 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(weapon:Clip1(), font, ScrW() - 20, ScrH() - 40, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        if ( ply:IsCombine() ) then
            draw.DrawText(language.GetPhrase(weapon:GetPrintName()):upper(), "CombineFontBlur50", ScrW() - 20, ScrH() - 150, ColorAlpha(team.GetColor(ply:Team()), smoothAlpha), TEXT_ALIGN_RIGHT)
            draw.DrawText(text, "CombineFontBlur50", ScrW() - 20, ScrH() - 110, ColorAlpha(color, smoothAlpha), TEXT_ALIGN_RIGHT)
        end
    end
end

function Schema:CreateCharacterInfo(panel)
    if ( LocalPlayer():IsCitizen() or LocalPlayer():IsLoyalist() ) then
        panel.cid = panel:Add("ixListRow")
        panel.cid:SetList(panel.list)
        panel.cid:Dock(TOP)
        panel.cid:DockMargin(0, 0, 0, 8)
    end
end

function Schema:UpdateCharacterInfo(panel)
    if ( LocalPlayer():IsCitizen() or LocalPlayer():IsLoyalist() ) then
        panel.cid:SetLabelText("ID")
        panel.cid:SetText(string.format("##%s", LocalPlayer():GetCharacter():GetData("cid") or "UNKNOWN"))
        panel.cid:SizeToContents()
    end
end

local darkColorLerp = 1
function Schema:RenderScreenspaceEffects()
    local ply, char = LocalPlayer(), LocalPlayer():GetCharacter()
    
    if ( IsValid(ix.gui.characterMenu) and not ix.gui.characterMenu:IsClosing() ) then return end
    if ( ply.ixRagdoll or ply.ixIntroState ) then return end

    local colorModify = {}
    colorModify["$pp_colour_brightness"] = 0
    colorModify["$pp_colour_contrast"] = 1

    if ( LocalPlayer():Health() <= 25 ) then
        darkColorLerp = Lerp(0.01, darkColorLerp, 0)
    elseif ( LocalPlayer():Health() <= 50 ) then
        darkColorLerp = Lerp(0.01, darkColorLerp, 0.33)
    elseif ( LocalPlayer():Health() <= 75 ) then
        darkColorLerp = Lerp(0.01, darkColorLerp, 0.66)
    else
        darkColorLerp = Lerp(0.01, darkColorLerp, 1)
    end

    colorModify["$pp_colour_colour"] = darkColorLerp

    DrawColorModify(colorModify)
end

function Schema:GetArmorText(ply)
    if ( ply:Team() == FACTION_BIRD ) then return end
    
    if ( ply:Armor() >= 100 ) then
        return "Wearing Premium Quality Armour", Color(0, 0, 255)
    elseif ( ply:Armor() >= 75 ) then
        return "Wearing High Quality Armour", Color(50, 50, 255)
    elseif ( ply:Armor() >= 50 ) then
        return "Wearing Medium Quality Armour", Color(100, 100, 255)
    elseif ( ply:Armor() >= 25 ) then
        return "Wearing Low Quality Armour", Color(150, 150, 255)
    elseif ( ply:Armor() >= 10 ) then
        return "Wearing Cheap Quality Armour", Color(200, 200, 255)
    else
        return nil
    end
end

function Schema:GetInjuredText(ply)
    if ( ply:Team() == FACTION_BIRD ) then return end

    if ( ply:Health() >= 100 ) then
        return nil
    elseif ( ply:Health() >= 99 ) then
        return "Healthy", Color(50, 200, 0)
    elseif ( ply:Health() >= 98 ) then
        return "Scarred", Color(75, 200, 0)
    elseif ( ply:Health() >= 95 ) then
        return "Slightly Grazed", Color(90, 200, 0)
    elseif ( ply:Health() >= 90 ) then
        return "Moderately Grazed", Color(100, 200, 0)
    elseif ( ply:Health() >= 85 ) then
        return "Badly Grazed", Color(110, 200, 0)
    elseif ( ply:Health() >= 80 ) then
        return "Slightly Injured", Color(120, 190, 0)
    elseif ( ply:Health() >= 70 ) then
        return "Moderately Injured", Color(150, 170, 0)
    elseif ( ply:Health() >= 65 ) then
        return "Badly Injured", Color(170, 150, 0)
    elseif ( ply:Health() >= 60 ) then
        return "Marginally Wounded", Color(170, 100, 0)
    elseif ( ply:Health() >= 50 ) then
        return "Moderately Wounded", Color(190, 90, 0)
    elseif ( ply:Health() >= 45 ) then
        return "Badly Wounded", Color(200, 70, 0)
    elseif ( ply:Health() >= 40 ) then
        return "Seriously Wounded", Color(200, 60, 0)
    elseif ( ply:Health() >= 35 ) then
        return "Fatally Wounded", Color(200, 50, 0)
    elseif ( ply:Health() >= 30 ) then
        return "Mortally Wounded", Color(200, 40, 0)
    elseif ( ply:Health() >= 20 ) then
        return "Bleeding Out", Color(200, 30, 0)
    elseif ( ply:Health() >= 15 ) then
        return "Seriously Bleeding Out", Color(200, 20, 0)
    elseif ( ply:Health() >= 10 ) then
        return "Cardiac Arrest", Color(200, 10, 0)
    elseif ( ply:Health() >= 5 ) then
        return "Visibly Dying", Color(200, 0, 0)
    elseif ( ply:Health() >= 1 ) then
        return "No Pulse Response", Color(255, 0, 0)
    elseif ( ply:Health() >= 0 ) then
        return "Dead", Color(0, 0, 0)
    else
        return "Dead", Color(0, 0, 0)
    end
end

local color_red = Color(255, 0, 0)
function Schema:PreDrawHalos()
    local panicUsers = {}

    for k, v in ipairs(ix.util.GetAllCombine()) do
        if ( IsValid(v) and v:Alive() and v:GetCharacter() and v:GetCharacter():GetData("ixPanic") ) then
            panicUsers[#panicUsers + 1] = v
        end
    end

    halo.Add(panicUsers, color_red, 2, 2, 1, true, true)
end

function Schema:PlayerStartVoice(ply)
    if ( IsValid(g_VoicePanelList) ) then
        g_VoicePanelList:Remove()
    end
end

function Schema:OnSpawnMenuOpen()
    if not ( LocalPlayer():GetCharacter():HasFlags("e") ) then
        return false
    end
end

function Schema:Think()
    for k, v in pairs(player.GetAll()) do
        v:StopSound("physics/concrete/rock_scrape_rough_loop1.wav")
    end
end

function Schema:OnContextMenuOpen()
    if not ( LocalPlayer():GetCharacter():HasFlags("e") ) then
        return false
    end
end

function Schema:ShouldDrawCrosshair()
    return false
end

function Schema:BuildBusinessMenu()
    return false
end

function Schema:ShouldHideBars()
    return true
end

function Schema:CanDrawAmmoHUD()
    return false
end

local noAccess = {
    ["#spawnmenu.category.saves"] = true,
    ["#spawnmenu.category.dupes"] = true,
    ["#spawnmenu.category.postprocess"] = true
}

local adminAccess = {
    ["#spawnmenu.category.entities"] = true,
    ["#spawnmenu.category.npcs"] = true
}

local superadminAccess = {
    ["#spawnmenu.category.vehicles"] = true,
    ["#spawnmenu.category.weapons"] = true,
    ["Admin Item Spawnmenu"] = true,
}

function Schema:PostReloadToolsMenu()
    local spawnMenu = g_SpawnMenu

    if ( spawnMenu ) then
        local tabs = spawnMenu.CreateMenu
        local closeMe = {}

        for k, v in pairs(tabs:GetItems()) do
            if ( noAccess[v.Name] ) then
                table.insert(closeMe, v.Tab)
            end

            if ( LocalPlayer() and LocalPlayer():IsAdmin() and LocalPlayer():IsDonator() ) then
                if ( adminAccess[v.Name] and not LocalPlayer():IsAdmin() ) then
                    table.insert(closeMe, v.Tab)
                end
            end

            if ( LocalPlayer() and LocalPlayer():IsSuperAdmin() ) then
                if ( superadminAccess[v.Name] and not LocalPlayer():IsSuperAdmin() ) then
                    table.insert(closeMe, v.Tab)
                end
            end
        end

        for k, v in pairs(closeMe) do
            tabs:CloseTab(v, true)
        end
    end
end

function Schema:OnReloaded()
    LocalPlayer():Notify("Server has been refreshed!")
    LocalPlayer():EmitSound("npc/roller/code2.wav", 0.5, 90)
end