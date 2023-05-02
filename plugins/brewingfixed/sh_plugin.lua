local PLUGIN = PLUGIN

PLUGIN.name = "Brewing System"
PLUGIN.description = "Allows players to brew moonshine etc."

PLUGIN.brews = {
    ["Gin"] = {
        requirements = function(ply)
            
            local char = ply:GetCharacter()
            local inv = char:GetInventory()
            
            if ( inv:GetItemCount("drink_champagne") >= 2 ) then
                return true
            end
           
            return false
        end
    },
    ["Vodka"] = {
        requirements = function(ply)
            
            local char = ply:GetCharacter()
            local inv = char:GetInventory()
            
            if ( inv:GetItemCount("drink_champagne") >= 2 ) then
                return true
            end
           
            return false
        end
    },
    ["Whisky"] = {
        requirements = function(ply)
            
            local char = ply:GetCharacter()
            local inv = char:GetInventory()
            
            if ( inv:GetItemCount("drink_champagne") >= 2 ) then
                return true
            end
           
            return false
        end
    }
}

if ( SERVER ) then
    util.AddNetworkString("ixBrewingMenu")
    
else
    net.Receive("ixBrewingMenu", function(len)
        local menu = DermaMenu()
        menu:SetMinimumWidth(100)
        menu:AddSpacer()
        
        for k, v in SortedPairs(PLUGIN.brews) do
            menu:AddOption(k, nil)
            if ( v.requirements ) then
                local submenu = menu:AddSubMenu(k)
                
                submenu:AddOption("Brew", function()
                    print("yet")
                end)
            end
        end
        menu:Open()
    end)
    
end