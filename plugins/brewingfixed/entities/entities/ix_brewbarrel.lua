local PLUGIN = PLUGIN

AddCSLuaFile()

ENT.PrintName = "Brewing Barrel"
ENT.Author = "Who cares"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Type = "anim"

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    
    timer.Simple(0.1, function()
        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            phys:Wake()
        end
    end)
end

