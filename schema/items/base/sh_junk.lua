-- Item Statistics

ITEM.name = "Junk Base"
ITEM.description = "Only used for Sorting."
ITEM.category = "Junk"

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
    if ( self.illegal ) then
        Schema:IllegalRow(tooltip)
    end
end