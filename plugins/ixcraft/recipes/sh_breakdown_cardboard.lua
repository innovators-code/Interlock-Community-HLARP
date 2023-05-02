-- Recipe Statistics

RECIPE.name = "Cardboard Box"
RECIPE.model = "models/props_junk/cardboard_box003a.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_cardboard"] = 1,
}

RECIPE.results = {
    ["crafting_plastic"] = 2,
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