ENT.Type = "anim"
ENT.PrintName = "Dissolver"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Dummy")
    self:NetworkVar("Bool", 0, "Toggle")
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/willardnetworks/props/forcefield_left.mdl")
        self:DrawShadow(false)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetToggle(true)
        
        local data = {}
            data.start = self:GetPos() + self:GetRight() * -16
            data.endpos = self:GetPos() + self:GetRight() * -784
            data.filter = self
        local trace = util.TraceLine(data)

        local angles = self:GetAngles()
        angles:RotateAroundAxis(angles:Up(), 90)

        self.dummy = ents.Create("prop_physics")
        self.dummy:SetModel("models/willardnetworks/props/forcefield_right.mdl")
        self.dummy:SetPos(trace.HitPos)
        self.dummy:SetAngles(self:GetAngles())
        self.dummy:Spawn()
        self.dummy:DrawShadow(false)
        self.dummy:DeleteOnRemove(self)
        self.dummy:MakePhysicsObjectAShadow(false, false)
        self:DeleteOnRemove(self.dummy)
        self:SetDummy(self.dummy)

        local physics_object = self:GetPhysicsObject()

        if ( IsValid(physics_object) ) then
            physics_object:EnableMotion(false)
        end

        physics_object = self.dummy:GetPhysicsObject()

        if ( IsValid(physics_object) ) then
            physics_object:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(client, trace)
        local angles = (client:GetPos() - trace.HitPos):Angle()
        angles.p = 0
        angles.r = 0
        angles:RotateAroundAxis(angles:Up(), 270)

        local entity = ents.Create(self.ClassName)
        entity:SetPos(trace.HitPos + Vector(0, 0, 40) + entity:GetForward() * 8)
        entity:SetAngles(angles:SnapTo("y", 90))
        entity:Spawn()
        entity:Activate()

        Schema:SaveForceFields()
        return entity
    end
    function ENT:DissolvePlayer( pl, pos )
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll:SetModel( pl:GetModel() )
        ragdoll:SetPos( pos) 
        ragdoll:SetAngles( pl:GetAngles() + Angle(5,4,3) )
        ragdoll:Spawn() 
        timer.Simple(0.1, function()
            ragdoll:GetPhysicsObject():EnableGravity(false)
        end) 
        pl:Kill()
        pl:SetPos(pl:GetPos() + self:GetForward() * 50)
        self:EmitSound("ambient/levels/citadel/zapper_warmup1.wav" )
        self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1,4) .. ".wav")
        timer.Simple(0.1, function()
            self:EmitSound("interlock/entities/scanner_access_denied.wav", 90)
            self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1,4) .. ".wav")
            timer.Create( ragdoll:EntIndex() .. "_dissolveloop", 0.5, 2, function()
                self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1,4) .. ".wav")
            end)        
            local diss = ents.Create("env_entity_dissolver")
            ragdoll:SetName(tostring(ragdoll))
            diss:SetPos(ragdoll:GetPos()) 
            diss:SetKeyValue("target", ragdoll:GetName())
            diss:SetKeyValue("magnitude", 2)
            diss:SetKeyValue("dissolvetype", 1)
            diss:Spawn() 
            diss:Fire("Dissolve", "", 0)
            diss:Fire("kill", "", 0.1)
        end)
    end

    function ENT:Confiscate( model, pos, ang )
        local weapon = ents.Create("prop_physics")
        weapon:SetModel(model)
        weapon:SetPos(pos)
        weapon:SetAngles(ang)
        weapon:Spawn() 
        timer.Simple(0.2, function()
            weapon:GetPhysicsObject():EnableGravity(false)
        end)
        
        self:EmitSound("npc/overwatch/cityvoice/fcitadel_confiscating.wav")
        self:EmitSound("ambient/energy/zap" .. math.random(1,3) .. ".wav")
        
        timer.Simple(2.5, function()
            self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1,4) .. ".wav")
            timer.Create( self:EntIndex() .. "_dissolveloop", 0.5, 4, function()
                self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1,4) .. ".wav")
            end) 
            local diss = ents.Create("env_entity_dissolver")
            weapon:SetName(tostring(weapon))
            diss:SetPos(weapon:GetPos())
            diss:SetKeyValue("target", weapon:GetName())
            diss:SetKeyValue("magnitude", 0)
            diss:SetKeyValue("dissolvetype", 2)
            diss:Spawn()
            diss:Fire("Dissolve", "", 0)
            diss:Fire("kill", "", 0.1)
        end)
    end

    local dissolve_entity_types = {
        ["ix_item"] = function(entity)
            return entity
        end,
        ["ix_money"] = function(entity)
            return entity
        end
    }

    local beep_delay = 1
    local beep_occurrence = -beep_delay
    
    function ENT:Think()
        local cur_time = CurTime()
        local beep_time_elapsed = cur_time - beep_occurrence

        if self:GetToggle() then
            local entities = ents.FindInBox(self:GetPos()-Vector(0,0,55), self:GetDummy():GetPos() + self:GetUp() * 150+Vector(5,5,0))

            for i = 1, #entities do
                local entity = entities[i]

                if IsValid(entity) and dissolve_entity_types[entity:GetClass()] and not entity.dissolve_cooldown then
                    local correct_entity = dissolve_entity_types[entity:GetClass()](entity)

                    if correct_entity then
                        self:Confiscate(entity:GetModel(), entity:GetPos(), entity:GetAngles())
                        entity:Remove()
                    end
                end

                if entity:GetClass() == "player" and not entity:GetNetVar("dissolve") then
                    if not entity:IsCombine() and entity:Team() != FACTION_ADMIN and entity:GetMoveType() != MOVETYPE_NOCLIP then
                        entity:SetNetVar("dissolve", true)
                        timer.Simple(10, function()
                            entity:SetNetVar("dissolve", false)
                        end)
                        self:DissolvePlayer(entity, entity:GetPos())
                    end
                end

                -- do we need this thing?
                if IsValid(entity) and entity:IsPlayer() and ( entity:IsCombine() or entity:Team() == FACTION_ADMIN ) and entity:GetMoveType() != MOVETYPE_NOCLIP then
                    if beep_time_elapsed > beep_delay then
                        self:EmitSound("buttons/blip2.wav", 90)

                        beep_occurrence = cur_time
                    end
                end
            end
        end
        -- disgusting
        if not ( self.sound_loop ) then
            self.sound_loop = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
            self.sound_loop:Play()
            self.sound_loop:ChangeVolume(0.8, 0)
        else
            if self:GetToggle() then
                self.sound_loop:Play()
            else
                self.sound_loop:FadeOut(1)
            end
        end

        if ( self:GetToggle() and self:GetNetVar("light") ) then
            if ( !self.Beep or CurTime() >= self.Beep ) then
                self:EmitSound("interlock/entities/scanner_access_denied.wav")
                self:GetDummy():EmitSound("interlock/entities/scanner_access_denied.wav")
                self.Beep = CurTime() + 2
            end

            -- messy skin stuff but idc
            self:SetSkin(1)
            self.dummy:SetSkin(1)
        elseif ( self:GetToggle() and not self:GetNetVar("light") ) then
            self:SetSkin(0)
            self.dummy:SetSkin(0)
        else
            self:SetSkin(3)
            self.dummy:SetSkin(3)
        end

        if ( self:GetToggle() ) then
            local data = {}
            for k, v in pairs(ents.FindInSphere(self:GetPos() + self:GetRight()*-(self:GetPos():Distance(self:GetDummy():GetPos())/2), 200)) do
                table.insert(data, v:GetClass())
            end

            if ( table.HasValue(data, "player") ) then
                for k, v in pairs(ents.FindInSphere(self:GetPos() + self:GetRight()*-(self:GetPos():Distance(self:GetDummy():GetPos())/2), 200)) do
                    if ( v:IsPlayer() and v:Alive() ) then
                        if not ( v:IsDispatch() or v:IsCombine() or v:IsCA() or v:GetMoveType() == MOVETYPE_NOCLIP ) then
                            if not self:GetNetVar("light") then
                                if ( not self.Warning or CurTime() >= self.Warning ) then
                                    Schema:AddDisplay("attention barrier alarm triggered!", Color(255, 0, 0), true)
                                    Schema:AddWaypoint(v:EyePos(), "BARRIER ALARM TRIGGERED", Color(255, 0, 0), 120, v)
                                    ix.dispatch.announce("Attention please. Access to this block is not permitted. To receive this message is to be in civil code violation.", v)
                                    self:EmitSound("interlock/dispatch/07_10004.ogg", 40)
                                    self:GetDummy():EmitSound("interlock/dispatch/07_10004.ogg", 40)
                                    self.Warning = CurTime() + 120
                                end
                                self:SetNetVar("light", true)
                                self.BeepDouble = true
                            end
                        end
                    end
                end
            else
                if self:GetNetVar("light") then
                    self:SetNetVar("light", false)
                    if self.BeepDouble then
                        if (not self.Beep2 or CurTime() >= self.Beep2) then
                            self:EmitSound("interlock/entities/scanner_access_denied.wav")
                            self:GetDummy():EmitSound("interlock/entities/scanner_access_denied.wav")
                            self.BeepDouble = false
                            self.Beep2 = CurTime() + 15 -- fix spam (W and S)
                        end
                    end
                end
            end
        end
    end

    function ENT:OnRemove()
        if self.sound_loop then
            self.sound_loop:Stop()
            self.sound_loop = nil
        end
    end

    function ENT:Set_id(id)
        self:SetNetVar("id", id)
    end

    function ENT:toggle(boolean)
        self:SetToggle(boolean)

        if self:GetToggle() then
            self:SetSkin(3)
            self.dummy:SetSkin(3)
            self:EmitSound("hl2rp/forcefield/enable.mp3")
            self:GetDummy():EmitSound("hl2rp/forcefield/enable.mp3")
        else
            self:SetSkin(0)
            self.dummy:SetSkin(0)
            self:EmitSound("hl2rp/forcefield/enable.mp3")
            self:GetDummy():EmitSound("hl2rp/forcefield/disable.mp3")
        end
    end
else
    local material = ix.util.GetMaterial("models/effects/shield_blue")

    function ENT:Draw()
        self:DrawModel()

        if ( self:GetToggle() and self:GetNetVar("light") ) then
            material = ix.util.GetMaterial("models/effects/shield_red")
        else
            material = ix.util.GetMaterial("models/effects/shield_blue")
        end

        local dummy = self:GetDummy()
        local angles = self:GetAngles()
        local matrix = Matrix()

        matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2)
        matrix:Rotate(angles)

        if ( IsValid(dummy) and self:GetToggle() ) then
            local vertex = self:WorldToLocal(dummy:GetPos())

            self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150)

            render.SetMaterial(material)

            cam.PushModelMatrix(matrix)
                self:draw_shield(vertex)
            cam.PopModelMatrix()

            matrix:Translate(vertex)
            matrix:Rotate(Angle(0, 180, 0))

            cam.PushModelMatrix(matrix)
                self:draw_shield(vertex)
            cam.PopModelMatrix()
        end
    end

    function ENT:draw_shield(vertex)
        local dist = self:GetDummy():GetPos():Distance(self:GetPos())
        local mat_fac = 90
        local height = 2
        local width = dist / mat_fac

        mesh.Begin(MATERIAL_QUADS, 1)
            mesh.Position(vector_origin)
            mesh.TexCoord(0, 0, 0)
            mesh.AdvanceVertex()
            mesh.Position(self:GetUp() * 190)
            mesh.TexCoord(0, 0, height)
            mesh.AdvanceVertex()
            mesh.Position(vertex + self:GetUp() * 190)
            mesh.TexCoord(0, width, height)
            mesh.AdvanceVertex()
            mesh.Position(vertex)
            mesh.TexCoord(0, width, 0)
            mesh.AdvanceVertex()
        mesh.End()
    end

    function ENT:Think()
        if ( self:GetToggle() and self:GetNetVar("light") ) then
            local dlight = DynamicLight( self:EntIndex() )
            dlight.pos = self:GetPos()
            dlight.r = 255
            dlight.g = 2
            dlight.b = 0
            dlight.brightness = 3
            dlight.Decay = 1000
            dlight.Size = 400
            dlight.DieTime = CurTime() + 1

            local dlight2 = DynamicLight( self:EntIndex()+1 )
            dlight2.pos = self:GetDummy():GetPos()
            dlight2.r = 255
            dlight2.g = 2
            dlight2.b = 0
            dlight2.brightness = 3
            dlight2.Decay = 1000
            dlight2.Size = 400
            dlight2.DieTime = CurTime() + 1
        end
    end
end

function ENT:id()
    return self:GetNetVar("id", 0)
end
