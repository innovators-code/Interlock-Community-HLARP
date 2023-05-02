-- Item Statistics

ITEM.name = "Crafting Components Base"
ITEM.description = "Only used for Sorting."
ITEM.category = "Crafting Components"

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
    if ( self.illegal ) then
        Schema:IllegalRow(tooltip)
    end
end