--[[---------------------------------------------------------------------------
    Serverside Hooks
---------------------------------------------------------------------------]]--

function Schema:PlayerConnect(name, ip)
    for k, v in pairs(player.GetAll()) do
    	if ( v:IsAdmin() ) then 
            v:ChatNotify(tostring(name).." is joining the Server! (Admin only)")
    	end
    end
    print(tostring(name).." is joining the Server! - ["..tostring(ip).."]")
end

local geneCodedWeapons = {
    ["pulse_minigun"] = true,
    ["pulse_rifle"] = true,
    ["pulse_shotgun"] = true,
    ["pulse_smg"] = true
}

function Schema:CanPlayerEquipItem(ply, item)
    if ( geneCodedWeapons[item.uniqueID] ) then
        if not ( ply:Team() == FACTION_OTA ) then
            ply:Notify("<:: ERROR: DNA Violation! Individual is not permitted for the use of this firearm! ::>")
            return false
        else
            return true
        end
    end
end

local takeoutSounds = {
    ["ls_usp"] = "weapons/357/357_reload3.wav",
}
function Schema:PlayerSwitchWeapon(ply, oldWep, newWep)
    if ( takeoutSounds[newWep:GetClass()] ) then
        if ( ix.clockworkAnims:GetModelClass(ply:GetModel()) == "metrocop" ) then
            ply:ForceSequence("drawpistol", nil, 0.6, true)
        elseif ( ix.clockworkAnims:GetModelClass(ply:GetModel()) == "citizen_male" ) then
            ply:ForceSequence("smgdraw", nil, 0.8, true)
        end
        ply:EmitSound(takeoutSounds[newWep:GetClass()], 70, 80, 0.6)
    end
end

function Schema:InitializedSchema()
    SetGlobalBool("conflict_devmode", (ix.data.Get("developmentMode", false)))

    for k, v in pairs(ents.FindByModel("models/props_interiors/VendingMachineSoda01a.mdl")) do
        if ( v:GetClass() == "prop_physics" or v:GetClass() == "ix_vendingmachine" ) then
            return
        end

        local pos = v:GetPos()
        local angs = v:GetAngles()

        SafeRemoveEntity(v)

        local replacement = ents.Create("ix_vendingmachine")
        replacement:SetPos(pos)
        replacement:SetAngles(angs)
        replacement:Spawn()
        replacement:PhysicsInit(SOLID_VPHYSICS)
        replacement:SetSolid(SOLID_VPHYSICS)
        if ( IsValid(replacement) ) then
            local phys = replacement:GetPhysicsObject()

            if ( IsValid(phys) ) then
                phys:EnableMotion(true)
            end
        end
    end
end

function Schema:DoPlayerDeath(ply)
    ply.ixDeathPos = ply:GetPos()
    ply.ixDeathAngles = ply:GetAngles()
    ply:SetRestricted(false)
end

function Schema:OnNPCKilled( npc, attack, wep )
    local pos = npc:GetPos()
    local ang = npc:GetAngles()
    local mod = npc:GetModel()
    if ( attack:IsNPC() ) then
        if ( attack:GetClass() == "npc_headcrab" ) then
            local zomb = ents.Create("npc_zombie")
            zomb:SetPos(npc:GetPos())
            zomb:SetAngles(npc:GetAngles())
            zomb:SetModel(mod)
            zomb:Spawn()
            zomb:Activate()
        elseif ( attack:GetClass() == "npc_headcrab_fast" ) then
            local zombfast = ents.Create("npc_fastzombie")
            zombfast:SetPos(pos)
            zombfast:SetAngles(ang)
            zombfast:SetModel(mod)
            zombfast:Spawn()
            zombfast:Activate()
        end
    end
end

function Schema:PlayerSpawn(ply)
    timer.Simple(1, function()
        for k, v in ipairs(ents.FindByClass("ix_campfire")) do
            v:StopFire()
            v:StartFire()
        end
    end)
end

function Schema:PlayerDeath(ply, wep, attacker)
    local pos = ply:GetPos()
    local ang = ply:GetAngles()
    if ( attacker:IsNPC() ) then
        if ( attacker:GetClass() == "npc_headcrab" ) then
            local zomb = ents.Create("npc_zombie")
            zomb:SetPos(pos)
            zomb:SetAngles(ang)
            zomb:Spawn()
            zomb:Activate()
            ply:Notify("A headcrab has attached to your head and you lost control of your body.")
        elseif ( attacker:GetClass() == "npc_headcrab_fast" ) then
            local zombfast = ents.Create("npc_fastzombie")
            zombfast:SetPos(pos)
            zombfast:SetAngles(ang)
            zombfast:Spawn()
            zombfast:Activate()
            ply:Notify("A headcrab has attached to your head and you lost control of your body.")
        end
    end
end

function Schema:PlayerHurt(ply, attacker, hp, dmg)
    if ( IsValid(attacker) and attacker:IsPlayer() and attacker:Alive() ) then
        local direction = attacker:GetAimVector() * dmg * 10
        direction.z = 0
        ply:SetVelocity(direction)
    end
end

local function setupStoof(ply, char)
    if not ( IsValid(ply) and char ) then return end

    for k, v in pairs(ents.GetAll()) do
        if ( v:IsNPC() ) then
            Schema:UpdateRelationShip(v)
        end
    end
    Schema:UpdateHeight(ply)
    Schema:SetupOTA(ply, char)

    ply:SetupHands()
end
function Schema:PlayerLoadedCharacter(ply, char, oldChar)
    setupStoof(ply, char)
end

function Schema:PlayerLoadout(ply)
    setupStoof(ply, ply:GetCharacter())
end

function Schema:PlayerJoinedClass(ply, class, oldClass)
    setupStoof(ply, ply:GetCharacter())
end

local dmg_vals = {
	[HITGROUP_HEAD] = 2,
	[HITGROUP_CHEST] = 0.975,
	[HITGROUP_STOMACH] = 0.975,
	[HITGROUP_LEFTARM] = 1.05,
	[HITGROUP_RIGHTARM] = 1.05,
	[HITGROUP_LEFTLEG] = 1.15,
	[HITGROUP_RIGHTLEG] = 1.15,
	[HITGROUP_GEAR] = 0,
}

function Schema:ScalePlayerDamage(ply, hitgroup, dmginfo)
    local char = ply:GetCharacter()
    local attacker = dmginfo:GetAttacker()
    local awep = attacker:GetActiveWeapon()

    if ( IsValid(attacker) and attacker:IsNPC() ) then
        dmginfo:ScaleDamage(0.25)
    end

    if ( hitgroup == HITGROUP_HEAD ) then
        ix.event.PlaySound(attacker, {
            sound = "weapons/rust_mp3/head.wav",
            volume = 0.5,
            pitch = 100,
            db = 80,
        })

        ply:EmitSound("weapons/rust_mp3/head.wav", 80, 100, 0.5)

        if ( IsValid(awep) ) then
            if ( awep.Primary.HeadshotDamage ) then
                dmginfo:SetDamage(awep.Primary.HeadshotDamage / 2)
            else
                dmginfo:SetDamage(awep.Primary.Damage * 2)
            end
        end
    end

    if ( ix.config.Get("generalDamageScale") ) then
		dmginfo:ScaleDamage(dmg_vals[hitgroup] or 1)
    end

    if ( ix.config.Get("gruntDamageScale") ) then
        if ( IsValid(attacker) and ( attacker:IsPlayer() or attacker:IsNPC() ) ) then
            if ( ply:Team() == FACTION_OTA ) then
                if not ( ply:Armor() == 0 ) then
                    dmginfo:ScaleDamage(0.8)
                end
            elseif ( ply:GetModel():find("combine_heavy_trooper") ) then
                if not ( ply:Armor() == 0 ) then
                    dmginfo:ScaleDamage(0.3)
                else
                    dmginfo:ScaleDamage(0.7)
                end
            end
        end
    end
end

function Schema:ScaleNPCDamage(npc, hitgroup, dmginfo)
    local attacker = dmginfo:GetAttacker()
    local awep = attacker:GetActiveWeapon()

    if ( hitgroup == HITGROUP_HEAD ) then
        if ( IsValid(awep) ) then
            if ( awep.Primary.HeadshotDamage ) then
                dmginfo:SetDamage(awep.Primary.HeadshotDamage / 2)
            else
                dmginfo:SetDamage(awep.Primary.Damage * 2)
            end
        end
    end
end

function Schema:GetPlayerPunchDamage(ply, damage, context)
    if ( ply:GetModel():find("combine_heavy_trooper") ) then
        return 100
    elseif ( ply:GetModel():find("combine_suppresor") ) then
        return 20
    end
end

function Schema:PlayerUseDoor(ply, door)
    if ( door:GetClass() == "func_door" ) and ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() ) then
        if not ( door:HasSpawnFlags(256) or door:HasSpawnFlags(1024) ) then
            ply:SetAction("Opening...", 1)
            ply:DoStaredAction(door, function()
                door:Fire("open")
                door:EmitSound("buttons/combine_button1.wav")
            end, 1)
        end
    end
end

function Schema:PlayerStaminaLost(ply)
    ply.ixOutBreath = true
    ply:AddDisplay("attention: excessive user exertion, administering stimulant...", Color(255, 255, 0))
end

function Schema:PlayerStaminaGained(ply)
    ply.ixOutBreath = nil
    ply:AddDisplay("stimulant administered", Color(0, 255, 0))
end

local walkSpeed = 90
local runSpeed = 180
local walkPenalty = 0
local runPenalty = 0
function Schema:Move(ply, mv)
    local char = ply:GetCharacter()
    if not ( IsValid(ply) and char ) then return end

    if ( ply:Team() == FACTION_BIRD ) then
        ply:SetWalkSpeed(25)
        ply:SetRunSpeed(50)
        return
    end

    if ( ply.ixOutBreath ) or ( IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "ix_stunstick" and ply:GetActiveWeapon():GetMode() == 3 and ply:GetNWBool("ixStunModeActive") ) or ( ply:GetNWBool("ixHealing", false) == true ) then
        walkPenalty = 20
        runPenalty = 70
    else
        walkPenalty = 0
        runPenalty = 0
    end

    if ( ply:GetModel():find("combine_heavy_trooper") ) then
        walkPenalty = 0
        runPenalty = 40
    elseif ( ply:GetModel():find("combine_suppresor") ) then
        walkPenalty = 0
        runPenalty = 30
    end

    if ( ply:IsCombine() or char:GetData("ixHigh") ) then
        runBoost = 20
    else
        runBoost = 0
    end

    ply:SetDuckSpeed(0.5)
    ply:SetUnDuckSpeed(0.5)
    ply:SetLadderClimbSpeed(walkSpeed - walkPenalty)
    ply:SetCrouchedWalkSpeed(0.6)

    if ( ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_MOVELEFT) ) then
        ply:SetWalkSpeed(walkSpeed * Schema.heights[char:GetHeight()] - 10 - walkPenalty)
        ply:SetRunSpeed(runSpeed * Schema.heights[char:GetHeight()] - 10 + runBoost - runPenalty)
    elseif ( ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_MOVERIGHT) ) then
        ply:SetWalkSpeed(walkSpeed * Schema.heights[char:GetHeight()] - 10 - walkPenalty)
        ply:SetRunSpeed(runSpeed * Schema.heights[char:GetHeight()] - 10 + runBoost - runPenalty)
    elseif ( ply:KeyDown(IN_FORWARD) and not ( ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) ) ) then
        ply:SetWalkSpeed(walkSpeed * Schema.heights[char:GetHeight()] - walkPenalty)
        ply:SetRunSpeed(runSpeed * Schema.heights[char:GetHeight()] + runBoost - runPenalty)
    elseif ( ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) ) then
        ply:SetWalkSpeed(walkSpeed * Schema.heights[char:GetHeight()] - 15 - walkPenalty)
        ply:SetRunSpeed(runSpeed * Schema.heights[char:GetHeight()] - 15 + runBoost - runPenalty)
    elseif ply:KeyDown(IN_BACK) then
        ply:SetWalkSpeed(walkSpeed * Schema.heights[char:GetHeight()] - 20 - walkPenalty)
        ply:SetRunSpeed(runSpeed * Schema.heights[char:GetHeight()] - 20 + runBoost - runPenalty)
    end
end

function Schema:OnPlayerHitGround(ply, inWater, onFloater, speed)
    if not ( inWater ) and ( ply:IsValid() and ply:GetCharacter() ) then
        local punch = ( speed * 0.01 ) * 2 -- math moment
        ply:ViewPunch(Angle(punch, 0, 0))

        if ( punch >= 7 ) then
            ply:EmitSound("npc/combine_soldier/zipline_hitground"..math.random(1,2)..".wav", 60)
            ply:EmitSound("interlock/player/body_oneshot_0"..math.random(1,6)..".ogg", 50, math.random(90, 110), math.random(0.3, 0.4))
            ply:EmitSound("interlock/player/teleport_movement_0"..math.random(1,4).."_short.ogg", 50, math.random(90, 110), math.random(0.3, 0.4))
        else
            ply:EmitSound("interlock/player/body_oneshot_0"..math.random(1,6)..".ogg", 50, math.random(90, 110), math.random(0.3, 0.4))
            ply:EmitSound("interlock/player/teleport_movement_0"..math.random(1,4).."_short.ogg", 50, math.random(90, 110), math.random(0.3, 0.4))
        end
    end

    local vel = ply:GetVelocity()
    ply:SetVelocity(Vector( - ( vel.x * 0.45 ), - ( vel.y * 0.45 ), 0))
end

function Schema:PlayerSwitchFlashlight(ply)
    if not ( ply ) then return end

    local char = ply:GetCharacter()

    if not ( char ) then return end

    local inv = char:GetInventory()

    if ( ply:IsCombine() or ply:IsDispatch() or ply:Team() == FACTION_EVENT ) then
        return true
    end

    if not ( ply:IsCombine() ) then
        if ( inv:HasItem("tool_flashlight") ) then
           return true
        end
    end

    return false
end

function Schema:PlayerSpray()
    return true
end

function Schema:ShowSpare2(ply)
    ply:ConCommand("ix_togglethirdperson")
end

function Schema:OnDamagedByExplosion(ply, dmginfo)
    if ( ply:IsCombine() or ply:IsDispatch() or ply:Team() == FACTION_EVENT ) then
        return true
    end
end

local npcHealthValues = {
    ["npc_antlionguard"] = 1000,
    ["npc_antlion"] = 200,
    ["npc_hunter"] = 400,
    ["npc_combine_s"] = 140,
    ["npc_metropolice"] = 110,
    ["npc_citizen"] = 100,
    ["npc_zombie"] = 80,
}
function Schema:PlayerSpawnedNPC(ply, ent)
    ent:SetKeyValue("spawnflags", "16384")
    ent:SetKeyValue("spawnflags", "2097152")
    ent:SetKeyValue("spawnflags", "8192")

    if ( ent.SetCurrentWeaponProficiency ) then
        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_GOOD)
    end

    if ( npcHealthValues[ent:GetClass()] ) then
        ent:SetHealth(npcHealthValues[ent:GetClass()])
    end
end

function Schema:CanPlayerTakeItem(ply, item)
    if not ( IsValid(item) ) then return end

    local itemTable = item:GetItemTable()
    if ( item:NearEntityPure("ix_nail", 64) and itemTable.base == "base_writing" ) then
        ply:Notify("You cannot take this item, it is attached on a wall with a nail!")
        return false
    end
end

function Schema:OnEntityCreated(ent)
    if ( ent:IsNPC() ) then
        Schema:UpdateRelationShip(ent)
    end
end

local ixInteractionDelay = 2
function Schema:PlayerInteractItem(ply, action, itemTable)
    -- global delay
    if ( ( ixInteractionDelay or 0 ) < CurTime() ) then
        local char = ply:GetCharacter()
        local inv = char:GetInventory()

        local texttake = "picks up an item."
        if not ( inv:FindEmptySlot(itemTable.width, itemTable.height, false) ) then
            texttake = "attempted to pick up an item, but doesn't have space to carry it."
        end

        if ( action == "take" ) then
            ply:ForceSequence("pickup", nil, 1, true)
            ix.chat.Send(ply, "me", texttake, false)
        elseif ( action == "drop" ) then
            ply:ForceSequence("ThrowItem", nil, 1, true)
            ix.chat.Send(ply, "me", "drops an item.", false)
        elseif ( action == "use" ) then
            ply:ForceSequence("smgdraw", nil, 1, true)
            ix.chat.Send(ply, "me", "used his "..itemTable.name, false)
        end

        ixInteractionDelay = CurTime() + 2
    end
end

function Schema:PlayerCanHearPlayersVoice(listener, ply)
    if not ( IsValid(ply) and ply:Alive() and ply:GetCharacter() ) then return end
    if not ( IsValid(listener) and listener:Alive() and listener:GetCharacter() ) then return end
    if not ( ply:GetCharacter():HasFlags("V") ) then return false end

    if ( ply:IsCombine() and ply:GetCharacter():GetData("ixRadio") ) and ( listener:IsCombine() and listener:GetCharacter():GetData("ixRadio") ) then
        return true
    end

    return false
end

// https://steamcommunity.com/sharedfiles/filedetails/?id=793317003

function Schema:PreGamemodeLoaded()
    function widgets.PlayerTick()
        -- empty
    end

    hook.Remove( "PlayerTick", "TickWidgets" )
end

function Schema:EntityTakeDamage(ply, dmgInfo)
end

local pickupAbleEntities = {
    ["grenade_helicopter"] = true,
    ["npc_grenade_frag"] = true,
    ["npc_handgrenade"] = true,
    ["ix_container"] = true,
    ["npc_satchel"] = true,
    ["stormfox_digitalclock"] = true,
    ["stormfox_oil_lamp"] = true,
}
function Schema:CanPlayerHoldObject(ply, ent)
    if ( pickupAbleEntities[ent:GetClass()] ) then
        return true
    end
end

function Schema:EntityEmitSound(data)
    local ent = data.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end

    if ( data.SoundName:find("player/footsteps") ) then
        return false
    end
end

function Schema:PlayerUse(ply, ent)
    if ( ( ply:IsCombine() or ply:IsCA() or ply:IsDispatch() ) and ent:IsDoor() and IsValid(ent.ixLock) and ply:KeyDown(IN_SPEED) ) then
        ent.ixLock:Use(ply)
        return false
    end
end

function Schema:PlayerUnableInteractEntity(ply, ent, option, data)
    if ( ent:GetClass() == "ix_vehiclewreckage" ) and ( ent:GetPos():Distance(ply:GetPos()) > 128 ) then
        ply:Notify("You are too far away from the vehicle!")
    end
end

local carLoot = {
    "crafting_adhesive",
    "crafting_charcoal",
    "crafting_charcoal_refill",
    "crafting_cloth",
    "crafting_electronics",
    "crafting_explosive",
    "crafting_fabric",
    "crafting_fueltube",
    "crafting_glass",
    "crafting_grenadecase",
    "crafting_gunpowder",
    "crafting_heavy_weapon_parts",
    "crafting_improved_nails",
    "crafting_metal",
    "crafting_nails_screws",
    "crafting_plastic",
    "crafting_refined_metal",
    "crafting_refined_plastic",
    "crafting_reshaped_metal",
    "crafting_stiched_cloth",
    "crafting_weapon_parts",
    "crafting_wood",
    "crafting_wooden_craftwork",

    "junk_battery",
    "junk_brown_bottle",
    "junk_bucket",
    "junk_cardboard",
    "junk_carton",
    "junk_coffeecup",
    "junk_computer_tower",
    "junk_computerparts",
    "junk_desk_clock",
    "junk_doll",
    "junk_empty_bobwater",
    "junk_empty_water",
    "junk_frame",
    "junk_fridge_door",
    "junk_gascan",
    "junk_gear",
    "junk_green_bottle",
    "junk_jar",
    "junk_jug",
    "junk_keyboard",
    "junk_lamp",
    "junk_mug",
    "junk_paintcan",
    "junk_pc_monitor",
    "junk_pipe",
    "junk_plantpot",
    "junk_plastic_bucket",
    "junk_plastic_crate",
    "junk_ration",
    "junk_receiver",
    "junk_shoe",
    "junk_sm_cardboard",
    "junk_takeaway",
    "junk_tattered_drawer",
    "junk_tincan",
    "junk_tire",
    "junk_toy",
    "junk_turtle",
    "junk_tv",
}
function Schema:PlayerInteractEntity(ply, ent, option, data)
    if ( ( ply.nextScavenge or 0 ) < CurTime() ) then
        if ( ent:GetClass() == "ix_vehiclewreckage" ) then
            if ( option == "Loot" ) then
                ent:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(1,7)..".wav")
                ply:Freeze(true)
                ply:SetAction("Looting...", 5, function()
                    local lootAmount = 1

                    local randomLootItem = table.Random(carLoot)
                    if ( math.random(1, 3) == 3 ) then
                        lootAmount = math.random(1,3)
                    else
                        lootAmount = 1
                    end

                    ply:Freeze(false)
                    for i = 1, lootAmount do
                        randomLootItem = table.Random(carLoot)
                        ply:ChatNotify("You have gained "..ix.item.Get(randomLootItem).name..", from the car wreckage.")
                        ply:GetCharacter():GetInventory():Add(randomLootItem)
                    end
                end)
            elseif ( option == "Siphon" ) then
                if ( ply:HasItem("tool_syphonkit") ) then
                    ent:EmitSound("physics/metal/metal_barrel_impact_hard"..math.random(1,7)..".wav")
                    ply:Freeze(true)
                    ply:SetAction("Siphoning...", 10, function()
                        ply:Freeze(false)
                        ply:ChatNotify("You have gained a fuel tube filled with gasoline from the car wreckage.")
                        ply:GetCharacter():GetInventory():Add("crafting_fueltube")
                    end)
                else
                    ply:Notify("You need a syphon kit to siphon from the wreckage!")
                end
            end
        end
        ply.nextScavenge = CurTime() + 60 * 5
    else
        ply:ChatPrint("You need to wait "..math.ceil(ply.nextScavenge - CurTime()).." seconds before you can scavenge again.")
    end
end

function Schema:ixForcefieldCollided(ply, ent, mode)
    if (mode == 4) and ply:IsPlayer() then
        if ((ent.nextShock or 0) < CurTime()) then
            local damage = DamageInfo()
            damage:SetDamage(35)
            damage:SetAttacker(ent or ply)
            damage:SetDamageType(DMG_DISSOLVE)

            ply:TakeDamageInfo(damage)
            ply:SetVelocity(ply:GetAimVector() * -200)

            local effect = EffectData()
                effect:SetStart(ply:GetPos())
                effect:SetOrigin(ply:GetPos())
            util.Effect("StunstickImpact", effect, true, true)

            ent.nextShock = CurTime() + 0.5
        end
    end
end

util.AddNetworkString("ixEntityMenuSelect")
net.Receive("ixEntityMenuSelect", function(length, ply)
    local ent = net.ReadEntity()
    local option = net.ReadString()
    local data = net.ReadType()

    if ( IsValid(ent) or isstring(option) ) then
        if ( ent:GetPos():Distance(ply:GetPos()) > 128 ) or ( hook.Run("CanPlayerInteractEntity", ply, ent, option, data) == false ) then
            hook.Run("PlayerUnableInteractEntity", ply, ent, option, data)
            return
        else
            hook.Run("PlayerInteractEntity", ply, ent, option, data)
        end
    end

    local callbackName = "OnSelect" .. option:gsub("%s", "")

    if ( ent[callbackName] ) then
        ent[callbackName](ent, ply, data)
    else
        if ( ent.OnOptionSelected ) then
            ent:OnOptionSelected(ply, option, data)
        end
    end
end)

function Schema:OnReloaded()
    for k, v in pairs(player.GetAll()) do
        v:Notify("Server has been refreshed!")
    end
    
    ix.event.PlaySoundGlobal({
        sound = "npc/roller/code2.wav",
        volume = 0.5,
        pitch = 90,
    })
end

function Schema:AllowPlayerPickup(ply, ent)
    if ( ply:IsCombine() ) then
        if ( ent:IsNPC() and ( ent:GetClass() == "npc_turret_floor" or ent:GetClass() == "npc_rollermine" ) ) then
            return true
        end
    end
end