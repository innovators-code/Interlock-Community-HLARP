local PLAYER = FindMetaTable("Player")

function PLAYER:IsIncognito()
    return self:GetNetVar("ixIncognito", false)
end

ix.command.Add("incognitotoggle", {
    description = "Toggles incognito mode. DO NOT USE FOR LONG PERIODS.",
    adminOnly = true,
    OnRun = function(self, ply)
        ply:SetNetVar("ixIncognito", !ply:IsIncognito(), true)

        if ply:IsIncognito() then
            ply:Notify("You have entered incognito mode. Please go back to normal mode as soon as you can.")
        else
            ply:Notify("You have exited incognito mode.")
        end
    end
})