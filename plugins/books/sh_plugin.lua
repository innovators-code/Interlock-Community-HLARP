--[[
    Helix Plugin made by Ghost
    https://steamcommunity.com/id/GhostL0L
--]]

local PLUGIN = PLUGIN

PLUGIN.name = "Books"
PLUGIN.description = "Adds books which players can read."
PLUGIN.author = "Ghost"

if (CLIENT) then
    netstream.Hook("ixBook", function(title, text)
        local book = vgui.Create("ixViewBook")

        text = string.gsub(string.gsub(text, "\n", "<br>"), "\t", string.rep("&nbsp;", 4))
        text = "<html><font face='Arial' size='2' color='#ffffff'>" .. text .. "</font></html>"

        book:Populate(title, text)
    end)
end