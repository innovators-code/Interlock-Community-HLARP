
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Combine Lock"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Locked")
    self:NetworkVar("Bool", 1, "DisplayError")

    if ( SERVER ) then
        self:NetworkVarNotify("Locked", self.OnLockChanged)
    end
end

if ( SERVER ) then
    function ENT:GetLockPosition(door, normal)
        local index = door:LookupBone("handle")
        local position = door:GetPos()
        normal = normal or door:GetForward():Angle()

        if (index and index >= 1) then
            position = door:GetBonePosition(index)
        end

        position = position + normal:Forward() * 7.2 + normal:Up() * 10 + normal:Right() * 2

        normal:RotateAroundAxis(normal:Up(), 90)
        normal:RotateAroundAxis(normal:Forward(), 180)
        normal:RotateAroundAxis(normal:Right(), 180)

        return position, normal
    end

    function ENT:SetDoor(door, position, angles)
        if not ( IsValid(door) or door:IsDoor() ) then
            return
        end

        local doorPartner = door:GetDoorPartner()

        self.door = door
        self.door:DeleteOnRemove(self)
        door.ixLock = self

        if (IsValid(doorPartner)) then
            self.doorPartner = doorPartner
            self.doorPartner:DeleteOnRemove(self)
            doorPartner.ixLock = self
        end

        self:SetPos(position + self:GetUp() * -4 + self:GetRight() * -2 + self:GetForward() * 2)
        self:SetAngles(angles)
        self:SetParent(door)
    end

    function ENT:SpawnFunction(ply, trace)
        local door = trace.Entity

        if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixLock)) then
            return ply:NotifyLocalized("dNotValid")
        end

        local normal = ply:GetEyeTrace().HitNormal:Angle()
        local position, angles = self:GetLockPosition(door, normal)

        local entity = ents.Create("ix_combinelock")
        entity:SetPos(trace.HitPos)
        entity:Spawn()
        entity:Activate()
        entity:SetDoor(door, position, angles)

        Schema:SaveCombineLocks()
        return entity
    end

    function ENT:Initialize()
        self:SetModel("models/hla/ap_lock.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)

        self.nextUseTime = 0
    end

    function ENT:OnRemove()
        if ( IsValid(self) ) then
            self:SetParent(nil)
        end

        if (IsValid(self.door)) then
            self.door:Fire("unlock")
            self.door.ixLock = nil
        end

        if (IsValid(self.doorPartner)) then
            self.doorPartner:Fire("unlock")
            self.doorPartner.ixLock = nil
        end

        if (!ix.shuttingDown) then
            Schema:SaveCombineLocks()
        end
    end

    function ENT:OnLockChanged(name, bWasLocked, bLocked)
        if (!IsValid(self.door)) then
            return
        end

        if (bLocked) then
            self:EmitSound("buttons/combine_button2.wav")
            self.door:Fire("lock")
            self.door:Fire("close")

            if (IsValid(self.doorPartner)) then
                self.doorPartner:Fire("lock")
                self.doorPartner:Fire("close")
            end
        else
            self:EmitSound("buttons/combine_button7.wav")
            self.door:Fire("unlock")

            if (IsValid(self.doorPartner)) then
                self.doorPartner:Fire("unlock")
            end
        end
    end

    function ENT:DisplayError()
        self:EmitSound("buttons/combine_button_locked.wav")
        self:SetSkin(2)
        self:SetDisplayError(true)

        timer.Simple(1.2, function()
            if ( IsValid(self) ) then
                if ( self:GetLocked() ) then
                    self:SetSkin(1)
                else
                    self:SetSkin(0)
                end
                self:SetDisplayError(false)
            end
        end)
    end

    function ENT:Toggle(ply)
        self:SetLocked(!self:GetLocked())
        if ( self:GetLocked() ) then
            self:SetSkin(1)
        else
            self:SetSkin(0)
        end
    end

    function ENT:Use(ply)
        if (self.nextUseTime > CurTime()) then
            return
        end

        if not ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() ) then
            self:DisplayError()
            self.nextUseTime = CurTime() + 2

            return
        end
        
        self:Toggle(ply)
        self.nextUseTime = CurTime() + 2
    end
else
    local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
    local color_green = Color(255, 255, 0)
    local color_blue = Color(0, 200, 255, 255)
    local color_red = Color(200, 50, 255)

    function ENT:Draw()
        self:DrawModel()

        local color = color_blue

        if (self:GetDisplayError()) then
            color = color_green
        elseif (self:GetLocked()) then
            color = color_red
        end

        local position = self:GetPos() + self:GetUp() * 3 + self:GetForward() * -2.75 + self:GetRight() * -2

        render.SetMaterial(glowMaterial)
        render.DrawSprite(position, 10, 10, color)
        
        local pos = self:GetPos()
        local angs = self:GetAngles()
        
        angs:RotateAroundAxis(self:GetUp(), 0)
        angs:RotateAroundAxis(self:GetForward(), -90)
        angs:RotateAroundAxis(self:GetRight(), 180)
        
        pos = pos + self:GetForward() * -3
        pos = pos - self:GetRight() * 1.9
        pos = pos + self:GetUp() * 19
        
        
        cam.Start3D2D(pos, angs, 0.08)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(-45, 0, 89, 60)
            draw.DrawText("<:: CLAMPED ::>", "HudHintTextSmall", 0, 10, color_white, TEXT_ALIGN_CENTER)
            if ( self:GetDisplayError() ) then
                draw.DrawText("ACCESS RESTRICTED", "HudHintTextSmall", -1, 40, Color(255, 255, 0), TEXT_ALIGN_CENTER)
            end
            if ( self:GetLocked() ) then
                draw.DrawText("LOCKED", "HudHintTextSmall", -1, 30, Color(200, 50, 255), TEXT_ALIGN_CENTER)
            else
                draw.DrawText("UNLOCKED", "HudHintTextSmall", -1, 30, Color(0, 200, 255, 255), TEXT_ALIGN_CENTER)
            end
        cam.End3D2D()
    end
    
    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(container)
        local name = container:AddRow("name")
        name:SetImportant()
        name:SetText("Combine Lock")
        name:SizeToContents()
    end
end
