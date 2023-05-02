-- Recipe Statistics

RECIPE.name = "Soviet Filter"
RECIPE.model = "models/willardnetworks/props/sovietfilter.mdl"
RECIPE.category = "Tailoring"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_charcoal_refill"] = 1,
    ["crafting_refined_plastic"] = 4,
}

RECIPE.tools = {
    "crafting_adhesive",
}

RECIPE.results = {
    ["tool_sovietfilter"] = 1,
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