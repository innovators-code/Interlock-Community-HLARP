local PLUGIN = PLUGIN

PLUGIN.name = "Ammo Crate"
PLUGIN.description = "Self-Explanatory. Just a ammo crate."
PLUGIN.author = "Skay"

if ( SERVER ) then
    function PLUGIN:SaveAmmoCrates()
        local data = {}
    
        for _, v in ipairs(ents.FindByClass("ix_ammocrate")) do
            data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
        end
    
        ix.data.Set("ammoCrates", data)
    end

    function PLUGIN:LoadTerminals()
        for _, v in ipairs(ix.data.Get("ammoCrates") or {}) do
            local ammoCrate = ents.Create("ix_ammocrate")
    
            ammoCrate:SetPos(v[1])
            ammoCrate:SetAngles(v[2])
            ammoCrate:SetModel(v[3])
            ammoCrate:Spawn()
        end
    end
end