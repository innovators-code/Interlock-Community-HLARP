--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

net.Receive("ixEvent.PlaySound", function()
    local soundData = net.ReadTable()
    if not ( soundData.sound ) then return end

    if ( soundData.delay and isnumber(soundData.delay) ) then
        timer.Simple(soundData.delay, function()
            LocalPlayer():EmitSound(soundData.sound, soundData.db, soundData.pitch, soundData.volume)
        end)
    else
        LocalPlayer():EmitSound(soundData.sound, soundData.db, soundData.pitch, soundData.volume)
    end
end)

net.Receive("ixEvent.StopSound", function()
    local soundString = net.ReadString()
    if not ( soundString ) then return end

    LocalPlayer():StopSound(soundString)
end)