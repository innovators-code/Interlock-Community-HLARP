AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- yes these are globals
-- if this causes problems with other asddons then i can change them later on

BOUNCEBOMB_RADIUS = 24
BOUNCEBOMB_MAX_FLIPS = 5
BOUNCEBOMB_HOOK_RANGE = 64
BOUNCEBOMB_WARN_RADIUS = 245
BOUNCEBOMB_DETONATE_RADIUS = 100

BOUNCEBOMB_EXPLODE_RADIUS = 125
BOUNCEBOMB_EXPLODE_DAMAGE = 150

MINE_STATE_DORMANT = 0
MINE_STATE_DEPLOY = 1    -- Try to lock down and arm
MINE_STATE_CAPTIVE = 3    -- Held in the physgun
MINE_STATE_ARMED = 4    -- Locked down and looking for targets
MINE_STATE_TRIGGERED = 5-- No turning back. I'm going to explode when I touch something.
MINE_STATE_LAUNCHED = 6    -- Similar. Thrown from physgun.

MINE_MODIFICATION_NORMAL = 0
MINE_MODIFICATION_CAVERN = 1

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_mine01.mdl")
    if !IsValid(self:GetParent()) then
        self:PhysicsInit(SOLID_VPHYSICS)
    end
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetSkin(self.iSkin or 0)

    self:Wake(false)

    self.iAllHooks = "blendstates"
    self.flHookPositions = 0

    self.bBounce = self.bBounce == nil and true or self.bBounce

    self:ResetSequence(0)

    self:OpenHooks(true)

    self.bHeldByPhysgun = false

    self.iFlipAttempts = 0

    self.flTimeGrabbed = 9999999999999999999

    if self.bDisarmed then
        self:SetStatus(MINE_STATE_DORMANT)
    else
        self:SetStatus(MINE_STATE_DEPLOY)
    end

    -- i couldnt work out the meaning of the GetDataDescMap function in the source code
    -- so i just replaced this with setting it to a random skin, if the skin isnt
    -- set already
    if self.iModification == MINE_MODIFICATION_CAVERN then
        if self:GetSkin() == 0 then
            self.iSkin = math.random(1, self:SkinCount() - 1)
            self:SetSkin(self.iSkin)
        end

        self.bPlacedByPlayer = true
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:SetStatus(status)
    self.iStatus = status

    switch(status, {
        [MINE_STATE_DORMANT] = function()
            self.pWarnSound:ChangeVolume(0, 0.1)
            self:UpdateLight(false, Color(0, 0, 0, 0))
            self:SetThink(nil)
        end,
        [MINE_STATE_CAPTIVE] = function()
            self.pWarnSound:ChangeVolume(0, 0.2)

            self:OpenHooks()

            if self.pConstraint then
                self.pConstraint:Remove()
                self.pConstraint = nil
            end

            self:UpdateLight(true, Color(0, 0, 255, 190))
            self:SetThink(self.CaptiveThink)
            self:SetNextThink(CurTime() + 0.1)
            self.PhysicsCollide = nil
        end,
        [MINE_STATE_DEPLOY] = function()
            self:OpenHooks(true)
            self:UpdateLight(true, Color(0, 0, 255, 190))
            self:SetThink(self.SettleThink)
            self.PhysicsCollide = nil
            self:SetNextThink(CurTime() + 0.1)
        end,
        [MINE_STATE_ARMED] = function()
            self:UpdateLight(false, Color(0, 0, 0, 0))
            self:SetThink(self.SearchThink)
            self:SetNextThink(CurTime() + 0.1)
        end,
        [MINE_STATE_TRIGGERED] = function()
            self:OpenHooks()
            self:FrameAdvance()

            if self.pConstraint then
                self.pConstraint:Remove()
                self.pConstraint = nil
            end

            -- scare npcs
            sound.EmitHint(SOUND_DANGER, self:GetPos(), 300, 1, self)

            self.pWarnSound:ChangeVolume(0, 0.2)

            local vecNudge = Vector()
            vecNudge.x = math.Rand(-1, 1)
            vecNudge.y = math.Rand(-1, 1)
            vecNudge.z = 1.5
            vecNudge = vecNudge * 350

            local physobject = self:GetPhysicsObject()
            physobject:Wake()
            physobject:ApplyForceCenter(vecNudge)

            local x, y
            x = 10 + math.Rand(0, 20)
            y = 10 + math.Rand(0, 20)

            physobject:ApplyTorqueCenter(Vector(x, y, 0))

            self.flIgnoreWolrdTime = CurTime() + 1
            self:UpdateLight(true, Color(255, 0, 0, 190))

            if self.iModification == MINE_MODIFICATION_CAVERN then
                self:SetThink(self.CavernBounceThink)
                self:SetNextThink(CurTime() + 0.15)
            else
                self:SetThink(self.BounceThink)
                self:SetNextThink(CurTime() + 0.5)
            end
        end,
        [MINE_STATE_LAUNCHED] = function()
            self:SetThink(nil)
            self:SetNextThink(CurTime() + 0.5)
            self:UpdateLight(true, Color(255, 0, 0, 190))
            self.PhysicsCollide = self.ExplodeTouch
        end,
        default = function()
            MsgC(Color(255, 0, 0), string.format("**Unknown Mine State: %d\n", iState))
        end
    })
end

function ENT:Flip(vecForce, torque)
    if self.iFlipAttempts >= BOUNCEBOMB_MAX_FLIPS then
        self:SetThink(nil)
        return
    end

    self:EmitSound( "NPC_CombineMine.FlipOver" )

    local physobject = self:GetPhysicsObject()
    physobject:ApplyForceCenter(vecForce)
    physobject:ApplyTorqueCenter(torque)
    self.iFlipAttempts = self.iFlipAttempts + 1
end

MINE_MIN_PROXIMITY_SQR = 676 // 27 inches
function ENT:IsValidLocation()
    local avoidobj
    local avoidforce

    local tr = util.TraceLine({
        start = self:GetPos() + self:GetAngles():Up() * 2,
        endpos = self:GetPos() + self:GetAngles():Up() * -100,
        filter = self
    })

    if !tr.HitWorld then
        avoidobj = tr.Entity
        avoidforce = 120
    else
        for k, v in ipairs(ents.FindInPVS(self)) do
            if v:GetClass() == self:GetClass() and v != self then
                if self:GetPos():DistToSqr(v:GetPos()) < MINE_MIN_PROXIMITY_SQR then
                    avoidobj = v
                    avoidforce = 120
                    break
                end
            end
        end
    end

    if IsValid(avoidobj) then
        local vecForce = Vector(0, 0, self:GetPhysicsObject():GetMass() * 200)

        local vecDir = self:GetPos() - avoidobj:GetPos()
        vecDir.z = 0
        vecDir:Normalize()
        vecForce = vecDir * self:GetPhysicsObject():GetMass() * avoidforce

        self:Flip(vecForce, Vector(100, 0, 0))

        return false
    end

    return true
end

function ENT:BounceThink()
    self:SetNextThink(CurTime() + 0.1)
    self:FrameAdvance()

    local pPhysicsObject = self:GetPhysicsObject()

    if IsValid(pPhysicsObject) then
        local MINE_MAX_JUMP_HEIGHT = 200

        local tr = util.TraceLine({
            start = self:GetPos() + self:GetAngles():Up() * 2,
            endpos = self:GetPos() + self:GetAngles():Up() * MINE_MAX_JUMP_HEIGHT,
            mask = MASK_SHOT,
            filter = self,
            collisiongroup = COLLISION_GROUP_INTERACTIVE
        })

        local height

        if !tr.Entity:IsValidWorld() then
            height = MINE_MAX_JUMP_HEIGHT
        else
            height = tr.HitPos.z - self:GetPos().z
            height = height - BOUNCEBOMB_RADIUS
            if height < 0.1 then
                height = 0.1
            end
        end

        local time = math.sqrt(height / (0.5 * physenv.GetGravity():Length()))
        local velocity = physenv.GetGravity():Length() * time
        
        local force = velocity * pPhysicsObject:GetMass()

        local up = self:GetAngles():Up()

        pPhysicsObject:Wake()
        pPhysicsObject:ApplyForceCenter(up * force)

        pPhysicsObject:ApplyTorqueCenter(Vector(math.Rand(5, 25), math.Rand(5, 25), 0))

        if self.hNearestNPC then
            local vecPredict = self.hNearestNPC:GetVelocity()

            pPhysicsObject:ApplyForceCenter(vecPredict * 10)
        end

        self.PhysicsCollide = self.ExplodeTouch

        self:EmitSound("NPC_CombineMine.Hop")
        self:SetThink(nil)
    end
end

function ENT:CavernBounceThink()
    self:SetNextThink(CurTime() + 0.1)
    self:FrameAdvance()

    local pPhysicsObject = self:GetPhysicsObject()

    if IsValid(pPhysicsObject) then
        local MINE_MAX_JUMP_HEIGHT = 78

        local tr = util.TraceLine({
            start = self:GetPos() + self:GetAngles():Up() * 2,
            endpos = self:GetPos() + self:GetAngles():Up() * MINE_MAX_JUMP_HEIGHT,
            mask = MASK_SHOT,
            filter = self,
            collisiongroup = COLLISION_GROUP_INTERACTIVE
        })

        local height

        if !tr.Entity:IsValidWorld() then
            height = MINE_MAX_JUMP_HEIGHT
        else
            height = tr.HitPos.z - self:GetPos().z
            height = height - BOUNCEBOMB_RADIUS
            if height < 0.1 then
                height = 0.1
            end
        end

        local time = math.sqrt(height / (0.5 * physenv.GetGravity():Length()))
        local velocity = physenv.GetGravity():Length() * time
        
        local force = velocity * pPhysicsObject:GetMass()

        local up = self:GetAngles():Up()

        pPhysicsObject:Wake()
        pPhysicsObject:ApplyForceCenter(up * force)

        if self.hNearestNPC then
            local vecPredict = self.hNearestNPC:GetVelocity()

            pPhysicsObject:ApplyForceCenter(vecPredict * 10)
        end

        pPhysicsObject:ApplyTorqueCenter(Vector(math.Rand(5, 25), math.Rand(5, 25), 0))

        self.PhysicsCollide = self.ExplodeTouch

        self:EmitSound("NPC_CombineMine.Hop")
        self:SetThink(nil)
    end
end

function ENT:CaptiveThink()
    self:SetNextThink(CurTime() + 0.05)
    self:FrameAdvance()

    local phase = math.abs(math.sin(CurTime() * 4))
    phase = phase * BOUNCEBOMB_HOOK_RANGE
    self:SetPoseParameter(self.iAllHooks, phase)
    return
end

function ENT:SettleThink()
    self:SetNextThink(CurTime() + 0.05)
    self:FrameAdvance()

    if IsValid(self:GetParent()) then
        return
    end

    if !IsValid(self:GetPhysicsObject()) then
        self:PhysicsInit(SOLID_VPHYSICS)

        self:GetPhysicsObject():Wake()
    end

    if !self.bDisarmed then
        if self:GetPhysicsObject():IsAsleep() && !self:GetPhysicsObject():HasGameFlag(FVPHYSICS_PLAYER_HELD) then
            local tr = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos() + self:GetAngles():Up() * -16,
                mask = MASK_SHOT,
                filter = self,
                collisiongroup = COLLISION_GROUP_NONE
            })

            if !tr.HitWorld then
                local vecForce = Vector(0, 0, 2500)
                self:Flip(vecForce, Vector(60, 0, 0))
                return
            end

            if !self:IsValidLocation() then
                return
            end

            self.pConstraint = constraint.Ballsocket(game.GetWorld(), self, 0, 0, Vector(0, 0, 0), 0, 0, 0)
            self:CloseHooks()

            self:SetStatus(MINE_STATE_ARMED)
        end
    end
end

function ENT:UpdateLight(bTurnOn, col)
    self:SetNWBool("light", bTurnOn)

    self:SetNWVector("lightcolor", col:ToVector())
    self:SetNWInt("lightalpha", col.a)
end

function ENT:Wake(bAwake)
    if !self.pWarnSound then
        self.pWarnSound = CreateSound(self, "NPC_CombineMine.ActiveLoop")
        self.pWarnSound:Play()
        self.pWarnSound:ChangeVolume(1, 0)
        self.pWarnSound:ChangePitch(100, 0)
    end

    if bAwake then
        if self.bFoeNearest then
            self:EmitSound("NPC_CombineMine.TurnOn")
            self.pWarnSound:ChangeVolume(1, 0.1)
        end

        local r, g, b = 0, 0, 0

        if self.bFoeNearest then
            r = 255
        else
            g = 255
        end

        self:UpdateLight(true, Color(r, g, b, 190))
    else
        if self.bFoeNearest then
            self:EmitSound("NPC_CombineMine.TurnOff")
        end

        self.pWarnSound:ChangeVolume(0, 0.1)
        self:UpdateLight(false, Color(0, 0, 0, 0))
    end
    
    self.bAwake = bAwake
end

function ENT:FindNearestNPC()
    local flNearest = (BOUNCEBOMB_WARN_RADIUS * BOUNCEBOMB_WARN_RADIUS) + 1

    self.hNearestNPC = nil

    for k, v in ipairs(ents.GetAll()) do
        if v:IsNPC() or v:IsPlayer() then

            if v:Health() <= 0 then continue end

            if v:EyePos().z < self:GetPos().z then continue end

            if v.Classify and v:Classify() == CLASS_NONE then continue end

            if v.Classify and v:Classify() == CLASS_BULLSEYE then continue end

            local flDist = v:GetPos():DistToSqr(self:GetPos())

            if flDist < flNearest then
                if self:VisibleVec(v:LocalToWorld(v:OBBCenter())) then
                    flNearest = flDist
                    self.hNearestNPC = v
                end
            end
        end
    end

    if self.hNearestNPC then
        if self:IsFriend(self.hNearestNPC) then
            self:UpdateLight(true, Color(0, 255, 0, 190))
            self.bFoeNearest = false
        else    
            if !self.bFoeNearest then
                self:UpdateLight(true, Color(255, 0, 0, 190))
                self.bFoeNearest = true
            end
        end
    end

    return math.sqrt(flNearest)
end

function ENT:IsFriend(pEntity)
    if !pEntity then return end
    local classify = pEntity.Classify and pEntity:Classify()
    local bIsCombine = false

    local result = hook.Run("CombineMineIsFriend", self, pEntity)
    if result != nil then
        return result
    end

    if classify == CLASS_ZOMBIE || classify == CLASS_HEADCRAB || classify == CLASS_ANTLION then
        return false
    end

    if classify == CLASS_METROPOLICE || classify == CLASS_COMBINE || classify == CLASS_MILITARY || classify == CLASS_COMBINE_HUNTER || classify == CLASS_SCANNER then
        bIsCombine = true
    end

    if self.bPlacedByPlayer then
        return !bIsCombine
    else
        return bIsCombine
    end
end

function ENT:SearchThink()
    if table.IsEmpty(ents.FindInPVS(self)) then
        self:SetNextThink(CurTime() + 0.5)
        return
    end

    if GetConVar("ai_disabled"):GetBool() then
        if self.bAwake then
            self:Wake(false)
        end

        self:SetNextThink(CurTime() + 0.5)
        return
    end

    self:SetNextThink(CurTime() + 0.1)
    self:FrameAdvance()

    if self.pConstraint && CurTime() - self.flTimeGrabbed >= 1 then
        self:TriggerOutput("OnPulledUp", self.hPlayerGrabber)
        self:SetStatus(MINE_STATE_CAPTIVE)
        return
    end

    local flNearestNPCDist = self:FindNearestNPC()

    if flNearestNPCDist <= BOUNCEBOMB_WARN_RADIUS then
        if !self.bAwake then
            self:Wake(true)
        end
    else
        if self.bAwake then
            self:Wake(false)
        end
        return
    end

    if flNearestNPCDist <= BOUNCEBOMB_DETONATE_RADIUS && !self:IsFriend(self.hNearestNPC) then
        if self.bBounce then
            self:SetStatus(MINE_STATE_TRIGGERED)
        else
            self:SetThink(self.ExplodeThink)
            self:SetNextThink(CurTime() + self.flExplosionDelay)
        end
    end
end

function ENT:ExplodeTouch(data)
    local ent = data.HitEntity

    if self.bHeldByPhysgun then
        return
    end

    if ent:GetSolidFlags() == FSOLID_TRIGGER then
        return
    end

    if ent:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then
        return
    end

    self:ExplodeThink()
end

-- for some reason you cant stop the sound without setting the volume to 0, but you also cant stop it if you set the volume to zero in the same scope (or maybe frame? idk)
-- so i call changevolume in the explodethink and stop in the onremove function
function ENT:OnRemove()
    if self.pWarnSound then
        self.pWarnSound:Stop()
    end
end

function ENT:ExplodeThink()
    -- removed because it causes a "Changing collision rules within a callback is likely to cause crashes!" error in the console.
    -- it hasnt crashed the game for me before, but just to make sure.
    -- self:SetSolid(SOLID_NONE)

    self:UpdateLight(false, Color(0, 0, 0, 0))

    if self.pWarnSound then
        self.pWarnSound:ChangeVolume(0)
    end

    util.BlastDamage(self, self, self:GetPos(), BOUNCEBOMB_EXPLODE_RADIUS, BOUNCEBOMB_EXPLODE_RADIUS)

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    util.Effect("Explosion", effectdata)

    util.Decal("Scorch", self:GetPos(), self:GetPos() + Vector(0, 0, -32))

    self:Remove()
end

function ENT:OpenHooks(bSilent)
    if !bSilent then
        self:EmitSound("NPC_CombineMine.OpenHooks")
    end

    self:SetPoseParameter(self.iAllHooks, BOUNCEBOMB_HOOK_RANGE)
end

function ENT:CloseHooks()
    if !self.bLockSilently then
        self:EmitSound("NPC_CombineMine.CloseHooks")
    end

    self.bLockSilently = false

    self:SetPoseParameter(self.iAllHooks, 0)

    self.iFlipAttempts = 0
end

function ENT:InputDisarm(inputdata)
    if !self.bPlacedByPlayer && self:GetStatus() == MINE_STATE_ARMED then
        if self.pConstraint then
            self.pConstraint:Remove()
            self.pConstraint = nil
        end

        self.bDisarmed = true
        self:OpenHooks(false)

        self:SetStatus(MINE_STATE_DORMANT)
    end
end

-- hammer compatibility stuff
local KeyFields = {
    ["OnPulledUp"] = function(ent, value)
        ent:StoreOutput("OnPulledUp", value)
    end,
    ["bounce"] = function(ent, value)
        ent.bBounce = tobool(value)
    end,
    ["LockSilently"] = function(ent, value)
        ent.bLockSilently = tobool(value)
    end,
    ["StartDisarmed"] = function(ent, value)
        ent.bDisarmed = tobool(value)
    end,
    ["ExplosionDelay"] = function(ent, value)
        ent.flExplosionDelay = tonumber(value)
    end,
    ["Modification"] = function(ent, value)
        ent.iModification = tonumber(value)
    end,
    ["skin"] = function(ent, value)
        ent.iSkin = tonumber(value)
    end
}

function ENT:KeyValue(key, value)
    if KeyFields[key] then
        KeyFields[key](self, value)
    end
end

function ENT:AcceptInput(input, activator, caller, data)
    if input == "Disarm" then
        self:InputDisarm(data)
    end
end
-- end of compatibility stuff

function ENT:GetStatus()
    return self.iStatus
end

-- i could have just used self.Think = otherthink, however then i couldnt have done setnextthink
function ENT:Think()
    if self.CurThink then
        self:CurThink()
    end

    self:NextThink(self.NextT or CurTime())
    return true
end

function ENT:SetThink(func)
    self.CurThink = func
end

function ENT:SetNextThink(time)
    self.NextT = time
end

function switch(val, tab)
    if tab[val] then
        return tab[val]()
    else
        return tab.default()
    end
end