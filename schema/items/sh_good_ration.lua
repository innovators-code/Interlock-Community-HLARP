-- Item Statistics

ITEM.name = "Support-Tier Citizen Ration"
ITEM.description = "A red shrink-wrapped packet containing some food and money."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/weapons/w_packatl.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs({"baking_bread", "comfort_sandwich", "drink_sparkling_water", "antidep", "junk_ration"}) do
            if not ( char:GetInventory():Add(v) ) then
                ix.item.Spawn(v, ply)
            end
        end

        char:GiveMoney(75)
        ply:EmitSound("interlock/craft/fabric/"..math.random(1,6)..".wav", nil, nil, 0.35)
    end
}
