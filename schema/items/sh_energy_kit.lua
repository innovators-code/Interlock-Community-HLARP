-- Item Statistics

ITEM.name = "Energy-Powered PCV Battery"
ITEM.description = "A battery capable of restoring PCV systems by a large amount."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/Items/battery.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.ArmorAmount = 60
ITEM.Volume = 80
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Restore PCV",
    icon = "icon16//shield.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ( ply:Armor() < ply:GetMaxArmor() ) ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        ix.chat.Send(ply, "me", "charges an "..itemTable.name.." on their armor.", false)
        ply:Lock()
        ply:SetAction("Charging "..itemTable.name.."...", 4, function()
            ply:SetArmor(math.min(ply:Armor() + itemTable.ArmorAmount, ply:GetMaxArmor()))
            ply:EmitSound("items/battery_pickup.wav", itemTable.Volume)

            ply:Notify("You charged an "..itemTable.name.." on your armor and you have gained more PCV shielding.")
            ply:UnLock()
            return true
        end)
    end
}

ITEM.functions.ApplyTarget = {
    name = "Restore Target PCV",
    icon = "icon16/shield_go.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) and ( target:Armor() < target:GetMaxArmor() ) then
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
                ix.chat.Send(ply, "me", "charges an "..itemTable.name.." on the person infront of them.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Charging "..itemTable.name.."...", 4, function()
                    ply:EmitSound("items/battery_pickup.wav", itemTable.Volume)
                    target:EmitSound("items/battery_pickup.wav", itemTable.Volume)
                    target:SetArmor(math.min(target:Armor() + itemTable.ArmorAmount, target:GetMaxArmor()))

                    ply:Notify("You charged an "..itemTable.name.." into your targets armor and they have gained PCV shielding.")
                    target:Notify(ply:Nick().." charged an "..itemTable.name.." on your armor and you have gained more PCV shielding.")
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
