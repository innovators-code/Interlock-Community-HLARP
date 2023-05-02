ix.command.Add("respawn", {
    description = "Respawns the player specified.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) then
            target:Spawn()
            target:Notify("You have been respawned by a game moderator.")
            ply:Notify(target:Name().." has been respawned.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})