--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

ix.intro.config["rp_city17_conflictstudios_update"] = { -- Define the map for the intro.
    music = "interlock/music/halflife/hl1/02 vague voices.ogg", -- music to play while intro is playing.
    pitch = 70, -- pitch of the music.
    view = { -- view to set when intro is playing.
        [1] = {
            {
                Vector(-4638.716796875, -330.74649047852, 165.74917602539),
                Angle(3.233847618103, 7.6555662155151, 0)
            }, -- start position
            {
                Vector(-3460.1955566406, -314.27404785156, 115.24200439453),
                Angle(-8.5141506195068, 35.177619934082, 0)
            }, -- end position
            {80, 70}, -- Fov and zoom
            "This is a roleplay server set in the Half-Life: Alyx Universe. You play as an oppressed citizen.", -- intro text
        },
        [2] = {
            {
                Vector(-547.76953125, -446.58770751953, 263.20443725586),
                Angle(12.275883674622, -24.22241973877, 0)
            }, -- start position
            {
                Vector(-702.83038330078, 195.72491455078, 626.78125),
                Angle(-36.432121276855, -6.0724339485168, 0)
            }, -- end position
            {70, 40}, -- Fov and zoom
            "The Combine is a inter-dimensional Empire of unknown origin, that have taken control of earth in only 7 hours.", -- intro text
        },
        [3] = {
            {
                Vector(2807.6623535156, -610.09210205078, 866.90014648438),
                Angle(-31.152139663696, -18.546285629272, 0)
            }, -- start position
            {
                Vector(3133.2817382813, 16.267772674561, 342.78192138672),
                Angle(1.9798511266708, 0.26368713378906, 0)
            }, -- end position
            {70, 40}, -- Fov and zoom
            "The Combine, being an interdimensional empire has no real regard for human buildings and architecture.\nAnd instead, will force their way through them. Creating a multitude of technical issues that hinder progress.", -- intro text
        },
        [4] = {
            {
                Vector(-1746.3959960938, 158.95359802246, 268.64486694336),
                Angle(0.3958438038826, 159.32432556152, 0)
            }, -- start position
            {
                Vector(-1830.93359375, -268.55889892578, 264.17794799805),
                Angle(14.651841163635, -154.14572143555, 0)
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
                Vector(-3200.8813476563, -2933.9477539063, 486.97155761719),
                Angle(-0.39615869522095, 0.36055609583855, 0)
            }, -- start position
            {
                Vector(-2528.7751464844, -2930.5207519531, 554.87799072266),
                Angle(11.483839035034, 0.36055612564087, 0)
            }, -- end position
            {70, 50}, -- Fov and zoom
            "You will be assigned to a apartment as a normal citizen, if you are lucky enough you may be alone in your room.\nYour room is your home, your only one..", -- intro text
        },
        [7] = {
            {
                Vector(-144.29756164551, 4504.876953125, 252.24612426758),
                Angle(-4.2555236816406, 20.901029586792, 0.00018257058400195)
            }, -- start position
            {
                Vector(1568.0356445313, 4315.0541992188, 245.01655578613),
                Angle(1.6013238430023, -9.8113965988159, 1.6147964743141e-06)
            }, -- end position
            {70, 50}, -- Fov and zoom
            "However, if you wish to revolt against the Universal Union Empire, you may join the revolution.. though it is no easy task.", -- intro text
        },
        [8] = {
            {
                Vector(-798.00604248047, 358.42056274414, 297.05316162109),
                Angle(-1.0099465847015, -29.422327041626, 8.7605447333772e-05)
            }, -- start position
            {
                Vector(-639.21429443359, 281.77270507813, 371.16732788086),
                Angle(-44.412818908691, -17.115379333496, 0.00068546563852578)
            }, -- end position
            {70, 40}, -- Fov and zoom
            "Welcome to Conflict Studios: Half-Life Alyx Roleplay.", -- intro text
        },
    },
}