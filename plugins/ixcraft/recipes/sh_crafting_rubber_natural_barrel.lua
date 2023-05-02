-- Recipe Statistics

RECIPE.name = "Barrel of Natural Rubber"
RECIPE.model = "models/props_c17/oildrum001.mdl"
RECIPE.category = "Crafting"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_rubber_natural"] = 12,
}

RECIPE.results = {
    ["crafting_rubber_natural_barrel"] = 1,
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