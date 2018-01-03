local versionNumber = "v1.0"

function gadget:GetInfo()
	return {
		name    = "1944 Unit Kill Voice",
		desc    = versionNumber .. " Makes certain units say things when they kill something",
		author  = "yuritch",
		date    = "18 March 2015",
		license = "Public domain",
		layer   = 10000,
		enabled = true  --  loaded by default?
	}
end

-- gadget is disabled
