ix.command.Add("ToggleRadio", {
    description = "Toggle voice radio.",
    OnCanRun = function(_, ply)
        if not ( ply:IsCombine() ) then
            ply:Notify("You need to be a Civil Protection Unit in order to use this!")
            return
        end
    end,
    OnRun = function(_, ply)
        if not ( ply:GetCharacter():GetData("ixRadio") ) then
            ply:AddDisplay("Radio System Online...", Color(0, 255, 0), true)
            ply:GetCharacter():SetData("ixRadio", true)
        else
            ply:AddDisplay("Radio System Offline...", Color(255, 0, 0), true)
            ply:GetCharacter():SetData("ixRadio", false)
        end
    end
})

local stable = {
    ["ix_357"] = {"Weapon_357.Single", "357"},
    ["ix_usp"] = {"Weapon_RTBusp.Fire", "pistol"}
}

ix.command.Add("Suicide", {
    description = "Kill yourself.",
    OnRun = function(_, ply)
        local wep = ply:GetActiveWeapon()
       
        if ( IsValid(wep) ) then
            if ( ply:IsWepRaised() ) then
                if ( stable[wep:GetClass()] ) then
                    if not ( wep:Clip1() == 0 or wep:Clip1() == -1 ) then
                        ply:Kill()
                        ply:EmitSound(stable[wep:GetClass()][1], 110)
                        ix.item.Spawn(stable[wep:GetClass()][2], ply:GetPos() + Vector(0, 0, 10))
                        ply:GetCharacter():Ban()
                    else
                        ply:Notify("You need to have ammo in your weapon before you can use this command!")
                    end
                end
            else
                ply:Notify("You need to raise your weapon in order to use this!")
            end
        end
    end
})

ix.command.Add("Panic", {
    description = "Press your panic button.",
    OnCanRun = function(_, ply)
        if not ( ply:IsCombine() ) then
            return false, "You need to be a Civil Protection Unit in order to use this!"
        end
    end,
    OnRun = function(_, ply)
        if not ( ply:GetCharacter():GetData("ixPanic") ) then
            net.Start("ixPanicNotify")
                net.WriteString(ply:Nick())
            net.Broadcast()
            
            ply:GetCharacter():SetData("ixPanic", true)
            ply:EmitSound("npc/metropolice/vo/11-99officerneedsassistance.wav")

            for k, v in pairs(player.GetAll()) do
                if not ( v == ply ) then
                    v:PlaySound("npc/metropolice/vo/11-99officerneedsassistance.wav")
                end
            end

            timer.Simple(60, function()
                if ( IsValid(ply) ) then
                    ply:GetCharacter():SetData("ixPanic", nil)
                end
            end)
        end
    end
})

ix.command.Add("ForceRespawn", {
    description = "Forcefully respawn yourself or somebody.",
    adminOnly = true,
    arguments = {bit.bor(ix.type.player, ix.type.optional)},
    OnCanRun = function(_, ply)
        if not ( ply:IsAdmin() ) then
            return false
        end
    end,
    OnRun = function(_, ply, target)
        if ( target and IsValid(target) and target:IsPlayer() ) then
            target:Spawn()
            if ( target.ixDeathPos and target.ixDeathAngles ) then
                target:SetPos(target.ixDeathPos)
                target:SetAngles(target.ixDeathAngles)
            end
        else
            ply:Spawn()
            if ( ply.ixDeathPos and ply.ixDeathAngles ) then
                ply:SetPos(ply.ixDeathPos)
                ply:SetAngles(ply.ixDeathAngles)
            end
        end
    end
})

ix.command.Add("SetModel", {
    description = "Set your model as a staff member.",
    adminOnly = true,
    arguments = ix.type.string,
    OnCanRun = function(_, ply)
        if not ( ply:IsAdmin() ) then
            return false
        end
    end,
    OnRun = function(_, ply, chosenModel)
        ply:SetModel(tostring(chosenModel))
    end
})

ix.command.Add("Discord", {
    description = "Join our Discord Server!",
    OnCanRun = function(_, ply)
        return true
    end,
    OnRun = function(_, ply)
        ply:SendLua([[gui.OpenURL("https://discord.gg/h5KxsdGYVT")]])
    end
})

ix.command.Add("Content", {
    description = "Get our Server's Content Pack.",
    OnCanRun = function(_, ply)
        return true
    end,
    OnRun = function(_, ply)
        ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2827438746")]])
    end
})