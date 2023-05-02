-- Recipe Statistics

RECIPE.name = "Roasted Antlion Meat"
RECIPE.model = "models/willardnetworks/food/cooked_alienmeat.mdl"
RECIPE.category = "Cooking"

-- Recipe Configuration

RECIPE.requirements = {
    ["antlion_raw"] = 1,
}

RECIPE.results = {
    ["antlion_roast"] = 1,
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
