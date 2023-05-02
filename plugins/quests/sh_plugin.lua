--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Quest System"
PLUGIN.description = "A quest system, made for players to complete tasks and earn rewards."
PLUGIN.author = "Riggs.mackay"

ix.quests = ix.quests or {}
ix.quests.stored = ix.quests.stored or {}

if ( SERVER ) then
    util.AddNetworkString("ixQuestAccept")
    
    net.Receive("ixQuestAccept", function(len, ply)
        local str = net.ReadString()
        local quest = ix.quests.stored[str]

        quest.onStart(ply, ply:GetCharacter(), str)

        timer.Create("ixQuest"..str.."Timer", quest.time, 1, function()
            quest.onFail(ply, ply:GetCharacter(), str)
        end)
    end)
end

function ix.quests.AddQuest(id, questTable)
    if ( ix.quests.stored[id] ) then
        print("A quest with this ID ( "..tostring(id).." ) already exists!")
        return false
    end

    ix.quests.stored[id] = questTable

    return true
end

function ix.quests.GetQuest(id)
    return ix.quests.stored[id]
end

function ix.quests.GetQuests()
    return ix.quests.stored
end

-- general sense of the quest
ix.quests.AddQuest("bring.Flashlight", {
    name = "Bring Flashlight",
    description = "Bring a flashlight to the quest giver.",
    time = 300, -- Time in seconds
    onCheck = function(ply, char)
        if not ( IsValid(ply) and char ) then return end

        return ( char:GetInventory():HasItem("tool_flashlight") )
    end,
    onStart = function(ply, char, id)
        if ( char:GetData("ixQuest."..id) != nil ) then return print(":(") end

        char:SetData("ixQuest."..id, true)
        ply:Notify("You have started the quest '"..tostring(id).."'.")
    end,
    onComplete = function(ply, char, id)
        if not ( char:GetData("ixQuest."..id) ) then return end

        char:SetData("ixQuest."..id, nil)
        ply:Notify("You have completed the quest '"..tostring(id).."'.")
    end,
    onFail = function(ply, char, id)
        if not ( char:GetData("ixQuest."..id) == true ) then return end

        char:SetData("ixQuest."..id, nil)
        ply:Notify("You have failed the quest '"..tostring(id).."'.")
    end,
})

if ( SERVER ) then
    function PLUGIN:PlayerTick(ply, mv)
        if not ( IsValid(ply) or IsValid(ply:GetCharacter()) ) then return end
        for k, v in pairs(ix.quests.GetQuests()) do
            if ( v.onCheck and v.onCheck(ply, ply:GetCharacter()) ) then
                if ( timer.Exists("ixQuest"..k.."Timer") ) then
                    timer.Remove("ixQuest"..k.."Timer")
                    if ( v.onComplete ) then
                        v.onComplete(ply, ply:GetCharacter(), k)
                    end
                    ply:GetCharacter():SetData("ixQuest."..k, nil)
                end
            end
        end
    end
end