local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.PrintName = "Brew Barrel"
ENT.Author = "Who cares"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Type = "anim"

if ( SERVER ) then
    function ENT:SetupDataTables()
        self:NetworkVar("Bool", 0, "Used")
    end

    function ENT:Initialize()
        self:SetModel("models/props_c17/oildrum001.mdl")
        self:PhysicsInit(SOLID_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        
        timer.Simple(0.1, function()
            local phys = self:GetPhysicsObject()
            
            if IsValid(phys) then
                phys:Wake()
            end
        end)
    end
    
    function ENT:SpawnFunction(ply, tr)
        
        local ent = ents.Create("ix_brewingbarrel")
        ent:SetPos(tr.HitPos)
        ent:Spawn() 
        
        return ent
    end

    function ENT:Use(ply, call)
        net.Start("ixBrewingMenu")
        net.Send(ply)      
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end

