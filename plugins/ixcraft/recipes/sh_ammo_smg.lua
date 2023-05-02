-- Recipe Statistics

RECIPE.name = "4.6x30mm SMG Bullets"
RECIPE.model = "models/Items/BoxMRounds.mdl"
RECIPE.category = "Ammunition"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_gunpowder"] = 1,
    ["crafting_charcoal"] = 2,
    ["crafting_metal"] = 4,
}

RECIPE.results = {
    ["smg1ammo"] = 1,
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