FACTION.name = "Conscript Force"
FACTION.description = "The Conscript Force is a group of trained soldiers who have been given a chance to fight for the Universal Union, mainly in the outlands."
FACTION.color = Color(0, 100, 0, 255)
FACTION.isDefault = false

FACTION.pay = 15
FACTION.payTime = 1800

FACTION.models = {
    "models/player/urban.mdl" -- temporary
}

FACTION.weapons = {"rappel_gear"}

--function FACTION:GetDefaultName(ply)
    --return "c17:i4-RCT.TAGLINE-"..math.random(0,9), true
--end

function FACTION:OnTransferred(ply)
    local char = ply:GetCharacter()

    char:SetName(self:GetDefaultName())
    char:SetModel(self.models[1])
end

function FACTION:OnCharacterCreated(ply, char)
    local inventory = char:GetInventory()

    inventory:Add("stunstick", 1)

    char:GiveMoney(50)
end

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(100)
    ply:SetMaxArmor(100)
end

FACTION_CONSCRIPT = FACTION.index