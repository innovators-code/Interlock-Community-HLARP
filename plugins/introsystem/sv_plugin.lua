--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

function PLUGIN:SetupPlayerVisibility( ply, viewEnt )
    if not ( ply.ixIntroState and ply.ixIntroOrigin ) then return end

    AddOriginToPVS(ply.ixIntroOrigin)
end

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    if ( ix.intro.config[game.GetMap()] ) then
        --if ( ply:GetPData("ixIntroLoaded", false) ) then return end
        if ( ply:GetPData("ixIntroLoaded."..tostring(game.GetMap()), false) ) then return end

        ix.intro:Start(ply)
        ply:SetPData("ixIntroLoaded."..tostring(game.GetMap()), true)
        --ply:SetPData("ixIntroLoaded", true)
    end
end

util.AddNetworkString("ixIntroStart")
function ix.intro:Start(ply)
    if ( ix.intro.config[game.GetMap()] ) then
        net.Start("ixIntroStart")
        net.Send(ply)

        ix.event.PlaySound(ply, {
            sound = ix.intro.config[game.GetMap()].music,
            pitch = ix.intro.config[game.GetMap()].pitch,
            db = 120,
            volume = 1,
        })
    end
end

util.AddNetworkString("ixIntroStarted")
net.Receive("ixIntroStarted", function(len, ply)
    local position = net.ReadVector()

    ply.ixIntroState = true
    ply.ixIntroOrigin = position

    if not ( ply:Alive() ) then
        ply:Spawn()
        hook.Run("PlayerLoadout", ply)
    end

    ix.event.PlaySound(ply, {
        sound = table.Random(ix.intro.config.transitionSounds),
        pitch = 100,
        db = 120,
        volume = 0.2,
    })
    ply:ScreenFade(SCREENFADE.IN, color_black, 5, 0)
    timer.Simple(18, function()
        ply:ScreenFade(SCREENFADE.OUT, color_black, 2, 0)
    end)
end)

util.AddNetworkString("ixIntroUpdate")
net.Receive("ixIntroUpdate", function(len, ply)
    local position = net.ReadVector()

    ply.ixIntroState = true
    ply.ixIntroOrigin = position
    
    ix.event.PlaySound(ply, {
        sound = table.Random(ix.intro.config.transitionSounds),
        pitch = 100,
        db = 120,
        volume = 0.2,
    })
    ply:ScreenFade(SCREENFADE.IN, color_black, 5, 0)
    timer.Simple(18, function()
        ply:ScreenFade(SCREENFADE.OUT, color_black, 2, 0)
    end)
end)

util.AddNetworkString("ixIntroComplete")
net.Receive("ixIntroComplete", function(len, ply)
    ply.ixIntroState = false
    ply.ixIntroOrigin = nil

    ply:ScreenFade(SCREENFADE.IN, color_black, 1, 2)
end)

concommand.Add("conflict_dev_intro_start", function(ply)
    if not ( ply:IsDeveloper() ) then return end
    
    ix.intro:Start(ply)
end)