-- Recipe Statistics

RECIPE.name = "Charcoal Filter"
RECIPE.model = "models/willardnetworks/props/charcoal.mdl"
RECIPE.category = "Fabrication"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_stiched_cloth"] = 2,
    ["crafting_charcoal"] = 1,
}

RECIPE.results = {
    ["crafting_charcoal_refill"] = 1,
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