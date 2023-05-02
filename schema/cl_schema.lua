--[[---------------------------------------------------------------------------
    Clientside Functions
---------------------------------------------------------------------------]]--

function notification.AddLegacy(text, _, __)
    LocalPlayer():Notify(tostring(text))
end

function Schema:ShouldShowPlayerOnScoreboard(trg)
    local ply = LocalPlayer()
    
    return true
end 

function ix.util.DrawIcon(material, color, x, y, w, h)
    surface.SetDrawColor(color or color_white)
    surface.SetMaterial(ix.util.GetMaterial(material))
    surface.DrawTexturedRect(x, y, w, h)
end

net.Receive("ixPanicNotify", function(len, ply)
    local callerName = net.ReadString()
    ix.display.AddDisplay("panic button pressed from "..callerName, Color(255, 100, 0), true, "interlock/ui/hacking_puzzle_tripmine_failure_01.ogg")
end)

net.Receive("ixPlaySound", function()
    LocalPlayer():EmitSound(tostring(net.ReadString()), tonumber(net.ReadUInt(7)) or 100)
end)

net.Receive("ixCreateVGUI", function()
    vgui.Create(tostring(net.ReadString()))
end)

net.Receive("ixPlayerDeath", function()
    if not ( LocalPlayer():IsCombine() ) then
        if ( IsValid(ix.gui.deathScreen) ) then
            ix.gui.deathScreen:Remove()
        end

        ix.gui.deathScreen = vgui.Create("ixDeathScreen")
    end
end)

sound.Add({
    name = "Helix.Whoosh",
    channel = CHAN_STATIC,
    volume = 0.4,
    level = 80,
    pitch = 100,
    sound = "interlock/ui/ui_appear_01.wav",
})

sound.Add({
    name = "Helix.Rollover",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    pitch = 100,
    sound = "interlock/ui/ui_rollover_01.wav",
})

sound.Add({
    name = "Helix.Press",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    pitch = 100,
    sound = "interlock/ui/ui_select_01.wav",
})

sound.Add({
    name = "Helix.Notify",
    channel = CHAN_STATIC,
    volume = 0.35,
    level = 80,
    pitch = 100,
    sound = "interlock/ui/ui_appear_03.wav",
})

surface.CreateFont("InterlockTitleFont", {
    font = "VoxRound",
    size = ScreenScale(30),
    antialias = true,
    shadow = true,
})

surface.CreateFont("InterlockSubTitleFont", {
    font = "VoxRound",
    size = ScreenScale(15),
    antialias = true,
    shadow = true,
})

surface.CreateFont("InterlockBigAmmoFont", {
    font = "Agency FB",
    size = 40,
    weight = 1000,
    antialias = true,
    shadow = true,
})

surface.CreateFont("InterlockAmmoFont", {
    font = "Agency FB",
    size = 30,
    weight = 1000,
    antialias = true,
    shadow = true,
})

for value = 10, 170 do
    surface.CreateFont("InterlockFont"..tostring(value), {
        font = "Russell Square",
        size = tonumber(value),
        weight = 1000,
        antialias = true,
        shadow = false,
    })
    
    surface.CreateFont("InterlockFont"..tostring(value).."-Light", {
        font = "Russell Square",
        size = tonumber(value),
        weight = 500,
        antialias = true,
        shadow = false,
    })
    
    surface.CreateFont("InterlockFontShadow"..tostring(value), {
        font = "Russell Square",
        size = tonumber(value),
        weight = 1000,
        antialias = true,
        shadow = true,
    })

    surface.CreateFont("InterlockFontShadow"..tostring(value).."-Light", {
        font = "Russell Square",
        size = tonumber(value),
        weight = 500,
        antialias = true,
        shadow = true,
    })

    surface.CreateFont("InterlockFontChat"..tostring(value), {
        font = ix.config.Get("genericFont", "Roboto"),
        size = tonumber(value),
        extended = true,
        weight = 600,
        antialias = true,
    })

    surface.CreateFont("InterlockFontChat"..tostring(value).."-Light", {
        font = ix.config.Get("genericFont", "Roboto"),
        size = tonumber(value),
        extended = true,
        weight = 600,
        antialias = true,
    })

    surface.CreateFont("CombineFontBlur"..tostring(value), {
        font = "Deadman",
        size = tonumber(value),
        weight = 600,
        blursize = 2,
        scanlines = 4,
    })

    surface.CreateFont("CombineFont"..tostring(value), {
        font = "Deadman",
        size = tonumber(value),
        weight = 600,
        blursize = 1,
        scanlines = 4,
    })

    surface.CreateFont("CombineFontNoBlur"..tostring(value), {
        font = "Deadman",
        size = tonumber(value),
        weight = 600,
        blursize = 0.5,
        scanlines = 4,
    })
end