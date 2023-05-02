-- Recipe Statistics

RECIPE.name = "Suitcase"
RECIPE.model = "models/weapons/w_suitcase_passenger.mdl"
RECIPE.category = "Tearing"

-- Recipe Configuration

RECIPE.requirements = {
    ["suitcase"] = 1,
}

RECIPE.results = {
    ["crafting_stiched_cloth"] = 4,
    ["crafting_metal"] = 2,
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