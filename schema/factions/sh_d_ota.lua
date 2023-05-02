FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "The military force of the Universal Union."
FACTION.color = Color(200, 0, 0)
FACTION.isDefault = false

FACTION.pay = 60
FACTION.payTime = 1500

FACTION.models = {
    "models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl"
}

FACTION.weapons = {"rappel_gear"}

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

function FACTION:GetDefaultName(ply)
    return "OTA:c3.TAGLINE-"..math.random(0,9), true
end

function FACTION:OnTransferred(ply)
    local char = ply:GetCharacter()

    char:SetName(self:GetDefaultName())
    char:SetModel(self.models[1])
end

function FACTION:OnCharacterCreated(ply, char)
    local inventory = char:GetInventory()

    inventory:Add("pulse_smg", 1)
    inventory:Add("ar2ammo", 2)

    char:GiveMoney(200)
end

FACTION_OTA = FACTION.index
