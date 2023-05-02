ix.char.RegisterVar("gender", {
    field = "gender",
    fieldType = ix.type.string,
    default = "Female",
    bNoDisplay = true
})

ix.char.RegisterVar("relocation", {
    field = "relocation",
    fieldType = ix.type.string,
    default = "10",
    OnDisplay = function(self, container, payload)
        local relocation = container:Add("DComboBox")
        relocation:SetValue("Unspecified City")
        relocation:AddChoice("Random City")
        for k, v in pairs(Schema.cities) do
            relocation:AddChoice(v)
        end
        relocation:SetSortItems(false)
        relocation:Dock(TOP)
        relocation:SetTall(40)
        relocation.OnSelect = function(panel, index, value)
            payload:Set("relocation", value)
        end
        relocation.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        return relocation
    end,
    OnValidate = function(self, value, payload, ply)
        if not ( value ) or ( value == "Unspecified City" ) then
            return false, "You have provided an invalid relocation!"
        end

        if ( value == "Random City" ) then
            return table.Random(Schema.cities)
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload)
        panel:SetFont("InterlockFont32")
    end,
    alias = "Relocation"
})

ix.char.RegisterVar("age", {
    field = "age",
    fieldType = ix.type.string,
    default = "30",
    OnDisplay = function(self, container, payload)
        local age = container:Add("DComboBox")
        age:SetValue("Unspecified Age")
        for i = 20, 60 do
            age:AddChoice(i)
        end
        age:SetSortItems(false)
        age:Dock(TOP)
        age:SetTall(40)
        age.OnSelect = function(panel, index, value)
            payload:Set("age", value)
        end
        age.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        return age
    end,
    OnValidate = function(self, value, payload, ply)
        if not ( value ) or ( value == "Unspecified Age" ) then
            return false, "You have provided an invalid age!"
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload)
        panel:SetFont("InterlockFont32")
    end,
    alias = "Age"
})

ix.char.RegisterVar("department", {
    field = "department",
    fieldType = ix.type.string,
    default = "None",
    OnDisplay = function(self, container, payload)
        if not ( payload.faction == FACTION_UUA ) then
            return false
        end

        local department = container:Add("DComboBox")
        department:SetValue("Unspecified Department")
        department:AddChoice("None")
        department:AddChoice("Medical Service")
        department:AddChoice("WorkForce")
        department:AddChoice("Infestation Control Unit")
        department:SetSortItems(false)
        department:Dock(TOP)
        department:SetTall(40)
        department.OnSelect = function(panel, index, value)
            payload:Set("department", value)
        end
        department.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        return department
    end,
    OnValidate = function(self, value, payload, ply)
        if not ( payload.faction == FACTION_UUA ) then
            return "None"
        end

        if not ( value ) or ( value == "Unspecified Department" ) then
            return false, "You have provided an invalid department!"
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload)
        panel:SetFont("InterlockFont32")
    end,
    alias = "Department"
})

ix.char.RegisterVar("height", {
    field = "height",
    fieldType = ix.type.string,
    default = "5'6",
    OnDisplay = function(self, container, payload)
        local height = container:Add("DComboBox")
        height:SetValue("Unspecified Height")
        height:AddChoice("4'0")
        height:AddChoice("4'2")
        height:AddChoice("4'4")
        height:AddChoice("4'6")
        height:AddChoice("4'8")
        height:AddChoice("4'10")
        height:AddChoice("4'12")
        height:AddChoice("5'0")
        height:AddChoice("5'2")
        height:AddChoice("5'4")
        height:AddChoice("5'6")
        height:AddChoice("5'8")
        height:AddChoice("5'10")
        height:AddChoice("5'12")
        height:AddChoice("6'0")
        height:AddChoice("6'2")
        height:AddChoice("6'4")
        height:AddChoice("6'6")
        height:AddChoice("6'8")
        height:AddChoice("6'10")
        height:AddChoice("6'12")
        height:SetSortItems(false)
        height:Dock(TOP)
        height:SetTall(40)
        height.OnSelect = function(panel, index, value)
            payload:Set("height", value)
        end
        height.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        return height
    end,
    OnValidate = function(self, value, payload, ply)
        if not ( value ) or ( value == "Unspecified Height" ) then
            return false, "You have provided an invalid height!"
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload, otherPanel)
        panel:SetFont("InterlockFont32")

        local dockpanel = otherPanel:Add("DPanel")
        dockpanel:Dock(TOP)
        dockpanel:SetTall(100)
    end,
    alias = "Height"
})

ix.char.RegisterVar("name", {
    field = "name",
    fieldType = ix.type.string,
    default = "John Doe",
    index = 1,
    OnValidate = function(self, value, payload, ply)
        if (!value) then
            return false, "invalid", "name"
        end

        value = tostring(value):gsub("\r\n", ""):gsub("\n", "")
        value = string.Trim(value)

        local minLength = ix.config.Get("minNameLength", 4)
        local maxLength = ix.config.Get("maxNameLength", 32)

        if (value:utf8len() < minLength) then
            return false, "nameMinLen", minLength
        elseif (!value:find("%S")) then
            return false, "invalid", "name"
        elseif (value:gsub("%s", ""):utf8len() > maxLength) then
            return false, "nameMaxLen", maxLength
        end

        return hook.Run("GetDefaultCharacterName", ply, payload.faction) or value:utf8sub(1, 70)
    end,
    OnPostSetup = function(self, panel, payload)
        local faction = ix.faction.indices[payload.faction]
        local name, disabled = hook.Run("GetDefaultCharacterName", LocalPlayer(), payload.faction)

        if (name) then
            panel:SetText(name)
            payload:Set("name", name)
        end

        if (disabled) then
            panel:SetDisabled(true)
            panel:SetEditable(false)
        end

        panel:SetBackgroundColor(faction.color or Color(255, 255, 255, 25))
        panel:SetTall(panel:GetTall() * 2 + 6) -- add another line
    end
})

ix.char.RegisterVar("description", {
    field = "description",
    fieldType = ix.type.text,
    default = "",
    index = 2,
    OnValidate = function(self, value, payload)
        value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))
        local minLength = ix.config.Get("minDescriptionLength", 16)

        if (value:utf8len() < minLength) then
            return false, "descMinLen", minLength
        elseif (!value:find("%s+") or !value:find("%S")) then
            return false, "invalid", "description"
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload)
        panel:SetMultiline(true)
        panel:SetFont("InterlockFont32")
        panel:SetTall(panel:GetTall() * 2 + 6) -- add another line
        panel.AllowInput = function(_, character)
            if (character == "\n" or character == "\r") then
                return true
            end
        end
    end,
    alias = "Desc"
})

ix.char.RegisterVar("model", {
    field = "model",
    fieldType = ix.type.string,
    default = "models/error.mdl",
    index = 3,
    OnSet = function(character, value)
        local ply = character:GetPlayer()

        if (IsValid(ply) and ply:GetCharacter() == character) then
            ply:SetModel(value)
        end

        character.vars.model = value
    end,
    OnGet = function(character, default)
        return character.vars.model or default
    end,
    OnDisplay = function(self, container, payload)
        local scroll = container:Add("DScrollPanel")
        scroll:SetTall(ScreenScale(75)) -- TODO: don't fill so we can allow other panels
        scroll:Dock(TOP) -- TODO: don't fill so we can allow other panels
        scroll.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        local layout = scroll:Add("DIconLayout")
        layout:Dock(FILL)
        layout:SetSpaceX(1)
        layout:SetSpaceY(1)

        local faction = ix.faction.indices[payload.faction]

        if (faction) then
            local models = faction:GetModels(LocalPlayer())

            for k, v in SortedPairs(models) do
                local icon = layout:Add("ixSpawnIcon")
                icon:SetSize(ScreenScale(75) / 2, ScreenScale(75) / 2)
                icon:InvalidateLayout(true)
                icon.DoClick = function(this)
                    payload:Set("model", k)
                end
                icon.PaintOver = function(this, w, h)
                    if (payload.model == k) then
                        local color = ix.config.Get("color", color_white)

                        surface.SetDrawColor(color.r, color.g, color.b, 200)

                        for i = 1, 3 do
                            local i2 = i * 2
                            surface.DrawOutlinedRect(i, i, w - i2, h - i2)
                        end
                    end
                end

                if (isstring(v)) then
                    icon:SetModel(v)
                else
                    icon:SetModel(v[1], v[2] or 0, v[3])
                    icon.Entity:SetBodyGroups(v[3])
                end
            end
        end

        return scroll
    end,
    OnValidate = function(self, value, payload, ply)
        local faction = ix.faction.indices[payload.faction]

        if (faction) then
            local models = faction:GetModels(ply)

            if (!payload.model or !models[payload.model]) then
                return false, "needModel"
            end
        else
            return false, "needModel"
        end
    end,
    OnAdjust = function(self, ply, data, value, newData)
        local faction = ix.faction.indices[data.faction]

        if (faction) then
            local model = faction:GetModels(ply)[value]

            if (isstring(model)) then
                newData.model = model
            elseif (istable(model)) then
                newData.model = model[1]

                -- save skin/bodygroups to character data
                local bodygroups = {}

                for i = 1, #model[3] do
                    bodygroups[i - 1] = tonumber(model[3][i]) or 0
                end

                newData.data = newData.data or {}
                newData.data.skin = model[2] or 0
                newData.data.groups = bodygroups
            end
        end
    end,
    ShouldDisplay = function(self, container, payload)
        local faction = ix.faction.indices[payload.faction]
        return #faction:GetModels(LocalPlayer()) > 1
    end
})

ix.char.RegisterVar("attributes", {
    field = "attributes",
    fieldType = ix.type.text,
    default = {},
    index = 4,
    category = "attributes",
    isLocal = true,
    OnDisplay = function(self, container, payload)
        local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or 10

        if (maximum < 1) then
            return
        end

        local attributes = container.attributesPanel:Add("DPanel")
        attributes:Dock(TOP)
        attributes:DockMargin(20, 20, 20, 20)

        local y
        local total = 0

        payload.attributes = {}

        -- total spendable attribute points
        local totalBar = attributes:Add("ixAttributeBar")
        totalBar:SetMax(maximum)
        totalBar:SetValue(maximum)
        totalBar:Dock(TOP)
        totalBar:DockMargin(2, 2, 2, 2)
        totalBar:SetText(L("attribPointsLeft"))
        totalBar:SetReadOnly(true)
        totalBar:SetColor(Color(20, 120, 20, 255))

        y = totalBar:GetTall() + 4

        for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
            payload.attributes[k] = 0

            local bar = attributes:Add("ixAttributeBar")
            bar:SetMax(maximum)
            bar:Dock(TOP)
            bar:DockMargin(2, 2, 2, 2)
            bar:SetText(L(v.name))
            bar.OnChanged = function(this, difference)
                if ((total + difference) > maximum) then
                    return false
                end

                total = total + difference
                payload.attributes[k] = payload.attributes[k] + difference

                totalBar:SetValue(totalBar.value - difference)
            end

            if (v.noStartBonus) then
                bar:SetReadOnly()
            end

            y = y + bar:GetTall() + 4
        end

        attributes:SetTall(y)
        return attributes
    end,
    OnValidate = function(self, value, data, client)
        if (value != nil) then
            if (istable(value)) then
                local count = 0

                for _, v in pairs(value) do
                    count = count + v
                end

                if (count > (hook.Run("GetDefaultAttributePoints", client, count) or 10)) then
                    return false, "unknownError"
                end
            else
                return false, "unknownError"
            end
        end
    end,
    ShouldDisplay = function(self, container, payload)
        return !table.IsEmpty(ix.attributes.list)
    end
})