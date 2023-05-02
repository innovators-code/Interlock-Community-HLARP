local PLUGIN = PLUGIN

local fileLimit = 2500
local formats = {".wav", ".ogg", ".mp3", ".midi"}

local function PaintPanel(self, w, h)
    surface.SetDrawColor(Color(20, 20, 20, 200))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(ix.config.Get("color"))
    surface.DrawOutlinedRect(0, 0, w, h)
end

local function CreateCatergory(self, text)
    self.catergory = self:Add("DPanel")
    self.catergory:Dock(TOP)
    self.catergory:DockMargin(5, 5, 5, 5)
    self.catergory:SetSize(0, 40)
    self.catergory.Paint = function(self, w, h)
        ix.util.DrawBlur(self, 2)

        surface.SetDrawColor(ColorAlpha(ix.config.Get("color"), 20))
        surface.DrawRect(0, 0, w, h)

        draw.DrawText(text, "InterlockFontShadow30", w / 2, h / 2 - 15, ix.config.Get("color"), TEXT_ALIGN_CENTER)
    end
end

local function CreateSoundButtons(self, type, name, noStop)
    if ( istable(type) ) then
        for k, v in pairs(type) do
            if not ( v[1] == "" or v[2] == "" ) then
                self.soundbutton = self:Add("ixMenuButton")
                self.soundbutton:Dock(TOP)
                self.soundbutton:SetText(v[1].."  |  "..v[2])

                self.soundbutton:SetFont("InterlockFont18")
                self.soundbutton:SetSize(0, 20)
                self.soundbutton:SetContentAlignment(5)
                self.soundbutton:DockMargin(5, 0, 5, 0)
                self.soundbutton.DoClick = function()
                    if ( noStop ) then
                        RunConsoleCommand("ix_playsoundall", v[2])
                    else
                        RunConsoleCommand("ix_stopsoundall")
                        timer.Simple(0.1, function()
                            RunConsoleCommand("ix_playsoundall", v[2])
                        end)
                        ix.util.Notify("Played "..v[1].." ("..v[2]..") to all players!")
                    end
                end

                self.soundbutton.DoRightClick = function()
                    RunConsoleCommand("play", v[2])
                    ix.util.Notify("You played "..v[1].." ("..v[2]..") only to yourself!")
                end
            end
        end
    else
        self.soundbutton = self:Add("ixMenuButton")
        self.soundbutton:Dock(TOP)
        if ( name ) then
            self.soundbutton:SetText(name)
        else
            self.soundbutton:SetText(type)
        end

        self.soundbutton:SetFont("InterlockFont18")
        self.soundbutton:SetSize(0, 20)
        self.soundbutton:SetContentAlignment(5)
        self.soundbutton:DockMargin(5, 0, 5, 0)
        self.soundbutton.DoClick = function()
            RunConsoleCommand("ix_playsoundall", type)
            if not ( noStop ) then
                ix.util.Notify("Played "..type.." to all players!")
            end
        end

        self.soundbutton.DoRightClick = function()
            RunConsoleCommand("play", type)
            ix.util.Notify("You played "..type.." only to yourself!")
        end
    end
end

local eventMenu
local function OpenEventMenu()
    if ( eventMenu ) then
        eventMenu.Frame:SetAlpha(0)
        eventMenu.Frame:AlphaTo(255, 0.25)
        eventMenu.Frame:SetVisible(true)

        hook.Add("Think", "ixEventMenuPressedSpace", function()
            if input.IsKeyDown(KEY_SPACE) and !keyDown then
                eventMenu.Frame.playsound.DoClick()
                keyDown = true
                timer.Simple(0.4, function() keyDown = false end)
            end
        end)
        
        return
    end
    
    eventMenu = {}

    eventMenu.Frame = vgui.Create("DFrame")
    eventMenu.Frame:SetSize(ScrW(), ScrH())
    eventMenu.Frame:SetTitle("")
    eventMenu.Frame:Center()

    eventMenu.Frame:SetAlpha(0)
    eventMenu.Frame:AlphaTo(255, 1)

    eventMenu.Frame:SetDeleteOnClose(false)
    eventMenu.Frame:MakePopup()

    eventMenu.Frame.sheet = eventMenu.Frame:Add("DColumnSheet")
    eventMenu.Frame.sheet:Dock(FILL)
    eventMenu.Frame.sheet:DockMargin(5, 5, 5, 5)

    eventMenu.Frame.musicpanel = eventMenu.Frame.sheet:Add("DPanel")
    eventMenu.Frame.musicpanel:Dock(FILL)
    eventMenu.Frame.musicpanel:DockMargin(10, 10, 10, 10)
    eventMenu.Frame.musicpanel.Paint = function(panel, w, h)
        PaintPanel(panel, w, h)
    end

    eventMenu.Frame.musicplayer = eventMenu.Frame.musicpanel:Add("DScrollPanel")
    eventMenu.Frame.musicplayer:SetSize(0, ScrH() / 1.2)
    eventMenu.Frame.musicplayer:Dock(TOP)

    for k, v in pairs(ix.event.music) do
        CreateCatergory(eventMenu.Frame.musicplayer, k)
        CreateSoundButtons(eventMenu.Frame.musicplayer, ix.event.music[k])
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Conflict Studios")
    local files, dirs = file.Find("sound/interlock/music/custom/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/custom/"..v
        local soundName = string.Replace(v, ".ogg", "")
        soundName = string.Replace(soundName, ".mp3", "")
        soundName = string.Replace(soundName, "_", " ")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Lambda Wars")
    local files, dirs = file.Find("sound/interlock/music/halflife/lw/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/lw/"..v
        local soundName = string.Replace(v, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Black Mesa")
    local files, dirs = file.Find("sound/interlock/music/halflife/bm/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/bm/"..v
        local soundName = string.Replace(v, ".ogg", "")
        soundName = string.Replace(soundName, "bms - ", "")
        soundName = string.Replace(soundName, "bms-", "")
        soundName = string.Replace(soundName, "xen-", "")
        soundName = string.Replace(soundName, "-", " ")
        soundName = string.Replace(soundName, "_", " ")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Half-Life 1")
    local files, dirs = file.Find("sound/interlock/music/halflife/hl1/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/hl1/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Half-Life Alyx")
    local files, dirs = file.Find("sound/interlock/music/halflife/alyx/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/alyx/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Half-Life 2")
    local files, dirs = file.Find("sound/interlock/music/halflife/hl2/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/hl2/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Half-Life 2 Episode 1")
    local files, dirs = file.Find("sound/interlock/music/halflife/ep1/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/ep1/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Half-Life 2 Episode 2")
    local files, dirs = file.Find("sound/interlock/music/halflife/ep2/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/ep2/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    local files, dirs = file.Find("sound/interlock/music/halflife/ep2/misc/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/ep2/misc/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Entropy Zero 1")
    local files, dirs = file.Find("sound/interlock/music/halflife/ez1/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/ez1/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end

    CreateCatergory(eventMenu.Frame.musicplayer, "Entropy Zero 2")
    local files, dirs = file.Find("sound/interlock/music/halflife/ez2/*", "GAME")
    for k, v in pairs(files) do
        local soundFile = "interlock/music/halflife/ez2/"..v
        local soundName = string.Replace(string.sub(v, 3), "-", "")
        soundName = string.Replace(soundName, ".ogg", "")
        CreateSoundButtons(eventMenu.Frame.musicplayer, soundFile, soundName)
    end
    
    eventMenu.Frame.musiccontrol = eventMenu.Frame.musicpanel:Add("DScrollPanel")
    eventMenu.Frame.musiccontrol:Dock(FILL)
    eventMenu.Frame.musiccontrol.Paint = function(panel, w, h)
        PaintPanel(panel, w, h)
    end
    
    eventMenu.Frame.musicstopsound = eventMenu.Frame.musiccontrol:Add("ixMenuButton")
    eventMenu.Frame.musicstopsound:Dock(TOP)
    eventMenu.Frame.musicstopsound:SetSize(0, 30)
    eventMenu.Frame.musicstopsound:SetText("Stop Sound")
    eventMenu.Frame.musicstopsound:SetFont("InterlockFont28")
    eventMenu.Frame.musicstopsound.DoClick = function()
        RunConsoleCommand("stopsound")
    end
    
    eventMenu.Frame.musicstopsoundall = eventMenu.Frame.musiccontrol:Add("ixMenuButton")
    eventMenu.Frame.musicstopsoundall:Dock(TOP)
    eventMenu.Frame.musicstopsoundall:SetSize(0, 30)
    eventMenu.Frame.musicstopsoundall:SetText("Stop Sound All")
    eventMenu.Frame.musicstopsoundall:SetFont("InterlockFont28")
    eventMenu.Frame.musicstopsoundall.DoClick = function()
        RunConsoleCommand("ix_stopsoundall")
    end

    eventMenu.Frame.sheet:AddSheet("Music Player", eventMenu.Frame.musicpanel)

    eventMenu.Frame.ambientpanel = eventMenu.Frame.sheet:Add("DPanel")
    eventMenu.Frame.ambientpanel:Dock(FILL)
    eventMenu.Frame.ambientpanel:DockMargin(10, 10, 10, 10)
    eventMenu.Frame.ambientpanel.Paint = function(panel, w, h)
        PaintPanel(panel, w, h)
    end

    eventMenu.Frame.ambientplayer = eventMenu.Frame.ambientpanel:Add("DScrollPanel")
    eventMenu.Frame.ambientplayer:SetSize(0, ScrH() / 1.2)
    eventMenu.Frame.ambientplayer:Dock(TOP)

    for k, v in pairs(ix.event.ambient) do
        CreateCatergory(eventMenu.Frame.ambientplayer, k)
        CreateSoundButtons(eventMenu.Frame.ambientplayer, ix.event.ambient[k], nil, true)
    end

    eventMenu.Frame.ambientcontrol = eventMenu.Frame.ambientpanel:Add("DScrollPanel")
    eventMenu.Frame.ambientcontrol:Dock(FILL)
    eventMenu.Frame.ambientcontrol.Paint = function(panel, w, h)
        PaintPanel(panel, w, h)
    end
    
    eventMenu.Frame.ambientstopsound = eventMenu.Frame.ambientcontrol:Add("ixMenuButton")
    eventMenu.Frame.ambientstopsound:Dock(TOP)
    eventMenu.Frame.ambientstopsound:SetSize(0, 30)
    eventMenu.Frame.ambientstopsound:SetText("Stop Sound")
    eventMenu.Frame.ambientstopsound:SetFont("InterlockFont28")
    eventMenu.Frame.ambientstopsound.DoClick = function()
        RunConsoleCommand("stopsound")
    end
    
    eventMenu.Frame.ambientstopsoundall = eventMenu.Frame.ambientcontrol:Add("ixMenuButton")
    eventMenu.Frame.ambientstopsoundall:Dock(TOP)
    eventMenu.Frame.ambientstopsoundall:SetSize(0, 30)
    eventMenu.Frame.ambientstopsoundall:SetText("Stop Sound All")
    eventMenu.Frame.ambientstopsoundall:SetFont("InterlockFont28")
    eventMenu.Frame.ambientstopsoundall.DoClick = function()
        RunConsoleCommand("ix_stopsoundall")
    end

    eventMenu.Frame.sheet:AddSheet("Ambient Player", eventMenu.Frame.ambientpanel)

    hook.Add("Think", "ixEventMenuPressedSpace", function()
        if input.IsKeyDown(KEY_SPACE) and !keyDown then
            eventMenu.Frame.playsound.DoClick()
            keyDown = true
            timer.Simple(0.4, function() keyDown = false end)
        end
    end)

    eventMenu.Frame.soundplayer = eventMenu.Frame.sheet:Add("DScrollPanel")
    eventMenu.Frame.soundplayer:Dock(FILL)
    eventMenu.Frame.soundplayer:DockMargin(10, 10, 10, 10)

    eventMenu.Frame.soundtree = eventMenu.Frame.soundplayer:Add("DTree")
    eventMenu.Frame.soundtree:Dock(TOP)
    eventMenu.Frame.soundtree:SetSize(0, ScrH() / 1.3)
    eventMenu.Frame.soundtree.Paint = function(panel, w, h)
        PaintPanel(panel, w, h)
    end
    
    eventMenu.Frame.playsound = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.playsound:Dock(TOP)
    eventMenu.Frame.playsound:SetSize(0, 30)
    eventMenu.Frame.playsound:SetText("Play Sound")
    eventMenu.Frame.playsound:SetFont("ixSmallFont")
    
    eventMenu.Frame.stopsound = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.stopsound:Dock(TOP)
    eventMenu.Frame.stopsound:SetSize(0, 30)
    eventMenu.Frame.stopsound:SetText("Stop Sound")
    eventMenu.Frame.stopsound:SetFont("ixSmallFont")
    
    eventMenu.Frame.copyfile = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.copyfile:Dock(TOP)
    eventMenu.Frame.copyfile:SetSize(0, 30)
    eventMenu.Frame.copyfile:SetText("Copy Filepath")
    eventMenu.Frame.copyfile:SetFont("ixSmallFont")
    
    eventMenu.Frame.refreshlist = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.refreshlist:Dock(TOP)
    eventMenu.Frame.refreshlist:SetSize(0, 30)
    eventMenu.Frame.refreshlist:SetText("Refresh List")
    eventMenu.Frame.refreshlist:SetFont("ixSmallFont")
    
    eventMenu.Frame.playtoall = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.playtoall:Dock(TOP)
    eventMenu.Frame.playtoall:SetSize(0, 30)
    eventMenu.Frame.playtoall:SetText("Play to all")
    eventMenu.Frame.playtoall:SetFont("ixSmallFont")
    
    eventMenu.Frame.stopsoundall = eventMenu.Frame.soundplayer:Add("ixMenuButton")
    eventMenu.Frame.stopsoundall:Dock(TOP)
    eventMenu.Frame.stopsoundall:SetSize(0, 30)
    eventMenu.Frame.stopsoundall:SetText("Stop Sound all")
    eventMenu.Frame.stopsoundall:SetFont("ixSmallFont")

    eventMenu.Frame.soundtreenode = eventMenu.Frame.soundtree:AddNode("sound")
    eventMenu.Frame.soundtreenode.dir  = "sound/"
    eventMenu.Frame.soundtreenode.gen = false
    
    local function FindSounds(node, dir)
        local files, dirs = file.Find(dir.."*", "GAME")
    
        for _, v in pairs(dirs) do
            local newNode = node:AddNode(v)
            newNode.dir = dir..v
            newNode.gen = false
        
            newNode.DoClick = function()
                if !newNode.gen then
                    FindSounds(newNode, dir..v.."/")
                    newNode.gen = true
                end
            end
        end

        local function GenerateNodes()
            local fileCount = 0

            for k, v in pairs(files) do
                if fileCount > fileLimit then break end
                local format = string.sub(v, -4)
                if format and table.HasValue(formats, format) then
                    fileCount = fileCount + 1

                    local newNode = node:AddNode(v)
                    newNode.file   = v
                    newNode.dir    = dir
                    newNode.IsFile = true
                    newNode.format = format
                    newNode.Icon:SetImage("icon16/sound.png")

                    files[k] = ""
                end
            end
        
            if fileCount > fileLimit then
                local newNode = node:AddNode("Click to load more files...")
                newNode.Icon:SetImage("icon16/sound_add.png")
                newNode.DoClick = function() 
                    newNode:Remove()
                    GenerateNodes()
                end
            end
        end
        GenerateNodes()
    end
    FindSounds(eventMenu.Frame.soundtreenode, "sound/")

    eventMenu.Frame.playsound.DoClick = function()
        local item = eventMenu.Frame.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        RunConsoleCommand("play", file)
    end

    eventMenu.Frame.stopsound.DoClick = function()
        RunConsoleCommand("stopsound")
    end

    eventMenu.Frame.copyfile.DoClick = function()
        local item = eventMenu.Frame.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        SetClipboardText(file)
    end

    eventMenu.Frame.refreshlist.DoClick = function()
        eventMenu.Frame.soundtreenode:Remove()
        eventMenu.Frame.soundtreenode = eventMenu.Frame.soundtree:AddNode("sound")
        eventMenu.Frame.soundtreenode.dir  = "sound/"
        eventMenu.Frame.soundtreenode.gen = false
    
        FindSounds(eventMenu.Frame.soundtreenode, "sound/")
    end

    eventMenu.Frame.playtoall.DoClick = function()
        local item = eventMenu.Frame.soundtree:GetSelectedItem()
        if !item or !item.IsFile then return end
        local file = string.sub(item.dir, 7)..item:GetText()
        timer.Simple(0.1, function()
            RunConsoleCommand("ix_playsoundall", file)
        end)
        ix.util.Notify("Played "..tostring(file).." to all players!")
    end

    eventMenu.Frame.stopsoundall.DoClick = function()
        RunConsoleCommand("ix_stopsoundall")
    end

    eventMenu.Frame.sheet:AddSheet("Sound Player", eventMenu.Frame.soundplayer)

    eventMenu.Frame.OnClose = function()
        hook.Remove("Think", "ixEventMenuPressedSpace")
    end 
end

concommand.Add("ix_soundmenu", OpenEventMenu)