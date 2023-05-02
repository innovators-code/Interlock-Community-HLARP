ix.command.Add("report", {
    description = "Sends (or updates) a report to the game moderators.",
    arguments = {
        ix.type.number,
        ix.type.string,
    },
    OnRun = function(self, ply, arg, rawText)
        ix.ops.ReportNew(ply, arg, rawText)
    end
})

ix.command.Add("rc", {
    description = "Claims a report for review.",
    adminOnly = true,
    arguments = {
        ix.type.number,
    },
    OnRun = function(self, ply, arg)
        ix.ops.ReportClaim(ply, arg)
    end
})

ix.command.Add("rcl", {
    description = "Closes a report.",
    adminOnly = true,
    arguments = {
        ix.type.number,
    },
    OnRun = function(self, ply, arg)
        ix.ops.ReportClose(ply, arg)
    end
})

ix.command.Add("rgoto", {
    description = "Teleports yourself to the reportee of your claimed report.",
    adminOnly = true,
    arguments = {
        ix.type.number,
    },
    OnRun = function(self, ply, arg)
        ix.ops.ReportGoto(ply, arg)
    end
})

ix.command.Add("rmsg", {
    description = "Messages the reporter of your claimed report.",
    adminOnly = true,
    arguments = {
        ix.type.number,
        ix.type.string,
    },
    OnRun = function(self, ply, arg, rawText)
        ix.ops.ReportMsg(ply, arg, rawText)
    end
})