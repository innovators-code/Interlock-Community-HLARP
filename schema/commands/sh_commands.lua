function AddDeveloperCommand(command, func)
    concommand.Add("interlock_dev_"..tostring(command), function(ply, cmd, args)
        if not ( ply:IsDeveloper() or ply:IsSuperAdmin() ) then return end
        
        func(ply, cmd, args)
    end)
end

AddDeveloperCommand("togglehud", function(ply)
    ply:SetLocalVar("interlock_showhud", (!ply:GetLocalVar("interlock_showhud", false)))
end)

AddDeveloperCommand("wep_bones", function(ply)
    local wep = ply:GetActiveWeapon()

    if ( wep and IsValid(wep) ) then
        for i = 0, wep:GetBoneCount() do
            print(wep:GetBoneName(i).."\n")
        end
    end
end)

AddDeveloperCommand("wep_attachments", function(ply)
    local wep = ply:GetActiveWeapon()

    if ( wep and IsValid(wep) ) then
        PrintTable(wep:GetAttachments())
    end
end)

AddDeveloperCommand("ply_bones", function(ply)
    for i = 0, ply:GetBoneCount() do
        print(ply:GetBoneName(i).."\n")
    end
end)

AddDeveloperCommand("ply_attachments", function(ply)
    PrintTable(ply:GetAttachments())
end)

AddDeveloperCommand("togglemode", function(ply)
    ix.data.Set("developmentMode", (!ix.data.Get("developmentMode", false)))
    SetGlobalBool("interlock_devmode", (!ix.data.Get("developmentMode", false)))
end)

AddDeveloperCommand("ply_getpos", function(ply)
    local pos = ply:GetPos()
    print("Vector("..pos.x..", "..pos.y..", "..pos.z..")")
end)

AddDeveloperCommand("ply_getang", function(ply)
    local angs = ply:GetAngles()
    print("Angle("..angs.p..", "..angs.y..", "..angs.r..")")
end)

AddDeveloperCommand("ent_getpos", function(ply)
    local ent = ply:GetEyeTrace().Entity
    local pos = ent:GetPos()
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    print("Vector("..pos.x..", "..pos.y..", "..pos.z..") - "..ent:GetClass())
end)

AddDeveloperCommand("ent_getbones", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    for i = 0, ent:GetBoneCount() - 1 do
        local bonepos = ent:GetBonePosition(i)
        print("Bone "..i.."\nName: "..ent:GetBoneName(i).."\nVector("..bonepos.x..", "..bonepos.y..", "..bonepos.z..")")
    end
end)

AddDeveloperCommand("ent_getattachments", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    PrintTable(ent:GetAttachments())
end)

AddDeveloperCommand("ent_getang", function(ply)
    local ent = ply:GetEyeTrace().Entity
    local angs = ent:GetAngles()
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    print("Angle("..angs.p..", "..angs.y..", "..angs.r..") - "..ent:GetClass())
end)

AddDeveloperCommand("ent_getmodel", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    print(ent:GetModel())
end)

AddDeveloperCommand("ent_getclass", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return 
    end
    
    print(ent:GetClass())
end)