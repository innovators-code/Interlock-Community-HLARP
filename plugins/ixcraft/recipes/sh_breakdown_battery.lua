-- Recipe Statistics

RECIPE.name = "Car Battery"
RECIPE.model = "models/Items/car_battery01.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_battery"] = 1,
}

RECIPE.results = {
    ["crafting_electronics"] = 1,
    ["crafting_refined_plastic"] = 2,
    ["crafting_nails_screws"] = 2,
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