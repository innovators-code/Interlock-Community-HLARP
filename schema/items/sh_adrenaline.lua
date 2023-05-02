-- Item Statistics

ITEM.name = "Adrenaline Shot"
ITEM.description = "A syringe shot that contains a substance which boosts the energy of who is injected with it."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/willardnetworks/skills/adrenaline.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.StaminaAmount = 60
ITEM.Volume = 80
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Inject Yourself",
    icon = "icon16/heart.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() ) and not ( ply:GetNWBool("ixHealing", false) == true ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        ix.chat.Send(ply, "me", "injects an "..itemTable.name.." into their leg.", false)
        ply:SetNWBool("ixHealing", true)
        ply:SetAction("Injecting "..itemTable.name.."...", 4, function()
            ply:RestoreStamina(itemTable.StaminaAmount)
            ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)

            ply:Notify("You injected an "..itemTable.name.." into your leg, you feel exertion surging through your body.")
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

        if ( IsValid(target) and target:IsPlayer() ) then
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
                ix.chat.Send(ply, "me", "injects an "..itemTable.name.." into the person infront of them.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 4, function()
                    ply:EmitSound("items/smallmedkit1.wav", itemTable.Volume)
                    target:EmitSound("items/smallmedkit1.wav", itemTable.Volume)
                    target:RestoreStamina(itemTable.StaminaAmount)

                    ply:Notify("You injected an "..itemTable.name.." into your target and they have gained stamina.")
                    target:Notify(ply:Nick().." injected an "..itemTable.name.." into you, you feel exertion surging through your body.")
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
