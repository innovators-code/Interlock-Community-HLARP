AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Loot Container"
ENT.Author = "Riggs.mackay"
ENT.Category = "IX:HLA RP"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ContainerClass")
end

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/props_junk/wood_crate001a.mdl")
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

        local entity = ents.Create("ix_loot_container")
        entity:SetPos(trace.HitPos)
        entity:SetAngles(Angle(0, (entity:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        entity:Spawn()
        entity:Activate()

        Schema:SaveLootContainers()
        return entity
    end
    
    function ENT:Use(ply, call)
        local char = ply:GetCharacter()
        local inv = char:GetInventory()
        local loot = ix.loot.containers[self:GetContainerClass()]

        if not ( loot ) then return end

        if ( ( self.ixNextSearch or 0 ) < CurTime() ) then
            local lootTime = loot.lootTime

            if ( istable(lootTime) ) then
                lootTime = lootTime[math.random(1, #lootTime)]
            end

            loot.onStart(ply, self)
            ply:SetAction("Looting", lootTime)
            ply:DoStaredAction(self, function()
                local char = ply:GetCharacter()
                local inv = char:GetInventory()
                local maxItems = 1

                if ( math.random(1, 10) == 1 ) then
                    maxItems = math.random(1, #loot.maxItems)
                end

                for i = 1, maxItems do
                    local item = loot.items[math.random(1, #loot.items)]
                    if ( loot.rareItems and istable(loot.rareItems) ) and ( math.random(1, 10) == 1 ) then
                        item = loot.rareItems[math.random(1, #loot.rareItems)]
                    end

                    if not ( inv:Add(item, amount) ) then
                        ix.item.Spawn(v, self)
                    end
                end
            end, lootTime)

            timer.Simple(lootTime, function()
                if ( IsValid(self) ) then
                    loot.onEnd(ply, self)
                end
            end)

            self.ixNextSearch = CurTime() + loot.delay
        else
            ply:Notify("You must wait before you can search this container again.")
        end
    end
end