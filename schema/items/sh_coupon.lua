-- Item Statistics

ITEM.name = "Relocation Coupon"
ITEM.description = "A relocation coupon with ID #%s, assigned to %s. The relocated city is from %s."
ITEM.category = "Tools"

-- Item Configuration

ITEM.model = "models/dorado/tarjeta3.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

function ITEM:GetDescription()
    return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"), self:GetData("city", "unknown"))
end