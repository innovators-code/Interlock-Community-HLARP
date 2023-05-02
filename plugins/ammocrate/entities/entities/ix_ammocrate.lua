AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ammo Crate"
ENT.Author = "Skay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

local ammo = {
    ["AR2"] = {
        item = "ar2ammo",
        max = "300"
    },
    ["Pistol"] = {
        item = "pistolammo",
        max = "50"
    },
    ["357"] = {
        item = "357ammo",
        max = "24"
    },
    ["Buckshot"] = {
        item = "shotgunammo",
        max = "32"
    },
    ["SMG1"] = {
        item = "smg1ammo",
        max = "200"
    }
}

if ( SERVER ) then
    util.AddNetworkString("OpenCrate")
    util.AddNetworkString("CloseCrate")
    util.AddNetworkString("SupplyCrate")
    
    net.Receive("SupplyCrate", function(len, ply)
        local ent = net.ReadEntity()
        local amount = net.ReadString()
        local weapon = ply:GetActiveWeapon()

        if ( !IsValid( weapon ) ) then return end

        timer.Simple(1, function()
            if ( !IsValid( ent ) ) then return end
            if ( !IsValid( ply ) ) then return end
            if ( !ply:Alive() ) then return end

            ent:EmitSound("items/ammo_pickup.wav")
            ply:EmitSound("items/ammo_pickup.wav")
            ply:SetAmmo(amount, weapon:GetPrimaryAmmoType())
        end)

        if ( ( ent.animationCooldown or 0 ) > CurTime() ) then return end
        if not ( IsValid(ent) ) then return end
        ent:ResetSequence("open")
        ent:EmitSound("items/ammocrate_open.wav")
        timer.Simple(2, function()
            ent:ResetSequence("close")
            ent:EmitSound("items/ammocrate_close.wav")
        end)
        ent.animationCooldown = CurTime() + 3
    end)
    
    function ENT:Initialize()
        self:SetModel(Model("models/Items/ammocrate_smg1.mdl"))
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

        local entity = ents.Create("ix_ammocrate")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()
        
        return entity
    end
    
    function ENT:Use(ply)
        if ( IsValid(self) ) then
            if ( ( self.nextopen or 0 ) > CurTime() ) then return end
            if not ( ammo[game.GetAmmoName(ply:GetActiveWeapon():GetPrimaryAmmoType())] ) then
                ply:Notify("You aren't holding a weapon that has the type of ammunition inside the box.")
                return
            else
                net.Start("OpenCrate")
                    net.WriteEntity(self)
                net.Send(ply)
            end
            self.nextopen = CurTime() + 3
        end
    end
else
    net.Receive("OpenCrate", function(len)
        local ent = net.ReadEntity()
        local ply = LocalPlayer()
        local s = ammo[game.GetAmmoName(ply:GetActiveWeapon():GetPrimaryAmmoType())]
        
        Derma_StringRequest("Ammunition", "Amount of ammo you want", s.max, function(amount)
            amount = tonumber(amount)
            if ( isnumber(amount) ) then 
                if ( amount > tonumber(s.max) ) then
                    ply:Notify("You can't have more than "..s.max.." of this type of ammo.")
                    return
                end
                
                net.Start("SupplyCrate")
                    net.WriteEntity(ent)
                    net.WriteString(amount)
                net.SendToServer()
            else
                ply:Notify("You must enter a number.")
                return
            end
        end)
    end)
end