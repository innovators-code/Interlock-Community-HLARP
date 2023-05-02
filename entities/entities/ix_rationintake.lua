AddCSLuaFile()

ENT.Base             = "base_gmodentity"
ENT.Type             = "anim"
ENT.PrintName        = "Ration Intake"
ENT.Author            = "Riggs.mackay"
ENT.Purpose            = "A Machine which dispenses rations, each ration you have to wait to gain another."
ENT.Instructions    = "Press E"
ENT.Category         = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "RationTime")
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
        self.dispenser:SetModel("models/props_combine/pickup_dispenser3.mdl")
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
    
    function ENT:CreateDummyRation()
        local forward = self:GetForward() * 15
        local right = self:GetRight() * 0
        local up = self:GetUp() * -8
    
        local entity = ents.Create("prop_physics")
    
        entity:SetAngles(self:GetAngles())
        entity:SetModel("models/willardnetworks/food/ration.mdl")
        entity:SetPos(self:GetPos() + forward + right + up)
        entity:Spawn()
    
        return entity
    end
    
    function ENT:ActivateRation(ply, force)
        local char = ply:GetCharacter()
        local curTime = CurTime()
    
        if (force or !self.nextActivateRation or curTime >= self.nextActivateRation) then
            self.nextActivateRation = curTime + 4
            if (!IsValid(self)) then return end

            local dispenser = self.dispenser
            local entity = self:CreateDummyRation()

            if (!IsValid(entity)) then return end

            self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

            entity:SetNoDraw(true)
            entity:SetNotSolid(true)
            entity:SetParent(dispenser)

            timer.Simple(0, function()
                if !(IsValid(self) and IsValid(entity)) then return end

                entity:Fire("SetParentAttachment", "package_attachment", 0)

                timer.Simple(0, function()
                    if !(IsValid(self) and IsValid(entity)) then return end

                    dispenser:Fire("SetAnimation", "dispense_package", 0)

                    timer.Simple(1, function()
                        entity:SetNoDraw(false)
                    end)
                    timer.Simple(1.5, function()
                        entity:SetModel("models/props_junk/popcan01a.mdl")
                    end)
                    timer.Simple(3, function()
                        self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
                        entity:SetModel("models/weapons/w_package.mdl")
                        dispenser:Fire("SetAnimation", "dispense_package", 0)
                    end)
                    timer.Simple(4, function()
                        if !(IsValid(self) and IsValid(entity)) then return end
    
                        local position = entity:GetPos()
                        local angles = entity:GetAngles()

                        if (IsValid(ply)) then
                            local rationItem = "correct_ration"
                            local randomChance = math.random(1,14)
                            if ( randomChance <= 2 ) then
                                rationItem = "vortigaunt_ration"
                            elseif ( randomChance <= 4 ) then
                                rationItem = "low_ration"
                            elseif ( randomChance <= 6 ) then
                                rationItem = "good_ration"
                            elseif ( randomChance <= 8 ) then
                                rationItem = "top_ration"
                            elseif ( randomChance <= 10 ) then
                                rationItem = "cp_ration"
                            elseif ( randomChance <= 12 ) then
                                rationItem = "correct_ration"
                            end
                            ix.item.Spawn(rationItem, position, nil, angles)
                        end
                        entity:Remove()
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
            "buttons/combine_button7.wav",
        }
    
        self:EmitSound(randomSounds[math.random(1,#randomSounds)])
    end
    
    function ENT:PhysicsUpdate(physicsObject)
        if (!self:IsPlayerHolding() and !self:IsConstrained()) then
            physicsObject:SetVelocity(Vector(0, 0, 0))
            physicsObject:Sleep()
        end
    end
    
    function ENT:Use(ply, caller)
        local char = ply:GetCharacter()
        if (ply:IsPlayer() and ply:GetEyeTraceNoCursor().Entity == self) then
            local curTime = CurTime()
            local unixTime = os.time()
    
            if (!self.nextUse or curTime >= self.nextUse) then
                if not ( self:IsLocked() ) then
                    if (!self.nextActivateRation or curTime >= self.nextActivateRation) then
                        if not ( ply:HasItem("junk_ration") ) then
                            ply:Notify("You need a Empty Ration!")
                            return
                        end

                        if not ( ply:HasItem("proc_nutrient_bar") ) then
                            ply:Notify("You need a Nutrient Bar!")
                            return
                        end

                        if not ( ply:HasItem("drink_breen_water") ) then
                            ply:Notify("You need Classic Breen's Water!")
                            return
                        end

                        ply:GetCharacter():GetInventory():HasItem("proc_nutrient_bar"):Remove()
                        ply:GetCharacter():GetInventory():HasItem("drink_breen_water"):Remove()
                        ply:GetCharacter():GetInventory():HasItem("junk_ration"):Remove()
                        self:ActivateRation(ply)
                    end
                end
    
                self.nextUse = curTime + 3
            end
        end
    end
    
    function ENT:CanTool(player, trace, tool)
        return false
    end
end