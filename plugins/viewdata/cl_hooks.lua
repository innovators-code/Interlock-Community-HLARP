net.Receive("ixViewDataOpen", function(len, ply)
    local target = net.ReadEntity()
    local cid = net.ReadUInt(32)
    local data = net.ReadTable()
    local status = net.ReadString()

    if not ( target ) then return end

    print(status)

    ix.gui.record = vgui.Create("ixCombineViewData")
    ix.gui.record:Build(target, cid, data, status)
end)