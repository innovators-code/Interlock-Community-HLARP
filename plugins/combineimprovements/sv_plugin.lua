--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/

    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

util.AddNetworkString("ixChatterFinishChat")
util.AddNetworkString("ixChatterChatTextChanged")
util.AddNetworkString("ixDisplaySend")
util.AddNetworkString("ixDispatchSend")
util.AddNetworkString("ixStartBootSequence")
util.AddNetworkString("ixNightvisionToggle")

local nv_enabled = false
function PLUGIN:PlayerButtonDown( ply, btn )
    if not ( ply:Team() == FACTION_OTA ) then return end

    if ( btn == KEY_N ) then
        net.Start("ixNightvisionToggle")
            net.WriteEntity(ply)
            net.WriteBool((!nv_enabled))
        net.Broadcast()
    end
end

net.Receive("ixChatterFinishChat", function(len, ply)
    if ( ply:IsCombine() and ply.ixTypingBeep ) then
        ply:EmitSound(PLUGIN.combineRadioOff[math.random(1, #PLUGIN.combineRadioOff)])
        ply.ixTypingBeep = nil
    end
end)

net.Receive("ixChatterChatTextChanged", function(len, ply)
    local key = net.ReadString()
    if ( ply:IsCombine() and not ply.ixTypingBeep ) and ( key == "y" or key == "w" or key == "r" or key == "t" ) then
        ply:EmitSound(PLUGIN.combineRadioOn[math.random(1, #PLUGIN.combineRadioOn)])
        ply.ixTypingBeep = true
    end
end)

local ENTITY = FindMetaTable("Entity")

function ENTITY:IsValidWorld()
    if ( self == game.GetWorld() ) then return true end

    return IsValid(self)
end

function PLUGIN:SaveData()
    local data = {}

    for _, v in pairs(ents.FindByClass("ix_combinelight")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetModel(), v:GetClass()}
    end

    ix.data.Set("combineLights", data)
end

function PLUGIN:LoadData()
    for _, v in pairs(ix.data.Get("combineLights")) do
        local combineLight = ents.Create(v[4])
        combineLight:SetPos(v[1])
        combineLight:SetAngles(v[2])
        combineLight:SetModel(v[3])
        combineLight:Spawn()
    end
end