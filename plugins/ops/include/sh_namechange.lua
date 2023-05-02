if SERVER then
    util.AddNetworkString("ixOpsNamechange")
    util.AddNetworkString("ixOpsDoNamechange")

    net.Receive("ixOpsDoNamechange", function(len, ply)
        if not ply.NameChangeForced then
            return
        end

        local charName = net.ReadString()

        local canUse, output = ix.util.CanUseName(charName)

        if not canUse then
            ply:Kick("Inappropriate roleplay name.")
            return
        end

        if not ( ply:GetCharacter() ) then return end

        ply:GetCharacter():SetName(output)
        ply:Notify("You have changed your name to "..output..".")

        ply.NameChangeForced = nil
    end)
else
    local nameChangeText = "You have been forced to change your name by a game moderator as it was deemed inappropriate.\nPlease change your name below to something more sutable.\nEXAMPLE: John Doe"
    net.Receive("ixOpsNamechange", function()
        local panel = vgui.Create("DFrame")
        panel:SetSize(500, 170)
        panel:SetTitle("helix")
        panel:Center()
        panel:ShowCloseButton(false)
        panel:MakePopup()

        local notice = vgui.Create("DLabel", panel)
        notice:SetPos(5, 30)
        notice:SetText(nameChangeText)
        notice:SizeToContents()

        local newName = vgui.Create("DLabel", panel)
        newName:SetPos(15, 85)
        newName:SetText("New name:")
        newName:SetFont("ixSmallFont")
        newName:SizeToContents()

        local entry = vgui.Create("DTextEntry", panel)
        entry:SetPos(15, 105)
        entry:SetSize(470, 20)

        local done = vgui.Create("DButton", panel)
        done:SetPos(15, 135)
        done:SetSize(80, 25)
        done:SetText("Done")

        function done:DoClick()
            local clear, rejectReason = ix.util.CanUseName(entry:GetValue())

            if not clear then
                Derma_Message(rejectReason, nil, "OK")
            else
                net.Start("ixOpsDoNamechange")
                net.WriteString(entry:GetValue())
                net.SendToServer()

                panel:Remove()
            end
        end
    end)
end

ix.command.Add("forcenamechange", {
    description = "Force changes the specified players name.",
    adminOnly = true,
    arguments = {ix.type.player},
    OnRun = function(self, ply, target)
        if ( target ) then
            net.Start("ixOpsNamechange")
            net.Send(target)

            target.NameChangeForced = true
            ply:Notify(target:Name().." has been forced name-changed.")
        else
            return ply:Notify("Could not find player.")
        end
    end
})