-- Item Statistics

ITEM.name = "Minimal-Tier Citizen Ration"
ITEM.description = "A brown shrink-wrapped packet containing some food and money."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/weapons/w_packati.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs({"proc_paste", "drink_breen_water", "junk_ration"}) do
            if not ( char:GetInventory():Add(v) ) then
                ix.item.Spawn(v, ply)
            end
        end

        char:GiveMoney(25)
        ply:EmitSound("interlock/craft/fabric/"..math.random(1,6)..".wav", nil, nil, 0.35)
    end
}
