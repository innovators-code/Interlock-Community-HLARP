--[[---------------------------------------------------------------------------
    Shared Hooks
---------------------------------------------------------------------------]]--

if ( SERVER ) then
    ix.plugin.SetUnloaded("thirdperson", true)
elseif ( CLIENT ) then
    if ( IsValid(ix.gui.pluginManager) ) then
        ix.gui.pluginManager:UpdatePlugin("thirdperson", false)
    end
end

local recog = {
    [FACTION_CP] = true,
    [FACTION_OTA] = true,
}

function Schema:IsCharacterRecognized(char, id)
    local ply = char:GetPlayer()
    local other = ix.char.loaded[id]:GetPlayer()
    if ( other ) then
        if ( recog[ply:Team()] and recog[other:Team()] ) then
            return true
        end
    end
end

function Schema:CanDrive()
    return false
end

function Schema:CanPlayerJoinClass()
    return false
end

function Schema:OnEntityCreated(ent)
    if ( IsValid(ent) and ent:GetClass() == "prop_door_rotating" ) then
        ent:DrawShadow(false)
        if ( SERVER ) then
            ent:Fire("setspeed", "120")
        end
    end
end

function Schema:PrePACEditorOpen(ply)
    if not ( ply:GetCharacter():HasFlags("P") ) then
        ply:Notify("You do not have the 'P' Flag to access the PAC Editor!")
        return false
    end

    return true
end

if ( CLIENT ) then
    function Schema:PlayerSwitchWeapon(ply, oldWep, newWep)
        if ( newWep:GetClass():find("ls") ) then
            ply.hasLongswordWeaponOn = true
        else
            ply.hasLongswordWeaponOn = false
        end
    end
end

function Schema:EntityEmitSound(data)
    local ent = data.Entity
    if not ( IsValid(ent) or ent:IsPlayer() ) then return end

    if ( data.SoundName:find("player/footsteps") or data.SoundName:find("glass_sheet_step") or data.SoundName:find("wood_box_footstep") ) then
        return false
    end
end

function Schema:SetupMove(ply, mv, cmd)
    if not ( ply:IsRestricted() ) then return end

    mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.6)

    if not ( IsValid(ply.dragger) ) then return end

    local kidnapper = ply.dragger
    if not ( kidnapper:IsPlayer() ) then return end

    local TargetPoint = (kidnapper:IsPlayer() and kidnapper:GetShootPos()) or kidnapper:GetPos()
    local MoveDir = ( TargetPoint - ply:GetPos() ):GetNormal()
    local ShootPos = ply:GetShootPos() + ( Vector(0, 0, ( ply:Crouching() and 0 )) )
    local Distance = 64

    local distFromTarget = ShootPos:Distance(TargetPoint)
    if ( distFromTarget ) <= ( Distance + 5 ) then return end
    if ( ply:InVehicle() ) then
        if ( SERVER ) and ( distFromTarget > ( Distance * 3 ) ) then
            ply:ExitVehicle()
        end

        return
    end

    local TargetPos = TargetPoint - ( MoveDir * Distance )

    local xDif = math.abs(ShootPos[1] - TargetPos[1])
    local yDif = math.abs(ShootPos[2] - TargetPos[2])
    local zDif = math.abs(ShootPos[3] - TargetPos[3])

    local speedMult = 3 + ( (xDif + yDif) * 0.5) ^ 1.01
    local vertMult = math.max((math.Max(300 - (xDif + yDif), -10) * 0.08) ^ 1.01 + (zDif / 2), 0)

    if ( kidnapper:GetGroundEntity() == ply ) then
        vertMult = - vertMult
    end

    local TargetVel = ( TargetPos - ShootPos ):GetNormal() * 10
    TargetVel[1] = TargetVel[1] * speedMult
    TargetVel[2] = TargetVel[2] * speedMult
    TargetVel[3] = TargetVel[3] * vertMult
    local dir = mv:GetVelocity()

    local clamp = 50
    local vclamp = 20
    local accel = 200
    local vaccel = 30 * ( vertMult / 50 )

    dir[1] = ( dir[1] > TargetVel[1] - clamp or dir[1] < TargetVel[1] + clamp ) and math.Approach(dir[1], TargetVel[1], accel) or dir[1]
    dir[2] = ( dir[2] > TargetVel[2] - clamp or dir[2] < TargetVel[2] + clamp ) and math.Approach(dir[2], TargetVel[2], accel) or dir[2]

    if ( ShootPos[3] < TargetPos[3] ) then
        dir[3] = ( dir[3] > TargetVel[3] - vclamp or dir[3] < TargetVel[3] + vclamp ) and math.Approach(dir[3], TargetVel[3], vaccel) or dir[3]
    end

    mv:SetVelocity(dir)
end