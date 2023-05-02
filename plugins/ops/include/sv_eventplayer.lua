local function UpdateEventAdmins(eventid)
    for v,k in pairs(player.GetAll()) do
        if k:IsEventAdmin() then
            net.Start("ixOpsEMUpdateEvent")
            net.WriteUInt(eventid, 10)
            net.Send(k)
        end
    end
end

local eventTimerNames = {}
local sequenceTime = 0

local function queueEvent(sequence, eventid)
    local event = ix.ops.eventManager.sequences[sequence][eventid]
    local timerName = "ixOpsEM-"..eventid
    local time = sequenceTime + (event.Delay or 0)
    local x = table.insert(eventTimerNames, timerName)

    timer.Create(timerName, time, 1, function()
        ix.ops.eventManager.PlayEvent(sequence, eventid)
        eventTimerNames[x] = nil
    end)

    sequenceTime = time
end

function ix.ops.eventManager.PlaySequence(name)
    local sequence = ix.ops.eventManager.sequences[name]

    eventTimerNames = {}
    sequenceTime = 0

    ix.ops.eventManager.SetSequence(name)

    for v,k in pairs(sequence) do
        queueEvent(name, v)
    end
end

function ix.ops.eventManager.StopSequence()
    for v,k in pairs(eventTimerNames) do
        if k and timer.Exists(k) and not (timer.TimeLeft(k) and timer.TimeLeft(k) <= 0) then
            timer.Remove(k)
        end
    end

    ix.ops.eventManager.SetSequence("")
end

function ix.ops.eventManager.PlayEvent(sequence, eventid)
    local count = table.Count(ix.ops.eventManager.sequences[sequence])
    local event = ix.ops.eventManager.sequences[sequence][eventid]

    if not ix.ops.eventManager.config.Events[event.Type] then
        return ix.ops.eventManager.StopSequence()
    end

    UpdateEventAdmins(eventid)

    if ix.ops.eventManager.config.Events[event.Type].Clientside then
        net.Start("ixOpsEMClientsideEvent")
        net.WriteString(event.Type)
        net.WriteString(event.UID or "")
        local data = pon.encode(event.Prop)
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
        net.Broadcast()
    else
        ix.ops.eventManager.config.Events[event.Type].Do(event.Prop or {}, event.UID or nil)
    end

    if eventid >= count then
        ix.ops.eventManager.StopSequence()
    end
end