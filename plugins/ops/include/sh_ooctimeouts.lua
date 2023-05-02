local PLUGIN = PLUGIN

ix.command.Add("BanOOC", {
    description = "Ban a player from typing in OOC chat.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        target:SetNetVar("ixOOCBanned", true)
        target:Notify("You have been banned from OOC chat.")
        ply:Notify("You have banned "..target:SteamName().." from OOC chat.")
    end
})

ix.command.Add("UnBanOOC", {
    description = "Unban a player from typing in OOC chat.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        target:SetNetVar("ixOOCBanned", nil)
        target:Notify("You have been unbanned from OOC chat.")
        ply:Notify("You have unbanned "..target:SteamName().." from OOC chat.")
    end
})