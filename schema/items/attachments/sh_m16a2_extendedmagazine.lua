ITEM.name = "Extended Magazine (M16A2)"
ITEM.description = "A large magazine with a capacity of 30 rounds, specially designed for the M16A2."
ITEM.category = "Tools"
ITEM.model = "models/props_lab/box01a.mdl"

ITEM:Hook("drop", function(item)
    local ply = item.player

    if ( ply:HasWeapon("ix_m16a2") ) then
        if ( ply:GetWeapon("ix_m16a2"):HasAttachment("extendedmagazine") ) then
            ply:GetWeapon("ix_m16a2"):TakeAttachment("extendedmagazine")
        end
    end
end)

ITEM.functions.eqp = {
    name = "Equip",
    tip = "Equip the extended magazine.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_m16a2") ) then return false end
        
        if not ( ply:GetWeapon("ix_m16a2"):HasAttachment("extendedmagazine") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_m16a2"):GiveAttachment("extendedmagazine")

        return false
    end
}

ITEM.functions.uneqp = {
    name = "Un-Equip",
    tip = "Un-Equip the extended magazine.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_m16a2") ) then return false end
        
        if ( ply:GetWeapon("ix_m16a2"):HasAttachment("extendedmagazine") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_m16a2"):TakeAttachment("extendedmagazine")

        return false
    end
}