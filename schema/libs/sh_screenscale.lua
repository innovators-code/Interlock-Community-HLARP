--[[---------------------------------------------------------------------------
    Screen Scale
---------------------------------------------------------------------------]]--

function VerticalScale( size )
    return size * ( ScrH() / 480.0 )
end

VScale = VerticalScale

function ScreenScaleMin( size )
    return math.min(SScale(size), VScale(size))
end

SScaleMin = ScreenScaleMin

function YScale( size )
    return math.Round(size * math.min(ScrW(), ScrH())/1080)
end