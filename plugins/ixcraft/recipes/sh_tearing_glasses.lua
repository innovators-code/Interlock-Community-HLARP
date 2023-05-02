-- Recipe Statistics

RECIPE.name = "Glasses"
RECIPE.model = "models/willardnetworks/clothingitems/glasses.mdl"
RECIPE.category = "Tearing"

-- Recipe Configuration

RECIPE.requirements = {
    ["glasses"] = 1,
}

RECIPE.results = {
    ["crafting_refined_plastic"] = 2,
    ["crafting_glass"] = 2,
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