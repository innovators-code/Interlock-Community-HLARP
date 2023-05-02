-- Recipe Statistics

RECIPE.name = "Supplements"
RECIPE.model = "models/props_lab/jar01b.mdl"
RECIPE.category = "Cooking"

-- Recipe Configuration

RECIPE.requirements = {
    ["fruit_watermelon"] = 2,
}

RECIPE.results = {
    ["supplements"] = 1,
}

RECIPE.station = nil

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