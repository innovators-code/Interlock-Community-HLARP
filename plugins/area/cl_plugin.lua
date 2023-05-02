
local PLUGIN = PLUGIN

function PLUGIN:GetPlayerAreaTrace()
    local ply = LocalPlayer()

    return util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetForward() * 96,
        filter = ply
    })
end

function PLUGIN:StartEditing()
    ix.area.bEditing = true
    self.editStart = nil
    self.editProperties = nil
end

function PLUGIN:StopEditing()
    ix.area.bEditing = false

    if (IsValid(ix.gui.areaEdit)) then
        ix.gui.areaEdit:Remove()
    end
end
