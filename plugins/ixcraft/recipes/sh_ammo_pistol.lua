-- Recipe Statistics

RECIPE.name = "9x19mm Pistol Bullets"
RECIPE.model = "models/Items/BoxSRounds.mdl"
RECIPE.category = "Ammunition"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_gunpowder"] = 1,
    ["crafting_charcoal"] = 1,
    ["crafting_metal"] = 2,
}

RECIPE.results = {
    ["pistolammo"] = 1,
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