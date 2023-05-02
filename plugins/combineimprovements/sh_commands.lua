--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

ix.command.Add("Doorkick", {
    description = "Kick the door.",
    OnRun = function(self, ply)
        local ent = ply:GetEyeTrace().Entity
        local stamina = math.Clamp(math.Round(ply:GetNetVar("attribute_stamina", 100)), 0, 100)

        if ( ( ply.nextKickdoor or 0 ) > CurTime() ) then return end

        if not ( ix.anim.GetModelClass(ply:GetModel()) == "metrocop" ) then
            ply:Notify("Your model is not allowed to use this command!")
            return
        end

        if ( ent:GetClass() == "func_door" ) then
            return ply:Notify("You cannot kick down these type of doors!")
        end

        if not ( IsValid(ent) and ent:IsDoor() ) or ent:GetNetVar("disabled") then
            return ply:Notify("You are not looking at a door!")
        end

        if not ( ply:GetPos():Distance(ent:GetPos()) < 100 ) then
            return ply:Notify("You are not close enough!")
        end

        if not ( stamina > 90 ) then
            return ply:Notify("You don't have enough stamina!")
        end

        if ( IsValid(ent.ixLock) ) then
            ply:Notify("You cannot kick down a combine lock!")
            return false
        end        

        ply:ConsumeStamina(10)
        ply:ForceSequence("kickdoorbaton", function()
            if ( IsValid(ply) ) then
                ply:Freeze(false)
            end
        end, 1.7)
        
        timer.Simple(1, function()
            if ( IsValid(ent) ) then 
                ent:EmitSound("physics/wood/wood_plank_break1.wav", 100)
                ent:Fire("unlock")
                ent:Fire("openawayfrom", ply:SteamID64())
            end
        end)
        
        timer.Simple(2, function()
            if ( IsValid(ply) ) then
                ply:EmitSound("npc/metropolice/vo/dontmove.wav", 100)
            end
        end)

        ply.nextKickdoor = CurTime() + 2
    end
})

ix.command.Add("SendCommand", {
    description = "Send a Command to all combine members.",
    adminOnly = false,
    arguments = ix.type.text,
    OnCheckAccess = function(self, ply)
        return ply:IsCombineCommand() or ply:IsDispatch()
    end,
    OnRun = function(self, ply, text)
        if ( ( ply.commandtimeout or 0 ) > CurTime() ) then
            return ply:Notify("You can only send a command once every 5 seconds.")
        end

        Schema:AddDisplay("New Command from "..ply:Nick()..": "..tostring(text), Color(208, 19, 19), "npc/metropolice/vo/newcommand.wav")
        ply.commandtimeout = CurTime() + 5  
    end
})

ix.command.Add("ToggleGate", {
    description = "Toggles the gate of the Overwatch Nexus.",
    OnRun = function(self, ply)
        if not ( ply:IsDispatch() or ply:IsCombineCommand() ) then
            ply:Notify("You don't have access to this command.")
            return
        end

        for k, v in pairs(ents.FindByName("blastdoors_toggle_1")) do
            v:Fire("trigger")
        end
    end
})

ix.command.Add("ChangeCityCode", {
    adminOnly = true,
    description = "Change City Code (codetwelve, idcheck, unrest, curfew, aj, jw, void).",
    arguments = ix.type.text,
    OnRun = function(self, ply, code)
        if not ( code == "void" or code == "jw" or code == "aj" or code == "curfew" or code == "unrest" or code == "idcheck" or code == "codetwelve" ) then
            return ply:Notify("You have provided a non-existent code.")
        end

        ply:SendLua("RunConsoleCommand('ix_code_set', '"..code.."')")
    end
})

ix.command.Add("ChangeSocioStatus", {
    adminOnly = true,
    description = "Change Socio Status (lost, fractured, marginal, disrupted, stable).",
    arguments = ix.type.text,
    OnRun = function(self, ply, sociostatus)
        if not ( sociostatus == "lost" or sociostatus == "fractured" or sociostatus == "marginal" or sociostatus == "disrupted" or sociostatus == "stable" ) then
            return ply:Notify("You have provided a non-existent socio status code.")
        end

        ply:SendLua("RunConsoleCommand('ix_status_set', '"..sociostatus.."')")
    end
})

ix.command.Add("shove", {
    description = "Knock someone out.",
    OnRun = function(self, ply)
        if not ( ply:Team() == FACTION_OTA ) then
            return false, "You need to be an OTA Unit to run this command."
        end

        local ent = ply:GetEyeTraceNoCursor().Entity

        if not ( ent:IsPlayer() ) then 
            return false, "You must be looking at someone!"    
        end

        local target = ent

        if ( target ) and ( target:GetPos():Distance(ply:GetPos()) >= 50 ) then
            return false, "You need to be close to your target!"
        end 

        ply:ForceSequence("melee_gunhit")
        target:SetVelocity(ply:GetAimVector() * 300)
        timer.Simple(0.1, function()
            ply:EmitSound("physics/body/body_medium_impact_hard6.wav")
            target:SetRagdolled(true, ix.config.Get("shoveTime", 20))
        end)
    end,
})

ix.command.Add("nightvision", {
    description = "Toggle Nightvision.",
    OnCheckAccess = function(self, ply)
        return ( ply:IsCombine() or ply:IsDispatch() )
    end,
    OnRun = function(self, ply)
        local char = ply:GetCharacter()

        if ( char:GetData("ixNightvision", false) ) then
            char:SetData("ixNightvision", false)
            ply:AddDisplay("Nightvision OFF..", Color(255, 0, 0), "npc/roller/code2.wav")    
        else
            char:SetData("ixNightvision", true)
            ply:AddDisplay("Nightvision ON..", Color(0, 255, 0), "npc/roller/code2.wav")
        end

        net.Start("ixNightvisionToggle")
            net.WriteEntity(ply)
        net.Broadcast()
    end,
})