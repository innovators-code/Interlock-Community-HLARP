-- Item Statistics

ITEM.name = "Zip-Tie"
ITEM.description = "An orange zip-tie used to restrict people."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Functions

ITEM.functions.Use = {
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if (IsValid(target) and target:IsPlayer() and target:GetCharacter() and !target:GetNetVar("tying") and !target:IsRestricted()) then
            itemTable.bBeingUsed = true

            ply:SetAction("Tying...", 5)

            ply:DoStaredAction(target, function()
                target:SetRestricted(true)
                target:SetNetVar("tying")
                target:Notify("You have been tied up.")

                if ( target:IsCombine() ) then
                    Schema:AddDisplay("Downloading lost radio contact information...")
                    Schema:AddDisplay("WARNING! Radio contact lost for unit at unknown location...", Color(255, 0, 0))
                end

                itemTable:Remove()
            end, 5, function()
                ply:SetAction()

                target:SetAction()
                target:SetNetVar("tying")

                itemTable.bBeingUsed = false
            end)

            target:SetNetVar("tying", true)
            target:SetAction("You are being tied up.", 5)
        else
            ply:NotifyLocalized("plyNotValid")
        end

        return false
    end,
    OnCanRun = function(itemTable)
        return !IsValid(itemTable.entity) or itemTable.bBeingUsed
    end
}

function ITEM:CanTransfer(inventory, newInventory)
    return !self.bBeingUsed
end
