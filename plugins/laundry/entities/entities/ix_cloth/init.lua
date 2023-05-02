AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:SpawnFunction(ply, tr, cn)
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	if math.random(1, 4) == 4 then
		ent:SetClothType(2)
	else 
		ent:SetClothType(1)
	end
	ent:SetClean(false)
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_newspaper001a.mdl")

	if not self:GetClean() then
		self:SetMaterial("models/props_pipes/GutterMetal01a")
	else
		self:SetMaterial("models/debug/debugwhite")
	end

	if self:GetClothType() == 1 then
		self:SetColor(Color(255,125,0))
	elseif self:GetClothType() == 2 then
		self:SetColor(Color(0,50,255))
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
