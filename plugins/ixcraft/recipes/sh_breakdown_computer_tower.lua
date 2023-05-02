-- Recipe Statistics

RECIPE.name = "Broken Computer Tower"
RECIPE.model = "models/props_lab/harddrive01.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_computer_tower"] = 1,
}

RECIPE.results = {
    ["crafting_electronics"] = 2,
    ["crafting_metal"] = 1,
    ["crafting_refined_plastic"] = 2,
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