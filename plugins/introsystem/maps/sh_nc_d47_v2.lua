--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

ix.intro.config["rp_nc_d47_v2"] = { -- Define the map for the intro.
    music = "interlock/music/halflife/hl2/29 neutrino trap.ogg", -- music to play while intro is playing.
    pitch = 70, -- pitch of the music.
    view = { -- view to set when intro is playing.
        [1] = {
            {
                Vector(1736.9669189453, -2308.98828125, 229.955078125),
                Angle(9.4819717407227, -64.760803222656, 0)
            }, -- start position
            {
                Vector(877.20404052734, -2307.1477050781, 739.37036132813),
                Angle(-29.325969696045, -82.910888671875, 0)
            }, -- end position
            {80, 70}, -- Fov and zoom
            "This is a roleplay server set in the Half-Life: Alyx Universe. You play as an oppressed citizen.", -- intro text
        },
        [2] = {
            {
                Vector(321.57989501953, -756.34222412109, 932.11358642578),
                Angle(-6.6219472885132, -127.03475189209, 0)
            }, -- start position
            {
                Vector(-885.2685546875, -483.72955322266, 959.14996337891),
                Angle(-5.0379476547241, -71.858680725098, 0)
            }, -- end position
            {70, 60}, -- Fov and zoom
            "The Combine is a inter-dimensional Empire of unknown origin, that have taken control of earth in only 7 hours.", -- intro text
        },
        [3] = {
            {
                Vector(-109.55390930176, 870.62396240234, 482.43576049805),
                Angle(-11.637927055359, -163.56878662109, 0)
            }, -- start position
            {
                Vector(-115.68930053711, 930.66168212891, 482.43576049805),
                Angle(-11.835927009583, 174.38732910156, 0)
            }, -- end position
            {70, 60}, -- Fov and zoom
            "The Combine, being an interdimensional empire has no real regard for human buildings and architecture.\nAnd instead, will force their way through them. Creating a multitude of technical issues that hinder progress.", -- intro text
        },
        [4] = {
            {
                Vector(266.13754272461, -1316.7559814453, 473.59005737305),
                Angle(6.0500693321228, -84.002769470215, 0)
            }, -- start position
            {
                Vector(198.94200134277, -1365.4041748047, 470.39651489258),
                Angle(3.4100699424744, -121.22693634033, 0)
            }, -- end position
            {70, 60}, -- Fov and zoom
            "Every currency around earth has been replaced with tokens. Tokens and food rationed by the Combine are supplied at ration dispensers around the city.", -- intro text
        },
        [5] = {
            {
                Vector(-950.9609375, -1495.16796875, 210.26321411133),
                Angle(14.585839271545, -16.469747543335, 0)
            }, -- start position
            {
                Vector(-956.27227783203, -1894.5943603516, 210.26321411133),
                Angle(14.519839286804, 20.754249572754, 0)
            }, -- end position
            {70, 60}, -- Fov and zoom
            "Alternatively you can start your own company or join the branches of the Combine Infestation Control and Combine Engineer Core.", -- intro text
        },
        [6] = {
            {
                Vector(-1870.791015625, -79.159996032715, 587.98992919922),
                Angle(-0.021928653120995, 90.074989318848, 0)
            }, -- start position
            {
                Vector(-1297.3067626953, -78.40943145752, 587.98992919922),
                Angle(-0.021928653120995, 90.074989318848, 0)
            }, -- end position
            {70, 60}, -- Fov and zoom
            "You will be assigned to a apartment as a normal citizen, if you are lucky enough you may be alone in your room.\nYour room is your home, your only one..", -- intro text
        },
        [7] = {
            {
                Vector(4859.314453125, 1406.3010253906, -325.3703918457),
                Angle(-3.3219547271729, -115.77922821045, 0)
            }, -- start position
            {
                Vector(4762.6918945313, 959.43011474609, -297.04153442383),
                Angle(-3.9159545898438, -109.70706939697, 0)
            }, -- end position
            {70, 50}, -- Fov and zoom
            "However, if you wish to revolt against the Universal Union Empire, you may join the revolution.. though it is no easy task.", -- intro text
        },
        [8] = {
            {
                Vector(-610.38635253906, -508.53079223633, 593.2880859375),
                Angle(0.30804473161697, -81.063209533691, 0)
            }, -- start position
            {
                Vector(-41.480587005615, -488.42608642578, 1464.8081054688),
                Angle(-28.467975616455, -92.745376586914, 0)
            }, -- end position
            {70, 40}, -- Fov and zoom
            "Welcome to Conflict Studios: Half-Life Alyx Roleplay.", -- intro text
        },
    },
}