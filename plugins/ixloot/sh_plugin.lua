local PLUGIN = PLUGIN

PLUGIN.name = "Improved Loot Containers"
PLUGIN.descriptions = "Adds Improved Loot Containers which can be easily configured."
PLUGIN.author = "Riggs.mackay"

CAMI.RegisterPrivilege({
    Name = "Helix - Manage Loot Containers",
    MinAccess = "admin"
})

ix.loot = ix.loot or {}
ix.loot.containers = ix.loot.containers or {}

ix.loot.containers = {
    ["drawer"] = {
        id = "drawer",
        name = "Drawer",
        description = "A small drawer.",
        model = "models/wn7new/advcrates/n7_drawer.mdl",
        delay = 300, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5, 6}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = {
            "crafting_glass",
            "crafting_nails_screws",
            "crafting_plastic",
            "crafting_rubber_natural",
            "crafting_electronics",
            "crafting_metal",
            "crafting_metalingot",
            "tool_wrench",
            "tool_scissors",
            "tool_flashlight",
            "junk_green_bottle",
            "junk_tincan",
            "junk_jar",
        },
        rareItems = {
            "junk_jar",
        },
        onStart = function(ply, ent) -- when you press e on the container
            ent:ResetSequence("locker_open_seq")
            ent:EmitSound("doors/metal_move1.wav", nil, 80)
            timer.Simple(1.2, function()
                ent:EmitSound("doors/metal_stop1.wav", nil, 80)
            end)
        end,
        onEnd = function(ply, ent) -- when you finished looting the container
            ent:ResetSequence("locker_close_seq")
            ent:EmitSound("doors/metal_move1.wav", nil, 80)
            timer.Simple(1.2, function()
                ent:EmitSound("doors/metal_stop1.wav", nil, 80)
            end)
        end,
    },
    ["infestationCrate"] = {
        id = "infestationCrate",
        name = "Infestation Control Crate",
        description = "A crate containing infestation control resources.",
        model = "models/wn7new/advcrates/n7_container.mdl",
        delay = 360, -- time in seconds before it can be looted again
        lootTime = {3, 4, 5}, -- can be a table for random time, example: lootTime = {2, 5, 7, 8, 10},
        maxItems = {1, 2, 3}, -- how many items can be in the container
        items = {
            "medical_syringe",
            "junk_receiver",
            "junk_coffeecup",
            "junk_lamp",
            "tool_sovietfilter",
            "writing_notepad",
            "crafting_adhesive",
            "crafting_rubber_synthetic",
            "crafting_stiched_cloth",
            "crafting_cloth",
            "crafting_charcoal",
        },
        rareItems = {
            "junk_jar",
        },
        onStart = function(ply, ent) -- when you press e on the container
            ent:ResetSequence("locker_open_seq")
            ent:EmitSound("doors/metal_move1.wav", nil, 80)
            timer.Simple(1.2, function()
                ent:EmitSound("doors/metal_stop1.wav", nil, 80)
            end)
        end,
        onEnd = function(ply, ent) -- when you finished looting the container
            ent:ResetSequence("locker_close_seq")
            ent:EmitSound("doors/metal_move1.wav", nil, 80)
            timer.Simple(1.2, function()
                ent:EmitSound("doors/metal_stop1.wav", nil, 80)
            end)
        end,
    },
}

properties.Add("loot_setclass", {
    MenuLabel = "Set Loot Class",
    MenuIcon = "icon16/wrench.png",
    Order = 5,

    Filter = function(self, ent, ply)
        if not ( IsValid(ent) and ent:GetClass() == "ix_loot_container" ) then return false end

        return CAMI.PlayerHasAccess(ply, "Helix - Manage Loot Containers", nil)
    end,

    Action = function(self, ent)
    end,

    LootClassSet = function(self, ent, class)
        self:MsgStart()
            net.WriteEntity(ent)
            net.WriteString(class)
        self:MsgEnd()
    end,

    MenuOpen = function(self, option, ent, trace)
        local subMenu = option:AddSubMenu()

        for k, v in SortedPairs(ix.loot.containers) do
            subMenu:AddOption(v.name.." ("..k..")", function()
                self:LootClassSet(ent, k)
            end)
        end
    end,

    Receive = function(self, len, ply)
        local ent = net.ReadEntity()

        if not ( IsValid(ent) ) then return end
        if not ( self:Filter(ent, ply) ) then return end

        local class = net.ReadString()
        local loot = ix.loot.containers[class]

        -- safety check, just to make sure if it really exists in both realms.
        if not ( class or loot ) then
            ply:Notify("You did not specify a valid container class!")
            return
        end

        ent:SetContainerClass(tostring(class))
        ent:SetModel(loot.model)
        ent:PhysicsInit(SOLID_VPHYSICS) 
        ent:SetSolid(SOLID_VPHYSICS)
        ent:SetUseType(SIMPLE_USE)
        ent:DropToFloor()
    end
})

if ( SERVER ) then
    function PLUGIN:SaveData()
        local data = {}
    
        for _, v in pairs(ents.FindByClass("ix_loot_container")) do
            data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel(), v:GetContainerClass()}
        end
    
        ix.data.Set("lootContainer", data)
    end

    function PLUGIN:LoadData()
        for _, v in pairs(ix.data.Get("lootContainer")) do
            local lootContainer = ents.Create("ix_loot_container")
            lootContainer:SetPos(v[1])
            lootContainer:SetAngles(v[2])
            lootContainer:SetModel(v[3])
            lootContainer:SetContainerClass(v[4])
            lootContainer:Spawn()
        end
    end
end