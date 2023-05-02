-- Item Statistics

ITEM.name = "Tools Base"
ITEM.description = "Only used for Sorting."
ITEM.category = "Tools"

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
    if ( self.illegal ) then
        Schema:IllegalRow(tooltip)
    end
end