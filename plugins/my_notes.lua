PLUGIN.name = 'My Notes'
PLUGIN.author = 'ZeMysticalTaco'
PLUGIN.description = 'Adds a personalized note system for characters.'

ix.command.Add( 'MyNotes', {
    description = 'Open your character\'s notes.',
    OnRun = function( self, client )
        net.Start( 'ixOpenNotes' )
        net.Send( client )
    end
} )

if CLIENT then
    net.Receive( 'ixOpenNotes', function( )
        local frame = vgui.Create( 'DFrame' )
        frame:SetSize( 385, ScrH( ) / 2 )
        frame:Center( )
        frame:MakePopup( )
        frame:SetTitle( 'My Notes' )
        frame.Save = frame:Add( 'DButton' )
        frame.Save:Dock( BOTTOM )
        frame.Save:SetText( 'Save Notes' )

        frame.Save.DoClick = function( )
            if string.len( frame.TextBox:GetText( ) ) > 2048 then
                ix.util.Notify( 'Your notes cannot be longer than 2048 characters!' )

                return
            end

            net.Start( 'ixSaveNotes' )
            net.WriteString( frame.TextBox:GetText( ) )
            net.SendToServer( )
        end

        frame.TextBox = frame:Add( 'DTextEntry' )
        frame.TextBox:Dock( FILL )
        frame.TextBox:SetMultiline( true )
        frame.TextBox:SetText( LocalPlayer( ):GetCharacter( ):GetData( 'notes', '' ) )
    end )
end

if SERVER then
    util.AddNetworkString( 'ixOpenNotes' )
    util.AddNetworkString( 'ixSaveNotes' )

    net.Receive( 'ixSaveNotes', function( len, ply )
        local str = net.ReadString( )
        if str:len( ) > 2048 then return end
        ply:GetCharacter( ):SetData( 'notes', str )
    end )
end