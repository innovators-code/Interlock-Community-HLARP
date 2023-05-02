local PLUGIN = PLUGIN

ITEM.name = "Manhack"
ITEM.model = "models/manhack.mdl"
ITEM.description = "A small robotic device, it has several sharp blades on it."
ITEM.category = "Tools"

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        PLUGIN:DeployManhack(ply)
    end
}
