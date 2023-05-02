
function PLUGIN:LoadData()
    hook.Run("SetupAreaProperties")
    ix.area.stored = self:GetData() or {}

    timer.Create("ixAreaThink", ix.config.Get("areaTickTime"), 0, function()
        self:AreaThink()
    end)
end

function PLUGIN:SaveData()
    self:SetData(ix.area.stored)
end

function PLUGIN:PlayerInitialSpawn(ply)
    timer.Simple(1, function()
        if (IsValid(ply)) then
            local json = util.TableToJSON(ix.area.stored)
            local compressed = util.Compress(json)
            local length = compressed:len()

            net.Start("ixAreaSync")
                net.WriteUInt(length, 32)
                net.WriteData(compressed, length)
            net.Send(ply)
        end
    end)
end

function PLUGIN:PlayerLoadedCharacter(ply)
    ply.ixArea = ""
    ply.ixInArea = nil
end

function PLUGIN:PlayerSpawn(ply)
    ply.ixArea = ""
    ply.ixInArea = nil
end

function PLUGIN:AreaThink()
    for _, ply in ipairs(player.GetAll()) do
        local character = ply:GetCharacter()

        if (!ply:Alive() or !character) then
            continue
        end

        local overlappingBoxes = {}
        local position = ply:GetPos() + ply:OBBCenter()

        for id, info in pairs(ix.area.stored) do
            if (position:WithinAABox(info.startPosition, info.endPosition)) then
                overlappingBoxes[#overlappingBoxes + 1] = id
            end
        end

        if (#overlappingBoxes > 0) then
            local oldID = ply:GetArea()
            local id = overlappingBoxes[1]

            if (oldID != id) then
                hook.Run("OnPlayerAreaChanged", ply, ply.ixArea, id)
                ply.ixArea = id
            end

            ply.ixInArea = true
        else
            ply.ixInArea = false
        end
    end
end

function PLUGIN:OnPlayerAreaChanged(ply, oldID, newID)
    net.Start("ixAreaChanged")
        net.WriteString(oldID)
        net.WriteString(newID)
    net.Send(ply)
end

net.Receive("ixAreaAdd", function(length, ply)
    if (!ply:Alive() or !CAMI.PlayerHasAccess(ply, "Helix - AreaEdit", nil)) then
        return
    end

    local id = net.ReadString()
    local type = net.ReadString()
    local startPosition, endPosition = net.ReadVector(), net.ReadVector()
    local properties = net.ReadTable()

    if (!ix.area.types[type]) then
        ply:NotifyLocalized("areaInvalidType")
        return
    end

    if (ix.area.stored[id]) then
        ply:NotifyLocalized("areaAlreadyExists")
        return
    end

    for k, v in pairs(properties) do
        if (!isstring(k) or !ix.area.properties[k]) then
            continue
        end

        properties[k] = ix.util.SanitizeType(ix.area.properties[k].type, v)
    end

    ix.area.Create(id, type, startPosition, endPosition, nil, properties)
    ix.log.Add(ply, "areaAdd", id)
end)

net.Receive("ixAreaRemove", function(length, ply)
    if (!ply:Alive() or !CAMI.PlayerHasAccess(ply, "Helix - AreaEdit", nil)) then
        return
    end

    local id = net.ReadString()

    if (!ix.area.stored[id]) then
        ply:NotifyLocalized("areaDoesntExist")
        return
    end

    ix.area.Remove(id)
    ix.log.Add(ply, "areaRemove", id)
end)
