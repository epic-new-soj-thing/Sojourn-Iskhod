// Lift master datum. One per turbolift.
/datum/turbolift
	var/datum/turbolift_stop/target_stop                // Where are we going?
	var/datum/turbolift_stop/current_stop               // Where is the lift currently?
	var/list/doors = list()                             // Doors inside the lift structure.
	var/list/queued_stops = list()                      // Where are we moving to next?
	var/list/stops = list()                             // All stops in this system.
	var/move_delay = 30                                 // Time between floor changes.
	var/floor_wait_delay = 85                           // Time to wait at floor stops.
	var/obj/structure/lift/panel/control_panel_interior // Lift control panel.
	var/doors_closing = 0								// Whether doors are in the process of closing
	var/list/music = null								// Elevator music to set on areas
	var/priority_mode = FALSE							// Flag to block buttons from calling the elevator if in priority mode.
	var/fire_mode = FALSE								// Flag to indicate firefighter mode is active.

	var/tmp/moving_upwards
	var/tmp/busy

/datum/turbolift/proc/emergency_stop()
	cancel_pending_floors()
	target_stop = null
	if(!fire_mode)
		open_doors()

// Enter priority mode, blocking all calls for awhile
/datum/turbolift/proc/priority_mode(var/time = 30 SECONDS)
	priority_mode = TRUE
	cancel_pending_floors()
	update_ext_panel_icons()
	control_panel_interior.audible_message("<span class='info'>This turbolift is responding to a priority call.  Please exit the lift when it stops and make way.</span>")
	spawn(time)
		priority_mode = FALSE
		update_ext_panel_icons()

/datum/turbolift/proc/update_fire_mode(var/new_fire_mode)
	if(fire_mode == new_fire_mode)
		return
	fire_mode = new_fire_mode
	if(new_fire_mode)
		cancel_pending_floors()

	// Turn the lights red and kill the music
	for(var/datum/turbolift_stop/F in stops)
		var/area/turbolift/A = locate(F.area_ref)
		if(new_fire_mode)
			if(A.forced_ambience)
				A.forced_ambience.Cut()
			A.fire_alert()
		else
			if(music)
				A.forced_ambience = music.Copy()
			A.fire_reset()
		for(var/mob/living/M in mobs_in_area(A))
			if(M.mind)
				A.play_ambience(M)
		// Disable safeties on the doors during firemode, reset when done
		for(var/obj/machinery/door/airlock/door in F.doors)
			door.safe = new_fire_mode ? FALSE : initial(door.safe)

	// Disable safeties on the doors during firemode, reset when done
	for(var/obj/machinery/door/airlock/door in doors)
		door.safe = new_fire_mode ? FALSE : initial(door.safe)
	update_ext_panel_icons()
	control_panel_interior.update_icon()

// Cancel all pending calls
/datum/turbolift/proc/cancel_pending_floors()
	for(var/datum/turbolift_stop/floor in queued_stops)
		if(floor.ext_panel)
			floor.ext_panel.reset()
	queued_stops.Cut()
	SStgui.update_uis(control_panel_interior)

// Update the icons of all exterior panels (after we change modes etc)
/datum/turbolift/proc/update_ext_panel_icons()
	for(var/datum/turbolift_stop/floor in stops)
		if(floor.ext_panel)
			floor.ext_panel.update_icon()

/datum/turbolift/proc/doors_are_open(var/datum/turbolift_stop/use_floor = current_stop)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		if(!door.density)
			return 1
	return 0

/datum/turbolift/proc/open_doors(var/datum/turbolift_stop/use_floor = current_stop)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		//door.command("open")
		spawn(0)
			door.open()
	return

/datum/turbolift/proc/close_doors(var/datum/turbolift_stop/use_floor = current_stop)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		//door.command("close")
		spawn(0)
			door.close()
	return

/datum/turbolift/proc/do_move()

	var/current_stop_index = stops.Find(current_stop)

	if(!target_stop)
		if(!queued_stops || !queued_stops.len)
			return 0
		target_stop = queued_stops[1]
		queued_stops -= target_stop
		if(current_stop_index < stops.Find(target_stop))
			moving_upwards = 1
		else
			moving_upwards = 0
		SStgui.update_uis(control_panel_interior)

	if(doors_are_open())
		if(!doors_closing)
			close_doors()
			doors_closing = 1
			return 1
		else // We failed to close the doors - probably, someone is blocking them; stop trying to move
			doors_closing = 0
			if(!fire_mode)
				open_doors()
			control_panel_interior.audible_message("\The [current_stop.ext_panel] buzzes loudly.")
			playsound(control_panel_interior.loc, "sound/machines/buzz-two.ogg", 50, 1)
			return 0

	doors_closing = 0 // The doors weren't open, so they are done closing

	var/area/turbolift/origin = locate(current_stop.area_ref)

	if(target_stop == current_stop)

		playsound(control_panel_interior.loc, origin.arrival_sound, 50, 1)
		target_stop.arrived(src)
		target_stop = null

		sleep(15)
		control_panel_interior.visible_message("<b>The elevator</b> announces, \"[origin.lift_announce_str]\"")
		sleep(floor_wait_delay)

		return 1

	// Work out where we're headed.
	var/datum/turbolift_stop/next_floor
	if(moving_upwards)
		next_floor = stops[current_stop_index+1]
	else
		next_floor = stops[current_stop_index-1]

	var/area/turbolift/destination = locate(next_floor.area_ref)

	if(!istype(origin) || !istype(destination) || (origin == destination))
		return 0

	// Shuttle-style physical movement: translate the car's turfs to the next stop position.
	if(current_stop.anchor_turf && next_floor.anchor_turf)
		// Build the translation map: shift origin area turfs to destination position.
		var/list/translation = get_turf_translation(current_stop.anchor_turf, next_floor.anchor_turf, origin.contents)

		// Clear any non-lift mobs/objects from destination turfs before moving.
		for(var/turf/src_turf in translation)
			var/turf/dst_turf = translation[src_turf]
			if(!dst_turf) continue
			for(var/I in dst_turf)
				if(istype(I, /mob/living))
					var/mob/living/L = I
					var/moved = FALSE
					for(var/dir_try in list(NORTH, SOUTH, EAST, WEST))
						var/turf/adj = get_step(dst_turf, dir_try)
						if(adj && !adj.density)
							L.forceMove(adj)
							moved = TRUE
							break
					if(!moved)
						L.gib()
				else if(istype(I, /obj))
					if(istype(I, /obj/machinery/door/airlock/lift) || istype(I, /obj/structure/lift))
						continue
					qdel(I)

		translate_turfs(translation, null, origin.base_turf)

		// Update the area reference for the stop to reflect new turf positions.
		current_stop = next_floor
	else
		// Fallback: old area-swap method if anchors aren't set.
		origin.move_contents_to(destination)
		current_stop = next_floor

	if((locate(/obj/machinery/power) in destination) || (locate(/obj/structure/cable) in destination))
		SSmachines.makepowernets()

	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")

	return (next_floor.delay_time || move_delay || 30)







/datum/turbolift/proc/queue_move_to(var/datum/turbolift_stop/floor)
	if(!floor || !(floor in stops) || (floor in queued_stops))
		return // STOP PRESSING THE BUTTON.
	floor.pending_move(src)
	queued_stops |= floor
	SSturbolift.lift_is_moving(src)

// TODO: dummy machine ('lift mechanism') in powered area for functionality/blackout checks.
/datum/turbolift/proc/is_functional()
	return 1
