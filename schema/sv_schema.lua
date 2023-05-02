--[[---------------------------------------------------------------------------
    Serverside Functions
---------------------------------------------------------------------------]]--

local irt_data = {
    [CLASS_D_1_GRUNT] = {
        "models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl", -- Model
        100, -- Armor/MaxArmor
        1.05 -- Model Scale
    },
    [CLASS_D_2_SUPPRESSOR] = {
        "models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl",
        150,
        1.1
    },
    [CLASS_D_3_CHARGER] = {
        "models/cultist/hl_a/combine_heavy/npc/combine_heavy_trooper.mdl",
        300,
        1.2
    },
    [CLASS_D_4_ORDINAL] = {
        "models/cultist/hl_a/combine_commander/npc/combine_commander.mdl",
        175,
        1.05
    },
    [CLASS_D_5_CAPTAIN] = {
        "models/captain/hl_a/combine_commander/npc/combine_commander.mdl",
        200,
        1.05
    },
}

function Schema:SetupOTA(ply, char)
    if not ( IsValid(ply) and ply:IsPlayer() ) then return end
    if not ( char ) then return end

    if ( ply:Team() == FACTION_OTA and char:GetFaction() == FACTION_OTA ) then
        local data = irt_data[char:GetClass()]

        if not ( data ) then return end

        char:SetModel(data[1])
        ply:SetModel(data[1])
        ply:SetMaxArmor(data[2])
        ply:SetArmor(data[2])
        ply:SetModelScale(data[3], 0)
    end
end

function Schema:UpdateHeight(ply, char)
    if not ( char ) then
        char = ply:GetCharacter()
    end

    if ( IsValid(ply) and char ) then
        if ( char:GetHeight() and Schema.heights[char:GetHeight()] ) then
            ply:SetModelScale(Schema.heights[char:GetHeight()], 0)
            ply:SetViewOffset(Vector(0, 0, 66 * Schema.heights[char:GetHeight()]))
            ply:SetViewOffsetDucked(Vector(0, 0, 32 * Schema.heights[char:GetHeight()]))
        else
            ply:SetModelScale(1, 0)
            ply:SetViewOffset(Vector(0, 0, 66))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
        end
    end
end

function Schema:SearchPlayer(ply, target)
    if not ( target:GetCharacter() or target:GetCharacter():GetInventory() ) then
        return false
    end

    local name = hook.Run("GetDisplayedName", target) or target:Name()
    local inventory = target:GetCharacter():GetInventory()

    ix.storage.Open(ply, inventory, {
        entity = target,
        name = name
    })

    return true
end

local rebelNPCs = {
    ["npc_citizen"] = true,
    ["npc_vortigaunt"] = true,
}
local combineNPCs = {
    ["npc_cscanner"] = true,
    ["npc_stalker"] = true,
    ["npc_clawscanner"] = true,
    ["npc_turret_floor"] = true,
    ["npc_combine_camera"] = true,
    ["npc_metropolice"] = true,
    ["npc_combine_s"] = true,
    ["npc_sniper"] = true,
    ["npc_manhack"] = true,
    ["npc_rollermine"] = true,
    ["npc_strider"] = true,
    ["npc_hunter"] = true,
    ["npc_combinegunship"] = true,
    ["npc_combinedropship"] = true,
    ["npc_helicopter"] = true,
}
function Schema:UpdateRelationShip(ent)
    for k, v in pairs(player.GetAll()) do
        if ( v:IsCombine() or v:IsDispatch() ) then
            if ( combineNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            elseif ( rebelNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_HT, 99)
            end
        else
            if ( combineNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_HT, 99)
            elseif ( rebelNPCs[ent:GetClass()] ) then
                ent:AddEntityRelationship(v, D_LI, 99)
            end
        end
    end
end

util.AddNetworkString("ixPanicNotify")

local workshop_items = engine.GetAddons()

for i = 1, #workshop_items do
    local addon_id = workshop_items[i].wsid

    resource.AddWorkshop(addon_id)
end

function Schema:PlayerSpawnVehicle(ply, mdl, name, data)
    local char = ply:GetCharacter()

	if ( char ) then
		if ( data.Category == "Chairs" ) then
			return char:HasFlags( "c" )
		end

		return char:HasFlags( "C" )
	end

	return false
end
