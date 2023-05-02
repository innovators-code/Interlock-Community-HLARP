AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Quest Giver"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/odessa.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:SpawnFunction(ply, tr, classname)
        local ent = ents.Create("ix_questgiver")
        ent:SetPos(tr.HitPos + tr.HitNormal * 16)
        ent:Spawn()

        return ent
    end

    function ENT:Use(ply)
        if ( ( ply.nextuse or 0 ) > CurTime() ) then return end
        
        ply:OpenVGUI("ixQuestGiver")
    end

else
    local PANEL = {}

    function PANEL:Init()
        self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
        self:SetPos(ScrW() * 0.25, ScrH() * 0.25)
        self:SetTitle("Quest Giver")
        self:SetVisible(true)
        self:SetDraggable(true)
        self:ShowCloseButton(true)
        self:MakePopup()
        self:SetBackgroundBlur(true)
        self:SetDrawOnTop(true)

        self.statusList = self:Add("DComboBox")
        self.statusList:Dock(TOP)
        self.statusList:DockMargin(0,8,0,8)
        self.statusList:SetTall(24)
        self.statusList:SetValue("Quests")
        self.statusList:SetTextColor(color_white)
        self.statusList:SetFont("ixSmallFont")
        self.statusList:SetSortItems(false)
        self.statusList:SetTooltip("Select a quest.")
        for k, v in pairs(ix.quests.GetQuests()) do
            self.statusList:AddChoice(v.name)

            self.statusList.OnSelect = function(panel, index, value)
                print(index.."\n"..value)
                Derma_Query("Are you sure you want to accept this quest?", "Accept Quest.", "Yes", function()
                    net.Start("ixQuestAccept")
                        net.WriteString(k)
                    net.SendToServer()
                end, "No")
            end
        end
    end

    vgui.Register("ixQuestGiver", PANEL, "DFrame")
end 