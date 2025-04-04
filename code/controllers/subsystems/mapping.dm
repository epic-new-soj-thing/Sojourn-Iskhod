SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/ruins_templates = list()
	var/dmm_suite/maploader = null
	var/list/teleportlocs = list()
	var/list/ghostteleportlocs = list()

/datum/controller/subsystem/mapping/Initialize(start_timeofday)
	if(config.generate_asteroid)
		// These values determine the specific area that the map is applied to.
		// Because we do not use Bay's default map, we check the config file to see if custom parameters are needed, so we need to avoid hardcoding.
		if(GLOB.maps_data.asteroid_levels)
			for(var/z_level in GLOB.maps_data.asteroid_levels)
				if(!isnum(z_level))
					// If it's still not a number, we probably got fed some nonsense string.
					admin_notice("<span class='danger'>Error: ASTEROID_Z_LEVELS config wasn't given a number.</span>")
				// Now for the actual map generating.  This occurs for every z-level defined in the config.
				new /datum/random_map/automata/cave_system(null, 1, 1, z_level, world.maxx, world.maxy)
				// Let's add ore too.
				new /datum/random_map/noise/ore(null, 1, 1, z_level, world.maxx, world.maxy)
		else
			admin_notice("<span class='danger'>Error: No asteroid z-levels defined in config!</span>")

	if(config.use_overmap)
		if(!GLOB.maps_data.overmap_z)
			build_overmap()
		else
			testing("Overmap already exist in maps_data for [GLOB.maps_data.overmap_z].")
	else
		testing("Overmap generation disabled in config.")

//	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	maploader = new()
	load_map_templates()

// Generates the random maint ruin templates.
#ifndef LOWMEMORYMODE
	SSmapping.seedStation()
#endif
	// Generate cache of all areas in world. This cache allows world areas to be looked up on a list instead of being searched for EACH time
	for(var/area/A in world)
		GLOB.map_areas += A

		if(!teleportlocs.Find("[A.name]") && !istype(A, /area/shuttle) && !istype(A, /area/wizard_station))
			if(area_has_station_turf(A))
				teleportlocs["[A.name]"] = A

		if(!ghostteleportlocs.Find("[A.name]"))
			if(istype(A, /area/turret_protected/aisat) || istype(A, /area/derelict) || istype(A, /area/shuttle/specops/centcom))
				ghostteleportlocs["[A.name]"] = A
			else if(area_has_station_turf(A))
				ghostteleportlocs["[A.name]"] = A

	teleportlocs = sortList(teleportlocs)
	ghostteleportlocs = sortList(ghostteleportlocs)

	return ..()

/datum/controller/subsystem/mapping/proc/build_overmap()
	testing("Building overmap...")
	world.incrementMaxZ()
	GLOB.maps_data.overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,GLOB.maps_data.overmap_z), locate(GLOB.maps_data.overmap_size, GLOB.maps_data.overmap_size, GLOB.maps_data.overmap_z)))
		var/turf/T = square
		if(T.x == GLOB.maps_data.overmap_size || T.y == GLOB.maps_data.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
		turfs += T
		CHECK_TICK

	var/area/overmap/A = new
	A.contents.Add(turfs)

	GLOB.maps_data.sealed_levels |= GLOB.maps_data.overmap_z
	testing("Overmap build complete.")

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT

/hook/roundstart/proc/init_overmap_events()
	if(config.use_overmap)
		if(GLOB.maps_data.overmap_z)
			testing("Creating overmap events...")
			//testing_variable(t1, world.tick_usage)
			overmap_event_handler.create_events(GLOB.maps_data.overmap_z, GLOB.maps_data.overmap_size, GLOB.maps_data.overmap_event_areas)
			//testing("Overmap events created in [(world.tick_usage-t1)*0.01*world.tick_lag] seconds")
		else
			testing("Overmap failed to create events.")
			return FALSE
	return TRUE

/datum/controller/subsystem/mapping/proc/load_map_templates()
	//Can also add other templates in the future. For now, maint ruins.
	preloadTemplates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new T()
		map_templates[template.name] = template
	return TRUE


/datum/controller/subsystem/mapping/proc/seedStation()
	for(var/V in GLOB.stationroom_landmarks)
		var/obj/effect/landmark/stationroom/LM = V
		LM.load()
	if(GLOB.stationroom_landmarks.len)
		seedStation() //I'm sure we can trust everyone not to insert a 1x1 rooms which loads a landmark which loads a landmark which loads a la...


/proc/cmp_ruincost_priority(datum/map_template/ruin/A, datum/map_template/ruin/B)
	return initial(A.cost) - initial(B.cost)

/datum/controller/subsystem/mapping/proc/preloadRuinTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("[global.config.directory]/lavaruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/spaceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/iceruinblacklist.txt")
	banned += generateMapList("[global.config.directory]/stationruinblacklist.txt")

	for(var/item in sort_list(subtypesof(/datum/map_template/ruin), GLOBAL_PROC_REF(cmp_ruincost_priority)))
		var/datum/map_template/ruin/ruin_type = item
		// screen out the abstract subtypes
		if(!initial(ruin_type.id))
			continue
		var/datum/map_template/ruin/R = new ruin_type()

		if(banned.Find(R.mappath))
			continue

		map_templates[R.name] = R
		ruins_templates[R.name] = R

			//We have to be specific here.
		if(istype(R, /datum/map_template/ruin/station))
			station_room_templates[R.name] = R


/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "_maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

	preloadRuinTemplates()


	// Station Ruins, Maints Rooms, Random shit!
/datum/controller/subsystem/mapping
	var/list/station_room_templates = list()