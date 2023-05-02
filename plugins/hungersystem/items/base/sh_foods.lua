
ITEM.name = "Consumable Base"
ITEM.model = Model("models/props_junk/garbage_takeoutcarton001a.mdl")
ITEM.description = "A base for consumables."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"

ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav"
ITEM.useName = "Consume"

ITEM.RestoreHunger = 0
ITEM.RestoreHealth = 0
ITEM.damage = 0
ITEM.spoilTime = 14

ITEM.cookable = false
ITEM.cookTime = 5
ITEM.cookResult = nil

function ITEM:GetName()
    if (self:GetSpoiled()) then
        local spoilText = self.spoilText or "Spoiled"
        return spoilText.." "..self.name
    end

    return self.name
end

function ITEM:GetDescription()
    local description = {self.description}
    if (!self:GetSpoiled() and self:GetData("spoilTime")) then
        local spoilTime = math.floor((self:GetData("spoilTime") - os.time()) / 60)
        local text = " minutes."
        if (spoilTime > 60) then
            text = " hours."
            spoilTime = math.floor(spoilTime / 60)
        end

        if (spoilTime > 24) then
            text = " days."
            spoilTime = math.floor(spoilTime / 24)
        end

        description[#description + 1] = "\nSpoils in "..spoilTime..text
    end

    return table.concat(description, "")
end

function ITEM:GetSpoiled()
    local spoilTime = self:GetData("spoilTime")
    if (!spoilTime) then
        return false
    end

    return os.time() > spoilTime
end

function ITEM:OnInstanced()
    if (self.spoil) then
        self:SetData("spoilTime", os.time() + 24 * 60 * 60 * self.spoilTime)
    end
end

ITEM.functions.Consume = {
    icon = "icon16/user.png",
    name = "Consume",
    OnRun = function(item)
        local ply = item.player
        local character = item.player:GetCharacter()
        local bSpoiled = item:GetSpoiled()
        local actiontext = "Invalid Action"

        if ( ply.isEatingConsumeable == true ) then
            ply:Notify("You can't stuff too much food in your mouth, bruh.")
            return false
        end

        if (item.useSound) then
            if string.find(item.useSound, "drink") then
                actiontext = "Drinking..."
            else
                actiontext = "Eating..."
            end
        end

        local function EatFunction(ply, character, bSpoiled)
            if not (ply:IsValid() and ply:Alive() and character) then return end

            if (item.damage > 0) then
                ply:TakeDamage(item.damage, ply, ply)
            end
    
            if (item.junk) then
                if (!character:GetInventory():Add(item.junk)) then
                    ix.item.Spawn(item.junk, ply)
                end
            end
    
            if (item.useSound) then
                if (istable(item.useSound)) then
                    ply:EmitSound(table.Random(item.useSound))
                else
                    ply:EmitSound(item.useSound)
                end
            end
    
            if (!bSpoiled) then
                if (item.RestoreHunger > 0) then
                    character:SetHunger(math.Clamp(character:GetHunger() + item.RestoreHunger, 0, 100))
                end
    
                if (item.RestoreHealth > 0) then
                    ply:SetHealth(math.Clamp(ply:Health() + item.RestoreHealth, 0, ply:GetMaxHealth()))
                end
            else
                ply:TakeDamage(math.random(1,5))
            end
        end

        if (item.useTime) then
            ply.isEatingConsumeable = true
            ply:SetAction(actiontext, item.useTime, function()
                EatFunction(ply, character, bSpoiled)

                ply.isEatingConsumeable = false
            end)
        else
            EatFunction(ply, character, bSpoiled)
        end
    end
}

ITEM.functions.cook = {
    icon = "icon16/fire.png",
    name = "Cook",
    OnCanRun = function(item)
        if not ( item.cookable and item.cookResult ) then
            return false
        end

        local ply = item.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local stove = util.TraceLine(data).Entity

        if not ( IsValid(stove) and stove:IsStove() ) then
            return false
        end
    end,
    OnRun = function(item)
        local ply = item.player
        local char = item.player:GetCharacter()

        local function CookFunction(ply, char, cookResult)
            if not ( ply:IsValid() and ply:Alive() and char ) then return end
            if not ( ix.item.Get(cookResult) ) then return end

            if not ( char:GetInventory():Add(ix.item.Get(cookResult).uniqueID) ) then
                ix.item.Spawn(ix.item.Get(cookResult).uniqueID, ply)
            end

            ply:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav", 60, 80)

            local data = {}
                data.start = ply:GetShootPos()
                data.endpos = data.start + ply:GetAimVector() * 96
                data.filter = ply
            local stove = util.TraceLine(data).Entity
    
            if not ( IsValid(stove) and stove:IsStove() ) then
                return false
            end

            stove:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav", 60, 80)
        end

        if ( item.cookable and item.cookResult ) then
            if ( item.cookTime ) then
                ply:Freeze(true)
                ply.isCookingConsumeable = true
                ply:SetAction("Cooking...", item.cookTime, function()
                    CookFunction(ply, char, item.cookResult)
                    ply:Freeze(false)
                    ply.isCookingConsumeable = false
                end)
            else
                CookFunction(ply, char, item.cookResult)
            end
        end
    end
}