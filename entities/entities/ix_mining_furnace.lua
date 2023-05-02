AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Mining Furnace"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP (Mining)"
--TODO: onUse panel(?) or something that grants the user the ability to choose the outcome of the smelting;
--TODO: includes changing up smelting of metal ore -> metal ingot to wood -> charcoal and alike.

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/willard/work/furnace3.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
            phys:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local angles = ply:GetAngles()

        local entity = ents.Create("ix_mining_furnace")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveMiningEntities()
        return entity
    end

    function ENT:Use(ply, caller)
        local char = ply:GetCharacter()
        if ( ply:IsPlayer() and ply:GetEyeTraceNoCursor().Entity == self ) then
            if ( ply:HasItem("crafting_metalore") ) then
                if not ( ply:HasItem("crafting_wood") ) then
                    ply:Notify("You need at least 1 wood to smelt the metal ore.")
                    return
                end

                self:EmitSound("ambient/fire/ignite.wav", 80)
                self:EmitSound("ambient/fire/fire_med_loop1.wav", 80)
                char:GetInventory():HasItem("crafting_wood"):Remove()
                ply:SetAction("Smelting...", 10, function()
                    self:StopSound("ambient/fire/fire_med_loop1.wav")
                    self:EmitSound("ambient/fire/mtov_flame2.wav", 80)
                    ix.item.Spawn( "crafting_metalingot", self:GetPos() + self:GetUp() * 53 )
                end)
            else
                ply:Notify("You need metal ore to smelt.")
            end
        end
    end
end
