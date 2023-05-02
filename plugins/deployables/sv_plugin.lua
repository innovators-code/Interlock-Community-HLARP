local PLUGIN = PLUGIN

local function createHopper(ply)
    local ent = ents.Create("ix_hopper")
    ent:SetPos(ply:EyePos() + ply:EyeAngles():Forward() * 32)
    ent:Spawn()

    Schema:AddDisplay("Updating Deployable Data...", Color(255, 100, 255, 255))
end
function PLUGIN:DeployHopper(ply)
    if ( ply:Team() == FACTION_CP ) then
        ply:ForceSequence("deploy", createHopper(ply))
    elseif ( ply:Team() == FACTION_OTA ) then
        ply:ForceSequence("Turret_Drop", createHopper(ply))
    else
        ply:ForceSequence("ThrowItem", createHopper(ply))
    end
end

local function createManhack(ply)
    local ent = ents.Create("npc_manhack")
    ent:SetKeyValue("spawnflags", "65536")
    ent:SetPos(ply:EyePos() + ply:EyeAngles():Forward() * 10)
    ent:Spawn()
    ent:Fire("Unpack", "", 0)
        
    for k, v in ipairs(player.GetAll()) do
        if ( v:IsCombine() ) then
            ent:AddEntityRelationship(v, D_LI, 99)
        end
    end

    Schema:AddDisplay("Updating Deployable Data...", Color(255, 100, 255, 255))

    timer.Simple(60, function()
        if ( IsValid(ent) ) then
            ent:Fire("InteractivePowerDown", "", 0)
        end
    end)
end
function PLUGIN:DeployManhack(ply)
    if ( ply:Team() == FACTION_CP ) then
        ply:ForceSequence("deploy", createManhack(ply))
    elseif ( ply:Team() == FACTION_OTA ) then
        ply:ForceSequence("Turret_Drop", createManhack(ply))
    else
        ply:ForceSequence("ThrowItem", createManhack(ply))
    end
end

function PLUGIN:CanPlayerHoldObject(ply, ent)
    if ( ent:GetClass() == "ix_hopper" and ent:GetState() == 0 ) then
        return true
    elseif ( ent:GetClass() == "npc_floor_turret" ) then
        return true
    end
end