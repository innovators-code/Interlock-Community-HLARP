local PLUGIN = PLUGIN

net.Receive("ixCinematicMessage", function()
    local title = net.ReadString()

    ix.ops.cinematicIntro = true
    ix.ops.cinematicTitle = title
end)