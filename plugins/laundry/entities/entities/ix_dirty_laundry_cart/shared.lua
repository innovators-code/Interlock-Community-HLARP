local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Dirty Laundry Cart"
ENT.Author = "The workshop dude."
ENT.Category = "IX:HLA RP ( Laundry )"
ENT.Contact = "none"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ClothesNumber")
end
