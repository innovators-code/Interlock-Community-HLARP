ITEM.name = "Laser Sight (MK23)"
ITEM.description = "A laser sight for your MK23."
ITEM.category = "Tools"
ITEM.model = "models/props_lab/box01a.mdl"

ITEM:Hook("drop", function(item)
    local ply = item.player

    if ( ply:HasWeapon("ix_mk23") ) then
        if ( ply:GetWeapon("ix_mk23"):HasAttachment("laser") ) then
            ply:GetWeapon("ix_mk23"):TakeAttachment("laser")
            ply:GetWeapon("ix_mk23"):TakeAttachment("suppressor")
        end
    end
end)

ITEM.functions.eqp = {
    name = "Equip",
    tip = "Equip the laser sight.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_mk23") ) then return false end
        
        if not ( ply:GetWeapon("ix_mk23"):HasAttachment("laser") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_mk23"):GiveAttachment("laser")

        return false
    end
}

ITEM.functions.uneqp = {
    name = "Un-Equip",
    tip = "Un-Equip the laser.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_mk23") ) then return false end
        
        if ( ply:GetWeapon("ix_mk23"):HasAttachment("laser") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_mk23"):TakeAttachment("laser")

        return false
    end
}