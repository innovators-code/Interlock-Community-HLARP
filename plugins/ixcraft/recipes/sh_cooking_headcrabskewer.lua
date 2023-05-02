-- Recipe Statistics

RECIPE.name = "Skewered Headcrab"
RECIPE.model = "models/willardnetworks/food/meatskewer.mdl"
RECIPE.category = "Cooking"

-- Recipe Configuration

RECIPE.requirements = {
    ["headcrab_raw"] = 1,
}

RECIPE.results = {
    ["headcrab_skewer"] = 1,
}

RECIPE.station = "ix_station_workbench"

-- Recipe Hooks

RECIPE:PostHook("OnCanCraft", function(recipeTable, ply)
    if ( recipeTable.station ) then
        for _, v in pairs(ents.FindByClass(recipeTable.station)) do
            if (ply:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
                return true
            end
        end

        return false, "You need to be near a workbench."
    end
end)