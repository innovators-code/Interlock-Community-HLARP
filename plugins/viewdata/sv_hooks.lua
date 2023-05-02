local PLUGIN = PLUGIN

util.AddNetworkString("ixViewDataAction")
util.AddNetworkString("ixViewDataPoints")
util.AddNetworkString("ixViewDataStatus")
util.AddNetworkString("ixViewDataOpen")

-- Called when a player adds a new row to a data file.
function PLUGIN:AddRow(data)
    if not ( data.title or data.creator ) then
        return
    end

    data.record.rows[#data.record.rows + 1] = {
        title = data.title,
        creator = data.creator,
        points = data.points or 0,
    }

    return data.record
end

-- Called when a player removes a row from a data file.
function PLUGIN:RemoveRow(data)
    if not ( data.index ) then return end

    if ( data.record.rows[data.index] ) then
        data.record.rows[data.index] = nil
    end

    return data.record
end

-- Called when a player edits a row in a data file.
function PLUGIN:EditRow(data)
    if not ( data.title or data.index ) then return end

    if ( data.record.rows[data.index] ) then
        data.record.rows[data.index] = {
            title = data.title,
            creator = data.creator,
            points = data.points or 0,
        }
    end

    return data.record
end

-- Called when a player updates a record variable.
function PLUGIN:UpdateVar(data)
    if not ( data.info and data.var ) then return end

    data.record.vars[data.var] = data.info

    return data.record
end

-- Called when a character needs their data file setup for the first time.
function PLUGIN:CharacterLoaded(char)
    if not ( char:GetData("record") ) then
        char:SetData("record", {
            rows = {},
            vars = {
                ["note"] = PLUGIN.defaultNote
            }
        })
    end

    if not ( char:GetData("status") ) then
        char:SetData("status", "Citizen")
    end
end

-- Receives the net message from the ply and checks if the message they're trying to run is implemented.
net.Receive("ixViewDataAction", function(length, ply)
    local id = net.ReadInt(32)
    local message = net.ReadInt(16)
    local data = net.ReadTable()

    data.target = ix.char.loaded[id]

    if not ( data or data.target ) then return end
    
    local record = data.target:GetData("record", {})

    -- We could send these as seperate variables, but its easier to have everything under 'data'.
    data.record = record
    data.ply = ply

    -- Using the message type to run the correct method.
    local newRecord = nil

    if ( message == VIEWDATA_ADDROW ) then
        newRecord = PLUGIN:AddRow(data)
    elseif ( message == VIEWDATA_REMOVEROW ) then
        newRecord = PLUGIN:RemoveRow(data)
    elseif ( message == VIEWDATA_EDITROW ) then
        newRecord = PLUGIN:EditRow(data)
    elseif ( message == VIEWDATA_UPDATEVAR ) then
        newRecord = PLUGIN:UpdateVar(data)
    else
        ErrorNoHalt(ply:Name() .. " has sent an invalid viewdata action type.")
    end
    
    -- Getting the data from the return method and updating the record.
    if ( newRecord ) then
        data.target:SetData("record", newRecord)
    end
end)

net.Receive("ixViewDataPoints", function(len, ply)
    local points = net.ReadInt(32)
    local target = net.ReadEntity()

    if not ( IsValid(target) and target:IsPlayer() ) then return end
    if not ( target:GetCharacter() ) then return end

    target:GetCharacter():SetData("CivicDeeds", points)
end)

net.Receive("ixViewDataStatus", function(len, ply)
    local status = net.ReadString()
    local target = net.ReadEntity()

    if not ( IsValid(target) and target:IsPlayer() ) then return end
    if not ( target:GetCharacter() ) then return end

    target:GetCharacter():SetData("status", status)
end)