-- Recipe Statistics

RECIPE.name = "Light Weapon Parts"
RECIPE.model = "models/willardnetworks/skills/weaponparts.mdl"
RECIPE.category = "Fabrication"

-- Recipe Configuration

RECIPE.requirements = {
    ["crafting_reshaped_metal"] = 2,
}

RECIPE.tools = {
    "crafting_adhesive",
}

RECIPE.results = {
    ["crafting_weapon_parts"] = 1,
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