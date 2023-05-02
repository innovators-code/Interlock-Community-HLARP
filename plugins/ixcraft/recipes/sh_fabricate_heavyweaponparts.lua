-- Recipe Statistics

RECIPE.name = "Heavy Weapon Parts"
RECIPE.model = "models/willardnetworks/skills/weaponparts.mdl"
RECIPE.category = "Fabrication"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_refined_metal"] = 3,
}

RECIPE.tools = {
    "tool_screwdriver",
}

RECIPE.results = {
    ["crafting_heavy_weapon_parts"] = 1,
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