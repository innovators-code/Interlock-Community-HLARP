-- Recipe Statistics

RECIPE.name = "Blue Kevlar Uniform"
RECIPE.model = "models/willardnetworks/clothingitems/torso_rebel_torso_2.mdl"
RECIPE.category = "Tearing"

-- Recipe Configuration

RECIPE.requirements = {
    ["torso_blue_kevlar"] = 1,
}

RECIPE.results = {
    ["crafting_stiched_cloth"] = 5,
    ["crafting_reshaped_metal"] = 3,
    ["crafting_fabric"] = 1,
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