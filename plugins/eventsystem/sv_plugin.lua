--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

util.AddNetworkString("ixEvent.PlaySound")
util.AddNetworkString("ixEvent.StopSound")
    
function ix.event.PlaySound(caller, soundData)
    if not ( IsValid(caller) ) then return end
    if not ( soundData.sound ) then return end

    net.Start("ixEvent.PlaySound")
        net.WriteTable({
            sound = soundData.sound,
            db = soundData.db or 75,
            pitch = soundData.pitch or 100,
            volume = soundData.volume or 1,
            delay = soundData.delay or nil,
        })
    net.Send(caller)
end

function ix.event.PlaySoundGlobal(soundData)
    if not ( soundData.sound ) then return end

    net.Start("ixEvent.PlaySound")
        net.WriteTable({
            sound = soundData.sound,
            db = soundData.db or 75,
            pitch = soundData.pitch or 100,
            volume = soundData.volume or 1,
            delay = soundData.delay or nil,
        })
    net.Broadcast()
end

function ix.event.StopSoundGlobal(soundString)
    if not ( soundString ) then return end

    net.Start("ixEvent.StopSound")
        net.WriteString(soundString)
    net.Broadcast()
end

function ix.event.EmitShake(amplitute, frequency, duration, delay)
    timer.Simple(delay or 0, function()
        for k, v in ipairs(player.GetAll()) do
            if ( IsValid(v) ) then
                util.ScreenShake(v:GetPos(), amplitute, frequency, duration, 64)
            end
        end
    end)
end

--[[---------------------------------------------------------------------------
    Commands
---------------------------------------------------------------------------]]--

concommand.Add("ix_stopsoundall", function(ply, cmd, args)
    if ( ply:IsSuperAdmin() ) then
        for k, v in pairs(player.GetAll()) do
            v:ConCommand("stopsound")
        end
    else
        ply:Notify("You must be a Super Admin to forcefully stopsound everyone!")
    end
end)

concommand.Add("ix_playsoundall", function(ply, cmd, args)
    if ( ply:IsSuperAdmin() ) then
        ix.event.PlaySoundGlobal({sound = args[1]})
    else
        ply:Notify("You must be a Super Admin to play a sound on everyone!")
    end
end)