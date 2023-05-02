
local PLUGIN = PLUGIN

function PLUGIN:OnPlayerObserve(ply, state)
    if (ply.rappelling) then
        self:EndRappel(ply)
    end
end
