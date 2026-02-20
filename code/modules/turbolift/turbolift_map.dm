/obj/turbolift_map_obj
	var/elevatorID = "Default"


/obj/turbolift_map_obj/turbolift_stop
	name = "Turbolift map stop"
	icon = 'icons/modules/turbolift/turbolift_preview_3x3.dmi'







// Map object.
/obj/turbolift_map_obj/turbolift_map_base
	name = "turbolift map placeholder"
	icon = 'icons/modules/turbolift/turbolift_preview_3x3.dmi'
	dir = SOUTH                 // Direction of the holder determines the placement of the lift control panel and doors.
	var/depth = 1               // Number of stops to generate, including the initial floor.
	var/lift_size_x = 2         // Number of turfs on each axis to generate in addition to the first
	var/lift_size_y = 2         // ie. a 3x3 lift would have a value of 2 in each of these variables.
	var/createInnerDoors = 0    // If we create inner doors or not

	// Various turf and door turftypes used when generating the turbolift stops.
	var/wall_type =  /turf/simulated/wall
	var/floor_type = /turf/simulated/shuttle/floor/mining
	var/door_type =  /obj/machinery/door/airlock/lift

	var/list/turbolift_stops = list()



    // Ghetto memory passing.  Sue me.
	var/tmp/elevatorBaseX
	var/tmp/elevatorBaseY
	var/tmp/elevatorBaseZ
	var/tmp/elevatorBaseDir

	var/tmp/elevatorSizeX
	var/tmp/elevatorSizeY

	var/tmp/make_walls
	var/tmp/int_panel_x
	var/tmp/int_panel_y

	var/tmp/door_x1
	var/tmp/door_y1
	var/tmp/door_x2
	var/tmp/door_y2
	var/tmp/light_x1
	var/tmp/light_x2
	var/tmp/light_y1
	var/tmp/light_y2




/obj/turbolift_map_obj/turbolift_map_base/proc/computeDirections(var/turf/stop)

	var/ext_panel_x
	var/ext_panel_y
	var/ext_door_x1
	var/ext_door_y1
	var/ext_door_x2
	var/ext_door_y2

	switch(dir)

		if(NORTH)

			int_panel_x = elevatorBaseX + FLOOR(lift_size_x/2, 1)
			int_panel_y = elevatorBaseY + (make_walls ? 1 : 0)

			door_x1 = elevatorBaseX + 1
			door_y1 = elevatorSizeY
			door_x2 = elevatorSizeX - 1
			door_y2 = elevatorSizeY

			ext_door_x1 = elevatorBaseX + 1
			ext_door_y1 = elevatorSizeY + 1
			ext_door_x2 = elevatorSizeX - 1
			ext_door_y2 = elevatorSizeY + 1

			light_x1 = elevatorBaseX + (make_walls ? 1 : 0)
			light_y1 = elevatorBaseY + (make_walls ? 1 : 0)
			light_x2 = elevatorBaseX + lift_size_x - (make_walls ? 1 : 0)
			light_y2 = elevatorBaseY + (make_walls ? 1 : 0)

			ext_panel_x = elevatorBaseX
			ext_panel_y = elevatorSizeY + 1

		if(SOUTH)

			int_panel_x = elevatorBaseX + FLOOR(lift_size_x/2, 1)
			int_panel_y = elevatorSizeY - (make_walls ? 1 : 0)

			door_x1 = elevatorBaseX + 1
			door_y1 = elevatorBaseY
			door_x2 = elevatorSizeX - 1
			door_y2 = elevatorBaseY

			ext_door_x1 = elevatorBaseX + 1
			ext_door_y1 = elevatorBaseY - 1
			ext_door_x2 = elevatorSizeX - 1
			ext_door_y2 = elevatorBaseY - 1

			light_x1 = elevatorBaseX + (make_walls ? 1 : 0)
			light_y1 = elevatorBaseY + (make_walls ? 2 : 1)
			light_x2 = elevatorBaseX + lift_size_x - (make_walls ? 1 : 0)
			light_y2 = elevatorBaseY + lift_size_y - (make_walls ? 1 : 0)

			ext_panel_x = elevatorBaseX
			ext_panel_y = elevatorBaseY - 1

		if(EAST)

			int_panel_x = elevatorBaseX + (make_walls ? 1 : 0)
			int_panel_y = elevatorBaseY + FLOOR(lift_size_y/2, 1)

			door_x1 = elevatorSizeX
			door_y1 = elevatorBaseY + 1
			door_x2 = elevatorSizeX
			door_y2 = elevatorSizeY - 1

			ext_door_x1 = elevatorSizeX + 1
			ext_door_y1 = elevatorBaseY + 1
			ext_door_x2 = elevatorSizeX + 1
			ext_door_y2 = elevatorSizeY - 1

			light_x1 = elevatorBaseX + (make_walls ? 1 : 0)
			light_y1 = elevatorBaseY + (make_walls ? 1 : 0)
			light_x2 = elevatorBaseX + (make_walls ? 1 : 0)
			light_y2 = elevatorBaseY + lift_size_x - (make_walls ? 1 : 0)

			ext_panel_x = elevatorSizeX + 1
			ext_panel_y = elevatorBaseY

		if(WEST)

			int_panel_x = elevatorSizeX - (make_walls ? 1 : 0)
			int_panel_y = elevatorBaseY + FLOOR(lift_size_y/2, 1)

			door_x1 = elevatorBaseX
			door_x2 = elevatorBaseX

			door_y1 = elevatorBaseY + 1
			door_y2 = elevatorSizeY - 1

			ext_door_x1 = elevatorBaseX - 1
			ext_door_y1 = elevatorBaseY + 1
			ext_door_x2 = elevatorBaseX - 1
			ext_door_y2 = elevatorSizeY - 1

			light_x1 = stop.x + lift_size_x - (make_walls ? 1 : 0)
			light_x2 = stop.x + lift_size_x - (make_walls ? 1 : 0)

			light_y1 = stop.y + (make_walls ? 1 : 0)
			light_y2 = stop.y + lift_size_y-1 - (make_walls ? 1 : 0)

			ext_panel_x = elevatorBaseX - 1
			ext_panel_y = elevatorBaseY

	return list("ext_x" = ext_panel_x, "ext_y" = ext_panel_y, "edoor_x1" = ext_door_x1, "edoor_y1" = ext_door_y1, "edoor_x2" = ext_door_x2, "edoor_y2" = ext_door_y2)



/obj/turbolift_map_obj/turbolift_map_base/Destroy()
	turbolifts -= src
	return ..()

/obj/turbolift_map_obj/turbolift_map_base/New()
	turbolifts += src
	..()

/obj/turbolift_map_obj/turbolift_map_base/Initialize()
	. = ..()
	// Create our system controller.
	var/datum/turbolift/lift = new()

	// Holder values since we're moving this object to null ASAP.
	elevatorBaseX   = x
	elevatorBaseY   = y
	elevatorBaseZ   = z
	elevatorBaseDir = dir
	elevatorSizeX 	= (elevatorBaseX+lift_size_x)
	elevatorSizeY 	= (elevatorBaseY+lift_size_y)
	forceMove(null)

	// These modifiers are used in relation to the origin
	// to place the system control panels and doors.
	make_walls = isnull(wall_type) ? FALSE : TRUE





	// Generate each floor and store it in the controller datum.
	var/car_built = FALSE

	for(var/stopAreaPath in turbolift_stops)
		var/area/turbolift/stopArea = locate(stopAreaPath) in world

		// If the area/level isn't loaded, skip it.
		if(!stopArea)
			continue

		var/turf/stop = locate() in stopArea

		if(!stop)
			// Area exists but has no turfs (empty marker?), skip.
			continue

		var/list/coords = computeDirections(stop)

		var/datum/turbolift_stop/cfloor = new()
		cfloor.anchor_turf = locate(elevatorBaseX, elevatorBaseY, stop.z)
		lift.stops += cfloor

		var/list/floor_turfs = list()

		if(!car_built)
			// Build the physical elevator car only at the first VALID stop found.
			// Update the appropriate turfs.
			for(var/turfX = stop.x to (stop.x + lift_size_x))
				for(var/turfY = stop.y to (stop.y + lift_size_y))
					var/turf/checking = locate(turfX, turfY, stop.z)

					if(!istype(checking))
						log_debug("[name] cannot find a component turf at [turfX],[turfY] on floor [stop.z]. Aborting.")
						qdel(src)
						return

					// Update path appropriately if needed.
					var/swap_to = /turf/simulated/open
					if(wall_type && (turfX == elevatorBaseX || turfY == elevatorBaseY || turfX == elevatorSizeX || turfY == elevatorSizeY) && !(turfX >= door_x1 && turfX <= door_x2 && turfY >= door_y1 && turfY <= door_y2))
						swap_to = wall_type
					else
						swap_to = floor_type

					if(checking.type != swap_to)
						checking.ChangeTurf(swap_to)
						checking = locate(turfX, turfY, stop.z)

					// Clear out contents.
					for(var/atom/movable/thing in checking.contents)
						if(thing.simulated)
							qdel(thing)

					if(turfX >= elevatorBaseX && turfX <= elevatorSizeX && turfY >= elevatorBaseY && turfY <= elevatorSizeY)
						floor_turfs += checking

			// Place interior doors (on the wall tiles of the car).
			for(var/turfX = door_x1 to door_x2)
				for(var/turfY = door_y1 to door_y2)
					var/turf/checking = locate(turfX, turfY, stop.z)
					var/obj/machinery/door/airlock/lift/newdoor = new door_type(checking)
					lift.doors += newdoor
					newdoor.lift = cfloor

			// Place lights inside the car.
			var/turf/placing1 = locate(light_x1, light_y1, stop.z)
			var/turf/placing2 = locate(light_x2, light_y2, stop.z)
			var/obj/machinery/light/light1 = new(placing1, light)
			var/obj/machinery/light/light2 = new(placing2, light)
			if(elevatorBaseDir == NORTH || elevatorBaseDir == SOUTH)
				light1.set_dir(WEST)
				light2.set_dir(EAST)
			else
				light1.set_dir(SOUTH)
				light2.set_dir(NORTH)

			// Place interior panel inside the car.
			var/turf/int_T = locate(int_panel_x, int_panel_y, stop.z)
			var/obj/structure/lift/panel/int_panel = new(int_T, lift)
			int_panel.set_dir(elevatorBaseDir)
			lift.control_panel_interior = int_panel

			car_built = TRUE

		// For all stops: assign area to the floor turfs (first stop only has turfs).
		// Note: The car turfs are physically ON the level of the first valid stop.
		// Moving the elevator moves these turfs.
		// We set the area of the car turfs to match the current stop's area type.
		var/area_path = stopAreaPath
		for(var/thing in floor_turfs)
			new area_path(thing)
		var/area/A = locate(area_path)
		cfloor.set_area_ref("\ref[A]")

		// For all stops: place exterior doors and call button (these are fixed to the landing).
		if(stopArea.lift_floor_label)
			// Place exterior doors (one tile outside the shaft opening).
			for(var/turfX = coords["edoor_x1"] to coords["edoor_x2"])
				for(var/turfY = coords["edoor_y1"] to coords["edoor_y2"])
					var/turf/ext_checking = locate(turfX, turfY, stop.z)
					if(ext_checking)
						var/obj/machinery/door/airlock/lift/ext_door = new door_type(ext_checking)
						ext_door.floor = cfloor
						cfloor.doors += ext_door

			// Place exterior call button.
			var/turf/placing = locate(coords["ext_x"], coords["ext_y"], stop.z)
			var/obj/structure/lift/button/panel_ext = new(placing, lift)
			panel_ext.floor = cfloor
			panel_ext.set_dir(elevatorBaseDir)
			panel_ext.pixel_x = 0
			panel_ext.pixel_y = 0
			cfloor.ext_panel = panel_ext


	// Ensure control_panel_interior is set (fallback if somehow not set above).
	if(!lift.control_panel_interior && lift.stops.len)
		var/datum/turbolift_stop/first = lift.stops[1]
		var/area/first_area = locate(first.area_ref)
		var/turf/first_turf = locate() in first_area
		if(first_turf)
			lift.control_panel_interior = new/obj/structure/lift/panel(first_turf, lift)

	if(lift.stops.len)
		lift.current_stop = lift.stops[1]

	lift.open_doors()

	qdel(src) // We're done.
