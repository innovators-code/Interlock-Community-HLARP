-- Item Statistics

ITEM.name = "3cc Incognizance Inducer"
ITEM.description = "A strange, white packaged, and viscous substance."
ITEM.category = "Medical Items"

-- Item Configuration

ITEM.model = "models/willardnetworks/skills/pyscho.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Functions

ITEM.functions.InjectClassAAmnestic = {
    name = "Inject Class A Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class A amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 1 week.")
                end)

                return true
            end
        end

        return false
    end
}

ITEM.functions.InjectClassBAmnestic = {
    name = "Inject Class B Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class B amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 3 days.")
                end)

                return true
            end
        end

        return false
    end
}

ITEM.functions.InjectClassCAmnestic = {
    name = "Inject Class C Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class C amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 1 day.")
                end)

                return true
            end
        end

        return false
    end
}

ITEM.functions.InjectClassDAmnestic = {
    name = "Inject Class D Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class D amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 12 hours.")
                end)

                return true
            end
        end

        return false
    end
}

ITEM.functions.InjectClassEAmnestic = {
    name = "Inject Class E Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class E amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 6 hours.")
                end)

                return true
            end
        end

        return false
    end
}

ITEM.functions.InjectClassFAmnestic = {
    name = "Inject Class F Dose",
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

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ply:Lock()
                target:Lock()
                ply:SetAction("Injecting "..itemTable.name.."...", 2, function()
                    ply:UnLock()
                    target:UnLock()

                    ply:ChatNotify("You have injected Class F amnestics into "..target:Nick()..".")
                    target:ChatNotify("You have been injected with an amnestic, you have forgotten up to 2 hours.")
                end)

                return true
            end
        end

        return false
    end
}
