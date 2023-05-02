
local PLUGIN = PLUGIN

PLUGIN.name = "Overwatch Rank Manager"
PLUGIN.author = "Gary Tate, wowm0d"
PLUGIN.description = "Allows Overwatch to manage ranks."
PLUGIN.schema = "IX:HLA RP"
PLUGIN.version = "1.3"
-- removed license due to file size

ix.lang.AddTable("english", {
    cmdCharRankDemote = "Demote an active Overwatch functionary.",
    cmdCharRankPromote = "Promote an active Overwatch functionary.",
    cmdCharRankSet = "Set the rank of an active Overwatch functionary.",
    cRankPromotion = "%s has promoted %s to %s.",
    cRankDemotion = "%s has demoted %s to %s.",
    cRankSet = "%s has set %s's rank to %s.",
    cRankMaxRank = "%s is already the maximum rank.",
    cRankMinRank = "%s is already the minimum rank.",
    cRankSameRank = "%s is already %s rank.",
    cRankInvalidRank = "%s is an invalid rank, cannot change their rank.",
    cRankInvalidFaction = "%s is not in a valid faction.",
    cRankInvalidInput = "'%s' is not a valid rank."
})

function PLUGIN:CanPlayerSetRanks(ply)
    if ( ply:IsCombineCommand() or ply:IsSuperAdmin() ) then
        return true
    end
end

if ( SERVER ) then
    timer.Simple(0, function()
        PLUGIN.rankTable = {
            [FACTION_CP] = {"RCT", "00", "10", "25", "50", "75", "99", "OfC", "RL", "CmD"},
            [FACTION_OTA] = {"GRUNT", "APF", "WALLHAMMER", "ORD", "CPT"}
        }

        -- Ignore Below --

        PLUGIN.rankMap = {}

        for _, ranks in next, PLUGIN.rankTable do
            PLUGIN.rankMap[ranks] = {}

            for index, rank in next, ranks do
                PLUGIN.rankMap[ranks][rank:lower()] = index
            end
        end
    end)
end

ix.command.Add("CharRankSet", {
    description = "@cmdCharRankSet",
    arguments = {
        ix.type.character,
        ix.type.string
    },
    OnCheckAccess = function(_, ply)
        return hook.Run("CanPlayerSetRanks", ply) == true
    end,
    OnRun = function(self, ply, target, rank)
        local targetRanks = PLUGIN.rankTable[target:GetFaction()]

        if (!targetRanks) then
            return "@cRankInvalidFaction", target:GetName()
        end

        local newRank = PLUGIN.rankMap[targetRanks][rank:lower()]

        if (!newRank) then
            return "@cRankInvalidInput", rank
        end

        local name = target:GetName()

        for index, rank in next, targetRanks do
            if (string.find(name, "[%D+]" .. rank .. "[%D+]")) then
                if (newRank == index) then
                    return "@cRankSameRank", name, rank
                end

                newRank = targetRanks[newRank]

                target:SetName(string.gsub(name, "([%D+])" .. rank .. "([%D+])", "%1" .. newRank .. "%2"))

                for _, v in next, player.GetAll() do
                    if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                        v:NotifyLocalized("cRankSet", ply:GetName(), name, newRank)
                    end
                end

                return
            end
        end

        return "@cRankInvalidRank", name
    end
})

ix.command.Add("CharRankPromote", {
    description = "@cmdCharRankPromote",
    arguments = ix.type.character,
    OnCheckAccess = function(_, ply)
        return hook.Run("CanPlayerSetRanks", ply) == true
    end,
    OnRun = function(self, ply, target)
        local targetRanks = PLUGIN.rankTable[target:GetFaction()]

        if (!targetRanks) then
            return "@cRankInvalidFaction", target:GetName()
        end

        local name = target:GetName()

        for index, rank in next, targetRanks do
            if (string.find(name, "[%D+]" .. rank .. "[%D+]")) then
                if (index == #targetRanks) then
                    return "@cRankMaxRank", name
                end

                local newRank = targetRanks[index + 1]

                target:SetName(string.gsub(name, "([%D+])" .. rank .. "([%D+])", "%1" .. newRank .. "%2"))

                for _, v in next, player.GetAll() do
                    if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                        v:NotifyLocalized("cRankPromotion", ply:GetName(), name, newRank)
                    end
                end

                return
            end
        end

        return "@cRankInvalidRank", name
    end
})

ix.command.Add("CharRankDemote", {
    description = "@cmdCharRankDemote",
    arguments = ix.type.character,
    OnCheckAccess = function(_, ply)
        return hook.Run("CanPlayerSetRanks", ply) == true
    end,
    OnRun = function(self, ply, target)
        local targetRanks = PLUGIN.rankTable[target:GetFaction()]

        if (!targetRanks) then
            return "@cRankInvalidFaction", target:GetName()
        end

        local name = target:GetName()

        for index, rank in next, targetRanks do
            if (string.find(name, "[%D+]" .. rank .. "[%D+]")) then
                if (index == 1) then
                    return "@cRankMinRank", name
                end

                local newRank = targetRanks[index - 1]

                target:SetName(string.gsub(name, "([%D+])" .. rank .. "([%D+])", "%1" .. newRank .. "%2"))

                for _, v in next, player.GetAll() do
                    if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                        v:NotifyLocalized("cRankDemotion", ply:GetName(), name, newRank)
                    end
                end

                return
            end
        end

        return "@cRankInvalidRank", name
    end
})
