local PLUGIN = PLUGIN

PLUGIN.name = "Curfew"
PLUGIN.author = "Scotnay"
PLUGIN.description = "Adds in a simple curfew system (glorified clock) with events"

-- Name of event, time start, time end
PLUGIN.schedule = {
    { "Curfew", 0, 420,
        function( bIsStart )
            if ( bIsStart == true ) then
                if not ( ix.cityCode.GetCurrent() == "curfew" ) then
                    ix.cityCode.Set(nil, "curfew")
                end
            else
                if ( ix.cityCode.GetCurrent() == "curfew" ) then
                    ix.cityCode.Set(nil, "codetwelve")
                end
            end
        end
    },
    { "Ration Distribution", 420, 480,
        -- These functions are called when a schedule starts or ends, but only serverside
        -- bIsStart is obviously whether or not schedule has started or ended
        function( bIsStart )
            for i, v in ipairs( ents.FindByClass( "ix_rationdispenser" ) ) do
                v:SetLocked( !bIsStart )
            end
        end
    },
    { "Free Time", 480, 840 },
    { "Work Cycle", 840, 1080 },
    { "Ration Distribution", 1080, 1140,
        -- These functions are called when a schedule starts or ends, but only serverside
        -- bIsStart is obviously whether or not schedule has started or ended
        function( bIsStart )
            for i, v in ipairs( ents.FindByClass( "ix_rationdispenser" ) ) do
                v:SetLocked( !bIsStart )
            end
        end
    },
    { "Free Time", 1140, 0 },
}

function PLUGIN:GetTime()
    return StormFox2.Time.Get(true)
end

function Schema:GetSchedule()
    for i, v in ipairs( PLUGIN.schedule ) do
        local time = StormFox2.Time.Get(true)

        if ( v[ 2 ] > v[ 3 ] ) then
            if ( time >= v[ 2 ] or time <= v[ 3 ] ) then
                SetGlobalString("ixCurfewSchedule", v[ 1 ])
                return v[ 1 ]
            end
        else
            if ( time >= v[ 2 ] and time <= v[ 3 ] ) then
                SetGlobalString("ixCurfewSchedule", v[ 1 ])
                return v[ 1 ]
            end
        end
    end

    SetGlobalString("ixCurfewSchedule", "N/A")
    return "N/A"
end

ix.util.Include( "sv_hooks.lua" )
ix.util.Include( "sv_plugin.lua" )