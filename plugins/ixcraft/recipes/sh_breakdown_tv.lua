-- Recipe Statistics

RECIPE.name = "Broken TV Monitor"
RECIPE.model = "models/props_lab/monitor01b.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_tv"] = 1,
}

RECIPE.results = {
    ["crafting_reshaped_metal"] = 2,
    ["crafting_electronics"] = 1,
    ["crafting_glass"] = 1,
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