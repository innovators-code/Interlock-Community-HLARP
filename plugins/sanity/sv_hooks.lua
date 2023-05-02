local PLUGIN = PLUGIN

PLUGIN.players = PLUGIN.players or { }

function PLUGIN:PlayerInitialSpawn( ply )
    self.players[ #self.players + 1 ] = ply
end

function PLUGIN:PlayerDisconnected( ply )
    for i, v in ipairs( self.players ) do
        if ( v == ply ) then
            table.remove( self.players, i )
        end
    end
end

function PLUGIN:CalcTable()
    self.players = player.GetAll()
end

function PLUGIN:Think()
    for i, v in ipairs( self.players ) do
        if ( !IsValid( v ) ) then
            table.remove( self.players, i )
            continue
        end

        if ( !v:GetCharacter() ) then
            continue
        end

        self:CalcSanity( v )
        self:HandleAddiction( v )
    end

    self.nextCalc = self.nextCalc or 0

    if ( self.nextCalc < CurTime() ) then
        self:CalcTable()

        -- Checks the player table every 5 minutes --
        self.nextCalc = CurTime() + math.random(60, 180)
    end
end

function PLUGIN:CalcSanity( ply )
    local character = ply:GetCharacter()

	if ( self:CheckSanity( character ) ) then
		return
	end

	ply.nextSanity = ply.nextSanity or CurTime() + math.random( 900, 1800 )
	if ( ply.nextSanity > CurTime() ) then
		return
	end

	character:SetSanity( character:GetSanity() - math.random( 1, 3 ) )
	ply.nextSanity = CurTime() + math.random( 900, 1800 )
end

function PLUGIN:HandleAddiction( ply )
    if ( !IsValid( ply ) ) then
        return
    end

    local character = ply:GetCharacter()
    if ( !character ) then
        return
    end

    if ( self:CheckSanity( character ) ) then
        return
    end

    local addictions = character:GetData( "addictions", { } )
    for i, v in pairs( addictions ) do
        if ( os.time() - character:GetData( "drug_use_" .. i, 0 ) > 1200 and character:GetData( "drug_need_" .. i, 0 ) < os.time() ) then
            local item = ix.item.list[ i ]
            if ( !item ) then
                return
            end
            local name = item:GetName()
            character:SetSanity( character:GetSanity() - 10 )
            character:SetData( "drug_need_" .. i, os.time() + 3600 )

            local endAddiction = character:GetData( "drug_addictionend_" .. i, 0 ) + 1
            character:SetData( "drug_addictionend_" .. i, endAddiction )

            if ( endAddiction > 5 ) then
                addictions[ i ] = nil
                character:SetData( "addictions", addictions )
                character:SetData( "drug_addictionend_" .. i, 0 )
                ply:ChatNotify( "It has been a while since you had some " .. name .. " but I'm sure you can live without them." )
            else
                ply:ChatNotify( "It sure has been a while since you had some " .. name .. "..." )
            end
        end
    end
end
