ix.command.Add("cleanup", {
    description = "Removes all the props of the specified player.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) then
            ix.ops.cleanupPlayer(target)

            target:Notify("Your props have been removed by a game moderator ("..ply:SteamName()..").")
            ply:Notify("You have cleaned up "..target:Nick().."'s props.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})

ix.command.Add("cleanupall", {
    description = "Cleans up ALL props on the server. (optional) countdown argument (in seconds)",
    adminOnly = true,
    arguments = {bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, ply, countdown)
        if DOING_CLEANUP and countdown then
            return ply:Notify("A cleanup is already queued.")
        end

        if countdown and tonumber(countdown) and tonumber(countdown) > 0 then
            countdown = math.Clamp(math.floor(tonumber(countdown)), 40, 600)
            local countdownEnd = CurTime() + countdown
            local r = countdown / 10
            local left = countdown

            DOING_CLEANUP = true
            timer.Create("ixOpsCleanupClock", 10, r, function()
                left = left - 10

                if left == 0 then
                    ix.ops.cleanupAll()

                    for v,k in pairs(player.GetAll()) do
                        k:Notify("Your props have been removed due to a server cleanup.")
                    end

                    DOING_CLEANUP = nil
                else
                    for v,k in pairs(player.GetAll()) do
                        k:Notify("WARNING: All props will be cleaned up in "..left.." seconds.")
                    end
                end
            end)

            for v,k in pairs(player.GetAll()) do
                k:Notify("WARNING: All props will be cleaned up in "..countdown.." seconds.")
            end

            ply:Notify("Cleanup countdown for "..countdown.." seconds has started.")
        else
            ix.ops.cleanupAll()

            for v,k in pairs(player.GetAll()) do
                k:Notify("Your props have been removed due to a server cleanup.")
            end
        end
    end
})

ix.command.Add("cleardecals", {
    description = "Clears all decals on the server.",
    adminOnly = true,
    OnRun = function(self, ply)
        ix.ops.clearDecals()
        ply:Notify("You have cleared all the decals on the map.")
    end
})