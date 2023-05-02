-- Item Statistics

ITEM.name = "Bread Slice"
ITEM.description = "A slice of fresh bread. Doesn't fill you up much on its own but it'll do."
ITEM.category = "Food"
ITEM.model = "models/willardnetworks/food/bread_slice.mdl"

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

ITEM.iconCam = {
    pos = Vector(258.35, 217.47, 159.76),
    ang = Angle(25.26, 220.13, 0),
    fov = 1.25,
}

-- Item Custom Configuration

ITEM.useTime = 3
ITEM.useSound = "interlock/player/eat.ogg"
ITEM.RestoreHunger = 5
ITEM.spoil = true