-- Item Statistics

ITEM.name = "Watermelon"
ITEM.description = "A large, round, green fruit. Rather pink inside!"
ITEM.category = "Food"
ITEM.model = "models/willardnetworks/food/watermelon_unbreakable.mdl"

-- Item Inventory Size Configuration

ITEM.width = 2
ITEM.height = 2

-- Item Custom Configuration

ITEM.useTime = 3
ITEM.useSound = "interlock/player/eat.ogg"
ITEM.RestoreHunger = 50
ITEM.spoil = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Cut",
    icon = "icon16/wrench.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ( ply:HasItem("tool_knife") ) ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player

        ply:SetAction("Cutting "..itemTable.name.."..", 6, function()
            ply:GetCharacter():GetInventory():Add("fruit_watermelon_half", 2)
        end)
    end
}