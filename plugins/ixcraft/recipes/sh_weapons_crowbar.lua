-- Recipe Statistics

RECIPE.name = "Crowbar"
RECIPE.model = "models/weapons/w_crowbar.mdl"
RECIPE.category = "Weapons"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_metal"] = 5,
    ["crafting_nails_screws"] = 1,
}

RECIPE.results = {
    ["crowbar"] = 1,
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