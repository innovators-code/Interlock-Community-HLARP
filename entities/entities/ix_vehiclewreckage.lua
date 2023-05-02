AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Vehicle Wreckage"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP (Loot)"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:GetEntityMenu(ply)
    local options = {}
    
    options["Loot"] = true
    options["Siphon"] = true

    return options
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel(table.Random({
            "models/props_vehicles/car003b_physics.mdl",
            "models/props_vehicles/car004b_physics.mdl",
            "models/props_vehicles/car001a_hatchback.mdl",
        }))
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

        local entity = ents.Create("ix_vehiclewreckage")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveWreckages()
        return entity
    end

    function ENT:OnRemove()
        if not ( ix.shuttingDown ) then
            Schema:SaveWreckages()
        end
    end
else
    ENT.PopulateEntityInfo = true

    function ENT:OnPopulateEntityInfo(container)
        local name = container:AddRow("name")
        name:SetImportant()
        name:SetText("Vehicle Wreckage")
        name:SizeToContents()
    end
end