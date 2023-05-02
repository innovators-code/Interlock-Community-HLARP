AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:SpawnFunction(ply, tr, cn)
	local ang = ply:GetAngles()
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,40))
	ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 90, 0))
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_basket001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	self:SetClothesNumber(0)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(act, cal)
	if ( ( cal.nextLaundryUse or 0) > CurTime() ) then return end
	cal.nextLaundryUse = CurTime() + 2
	if not ( cal:Team() == FACTION_UUA ) then return cal:Notify("You are not allowed to interact with this entity!") end

	if self:GetClothesNumber() >= PLUGIN.DirtyCartMaxCloth then return end

	local pos = self:LocalToWorld(self:OBBCenter())
	local ang = self:GetAngles()

	local cloth = ents.Create("ix_cloth")
	if not cloth:IsValid() then return end
	cloth:SetPos(pos + (ang:Up() * 30))
	cloth:SetAngles(self:GetAngles())
	if math.random(1, 4) == 4 then
		cloth:SetClothType(2)
	else
		cloth:SetClothType(1)
	end
	cloth:SetClean(false)
	cloth:Spawn()

	cloth.OnRemove = function()
		self:SetClothesNumber(self:GetClothesNumber() - 1)
	end

	self:SetClothesNumber(self:GetClothesNumber() + 1)
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if timer.Exists("AddClothTimer"..self:EntIndex()) then
		timer.Remove("AddClothTimer"..self:EntIndex())
	end
end
