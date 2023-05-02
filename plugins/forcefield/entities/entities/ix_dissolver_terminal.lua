ENT.Type = "anim"
ENT.PrintName = "Dissolver Terminal"
ENT.Category = "IX:HLA RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PhysgunDisabled = false
ENT.bNoPersist = true

if ( SERVER ) then
    function ENT:Initialize()
        self:SetModel("models/hla_combine_props/combine_monitor_medium.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetSolid(SOLID_VPHYSICS)

        self:SetNetVar("id", math.random(10000, 99999))

        local physics_object = self:GetPhysicsObject()

        if (IsValid(physics_object)) then
            physics_object:Sleep()
            physics_object:EnableMotion(false)
        end
    end

    function ENT:SpawnFunction(ply, trace)
        local entity = ents.Create(self.ClassName)
        entity:SetPos(trace.HitPos)
        entity:SetAngles(trace.HitNormal:Angle())
        entity:Spawn()
        entity:Activate()

        return entity
    end

    local use_delay = 1
    local use_occurrence = -use_delay

    function ENT:Use(ply)
        local cur_time = CurTime()
        local use_time_elapsed = cur_time - use_occurrence

        if use_time_elapsed > use_delay then
            if ( ply:IsCombine() or ply:IsCA() ) and not self:GetNetVar("hacked", false) then
                for i = 1, #self:get_dissolvers() do
                    local dissolver = self:get_dissolvers()[i]

                    dissolver:toggle(not dissolver:GetToggle())
                end
            end

            use_occurrence = cur_time
        end
    end

    local default_delay = 10

    function ENT:hack(delay)
        self:EmitSound("hl2rp/forcefield/hacked.wav")
        for i = 1, #self:get_dissolvers() do
            local dissolver = self:get_dissolvers()[i]

            dissolver:toggle(false)
        end

        local spark = ents.Create("env_spark")
        spark:SetPos(self:GetPos() + Vector(0, 0, 10)) 
        spark:SetKeyValue("magnitude", 1)
        spark:SetKeyValue("maxdelay", 0.4)
        spark:SetKeyValue("traillength", 1)
        spark:Spawn() 
        spark:Fire("StartSpark")

        self:SetNetVar("hacked", true)

        timer.Simple(15, function()
            spark:Fire("StopSpark")

            self:SetNetVar("hacked", false)

            for i = 1, #self:get_dissolvers() do
                local dissolver = self:get_dissolvers()[i]

                dissolver:toggle(true)
            end
        end)
    end
else
    local render_size = 256
    local noise = Material( "effects/tvscreen_noise002a" )
    local overlay = Material( "effects/combine_binocoverlay" )

    -- This is so hacky that it is borderline not worth it.
    local noiseRT = GetRenderTargetEx( "noise_render", 128, 128, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, 16, 0, IMAGE_FORMAT_RGB888 )
    local noiseRTMat = CreateMaterial( "noise_render", "UnlitGeneric", { } )
    
    noiseRTMat:SetTexture( "$basetexture", noiseRT )
    noiseRTMat:SetFloat( "$alpha", 0.02 )

    local combineLogoParts = { 
        { 
            { x = 200, y = 77.5 },
            { x = 370, y = 164.5 },
            { x = 278, y = 160 }
        },
        { 
            { x = 126, y = 151.5 },
            { x = 205.3, y = 230 },
            { x = 212, y = 322.6 }
        },
        { 
            { x = 200, y = 293 },
            { x = 370, y = 293 },
            { x = 370, y = 322.6 },
            { x = 212, y = 322.6 }
        },
        { 
            { x = 338, y = 162 },
            { x = 370, y = 164.5 },
            { x = 370, y = 300 },
            { x = 338, y = 300 }
        },
        { 
            { x = 200, y = 77.5 },
            { x = 282, y = 164 },
            { x = 235, y = 175 },
            { x = 207, y = 232 },
            { x = 126, y = 151.5 }
        }
    }

    -- Helper function from the wiki.
    local function draw_Circle( x, y, radius, seg )
        local cir = {  }

        table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
        for i = 0, seg do
            local a = math.rad( ( i / seg ) * -360 )
            table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
        end

        local a = math.rad( 0 ) -- This is needed for non absolute segment counts
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

        surface.DrawPoly( cir )
    end

    local text_terminal = "Terminal #%s"
    local text_dissolver = "Field #%s (%s)"
    local dissolver_status = {
        [true] = {"ONLINE", Color(0, 100, 0)},
        [false] = {"OFFLINE", Color(100, 0, 0)}
    }

    function ENT:Draw()
        self:DrawModel()

        local dissolver_toggle = false

        local angle = self:GetAngles( )
        angle:RotateAroundAxis( angle:Up( ), 170 )
        angle:RotateAroundAxis( angle:Forward( ), 90 )
    
        cam.Start3D2D( self:GetPos( ) + self:GetForward( ) * 10 + self:GetRight( ) * -16 + self:GetUp( ) * 10, angle, 0.0364 )
            surface.SetDrawColor( 50, 50, 50, 255 )
            surface.DrawRect( 0, 0, 496, 502 )

            surface.SetDrawColor( 0, 0, 255, 75 )
            surface.DrawRect( 0, 0, 496, 40 )

            -- Combine Logo. If you want to put a non-solid color background here, you need to change the logo to a material.
            surface.SetDrawColor( 176, 124, 32, 255 )
            draw.NoTexture( )
            surface.DrawPoly( combineLogoParts[1] )
            surface.DrawPoly( combineLogoParts[2] )
            surface.DrawPoly( combineLogoParts[3] )
            surface.DrawPoly( combineLogoParts[4] )

            draw_Circle( 271.5, 227.3, 94, 100 )
            
            surface.SetDrawColor( 50, 50, 50, 255 )
            draw_Circle( 271.5, 227.3, 65, 100 )
            
            surface.SetDrawColor( 176, 124, 32, 255 )
            draw_Circle( 271.5, 227.3, 52, 100 )
            
            surface.SetDrawColor( 50, 50, 50, 255 )
            surface.DrawPoly( combineLogoParts[5] )
            
            if not ( self:GetNetVar("hacked", false) ) then
                surface.SetFont("CombineFont30")

                local text_w, text_h = surface.GetTextSize(text_terminal:format(self:id()))
                draw.SimpleText(text_terminal:format(self:id()), "CombineFont30", 248, 375, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                local y = 405

                for i = 1, #self:get_dissolvers() do
                    local dissolver = self:get_dissolvers()[i]

                    dissolver_toggle = dissolver:GetToggle()

                    surface.SetDrawColor(dissolver_status[dissolver:GetToggle()][2])

                    local text_w, text_h = surface.GetTextSize(text_dissolver:format(dissolver:EntIndex(), dissolver_status[dissolver:GetToggle()][1]))

                    surface.DrawRect(248 / 2 - 6, y - text_h / 2, text_w + 8, text_h)

                    draw.SimpleText(text_dissolver:format(dissolver:EntIndex(), dissolver_status[dissolver:GetToggle()][1]),
                    "CombineFont30", 248, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    y = y + text_h + 2
                end
            else
                surface.SetFont("CombineFont30")

                local text_w, text_h = surface.GetTextSize(text_terminal:format("?????"))
                draw.SimpleText(text_terminal:format("?????"), "CombineFont30", 248, 375, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
    
            draw.SimpleText( "FORCEFIELD TERMINAL", "CombineFont35", 248, 20, Color( 255, 255, 225, 50 + math.abs( math.sin( CurTime( ) ) ) * 300 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

            render.PushRenderTarget( noiseRT )
            render.Clear( 0, 0, 0, 0 )
            render.SetMaterial( noise )
            render.DrawScreenQuad( )
            render.PopRenderTarget( )
    
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( noiseRTMat )
            surface.DrawTexturedRect( 0, 0, 496, 502 )
            
            surface.SetDrawColor( 0, 0, 0, 255 )
            surface.SetMaterial( overlay )
            surface.DrawTexturedRect( 0, 0, 496, 502 )
        cam.End3D2D()
    end
end

function ENT:id()
    return self:GetNetVar("id")
end

function ENT:get_dissolvers()
    local dissolvers = {}

    for _, v in ipairs(ents.FindByClass("ix_dissolver")) do
        if v:id() == self:id() then
            dissolvers[#dissolvers + 1] = v
        end
    end

    return dissolvers
end
