-- Recipe Statistics

RECIPE.name = "Wooden Craftwork"
RECIPE.model = "models/props_debris/wood_board06a.mdl"
RECIPE.category = "Fabrication"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_wood"] = 4,
}

RECIPE.results = {
    ["crafting_wooden_craftwork"] = 1,
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