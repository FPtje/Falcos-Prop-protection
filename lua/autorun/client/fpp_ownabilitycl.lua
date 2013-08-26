FPP = FPP or {}

FPP.entOwners       = FPP.entOwners or {}
FPP.entTouchability = FPP.entTouchability or {}
FPP.entTouchReasons = FPP.entTouchReasons or {}

local touchTypes = {
	Physgun = 1,
	Gravgun = 2,
	Toolgun = 4,
	PlayerUse = 8,
	EntityDamage = 16
}

local function receiveTouchData(len)
	repeat
		local entIndex = net.ReadUInt(32)
		local ownerIndex = net.ReadUInt(32)
		local touchability = net.ReadUInt(5)
		local reasons = net.ReadUInt(20)

		FPP.entOwners[entIndex] = ownerIndex
		FPP.entTouchability[entIndex] = touchability
		FPP.entTouchReasons[entIndex] = reasons
	until net.ReadBit() == 1
end
net.Receive("FPP_TouchabilityData", receiveTouchData)

function FPP.entGetOwner(ent)
	local idx = FPP.entOwners[ent:EntIndex()]
	ent.FPPOwner = idx and Entity(idx) or nil

	return ent.FPPOwner
end

function FPP.canTouchEnt(ent, touchType)
	ent.FPPCanTouch = FPP.entTouchability[ent:EntIndex()]
	if not touchType then
		return ent.FPPCanTouch
	end

	return bit.bor(ent.FPPCanTouch, touchTypes[touchType]) == ent.FPPCanTouch
end

function FPP.entGetTouchReason(ent)
	local idx = FPP.entTouchReasons[ent:EntIndex()]
	ent.FPPCanTouchWhy = idx

	return ent.FPPCanTouchWhy
end
