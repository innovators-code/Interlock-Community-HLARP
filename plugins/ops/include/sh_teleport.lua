if SERVER then
    function opsGoto(ply, pos)
        ply:ExitVehicle()
        if not ply:Alive() then ply:Spawn() end

        ply:SetPos(ix.util.FindEmptyPos(pos, {ply}, 600, 30, Vector(16, 16, 64)))
    end

    function opsBring(ply, target)
        local hasPhysgun = false
        local wep = target:GetActiveWeapon()

        if not target:IsBot() and wep and IsValid(wep) and wep:GetClass() == "weapon_physgun" and target:KeyDown(IN_ATTACK) then
            target:ConCommand("-attack")
            target:GetActiveWeapon():Remove()
            hasPhysgun = true
        end

        if hasPhysgun then
            timer.Simple(0.5, function() 
                if IsValid(target) and target:Alive() then
                    target:Give("weapon_physgun")
                    target:SelectWeapon("weapon_physgun")
                end
            end)
        end

        target.lastPos = target:GetPos()
        opsGoto(target, ply:GetPos())
    end
end

ix.command.Add("goto", {
    description = "Teleports yourself to the player specified.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) and ( ply != target ) then
            opsGoto(ply, target:GetPos())
            ply:Notify("You have teleported to "..target:Name().."'s position.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})

ix.command.Add("bring", {
    description = "Teleports the player specified to your location.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) and ( ply != target ) then
            if not target:Alive() then
                target:Spawn()
                target:Notify("You have been respawned by a game moderator.")
                ply:Notify("Target was dead, automatically respawned.")
            end

            opsBring(ply, target)
            ply:Notify(target:Name().." has been brought to your position.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})

ix.command.Add("return", {
    description = "Returns the player specified to their last location.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) and ( ply != target ) then
            if ( target.lastPos ) then
                if not ( target:Alive() ) then
                    return ply:Notify("Player is dead.")
                end
                
                opsGoto(target, target.lastPos)
                target.lastPos = nil
                ply:Notify(target:Name().." has been returned.")
            else
                return ply:Notify("No old position to return the player to.")
            end
        else
            return ply:Notify("Could not find player.")
        end
    end
})