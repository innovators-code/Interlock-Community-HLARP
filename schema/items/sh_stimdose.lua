-- Item Statistics

ITEM.name = "2cc Stimdose Syringe"
ITEM.description = "A syringe full of hardly known green substance intended for quick medicinal injection."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/willardnetworks/syringefull.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.HealAmount = 20
ITEM.Volume = 70
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Inject Yourself",
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
        ix.chat.Send(ply, "me", "injects a "..itemTable.name.." into themselves.", false)
        ply:SetNWBool("ixHealing", true)
        ply:SetAction("Injecting "..itemTable.name.."...", 4, function()
            ply:SetHealth(math.min(ply:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medicine", 0), ply:GetMaxHealth()))
            ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)

            ply:Notify("You injected a "..itemTable.name.." into your body and you have gained health.")
            ply:SetNWBool("ixHealing", false)
            return true
        end)
    end
}

ITEM.functions.ApplyTarget = {
    name = "Inject Target",
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
                ix.chat.Send(ply, "me", "injects a "..itemTable.name.." into the person infront of them.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 4, function()
                    ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)
                    target:EmitSound("items/smallmedkit1.wav", itemTable.Volume)
                    target:SetHealth(math.min(target:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medicine", 0), target:GetMaxHealth()))

                    ply:Notify("You injected a "..itemTable.name.." into the person infront of you.")
                    target:Notify(ply:Nick().." injected a "..itemTable.name.." into you and you have gained health.")
                    ply:UnLock()
                    target:UnLock()
                    return true
                end)
                return true
            end
        end

        return false
    end
}
