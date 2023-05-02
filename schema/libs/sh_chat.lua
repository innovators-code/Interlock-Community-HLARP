function Schema:OnReloaded()
    hook.Run("InitializedChatClasses")
end

local blacklistedwords = {
    "ped0",-- Toxcity
    "pedo",-- Toxcity
    "pedophile",-- Toxcity
    "nigger",-- Racism
    "niggers",-- Racism
    "rule 34",-- Erotic/Inappropriate
    "r 34",-- Erotic/Inappropriate
    "r34",-- Erotic/Inappropriate
    "rul 34",-- Erotic/Inappropriate
    "rule34",-- Erotic/Inappropriate
    "seeth",-- Toxcity
    "seethe",-- Toxcity
    "mald",-- Toxcity
    "sieg heil", -- Nazi Stuff
    "heil hitler" -- Nazi Stuff
}

function Schema:InitializedChatClasses()
    ix.chat.Register("me", {
        format = "** %s %s",
        GetColor = ix.chat.classes.ic.GetColor,
        CanHear = ix.config.Get("chatRange", 280),
        prefix = {"/Me", "/Action"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        font = "InterlockFontChat20",
        deadCanChat = true,
    })

    ix.chat.Register("me_close", {
        format = "** %s %s",
        GetColor = ix.chat.classes.ic.GetColor,
        CanHear = ix.config.Get("chatRange", 280) * 0.25,
        prefix = {"/MeClose", "/ActionClose", "/MeC"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        font = "InterlockFontChat18",
        deadCanChat = true,
    })

    ix.chat.Register("me_large", {
        format = "** %s %s",
        GetColor = ix.chat.classes.ic.GetColor,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/MeLarge", "/ActionLarge", "/MeL"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        font = "InterlockFontChat24",
        deadCanChat = true,
    })

    ix.chat.Register("me_scream", {
        format = "** %s %s",
        GetColor = ix.chat.classes.ic.GetColor,
        CanHear = ix.config.Get("chatRange", 280) * 4,
        prefix = {"/MeScream", "/ActionScream", "/MeS"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        font = "InterlockFontChat28",
        deadCanChat = true,
    })

    ix.chat.Register("it", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(200, 160, 20), "**** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280),
        prefix = {"/It"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        font = "InterlockFontChat20",
        deadCanChat = true,
    })

    ix.chat.Register("it_close", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(200, 160, 20), "**** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280) * 0.25,
        prefix = {"/ItClose", "/ItC"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        font = "InterlockFontChat18",
        deadCanChat = true,
    })

    ix.chat.Register("it_large", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(200, 160, 20), "**** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/ItLarge", "/ItL"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        font = "InterlockFontChat24",
        deadCanChat = true,
    })

    ix.chat.Register("it_scream", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(200, 160, 20), "**** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280) * 4,
        prefix = {"/ItScream", "/ItS"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        font = "InterlockFontChat28",
        deadCanChat = true,
    })

    ix.chat.Register("ic", {
        format = " \"%s\"",
        indicator = "chatTalking",
        font = "InterlockFontChat20",
        GetColor = function(self, ply, text)
            if (LocalPlayer():GetEyeTrace().Entity == ply) then
                return ix.config.Get("chatListenColor")
            end

            return ix.config.Get("chatColor")
        end,
        OnChatAdd = function(self, ply, text, anonymous, info)
            local color = self:GetColor(ply, text, info)
            local name = anonymous and L"someone" or hook.Run("GetCharacterName", ply, "ic") or ( IsValid(ply) and ply:Name() or "Console" )

            -- to you - inspired by willard networks
            local lookingAt = ply:GetEyeTraceNoCursor().Entity == LocalPlayer()

            chat.AddText(Material("willardnetworks/chat/message_icon.png"), color, name, " says", lookingAt and " to you" or "", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280),
    })

    ix.chat.Register("w", {
        format = " \"%s\"",
        indicator = "chatWhispering",
        font = "InterlockFontChat18",
        description = "@cmdW",
        prefix = {"/W", "/Whisper"},
        OnChatAdd = function(self, ply, text, anonymous, info)
            local color = Color(0, 150, 255)
            local name = anonymous and L"someone" or hook.Run("GetCharacterName", ply, "w") or ( IsValid(ply) and ply:Name() or "Console" )

            -- to you - inspired by willard networks
            local lookingAt = ply:GetEyeTraceNoCursor().Entity == LocalPlayer()

            chat.AddText(Material("willardnetworks/chat/whisper_icon.png"), color, name, " whispers", lookingAt and " to you" or "", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280) * 0.25,
    })

    ix.chat.Register("y", {
        format = " \"%s\"",
        indicator = "chatYelling",
        font = "InterlockFontChat24",
        description = "@cmdY",
        prefix = {"/Y", "/Yell"},
        OnChatAdd = function(self, ply, text, anonymous, info)
            local color = Color(250, 100, 0)
            local name = anonymous and L"someone" or hook.Run("GetCharacterName", ply, "y") or ( IsValid(ply) and ply:Name() or "Console" )

            -- to you - inspired by willard networks
            local lookingAt = ply:GetEyeTraceNoCursor().Entity == LocalPlayer()

            chat.AddText(Material("willardnetworks/chat/yell_icon.png"), color, name, " yells", lookingAt and " at you" or "", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
    })

    ix.chat.Register("s", {
        format = " \"%s\"",
        indicator = "Screaming...",
        font = "InterlockFontChat28",
        description = "@cmdY",
        prefix = {"/S", "/Scream"},
        OnChatAdd = function(self, ply, text, anonymous, info)
            local color = Color(150, 0, 0)
            local name = anonymous and L"someone" or hook.Run("GetCharacterName", ply, "y") or ( IsValid(ply) and ply:Name() or "Console" )

            -- to you - inspired by willard networks
            local lookingAt = ply:GetEyeTraceNoCursor().Entity == LocalPlayer()

            chat.AddText(color, name, " screams", lookingAt and " at you" or "", string.format(self.format, text))
        end,
        CanHear = ix.config.Get("chatRange", 280) * 4,
    })

    ix.chat.Register("ooc", {
        font = "InterlockFontChat20",
        CanSay = function(self, ply, text)
            if not ( ix.config.Get("allowGlobalOOC") ) then
                ply:NotifyLocalized("Global OOC is disabled on this server.")
                return false
            else
                local delay = ix.config.Get("oocDelay", 10)

                if ( delay > 0 and ply.ixLastOOC ) then
                    local lastOOC = CurTime() - ply.ixLastOOC

                    if ( lastOOC <= delay and not CAMI.PlayerHasAccess(ply, "Helix - Bypass OOC Timer", nil) ) then
                        ply:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

                        return false
                    end
                end

                ply.ixLastOOC = CurTime()
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end
            for k, v in pairs(blacklistedwords) do
                if ( text:lower():find(v) ) then
                    if ( SERVER ) then
                        ply:Notify("You have used blacklisted word '"..v.."'")
                        for _, i in pairs(player.GetAll()) do
                            if ( i:IsAdmin() ) then
                                i:ChatPrint(ply:SteamName().." ('"..ply:Nick().."') ".." has used blacklisted word ".."'"..v.."'")
                                print(ply:SteamName().." ('"..ply:Nick().."') ".." has used blacklisted word ".."'"..v.."'") -- RCON
                            end
                        end
                    end

                    return false
                end
            end

            local icon = "icon16/user.png"
            local label = "Member"
            local color = Color(240, 240, 240)

            if ( ply:SteamID() == "STEAM_0:1:1395956" ) then
                icon = "icon16/cog_edit.png"
                label = "Founder"
                color = Color(255, 0, 0)
            elseif ( ply:SteamID() == "STEAM_0:0:503985107" ) then
                icon = "icon16/page_lightning.png"
                label = "Roleplay Director"
                color = Color(0, 255, 255)
            elseif ( ply:IsSuperAdmin() ) then
                icon = "icon16/ruby.png"
                label = "Administration"
                color = Color(215, 52, 42)
            elseif ( ply:IsAdmin() ) then
                icon = "icon16/shield_add.png"
                label = "Moderation Group"
                color = Color(32, 102, 148)
            elseif ( ply:IsDonator() ) then
                icon = "icon16/coins.png"
                label = "Donator"
                color = Color(200, 150, 0)
            end

            chat.AddText(Material(icon), Color(175, 0, 0), "[OOC] ", color, ply:SteamName(), color_white, ": "..text)
        end,
        prefix = {"//", "/OOC"},
        description = "@cmdOOC",
        noSpaceAfter = true,
    })

    ix.chat.Register("looc", {
        font = "InterlockFontChat20",
        CanSay = function(self, ply, text)
            local delay = ix.config.Get("loocDelay", 0)

            if ( delay > 0 and ply.ixLastLOOC ) then
                local lastLOOC = CurTime() - ply.ixLastLOOC

                if ( lastLOOC <= delay and not CAMI.PlayerHasAccess(ply, "Helix - Bypass OOC Timer", nil) ) then
                    ply:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

                    return false
                end
            end

            ply.ixLastLOOC = CurTime()
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end
            for k, v in pairs(blacklistedwords) do
                if ( text:lower():find(v) ) then
                    if ( SERVER ) then
                        ply:Notify("You have used blacklisted word '"..v.."'")
                        for _, i in pairs(player.GetAll()) do
                            if ( i:IsAdmin() ) then
                                i:ChatPrint(ply:SteamName().." ('"..ply:Nick().."') ".." has used blacklisted word ".."'"..v.."'")
                                print(ply:SteamName().." ('"..ply:Nick().."') ".." has used blacklisted word ".."'"..v.."'") -- RCON
                            end
                        end
                    end
                    
                    return false
                end
            end

            local icon = "icon16/user.png"
            local label = "Member"
            local color = Color(240, 240, 240)

            if ( ply:SteamID() == "STEAM_0:1:1395956" ) then
                icon = "icon16/cog_edit.png"
                label = "Founder"
                color = Color(255, 0, 0)
            elseif ( ply:SteamID() == "STEAM_0:0:503985107" ) then
                icon = "icon16/page_lightning.png"
                label = "Roleplay Director"
                color = Color(0, 255, 255)
            elseif ( ply:IsSuperAdmin() ) then
                icon = "icon16/ruby.png"
                label = "Administration"
                color = Color(215, 52, 42)
            elseif ( ply:IsAdmin() ) then
                icon = "icon16/shield_add.png"
                label = "Moderation Group"
                color = Color(32, 102, 148)
            elseif ( ply:IsDonator() ) then
                icon = "icon16/coins.png"
                label = "Donator"
                color = Color(200, 150, 0)
            end

            chat.AddText(Material(icon), Color(175, 0, 0), "[LOOC] ", color, ply:SteamName(), team.GetColor(ply:Team()), " ("..ply:Nick()..")", color_white, ": "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280),
        prefix = {".//", "[[", "/LOOC"},
        description = "@cmdLOOC",
        noSpaceAfter = true,
    })

    ix.chat.Register("radio_combine", {
        CanSay = function(self, ply, text)
            if not ( ply:IsCombine() or ply:IsCA() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(Material("willardnetworks/chat/cmb_shared_icon.png"), Color(180, 230, 240), "[TAC-1]"..ply:Nick().." radios <:: "..text.." ::>")
        end,
        CanHear = function(self, ply, listener)
            if not ( listener:IsCombine() or listener:IsCA() or listener:IsDispatch() ) then
                return false
            else  
                listener:EmitSound("NPC_MetroPolice.Radio.Off", 40, math.random(90,110), 0.3)
                return true
            end
        end,
        prefix = {"/CombineRadio", "/CR", "/T"},
        description = "Radio in a message to the Combine.",
        indicator = "chatPerforming",
        font = "CombineFontNoBlur24",
        deadCanChat = false,
    })

    ix.chat.Register("radio_dispatch", {
        CanSay = function(self, ply, text)
            if not ( ply:IsDispatch() or ply:IsAdmin() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(200, 40, 40), "Dispatch radios <:: "..text.." ::>")
        end,
        CanHear = function(self, ply, listener)
            if not ( listener:IsCombine() or listener:IsDispatch() ) then
                return false
            else
                listener:EmitSound("NPC_MetroPolice.Radio.Off", 40, math.random(90,110), 0.3)
                return true
            end
        end,
        prefix = {"/DispatchRadio", "/DR"},
        description = "Radio something as dispatch to the combine.",
        indicator = "chatPerforming",
        font = "CombineFontNoBlur24",
        deadCanChat = true,
    })

    ix.chat.Register("dispatch", {
        font = "InterlockFontChat20",
        CanSay = function(self, ply, text)
            if not ( ply:IsDispatch() or ply:IsAdmin() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(255, 40, 40), "Overwatch broadcasts: "..text)
        end,
        CanHear = function(self, ply, listener)
            return true
        end,
        prefix = {"/Dispatch", "/D"},
        description = "Announce something as dispatch to the city.",
        indicator = "chatPerforming",
        deadCanChat = false,
    })

    ix.chat.Register("announce", {
        font = "InterlockFontChat20",
        CanSay = function(self, ply, text)
            if not ( ply:IsDispatch() or ply:IsAdmin() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(Material("willardnetworks/chat/dispatch_icon.png"), Color(255, 40, 40), "Speakers announce: "..text)
        end,
        CanHear = function(self, ply, listener)
            listener:PlaySound("interlock/ambient/alarms/dispatch_alarm.wav")
            
            return true
        end,
        prefix = {"/Announce", "/A"},
        description = "Announce something to the city.",
        indicator = "chatPerforming",
        deadCanChat = false,
    })

    ix.chat.Register("adminchat", {
        CanSay = function(_, ply)
            if not ( ply:IsAdmin() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        CanHear = function(self, ply, listener)
            if not ( listener:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(ix.config.Get("color"), Material("interlock/icons/16/news.png"), ix.config.Get("color"), "[Admin Chat] ", team.GetColor(ply:Team()), ply:SteamName(), color_white, ": "..text)
        end,
        prefix = {"/AdminChat", "/AC"},
        description = "Talk to staff members :3",
        indicator = "chatPerforming",
        font = "InterlockFontChat18-Light",
        adminOnly = true,
        deadCanChat = true,
    })

    ix.chat.Register("officialannouncement", {
        CanSay = function(_, ply)
            if not ( ply:IsSuperAdmin() ) then
                ply:Notify("You can't use this command.")
                return false
            end
        end,
        CanHear = function(self, ply, listener)
            return true
        end,
        OnChatAdd = function(self, ply, text)
            if not ( IsValid(ply) ) then return end

            chat.AddText(ix.config.Get("color"), Material("interlock/icons/16/news.png"), ix.config.Get("color"), "Interlock: Announcement", Color(100, 100, 100), " | ", color_white, text)
        end,
        prefix = {"/OfficialAnnounce", "/OA"},
        description = "Officially Announce something to the entire server.",
        indicator = "chatPerforming",
        font = "InterlockFontChat20-Light",
        adminOnly = true,
        deadCanChat = true,
    })
end