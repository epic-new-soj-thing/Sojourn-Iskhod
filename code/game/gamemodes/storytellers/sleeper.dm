/datum/storyteller/sleeper
	config_tag = "sleeper"
	name = "The Sleeper"
	welcome = "Welcome to the Nadezhda colony! It's going to be a quiet day"
	description = "A passive storyteller that does almost nothing. It will be a very uneventful day."

	gain_mult_mundane = 0.7
	gain_mult_moderate = 0.4
	gain_mult_major = 0.4
	gain_mult_roleset = 0.5

	points = list(
	EVENT_LEVEL_MUNDANE = 0, //Mundane
	EVENT_LEVEL_MODERATE = 0, //Moderate
	EVENT_LEVEL_MAJOR = 0, //Major
	EVENT_LEVEL_ROLESET = -999 //Roleset
	)
