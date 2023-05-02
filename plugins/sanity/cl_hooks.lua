local PLUGIN = PLUGIN

local math_random = math.random

local ply = LocalPlayer()

surface.CreateFont("scaryFont", {
    font = "i know a ghost",
    size = 30,
    weight = 1000,
    antialias = true,
    shadow = true
})

ix.bar.Add( function()
    local status = "Sane"
    local character = ply:GetCharacter()

    if ( !character ) then
        return 0, "ERR"
    end

    local var = character:GetSanity() / 100

    if ( var < 0.2 ) then
        status = "Insane"
    elseif ( var < 0.4 ) then
        status = "Disturbed"
    elseif ( var < 0.6 ) then
        status = "Worried"
    else
        status = status
    end

    return var, status
end, Color( 0, 200, 200 ), nil, "sanity" )

function PLUGIN:RenderScreenspaceEffects()
    if ( !IsValid( ply ) ) then
        ply = LocalPlayer()
        return
    end

    local character = LocalPlayer():GetCharacter()
    if ( !character ) then
        return
    end

    local sanity = character:GetSanity() / 100
    if ( !sanity ) then
        return
    end

    local colMod = {}
    colMod[ "$pp_colour_colour" ] = 0.8

    if ( sanity < 0.2) then
        colMod[ "$pp_colour_colour" ] = 0.45
        colMod[ "$pp_colour_brightness" ] = -0.1
    elseif ( sanity < 0.4 ) then
        colMod[ "$pp_colour_colour" ] = 0.6
        colMod[ "$pp_colour_brightness" ] = -0.05
    elseif ( sanity < 0.6 ) then
        colMod[ "$pp_colour_colour" ] = 0.7
        colMod[ "$pp_colour_brightness" ] = -0.025
    end

    DrawColorModify( colMod )
end

PLUGIN.randomMessages = {
    "The world sucks so much, why can't it just be better...?",
    "I wonder if things will get better...",
    "How much longer do I have to live like this...",
    "I can't keep moving on.",
    "What's the point?",
    "I miss everything.",
    "Leaving this world isn't as scary as it sounds.",
    "Why is it like this...?",
    "Who is responsible...?",
    "The voices... they make me want to die...",
    "Should I kill them...?",
    "God is with us or against us...",
    "Blood...",
    "4 hours...",
    "The man in the picture... nods his head.",
}

PLUGIN.events = {
    [ 1 ] = function( ply )
        surface.PlaySound( "ambient/voices/squeal1.wav" )
        ply:ChatNotify( "What was that sound...?" )
    end,
    [ 2 ] = function( ply )
        local sound = CreateSound( ply, "music/radio1.mp3" )
        sound:SetDSP( 5 )
        sound:Play()

        timer.Simple( 20, function()
            sound:FadeOut( 3 )
        end )

        ply:ChatNotify( "Why... why can I hear music...?" )
    end,
    [ 3 ] = function( ply )
        surface.PlaySound( "ambient/voices/playground_memory.wav" )
        ply:ChatNotify( "What are those sounds... Children...?" )
    end,
    [ 4 ] = function(ply)
        local sound = CreateSound( ply, "player/heartbeat1.wav" )
        sound:SetDSP( 5 )
        sound:Play()

        timer.Simple( 6, function()
            sound:FadeOut( 3 )
        end )
    end,
    [ 5 ] = function( ply )
        local sound = CreateSound( ply, "hl1/ambience/alien_cycletone.wav" )
        sound:SetDSP( 5 )
        sound:Play()

        timer.Simple( 12, function()
            sound:FadeOut( 3 )
        end )

        ply:ChatNotify( "What is that noise...?" )
    end,
    [ 6 ] = function( ply )
        local sound = CreateSound( ply, "npc/stalker/breathing3.wav" )
        sound:SetDSP( 5 )
        sound:Play()

        timer.Simple( 5, function()
            sound:FadeOut( 3 )
        end )

        ply:ChatNotify( "Who is breathing...?" )
    end,
    [ 7 ] = function( ply )
        local sound = CreateSound( ply, "ambient/creatures/pigeon_idle"..math_random(1,4)..".wav" )
        sound:SetDSP( 5 )
        sound:Play()
        sound:FadeOut( 2 )

        ply:ChatNotify( "Is that a pigeon...?" )
    end,
    [ 8 ] = function( ply )
        local sound = CreateSound( ply, "vo/episode_1/intro/vortchorus.wav" )
        sound:SetDSP(38)
        sound:Play()

        ply:ScreenFade( SCREENFADE.OUT, Color( 255, 0, 0, 220 ), 2, 12 )

        timer.Simple( 9, function()
            sound:FadeOut( 7 )
            timer.Simple( 4, function()
                ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 220 ), 2, 2 )
            end )
        end )
    end,
    [ 9 ] = function( ply )
        local sound = CreateSound( ply, "interlock/ambient/horror/scream"..math_random(1,5)..".ogg" )
        sound:SetDSP( 5 )
        sound:Play()

        ply:ChatNotify( "Why do I recognize those screams...?" )
    end,
}

function PLUGIN:Think()
    if ( !IsValid( ply ) ) then
        ply = LocalPlayer()
    end

    local character = ply:GetCharacter()
    if ( !character ) then
        return
    end

    if ( self:CheckSanity( character ) ) then
        return
    end


    local sanity = character:GetSanity()/100

    if ( sanity > 0.4 ) then
        self.nextEvent = CurTime() + math_random( 30, 120 )
        return
    end

    self.nextEvent = self.nextEvent or CurTime() + math_random( 60, 180 )

    if ( self.nextEvent < CurTime() ) then
		local rand = math_random( 1, 100 )

		if ( rand < 5 ) then
			rand = math_random( 1, #self.events )

			if ( self.events[ rand ] ) then
				self.events[ rand ]( ply )
			end
		end

        self.nextEvent = CurTime() + math_random( 60, 180 )
    end
end

local vignetteAlpha = 0
function PLUGIN:HUDPaint()
    if ( !IsValid( ply ) ) then
        ply = LocalPlayer()
    end

    local character = ply:GetCharacter()
    if ( !character ) then
        return
    end

    if ( self:CheckSanity(character) ) then
        return
    end

    local sanity = character:GetSanity()/100

    self.nextMessage = self.nextMessage or 0
    self.messages = self.messages or { }

    if ( self.nextMessage < CurTime() ) then
        -- Load of elseif...
        local chance = math_random( 1, 100 )
        local nextMessage = math_random( 120, 300 )
        if ( sanity < 0.1 and chance > 40 ) then
            self.messages[ #self.messages + 1 ] = { table.Random( self.randomMessages ), CurTime() + math_random( 12, 45 ) }
            nextMessage = math_random( 30, 60 )
        elseif ( sanity < 0.2 and chance > 60 ) then
            self.messages[ #self.messages + 1 ] = { table.Random( self.randomMessages ), CurTime() + math_random( 12, 45 ) }
            nextMessage = math_random( 60, 120 )
        elseif ( sanity < 0.4 and chance > 80 ) then
            self.messages[ #self.messages + 1 ] = { table.Random(self.randomMessages), CurTime() + math_random( 12, 45 ) }
        end
        self.nextMessage = CurTime() + nextMessage
    end

    for i, v in ipairs( self.messages ) do
        if ( v[ 2 ] < CurTime() ) then
            table.remove( self.messages, i )
        end

        if ( v.reverse == nil ) then
            local rand = math_random( -5, 5 )

            if ( rand > 0 ) then
                v.reverse = true
            else
                v.reverse = false
            end
        end

        v.x = v.x or math_random( 1, ScrW() )
        v.y = v.y or math_random( 1, ScrH() )

        v.projX = v.projX or math_random( 1, ScrW() )
        v.projY = v.projY or math_random( 1, ScrH() )

        v.x = Lerp( 0.005, v.x, v.projX )
        v.y = Lerp( 0.005, v.y, v.projY )

        local dist = math.Distance( v.x, v.y, v.projX, v.projY )

        if ( dist < 5) then
            v.projX = math_random( 1, ScrW() )
            v.projY = math_random( 1, ScrH() )
        end

        local m = Matrix()
        local pos = Vector( v.x, v.y )
        m:Translate( pos )
        m:Scale( Vector( 1, 1, 1 ) * TimedSin( 0.25, 3, 6, v[ 2 ] ) )
        m:Rotate( Angle( 0, v[ 2 ] + CurTime() * 50 * ( v.reverse and 1 or -1 ), 0 ) )
        m:Translate( -pos )

        cam.PushModelMatrix( m )
            draw.SimpleText( v[ 1 ], "scaryFont", v.x + math_random( -3, 3 ), v.y + math_random( -3, 3 ), Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        cam.PopModelMatrix()
    end

    if ( sanity < 0.2 ) then
        vignetteAlpha = Lerp(0.1, vignetteAlpha, 255 )
    elseif ( sanity < 0.4 ) then
        vignetteAlpha = Lerp(0.1, vignetteAlpha, 150 )
    elseif ( sanity < 0.6 ) then
        vignetteAlpha = Lerp(0.1, vignetteAlpha, 100 )
    elseif ( sanity < 0.8 ) then
        vignetteAlpha = Lerp(0.1, vignetteAlpha, 50 )
    else
        vignetteAlpha = Lerp(0.1, vignetteAlpha, 0 )
    end

    surface.SetMaterial(ix.util.GetMaterial("helix/gui/vignette.png"))
    surface.SetDrawColor(ColorAlpha(color_black, vignetteAlpha))
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

PLUGIN.dist = 64 ^ 2

local function GetPos( ply )
    local tr = { }
    tr.start = ply:GetPos()
    tr.endpos = ply:GetPos() + Angle(0, EyeAngles().y, 0):Forward() * -224
    tr.filter = ply

    return util.TraceLine( tr ).HitPos
end

function PLUGIN:PostDrawOpaqueRenderables()
    self.monsters = self.monsters or { }
    self.nextMonster = self.nextMonster or 0

    if ( !IsValid( ply ) ) then
        ply = LocalPlayer()
    end

    local character = ply:GetCharacter()
    if ( !character ) then
        return
    end

    if ( self:CheckSanity( character ) ) then
        return
    end

    local sanity = character:GetSanity()/100

    if ( sanity > 0.1 ) then
        self.nextMonster = CurTime() + 120
    end

    if ( self.nextMonster < CurTime() ) then
        self.monsters[#self.monsters + 1] = { "models/Humans/Group01/Male_Cheaple.mdl", CurTime() + 24 }
        self.nextMonster = CurTime() + math.random(300,600)
        surface.PlaySound("interlock/ambient/horror/heiswatching.ogg")
        ply:ChatNotify( "You feel as if something is watching you..." )
        ply:SetNWBool("ixSpook", true)
    end

    for i, v in ipairs( self.monsters ) do
        if ( v[ 2 ] < CurTime() ) then
            if ( IsValid( v.ent ) ) then
                v.ent:Remove()
            end
            table.remove( self.monsters, i )
        end


        v.ent = v.ent or ClientsideModel( v[ 1 ], RENDERGROUP_BOTH )

        if ( v.ent ) then
            v.ent:SetModelScale(1.2, 0)
            v.pos = v.pos or GetPos( ply )

            if ( !v.pos ) then
                continue
            end

            local trace = { }
            trace.start = EyePos()
            trace.endpos = EyePos() + EyeAngles():Forward() * (EyePos():Distance(v.pos))
            trace.filter = ply
            trace = util.TraceLine(trace)

            if ( trace.HitPos:Distance( v.pos ) < 96 ) then
                v.startLook = v.startLook or CurTime() + 1

                if not ( v.noise ) then
                    surface.PlaySound( "interlock/ambient/horror/scare.ogg" )
                    v.noise = true
                end

                if ( v.startLook < CurTime() ) then
                    v.pos = LerpVector( 0.1, v.pos, LocalPlayer():GetPos() )
                end
            end

            if ( ply:GetPos():DistToSqr( v.pos ) < self.dist ) then
                v.ent:Remove()
                table.remove( self.monsters, i )
                ply:SetDSP( 39 )
                ply:ScreenFade( SCREENFADE.MODULATE, Color( 0, 0, 0 ), 1, 0 )
                ply:EmitSound("interlock/ambient/horror/breath_loop.wav")

                -- Could improve this but I'm lazy
                timer.Simple( 1, function()
                    ply:SetDSP( 38 )
                    ply:ScreenFade( SCREENFADE.PURGE, Color( 0, 0, 0, 240 ), 4, 0 )
                    timer.Simple( 4, function()
                        ply:SetDSP( 39 )
                        ply:ScreenFade( SCREENFADE.MODULATE, Color(0, 0, 0), 1, 0 )
                        timer.Simple( 1, function()
                            ply:StopSound("interlock/ambient/horror/breath_loop.wav")
                            ply:SetNWBool("ixSpook", nil)
                            ply:SetDSP( 6 )
                        end )
                    end )
                end )
            end

            v.ang = Angle( 0, EyeAngles().y - 180, 0 )

            v.ent:SetPos( v.pos )
            v.ent:SetAngles( v.ang )
            v.ent:SetSequence( ACT_IDLE )
            v.ent:SetColor( Color( 0, 0, 0 ) )
        end
    end
end
