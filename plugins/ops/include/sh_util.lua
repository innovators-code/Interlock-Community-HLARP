if SERVER then
    util.AddNetworkString("opsGiveWarn")
    util.AddNetworkString("opsGetRecord")
end

ix.command.Add("sethp", {
    description = "Sets health of the specified player.",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.number,
    },
    OnRun = function(self, ply, target, hp)
        if ( target ) then
            target:SetHealth(hp)
            ply:Notify("You have set "..target:Nick().."'s health to "..hp..".")

            if ( target == ply ) then
                for v,k in pairs(player.GetAll()) do
                    if k:IsSuperAdmin() then
                        k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." set their health to "..hp..".")
                    end
                end
            end
        else
            return ply:Notify("Could not find player.")
        end
    end
})

ix.command.Add("kick", {
    description = "Kicks the specified player from the server.",
    adminOnly = true,
    arguments = {
        ix.type.player,
        ix.type.string,
    },
    OnRun = function(self, ply, target, reason)
        if ( reason == "" ) then
            reason = nil
        end

        if ( target ) and ( ply != target ) then
            ply:Notify("You have kicked "..target:Name().." from the server.")
            target:Kick(reason or "Kicked by a game moderator.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})