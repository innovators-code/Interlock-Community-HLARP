-- data saving
function Schema:SaveRationDispensers()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
    end

    ix.data.Set("rationDispensers", data)
end

function Schema:SaveCombineLights()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_unionlight")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetLocked()}
    end

    ix.data.Set("combineLights", data)
end

function Schema:SaveVendingMachines()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_vendingmachine")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetAllStock()}
    end

    ix.data.Set("vendingMachines", data)
end

function Schema:SaveCombineLocks()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_combinelock")) do
        if (IsValid(v.door)) then
            data[#data + 1] = {
                v.door:MapCreationID(),
                v.door:WorldToLocal(v:GetPos()),
                v.door:WorldToLocalAngles(v:GetAngles()),
                v:GetLocked()
            }
        end
    end

    ix.data.Set("combineLocks", data)
end

function Schema:SaveUnionLocks()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_unionlock")) do
        if (IsValid(v.door)) then
            data[#data + 1] = {
                v.door:MapCreationID(),
                v.door:WorldToLocal(v:GetPos()),
                v.door:WorldToLocalAngles(v:GetAngles()),
                v:GetLocked()
            }
        end
    end

    ix.data.Set("unionLocks", data)
end

function Schema:SaveForceFields()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetMode()}
    end

    ix.data.Set("forceFields", data)
end

function Schema:SaveTerminals()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_terminal_*")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetClass()}
    end

    ix.data.Set("terminals", data)
end

function Schema:SaveWreckages()
    local data = {}

    for _, v in ipairs(ents.FindByClass("ix_vehiclewreckage")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel()}
    end

    ix.data.Set("vehicleWreckage", data)
end

function Schema:SaveMiningEntities()
    local data = {}

    for _, v in pairs(ents.FindByClass("ix_mining_*")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel(), v:GetClass()}
    end

    ix.data.Set("miningEntities", data)
end

function Schema:SaveCampfire()
    local data = {}

    for _, v in pairs(ents.FindByClass("ix_campfire")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("campfires", data)
end

function Schema:SaveNails()
    local data = {}

    for _, v in pairs(ents.FindByClass("ix_nail")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end

    ix.data.Set("nails", data)
end

-- data loading
function Schema:LoadRationDispensers()
    for _, v in ipairs(ix.data.Get("rationDispensers") or {}) do
        local dispenser = ents.Create("ix_rationdispenser")

        dispenser:SetPos(v[1])
        dispenser:SetAngles(v[2])
        dispenser:Spawn()
        dispenser:SetLocked(v[3])
    end
end

function Schema:LoadCombineLights()
    for _, v in ipairs(ix.data.Get("combineLights") or {}) do
        local light = ents.Create("ix_unionlight")

        light:SetPos(v[1])
        light:SetAngles(v[2])
        light:Spawn()
        light:SetLocked(v[3])
    end
end

function Schema:LoadVendingMachines()
    for _, v in ipairs(ix.data.Get("vendingMachines") or {}) do
        local vendor = ents.Create("ix_vendingmachine")

        vendor:SetPos(v[1])
        vendor:SetAngles(v[2])
        vendor:Spawn()
        vendor:SetStock(v[3])
    end
end

function Schema:LoadCombineLocks()
    for _, v in ipairs(ix.data.Get("combineLocks") or {}) do
        local door = ents.GetMapCreatedEntity(v[1])

        if (IsValid(door) and door:IsDoor()) then
            local lock = ents.Create("ix_combinelock")

            lock:SetPos(door:GetPos())
            lock:Spawn()
            lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
            lock:SetLocked(v[4])
        end
    end
end

function Schema:LoadUnionLocks()
    for _, v in ipairs(ix.data.Get("unionLocks") or {}) do
        local door = ents.GetMapCreatedEntity(v[1])

        if (IsValid(door) and door:IsDoor()) then
            local lock = ents.Create("ix_unionlock")

            lock:SetPos(door:GetPos())
            lock:Spawn()
            lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
            lock:SetLocked(v[4])
        end
    end
end

function Schema:LoadForceFields()
    for _, v in ipairs(ix.data.Get("forceFields") or {}) do
        local field = ents.Create("ix_forcefield")

        field:SetPos(v[1])
        field:SetAngles(v[2])
        field:Spawn()
        field:SetMode(v[3])
    end
end

function Schema:LoadTerminals()
    for _, v in ipairs(ix.data.Get("terminals") or {}) do
        local terminal = ents.Create(v[3])

        terminal:SetPos(v[1])
        terminal:SetAngles(v[2])
        terminal:Spawn()
    end
end

function Schema:LoadWreckages()
    for _, v in ipairs(ix.data.Get("vehicleWreckages") or {}) do
        local terminal = ents.Create("ix_vehiclewreckage")

        terminal:SetModel(v[3])
        terminal:SetPos(v[1])
        terminal:SetAngles(v[2])
        terminal:Spawn()
    end
end

function Schema:LoadMiningEntities()
    for _, v in pairs(ix.data.Get("miningEntities")) do
        local miningEntity = ents.Create(v[4])
        miningEntity:SetPos(v[1])
        miningEntity:SetAngles(v[2])
        miningEntity:SetModel(v[3])
        miningEntity:Spawn()
    end
end

function Schema:LoadCampfire()
    for _, v in pairs(ix.data.Get("campfires")) do
        local miningEntity = ents.Create("ix_campfire")
        miningEntity:SetPos(v[1])
        miningEntity:SetAngles(v[2])
        miningEntity:Spawn()
    end
end

function Schema:LoadNails()
    for _, v in pairs(ix.data.Get("nails")) do
        local nails = ents.Create("ix_nail")
        nails:SetPos(v[1])
        nails:SetAngles(v[2])
        nails:Spawn()
    end
end

-- data
function Schema:SaveData()
    self:SaveRationDispensers()
    self:SaveVendingMachines()
    self:SaveCombineLocks()
    self:SaveUnionLocks()
    self:SaveForceFields()
    self:SaveTerminals()
    self:SaveWreckages()
    self:SaveMiningEntities()
    self:SaveCampfire()
    self:SaveNails()
end

function Schema:LoadData()
    self:LoadRationDispensers()
    self:LoadVendingMachines()
    self:LoadCombineLocks()
    self:LoadUnionLocks()
    self:LoadForceFields()
    self:LoadTerminals()
    self:LoadWreckages()
    self:LoadMiningEntities()
    self:LoadCampfire()
    self:LoadNails()
end