AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local PLUGIN = PLUGIN

function ENT:SpawnFunction(ply, tr, cn)
  local ang = ply:GetAngles()
  local ent = ents.Create(cn)
  ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0, 0, 60))
  ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 180, 0))
  ent:Spawn()

  return ent
end

function ENT:Initialize()
  self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
 
  local phys = self:GetPhysicsObject()
  if (phys:IsValid()) then
    phys:Wake()
  end
end

function ENT:Think()
  local pos = self:LocalToWorld(self:OBBCenter())
  local ang = self:GetAngles()
  ang:RotateAroundAxis(ang:Up(), 90)
  ang:RotateAroundAxis(ang:Forward(), 90)

  for _, ent in pairs(ents.FindInSphere(pos + (ang:Up() * 20) - (ang:Right() * 9), 20)) do
    if ent:GetClass() == "ix_cloth" and not self:GetWashing() then
      if not ent:GetClean() then
        self:SetClothType(ent:GetClothType())
        self:SetWashing(true)
        self:SetWashState(PLUGIN.WashTime)
        ent:Remove()
      end
    end
  end

  self:NextThink(CurTime())
  return true
end

function ENT:OnWash(ent, name, ov, nv)
  if timer.Exists("WashTimer" .. self:EntIndex()) then return end

  timer.Create("WashTimer" .. self:EntIndex(), 1, PLUGIN.WashTime, function()
    self:SetWashState(self:GetWashState() - 1)

    timer.Simple(1, function()
      if self:IsValid() then
        self:EmitSound("plats/elevator_stop1.wav")
      end
    end)

    if self:GetWashState() == 0 then
      self:SetWashing(false)
      timer.Remove("WashTimer"..self:EntIndex())

      local pos = self:LocalToWorld(self:OBBCenter())
      local ang = self:GetAngles()

      ang:RotateAroundAxis(ang:Up(), 90)
      ang:RotateAroundAxis(ang:Forward(), 90)

      local cloth = ents.Create("ix_cloth")
      if not cloth:IsValid() then return end
      cloth:SetPos(pos + (ang:Up() * 25))
      cloth:SetAngles(self:GetAngles())
      cloth:SetClothType(self:GetClothType())
      cloth:SetClean(true)
      cloth:Spawn()
      
      self:EmitSound("plats/elevbell1.wav")
    else
      self:EmitSound("plats/elevator_start1.wav", SNDLVL_60Db)
      self:EmitSound("plats/elevator_move_loop2.wav", SNDLVL_60Db)
    end
  end)
end

function ENT:OnRemove()
  if timer.Exists("WashTimer" .. self:EntIndex()) then
    timer.Remove("WashTimer" .. self:EntIndex())
  end
  if timer.Exists("WashSoundTimer" .. self:EntIndex()) then
    timer.Remove("WashSoundTimer" .. self:EntIndex())
  end
end
