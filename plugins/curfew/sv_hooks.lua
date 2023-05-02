local PLUGIN = PLUGIN

function PLUGIN:LoadData()
    self:LoadCurfewTerminals()
end

function PLUGIN:SaveData()
    self:SaveCurfewTerminals()
end

function PLUGIN:Think()
    self.nextTick = self.nextTick or 0
    if ( self.nextTick < CurTime() ) then
        self.nextTick = CurTime() + 0.5

        -- Stuff for the start/end event system
        for i, v in ipairs( self.schedule ) do
            if ( StormFox2.Time.Get(true) == v[ 2 ] ) then
                hook.Run( "CurfewEvent", v, true )
            elseif ( StormFox2.Time.Get(true) == v[ 3 ] ) then
                hook.Run( "CurfewEvent", v, false )
            end
        end
    end
end

-- Workaround for something I'm too lazy to fix
function PLUGIN:PhysgunPickup( client, entity )
    if ( entity:GetClass() == "ix_curfewterminal" ) then
        entity:SetNetVar( "bHeld", true )
    end
end

function PLUGIN:PhysgunDrop( client, entity )
    if ( entity:GetNetVar( "bHeld" ) ) then
        entity:SetNetVar( "bHeld", nil )
    end
end

-- If you wanna do any extra stuff with events
-- then edit this hook
function PLUGIN:CurfewEvent( event, bStart )
    local call = event[ 4 ]

    print( "Curfew event: " .. event[1] ..  " " .. tostring( bStart ) )

    if ( call ) then
        call( bStart )
    end
end
