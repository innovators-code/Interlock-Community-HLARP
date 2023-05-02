-- Recipe Statistics

RECIPE.name = "Old Tire"
RECIPE.model = "models/props_vehicles/carparts_tire01a.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_tire"] = 1,
}

RECIPE.results = {
    ["crafting_rubber_synthetic"] = 4,
    ["crafting_metal"] = 1,
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