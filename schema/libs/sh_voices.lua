Schema.voices = {}
Schema.voices.stored = {}
Schema.voices.classes = {}
Schema.voices.chatTypes = {}
Schema.voices.radioChatTypes = {}

function Schema.voices.Add(class, key, text, sound)
    class = string.lower(class)
    key = string.lower(key)

    Schema.voices.stored[class] = Schema.voices.stored[class] or {}
    Schema.voices.stored[class][key] = {
        text = text,
        sound = sound,
    }
end

function Schema.voices.Get(class, key)
    class = string.lower(class)
    key = string.lower(key)

    if (Schema.voices.stored[class]) then
        return Schema.voices.stored[class][key]
    end
end

function Schema.voices.AddClass(class, condition)
    class = string.lower(class)

    Schema.voices.classes[class] = {
        condition = condition
    }
end

function Schema.voices.GetClass(ply)
    local classes = {}

    for k, v in pairs(Schema.voices.classes) do
        if (v.condition(ply)) then
            classes[#classes + 1] = k
        end
    end

    return classes
end

Schema.voices.chatTypes["ic"] = true
Schema.voices.chatTypes["w"] = true
Schema.voices.chatTypes["y"] = true

Schema.voices.radioChatTypes["radio"] = true
Schema.voices.radioChatTypes["radio_yell"] = true
Schema.voices.radioChatTypes["radio_whisper"] = true
Schema.voices.radioChatTypes["radio_eavesdrop"] = true
Schema.voices.radioChatTypes["radio_eavesdrop_yell"] = true
Schema.voices.radioChatTypes["radio_eavesdrop_whisper"] = true
Schema.voices.radioChatTypes["radio_overhear"] = true
Schema.voices.radioChatTypes["radio_combine"] = true
Schema.voices.radioChatTypes["radio_dispatch"] = true