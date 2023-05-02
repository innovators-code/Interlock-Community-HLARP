-- Recipe Statistics

RECIPE.name = "12g Buckshot Shotgun Shells"
RECIPE.model = "models/Items/BoxBuckshot.mdl"
RECIPE.category = "Ammunition"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_gunpowder"] = 2,
    ["crafting_charcoal"] = 3,
    ["crafting_metal"] = 5,
}

RECIPE.results = {
    ["shotgunammo"] = 1,
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