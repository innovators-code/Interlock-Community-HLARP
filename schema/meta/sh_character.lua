local CHAR = ix.meta.character

function CHAR:IsCitizen()
    if ( self:GetFaction() == FACTION_CITIZEN or self:GetFaction() == FACTION_UUA ) then
        return true
    end
end

function CHAR:IsLoyalist()
    if ( self:GetFaction() == FACTION_UUA ) then
        return true
    end
    
    if ( IsValid(self) and ( self:GetClass() == CLASS_A_4_LOYALIST or self:GetClass() == CLASS_A_5_PRIORITYLOYALIST ) ) then
        return true
    end
end

function CHAR:IsCombine()
    if ( self:GetFaction() == FACTION_CP or self:GetFaction() == FACTION_OTA ) then
        return true
    end
end

function CHAR:IsCA()
    if ( self:GetFaction() == FACTION_CA ) then
        return true
    end
end

function CHAR:IsDispatch()
    if ( self:GetFaction() == FACTION_DISPATCH ) then
        return true
    end
end

function CHAR:IsProselyte()
    if ( self:GetFaction() == FACTION_UP ) then
        return true
    end

    return false
end

function CHAR:IsConscript()
    if ( self:GetFaction() == FACTION_CONSCRIPT ) then
        return true
    end

    return false
end

function CHAR:IsCombineCommand()
    if ( self:GetFaction() == FACTION_CA or self:GetFaction() == FACTION_DISPATCH ) then
        return true
    end

    if not ( self:GetFaction() == FACTION_CP or self:GetFaction() == FACTION_OTA ) then
        return false
    end
  
    local name = self:GetName()
    for k, v in ipairs({"OfC", "RL", "CmD", "CPT", "OWC"}) do
        if ( name:find(v) ) then
            return true
        end
    end
end

function CHAR:IsCombineSupervisor()
    if ( self:GetFaction() == FACTION_CA or self:GetFaction() == FACTION_DISPATCH ) then
        return true
    end

    if not ( self:GetFaction() == FACTION_CP ) then
        return false
    end
  
    local name = self:GetName()
    for k, v in ipairs({"CmD", "OWC"}) do
        if ( name:find(v) ) then
            return true
        end
    end
end