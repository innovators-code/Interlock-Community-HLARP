-- Recipe Statistics

RECIPE.name = "Sharpened Pickaxe"
RECIPE.model = "models/weapons/hl2meleepack/w_pickaxe.mdl"
RECIPE.category = "Sharpening"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_metalore"] = 1,
    ["pickaxe_blunt"] = 1,
}

RECIPE.results = {
    ["pickaxe"] = 1,
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