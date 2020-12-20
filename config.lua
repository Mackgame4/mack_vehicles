Config = {}

-- setr debug true
Config.Debug = GetConvar("debug", "false")

Config.BarrierList = {
	-- Park
	{
		objType = "prop_bollard_01a",
		objCoords = vector3(100.25, -1068.46, 29.29),
		heading = 64.86,
		authorizedJob = 'none',
		status = "locked",
		maxDistance = 17
	},
	{
		objType = "prop_bollard_01a",
		objCoords = vector3(100.94, -1066.23, 29.29),
		heading = 64.86,
		authorizedJob = 'none',
		status = "locked",
		maxDistance = 17
	},
	{
		objType = "prop_bollard_01a",
		objCoords = vector3(99.25, -1070.79, 29.29),
		heading = 64.86,
		authorizedJob = 'none',
		status = "locked",
		maxDistance = 17
	},
	-- Park2
	{
		objType = "prop_bollard_01a",
		objCoords = vector3(51.72, -1055.00, 29.53),
		heading = 64.86,
		authorizedJob = 'none',
		status = "unlocked",
		maxDistance = 17
	},
	{
		objType = "prop_bollard_01a",
		objCoords = vector3(50.79, -1058.95, 29.53),
		heading = 64.86,
		authorizedJob = 'none',
		status = "unlocked",
		maxDistance = 17
	},
	-- Park3
	{
		objType = "prop_fnclink_06c",
		objCoords = vector3(461.84, -1077.68, 29.29),
		heading = 360.19,
		authorizedJob = 'police',
		status = "locked",
		maxDistance = 9
	},
	{
		objType = "prop_fnclink_06c",
		objCoords = vector3(476.34, -1077.68, 29.29),
		heading = 360.19,
		authorizedJob = 'police',
		status = "locked",
		maxDistance = 9
	}
}