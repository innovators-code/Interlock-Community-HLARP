-- Item Statistics

ITEM.name = "Attachments Base"
ITEM.description = "Only used for Sorting."
ITEM.category = "Weapon Attachments"

-- Item Functions

function ITEM:PopulateTooltip(tooltip)
    if ( self.illegal ) then
        Schema:IllegalRow(tooltip)
    end
end