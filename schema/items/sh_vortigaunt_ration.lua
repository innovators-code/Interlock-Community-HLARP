-- Item Statistics

ITEM.name = "Standard Biotic Ration"
ITEM.description = "A green shrink-wrapped packet containing some bizarre food and barely money."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/weapons/w_packatb.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.functions.Open = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        for k, v in ipairs({"headcrab_skewer", "xen_concoctionq", "junk_ration"}) do
            if not ( char:GetInventory():Add(v) ) then
                ix.item.Spawn(v, ply)
            end
        end

        char:GiveMoney(5)
        ply:EmitSound("interlock/craft/fabric/"..math.random(1,6)..".wav", nil, nil, 0.35)
    end
}
