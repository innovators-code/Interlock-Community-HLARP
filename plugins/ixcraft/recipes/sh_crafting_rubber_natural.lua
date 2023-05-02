-- Recipe Statistics

RECIPE.name = "Jar of Natural Rubber"
RECIPE.model = "models/willardnetworks/props/scrap.mdl"
RECIPE.category = "Crafting"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_rubber_natural_barrel"] = 1,
}

RECIPE.results = {
    ["crafting_rubber_natural"] = 12,
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