-- Recipe Statistics

RECIPE.name = "Molotov Cocktail"
RECIPE.model = "models/props_junk/glassbottle01a.mdl"
RECIPE.category = "Weapons"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_green_bottle"] = 1,
    ["crafting_cloth"] = 2,
    ["crafting_fueltube"] = 2,
}

RECIPE.results = {
    ["molotov"] = 1,
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