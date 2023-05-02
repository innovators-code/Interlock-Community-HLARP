local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Clean Laundry Cart"
ENT.Author = "The workshop dude."
ENT.Category = "IX:HLA RP ( Laundry )"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ClothesNumber")
end
