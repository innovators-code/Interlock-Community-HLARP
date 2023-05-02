local PLUGIN = PLUGIN

function PLUGIN:OnEntityCreated(entity)
    if ( entity:GetClass() == "combine_mine" or entity:GetClass() == "Combine Mine" ) then
        timer.Simple(0.5, function()
            if ( IsValid(entity) ) then
                local physObj = entity:GetPhysicsObject()
                local storedVel = physObj:GetVelocity()
                local hopper = ents.Create("ix_hopper")

                hopper:SetPos(entity:GetPos())
                hopper:SetAngles(entity:GetAngles())

                SafeRemoveEntity(entity)

                hopper:Spawn()
                hopper:SetVelocity(storedVel)
            end
        end)
    end
end

function PLUGIN:KeyPress(ply, key)
    if ( IsValid(ply.ixScn) and ply.ixScn:GetClass() == "npc_clawscanner" ) then
        if ( key == IN_ATTACK2 ) then
            if ( ply.nextMineDrop or 0 < CurTime() ) then
                local scanner = ply.ixScn

                if ( IsValid(scanner) ) then
                    ply.nextMineDrop = CurTime() + 4
                    scanner:Fire("EquipMine")
                    scanner:Fire("DeployMine", "", 1)

                    timer.Simple(2.8, function()
                        if ( IsValid(scanner) ) then
                            scanner:SetSaveValue("m_bIsOpen", false)
                        end
                    end)
                end
            end
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(ply, char, oldChar)
    for k, v in ipairs(ents.FindByClass("npc_manhack")) do
        if ( ply:IsCombine() ) then
            v:AddEntityRelationship(ply, D_LI, 99)
        else
            v:AddEntityRelationship(ply, D_HT, 99)
        end
    end
end