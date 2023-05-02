
local PLUGIN = PLUGIN

function PLUGIN:CreateRope(ply)
    local attachmentIndex

    if (ply.ixAnimModelClass == "metrocop") then
        attachmentIndex = ply:LookupAttachment("anim_attachment_LH")
    else
        attachmentIndex = ply:LookupAttachment("hips")
    end

    local attachment = ply:GetAttachment(attachmentIndex)

    if (attachmentIndex == 0 or attachmentIndex == -1) then
        attachment = {Pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))}
        attachmentIndex = ply:LookupAttachment("forward")
    end

    local rappelRope = ents.Create("keyframe_rope")
        rappelRope:SetParent(ply, attachmentIndex)
        rappelRope:SetPos(attachment and attachment.Pos or ply:GetPos())
        rappelRope:SetColor(Color(150, 150, 150))
        rappelRope:SetEntity("StartEntity", rappelRope)
        rappelRope:SetEntity("EndEntity", Entity(0))
        rappelRope:SetKeyValue("Width", 2)
        rappelRope:SetKeyValue("Collide", 1)
        rappelRope:SetKeyValue("RopeMaterial", "cable/cable")
        rappelRope:SetKeyValue("EndOffset", tostring(ply.rappelPos or ply:GetPos()))
        rappelRope:SetKeyValue("EndBone", 0)
    ply.rappelRope = rappelRope

    ply:DeleteOnRemove(rappelRope)
    ply:EmitSound("npc/combine_soldier/zipline_clip" .. math.random(2) .. ".wav")

end

function PLUGIN:RemoveRope(ply)
    if (IsValid(ply.rappelRope)) then
        ply.rappelRope:Remove()
    end

    ply.rappelRope = nil
    ply.oneTimeRappelSound = nil

    local sequence = ply:LookupSequence("rappelloop")

    if (sequence != 1 and ply:GetNetVar("forcedSequence") == sequence) then
        ply:SetNetVar("forcedSequence", nil)
    end
end
