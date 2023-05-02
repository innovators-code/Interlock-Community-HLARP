local PLAYER = FindMetaTable("Player")

function PLAYER:IsCitizen()
    if ( self:Team() == FACTION_CITIZEN or self:Team() == FACTION_UUA ) then
        return true
    end

    return false
end

function PLAYER:IsLoyalist()
    if ( self:Team() == FACTION_UUA ) then
        return true
    end

    if ( self:GetCharacter() and ( self:GetCharacter():GetClass() == CLASS_A_4_LOYALIST or self:GetCharacter():GetClass() == CLASS_A_5_PRIORITYLOYALIST ) ) then
        return true
    end

    return false
end

function PLAYER:IsCombine()
    if ( self:Team() == FACTION_CP or self:Team() == FACTION_OTA ) then
        return true
    end

    return false
end

function PLAYER:IsCA()
    if ( self:Team() == FACTION_CA ) then
        return true
    end

    return false
end

function PLAYER:IsDispatch()
    if ( self:Team() == FACTION_DISPATCH ) then
        return true
    end

    return false
end

function PLAYER:IsProselyte()
    if ( self:Team() == FACTION_UP ) then
        return true
    end

    return false
end

function PLAYER:IsConscript()
    if ( self:Team() == FACTION_CONSCRIPT ) then
        return true
    end

    return false
end

function PLAYER:IsCombineCommand()
    if ( self:Team() == FACTION_CA or self:Team() == FACTION_DISPATCH ) then
        return true
    end

    if not ( self:Team() == FACTION_CP or self:Team() == FACTION_OTA ) then
        return false
    end

    if ( self:Team() == FACTION_OTA ) then
        for i, a in ipairs({"ORDINAL"}) do
            if ( self:Nick():find(a) ) then
                return true
            end
        end
    end

    local name = self:Nick()
    for k, v in ipairs({"OfC", "RL", "CmD", "CPT", "OWC"}) do
        if ( name:find(v) ) then
            return true
        end
    end

    return false
end

function PLAYER:IsCombineSupervisor()
    if ( self:Team() == FACTION_CA or self:Team() == FACTION_DISPATCH ) then
        return true
    end

    if not ( self:Team() == FACTION_CP or self:Team() == FACTION_OTA ) then
        return false
    end

    local name = self:Nick()
    for k, v in ipairs({"CmD", "OWC"}) do
        if ( name:find(v) ) then
            return true
        end
    end

    return false
end

function PLAYER:HasFlags(flags)
    local char = self:GetCharacter()
    if not ( char ) then
        return false
    end

    return char:HasFlags( flags )
end

function PLAYER:GetGender()
    local gender = "male"

    if ( self:IsFemale() ) then
        gender = "female"
    end

    return gender
end

function PLAYER:GetNiceGender() -- bruh
    local gender = "Male"

    if ( self:IsFemale() ) then
        gender = "Female"
    end

    return gender
end

function PLAYER:IsRunning()
    return self:KeyDown(IN_SPEED)
end

function PLAYER:HasItem(item)
    local character = self:GetCharacter()
    if not ( character ) then return false end
    local inventory = character:GetInventory()
    if ( character and inventory ) then
        if ( inventory:HasItem(item) ) then
           return true
        end

        return false
    end
end

function PLAYER:SetPlyColor(color)
    self:SetPlayerColor(Vector(color.r / 255, color.g / 255, color.b / 255))
end

local devsteamid = {
    ["76561197963057641"] = true, -- Riggs.mackay
    ["76561198373309941"] = true, -- Apsys
}

function PLAYER:IsDeveloper()
    if ( devsteamid[self:SteamID64()] ) then
       return true
    end

    return false
end

function PLAYER:IsDonator()
    if ( self:GetUserGroup() == "donator" ) then
        return true
    end

    return false
end

if ( SERVER ) then
    local PLAYER = FindMetaTable("Player")

    util.AddNetworkString("ixPlaySound")
    function PLAYER:PlaySound(sound, pitch)
        net.Start("ixPlaySound")
            net.WriteString(tostring(sound))
            net.WriteUInt(tonumber(pitch) or 100, 7)
        net.Send(self)
    end

    util.AddNetworkString("ixCreateVGUI")
    function PLAYER:OpenVGUI(panel)
        if not ( isstring(panel) ) then
            ErrorNoHalt("Warning argument is required to be a string! Instead is "..type(panel).."\n")
            return
        end

        net.Start("ixCreateVGUI")
            net.WriteString(panel)
        net.Send(self)
    end

    function PLAYER:GiveMoney(value)
        if ( self and self:GetCharacter() ) then
            self:GetCharacter():SetMoney(self:GetCharacter():GetMoney() + value)
        end
    end

    function PLAYER:NearEntity(entity, radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if ( v:GetClass() == entity ) then
                return true
            end
        end
        return false
    end

    --[[
        -- Used the same as the above but you input a pure entity e.g. --
        local ply = Entity(1)
        local our_ent = Entity(123)
        if ( ply:NearEntityPure(our_ent) ) then
            DoStuff()
        end
    ]]

    function PLAYER:NearEntityPure(entity, radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if ( v == entity ) then
                return true
            end
        end
        return false
    end

    function PLAYER:NearPlayer(radius)
        for k, v in ipairs(ents.FindInSphere(self:GetPos(), radius or 96)) do
            if ( v:IsPlayer() and v:Alive() and v:IsValid() ) then
                return true
            end
        end
        return false
    end
else
    local PLAYER = FindMetaTable("Player")

    function PLAYER:GetPlayerInArea() -- Could be slightly expensive so I'll try some optimization methods ~ scotnay
        -- Area plugin not used method useless
        if not ( ix.area and ix.area.stored ) then
            return
        end

        local oldArea = self.oldArea or nil

        -- If an area already exists it saves us having to loop over everything
        if ( oldArea ) then
            local areaData = ix.area.stored[oldArea]

            if not ( areaData ) then
                self.oldArea = nil
                return self.oldArea
            end

            local min, max = areaData.startPosition, areaData.endPosition

            -- Pos is at feet so we add the center so if the area is off the ground still registers
            local pos = self:GetPos() + self:OBBCenter()

            if ( pos:WithinAABox(max, min) ) then
                self.oldArea = self.oldArea
                return self.oldArea
            else
                self.oldArea = nil
                self.oldAreaTimer = nil
                self:GetPlayerInArea() -- Try again since no longer in area
            end
        else
            for i, v in pairs(ix.area.stored) do
                local min, max = v.startPosition, v.endPosition

                local pos = self:GetPos() + self:OBBCenter()

                if ( pos:WithinAABox(min, max) ) then
                    self.oldArea = i
                    return self.oldArea
                end
            end
        end
        return nil
    end
end

if ( CLIENT ) then
    net.Receive("ixCharacterIDRequest", function(len)
        local id = net.ReadString()
        local ent  = net.ReadEntity()
        if not ( IsValid(ent) and ent:IsPlayer() and ent:GetCharacter() ) then return end

        ent.ixIdentification = id
    end)

    function PLAYER:GetIDNumber()
        if not ( self.ixIdentification ) then
            net.Start("ixCharacterIDRequest")
                net.WriteEntity(self)
            net.SendToServer()
            return "N/A"
        end

        return self.ixIdentification or "N/A"
    end
else
    util.AddNetworkString("ixCharacterIDRequest")
    net.Receive("ixCharacterIDRequest", function(len, ply)
        local ent = net.ReadEntity()
        if not ( IsValid(ent) and ent:IsPlayer() and ent:GetCharacter() ) then return end
        local id = tostring(ent:GetCharacter():GetData("ixIdentification", "N/A"))

        net.Start("ixCharacterIDRequest")
            net.WriteString(id)
            net.WriteEntity(ent)
        net.Send(ply)
    end)
end
