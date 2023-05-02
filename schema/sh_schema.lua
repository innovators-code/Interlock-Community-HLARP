--[[---------------------------------------------------------------------------
    Schema Information
---------------------------------------------------------------------------]]--

Schema.name = "Half-Life: Alyx Roleplay"
Schema.description = "A server set in the Half-Life Alyx storyline."
Schema.author = "Riggs.mackay"
Schema.developers = "Riggs.mackay and Skay"
Schema.adminTeam = {
    "Echoloveation",
    "Overwatch",
}
Schema.supportTeam = {
    "Bor3d", -- Active Beta Tester
    "Lee West", -- Active Beta Tester
    "Mellish", -- Active Beta Tester
    "BreadGaming", -- Active Beta Tester
    "Skay", -- Developer & Code Assist
    "Scotnay", -- Developer & Code Assist
    "Mike White", -- UI Designer
}
Schema.build = "Beta"
Schema.version = "1.0.0"

Schema.changelogs = {
    ["Update 1.0.0"] = {
        "Server Launch",
    }
}

if ( vrmod and CLIENT ) then
    vrmod.AddInGameMenuItem("Helix Menu", 1, 1, function()
        if ( IsValid(LocalPlayer()) and LocalPlayer():Alive() and LocalPlayer():GetCharacter() ) then
            if ( IsValid(ix.vrmenu) ) then
                ix.vrmenu:Remove()
                ix.vrmenu = nil
            else
                ix.vrmenu = vgui.Create("ixMenu")
            end
        end
    end)

    vrmod.AddInGameMenuItem("Helix Chat", 2, 2, function()
        if ( IsValid(LocalPlayer()) and LocalPlayer():Alive() and LocalPlayer():GetCharacter() ) then
            if ( IsValid(ix.vrchat) ) then
                ix.vrchat:Remove()
                ix.vrchat = nil
            else
                ix.vrchat = vgui.Create("ixChatbox")
                ix.vrchat:SetupTabs(util.JSONToTable(ix.option.Get("chatTabs", "")))
                ix.vrchat:SetupPosition(util.JSONToTable(ix.option.Get("chatPosition", "")))
            end
        end
    end)

    hook.Add("VRMod_Input", "ixVRModInput", function(ActionName, State)
        if ( vrmod.IsPlayerInVR(LocalPlayer()) ) and ( tostring(ActionName) == "boolean_secondaryfire" ) then
            gui.InternalMousePressed(MOUSE_RIGHT)
        end
    end)
end

--[[---------------------------------------------------------------------------
    Schema Config
---------------------------------------------------------------------------]]--

ix.entities = ix.entities or {}
ix.entities.ID = ix.entities.ID or {}

ix.currency.symbol = "T"
ix.currency.singular = "token"
ix.currency.plural = "tokens"
ix.currency.model = "models/token/old_token.mdl"

ix.attributes.list["end"] = nil
ix.attributes.list["stm"] = nil
ix.attributes.list["str"] = nil

ix.config.Add("rationInterval", 300, "How long a person needs to wait in seconds to get their next ration", nil, {
    data = {min = 0, max = 86400},
    category = "economy"
})

ix.config.Add("gruntDamageScale", true, "Enable the Infestation Respone Team Damage Multiplier.", nil, {
    category = "damage"
})

ix.config.Add("generalDamageScale", true, "Enable the general Damage Multiplier.", nil, {
    category = "damage"
})

ix.config.SetDefault("color", Color(200, 50, 255))
ix.config.SetDefault("gruntDamageScale", true)
ix.config.SetDefault("generalDamageScale", true)
ix.config.SetDefault("font", "Russell Square")
ix.config.SetDefault("genericFont", "Roboto")
ix.config.SetDefault("music", "interlock/music/halflife/alyx/misc/mainmenu.ogg")

ix.config.SetDefault("communityText", "Discord")
ix.config.SetDefault("communityURL", "https://discord.gg/h6pezHJkh5")

ix.act.Register("Knock", "metrocop", {
    sequence = "adoorknock",
    untimed = true
})

ix.flag.Add("V", "Access to voice chat.")
ix.flag.Add("P", "Access to PAC3.")

Schema.cities = {}

for i = 1, 9 do
    table.insert(Schema.cities, "City 0"..i)
end

for i = 10, 100 do
    table.insert(Schema.cities, "City "..i)
end

Schema.heights = {
    ["4'0"] = 0.80,
    ["4'2"] = 0.82,
    ["4'4"] = 0.84,
    ["4'6"] = 0.86,
    ["4'8"] = 0.88,
    ["4'10"] = 0.90,
    ["4'12"] = 0.92,
    ["5'0"] = 0.94,
    ["5'2"] = 0.96,
    ["5'4"] = 0.98,
    ["5'6"] = 1.00,
    ["5'8"] = 1.02,
    ["5'10"] = 1.04,
    ["5'12"] = 1.06,
    ["6'0"] = 1.08,
    ["6'2"] = 1.10,
    ["6'4"] = 1.12,
    ["6'6"] = 1.14,
    ["6'8"] = 1.16,
    ["6'10"] = 1.18,
    ["6'12"] = 1.20,
}

ALWAYS_RAISED["swep_construction_kit"] = true
ALWAYS_RAISED["ix_adminstick"] = true

--[[---------------------------------------------------------------------------
    Schema Includes
---------------------------------------------------------------------------]]--

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.IncludeDir("hooks")
ix.util.IncludeDir("meta")
ix.util.IncludeDir("voices")
ix.util.IncludeDir("data")
ix.util.IncludeDir("commands")

function Schema:IllegalRow(tooltip)
    local warning = tooltip:AddRow("warning")
    warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
    warning:SetText("// THIS ITEM IS ILLEGAL TO CARRY AROUND, FOUND WITH THIS ITEM CAN CAUSE VIOLATIONS BY UU AUTHORITIES //")
    warning:SetFont("BudgetLabel")
    warning:SetExpensiveShadow(0.5)
    warning:SizeToContents()
end

function Schema:ZeroNumber(number, length)
    local amount = math.max(0, length - string.len(number))
    return string.rep("0", amount)..tostring(number)
end

function Schema:EaseLerp(fraction, from, to)
    return Lerp(math.ease.InSine(fraction), from, to)
end

function Schema:DispatchActive()
    for k, v in ipairs(player.GetAll()) do
        if not ( IsValid(v) or v:GetCharacter() ) then
            continue
        end

        if not ( v:IsDispatch() ) then
            return false
        end
        
        return true
    end
end

function Schema:InitPostEntity()
    local toolgun = weapons.GetStored("gmod_tool") -- uhh? I guess make it an arg?

    if not ( istable(toolgun) ) then return end

    function toolgun:DoShootEffect(hitpos, hitnorm, ent, physbone, predicted)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)

        return false
    end
end

function string.Count(str, char)
    local n = 0
    for _ in string.gmatch(str, char) do
        n = n + 1
    end
    
    return n
end


local gunshots = file.Find( "sound/weapons/rust_distant/*", "GAME" )
local mp3s = file.Find( "sound/weapons/rust_mp3/*.mp3", "GAME" )
local wavs = file.Find( "sound/weapons/rust/*.wav", "GAME" )

for i=1, #mp3s do
    local snd = string.sub(mp3s[i],1,-5)
    sound.Add(
        {
            name = "darky_rust."..snd,
            channel = CHAN_STATIC,
            volume = 1.0,
            soundlevel = 180,
            sound = "weapons/rust_mp3/"..snd..".mp3"
        }
    )	
end

for i=1, #wavs do
    local snd = string.sub(wavs[i],1,-5)
    sound.Add(
        {
            name = "darky_rust."..snd,
            channel = CHAN_STATIC,
            volume = 1.0,
            soundlevel = 180,
            sound = "weapons/rust/"..snd..".wav"
        }
    )	
end

for i=1, #gunshots do
    local snd = string.sub(gunshots[i],1,-5)
    sound.Add(
        {
            name = "darky_rust."..snd,
            channel = CHAN_STATIC,
            volume = 15.0,
            soundlevel = 511,
            sound = "^weapons/rust_distant/"..snd..".mp3"
        }
    )	
end