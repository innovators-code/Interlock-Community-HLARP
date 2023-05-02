PLUGIN.name = "Viewdata"
PLUGIN.description = "Implements a new viewdata screen to hold records and a note."
PLUGIN.author = "Adolphus & Riggs.mackay"

-- Globals for viewdata message types to make it neater.
VIEWDATA_ADDROW = 1
VIEWDATA_REMOVEROW = 2
VIEWDATA_EDITROW = 3
VIEWDATA_UPDATEVAR = 4

-- Default viewdata note.
PLUGIN.defaultNote = [[
This is the default note
]]

--[[
    -- Anti-Body
    "Anti-Citizen One" (-50)
    "Anti-Citizen" (-25)
    "Malignant" (-10)
    "Outcast" (-1)

    -- Civil Standard
    "Citizen" (0)
    "Black Tier Loyalist" (5)
    "Brown Tier Loyalist" (15)
    "Red Tier Loyalist" (25)

    -- Loyalist
    "Yellow Tier Loyalist" (30)
    "Green Tier Loyalist" (50)
    "Blue Tier Loyalist" (75)
    "White Tier Loyalist" (100)
]]

PLUGIN.statuses = {
    -- Anti-Body
    "Anti-Citizen One",
    "Anti-Citizen",
    "Malignant",
    "Outcast",

    -- Civil Standard
    "Citizen",
    "Black Tier Loyalist",
    "Brown Tier Loyalist",
    "Red Tier Loyalist",
    
    -- Loyalist
    "Yellow Tier Loyalist",
    "Green Tier Loyalist",
    "Blue Tier Loyalist",
    "White Tier Loyalist"
}

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")

ix.command.Add("ViewData", {
    arguments = {
        ix.type.character
    },
    OnRun = function(self, ply, target)
		if not ( ply:IsCombine() or ply:IsDispatch() ) then return end
        
        local faction = target:GetFaction()
        if not ( faction == FACTION_CITIZEN or faction == FACTION_UUA or faction == FACTION_CP ) then
            return "Can only view the data of citizens and units."
        end

        local data = target:GetData("record", {})
        local cid = target:GetData("cid", 00000)
        local status = target:GetData("status", "Citizen")
        net.Start("ixViewDataOpen")
            net.WriteEntity(target:GetPlayer())
            net.WriteUInt(cid, 32)
            net.WriteTable(data)
            net.WriteString(status)
        net.Send(ply)

		Schema:AddDisplay("Downloading citizen profile data...")
    end
})