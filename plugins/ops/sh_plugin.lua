local PLUGIN = PLUGIN

PLUGIN.name = "OPS"
PLUGIN.description = ""
PLUGIN.author = "Riggs.mackay"

ix.ops = ix.ops or {}
ix.ops.eventManager = ix.ops.eventManager or {}
ix.ops.eventManager.sequences = ix.ops.eventManager.sequences or {}
ix.ops.eventManager.scenes = ix.ops.eventManager.scenes or {}
ix.ops.eventManager.data = ix.ops.eventManager.data or {}
ix.ops.eventManager.config = ix.ops.eventManager.config or {}
ix.ops.staffManager = ix.ops.staffManager or {}

file.CreateDir("helix/"..Schema.folder.."/ops/eventmanager")

ix.lang.AddTable("english", {
    optAdmin_onduty = "Moderator on duty",
    optdAdmin_onduty = "(DO NOT LEAVE UNTICKED FOR A LONG TIME)",
    optAdmin_reportalpha = "Report menu fade alpha",
    optAdmin_esp = "Observer ESP enabled",
    optAdmin_showgroup = "Show player groups",
})

ix.option.Add("admin_onduty", ix.type.bool, false, {
    category = PLUGIN.name,
    default = true,
})

ix.option.Add("admin_reportalpha", ix.type.number, 130, {
    category = PLUGIN.name,
    min = 0,
    max = 255,
    decimals = 1,
    default = 130,
})

ix.option.Add("admin_esp", ix.type.bool, false, {
    category = PLUGIN.name,
    default = true,
})

ix.option.Add("admin_showgroup", ix.type.bool, true, {
    category = PLUGIN.name,
    default = true,
})

if ( SERVER ) then
    function PLUGIN:PlayerNoClip(ply, state)
        if ( ply:IsAdmin() ) then
            if ( state ) then
                if ply:FlashlightIsOn() then
                    ply:Flashlight(false)
                end

                ply:AllowFlashlight(false)
            else
                ply:AllowFlashlight(true)
            end
        end
    end

    function PLUGIN:PrePlayerMessageSend(ply, chatType, message, bAnonymous)
        if ( ply:GetNetVar("ixOOCBanned") == true ) and ( chatType == "ooc" ) then
            ply:Notify("You are banned from out of character chat!")
            return false
        end
    end

    function PLUGIN:PlayerInitialSpawn(ply, char)
        ply:SetReports(ply:GetPData("ixReports", 0))
    end

    util.AddNetworkString("ixOpsSMOpen")
    function ix.ops.staffManager.Open(ply)
        net.Start("ixOpsSMOpen")
        net.Send(ply)
    end
end

ix.util.IncludeDir(PLUGIN.folder.."/include", true)
ix.util.Include("cl_plugin.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_util.lua")
ix.util.Include("sv_plugin.lua")