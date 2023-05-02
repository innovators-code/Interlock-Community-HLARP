--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

function PLUGIN:FinishChat()
    net.Start("ixChatterFinishChat")
    net.SendToServer()
end

local cmdPrefix = "/"
function PLUGIN:ChatTextChanged(text)
    local key = nil
    if ( text == cmdPrefix.."radio " ) then
        key = "r"
    elseif ( text == cmdPrefix.."w " ) then
        key = "w"
    elseif ( text == cmdPrefix.."y " ) then
        key = "y"
    elseif ( text:sub(1, 1):match("%w") ) then
        key = "t"
    end

    if ( key ) then
        net.Start("ixChatterChatTextChanged")
            net.WriteString(key)
        net.SendToServer()
    end
end