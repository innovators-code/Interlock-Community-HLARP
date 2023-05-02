ITEM.name = "Suppressor (USP)"
ITEM.description = "A suppressor for your USP."
ITEM.category = "Tools"
ITEM.model = "models/props_lab/box01a.mdl"

ITEM:Hook("drop", function(item)
    local ply = item.player

    if ( ply:HasWeapon("ix_usp") ) then
        if ( ply:GetWeapon("ix_usp"):HasAttachment("suppressor") ) then
            ply:GetWeapon("ix_usp"):TakeAttachment("suppressor")
        end
    end
end)

ITEM.functions.eqp = {
    name = "Equip",
    tip = "Equip the suppressor.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_usp") ) then return false end
        
        if not ( ply:GetWeapon("ix_usp"):HasAttachment("suppressor") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_usp"):GiveAttachment("suppressor")

        return false
    end
}

ITEM.functions.uneqp = {
    name = "Un-Equip",
    tip = "Un-Equip the suppressor.",
    icon = "icon16/wrench.png",
    OnCanRun = function(item)
        local ply = item.player

        if not ( ply:HasWeapon("ix_usp") ) then return false end
        
        if ( ply:GetWeapon("ix_usp"):HasAttachment("suppressor") ) then
            return true
        end

        return false
    end,
    OnRun = function(item)
        local ply = item.player
        
        ply:EmitSound("physics/metal/weapon_footstep2.wav")
        ply:GetWeapon("ix_usp"):TakeAttachment("suppressor")

        return false
    end
}