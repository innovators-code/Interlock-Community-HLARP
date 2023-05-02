--- Allows for the creation of persistent menu messages similar in style to CS:GO's menu notifications
-- @module MenuMessage

file.CreateDir("helix/"..Schema.folder.."/menumsgs")

ix.menuMessage = ix.menuMessage or {}
ix.menuMessage.Data = ix.menuMessage.Data or {}

--- Creates a new MenuMessage and displays it
-- @realm client
-- @string uid Unique name
-- @string title Message title
-- @string message Message content
-- @color[opt] col The message colour
-- @string[opt] url The URL to open if pressed
-- @string[opt] urlText The text of the URL button
function ix.menuMessage.Add(uid, title, xmessage, xcol, url, urlText)
    if ix.menuMessage.Data[uid] then
        return
    end

    ix.menuMessage.Data[uid] = {
        type = uid,
        title = title,
        message = xmessage,
        colour = xcol or ix.config.Get("color"),
        url = url or nil,
        urlText = urlText or nil,
    }
end

--- Removes an active MenuMessage
-- @realm client
-- @string uid Unique name
function ix.menuMessage.Remove(uid)
    local msg = ix.menuMessage.Data[uid]
    if not msg then
        return
    end

    ix.menuMessage.Data[uid] = nil

    local fname = "helix/"..Schema.folder.."/menumsgs/"..uid..".dat"

    if file.Exists(fname, "DATA") then
        file.Delete(fname)
    end
end

--- Saves the specified MenuMessage to file so it persists
-- @realm client
-- @string uid Unique name
function ix.menuMessage.Save(uid)
    local msg = ix.menuMessage.Data[uid]
    if not msg then
        return
    end

    local compiled = util.TableToJSON(msg)

    file.Write("helix/"..Schema.folder.."/menumsgs/"..uid..".dat", compiled)
end

--- Returns if a MenuMessage can be seen
-- @realm client
-- @string uid Unique name
-- @internal
function ix.menuMessage.canSee(uid)
    local msg = ix.menuMessage.Data[uid]

    if not msg then
        return
    end

    if not msg.scheduled then
        return true
    end

    if msg.scheduledTime and msg.scheduledTime != 0 then
        if os.time() > msg.scheduledTime then
            return true
        end
    end

    return false
end