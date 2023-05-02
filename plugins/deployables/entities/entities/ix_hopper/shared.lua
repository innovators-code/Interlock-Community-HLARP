if (SERVER) then
    AddCSLuaFile();
end;

local PLUGIN = PLUGIN;

local STATE_DORMANT        = 0; -- Off/passive
local STATE_DEPLOY         = 1; -- Initialize, try to lock down
local STATE_ARMED        = 2; -- Locked, looking for victims
local STATE_CAPTIVE     = 3; -- Put me down...
local STATE_TRIGGERED     = 4; -- Boom

local DETECT_DEPLOY     = Color(0, 0, 255, 190);
local DETECT_FRIENDLY     = Color(0, 255, 0, 190);
local DETECT_ENEMY         = Color(255, 0, 0, 190);

local DETECT_LOOKUP = {
    DETECT_DEPLOY,
    DETECT_FRIENDLY,
    DETECT_ENEMY
};

local BOUNCEBOMB_EXPLODE_RADIUS = 160;
local BOUNCEBOMB_WARN_RADIUS     = 250;
local BOUNCEBOMB_LAUNCH_RADIUS    = 150;

ENT.PrintName        = "Combine Mine";
ENT.Category        = "HL2RP";
ENT.Spawnable        = true;
ENT.AdminOnly        = true;
ENT.Model            = Model("models/props_combine/combine_mine01.mdl");
ENT.RenderGroup     = RENDERGROUP_BOTH;
ENT.Type            = "anim";
ENT.Base            = "base_anim";

if (SERVER) then

    function ENT:SpawnFunction( player, trace, class )
        if (!trace.Hit) then return; end;
        local entity = ents.Create(class);

        entity:SetPos(trace.HitPos + trace.HitNormal * 1.5);
        entity:Spawn();
        return entity;
    end;

    function ENT:SetupDataTables()
        self:NetworkVar("Int", 0, "State");
        self:NetworkVar("Int", 1, "LightState");
        self:NetworkVar("Bool", 0, "Latched");

        --self:NetworkVarNotify("State", self.UpdateState);
    end;

    --[[
    function ENT:UpdateState(varName, oldState, newState)
        if (newState == STATE_DEPLOY or newState == STATE_TRIGGERED or newState == STATE_DORMANT) then
            self:SetPoseParameter("blendstates", 65);
        elseif (newState == STATE_ARMED) then
            self:SetPoseParameter("blendstates", 0);
        end;
    end;
    ]]--

    function ENT:Initialize()
        self:SetModel(self.Model);
        self:SetSolid(SOLID_VPHYSICS);
        self:PhysicsInit(SOLID_VPHYSICS);
        self:SetState(STATE_DEPLOY);
        self:SetLightState(1);
        self:SetTrigger(true);
        self:SetUseType(SIMPLE_USE);
        self.latchGrace = CurTime() + 1;

        self.warnSound = CreateSound(self, "NPC_CombineMine.ActiveLoop");

        local phys = self:GetPhysicsObject();

        if (IsValid(phys)) then
            phys:Wake();
        end;
    end;

    function ENT:Latch()
        constraint.Weld(self, Entity(0), 0, 0, 0, false, false);
        self:SetState(STATE_ARMED);
        self:EmitSound("NPC_CombineMine.CloseHooks");
        self:GetPhysicsObject():EnableMotion(false);
    end;

    function ENT:UnLatch()
        constraint.RemoveConstraints(self, "Weld");
        self:EmitSound("NPC_CombineMine.OpenHooks");
        self:GetPhysicsObject():EnableMotion(true);
        self:GetPhysicsObject():ApplyForceCenter(VectorRand() * 20);
    end;

    function ENT:Enable()
        self:SetState(STATE_DEPLOY);
        self:SetLightState(1);
        self:EmitSound("NPC_CombineMine.TurnOn");
        self.latchGrace = CurTime() + 1;
    end;

    function ENT:Disable()
        self:UnLatch();
        self:SetState(STATE_DORMANT);
        self:SetLightState(0);
        self:EmitSound("NPC_CombineMine.TurnOff");
    end;

    function ENT:Flip()
        self:EmitSound("NPC_CombineMine.FlipOver");
        self:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, 2500));
        self:GetPhysicsObject():ApplyForceOffset(Vector(0, 0, 160), self:GetPos() + self:GetRight() * 10 + self:GetUp() * 5)
    end;

    function ENT:GetForce(targetPos, startPos, arrivalTime)
        local diff = targetPos - startPos;
        local velx = diff.x / arrivalTime;
        local vely = diff.y / arrivalTime;
        local velz = (diff.z - 0.5 * (-GetConVarNumber("sv_gravity")) * (arrivalTime ^ 2)) / arrivalTime;

        return Vector(velx, vely, velz);
    end;

    function ENT:Launch(target)
        self.explodeGrace = CurTime() + 1.1;
        self.warnSound:Stop();
        self:SetState(STATE_TRIGGERED);
        self:UnLatch();
        timer.Simple(0.45, function()
            if ( IsValid(self) ) then
                local vecPredict = target:GetVelocity();
                local arcForce = self:GetForce(target:GetPos() + vecPredict * 1.4, self:GetPos(), 1.4)

                self:EmitSound("NPC_CombineMine.Hop");
                 -- self:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, 4500));
                self:GetPhysicsObject():ApplyForceOffset(Vector(0, 0, 160), self:GetPos() + self:GetRight() * math.random(-5, 5) + self:GetForward() * math.random(-5, -5) - self:GetUp() * 5);
                self:GetPhysicsObject():SetVelocity(arcForce);
                --self:GetPhysicsObject():ApplyForceCenter(vecPredict * 11);

                self.explodeGrace = CurTime() + 0.5;
            end;
        end);
    end;

    function ENT:Explode()
        local pos = self:GetPos();
        local effect = EffectData();

        effect:SetOrigin(pos);
        util.Effect("Explosion", effect, true, true);

        util.BlastDamage(self, self.attacker or self, pos, BOUNCEBOMB_EXPLODE_RADIUS, 150);

        SafeRemoveEntity(self);
    end;

    function ENT:OnRemove()
        self.warnSound:Stop();
    end;

    -- This one triggers for entities
    function ENT:Touch()
        if (self:GetState() == STATE_TRIGGERED and !self.exploding) then
            self.exploding = true;
            self:Explode();
        end;
    end;

    -- This one doesn't trigger for entities, but detects map brushes???
    function ENT:PhysicsCollide()
        if (self:GetState() == STATE_TRIGGERED and !self.exploding and CurTime() >= (self.explodeGrace or 0)) then
            self.exploding = true;
            self:Explode();
        end;
    end;

    function ENT:Think()
        local state = self:GetState();

        if (state == STATE_ARMED) then
            local nearestEnt = self:FindClosest();

            if (!IsValid(nearestEnt)) then
                self:SetLightState(0);

                if (self.on) then
                    self:EmitSound("NPC_CombineMine.TurnOff");
                    self.on = false;
                end;

                self.warnSound:ChangeVolume(0, 0.1);
            else
                if (self:IsFriend(nearestEnt)) then
                    self:SetLightState(2);
                else
                    if (!self.on) then
                        self:EmitSound("NPC_CombineMine.TurnOn");
                        self.on = true;
                    end;

                    if (!self.warnSound:IsPlaying()) then
                        self.warnSound:Play();
                    end;

                    self.warnSound:ChangeVolume(0.7, 0.1);

                    self:SetLightState(3);

                    if (nearestEnt:GetPos():Distance(self:GetPos()) <= BOUNCEBOMB_LAUNCH_RADIUS) then
                        self:SetState(STATE_TRIGGERED);
                        self:Launch(nearestEnt);
                    end;
                end;
            end;
            self:NextThink(CurTime());

            return true;
        elseif (state == STATE_DEPLOY) then
            local groundTrace = util.QuickTrace(self:GetPos(), self:GetUp() * -5, self);

            self:SetLightState(1)

            if (groundTrace.Hit) then
                if (self:GetVelocity():Length() <= 10 and CurTime() >= self.latchGrace) then
                    self:Latch();
                    self:SetState(STATE_ARMED);
                end;
            else
                if (CurTime() > (self.nextBounce or 0) and self:GetVelocity():Length() <= 5) then
                    self.nextBounce = CurTime() + 2.5;
                    self:Flip();
                end;
            end;
        end;
    end;

    function ENT:FindClosest()
        local nearest = false;

        for k, v in pairs(ents.FindInSphere(self:GetPos(), BOUNCEBOMB_WARN_RADIUS)) do
            if (v:IsNPC()) then
                if (v:Health() > 0) then

                    if (v:GetNoDraw()) then
                        continue;
                    end;

                    if (v:EyePos().z < self:GetPos().z) then
                        continue;
                    end;

                    if (v:Classify() == CLASS_NONE) then
                        continue;
                    end;

                    if (v:Classify() == CLASS_BULLSEYE) then
                        continue;
                    end;

                    if (v:GetClass() == "npc_turret_ground" or v:GetClass() == "npc_turret_floor") then
                        continue;
                    end;

                    if (!nearest or v:GetPos():Distance(self:GetPos()) < nearest:GetPos():Distance(self:GetPos())) then
                        if (v:Visible(self)) then
                            nearest = v;
                        end;
                    end;
                end;
            elseif (v:IsPlayer()) then
                if (v:Alive()) then

                    if (v:GetNoDraw()) then
                        continue;
                    end;

                    if (v:EyePos().z < self:GetPos().z) then
                        continue;
                    end;

                    if (!nearest or v:GetPos():Distance(self:GetPos()) < nearest:GetPos():Distance(self:GetPos())) then
                        if (v:Visible(self)) then
                            nearest = v;
                        end;
                    end;
                end;
            end;
        end;

        return nearest;
    end;


    function ENT:Use( activator, caller, type, value )
        if (activator:IsCombine()) then
            if (self:GetState() == STATE_DORMANT) then
                self:Enable()
            elseif (self:GetState() == STATE_ARMED) then
                self:Disable();
            end;
        end;
    end;

    function ENT:IsFriend( entity )
        if (entity:IsNPC()) then
            local classify = entity:Classify();

            -- Unconditional enemies to combine and Player.
            if (classify == CLASS_ZOMBIE or classify == CLASS_HEADCRAB or classify == CLASS_ANTLION) then
                return false;
            end;

            if (classify == CLASS_METROPOLICE or classify == CLASS_COMBINE or classify == CLASS_MILITARY or classify == CLASS_COMBINE_HUNTER or classify == CLASS_SCANNER) then
                return true;
            end;
        elseif (entity:IsPlayer()) then
            return (entity:IsCombine());
        else
            return false;
        end;
    end;

    function PLUGIN:GravGunOnPickedUp(player, ent)
        if (ent:GetClass() == "ix_hopper") then
            if (ent:GetState() != STATE_TRIGGERED) then
                ent:SetLightState(0);
                ent.warnSound:Stop();

                if (ent:GetState() == STATE_ARMED) then
                    timer.Simple(0.3, function()
                        if (IsValid(ent)) then
                            ent:SetState(STATE_CAPTIVE);
                            ent:SetLightState(1);
                            ent.warnSound:Stop();
                            ent:UnLatch();
                        end;
                    end);
                elseif (ent:GetState() == STATE_DEPLOY) then
                    ent:SetState(STATE_CAPTIVE);
                    ent:SetLightState(1);
                    ent.warnSound:Stop();
                end;
            end;
        end;
    end;

    function PLUGIN:GravGunOnDropped(player, ent)
        if (ent:GetClass() == "ix_hopper" and ent:GetState() != STATE_TRIGGERED) then
            ent:SetState(STATE_DEPLOY);
            ent.latchGrace = CurTime() + 1;
        end;
    end;

    function PLUGIN:GravGunPunt(player, ent)
        if (ent:GetClass() == "ix_hopper" and ent:GetState() == STATE_CAPTIVE) then
            ent:SetState(STATE_TRIGGERED);
            ent.attacker = player;
        end;
    end;

    function PLUGIN:KeyPress(player, key)
        if (IsValid(player) and IsValid(player:GetActiveWeapon())) then
            if (player:GetActiveWeapon():GetClass() == "weapon_physcannon") then
                if (key == IN_ATTACK2) then
                    local eyeEnt = player:GetEyeTrace().Entity

                    if (IsValid(eyeEnt) and eyeEnt:GetClass() == "ix_hopper") then
                        if (eyeEnt:GetPos():Distance(player:EyePos()) <= 260) then
                            eyeEnt:GetPhysicsObject():EnableMotion(true);
                        end;
                    end;
                end;
            end;
        end;
    end;

elseif (CLIENT) then
    local sprite = CreateMaterial("mineGlow", "UnlitGeneric", {
        ["$basetexture"] = "sprites/glow01",
        ["$basetexturetransform"] = "center 0 0 scale 1 1 rotate 0 translate 0 0",
        ["$model"] = 0,
        ["$additive"] = 1,
        ["$nolod"] = 1,
        ["$translucent"] = 0,
        ["$vertexcolor"] = 1
    });

    function ENT:Initialize()
        self:SetSolid(SOLID_VPHYSICS);
        self:SetPoseParameter("blendstates", 65);
    end;

    function ENT:Draw()
        local state = self:GetDTInt(0);
        local lightState = self:GetDTInt(1);
        local spriteColor = DETECT_LOOKUP[lightState] != 0 and DETECT_LOOKUP[lightState] or false;

        if (state == STATE_TRIGGERED) then
            spriteColor = DETECT_ENEMY;
        end;

        self:DrawModel();

        if (state > 0 and spriteColor) then
            render.SetMaterial(sprite);
            render.DrawSprite(self:GetPos() + self:GetUp() * 10, 20, 20, spriteColor);
        end;
    end;

    function ENT:Think()
        local state = self:GetDTInt(0) or STATE_DEPLOY;

        if (state == STATE_DEPLOY or state == STATE_TRIGGERED) then
            self:SetPoseParameter("blendstates", 65);
        elseif (state == STATE_ARMED) then
            self:SetPoseParameter("blendstates", 0);
        elseif (state == STATE_CAPTIVE) then
            local sine = math.abs(math.sin(CurTime() * 4)) * 65

            self:SetPoseParameter("blendstates", sine);
        else
            self:SetPoseParameter("blendstates", 65);
        end;
    end;
end;