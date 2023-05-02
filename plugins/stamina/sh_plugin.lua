local PLUGIN = PLUGIN

PLUGIN.name = "Stamina"
PLUGIN.description = "Adds a stamina system to limit running."
PLUGIN.author = "Chessnut"

ix.config.Add("staminaDrain", 1, "How much stamina to drain per tick (every quarter second). This is calculated before attribute reduction.", nil, {
    data = {min = 0, max = 10, decimals = 2},
    category = "characters"
})

ix.config.Add("staminaRegeneration", 1.75, "How much stamina to regain per tick (every quarter second).", nil, {
    data = {min = 0, max = 10, decimals = 2},
    category = "characters"
})

ix.config.Add("staminaCrouchRegeneration", 2, "How much stamina to regain per tick (every quarter second) while crouching.", nil, {
    data = {min = 0, max = 10, decimals = 2},
    category = "characters"
})

ix.config.Add("punchStamina", 10, "How much stamina punches use up.", nil, {
    data = {min = 0, max = 100},
    category = "characters"
})

local function CalcStaminaChange(ply)
    local char = ply:GetCharacter()

    if not ( char ) or ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
        return 0
    end

    local runSpeed

    if ( SERVER ) then
        runSpeed = ix.config.Get("runSpeed") + char:GetAttribute("attribute_stamina", 0)

        if ( ply:WaterLevel() > 1 ) then
            runSpeed = runSpeed * 0.775
        end
    end

    local walkSpeed = ix.config.Get("walkSpeed")
    local maxAttributes = ix.config.Get("maxAttributes", 100)
    local offset

    if ( ply:KeyDown(IN_SPEED) and ply:GetVelocity():LengthSqr() >= ( walkSpeed * walkSpeed ) ) then
        offset = -ix.config.Get("staminaDrain", 1)
    else
        offset = ply:Crouching() and ix.config.Get("staminaCrouchRegeneration", 2) or ix.config.Get("staminaRegeneration", 1.75)
    end

    offset = hook.Run("AdjustStaminaOffset", ply, offset) or offset

    if ( CLIENT ) then
        return offset
    else
        local current = ply:GetLocalVar("attribute_stamina", 0)
        local value = math.Clamp(current + offset, 0, 100)

        if not ( current == value ) then
            ply:SetLocalVar("attribute_stamina", value)

            if ( value == 0 and not ply:GetNetVar("brth", false) ) then
                ply:SetRunSpeed(walkSpeed)
                ply:SetNetVar("brth", true)

                char:UpdateAttrib("end", 0.1)
                char:UpdateAttrib("attribute_stamina", 0.01)

                hook.Run("PlayerStaminaLost", ply)
            elseif ( value >= 50 and ply:GetNetVar("brth", false) ) then
                ply:SetRunSpeed(runSpeed)
                ply:SetNetVar("brth", nil)

                hook.Run("PlayerStaminaGained", ply)
            end
        end
    end
end

if ( SERVER ) then
    function PLUGIN:PostPlayerLoadout(ply)
        local uniqueID = "ixStam" .. ply:SteamID()

        timer.Create(uniqueID, 0.25, 0, function()
            if not ( IsValid(ply) ) then
                timer.Remove(uniqueID)
                return
            end

            CalcStaminaChange(ply)
        end)
    end

    function PLUGIN:CharacterPreSave(char)
        local ply = char:GetPlayer()

        if ( IsValid(ply) ) then
            char:SetData("stamina", ply:GetLocalVar("attribute_stamina", 0))
        end
    end

    function PLUGIN:PlayerLoadedCharacter(ply, char)
        timer.Simple(0.25, function()
            ply:SetLocalVar("attribute_stamina", char:GetData("stamina", 100))
        end)
    end

    local playerMeta = FindMetaTable("Player")

    function playerMeta:RestoreStamina(amount)
        local current = self:GetLocalVar("attribute_stamina", 0)
        local value = math.Clamp(current + amount, 0, 100)

        self:SetLocalVar("attribute_stamina", value)
    end

    function playerMeta:ConsumeStamina(amount)
        local current = self:GetLocalVar("attribute_stamina", 0)
        local value = math.Clamp(current - amount, 0, 100)

        self:SetLocalVar("attribute_stamina", value)
    end

else
    local predictedStamina = 100

    function PLUGIN:Think()
        local offset = CalcStaminaChange(LocalPlayer())
        offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)

        if not ( offset == 0 ) then
            predictedStamina = math.Clamp(predictedStamina + offset, 0, 100)
        end
    end

    function PLUGIN:OnLocalVarSet(key, var)
        if not ( key == "attribute_stamina" ) then return end
        if ( math.abs(predictedStamina - var) > 5 ) then
            predictedStamina = var
        end
    end

    ix.bar.Add(function()
        return predictedStamina / 100
    end, Color(200, 200, 40), nil, "attribute_stamina")
end