-- Item Statistics

ITEM.name = "Halved Bread"
ITEM.description = "Half a loaf of bread ready to be consumed."
ITEM.category = "Food"
ITEM.model = "models/willardnetworks/food/bread_half.mdl"

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.iconCam = {
    pos = Vector(258.35, 217.47, 159.76),
    ang = Angle(25.14, 219.92, 0),
    fov = 1.49,
}

-- Item Custom Configuration

ITEM.useTime = 3
ITEM.useSound = "interlock/player/eat.ogg"
ITEM.RestoreHunger = 10
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
            ply:GetCharacter():GetInventory():Add("baking_bread_slice", 2)
        end)
    end
}