PLUGIN.name = "Refilled"
PLUGIN.author = "Lechu2375"
PLUGIN.desc = "Allows players to refill stock of the vendor, vending machines and even ration distributors."
ix.util.Include("core/sv_core.lua")
ix.util.Include("core/cl_derma.lua")


ix.command.Add("refill", {
    description = "refill box",
    AdminOnly = true,
    OnRun = function(self, client, text)
        local ent = client:GetEyeTraceNoCursor().entity
        if IsValid(ent) and ent:GetClass()=="ix_item" then
            PrintTable(ent:GetItemTable())
        end
    end
})

