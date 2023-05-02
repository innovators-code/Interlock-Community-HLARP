-- Item Statistics

ITEM.name = "2cc Nirvana"
ITEM.description = "A syringe with two doses of unknown substance."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/willardnetworks/skills/pyscho.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Functions

ITEM.functions.InjectCureSelf = {
    name = "Inject Yourself",
    icon = "icon16/pill.png",
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

        ply:Lock()
        ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
            ply:UnLock()

            ply:ChatNotify("You have been injected with a cure for amnesia, you have remembered everything taken away from amnestics.")
        end)

        return true
    end
}

ITEM.functions.InjectCure = {
    name = "Inject Target",
    icon = "icon16/pill_go.png",
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
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected an amnestic cure into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with a cure for amnesia, you have remembered everything taken away from amnestics.")
                end)

                return true
            end
        end

        return false
    end
}
