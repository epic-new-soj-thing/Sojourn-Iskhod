//Handles the control of airlocks - Baystation 12 style logic

#define STATE_IDLE			0
#define STATE_PREPARE		1
#define STATE_DEPRESSURIZE	2
#define STATE_PRESSURIZE	3

#define TARGET_NONE			0
#define TARGET_INOPEN		-1
#define TARGET_OUTOPEN		-2

#define SENSOR_TOLERANCE 1
// Exterior pressure above this (kPa) means we fill chamber from outside when cycling to exterior
#define EXTERIOR_FILL_THRESHOLD 1

/datum/computer/file/embedded_program/airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump       // Internal pump: chamber <-> station
	var/tag_airpump_ext   // In chamber, vents to outside shuttle (siphon = chamber->exterior, release = exterior->chamber)
	var/tag_scrubber
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_airlock_mech_sensor
	var/tag_shuttle_mech_sensor
	var/tag_purge
	var/tag_secure

	var/state = STATE_IDLE
	var/target_state = TARGET_NONE

/datum/computer/file/embedded_program/airlock/New(var/obj/machinery/embedded_controller/M)
	..(M)

	memory["chamber_sensor_pressure"] = ONE_ATMOSPHERE
	memory["external_sensor_pressure"] = 0
	memory["internal_sensor_pressure"] = ONE_ATMOSPHERE
	memory["exterior_status"] = list(state = "closed", lock = "locked")
	memory["interior_status"] = list(state = "closed", lock = "locked")
	memory["pump_status"] = "unknown"
	memory["target_pressure"] = ONE_ATMOSPHERE
	memory["purge"] = 0
	memory["secure"] = 0
	memory["depressurize_pump_ext_only"] = 0
	memory["pressurize_pump_ext_only"] = 0
	memory["pressurize_with_pump_ext"] = 0
	memory["fill_from_ext_after"] = 0

	if (istype(M, /obj/machinery/embedded_controller/radio/airlock))
		var/obj/machinery/embedded_controller/radio/airlock/controller = M
		tag_exterior_door = controller.tag_exterior_door ? controller.tag_exterior_door : "[id_tag]_outer"
		tag_interior_door = controller.tag_interior_door ? controller.tag_interior_door : "[id_tag]_inner"
		// Pump/scrubber tags: use controller's if set (e.g. map-set to match custom pump id), else default from id_tag
		tag_airpump = controller.tag_airpump ? controller.tag_airpump : "[id_tag]_pump"
		tag_airpump_ext = controller.tag_airpump_ext ? controller.tag_airpump_ext : "[id_tag]_pump_ext"
		tag_scrubber = controller.tag_scrubber ? controller.tag_scrubber : "[id_tag]_scrubber"
		tag_chamber_sensor = controller.tag_chamber_sensor ? controller.tag_chamber_sensor : "[id_tag]_sensor"
		tag_exterior_sensor = controller.tag_exterior_sensor
		tag_interior_sensor = controller.tag_interior_sensor
		tag_airlock_mech_sensor = controller.tag_airlock_mech_sensor ? controller.tag_airlock_mech_sensor : "[id_tag]_airlock_mech"
		tag_shuttle_mech_sensor = controller.tag_shuttle_mech_sensor ? controller.tag_shuttle_mech_sensor : "[id_tag]_shuttle_mech"
		tag_purge = controller.tag_purge && istext(controller.tag_purge) ? controller.tag_purge : "[id_tag]_purge"
		tag_secure = controller.tag_secure && istext(controller.tag_secure) ? controller.tag_secure : "[id_tag]_secure"
		memory["secure"] = istext(controller.tag_secure) ? 0 : controller.tag_secure
		memory["purge"] = istext(controller.tag_purge) ? 0 : controller.tag_purge

		if(memory["purge"])
			receive_user_command("purge")

		spawn(10)
			signalDoor(tag_exterior_door, "update")
			signalDoor(tag_interior_door, "update")
			signalPump(tag_airpump, 0)
			if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
			if(tag_scrubber) signalScrubber(tag_scrubber, 0)

/datum/computer/file/embedded_program/airlock/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	if(!receive_tag) return

	if(receive_tag==tag_chamber_sensor)
		if(signal.data["pressure"])
			memory["chamber_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_sensor)
		memory["external_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_interior_sensor)
		memory["internal_sensor_pressure"] = text2num(signal.data["pressure"])

	else if(receive_tag==tag_exterior_door)
		memory["exterior_status"]["state"] = signal.data["door_status"]
		memory["exterior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_interior_door)
		memory["interior_status"]["state"] = signal.data["door_status"]
		memory["interior_status"]["lock"] = signal.data["lock_status"]

	else if(receive_tag==tag_airpump)
		if(signal.data["power"])
			memory["pump_status"] = signal.data["direction"]
		else
			memory["pump_status"] = "off"

	else if(receive_tag==tag_purge)
		receive_user_command("purge")

	else if(receive_tag==tag_secure)
		receive_user_command("secure")

	else if(receive_tag==id_tag)
		if(istype(master, /obj/machinery/embedded_controller/radio/airlock/access_controller))
			switch(signal.data["command"])
				if("cycle_exterior")
					receive_user_command("cycle_ext_door")
				if("cycle_interior")
					receive_user_command("cycle_int_door")
				if("cycle")
					if(memory["interior_status"]["state"] == "open")
						receive_user_command("cycle_ext_door")
					else
						receive_user_command("cycle_int_door")
		else
			switch(signal.data["command"])
				if("cycle_exterior")
					if(state == target_state)
						begin_cycle_out()
				if("cycle_interior")
					if(state == target_state)
						begin_cycle_in()
				if("cycle")
					if(memory["interior_status"]["state"] == "open")
						if(state == target_state)
							begin_cycle_out()
					else
						if(state == target_state)
							begin_cycle_in()


/datum/computer/file/embedded_program/airlock/receive_user_command(command)
	var/shutdown_pump = 0
	switch(command)
		if("cycle_ext")
			if(!memory["purge"] && ISINRANGE(memory["external_sensor_pressure"], memory["chamber_sensor_pressure"] - SENSOR_TOLERANCE, memory["chamber_sensor_pressure"] + SENSOR_TOLERANCE))
				toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
				toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")
			else if(state == target_state)
				begin_cycle_out()

		if("cycle_int")
			if(!memory["purge"] && ISINRANGE(memory["internal_sensor_pressure"], memory["chamber_sensor_pressure"] - SENSOR_TOLERANCE, memory["chamber_sensor_pressure"] + SENSOR_TOLERANCE))
				toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")
				toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
			else if(state == target_state)
				begin_cycle_in()

		if("cycle_ext_door")
			cycleDoors(TARGET_OUTOPEN)

		if("cycle_int_door")
			cycleDoors(TARGET_INOPEN)

		if("abort")
			stop_cycling()

		if("force_ext")
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "toggle")

		if("force_int")
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "toggle")

		if("purge")
			memory["purge"] = !memory["purge"]
			if(memory["purge"])
				close_doors()
				state = STATE_PREPARE
				target_state = TARGET_NONE

		if("secure")
			memory["secure"] = !memory["secure"]
			if(memory["secure"])
				signalDoor(tag_interior_door, "lock")
				signalDoor(tag_exterior_door, "lock")
			else
				signalDoor(tag_interior_door, "unlock")
				signalDoor(tag_exterior_door, "unlock")

	if(shutdown_pump)
		signalPump(tag_airpump, 0)
		if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
		if(tag_scrubber) signalScrubber(tag_scrubber, 0)


/datum/computer/file/embedded_program/airlock/Process()
	if(!state)
		if(target_state)
			switch(target_state)
				if(TARGET_INOPEN)
					// Cycle in: depressurize (pump_ext siphon to exterior) then fill (internal pump from station)
					memory["target_pressure"] = 0
					memory["fill_from_ext_after"] = 0
				if(TARGET_OUTOPEN)
					// Cycle out: depressurize (internal pump siphon to station) then optionally fill (pump_ext from exterior)
					memory["target_pressure"] = 0
					memory["fill_from_ext_after"] = (tag_airpump_ext && memory["external_sensor_pressure"] > EXTERIOR_FILL_THRESHOLD)

			close_doors()
			state = STATE_PREPARE
		else
			if(memory["pump_status"] != "off")
				signalPump(tag_airpump, 0)
				if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
				if(tag_scrubber) signalScrubber(tag_scrubber, 0)

	if ((state == STATE_PRESSURIZE || state == STATE_DEPRESSURIZE) && !check_doors_secured())
		stop_cycling()

	switch(state)
		if(STATE_PREPARE)
			if (check_doors_secured())
				var/chamber_pressure = memory["chamber_sensor_pressure"]
				var/target_pressure = memory["target_pressure"]

				if(memory["purge"])
					target_pressure = 0
					state = STATE_DEPRESSURIZE
					signalPump(tag_airpump, 1, 0, target_pressure)
					if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
					if(tag_scrubber) signalScrubber(tag_scrubber, 1, 1)
					memory["depressurize_pump_ext_only"] = 0

				else if(chamber_pressure <= target_pressure + SENSOR_TOLERANCE)
					// At or below target: pressurize (fill chamber)
					state = STATE_PRESSURIZE
					if(memory["pressurize_with_pump_ext"])
						// Fill from exterior (cycle out, second phase)
						signalPump(tag_airpump_ext, 1, 1, target_pressure)
						signalPump(tag_airpump, 0)
						memory["pressurize_pump_ext_only"] = 1
						memory["pressurize_with_pump_ext"] = 0
					else
						// Fill from station (internal pump)
						signalPump(tag_airpump, 1, 1, target_pressure)
						if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
						memory["pressurize_pump_ext_only"] = 0
					if(tag_scrubber) signalScrubber(tag_scrubber, 0)

				else if(chamber_pressure > target_pressure)
					// Above target: depressurize (siphon chamber)
					state = STATE_DEPRESSURIZE
					// Cycle out: siphon chamber to station via internal pump. Cycle in: siphon chamber to exterior via pump_ext.
					if(target_state == TARGET_OUTOPEN)
						signalPump(tag_airpump, 1, 0, target_pressure)
						if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
						memory["depressurize_pump_ext_only"] = 0
					else
						// TARGET_INOPEN: vent chamber through pump_ext to exterior
						if(tag_airpump_ext)
							signalPump(tag_airpump_ext, 1, 0, target_pressure)
							signalPump(tag_airpump, 0)
							memory["depressurize_pump_ext_only"] = 1
						else
							signalPump(tag_airpump, 1, 0, target_pressure)
							memory["depressurize_pump_ext_only"] = 0
					if(tag_scrubber) signalScrubber(tag_scrubber, 1, 1)

				memory["target_pressure"] = target_pressure

		if(STATE_PRESSURIZE)
			if(memory["chamber_sensor_pressure"] >= memory["target_pressure"] - SENSOR_TOLERANCE)
				if(memory["pressurize_pump_ext_only"])
					// Filling from exterior (pump_ext doesn't report status); turn off and open
					signalPump(tag_airpump_ext, 0)
					signalPump(tag_airpump, 0)
					if(tag_scrubber) signalScrubber(tag_scrubber, 0)
					cycleDoors(target_state)
					state = STATE_IDLE
					target_state = TARGET_NONE
				else if(memory["pump_status"] != "off")
					signalPump(tag_airpump, 0)
					if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
					if(tag_scrubber) signalScrubber(tag_scrubber, 0)
				else
					cycleDoors(target_state)
					state = STATE_IDLE
					target_state = TARGET_NONE

		if(STATE_DEPRESSURIZE)
			if(memory["chamber_sensor_pressure"] <= memory["target_pressure"] + SENSOR_TOLERANCE)
				if(memory["depressurize_pump_ext_only"])
					// Exterior pump was used (no status reported); turn it off
					signalPump(tag_airpump_ext, 0)
					signalPump(tag_airpump, 0)
					if(tag_scrubber) signalScrubber(tag_scrubber, 0)
					if(memory["purge"])
						memory["purge"] = 0
						memory["target_pressure"] = (target_state == TARGET_INOPEN ? memory["internal_sensor_pressure"] : memory["external_sensor_pressure"])
						if (memory["target_pressure"] > SENSOR_TOLERANCE)
							state = STATE_PREPARE
						else
							cycleDoors(target_state)
							state = STATE_IDLE
							target_state = TARGET_NONE
					else if(target_state == TARGET_INOPEN)
						// Cycle in: now fill from station with internal pump
						memory["target_pressure"] = memory["internal_sensor_pressure"]
						state = STATE_PREPARE
					else
						cycleDoors(target_state)
						state = STATE_IDLE
						target_state = TARGET_NONE
				else if(memory["pump_status"] != "off")
					signalPump(tag_airpump, 0)
					if(tag_airpump_ext) signalPump(tag_airpump_ext, 0)
					if(tag_scrubber) signalScrubber(tag_scrubber, 0)
				else
					if(memory["purge"])
						memory["purge"] = 0
						memory["target_pressure"] = (target_state == TARGET_INOPEN ? memory["internal_sensor_pressure"] : memory["external_sensor_pressure"])
						if (memory["target_pressure"] > SENSOR_TOLERANCE)
							state = STATE_PREPARE
						else
							cycleDoors(target_state)
							state = STATE_IDLE
							target_state = TARGET_NONE
					else if(target_state == TARGET_OUTOPEN && memory["fill_from_ext_after"] && tag_airpump_ext)
						// Cycle out: depressurize done; now fill from exterior if it has atmosphere
						memory["target_pressure"] = memory["external_sensor_pressure"]
						memory["pressurize_with_pump_ext"] = 1
						state = STATE_PREPARE
					else
						cycleDoors(target_state)
						state = STATE_IDLE
						target_state = TARGET_NONE

	memory["processing"] = (state != target_state)

	return 1

/datum/computer/file/embedded_program/airlock/proc/begin_cycle_in()
	state = STATE_IDLE
	target_state = TARGET_INOPEN

/datum/computer/file/embedded_program/airlock/proc/begin_cycle_out()
	state = STATE_IDLE
	target_state = TARGET_OUTOPEN

/datum/computer/file/embedded_program/airlock/proc/close_doors()
	toggleDoor(memory["interior_status"], tag_interior_door, 1, "close")
	toggleDoor(memory["exterior_status"], tag_exterior_door, 1, "close")

/datum/computer/file/embedded_program/airlock/proc/stop_cycling()
	state = STATE_IDLE
	target_state = TARGET_NONE

/datum/computer/file/embedded_program/airlock/proc/done_cycling()
	return (state == STATE_IDLE && target_state == TARGET_NONE)

/datum/computer/file/embedded_program/airlock/proc/check_exterior_door_secured()
	return (memory["exterior_status"]["state"] == "closed" && memory["exterior_status"]["lock"] == "locked")

/datum/computer/file/embedded_program/airlock/proc/check_interior_door_secured()
	return (memory["interior_status"]["state"] == "closed" && memory["interior_status"]["lock"] == "locked")

/datum/computer/file/embedded_program/airlock/proc/check_doors_secured()
	var/ext_closed = check_exterior_door_secured()
	var/int_closed = check_interior_door_secured()
	return (ext_closed && int_closed)

/datum/computer/file/embedded_program/airlock/proc/signalDoor(var/tag, var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = tag
	signal.data["command"] = command
	post_signal(signal, RADIO_AIRLOCK)

/datum/computer/file/embedded_program/airlock/proc/signalPump(var/tag, var/power, var/direction, var/pressure)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"power" = power,
		"direction" = direction,
		"set_external_pressure" = pressure,
		"expanded_range" = TRUE
	)
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/signalScrubber(var/tag, var/power, var/panic=0)
	var/datum/signal/signal = new
	signal.data = list(
		"tag" = tag,
		"sigtype" = "command",
		"power" = power,
		"panic_siphon" = panic,
		"scrubbing" = !panic,
		"co2_scrub" = 1,
		"tox_scrub" = 1,
		"n2o_scrub" = 1
	)
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/cycleDoors(var/target)
	switch(target)
		if(TARGET_OUTOPEN)
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")
		if(TARGET_INOPEN)
			toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")
			toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
		if(TARGET_NONE)
			var/command = "unlock"
			if(memory["secure"])
				command = "lock"
			signalDoor(tag_exterior_door, command)
			signalDoor(tag_interior_door, command)

/datum/computer/file/embedded_program/airlock/proc/signal_mech_sensor(var/command, var/sensor)
	var/datum/signal/signal = new
	signal.data["tag"] = sensor
	signal.data["command"] = command
	post_signal(signal)

/datum/computer/file/embedded_program/airlock/proc/enable_mech_regulation()
	signal_mech_sensor("enable", tag_shuttle_mech_sensor)
	signal_mech_sensor("enable", tag_airlock_mech_sensor)

/datum/computer/file/embedded_program/airlock/proc/disable_mech_regulation()
	signal_mech_sensor("disable", tag_shuttle_mech_sensor)
	signal_mech_sensor("disable", tag_airlock_mech_sensor)

/datum/computer/file/embedded_program/airlock/proc/toggleDoor(var/list/doorStatus, var/doorTag, var/secure, var/command)
	var/doorCommand = null

	if(command == "toggle")
		if(doorStatus["state"] == "open")
			command = "close"
		else if(doorStatus["state"] == "closed")
			command = "open"

	switch(command)
		if("close")
			if(secure)
				if(doorStatus["state"] == "open")
					doorCommand = "secure_close"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "open")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag, "unlock")
					doorCommand = "close"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

		if("open")
			if(secure)
				if(doorStatus["state"] == "closed")
					doorCommand = "secure_open"
				else if(doorStatus["lock"] == "unlocked")
					doorCommand = "lock"
			else
				if(doorStatus["state"] == "closed")
					if(doorStatus["lock"] == "locked")
						signalDoor(doorTag,"unlock")
					doorCommand = "open"
				else if(doorStatus["lock"] == "locked")
					doorCommand = "unlock"

	if(doorCommand)
		signalDoor(doorTag, doorCommand)


#undef STATE_IDLE
#undef STATE_PREPARE
#undef STATE_DEPRESSURIZE
#undef STATE_PRESSURIZE
#undef TARGET_NONE
#undef TARGET_INOPEN
#undef TARGET_OUTOPEN
#undef SENSOR_TOLERANCE
#undef EXTERIOR_FILL_THRESHOLD
