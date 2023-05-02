local PLUGIN = PLUGIN

ITEM.name = "Hopper Mine"
ITEM.model = "models/props_combine/combine_mine01.mdl"
ITEM.description = "A powerful, compact mine, utilizing pneumatically-powered legs to propel itself at nearby personnel."
ITEM.category = "Tools"

ITEM.functions.Deploy = {
    icon = "icon16/wrench.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()
        PLUGIN:DeployHopper(ply)
    end
}
