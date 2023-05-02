-- Item Statistics

ITEM.name = "Whole Bread"
ITEM.description = "Even in times such as these, homemade bread can make all the difference."
ITEM.category = "Food"
ITEM.model = "models/willardnetworks/food/bread_loaf.mdl"

-- Item Inventory Size Configuration

ITEM.width = 2
ITEM.height = 1

ITEM.iconCam = {
    pos = Vector(258.35, 217.47, 159.76),
    ang = Angle(25.18, 220.07, 0),
    fov = 2.39,
}

-- Item Custom Configuration

ITEM.useTime = 3
ITEM.useSound = "interlock/player/eat.ogg"
ITEM.RestoreHunger = 20
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
            ply:GetCharacter():GetInventory():Add("baking_bread_half", 2)
        end)
    end
}