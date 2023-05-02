local PLUGIN = PLUGIN

PLUGIN.name = "Item collide fixer"
PLUGIN.description = "Stop killing server through item collisions bounds"
PLUGIN.author = "Bilwin"

PLUGIN.BlockedCollideEntities = {
    ["ix_item"] = true,
    ["ix_money"] = true,
    ["ix_shipment"] = true,
}

function PLUGIN:OnItemSpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:OnMoneySpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:OnShipmentSpawned(ent)
    ent:SetCustomCollisionCheck(true)
end

function PLUGIN:ShouldCollide(ent1, ent2)
    if ( self.BlockedCollideEntities[ent1:GetClass()] and self.BlockedCollideEntities[ent2:GetClass()] ) then
        return false
    end
end