local PLUGIN = PLUGIN

ix.command.Add("staffmanager", {
    description = "Opens the staff manager tool.",
    superAdminOnly = true,
    OnRun = function(self, ply)
        ix.ops.staffManager.Open(ply)
    end
})

ix.chat.Register("adminchat", {
    font = "ixMediumFont",
    prefix = {"/AC", "/AdminChat"},
    description = "A super-secret chatroom for staff members.",
    indicator = "chatPerforming",
    deadCanChat = true,
    CanHear = function(self, ply, listener)
        return listener:IsAdmin()
    end,
    CanSay = function(self, ply)
        return ply:IsAdmin()
    end,
    OnChatAdd = function(self, ply, text)
        chat.AddText(ix.config.Get("color"), "[ADMIN CHAT]", team.GetColor(ply:Team()), " ("..ply:Nick()..") ", ix.config.Get("color"), ply:SteamName(), color_white, ": "..text)
    end,
})