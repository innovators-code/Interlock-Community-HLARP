-- Recipe Statistics

RECIPE.name = "H&K USP Match"
RECIPE.model = "models/weapons/w_pistol.mdl"
RECIPE.category = "Weapons"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_weapon_parts"] = 2,
    ["crafting_refined_plastic"] = 4,
    ["crafting_nails_screws"] = 2,
}

RECIPE.tools = {
    "crafting_adhesive",
}

RECIPE.results = {
    ["pistol"] = 1,
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