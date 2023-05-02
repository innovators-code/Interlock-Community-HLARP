-- Item Statistics

ITEM.name = "Bandage"
ITEM.description = "A Cloth, can be used to cover wounds to stop bleeding."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/stuff/bandages.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.HealAmount = 15
ITEM.Volume = 70
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Bandage Yourself",
    icon = "icon16/heart.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ( ply:Health() < ply:GetMaxHealth() ) ) and not ( ply:GetNWBool("ixHealing", false) == true ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        ix.chat.Send(ply, "me", "wraps around a "..itemTable.name.." on themselves.", false)
        ply:SetNWBool("ixHealing", true)
        ply:SetAction("Wrapping "..itemTable.name.."...", 2, function()
            ply:SetHealth(math.min(ply:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medicine", 0), ply:GetMaxHealth()))
            ply:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,7)..".wav", itemTable.Volume)

            ply:Notify("You applied a "..itemTable.name.." on yourself and you have gained health.")
            ply:SetNWBool("ixHealing", false)
            return true
        end)
    end
}

ITEM.functions.ApplyTarget = {
    name = "Bandage Target",
    icon = "icon16/heart_add.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) and ( target:Health() < target:GetMaxHealth() ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ix.chat.Send(ply, "me", "wraps a "..itemTable.name.." on the person infront of them.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Wrapping "..itemTable.name.."...", 2, function()
                    ply:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,7)..".wav", itemTable.Volume)
                    target:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,7)..".wav", itemTable.Volume)
                    target:SetHealth(math.min(target:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medicine", 0), target:GetMaxHealth()))

                    ply:Notify("You applied a "..itemTable.name.." on your target and they have gained health.")
                    target:Notify(ply:Nick().." applied a "..itemTable.name.." on you and you have gained health.")
                    ply:UnLock()
                    target:UnLock()
                end)
                return true
            end
        end

        return false
    end
}
