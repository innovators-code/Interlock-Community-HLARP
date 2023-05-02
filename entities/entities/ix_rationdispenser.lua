AddCSLuaFile()

ENT.Base             = "base_gmodentity"
ENT.Type             = "anim"
ENT.PrintName        = "Ration Machine"
ENT.Author            = "Riggs.mackay"
ENT.Purpose            = "A Machine which dispenses rations, each ration you have to wait to gain another."
ENT.Instructions    = "Press E"
ENT.Category         = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "RationTime")
    self:NetworkVar("Float", 1, "FlashTime")
    self:NetworkVar("Bool", 0, "Locked")
end

function ENT:IsLocked()
    return self:GetLocked()
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_junk/metalgascan.mdl")
    
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local physics = self:GetPhysicsObject()
        physics:EnableMotion(false)
        physics:Sleep()
    
        self.dispenser = ents.Create("prop_dynamic")
        self.dispenser:DrawShadow(false)
        self.dispenser:SetAngles(self:GetAngles())
        self.dispenser:SetParent(self)
        self.dispenser:SetModel("models/willardnetworks/props_combine/combine_dispenser.mdl")
        self.dispenser:SetPos(self:GetPos())
        self.dispenser:Spawn()
    
        self:DeleteOnRemove(self.dispenser)
    
        local minimum = Vector(-8, -8, -8)
        local maximum = Vector(8, 8, 64)

        self:DrawShadow(false)
    end
    
    function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
    end
    
    function ENT:Toggle()
        if (self:IsLocked()) then
            self:Unlock()
        else
            self:Lock()
        end
    end
    
    function ENT:Lock()
        self:SetLocked(true)
        self:EmitRandomSound()
    end
    
    function ENT:Unlock()
        self:SetLocked(false)
        self:EmitRandomSound()
    end
    
    function ENT:SetFlashDuration(duration)
        self:EmitSound("buttons/combine_button_locked.wav", 80)
        self:SetFlashTime(CurTime() + duration)
    end
    
    local classes = {
        -- Citizen
        [CLASS_A_1_CITIZEN] = {
            ["ration"] = "correct_ration",
        },
        [CLASS_A_2_ANTICITIZEN] = {
            ["ration"] = "low_ration",
        },
        [CLASS_A_3_OUTCAST] = {
            ["ration"] = "low_ration",
        },
        [CLASS_A_4_LOYALIST] = {
            ["ration"] = "good_ration",
        },
        [CLASS_A_5_PRIORITYLOYALIST] = {
            ["ration"] = "top_ration",
        },
        
        -- Universal Union Associate
        [CLASS_B_1_UNASSIGNED] = {
            ["ration"] = "good_ration",
        },
        [CLASS_B_1_ASSIGNEDDEPARTMENT] = {
            ["ration"] = "good_ration",
        },
        [CLASS_B_3_UEC] = {
            ["ration"] = "good_ration",
        },
        [CLASS_B_4_CIC] = {
            ["ration"] = "good_ration",
        },
        [CLASS_B_5_UM] = {
            ["ration"] = "top_ration",
        },
        
        -- Union Administration Board
        [CLASS_J_1_UABOFFICIAL] = {
            ["ration"] = "top_ration",
        },
        
        -- Civil Protection
        [CLASS_C_1_RCT] = {
            ["ration"] = "good_ration",
        },
        [CLASS_C_2_00] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_3_10] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_4_25] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_5_50] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_6_75] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_7_99] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_8_OFC] = {
            ["ration"] = "cp_ration",
        },
        [CLASS_C_9_RL] = {
            ["ration"] = "top_ration",
        },
        [CLASS_C_10_CMD] = {
            ["ration"] = "top_ration",
        },
    }
    
    function ENT:CreateDummyRation(ply)
        local forward = self:GetForward() * 15
        local right = self:GetRight() * 0
        local up = self:GetUp() * -8
    
        local entity = ents.Create("prop_physics")
    
        entity:SetAngles(self:GetAngles())
        for k, v in pairs(classes[ply:GetCharacter():GetClass()]) do
            entity:SetModel(ix.item.Get(v).model)
        end
        entity:SetPos(self:GetPos() + forward + right + up)
        entity:Spawn()
    
        return entity
    end
    
    function ENT:ActivateRation(ply, ration, duration, force)
        local char = ply:GetCharacter()
        local curTime = CurTime()
        
        if (!duration) then duration = 6 end
    
        if (force or !self.nextActivateRation or curTime >= self.nextActivateRation) then
            self.nextActivateRation = curTime + duration + 2
            self:SetRationTime(curTime + duration)
    
            timer.Create("ration_" .. self:EntIndex(), duration, 1, function()
                if (!IsValid(self)) then return end
    
                local dispenser = self.dispenser
                local entity = self:CreateDummyRation(ply)
    
                if (!IsValid(entity)) then return end
    
                entity:EmitSound("ambient/machines/combine_terminal_idle4.wav")
    
                entity:SetNotSolid(true)
                entity:SetParent(dispenser)
    
                timer.Simple(0, function()
                    if !(IsValid(self) and IsValid(entity)) then return end
    
                    entity:Fire("SetParentAttachment", "package_attachment", 0)
    
                    timer.Simple(0, function()
                        if !(IsValid(self) and IsValid(entity)) then return end
    
                        dispenser:Fire("SetAnimation", "dispense_package", 0)
    
                        timer.Simple(1.75, function()
                            if !(IsValid(self) and IsValid(entity)) then return end
    
                            local position = entity:GetPos()
                            local angles = entity:GetAngles()
    
                            entity:CallOnRemove("CreateRation", function()
                                if (IsValid(ply)) then
                                    ix.item.Spawn(ration or "correct_ration", position, nil, angles)
                                    realration = ration
                                end
                            end)
    
                            entity:SetNoDraw(true)
                            entity:Remove()
                        end)
                    end)
                end)
            end)
        end
    end
    
    function ENT:EmitRandomSound()
        local randomSounds = {
            "buttons/combine_button1.wav",
            "buttons/combine_button2.wav",
            "buttons/combine_button3.wav",
            "buttons/combine_button5.wav",
            "buttons/combine_button7.wav"
        }
    
        self:EmitSound(randomSounds[ math.random(1, #randomSounds) ])
    end
    
    function ENT:Use(ply, caller)
        local char = ply:GetCharacter()
        if ( ply:IsPlayer() ) then
            local curTime = CurTime()
    
            if not ( self.nextUse ) or ( curTime >= self.nextUse ) then
                if ( ply:IsCombine() ) then
                    net.Start("ixRationDispenserQuery")
                        net.WriteEntity(self)
                    net.Send(ply)
                    self.nextUse = CurTime() + 4
                else
                    if ( ( ply.nextRation or 0 ) < CurTime() ) then
                        if ( self:GetLocked() ) then
                            self:SetFlashDuration(2)
                            self.nextUse = CurTime() + 2.5
                            return
                        end

                        for k, v in pairs(classes[ply:GetCharacter():GetClass()]) do
                            self:ActivateRation(ply, ix.item.Get(v))
                        end
                        
                        ply.nextRation = CurTime() + ix.config.Get("rationInterval", 10)
                    else
                        if ( ( ply.nextRationCheck or 0 ) < CurTime() ) then
                            ply:ChatNotify("You need to wait "..math.ceil(ply.nextRation - CurTime()).." seconds before you can get your ration again!")
                            self:SetFlashDuration(2)
                            ply.nextRationCheck = CurTime() + 2.5
                        end
                    end
                end
            end
        end
    end
    
    function ENT:CanTool(player, trace, tool)
        return false
    end

    util.AddNetworkString("ixRationDispenserQuery")
    util.AddNetworkString("ixRationDispenserDispense")
    util.AddNetworkString("ixRationDispenserToggle")
    net.Receive("ixRationDispenserDispense", function(len, ply)
        local self = net.ReadEntity()
        local curTime = CurTime()
        if ( self:IsLocked() ) then
            if ( ( ply.nextRationPress or 0 ) < CurTime() ) then
                self:SetFlashDuration(2)
                ply.nextRationPress = CurTime() + 2.5
            end
        else
            if (!self.nextActivateRation or curTime >= self.nextActivateRation) then
                if ( ( ply.nextRation or 0 ) < CurTime() ) then
                    self:ActivateRation(ply, "cp_ration")
                    ply.nextRation = CurTime() + ix.config.Get("rationInterval", 10)
                else
                    if ( ( ply.nextRationCheck or 0 ) < CurTime() ) then
                        ply:ChatNotify("You need to wait "..math.ceil(ply.nextRation - CurTime()).." seconds before you can get your ration again!")
                        self:SetFlashDuration(2)
                        ply.nextRationCheck = CurTime() + 2.5
                    end
                end
            end
        end
    end)

    net.Receive("ixRationDispenserToggle", function(len, ply)
        local self = net.ReadEntity()
        local curTime = CurTime()
        self:SetLocked(!self:GetLocked())
        self:EmitRandomSound()
    end)
else
    net.Receive("ixRationDispenserQuery", function()
        local self = net.ReadEntity()
        Derma_Query("What action would you like to do?", "Ration Dispenser", "Dispense", function()
            net.Start("ixRationDispenserDispense")
                net.WriteEntity(self)
            net.SendToServer()  
        end, "Override", function()
            
            net.Start("ixRationDispenserToggle")
                net.WriteEntity(self)
            net.SendToServer()
        end)
    end)
    local glowMaterial = Material("sprites/glow04_noz")

    function ENT:Draw()
        local _, _, _, a = self:GetColor()
        local rationTime = self:GetRationTime()
        local flashTime = self:GetFlashTime()
        local position = self:GetPos()
        local angles = self:GetAngles()
        local forward = self:GetForward() * 10
        local curTime = CurTime()
        local right = self:GetRight()
        local up = self:GetUp() * 22
    
        if (rationTime > curTime) then
            local glowColor = Color(0, 0, 255, a)
            local timeLeft = rationTime - curTime
    
            if (!self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime)) then
                cam.Start3D()
                    render.SetMaterial(glowMaterial)
                    render.DrawSprite(position + self:GetForward() * 10 + self:GetRight() * -1.5 + self:GetUp() * 22, 20, 20, glowColor)
                cam.End3D()
    
                if (!self.flashUntil or curTime >= self.flashUntil) then
                    self.nextFlash = curTime + (timeLeft / 4)
                    self.flashUntil = curTime + (FrameTime() * 4)
                    self:EmitSound("buttons/blip1.wav", 80)
                end
            end
        else
            local glowColor = Color(0, 255, 0, a)
    
            if (self:IsLocked()) then
                glowColor = Color(255, 150, 0, a)
            end
    
            if (flashTime and flashTime >= curTime) then
                glowColor = Color(255, 0, 0, a)
            end
    
            cam.Start3D()
                render.SetMaterial(glowMaterial)
                render.DrawSprite(position + self:GetForward() * 10 + self:GetRight() * -1.5 + self:GetUp() * 22, 20, 20, glowColor)
            cam.End3D()
        end
    end
end
