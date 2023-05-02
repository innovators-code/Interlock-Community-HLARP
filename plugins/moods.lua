
local PLUGIN = PLUGIN
local pk_pills = pk_pills or {}

PLUGIN.name = "Emote Moods"
PLUGIN.author = "DrodA (Ported from NS)"
PLUGIN.description = "With this plugin, characters can set their mood."
PLUGIN.schema = "Any"
PLUGIN.version = 1.1

do
    MOOD_NONE = 0
    MOOD_RELAXED = 1
    MOOD_FRUSTRATED = 2
    MOOD_MODEST = 3
    MOOD_PANICKED = 4
    MOOD_FEAR = 5

    PLUGIN.MoodTextTable = {
        [MOOD_NONE] = "Default",
        [MOOD_RELAXED] = "Relaxed",
        [MOOD_FRUSTRATED] = "Frustrated",
        [MOOD_MODEST] = "Modest",
        [MOOD_PANICKED] = "Panicked",
        [MOOD_FEAR] = "Fearful",
    }

    PLUGIN.MoodBadMovetypes = {
        [MOVETYPE_FLY] = true,
        [MOVETYPE_LADDER] = true,
        [MOVETYPE_NOCLIP] = true
    }

    PLUGIN.MoodAnimTable = {
        [MOOD_RELAXED] = {
            [0] = "LineIdle01",
            [1] = "walk_all_Moderate",
        },
        [MOOD_FRUSTRATED] = {
            [0] = "LineIdle02",
            [1] = "pace_all",
            [2] = "run_all_panicked",
        },
        [MOOD_MODEST] = {
            [0] = "LineIdle04",
            [1] = "plaza_walk_all",
        },
        [MOOD_PANICKED] = {
            [0] = "crouchIdle_panicked4",
            [1] = "walk_panicked_all",
            [2] = "crouchRUNALL1",
        },
        [MOOD_FEAR] = {
            [0] = "scaredidle",
            [1] = "walk_panicked_all",
            [2] = "run_protected_all",
        }
    }
end

do
    local meta = FindMetaTable("Player")

    function meta:GetMood()
        return self:GetNetVar("mood") or MOOD_NONE
    end

    if (SERVER) then
        function meta:SetMood(int)
            int = int or 0
            self:SetNetVar("mood", int)
        end
    end
end

if (SERVER) then
    function PLUGIN:PlayerLoadedCharacter(ply, character)
        ply:SetMood(MOOD_NONE)
    end
end

do
	local moodToEnum = {
		[ "default" ] = 0,
		[ "relaxed" ] = 1,
		[ "frustrated" ] = 2,
		[ "modest" ] = 3,
		[ "panicked" ] = 4,
		[ "fearful" ] = 5
	}
    ix.command.Add("Mood", {
        description = "Set your own mood. These can be: Default, Relaxed, Frustrated, Modest, Panicked, Fearful.",
        arguments = {ix.type.string},
        OnRun = function(_, ply, mood)
			local m = moodToEnum[ mood:lower() ]

			if ( !m ) then
				ply:SetMood( MOOD_NONE )
				return "Not a valid mood"
			end

			ply:SetMood( m )
        end
    })

    local tblWorkaround = {["ix_keys"] = true, ["ix_hands"] = true}
    function PLUGIN:CalcMainActivity(ply, velocity)
        local length = velocity:Length2DSqr()
        local plyInfo = ply:GetTable()

        local mood = ply:GetMood()
        local pkExist = pcall(pk_pills.getMappedEnt, ply)
        local pkpill
        if ( pkExist ) then
            pkpill = pk_pills.getMappedEnt(ply)
        end

        if ( IsValid(pkpill) ) then return end

        if ( ply and IsValid(ply) and ply:IsPlayer() ) then
            if ( !ply:IsWepRaised() and !ply:Crouching() and IsValid(ply:GetActiveWeapon()) and tblWorkaround[ply:GetActiveWeapon():GetClass()] and !ply:InVehicle() and mood > 0 and !self.MoodBadMovetypes[ply:GetMoveType()] and !ply.m_bJumping and ply:IsOnGround() ) then
                if ( length < 0.25 ) then
                    plyInfo.CalcSeqOverride = self.MoodAnimTable[mood][0] and ply:LookupSequence(self.MoodAnimTable[mood][0]) or plyInfo.CalcSeqOverride
                elseif ( length > 0.25 and length < 22500 ) then
                    plyInfo.CalcSeqOverride = self.MoodAnimTable[mood][1] and ply:LookupSequence(self.MoodAnimTable[mood][1]) or plyInfo.CalcSeqOverride
                elseif ( length > 22500 ) then
                    plyInfo.CalcSeqOverride = self.MoodAnimTable[mood][2] and ply:LookupSequence(self.MoodAnimTable[mood][2]) or plyInfo.CalcSeqOverride
                end
            end
        end
    end
end
