AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Forcefield"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Mode")
    self:NetworkVar("Entity", 0, "Dummy")
end

local MODE_ALLOW_ALL = 1
--local MODE_ALLOW_CID = 2
--local MODE_ALLOW_NONE = 3

if (SERVER) then
    function ENT:SpawnFunction(ply, trace)
        local angles = (ply:GetPos() - trace.HitPos):Angle()
        angles.p = 0
        angles.r = 0
        angles:RotateAroundAxis(angles:Up(), 270)

        local entity = ents.Create("ix_forcefield")
        entity:SetPos(trace.HitPos + Vector(0, 0, 40))
        entity:SetAngles(angles:SnapTo("y", 90))
        entity:Spawn()
        entity:Activate()

        Schema:SaveForceFields()
        return entity
    end

    function ENT:Initialize()
        self:SetModel("models/willardnetworks/props/forcefield_left.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)

        local data = {}
            data.start = self:GetPos() + self:GetRight() * -16
            data.endpos = self:GetPos() + self:GetRight() * -480
            data.filter = self
        local trace = util.TraceLine(data)

        local angles = self:GetAngles()
        angles:RotateAroundAxis(angles:Up(), 90)

        self.dummy = ents.Create("prop_physics")
        self.dummy:SetModel("models/willardnetworks/props/forcefield_right.mdl")
        self.dummy:SetPos(trace.HitPos)
        self.dummy:SetAngles(self:GetAngles())
        self.dummy:Spawn()
        self.dummy.PhysgunDisabled = true
        self:DeleteOnRemove(self.dummy)

        local verts = {
            {pos = Vector(0, 0, -25)},
            {pos = Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)},
            {pos = Vector(0, 0, -25)}
        }

        self:PhysicsFromMesh(verts)

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        self:SetCustomCollisionCheck(true)
        self:EnableCustomCollisions(true)
        self:SetDummy(self.dummy)

        physObj = self.dummy:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        self:SetMoveType(MOVETYPE_NOCLIP)
        self:SetMoveType(MOVETYPE_PUSH)
        self:MakePhysicsObjectAShadow()
        self:SetMode(MODE_ALLOW_ALL)
    end

    function ENT:StartTouch(entity)
        if (!self.buzzer) then
            self.buzzer = CreateSound(entity, "ambient/machines/combine_shield_touch_loop1.wav")
            self.buzzer:Play()
            self.buzzer:ChangeVolume(0.8, 0)
            self.buzzer:SetSoundLevel(60)
        else
            self.buzzer:ChangeVolume(0.8, 0.5)
            self.buzzer:Play()
        end

        hook.Run("ixForcefieldCollided", entity, self, self:GetMode() or 1)
        self.entities = (self.entities or 0) + 1
    end

    function ENT:EndTouch(entity)
        self.entities = math.max((self.entities or 0) - 1, 0)

        if (self.buzzer and self.entities == 0) then
            self.buzzer:FadeOut(0.5)
        end
    end

    function ENT:OnRemove()
        if (self.buzzer) then
            self.buzzer:Stop()
            self.buzzer = nil
        end

        if ( timer.Exists("ixBarrierAlarm") ) then
            timer.Remove("ixBarrierAlarm")
        end

        if (!ix.shuttingDown and !self.ixIsSafe) then
            Schema:SaveForceFields()
        end
    end

    local MODES = {
        {
            function(ply)
                return false
            end,
            "Off."
        },
        {
            function(ply)
                if ( ply:HasItem("id") ) or ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() ) then
                    return false
                else
                    return true
                end
            end,
            "Only allow people with valid Identification Cards."
        },
        {
            function(ply)
                if ( ply:IsLoyalist() or ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() ) then
                    return false
                else
                    return true
                end
            end,
            "Only allow loyalists."
        },
        {
            function(ply)
                if ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() or ply:IsProselyte() ) then
                    return false
                else
                    return true
                end
            end,
            "Never allow citizens."
        },
    }

    function ENT:Use(activator)
        if ((self.nextUse or 0) < CurTime()) then
            self.nextUse = CurTime() + 0.5
        else
            return
        end

        if ( activator:IsCombine() or activator:IsCA() or activator:IsDispatch() ) then
            self:SetMode(self:GetMode() + 1)

            if (self:GetMode() > #MODES) then
                self:SetMode(1)
                self:CollisionRulesChanged()

                self:SetSkin(3)
                self.dummy:SetSkin(3)

                self:EmitSound("npc/turret_floor/die.wav")
                self.dummy:EmitSound("npc/turret_floor/die.wav")

                Schema:AddDisplay("Attention Forcefield barrier mode changed to "..MODES[self:GetMode()][2], Color(255, 50, 50), true)
            else
                self:CollisionRulesChanged()

                self:SetSkin(0)
                self.dummy:SetSkin(0)

                if ( self:GetMode() == 4 ) then
                    self:SetSkin(1)
                    self:GetDummy():SetSkin(1)
                end

                self:EmitSound("ambient/alarms/klaxon1.wav", 90, 100 + (self:GetMode() - 1) * 6)
                self.dummy:EmitSound("ambient/alarms/klaxon1.wav", 90, 100 + (self:GetMode() - 1) * 6)

                Schema:AddDisplay("Attention Forcefield barrier mode changed to "..MODES[self:GetMode()][2], Color(70, 216, 218), true)
            end

            self:EmitSound("buttons/combine_button5.wav", 140, 100 + (self:GetMode() - 1) * 15)
            self.dummy:EmitSound("buttons/combine_button5.wav", 140, 100 + (self:GetMode() - 1) * 15)
            
            activator:ChatPrint("Changed barrier mode to: "..MODES[self:GetMode()][2])

            Schema:SaveForceFields()
        else
            self:EmitSound("buttons/combine_button3.wav")
        end
    end

    local whitelist = {
        ["prop_combine_ball"] = true,
        ["npc_grenade_frag"] = true,
        ["rpg_missile"] = true,
        ["grenade_ar2"] = true,
        ["crossbow_bolt"] = true,
        ["npc_combine_camera"] = true,
        ["npc_turret_ceiling"] = true,
        ["npc_cscanner"] = true,
        ["npc_combinedropship"] = true,
        ["npc_combine_s"] = true,
        ["npc_combinegunship"] = true,
        ["npc_hunter"] = true,
        ["npc_helicopter"] = true,
        ["npc_manhack"] = true,
        ["npc_metropolice"] = true,
        ["npc_rollermine"] = true,
        ["npc_clawscanner"] = true,
        ["npc_stalker"] = true,
        ["npc_strider"] = true,
        ["npc_turret_floor"] = true,
        ["prop_vehicle_zapc"] = true,
        ["prop_vehicle_jeep"] = true,
        ["prop_physics"] = true,
        ["hunter_flechette"] = true,
        ["npc_tripmine"] = true,
        ["ix_scanner"] = true,
        ["prop_ragdoll"] = true,
    }
    
    hook.Add("ShouldCollide", "ix_forcefields", function(a, b)
        local ply
        local entity

        if (a:IsPlayer()) then
            ply = a
            entity = b
        elseif (b:IsPlayer()) then
            ply = b
            entity = a
        else
            if ( IsValid(entity) ) then
                if ( entity:GetMode() == 1 or ( other.ixPlayer and other.ixPlayer:IsCombine() or other.ixPlayer:IsDispatch() ) ) then
                    return false
                end

                local otherClass = other:GetClass()

                if (whitelist[otherClass]) then
                    if ( otherClass == "prop_vehicle_jeep" and !other:GetModel():find("combine_apc") ) then
                        return true
                    end
                    return false
                end
            end
        end

        if ( IsValid(entity) and entity:GetClass() == "ix_forcefield" ) then
            if ( IsValid(ply) and ply:GetCharacter() ) then
                if ( ply:IsCombine() ) then
                    return false
                end

                local mode = entity:GetMode() or 1

                return istable(MODES[mode]) and MODES[mode][1](ply)
            else
                return entity:GetMode() != 4
            end
        end
    end)
end

local alarmSound = Sound("interlock/entities/scanner_access_denied.wav")
function ENT:Think()
    local dummy = self:GetDummy()
    if ( self:GetMode() == 4 ) then
        if ( ( self.nextAlarm or 0 ) < CurTime() ) then
            for k, v in pairs(ents.FindInSphere(self:GetPos(), 192)) do
                if ( v:IsPlayer() and v:Alive() and v:GetCharacter() ) then
                    if not ( v:IsCombine() ) then
                        if ( v:GetMoveType() == MOVETYPE_NOCLIP ) then return end
                        if not ( self:GetNWBool("ixAlarmTriggered") == true ) then
                            if ( SERVER ) then
                                self:EmitSound(alarmSound, 80)
                                dummy:EmitSound(alarmSound, 80)

                                timer.Create("ixBarrierAlarm", 1, 0, function()
                                    self:StopSound(alarmSound)
                                    dummy:StopSound(alarmSound)

                                    self:EmitSound(alarmSound, 80)
                                    dummy:EmitSound(alarmSound, 80)
                                end)

                                Schema:AddDisplay("attention barrier alarm triggered!", Color(255, 0, 0), true)
                                Schema:AddWaypoint(v:EyePos(), "BARRIER ALARM TRIGGERED", Color(255, 0, 0), 30, v)
                                self:SetNWBool("ixAlarmTriggered", true)

                                timer.Simple(60, function()
                                    self:SetNWBool("ixAlarmTriggered", nil)
                                    if ( timer.Exists("ixBarrierAlarm") ) then
                                        timer.Remove("ixBarrierAlarm")
                                    end
                                end)
                            end
                        end

                        self.nextAlarm = CurTime() + 5
                    end
                end
            end

            for k, v in pairs(ents.FindInSphere(dummy:GetPos(), 192)) do
                if ( v:IsPlayer() and v:Alive() and v:GetCharacter() ) then
                    if not ( v:IsCombine() ) then
                        if ( v:GetMoveType() == MOVETYPE_NOCLIP ) then return end
                        if not ( self:GetNWBool("ixAlarmTriggered") == true ) then
                            if ( SERVER ) then
                                self:EmitSound(alarmSound, 80, nil, 120)
                                dummy:EmitSound(alarmSound, 80, nil, 120)

                                timer.Create("ixBarrierAlarm", 1, 0, function()
                                    self:StopSound(alarmSound)
                                    dummy:StopSound(alarmSound)

                                    self:EmitSound(alarmSound, 80, nil, 120)
                                    dummy:EmitSound(alarmSound, 80, nil, 120)
                                end)

                                Schema:AddDisplay("attention barrier alarm triggered!", Color(255, 0, 0), true)
                                Schema:AddWaypoint(v:EyePos(), "BARRIER ALARM TRIGGERED", Color(255, 0, 0), 30, v)
                                self:SetNWBool("ixAlarmTriggered", true)

                                timer.Simple(60, function()
                                    self:SetNWBool("ixAlarmTriggered", nil)
                                    if ( timer.Exists("ixBarrierAlarm") ) then
                                        timer.Remove("ixBarrierAlarm")
                                    end
                                end)
                            end
                        end

                        self.nextAlarm = CurTime() + 5
                    end
                end
            end
        end
    end
end

if (CLIENT) then
    local SHIELD_MATERIAL = ix.util.GetMaterial("models/effects/shield_blue")

    function ENT:Initialize()
        local data = {}
            data.start = self:GetPos() + self:GetRight()*-16
            data.endpos = self:GetPos() + self:GetRight()*-480
            data.filter = self
        local trace = util.TraceLine(data)

        self:EnableCustomCollisions(true)
        self:PhysicsInitConvex({
            vector_origin,
            Vector(0, 0, 150),
            trace.HitPos + Vector(0, 0, 150),
            trace.HitPos
        })

        self.distance = self:GetPos():Distance(trace.HitPos)
    end

    function ENT:Draw()
        self:DrawModel()

        if (self:GetMode() == 1) then
            return
        end

        if ( self:GetMode() == 4 ) then
            SHIELD_MATERIAL = ix.util.GetMaterial("models/effects/shield_red")
        else
            SHIELD_MATERIAL = ix.util.GetMaterial("models/effects/shield_blue")
        end

        local pos = self:GetPos()
        local angles = self:GetAngles()
        local matrix = Matrix()
        matrix:Translate(pos + self:GetUp() * -40)
        matrix:Rotate(angles)

        render.SetMaterial(SHIELD_MATERIAL)

        local dummy = self:GetDummy()

        if (IsValid(dummy)) then
            local dummyPos = dummy:GetPos()
            local vertex = self:WorldToLocal(dummyPos)
            self:SetRenderBounds(vector_origin, vertex + self:GetUp() * 150)

            cam.PushModelMatrix(matrix)
                self:DrawShield(vertex)
            cam.PopModelMatrix()

            matrix:Translate(vertex)
            matrix:Rotate(Angle(0, 180, 0))

            cam.PushModelMatrix(matrix)
                self:DrawShield(vertex)
            cam.PopModelMatrix()

            local titleAngles = self:GetAngles()
            titleAngles:RotateAroundAxis(titleAngles:Up(), 90)
            titleAngles:RotateAroundAxis(titleAngles:Forward(), 90)

            local pos = LerpVector(0.5, pos, dummyPos) + self:GetUp() * 50
            local mode = self:GetMode()
            local text = "ACCESS GRANTED"
            local color = Color(70, 216, 218)
            if ( mode == 4 ) then
                text = "ACCESS RESTRICTED"
                color = Color(255, 50, 50)
            end
            local scale = Lerp((self.distance - 150) / (500 - 150), 0.05, 0.3)

            cam.Start3D2D(pos, titleAngles, scale)
                render.PushFilterMin(TEXFILTER.NONE)
                render.PushFilterMag(TEXFILTER.NONE)

                draw.SimpleText(text, "CombineFontBlur128", 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                render.PopFilterMin()
                render.PopFilterMag()
            cam.End3D2D()

            titleAngles:RotateAroundAxis(titleAngles:Right(), 180)    

            cam.Start3D2D(pos, titleAngles, scale)
                render.PushFilterMin(TEXFILTER.NONE)
                render.PushFilterMag(TEXFILTER.NONE)

                draw.SimpleText(text, "CombineFontBlur128", 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                render.PopFilterMin()
                render.PopFilterMag()
            cam.End3D2D()

            local forcefieldglow01 = DynamicLight(self:EntIndex())
            local forcefieldglow02 = DynamicLight(dummy:EntIndex())
            if (forcefieldglow01) then
                if ( self:GetNWBool("ixAlarmTriggered") ) then
                    forcefieldglow01.r = Color(255, 50, 50).r
                    forcefieldglow01.g = Color(255, 50, 50).g
                    forcefieldglow01.b = Color(255, 50, 50).b
                elseif mode == 4 then
                    forcefieldglow01.r = Color(255, 50, 50).r
                    forcefieldglow01.g = Color(255, 50, 50).g
                    forcefieldglow01.b = Color(255, 50, 50).b
                else
                    forcefieldglow01.r = Color(70, 216, 218).r
                    forcefieldglow01.g = Color(70, 216, 218).g
                    forcefieldglow01.b = Color(70, 216, 218).b
                end

                forcefieldglow01.pos = self:GetPos()
                forcefieldglow01.brightness = 2
                forcefieldglow01.Decay = 1000
                forcefieldglow01.Size = 256
                forcefieldglow01.DieTime = CurTime() + 1
            end

            if (forcefieldglow02) then
                if ( self:GetNWBool("ixAlarmTriggered") ) then
                    forcefieldglow02.r = Color(255, 50, 50).r
                    forcefieldglow02.g = Color(255, 50, 50).g
                    forcefieldglow02.b = Color(255, 50, 50).b
                elseif mode == 4 then
                    forcefieldglow02.r = Color(255, 50, 50).r
                    forcefieldglow02.g = Color(255, 50, 50).g
                    forcefieldglow02.b = Color(255, 50, 50).b
                else
                    forcefieldglow02.r = Color(70, 216, 218).r
                    forcefieldglow02.g = Color(70, 216, 218).g
                    forcefieldglow02.b = Color(70, 216, 218).b
                end

                forcefieldglow02.pos = dummy:GetPos()
                forcefieldglow02.brightness = 2
                forcefieldglow02.Decay = 1000
                forcefieldglow02.Size = 256
                forcefieldglow02.DieTime = CurTime() + 1
            end
        end
    end

    function ENT:DrawShield(vertex)
        mesh.Begin(MATERIAL_QUADS, 1)
            mesh.Position(vector_origin)
            mesh.TexCoord(0, 0, 0)
            mesh.AdvanceVertex()

            mesh.Position(self:GetUp() * 190)
            mesh.TexCoord(0, 0, 3)
            mesh.AdvanceVertex()

            mesh.Position(vertex + self:GetUp() * 190)
            mesh.TexCoord(0, 3, 3)
            mesh.AdvanceVertex()

            mesh.Position(vertex)
            mesh.TexCoord(0, 3, 0)
            mesh.AdvanceVertex()
        mesh.End()
    end
end