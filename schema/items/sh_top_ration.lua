-- Item Statistics

ITEM.name = "Priority-Tier Citizen Ration"
ITEM.description = "A yellow shrink-wrapped packet containing some food and money."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/weapons/w_packatp.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs({"comfort_beef", "comfort_sandwich", "comfort_sandwich", "drink_premium_water", "ccasanitypills", "junk_ration"}) do
            if not ( char:GetInventory():Add(v) ) then
                ix.item.Spawn(v, ply)
            end
        end

        char:GiveMoney(100)
        ply:EmitSound("interlock/craft/fabric/"..math.random(1,6)..".wav", nil, nil, 0.35)
    end
}
