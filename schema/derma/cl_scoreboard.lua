local PANEL = {}
local playerData = {}

function PANEL:Init()
    local ply = LocalPlayer()
    self:Dock(FILL)

    local players = player.GetAll()
    table.sort(players, function(k, v) return k:Team() > v:Team() end)

    for k, v in pairs(players) do
        if not ( v or IsValid(v) ) or hook.Run("ShouldShowPlayerOnScoreboard", v) == false then return end
        playerData[v] = {
            name = (ply:IsAdmin() and v:SteamName().." ("..v:Nick()..")") or v:SteamName(),
            team = team.GetName(v:Team()),
            ping = v:Ping(),
            steamname = v:SteamName(),
            teamColor = team.GetColor(v:Team()),
            steamid64 = v:SteamID64()
        }

        self.playerPanel = self:Add("ixMenuButton")
        self.playerPanel:Dock(TOP)
        self.playerPanel:SetText("")
        self.playerPanel:DockMargin(0, 0, 0, 0)
        self.playerPanel:SetTall(80)
        self.playerPanel.Paint = function(self, w, h)
            surface.SetDrawColor(ix.config.Get("color"))
            surface.DrawRect(0, 0, w, 5)
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawRect(0, 0, w, 80)

            draw.DrawText(playerData[v].name, "InterlockFont40", 80, 5, color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(playerData[v].team, "InterlockFont30", 80, 50, playerData[v].teamColor, TEXT_ALIGN_LEFT)
            draw.DrawText(playerData[v].ping.."ms", "InterlockFont30", w - 10, 50, color_white, TEXT_ALIGN_RIGHT)
        end
        self.playerPanel.DoClick = function()
            gui.OpenURL("http://steamcommunity.com/profiles/"..playerData[v].steamid64)
        end
        self.playerPanel.DoRightClick = function()
            if not ( IsValid(v) ) then return end
            
            local function copyString(str)
                local realString = tostring(str)
                SetClipboardText(realString)
                LocalPlayer():Notify("Copied "..realString.." to clipboard.")
                LocalPlayer():ChatNotify(realString)
            end
        
            local menu = DermaMenu()
            menu:SetMinimumWidth(100)
            menu:AddOption("Abort"):SetIcon("icon16/cancel.png")
        
            menu:AddSpacer()
        
            menu:AddOption("Copy SteamID", function() copyString(v:SteamID()) end):SetIcon("icon16/page_gear.png")
            menu:AddOption("Copy SteamID64", function() copyString(v:SteamID64()) end):SetIcon("icon16/page_gear.png")
        
            if ( LocalPlayer():IsAdmin() ) then
                menu:AddSpacer()
        
                menu:AddOption("View Player", function()
                    LocalPlayer():NotifyLocalized(string.format("%s | %s\nHealth: %s\nArmor: %s", v:Nick(), v:SteamID(), v:Health(), v:Armor()))
                end):SetIcon("icon16/page.png")
                menu:AddOption("Copy Roleplay Name", function() copyString(v:Nick()) end):SetIcon("icon16/page_edit.png")
                menu:AddOption("Copy Steam Name", function() copyString(v:SteamName()) end):SetIcon("icon16/page_edit.png")
                menu:AddOption("Copy Model", function() copyString(v:GetModel()) end):SetIcon("icon16/page_save.png")
                menu:AddOption("Copy Skin", function() copyString(v:GetSkin()) end):SetIcon("icon16/page_save.png")
        
                menu:AddSpacer()
        
                menu:AddOption("Set Name", function()
                    Derma_StringRequest("Set Name", "Enter a new name for "..v:Nick(), v:Nick(), function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetName")
                                net.WriteEntity(v)
                                net.WriteString(text)
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
        
                menu:AddOption("Set Description", function()
                    Derma_StringRequest("Set Description", "Enter a new description for "..v:Nick(), "", function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetDescription")
                                net.WriteEntity(v)
                                net.WriteString(text)
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                menu:AddOption("Set Model (Input)", function()
                    Derma_StringRequest("Set Model", "Enter a new model for "..v:Nick(), v:GetModel(), function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetModelInput")
                                net.WriteEntity(v)
                                net.WriteString(text)
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                
                local panel = vgui.Create("DScrollPanel", menu)
                panel:SetSize(100, 200)
        
                local grid = vgui.Create("DGrid", panel)
                grid:SetPos(0, 0)
                grid:SetCols(6)
                grid:SetRowHeight(50)
                grid:SetColWide(50)
        
                local modelList = {
                    "models/player/group01/male_male_077.mdl",
                    "models/hla/police.mdl",
                    "models/hlvr/characters/hazmat_worker/npc/hazmat_worker_citizen.mdl",
                    "models/hlvr/characters/worker/npc/worker_citizen.mdl",
                    "models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl",
                    "models/cultist/hl_a/combine_heavy/npc/combine_heavy_trooper.mdl",
                    "models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl",
                    "models/cultist/hl_a/combine_commander/npc/combine_commander.mdl",
                    "models/hla/combine/combine_hla_soldier.mdl",
                    "models/hla/combine/combine_soldier.mdl",
                    "models/hla/combine/combine_soldier_prisonguard.mdl",
                    "models/hla/combine/combine_super_soldier.mdl",
                }
                for _, v2 in pairs(ix.faction.Get(FACTION_CITIZEN).models) do
                    table.insert(modelList, v2)
                end
                for k, v2 in pairs(modelList) do
                    local modelicon = grid:Add("SpawnIcon")
                    modelicon:SetModel(v2)
                    modelicon:SetSize(50, 50)
                    modelicon:SetTooltip(v2)
                    modelicon.DoClick = function()
                        net.Start("ixAdminStick.SetModel")
                            net.WriteEntity(v)
                            net.WriteString(v2)
                        net.SendToServer()
                    end
        
                    grid:AddItem(modelicon)
                end
                local subMenu, parentSubMenu = menu:AddSubMenu("Set Model (List)")
                parentSubMenu:SetIcon("icon16/user_edit.png")
                subMenu:SetMinimumWidth(315)
                subMenu:AddPanel(panel)
                menu:AddOption("Set Skin", function()
                    Derma_StringRequest("Set Skin", "Set the new Skin for "..v:Nick(), v:GetSkin(), function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetSkin")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                local subMenu, parentSubMenu = menu:AddSubMenu("Set Faction")
                parentSubMenu:SetIcon("icon16/user_edit.png")
                for k2, v2 in SortedPairs(ix.faction.teams) do
                    subMenu:AddOption(v2.name, function()
                        net.Start("ixAdminStick.SetFaction")
                            net.WriteEntity(v)
                            net.WriteString(tostring(v2.index))
                        net.SendToServer()
                    end):SetIcon("icon16/user_edit.png")
                end
                menu:AddOption("Edit bodygroups", function()
                    local panel = vgui.Create("ixBodygroupView")
                    panel:Display(v)
                end):SetIcon("icon16/user_edit.png")
                menu:AddSpacer()
                menu:AddOption("Force Recognize (Yourself)", function()
                    net.Start("ixAdminStick.ForceRecognizeSelf")
                        net.WriteEntity(v)
                    net.SendToServer()
                end):SetIcon("icon16/user_comment.png")
                local subMenu, parentSubMenu = menu:AddSubMenu("Force Recognize")
                parentSubMenu:SetIcon("icon16/user_comment.png")
                for k2, v2 in SortedPairs(player.GetAll()) do
                    if ( v:GetCharacter() and v:GetCharacter():GetID() ) then
                        subMenu:AddOption(v:Nick(), function()
                            net.Start("ixAdminStick.ForceRecognizeTarget")
                                net.WriteEntity(v)
                                net.WriteString(tostring(v2:GetCharacter():GetID()))
                            net.SendToServer()
                        end):SetIcon("icon16/user.png")
                    end
                end
                menu:AddSpacer()
                menu:AddOption("Set Max Armor", function()
                    Derma_StringRequest("Set Max Armor", "Set the new Max Armor for "..v:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetMaxArmor")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/shield_add.png")
                menu:AddOption("Set Armor", function()
                    Derma_StringRequest("Set Armor", "Set the new Armor for "..v:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetArmor")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/shield.png")
                menu:AddSpacer()
                menu:AddOption("Set Max Health", function()
                    Derma_StringRequest("Set Max Health", "Set the new Max Health for "..v:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetMaxHealth")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/heart_add.png")
                menu:AddOption("Set Health", function()
                    Derma_StringRequest("Set Max Health", "Set the new Health for "..v:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetHealth")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/heart.png")
                menu:AddSpacer()
                menu:AddOption("Set Hunger", function()
                    Derma_StringRequest("Set Hunger", "Set the new Hunger for "..v:Nick(), "100", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetHunger")
                                net.WriteEntity(v)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/cup.png")
            end
            menu:Open(gui.MouseX(), gui.MouseY(), false)
        end

        local avt = self.playerPanel:Add("AvatarImage")
        avt:SetSize(65, 65)
        avt:SetPos(5, 10)
        avt:SetPlayer(v, 65)
    end
end

vgui.Register("ixScoreboard", PANEL, "DScrollPanel")