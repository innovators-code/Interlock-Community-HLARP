-- Item Statistics

ITEM.name = "Classic Breen's Water"
ITEM.description = "A can of water with a strange taste to it. It feels refreshing."
ITEM.category = "Food"
ITEM.model = "models/props_junk/popcan01a.mdl"

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.useTime = 3
ITEM.useSound = "interlock/player/drink.ogg"
ITEM.RestoreHunger = 25
ITEM.spoil = false
ITEM.junk = "junk_empty_water"

ITEM:Hook("Consume", function(item)
    local ply = item.player

    local textMessages = {
        "clicks open and takes a sip from a water can.",
        "snaps open and takes a slurp from a water can.",
        "pulls the lid and takes a gulp from a water can.",
    }

    local randomText = {
        "You seem fine after drinking the water.",
        "You didn't feel any different after drinking the water.",
        "You tasted stale water but didn't suffer any side-effects.",
        "You drunk the water and felt no different than before.",
        "You enjoyed the water after consuming it.",
        "You suddenly loved the taste of the water, thinking of it being sabotaged for your own enjoyment.",
        "You have forgotten the past hour and lost track of time as a result.",
        "You seem very hazy in your mind and have neglected to remember the past day.",
        "You had forgotten mostly everything you have done this week.",
        "You grow upset as you forget important memories your family.",
        "You forgot certain memories about your school friends.",
        "You forgotten how you gotten into this city.",
        "You can't seem to remember what city you relocated from.",
        "You had it in your mind but once you took a drink of the water, you had forgotten your CID number.",
        "You forgot your CID number as a result of drinking the water.",
        "You had an unusual side-effect which reminded you how evil the Combine really is. Your important memories have come back to you.",
        "You tasted drugs in the water, proving otherwise that the Combine have drugged the water. You forgotten the taste right after consumpation.",
    }

    if ( SERVER ) then
        local chance = math.random(1, 4)
        
        timer.Simple(3.1, function()
            if ( chance == 4 ) then
                ply:SetSanity(ply:GetSanity() - 5)
            end
            ix.chat.Send(ply, "me", textMessages[math.random(1, #textMessages)], false)
            ply:ChatNotify(randomText[math.random(1, #randomText)])
        end)
    end
end)