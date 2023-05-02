-- Recipe Statistics

RECIPE.name = "Broken Lamp"
RECIPE.model = "models/props_lab/desklamp01.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_lamp"] = 1,
}

RECIPE.results = {
    ["crafting_plastic"] = 3,
    ["crafting_nails_screws"] = 1,
    ["crafting_glass"] = 2,
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