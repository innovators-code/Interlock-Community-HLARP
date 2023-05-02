AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.PrintName = "Administration Stick"
SWEP.Author = "Riggs.mackay"
SWEP.Category = "IX:HLA RP"

SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Aim at a player and press the primary fire button to bring up a menu."
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.UseHands = true

SWEP.IsAlwaysRaised = true

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ViewModelFOV = 50

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.HoldType = "melee"

SWEP.Primary.Delay = 2
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Delay = 0.5
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
 
function SWEP:Reload()
    if ( ( self.reloadCooldown or 0 ) < CurTime() ) then
        self.Weapon:EmitSound("weapons/stunstick/spark"..math.random(1,3)..".wav", 30)
        self.reloadCooldown = CurTime() + 0.5
    end
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
    if ( ( self.primaryCooldown or 0 ) < CurTime() ) then
        if not ( IsValid(self:GetOwner()) and self:GetOwner():IsAdmin() ) then self:GetOwner():Notify("No Access!") return end

        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        self.Weapon:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1,2)..".wav", 30)

        local data = {}
            data.start = self:GetOwner():GetShootPos()
            data.endpos = data.start + self:GetOwner():GetAimVector() * 1024
            data.filter = self:GetOwner()
        local target = util.TraceLine(data).Entity

        if ( CLIENT ) then
            if ( IsValid(target) and target:IsPlayer() ) then
                local menu = DermaMenu() 
                menu:AddOption("Abort"):SetIcon("icon16/cancel.png")
                menu:AddSpacer()
                local function copyString(str)
                    local realString = tostring(str)
                    SetClipboardText(realString)
                    self:GetOwner():Notify("Copied "..realString.." to clipboard.")
                    self:GetOwner():ChatNotify(realString)
                end
                menu:AddOption("View Player", function()
                    self:GetOwner():NotifyLocalized(string.format("%s | %s\nHealth: %s\nArmor: %s", target:Nick(), target:SteamID(), target:Health(), target:Armor()))
                end):SetIcon("icon16/page.png")
                menu:AddOption("Copy Roleplay Name", function() copyString(target:Nick()) end):SetIcon("icon16/page_edit.png")
                menu:AddOption("Copy Steam Name", function() copyString(target:SteamName()) end):SetIcon("icon16/page_edit.png")
                menu:AddOption("Copy SteamID", function() copyString(target:SteamID()) end):SetIcon("icon16/page_gear.png")
                menu:AddOption("Copy SteamID64", function() copyString(target:SteamID64()) end):SetIcon("icon16/page_gear.png")
                menu:AddOption("Copy Model", function() copyString(target:GetModel()) end):SetIcon("icon16/page_save.png")
                menu:AddOption("Copy Skin", function() copyString(target:GetSkin()) end):SetIcon("icon16/page_save.png")
                menu:Open(ScrW() / 2 - 200, ScrH() / 2)

                timer.Simple(0, function()
                    gui.SetMousePos(ScrW() / 2 - 150, ScrH() / 2)
                end)
            else
                self:GetOwner():Notify("You must target a player.")
            end
        end

        self.primaryCooldown = CurTime() + self.Primary.Delay
    end
end

if ( SERVER ) then
    util.AddNetworkString("ixAdminStick.SetName")
    net.Receive("ixAdminStick.SetName", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local name = net.ReadString()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( name == "" ) then
            ply:Notify("You must enter a name!")
            return
        end

        target:GetCharacter():SetName(name)
    end)

    util.AddNetworkString("ixAdminStick.SetDescription")
    net.Receive("ixAdminStick.SetDescription", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local description = net.ReadString()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( description == "" ) then
            ply:Notify("You must enter a name!")
            return
        end

        target:GetCharacter():SetDescription(description)
    end)

    util.AddNetworkString("ixAdminStick.SetModelInput")
    net.Receive("ixAdminStick.SetModelInput", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local model = net.ReadString()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( model == "" ) then
            ply:Notify("You must enter a model path!")
            return
        end

        target:GetCharacter():SetModel(model)
    end)

    util.AddNetworkString("ixAdminStick.SetModel")
    net.Receive("ixAdminStick.SetModel", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local model = net.ReadString()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( model == "" ) then
            ply:Notify("You must enter a model!")
            return
        end

        target:GetCharacter():SetModel(model)
    end)

    util.AddNetworkString("ixAdminStick.SetSkin")
    net.Receive("ixAdminStick.SetSkin", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:SetSkin(amount)
    end)

    util.AddNetworkString("ixAdminStick.SetFaction")
    net.Receive("ixAdminStick.SetFaction", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local faction = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( faction == nil ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:GetCharacter():SetFaction(faction)
    end)

    util.AddNetworkString("ixAdminStick.SetMaxHealth")
    net.Receive("ixAdminStick.SetMaxHealth", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:SetMaxHealth(amount)
    end)

    util.AddNetworkString("ixAdminStick.SetMaxArmor")
    net.Receive("ixAdminStick.SetMaxArmor", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:SetMaxArmor(amount)
    end)

    util.AddNetworkString("ixAdminStick.SetHealth")
    net.Receive("ixAdminStick.SetHealth", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:SetHealth(amount)
    end)

    util.AddNetworkString("ixAdminStick.SetArmor")
    net.Receive("ixAdminStick.SetArmor", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:SetArmor(amount)
    end)

    util.AddNetworkString("ixAdminStick.SetHunger")
    net.Receive("ixAdminStick.SetHunger", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local amount = tonumber(net.ReadString())

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( amount == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:GetCharacter():SetHunger(amount)
    end)

    util.AddNetworkString("ixAdminStick.ForceRecognizeSelf")
    net.Receive("ixAdminStick.ForceRecognizeSelf", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        target:GetCharacter():Recognize(ply:GetCharacter():GetID())
    end)

    util.AddNetworkString("ixAdminStick.ForceRecognizeTarget")
    net.Receive("ixAdminStick.ForceRecognizeTarget", function(length, ply)
        if not ( IsValid(ply) and ply:IsAdmin() ) then ply:Notify("No Access!") return end

        local target = net.ReadEntity()
        local id = net.ReadString()

        if not ( IsValid(target) and target:IsPlayer() and target:GetCharacter() ) then
            ply:Notify("You must target a player!")
            return
        end

        if ( id == "" ) then
            ply:Notify("You must enter a value!")
            return
        end

        target:GetCharacter():Recognize(tonumber(id))
    end)
end

function SWEP:SecondaryAttack()
    if ( ( self.secondaryCooldown or 0 ) < CurTime() ) then
        if not ( IsValid(self:GetOwner()) and self:GetOwner():IsAdmin() ) then self:GetOwner():Notify("No Access!") return end

        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        self.Weapon:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1,2)..".wav", 70)

        local data = {}
            data.start = self:GetOwner():GetShootPos()
            data.endpos = data.start + self:GetOwner():GetAimVector() * 1024
            data.filter = self:GetOwner()
        local target = util.TraceLine(data).Entity

        if ( CLIENT ) then
            if ( IsValid(target) and target:IsPlayer() ) then
                local menu = DermaMenu() 
                menu:SetMinimumWidth(100)
                menu:AddOption("Abort"):SetIcon("icon16/cancel.png")
                menu:AddSpacer()
                menu:AddOption("Set Name", function()
                    Derma_StringRequest("Set Name", "Enter a new name for "..target:Nick(), target:Nick(), function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetName")
                                net.WriteEntity(target)
                                net.WriteString(text)
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                menu:AddOption("Set Description", function()
                    Derma_StringRequest("Set Description", "Enter a new description for "..target:Nick(), "", function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetDescription")
                                net.WriteEntity(target)
                                net.WriteString(text)
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                menu:AddOption("Set Model (Input)", function()
                    Derma_StringRequest("Set Model", "Enter a new model for "..target:Nick(), target:GetModel(), function(text)
                        if not ( text == "" ) then
                            net.Start("ixAdminStick.SetModelInput")
                                net.WriteEntity(target)
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
                for _, v in pairs(ix.faction.Get(FACTION_CITIZEN).models) do
                    table.insert(modelList, v)
                end
                for k, v in pairs(modelList) do
                    local modelicon = grid:Add("SpawnIcon")
                    modelicon:SetModel(v)
                    modelicon:SetSize(50, 50)
                    modelicon:SetTooltip(v)
                    modelicon.DoClick = function()
                        net.Start("ixAdminStick.SetModel")
                            net.WriteEntity(target)
                            net.WriteString(v)
                        net.SendToServer()
                    end

                    grid:AddItem(modelicon)
                end
                local subMenu, parentSubMenu = menu:AddSubMenu("Set Model (List)")
                parentSubMenu:SetIcon("icon16/user_edit.png")
                subMenu:SetMinimumWidth(315)
                subMenu:AddPanel(panel)
                menu:AddOption("Set Skin", function()
                    Derma_StringRequest("Set Skin", "Set the new Skin for "..target:Nick(), target:GetSkin(), function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetSkin")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/user_edit.png")
                local subMenu, parentSubMenu = menu:AddSubMenu("Set Faction")
                parentSubMenu:SetIcon("icon16/user_edit.png")
                for k, v in SortedPairs(ix.faction.teams) do
                    subMenu:AddOption(v.name, function()
                        net.Start("ixAdminStick.SetFaction")
                            net.WriteEntity(target)
                            net.WriteString(tostring(v.index))
                        net.SendToServer()
                    end):SetIcon("icon16/user_edit.png")
                end
                menu:AddOption("Edit bodygroups", function()
                    local panel = vgui.Create("ixBodygroupView")
                    panel:Display(target)
                end):SetIcon("icon16/user_edit.png")
                menu:AddSpacer()
                menu:AddOption("Force Recognize (Yourself)", function()
                    net.Start("ixAdminStick.ForceRecognizeSelf")
                        net.WriteEntity(target)
                    net.SendToServer()
                end):SetIcon("icon16/user_comment.png")
                local subMenu, parentSubMenu = menu:AddSubMenu("Force Recognize")
                parentSubMenu:SetIcon("icon16/user_comment.png")
                for k, v in SortedPairs(player.GetAll()) do
                    if ( v:GetCharacter() and v:GetCharacter():GetID() ) then
                        subMenu:AddOption(v:Nick(), function()
                            net.Start("ixAdminStick.ForceRecognizeTarget")
                                net.WriteEntity(target)
                                net.WriteString(tostring(v:GetCharacter():GetID()))
                            net.SendToServer()
                        end):SetIcon("icon16/user.png")
                    end
                end
                menu:AddSpacer()
                menu:AddOption("Set Max Armor", function()
                    Derma_StringRequest("Set Max Armor", "Set the new Max Armor for "..target:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetMaxArmor")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/shield_add.png")
                menu:AddOption("Set Armor", function()
                    Derma_StringRequest("Set Armor", "Set the new Armor for "..target:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetArmor")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/shield.png")
                menu:AddSpacer()
                menu:AddOption("Set Max Health", function()
                    Derma_StringRequest("Set Max Health", "Set the new Max Health for "..target:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetMaxHealth")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/heart_add.png")
                menu:AddOption("Set Health", function()
                    Derma_StringRequest("Set Max Health", "Set the new Health for "..target:Nick(), "", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetHealth")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/heart.png")
                menu:AddSpacer()
                menu:AddOption("Set Hunger", function()
                    Derma_StringRequest("Set Hunger", "Set the new Hunger for "..target:Nick(), "100", function(amount)
                        if not ( amount == "" ) then
                            net.Start("ixAdminStick.SetHunger")
                                net.WriteEntity(target)
                                net.WriteString(tonumber(amount))
                            net.SendToServer()
                        end
                    end)
                end):SetIcon("icon16/cup.png")
                menu:Open(ScrW() / 2 - 200, ScrH() / 2)

                timer.Simple(0, function()
                    gui.SetMousePos(ScrW() / 2 - 150, ScrH() / 2)
                end)
            else
                self:GetOwner():Notify("You must target a player.")
            end
        end

        self.secondaryCooldown = CurTime() + self.Secondary.Delay
    end
end