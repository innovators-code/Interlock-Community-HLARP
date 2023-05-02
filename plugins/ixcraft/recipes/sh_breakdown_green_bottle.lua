-- Recipe Statistics

RECIPE.name = "Empty Bottle"
RECIPE.model = "models/props_junk/GlassBottle01a.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_green_bottle"] = 1,
}

RECIPE.results = {
    ["crafting_glass"] = 4,
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