-- Recipe Statistics

RECIPE.name = "Axe"
RECIPE.model = "models/weapons/hl2meleepack/w_axe.mdl"
RECIPE.category = "Weapons"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_wooden_craftwork"] = 2,
    ["crafting_metal"] = 2,
    ["crafting_nails_screws"] = 1,
}

RECIPE.tools = {
    "crafting_adhesive",
}

RECIPE.results = {
    ["axe"] = 1,
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