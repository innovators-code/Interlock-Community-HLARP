
ITEM.name = "Ammo Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.ammo = "pistol" -- type of the ammo
ITEM.ammoAmount = 30 -- amount of the ammo
ITEM.description = "A Box that contains %s of Pistol Ammo"
ITEM.category = "Ammunition"
ITEM.useSound = "items/ammo_pickup.wav"

function ITEM:GetDescription()
    local rounds = self:GetData("rounds", self.ammoAmount)
    return Format(self.description, rounds)
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        draw.SimpleText(
            item:GetData("rounds", item.ammoAmount), "DermaDefault", w - 5, h - 5,
            color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black
        )
    end
end

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = {
    name = "Load",
    tip = "useTip",
    icon = "icon16/add.png",
    OnCanRun = function(item)
        local ply = item.player

        if ( ply.ixLoadingAmmo == true ) then
            ply:Notify("You need to wait before loading ammunition again!")
            return false
        end
    end,
    OnRun = function(item)
        local ply = item.player
        local rounds = item:GetData("rounds", item.ammoAmount)

        if ( ply.ixLoadingAmmo == true ) then
            ply:Notify("You need to wait before loading ammunition again!")
            return false
        end

        ply.ixLoadingAmmo = true
        ply:SetAction("Loading "..item.name.."...", 1, function()
            ply:GiveAmmo(rounds, item.ammo)
            ply:EmitSound(item.useSound, 90)
            ply.ixLoadingAmmo = nil
        end)

        return true
    end,
}

-- Called after the item is registered into the item tables.
function ITEM:OnRegistered()
    if (ix.ammo) then
        ix.ammo.Register(self.ammo)
    end
end
