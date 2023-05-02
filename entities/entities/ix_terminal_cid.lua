AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "CID Terminal"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    util.AddNetworkString("ixTerminalCIDUsed")
    util.AddNetworkString("ixTerminalCIDNotUsed")

    function ENT:Initialize()
        self:SetModel("models/hla_combine_props/combine_breenconsole.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end

        self.id = Schema:ZeroNumber(math.random(1,9999), 4)
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_terminal_cid")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveTerminals()
        return entity
    end

    function ENT:OnRemove()
        if not ( ix.shuttingDown ) then
            Schema:SaveTerminals()
        end
    end

    function ENT:Use(ply, caller)
        if ( IsValid(ply) and ply:IsPlayer() ) then
            if ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() or ply:Team() == FACTION_EVENT ) then
                self:EmitSound("ambient/machines/combine_terminal_idle2.wav", 70, 90)
                ply:Lock()
                ply:SetAction("logging in...", 1, function()
                    self:EmitSound("buttons/button14.wav", 70, 50)
                    ply:OpenVGUI("ixTerminalCIDMenu")
                    ply:UnLock()
                end)
            else
                ply:Notify("You do not have access to this terminal!")
            end
        end
    end

    util.AddNetworkString("ixTerminalCIDNew")
    net.Receive("ixTerminalCIDNew", function(len, ply)
        if ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() or ply:Team() == FACTION_EVENT ) then
            local data = net.ReadTable()
            local char = ply:GetCharacter()
            local inv = char:GetInventory()

            local data2 = {
                ["name"] = data[1],
                ["id"] = Schema:ZeroNumber(math.random(1, 99999), 5),
                ["issueDate"] = os.date("%H:%M:%S - %d/%m/%Y", os.time()),
                ["officer"] = ply:Nick()
            }

            inv:Add("id", 1, data2)
            ply:EmitSound("buttons/button14.wav", 70, 25)
            ply:ForceSequence("harassfront1")
            ix.log.AddRaw(ply:Nick().." has created a new Identification Card with the name "..data[1], false)
        end
    end)
else
    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(container)
        local name = container:AddRow("name")
        name:SetImportant()
        name:SetText("CID Terminal")
        name:SizeToContents()
    end

    local PANEL = {}

    function PANEL:Init()
        ix.gui.cidTerminal = self

        self:SetTitle("")
        self:SetSize(ScrW() / 4, ScrH() / 7)
        self:Center()
        self:MakePopup()
        self:SetBackgroundBlur(true)

        self.toptext = self:Add("DLabel")
        self.toptext:SetContentAlignment(5)
        self.toptext:Dock(TOP)
        self.toptext:SetText("Automatic Registration Center")
        self.toptext:SetExpensiveShadow(2)
        self.toptext:SetFont("ixSmallFont")
        self.toptext:SetTall(32)

        self.nametext = self:Add("DLabel")
        self.nametext:SetContentAlignment(5)
        self.nametext:Dock(TOP)
        self.nametext:SetText("Input Name")
        self.nametext:SetExpensiveShadow(2)
        self.nametext:SetFont("ixSmallFont")

        self.nameinput = self:Add("DTextEntry")
        self.nameinput:Dock(TOP)

        self.itemswang = self:Add("DComboBox")
        self.itemswang:Dock(BOTTOM)
        self.itemswang:SetValue("Or select a relocation coupon.")

        self.itemswang.OnSelect = function()
            self.nameinput:SetDisabled(true)
            self.nameinput:SetText("")
        end

        self.submitbutton = self:Add("DButton")
        self.submitbutton:Dock(BOTTOM)
        self.submitbutton:SetText("Submit")

        for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
            if ( v.uniqueID == "coupon" ) then
                self.itemswang:AddChoice(v:GetData("name", "no name?????"))
            end
        end

        function self.submitbutton:DoClick()
            if ( string.len(ix.gui.cidTerminal.nameinput:GetText()) == 0 ) and not ( ix.gui.cidTerminal.itemswang:GetSelected() ) then
                return
            end

            if ( string.len(ix.gui.cidTerminal.nameinput:GetText()) > 1 ) then
                net.Start("ixTerminalCIDNew")
                    net.WriteTable({ix.gui.cidTerminal.nameinput:GetText()})
                net.SendToServer()

                ix.gui.cidTerminal:Close()
            elseif ix.gui.cidTerminal.itemswang:GetSelected() ~= "Or select a relocation coupon." then
                net.Start("ixTerminalCIDNew")
                    net.WriteTable({ix.gui.cidTerminal.itemswang:GetSelected()})
                net.SendToServer()

                ix.gui.cidTerminal:Close()
            else
                LocalPlayer():Notify("You need to input a name or select a relocation coupon!")
            end
        end
    end

    vgui.Register("ixTerminalCIDMenu", PANEL, "DFrame")
end