-- Recipe Statistics

RECIPE.name = "Refrigerator Door"
RECIPE.model = "models/props_interiors/refrigeratordoor02a.mdl"
RECIPE.category = "Breakdown"

-- Recipe Configuration

RECIPE.requirements = {
    ["junk_fridge_door"] = 1,
}

RECIPE.results = {
    ["crafting_metal"] = 3,
    ["crafting_reshaped_metal"] = 1,
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