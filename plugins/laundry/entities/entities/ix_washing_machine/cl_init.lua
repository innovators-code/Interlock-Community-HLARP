include("shared.lua")

local PLUGIN = PLUGIN

local lightMat = Material("sprites/glow04_noz")
local colBlue, colGreen = Color(50, 50, 255), Color(50, 255, 50)

function ENT:Draw()

  	self:DrawModel()

	local position = self:GetPos()
	local angles = self:GetAngles()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

	local buttonLocation = position + f*25 + r*15 + u*6

	angles:RotateAroundAxis(angles:Up(), 90)
	angles:RotateAroundAxis(angles:Forward(), 90)

	render.SetMaterial(lightMat)
	if self:GetWashing() then
		render.DrawSprite(buttonLocation, 16, 16, colBlue)
	else
		render.DrawSprite(buttonLocation, 16, 16, colGreen)
	end
end