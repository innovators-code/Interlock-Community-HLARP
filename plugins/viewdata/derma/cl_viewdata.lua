--[[
    © 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

local PLUGIN = PLUGIN
local PANEL = {}

-- Called when the panel is first initialized.
function PANEL:Init()
    if(IsValid(ix.gui.menu)) then
        ix.gui.menu:Remove()
    end

    self:SetBackgroundBlur(true);
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self:SetAlpha(0)

    self.exitButton = self:Add("DButton")
    self.exitButton:SetText("Exit")
    self.exitButton:SetFont("ixSmallFont")
    self.exitButton:Dock(TOP)
    self.exitButton:DockMargin(16, -8, 16, 0)

    function self.exitButton:DoClick()
        ix.gui.record:SendToServer(VIEWDATA_UPDATEVAR, {
            var = "note",
            info = ix.gui.record.note.textEntry:GetText()
        })
        ix.gui.record:Remove()
    end
end

function PANEL:Paint() 
    surface.SetMaterial(ix.util.GetMaterial("materials/interlock/viewdata/background.png"))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(0, 0, 512, 512)

    surface.SetMaterial(ix.util.GetMaterial("materials/interlock/viewdata/combineoverlay.png"))
    surface.SetDrawColor(255, 255, 255, 150)
    surface.DrawTexturedRect(0, 0, 512, 512)
end

-- Called each frame of the panel being open.
function PANEL:Think()
    local scrW = ScrW()
    local scrH = ScrH()

    self:SetSize(512, 512)
    self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2))
end

function PANEL:AddStage(text, panelType)
    local panel = self:Add(panelType or "DPanel")
    panel:Dock(FILL)
    panel:DockMargin(16,0,16,16)
    panel:SetVisible(false)

    if(!self.stages) then
        self.stages = {}
    end

    self.stages[text] = panel

    return panel
end

function PANEL:SetStage(text)
    if(!self.stages[text]) then
        return
    end

    for k, v in pairs(self.stages) do
        if(k != text) then
            v:SetVisible(false)
        else
            v:SetVisible(true)
        end
    end
end

-- Called when the panel is receiving data and will start to build.
function PANEL:Build(target, cid, record, status)
    self.target = target
    self.character = self.target:GetCharacter()
    self.cidValue = cid
    self.recordTable = record
    self.cidstatus = status
    print(self.cidstatus)

    self.content = self:AddStage("Home")
    self.content:SetDrawBackground(false)
    self.content:Add(self:BuildLabel("Civil Protection Datapad", true))
    
    self:BuildCID()

    self.record = self:AddStage("Record", "ixCombineViewDataRecord")
    self.note = self:AddStage("Note", "ixCombineViewDataViewNote")
    self.unitrecord = self:AddStage("UnitRecord", "ixCombineViewDataUnitRecord")
    self.vars = self:AddStage("EditData", "ixCombineViewDataEditData")
    
    self.status:SetText("Status: " .. self.cidstatus)

    self:SetStage("Home")
    self:AlphaTo(255, 0.5)

    self:BuildButtons()
end

function PANEL:GetRecord()
    return self.recordTable or {
        rows = {},
        vars = {
            ["note"] = PLUGIN.defaultNote
        }
    }
end

function PANEL:BuildCID()
    self.cid = self.content:Add("DPanel")
    self.cid:Dock(TOP)
    self.cid:DockMargin(0,8,0,8)
    self.cid:SetTall(196)
    self.cid:SetDrawBackground(false)

    self.modelBackground = self.cid:Add(self:DrawCharacter())

    self.rightDock = self.cid:Add("DPanel")
    self.rightDock:Dock(FILL)
    self.rightDock:DockMargin(8,16,16,16)
    self.rightDock:SetDrawBackground(false)

    self.name = self.rightDock:Add(self:BuildLabel("Name: " .. self.character:GetName() or "ERROR", false, 4))
    self.cid = self.rightDock:Add(self:BuildLabel("Citizen ID: #ERROR", false, 4))
    self.points = self.rightDock:Add(self:BuildLabel("Total Points: " ..  "ERROR", false, 4))
    if ( self.character:IsCitizen() or self.character:IsLoyalist() ) then
        self.status = self.rightDock:Add(self:BuildLabel("Status: " .. self.cidstatus, false, 4))
    end

    self.statusList = self.rightDock:Add("DComboBox")
    self.statusList:Dock(TOP)
    self.statusList:DockMargin(0,8,0,8)
    self.statusList:SetTall(24)
    self.statusList:SetValue("Status")
    self.statusList:SetTextColor(color_white)
    self.statusList:SetFont("ixSmallFont")
    self.statusList:SetSortItems(false)
    self.statusList:SetTooltip("Select the status of the character.")
    for k, v in ipairs(PLUGIN.statuses) do
        self.statusList:AddChoice(v)
    end

    self.statusList.OnSelect = function(panel, index, value)
        print("Hilao")
        Derma_Query("Are you sure you want to change the status of this character?", "Change Status", "Yes", function()
            net.Start("ixViewDataStatus")
                net.WriteString(value)
                net.WriteEntity(self.target)
            net.SendToServer()
            self.status:SetText("Status: " .. value)
        end, "No") 
    end
end

function PANEL:BuildButtons()
    self.buttonLayout = self.content:Add("DIconLayout")
    self.buttonLayout:Dock(FILL)
    self.buttonLayout:DockMargin(0, 4, 0, 4)
    self.buttonLayout:SetSpaceX(4)
    self.buttonLayout:SetSpaceY(4)
    self.buttonLayout:SetStretchWidth(true)
    self.buttonLayout:SetStretchHeight(true)
    self.buttonLayout:InvalidateLayout(true)

    self.buttonLayout:Add(self:AddStageButton("View Record", "Record"))
    self.buttonLayout:Add(self:AddStageButton("View Note", "Note"))

    local unitRecord = self.buttonLayout:Add(self:AddStageButton("View Unit Record\n(Unavailable)", "UnitRecord"))
    local editData = self.buttonLayout:Add(self:AddStageButton("Edit Data\n(Unavailable)", "EditData"))

    unitRecord:SetEnabled(false)
    editData:SetEnabled(false)
end

function PANEL:SetLoyaltyPoints(record)
    local count = 0

    if(IsValid(record)) then
        for k, v in pairs(record:GetLines()) do
            count = count + (v:GetValue(3) or 0)
        end
    end

    self.points:SetText("Civic Deeds: " .. count)
    net.Start("ixViewDataPoints")
        net.WriteInt(count, 32)
        net.WriteEntity(self.target)
    net.SendToServer()
end

function PANEL:DrawCharacter(small)
    local modelBackground = vgui.Create("DPanel")
    modelBackground:Dock(LEFT)

    if(!small) then
        modelBackground:SetSize(180,180)
        modelBackground:DockMargin(16,16,16,16)
    end
    
    function modelBackground:Paint(w, h)
        surface.SetDrawColor(25, 25, 25, 225)
        surface.DrawRect(0, 0, w, h)
    
        surface.SetMaterial(ix.util.GetMaterial("materials/interlock/viewdata/datamugshot.png"))
        surface.SetDrawColor(255, 255, 255, 225)
        surface.DrawTexturedRect(0, 0, w, h)
    
        surface.SetDrawColor(90, 90, 90, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    
    local model = modelBackground:Add("DModelPanel")
    model:Dock(FILL)

    if(!small) then
        model:DockMargin(2,2,2,2)
    end

    model:SetModel(self.target:GetModel())
    model.Entity:SetSkin(self.character:GetData("skin", 0))

    for k, v in pairs(self.character:GetData("groups", {})) do
        model.Entity:SetBodygroup(k, v)
    end

    function model:LayoutEntity( Entity ) return end

    local eyepos =  model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    eyepos:Add(Vector(9, 0, 2))    -- Move up slightly
    model:SetLookAt(eyepos)
    model:SetCamPos(eyepos-Vector(-12, 0, -1))    -- Move cam in front of eyes
    model.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))
    
    return modelBackground
end

function PANEL:BuildLabel(text, title, align, overrideFont)
    local label = self:Add("DLabel")
    local font = "ixSmallFont"

    if(title) then
        font = "ixBigFont"
    end

    font = overrideFont or font

    label:SetContentAlignment(align or 5)
    label:SetFont(font)
    label:SetText(text)
    label:Dock(TOP)
    label:SizeToContents()
    label:SetExpensiveShadow(3)

    return label
end

function PANEL:AddStageButton(name, parent)
    local button = vgui.Create("DButton")
    button:SetSize(233, 100)
    button:SetText(name)
    button:SetFont("ixSmallFont")
    
    function button.DoClick()
        ix.gui.record:SetStage(parent)
    end

    return button
end

function PANEL:AddBackHeader(callback)
    local header = vgui.Create("DPanel")
    header:Dock(TOP)
    header:SetTall(32)
    header:DockMargin(0, 0, 0, 4)
    header:SetDrawBackground(false)

    local model = header:Add(self:DrawCharacter(true))
    model:SetSize(32,32)
    model:DockMargin(4,4,4,4)

    local back = header:Add("DButton")
    back:Dock(LEFT)
    back:DockMargin(2,2,2,2)
    back:SetText("Back")
    back:SetFont("ixSmallFont")

    function back.DoClick()
        if(!callback) then
            ix.gui.record:SetStage("Home")
        else
            callback()
        end
    end
    
    return header
end

function PANEL:SendToServer(message, data)
    if(!message or !data or !self.character) then
        ErrorNoHalt("Could not send viewdata mesage to server because data or target character is missing.")
        return
    end
    
    net.Start("ixViewDataAction")
        net.WriteInt(self.character.id, 32)
        net.WriteInt(message, 16)
        net.WriteTable(data)
    net.SendToServer()
end

vgui.Register("ixCombineViewData", PANEL, "DFrame")