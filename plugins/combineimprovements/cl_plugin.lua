--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

net.Receive("ixDisplaySend", function()
    local message, color, soundBool = net.ReadString(), net.ReadColor(), net.ReadBool()
    ix.display.AddDisplay(message, color or color_white, soundBool or false, "npc/roller/code2.wav")
end)

net.Receive("ixDispatchSend", function()
    chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(255, 40, 40), "Overwatch broadcasts: "..net.ReadString())
end)

net.Receive("ixNightvisionToggle", function(len)
    local trg = net.ReadEntity()

    local char = trg:GetCharacter()

    if not ( char:GetData("ixNightvision", false) ) then return end
    
    hook.Add("Think", "ixNightvisioAll", function()
        local teamColor = team.GetColor(trg:Team())
        local nightvision = DynamicLight(trg:EntIndex())
        if ( nightvision ) then
            
            nightvision.pos = trg:EyePos()
            nightvision.r = teamColor.r or 255
            nightvision.g = teamColor.g or 255
            nightvision.b = teamColor.b or 255
            nightvision.brightness = 1
            nightvision.Decay = 1000
            nightvision.Size = 1024
            nightvision.DieTime = CurTime() + 1
        end
    end)
end)
