--[[
    Helix Plugin made by Ghost
    https://steamcommunity.com/id/GhostL0L
--]]

ITEM.name = "Book"
ITEM.description = "A regular looking book."
ITEM.category = "Literature"
ITEM.model = "models/props_lab/binderbluelabel.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.invWidth = 1
ITEM.invHeight = 1
ITEM.weight = 0.4

ITEM.functions.Read = {
    name = "Read",
    tip = "Allows you to read the book.",
    icon = "icon16/book.png",
    OnRun = function(itemTable)
        local client = itemTable.player

        netstream.Start(client, "ixBook", itemTable.name, itemTable.text or "")        
        return false
    end
}