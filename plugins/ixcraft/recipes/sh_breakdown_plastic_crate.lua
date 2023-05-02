-- Recipe Statistics

RECIPE.name = "Plastic Crate"
RECIPE.model = "models/props_junk/PlasticCrate01a.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_plastic_crate"] = 1,
}

RECIPE.results = {
    ["crafting_plastic"] = 3,
    ["crafting_refined_plastic"] = 1,
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