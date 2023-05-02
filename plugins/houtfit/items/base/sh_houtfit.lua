
ITEM.name = "Bodygroup Clothing"
ITEM.model = Model("models/props_c17/BriefCase001a.mdl")
ITEM.description = "A generic piece of clothing."

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        if (item:GetData("equip")) then
            surface.SetDrawColor(110, 255, 110, 100)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
        end
    end

    function ITEM:PopulateTooltip(tooltip)
        if (self:GetData("equip")) then
            local name = tooltip:GetRow("name")
            name:SetBackgroundColor(derma.GetColor("Success", tooltip))
        end

        if (self.maxArmor) then
            local panel = tooltip:AddRowAfter("name", "armor")
            panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
            panel:SetText("Armor: " .. (self:GetData("equip") and LocalPlayer():Armor() or self:GetData("armor", self.maxArmor)))
            panel:SizeToContents()
        end
    end
end

function ITEM:RemoveOutfit(ply)
    local char = ply:GetCharacter()
    self:SetData("equip", false)
    if (self.maxArmor) then
        self:SetData("armor", math.Clamp(ply:Armor(), 0, self.maxArmor))
        ply:SetArmor(0)
    end

    if (char:GetData("oldModel" .. self.outfitCategory)) then
        char:SetModel(char:GetData("oldModel" .. self.outfitCategory))
        char:SetData("oldModel" .. self.outfitCategory, nil)
    end

    if (self.newSkin) then
        if (char:GetData("oldSkin" .. self.outfitCategory)) then
            ply:SetSkin(char:GetData("oldSkin" .. self.outfitCategory))
            char:SetData("oldSkin" .. self.outfitCategory, nil)
            char:SetData("skin", ply:GetSkin())
        else
            ply:SetSkin(0)
        end
    end

    if ( self.bodyGroups ) then
        for k in pairs(self.bodyGroups) do
            local index = ply:FindBodygroupByName(k)
            local char = ply:GetCharacter()
            local groups = char:GetData("groups", {})

            if (index > -1) then
                groups[index] = 0
                char:SetData("groups", groups)
                ply:SetBodygroup(index, 0)
            end
        end
    end
end

ITEM:Hook("drop", function(item)
    if (item:GetData("equip")) then
        item:RemoveOutfit(item:GetOwner())
    end
end)

ITEM.functions.Repair = {
    name = "Repair",
    tip = "repairTip",
    icon = "icon16/wrench.png",
    OnRun = function(item)
        item:Repair(item.player)
        item.player:GetCharacter():GetInventory():HasItem("tool_repair"):Remove()
        return false
    end,
    OnCanRun = function(item)
        local ply = item.player
        return (item.maxArmor != nil and item:GetData("equip") == false and !IsValid(item.entity) and IsValid(ply) and ply:GetCharacter():GetInventory():HasItem("tool_repair") and item:GetData("armor") < item.maxArmor)
    end,
}

ITEM.functions.EquipUn = {
    name = "Unequip",
    tip = "unequipTip",
    icon = "icon16/cross.png",
    OnRun = function(item)
        if (item.player) then
            item:RemoveOutfit(item.player)

            if item.OnUnEquip then
                item:OnUnEquip(item.player, item)
            end
        else
            item:SetData("equip", false)

            if item.OnUnEquip then
                item:OnUnEquip(item.player, item)
            end
        end

        item.player:EmitSound("interlock/player/arm_oneshot_0"..math.random(1,7)..".ogg", 70, math.random(90,110))
        
        return false
    end,
    OnCanRun = function(item)
        local ply = item.player

        return !IsValid(item.entity) and IsValid(ply) and item:GetData("equip") == true and
            hook.Run("CanPlayerUnequipItem", ply, item) != false and item:CanUnequipOutfit()
    end
}

ITEM.functions.Equip = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(item, creationClient)
        local ply = item.player or creationClient
        local char = ply:GetCharacter()
        local items = char:GetInventory():GetItems()
        local groups = char:GetData("groups", {})

        -- Checks if any [Torso] is already equipped.
        for _, v in pairs(items) do
            if ( v.id != item.id ) then
                local itemTable = ix.item.instances[v.id]

                if ( v.outfitCategory == item.outfitCategory and itemTable:GetData("equip") ) then
                    ply:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
                    return false
                end
            end
        end

        item:SetData("equip", true)
        
        if (isfunction(item.OnGetReplacement)) then
            char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
            char:SetModel(item:OnGetReplacement())
        elseif (item.replacement or item.replacements) then
            char:SetData("oldModel" .. item.outfitCategory, char:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

            if (istable(item.replacements)) then
                if (#item.replacements == 2 and isstring(item.replacements[1])) then
                    char:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
                else
                    for _, v in ipairs(item.replacements) do
                        char:SetModel(item.player:GetModel():gsub(v[1], v[2]))
                    end
                end
            else
                char:SetModel(item.replacement or item.replacements)
            end
        end

        if (item.newSkin) then
            char:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
            char:SetData("skin", item.newSkin)

            item.player:SetSkin(item.newSkin)
        end

        if (item.maxArmor) then
            ply:SetArmor(item:GetData("armor", item.maxArmor))
        end

        if (item.bodyGroups) then
            for k, value in pairs(item.bodyGroups) do
                local index = ply:FindBodygroupByName(k)

                if (index > -1) then
                    groups[index] = value
                    char:SetData("groups", groups)
                    ply:SetBodygroup(index, value)

                    if item.OnEquip then
                        item:OnEquip(ply, item)
                    end
                end
            end
        end

        ply:EmitSound("interlock/player/arm_oneshot_0"..math.random(1,7)..".ogg", 70, math.random(90,110))

        return false
    end,
    OnCanRun = function(item)
        local ply = item.player
        if item.allowedModels and !table.HasValue(item.allowedModels, ply:GetCharacter():GetModel()) then
            return false
        end

        if item.factionList and !table.HasValue(item.factionList, ply:GetCharacter():GetFaction()) then
            return false
        end

        return !IsValid(item.entity) and IsValid(ply) and item:GetData("equip") != true and
            hook.Run("CanPlayerEquipItem", ply, item) != false and item:CanEquipOutfit()
    end
}

function ITEM:Repair(ply, amount)
    amount = amount or self.maxArmor
    local repairItem = ply:GetCharacter():GetInventory():HasItem("tool_repair")

    if (repairItem) then
        if (repairItem.isTool) then
            repairItem:DamageDurability(1)
        end

        self:SetData("armor", math.Clamp(self:GetData("armor") + amount, 0, self.maxArmor))
    end
end

function ITEM:CanTransfer(oldInventory, newInventory)
    if (newInventory and self:GetData("equip")) then
        return false
    end

    return true
end

function ITEM:OnInstanced()
    if (self.maxArmor) then
        self:SetData("armor", self.maxArmor)
    end
end

function ITEM:OnRemoved()
    if (self.invID != 0 and self:GetData("equip")) then
        self.player = self:GetOwner()
        self:RemoveOutfit(self.player)

        if self.OnUnEquip then
            self:OnUnEquip()
        end

        self.player = nil
    end
end

function ITEM:OnLoadout()
    if (self.maxArmor and self:GetData("equip")) then
        self.player:SetArmor(self:GetData("armor", self.maxArmor))
    end
end

function ITEM:OnSave()
    if (self:GetData("equip") and self.maxArmor) then
        local armor = math.Clamp(self.player:Armor(), 0, self.maxArmor)
        self:SetData("armor", armor)
        if (armor != self.player:Armor()) then
            self.player:SetArmor(armor)
        end
    end
end

function ITEM:CanEquipOutfit()
    if (self.maxArmor) then
        local bgItems = self.player:GetCharacter():GetInventory():GetItemsByBase("base_houtfit", true)
        for _, v in pairs(bgItems) do
            if (v:GetData("equip") and v.maxArmor) then
                return false
            end
        end
    end

    return true
end

function ITEM:CanUnequipOutfit()
    return true
end
