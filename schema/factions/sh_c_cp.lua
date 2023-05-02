FACTION.name = "Civil Protection"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150, 255)
FACTION.isDefault = false

FACTION.pay = 20
FACTION.payTime = 1800

FACTION.models = {
    "models/hla/police.mdl"
}

FACTION.weapons = {"rappel_gear"}

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

function FACTION:GetDefaultName(ply)
    return "c3:i4-RCT.TAGLINE-"..math.random(0,9), true
end

function FACTION:OnTransferred(ply)
    local char = ply:GetCharacter()

    char:SetName(self:GetDefaultName())
    char:SetModel(self.models[1])
end

function FACTION:OnCharacterCreated(ply, char)
    local inventory = char:GetInventory()

    inventory:Add("pistol", 1)
    inventory:Add("pistolammo", 2)
    inventory:Add("stunstick", 1)

    char:GiveMoney(150)
end

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(100)
    ply:SetMaxArmor(100)
end

FACTION_CP = FACTION.index
