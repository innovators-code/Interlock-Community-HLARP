-- Item Statistics

ITEM.name = "Unregistered Ration"
ITEM.description = "A shrink-wrapped packet containing some food. It is grey-colored and has no branding."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/weapons/w_packate.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Functions

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs({"proc_nutrient_bar", "drink_breen_water", "junk_ration"}) do
            if not ( char:GetInventory():Add(v) ) then
                ix.item.Spawn(v, ply)
            end
        end

        char:GiveMoney(0)
        ply:EmitSound("interlock/craft/fabric/"..math.random(1,6)..".wav", nil, nil, 0.35)
    end
}
