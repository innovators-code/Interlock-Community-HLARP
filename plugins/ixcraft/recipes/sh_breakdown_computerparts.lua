-- Recipe Statistics

RECIPE.name = "Computer Parts"
RECIPE.model = "models/props_lab/harddrive02.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_computerparts"] = 1,
}

RECIPE.results = {
    ["junk_computer_tower"] = 1,
    ["crafting_refined_plastic"] = 2,
}

RECIPE.station = "ix_station_workbench"

-- Recipe Hooks

RECIPE:PostHook("OnCanCraft", function(recipeTable, ply)
    for _, v in pairs(ents.FindByClass(RECIPE.station)) do
        if (ply:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
            return true
        end
    end

    return false, "You need to be near a workbench."
end)