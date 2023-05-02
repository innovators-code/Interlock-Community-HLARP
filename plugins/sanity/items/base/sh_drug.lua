ITEM.name = "Drug"
ITEM.description = "A simple drug"
ITEM.category = "Medical Items"
ITEM.model = "models/Gibs/Antlion_gib_Large_2.mdl"
ITEM.addiction = false
ITEM.addictionChance = 10
ITEM.sanity = 0
ITEM.width = 1
ITEM.height = 1
ITEM.isDrug = true

if ( CLIENT ) then
    function ITEM:PaintOver( item, w, h )
        local ply = LocalPlayer()
        if ( !ply ) then
            return
        end

        local character = ply:GetCharacter()

        local addictions = character:GetData( "addictions", { } )
        if ( addictions[ item.uniqueID ] ) then
            draw.SimpleText( "Addicted", "InterlockFont20-Light", 5, 5, Color( 0, 255, 255 ) )
        end
    end
end

ITEM.functions.use = {
    name = "Consume",
    tip = "useTip",
    icon = "icon16/add.png",
    OnRun = function( item )
        local ply = item.player
        local character = ply:GetCharacter()

        if ( item.addiction ) then
            local lastUse = character:GetData( "drug_use_" .. item.uniqueID, os.time() )

            -- 2 hours
            if ( os.time() - lastUse < 7200 ) then
                local addictionChance = math.random( 1, 100 )

                if ( addictionChance < item.addictionChance ) then
                    local curAddiction = character:GetData( "addictions", { } )
                    curAddiction[ item.uniqueID ] = true
                    character:SetData( "addictions", curAddiction )
                end
            end

            character:SetData( "drug_use_" .. item.uniqueID, os.time() )
            character:SetData( "drug_addictionend_" .. item.uniqueID, 0 )
        end

        character:SetSanity( math.Clamp( character:GetSanity() + item.sanity, 0, 100 ) )
        return true
    end
}
