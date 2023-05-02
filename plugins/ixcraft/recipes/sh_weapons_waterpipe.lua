-- Recipe Statistics

RECIPE.name = "Waterpipe Shotgun"
RECIPE.model = "models/weapons/darky_m/rust/w_waterpipe.mdl"
RECIPE.category = "Weapons"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_weapon_parts"] = 1,
    ["crafting_metal"] = 4,
}

RECIPE.tools = {
    "crafting_adhesive",
}

RECIPE.results = {
    ["waterpipeshotgun"] = 1,
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
