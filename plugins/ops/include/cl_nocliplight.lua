local wait = 0
local lightOn = lightOn or false
OPS_LIGHT = OPS_LIGHT or false
local dLight
function PLUGIN:Think()
    if not LocalPlayer():IsAdmin() or LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP or not LocalPlayer():Alive() then
        OPS_LIGHT = false
        lightOn = false
        return
    end

    if lightOn then
        dLight = DynamicLight(LocalPlayer():EntIndex())
        if dLight then
            dLight.pos = LocalPlayer():EyePos()

            dLight.r = 255
            dLight.g = 255
            dLight.b = 255
            dLight.brightness = 3
            local size = 1200
            dLight.Size = size
            dLight.Decay = size * 5
            dLight.DieTime = CurTime() + 0.8
        end
    end

    if vgui.CursorVisible() then
        return
    end

    if (wait > CurTime()) then return end

    if input.IsKeyDown(KEY_F) then
        wait = CurTime() + 0.3

        if lightOn then
            OPS_LIGHT = false
            lightOn = false
            surface.PlaySound("buttons/button14.wav")
            return
        end

        surface.PlaySound("buttons/button14.wav")
        lightOn = true
        OPS_LIGHT = true
    end
end