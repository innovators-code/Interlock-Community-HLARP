local PLUGIN = PLUGIN

PLUGIN.name = "Media Library to Helix"
PLUGIN.author = "The GitHub guy"
PLUGIN.description = "Adds Media Library to Helix"

ix.util.IncludeDir(PLUGIN.folder.."/medialibb",true)

if ( SERVER ) then
    util.AddNetworkString("ixMusicPlayer")
    util.AddNetworkString("ixMusicPlayerStop")
    util.AddNetworkString("ixMusicPlayerSetVolume")
    
    concommand.Add("ix_play_music", function(ply, cmd, args)
        if ( ix.ops ) then
            if not ( ply:IsEventAdmin() ) then return end
        else
            if not ( ply:IsSuperAdmin() ) then return end
        end

        net.Start("ixMusicPlayer")
            net.WriteString(tostring(args[1]))
        net.Broadcast()
    end)
    
    concommand.Add("ix_stop_music", function(ply, cmd, args)
        if ( ix.ops ) then
            if not ( ply:IsEventAdmin() ) then return end
        else
            if not ( ply:IsSuperAdmin() ) then return end
        end

        net.Start("ixMusicPlayerStop")
        net.Broadcast()
    end)
    
    concommand.Add("ix_set_volume", function(ply, cmd, args)
        if ( ix.ops ) then
            if not ( ply:IsEventAdmin() ) then return end
        else
            if not ( ply:IsSuperAdmin() ) then return end
        end

        net.Start("ixMusicPlayerSetVolume")
            net.WriteString(args[1])
        net.Broadcast()
    end)
else
    net.Receive("ixMusicPlayer", function(len)
        local str = net.ReadString()
        if ( str and str != "" ) then
            local service = medialib.load("media").guessService(str)
            local mediaclip = service:load(str)
        
            if ( music ) then
                music:stop()
                music = nil
            end
        
            music = mediaclip
            music:play()
        end
    end)
    
    net.Receive("ixMusicPlayerStop", function()
        if ( music and IsValid(music) ) then
            music:stop()
          end
    end)
     
    net.Receive("ixMusicPlayerSetVolume", function()
        local volume = net.ReadString()
        if ( volume and volume != "" ) then
            if ( music and IsValid(music) ) then
                music:setVolume(volume) -- apparently this takes a string so don't use tonumber
            end
        end
    end)
end