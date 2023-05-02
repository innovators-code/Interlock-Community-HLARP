FACTION.name = "Citizen"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(150, 125, 100, 255)
FACTION.isDefault = true

FACTION.models = {
    "models/willardnetworks/citizens/male01.mdl",
    "models/willardnetworks/citizens/male02.mdl",
    "models/willardnetworks/citizens/male03.mdl",
    "models/willardnetworks/citizens/male04.mdl",
    "models/willardnetworks/citizens/male05.mdl",
    "models/willardnetworks/citizens/male06.mdl",
    "models/willardnetworks/citizens/male07.mdl",
    "models/willardnetworks/citizens/male08.mdl",
    "models/willardnetworks/citizens/male09.mdl",
    "models/willardnetworks/citizens/male10.mdl",

    "models/willardnetworks/citizens/female_01.mdl",
    "models/willardnetworks/citizens/female_02.mdl",
    "models/willardnetworks/citizens/female_03.mdl",
    "models/willardnetworks/citizens/female_04.mdl",
    "models/willardnetworks/citizens/female_06.mdl",
    "models/willardnetworks/citizens/female_07.mdl",
}

function FACTION:OnCharacterCreated(ply, char)
    local id = ix.util.ZeroNumber(math.random(1, 99999), 5)
    local inventory = char:GetInventory()

    char:SetData("ixIdentification", id)

    inventory:Add("suitcase", 1)
    inventory:Add("correct_ration", 1)
    inventory:Add("coupon", 1, {
        name = char:GetName(),
        id = id,
        city = char:GetRelocation(),
    })

    char:GiveMoney(100)

	local x, y, id = inventory:Add( "torso_blue_shirt" )

	if ( x ) then
		local item = inventory:GetItemAt( x, y )

		item:SetData( "equip", true )
	end

	x, y, id = inventory:Add( "legs_blue_pants" )

	if ( x ) then
		local item = inventory:GetItemAt( x, y )

		item:SetData( "equip", true )
	end

	char:SetData( "groups", { [ 2 ] = 1, [ 3 ] = 1 } )
end

function FACTION:OnSpawn(ply)
    ply:SetHealth(100)
    ply:SetMaxHealth(100)
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
end

FACTION_CITIZEN = FACTION.index
