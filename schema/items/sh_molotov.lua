-- Item Statistics

ITEM.name = "Molotov"
ITEM.description = "A Bottle filled with cocktail that emits fire when broken."
ITEM.category = "Weapons"

-- Item Configuration

ITEM.model = "models/props_junk/glassbottle01a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 2

-- Item Functions

ITEM.functions.throw = {
    name = "Grab",
    OnRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_molotov") ) then
            ply:Give("ix_molotov")
            ply:SelectWeapon("ix_molotov")
        else
            ply:Notify("You already have a Molotov!")

            return false
        end
    end
}