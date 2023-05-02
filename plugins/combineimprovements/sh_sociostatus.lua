--[[---------------------------------------------------------------------------
    ** License: https://creativecommons.org/licenses/by-nc-nd/4.0/
    ** Copryright 2022 Riggs.mackay
    ** This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 4.0 Unported License.
---------------------------------------------------------------------------]]--

local PLUGIN = PLUGIN

ix.socioStatus = ix.socioStatus or {}
ix.socioStatus.codes = ix.socioStatus.codes or {}

--[[---------------------------------------------------------------------------
    Socio Status List
---------------------------------------------------------------------------]]--

ix.socioStatus.codes = {
    ["lost"] = {
        color = Color(0, 0, 0),
        name = "Lost",
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
    },
    ["fractured"] = {
        color = Color(250, 0, 0),
        name = "Fractured",
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
    },
    ["marginal"] = {
        color = Color(250, 250, 0),
        name = "Marginal",
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
    },
    ["disrupted"] = {
        color = Color(0, 0, 250),
        name = "Disrupted",
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
    },
    ["stable"] = {
        color = Color(0, 250, 0),
        name = "Stable",
        OnCheckAccess = function(ply)
            if not ( ply:IsCombineCommand() or ply:IsAdmin() ) then
                return false
            else
                return true
            end
        end,
    },
}

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.GetAll()
    Desc: Returns a table of all codes.
---------------------------------------------------------------------------]]--

function ix.socioStatus.GetAll()
    return ix.socioStatus.codes
end

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.GetCurrent()
    Desc: Returns the current code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.GetCurrent()
    return GetGlobalString("ixSocioStatus", "stable")
end

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.Get()
    Desc: Returns a table of a specific code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.Get(id)
    return ix.socioStatus.codes[id]
end

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.GetColor()
    Desc: Returns a color of a specific code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.GetColor(id)
    return ix.socioStatus.codes[id].color
end

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.GetName()
    Desc: Returns a name of a specific code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.GetName(id)
    return ix.socioStatus.codes[id].name
end

--[[---------------------------------------------------------------------------
    Name: ix.socioStatus.GetAccess()
    Desc: Returns a access function of a specific code.
---------------------------------------------------------------------------]]--

function ix.socioStatus.GetAccess(id)
    return ix.socioStatus.codes[id].OnCheckAccess
end
