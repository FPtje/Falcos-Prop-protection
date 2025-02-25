CPPI = CPPI or {}
CPPI.CPPI_DEFER = 102112 --\102\112 = fp
CPPI.CPPI_NOTIMPLEMENTED = 7080 --\70\80 = FP

function CPPI:GetName()
    return "Falco's prop protection"
end

function CPPI:GetVersion()
    return "universal.1"
end

function CPPI:GetInterfaceVersion()
    return 1.3
end

function CPPI:GetNameFromUID(uid)
    return CPPI.CPPI_NOTIMPLEMENTED
end

local PLAYER = FindMetaTable("Player")
function PLAYER:CPPIGetFriends()
    if not self.Buddies then return CPPI.CPPI_DEFER end
    local FriendsTable = {}

    for k, v in pairs(self.Buddies) do
        if not table.HasValue(v, true) then continue end -- not buddies in anything
        table.insert(FriendsTable, k)
    end

    return FriendsTable
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:CPPIGetOwner()
    local Owner = FPP.entGetOwner(self)
    if not IsValid(Owner) or not Owner:IsPlayer() then return SERVER and Owner or nil, self.FPPOwnerID end
    return Owner, Owner:UniqueID()
end

if SERVER then
    function ENTITY:CPPISetOwner(ply)
        if ply == self.FPPOwner then return end

        assert(ply == nil or IsEntity(ply), "The owner of an entity must be set to either nil, NULL or a valid entity.")

        local valid = IsValid(ply) and ply:IsPlayer()
        local steamId = valid and ply:SteamID() or nil
        local canSetOwner = hook.Run("CPPIAssignOwnership", ply, self, valid and ply:UniqueID() or ply)

        if canSetOwner == false then return false end
        ply = canSetOwner ~= nil and canSetOwner ~= true and canSetOwner or ply
        self.FPPOwner = ply
        self.FPPOwnerID = steamId

        self.FPPOwnerChanged = true
        FPP.recalculateCanTouch(player.GetAll(), {self})
        self.FPPOwnerChanged = nil

        return true
    end

    function ENTITY:CPPISetOwnerUID(UID)
        local ply = UID and player.GetByUniqueID(tostring(UID)) or nil
        if UID and not ply then return false end
        return self:CPPISetOwner(ply)
    end

    function ENTITY:CPPICanTool(ply, tool)
        local cantool = FPP.Protect.CanTool(ply, nil, tool, self)
        return cantool == nil and true or cantool
    end

    function ENTITY:CPPICanPhysgun(ply)
        local canphysgun = FPP.Protect.PhysgunPickup(ply, self, true)
        return canphysgun == nil and true or canphysgun
    end

    function ENTITY:CPPICanPickup(ply)
        local canpickup = FPP.Protect.CanGravGunPickup(ply, self)
        return canpickup == nil and true or canpickup
    end

    function ENTITY:CPPICanPunt(ply)
        local canpunt = FPP.Protect.GravGunPunt(ply, self, true)
        return canpunt == nil and true or canpunt
    end

    function ENTITY:CPPICanUse(ply)
        local canuse = FPP.Protect.PlayerUse(ply, self, true)
        return canuse == nil and true or canuse
    end

    function ENTITY:CPPICanDamage(ply)
        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(ply)
        dmginfo:SetDamage(-1)

        FPP.Protect.EntityDamage(self, dmginfo)
        return dmginfo:GetDamage() ~= 0
    end

    function ENTITY:CPPIDrive(ply)
        local candrive = FPP.Protect.CanDrive(ply, self)
        return candrive == nil and true or candrive
    end

    function ENTITY:CPPICanProperty(ply, property)
        local canproperty = FPP.Protect.CanProperty(ply, property, self)
        return canproperty == nil and true or canproperty
    end

    function ENTITY:CPPICanEditVariable(ply, key, val, editTbl)
        return self:CPPICanProperty(ply, "editentity")
    end
end
