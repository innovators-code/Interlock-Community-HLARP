
include( "shared.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

function ENT:Initialize( )
    self:SetModel( "models/hla_combine_props/combine_monitor_medium.mdl" )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetSolid( SOLID_VPHYSICS )

    self:SetNetVar( "alarm", false )
end

function ENT:Use( ply )
    local combineAvailable

    for _, player in ipairs( player.GetAll( ) ) do
        if ( player:IsCombine( ) ) then
            combineAvailable = true

            break
        end
    end
    
    if ( combineAvailable ) then
        if ( !ply:IsCombine( ) ) then
            local card = ply:GetCharacter( ):GetInventory( ):HasItem( "id" )
            
            if ( card ) then
                local cid = card:GetData( "id", 0 )
                local area = ply:GetArea( )
                
                if ( !area or area == "" ) then
                    area = "Unknown Location"
                end

                self:SetNetVar( "alarm", true )
                self:SetNetVar( "requester", cid )

                ix.chat.Send( ply, "terminal_request", tostring(cid), false, nil, {area} )

                -- Waypoint support.
                local waypointPlugin = ix.plugin.Get( "waypoints" )

                if ( waypointPlugin ) then
                    local waypoint = {
                        pos = self:GetPos( ),
                        text = "Terminal Request - #" .. tostring(cid) .. " | " .. area,
                        color = Color( 175, 125, 100 ),
                        addedBy = ply,
                        time = CurTime( ) + 300
                    }

                    self:SetNetVar( "waypoint", #waypointPlugin.waypoints ) -- Save the waypoint index for easy access later.

                    waypointPlugin:AddWaypoint( waypoint )
                end
            else
                ply:Notify( "You need an Identification Card to use the Assistance Terminal!" )
            end
        elseif ( self:GetNetVar( "alarm", false ) ) then
            self:SetNetVar( "alarm", false )
            self:SetNetVar( "requester", nil )

            local waypointIndex = self:GetNetVar( "waypoint" )

            if ( waypointIndex ) then
                local waypointPlugin = ix.plugin.Get( "waypoints" )

                if ( waypointPlugin ) then
                    waypointPlugin:UpdateWaypoint(waypointIndex, nil)
                end

                self:SetNetVar( "waypoint", nil)
            end
        end
    else
        ply:Notify( "There are no officers available at this time!" )
    end
end

function ENT:Think( )
    if ( ( self.NextAlert or 0 ) <= CurTime( ) and self:GetNetVar( "alarm" ) ) then
        self.NextAlert = CurTime( ) + 3

        self:EmitSound( "ambient/alarms/klaxon1.wav", 80, 70 )
        self:EmitSound( "ambient/alarms/klaxon1.wav", 80, 80 )

        self:SetNetVar( "alarmLights", true )
        
        timer.Simple( 2, function( )
            self:SetNetVar( "alarmLights", false )
        end )
    end

    self:NextThink( CurTime( ) + 2 )
end
