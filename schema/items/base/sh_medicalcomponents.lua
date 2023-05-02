-- Item Statistics

ITEM.name = "Medical Components Base"
ITEM.description = "Only used for Sorting."
ITEM.category = "Medical Components"

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
    if ( self.illegal ) then
        Schema:IllegalRow(tooltip)
    end
end