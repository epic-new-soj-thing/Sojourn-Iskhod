
// Base variants are applied to everyone on the same Z level
// Range variants are applied on per-range basis: numbers here are on point blank, scales with distance
#define DETONATION_RADS 200 // Increased radiation
#define DETONATION_MOB_CONCUSSION 8

// Base amount of ticks for which a specific type of machine will be offline for. +- 20% added by RNG.
#define DETONATION_APC_OVERLOAD_PROB 40
#define DETONATION_SHUTDOWN_APC 120
#define DETONATION_SHUTDOWN_CRITAPC 10
#define DETONATION_SHUTDOWN_SMES 60
#define DETONATION_SHUTDOWN_RNG_FACTOR 20
#define DETONATION_SOLAR_BREAK_CHANCE 60

#define WARNING_DELAY 20 //seconds between warnings.

/obj/machinery/power/supermatter
	name = "supermatter core"
	desc = "A strangely translucent and iridescent crystal. <span class='danger'>You get headaches just from looking at it.</span>"
	icon = 'icons/obj/engine.dmi'
	icon_state = "supermatter"
	density = TRUE
	anchored = FALSE
	light_range = 4
	layer = ABOVE_ALL_MOB_LAYER

	//Configurable variables (previously defines)
	var/nitrogen_retardation_factor = 0.15
	var/thermal_release_modifier = 15000
	var/phoron_release_modifier = 1500
	var/oxygen_release_modifier = 15000
	var/radiation_release_modifier = 2
	var/reaction_power_modifier = 1.1

	var/power_factor = 1.0
	var/decay_factor = 700
	var/critical_temperature = 5000
	var/charging_factor = 0.05
	var/damage_rate_limit = 4.5

	var/gasefficency = 0.25
	var/base_icon_state = "supermatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/code_orange_point = 500
	var/emergency_point = 700
	var/code_red_point = 800
	var/code_delta_point = 900
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#927a10"
	var/base_color = "#927a10"
	var/warning_color = "#c78c20"
	var/emergency_color = "#ffd04f"
	var/rotation_angle = 0

	var/grav_pulling = 0
	var/pull_time = 300 // 30 seconds
	var/explosion_power = 9 // Massive explosion

	var/emergency_issued = 0
	var/lastwarning = 0
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Configuration
	var/config_bullet_energy = 2
	var/config_hallucination_power = 0.1

	var/obj/item/device/radio/radio
	var/debug = 0
	var/disable_adminwarn = FALSE

	// Admin Warning States
	var/aw_normal = FALSE
	var/aw_warning = FALSE
	var/aw_danger = FALSE
	var/aw_emerg = FALSE
	var/aw_delam = FALSE
	var/aw_EPR = FALSE

	var/last_status = SUPERMATTER_INACTIVE
	var/delam_test_running = FALSE

/obj/machinery/power/supermatter/Initialize()
	. = ..()
	radio = new /obj/item/device/radio{channels=list("Engineering")}(src)
	assign_uid()

/obj/machinery/power/supermatter/Destroy()
	if(GLOB.supermatter_status)
		GLOB.supermatter_status.raise_event(src, SUPERMATTER_INACTIVE)
	QDEL_NULL(radio)
	. = ..()

/obj/machinery/power/supermatter/proc/handle_admin_warnings()
	if(disable_adminwarn)
		return

	aw_normal = status_adminwarn_check(SUPERMATTER_NORMAL, aw_normal, "INFO: Supermatter crystal has been energised", FALSE)
	aw_warning = status_adminwarn_check(SUPERMATTER_WARNING, aw_warning, "WARN: Supermatter crystal is taking integrity damage", FALSE)
	aw_danger = status_adminwarn_check(SUPERMATTER_DANGER, aw_danger, "WARN: Supermatter integrity is below 50%", TRUE)
	aw_emerg = status_adminwarn_check(SUPERMATTER_EMERGENCY, aw_emerg, "CRIT: Supermatter integrity is below 25%", FALSE)
	aw_delam = status_adminwarn_check(SUPERMATTER_DELAMINATING, aw_delam, "CRIT: Supermatter is delaminating", TRUE)

	if(get_status() && (get_epr() < 0.5))
		if(!aw_EPR)
			var/area/A = get_area(src)
			log_and_message_admins("WARN: Supermatter EPR value low. Possible core breach detected in [A.name]", null, src)
		aw_EPR = TRUE
	else
		aw_EPR = FALSE

/obj/machinery/power/supermatter/proc/status_adminwarn_check(min_status, current_state, message, send_to_irc = FALSE)
	var/status = get_status()
	if(status >= min_status)
		if(!current_state)
			var/area/A = get_area(src)
			log_and_message_admins(message + " in [A.name]", null, src)
		return TRUE
	else
		return FALSE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > critical_temperature))
		return SUPERMATTER_WARNING

	if(air.temperature > (critical_temperature * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE

/obj/machinery/power/supermatter/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	log_and_message_admins("Supermatter delaminating at [x] [y] [z]", null, src)
	anchored = TRUE
	grav_pulling = 1
	exploded = 1
	sleep(pull_time)
	var/turf/TS = get_turf(src)
	if(!istype(TS))
		return

	var/list/affected_z = GetConnectedZlevels(TS.z)

	// Effect 1: Radiation, weakening to all mobs on Z level + User request: "spew radiation on detonation"
	for(var/mob/living/L in view(get_turf(src), world.maxy)) // Fallback to view() to approximate z-level
		if(L.z in affected_z)
			L.apply_effect(DETONATION_RADS, IRRADIATE)
			to_chat(L, SPAN_DANGER("An invisible force slams you against the ground!"))
			L.Weaken(DETONATION_MOB_CONCUSSION)

	// Effect 2: EMP All Areas (User request) + Electrical pulse
	for(var/obj/machinery/M in GLOB.machines)
		if(M.z in affected_z)
			M.emp_act(1) // EMP everything level 1 severity

	// Effect 3: Break solar arrays (already covered by EMP but specific logic here too)
	for(var/obj/machinery/power/solar/S in GLOB.machines)
		if((S.z in affected_z) && prob(DETONATION_SOLAR_BREAK_CHANCE))
			S.broken()

	// Effect 4: Massive Explosion (User request)
	spawn(0)
		explosion(TS, explosion_power * 3.5) // Power 9 * 3.5 = 31.5 devastation range? Massive.
		qdel(src)

/obj/machinery/power/supermatter/examine(mob/user)
	. = ..()
	// Removed skill checks due to missing defines. Now everyone can see the status.
	var/integrity_message
	switch(get_integrity())
		if(0 to 30)
			integrity_message = SPAN_DANGER("It looks highly unstable!")
		if(31 to 70)
			integrity_message = "It appears to be losing cohesion!"
		else
			integrity_message = "At a glance, it seems to be in sound shape."
	to_chat(user, integrity_message)

	var/display_power = power
	display_power *= (0.85 + 0.3 * rand())
	display_power = round(display_power, 20)
	to_chat(user, "Eyeballing it, you place the relative EER at around [display_power] MeV/cm3.")

/obj/machinery/power/supermatter/proc/shift_light(lum, clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, 1, l_color = clr)

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity

/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage > code_orange_point)
		alert_msg = "Danger! Crystal hyperstructure integrity below 50%!" + alert_msg
		lastwarning = world.timeofday
	else if(damage >= damage_archived)
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null

	if(alert_msg)
		if(radio)
			radio.autosay(alert_msg, "Supermatter Monitor", "Engineering")

		//Public alerts
		if((damage > code_orange_point) && !public_alert)
			if(radio)
				radio.autosay("WARNING: SUPERMATTER CRYSTAL INTEGRITY BELOW 50%. CODE ORANGE IS NOW IN EFFECT.", "Supermatter Monitor")
			public_alert = 1

			for(var/mob/M in GLOB.player_list)
				var/turf/T = get_turf(M)
				if(T && (T.z in GLOB.maps_data.station_levels) && !istype(M,/mob/new_player) && !isdeaf(M))
					sound_to(M, 'sound/effects/matteralarm.ogg')

			// Set alert level to code orange
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
			var/decl/security_level/orange = decls_repository.get_decl(/decl/security_level/default/code_orange)
			if(security_state && orange && security_state.current_security_level_is_lower_than(orange))
				security_state.set_security_level(orange)

		if((damage > code_red_point) && public_alert < 2)
			if(radio)
				radio.autosay("WARNING: SUPERMATTER CRYSTAL INTEGRITY CRITICAL. CODE RED IN EFFECT.", "Supermatter Monitor")
			public_alert = 2
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
			var/decl/security_level/red = decls_repository.get_decl(/decl/security_level/default/code_red)
			if(security_state && red && security_state.current_security_level_is_lower_than(red))
				security_state.set_security_level(red, TRUE)

		if((damage > code_delta_point) && public_alert < 3)
			if(radio)
				radio.autosay("CRITICAL WARNING: SUPERMATTER CRYSTAL INTEGRITY FAILURE IMMINENT. CODE DELTA IN EFFECT.", "Supermatter Monitor")
			public_alert = 3
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
			var/decl/security_level/delta = decls_repository.get_decl(/decl/security_level/default/code_delta)
			if(security_state && delta && security_state.current_security_level_is_lower_than(delta))
				security_state.set_security_level(delta, TRUE)

		if((damage > emergency_point) && public_alert < 1.5) // Just a marker for the delam imminent message
			if(radio)
				radio.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT! SAFEROOMS UNBOLTED.", "Supermatter Monitor")
			// We don't increment public_alert higher than its threshold above unless it clears

		else if(integrity > 50 && public_alert)
			if(radio)
				radio.autosay("Supermatter crystal has returned to safe operating levels. Reverting emergency lighting.", "Supermatter Monitor")

			for(var/obj/machinery/light/L in GLOB.machines)
				if(L.z in GLOB.maps_data.station_levels)
					L.reset_color()
			public_alert = 0

/obj/machinery/power/supermatter/Process()
	var/turf/L = loc

	if(isnull(L))
		return PROCESS_KILL

	if(!istype(L))
		return

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space) && (L.z in GLOB.maps_data.station_levels))
				announce_warning()
			explode()
	else if(damage > warning_point)
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && ((world.timeofday - lastwarning) >= WARNING_DELAY * 10) && (L.z in GLOB.maps_data.station_levels))
			announce_warning()
	else
		shift_light(4,base_color)
	if(grav_pulling)
		supermatter_pull(src)

	//Send state changed events
	var/current_status = get_status()
	if(current_status != last_status)
		GLOB.supermatter_status.raise_event(src, current_status)
		last_status = current_status

	handle_admin_warnings()

	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*damage_rate_limit

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)

	if(!env || !removed || !removed.total_moles)
		damage_archived = damage
		damage += max((power - 15*power_factor)/10, 0)
	else if (grav_pulling)
		env.remove(env.total_moles)
	else
		damage_archived = damage
		damage = max(0, damage + clamp((removed.temperature - critical_temperature) / 150, -damage_rate_limit, damage_inc_limit))

		oxygen = clamp((removed.get_by_flag(XGM_GAS_OXIDIZER) - (removed.gas[GAS_NITROGEN] * nitrogen_retardation_factor)) / removed.total_moles, 0, 1)

		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			equilibrium_power = 250
			icon_state = base_icon_state

		if (damage > code_orange_point)
			icon_state = "[base_icon_state]_glow"

		temp_factor = ( (equilibrium_power/decay_factor)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		var/device_energy = power * reaction_power_modifier

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi(GAS_PLASMA, max(device_energy / phoron_release_modifier, 0), \
							 GAS_OXYGEN, max((device_energy + removed.temperature - T0C) / oxygen_release_modifier, 0))

		var/thermal_power = thermal_release_modifier * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		removed.add_thermal_energy(thermal_power)
		removed.temperature = clamp(removed.temperature, 0, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/subject in view(src, min(7, round(sqrt(power/6)))))
		// Note: removed meson check because access methods were missing.
		// If you want to add it back, check slot_eyes for meson goggles.
		var/obj/item/organ/internal/eyes/eyes = subject.random_organ_by_process(OP_EYES)
		if (!eyes)
			continue
		if (BP_IS_ROBOTIC(eyes))
			continue

		var/effect = max(0, min(200, power * config_hallucination_power * sqrt( 1 / max(1,get_dist(subject, src)))) )
		subject.adjust_hallucination(effect, 0.25 * effect)

	var/level = LERP(0, 50, clamp( (damage - emergency_point) / (explosion_point - emergency_point),0,1))
	var/list/new_color = color_contrast(level )

	if(rotation_angle != 0)
		if(level != 0)
			new_color = multiply_matrices(new_color, color_rotation(rotation_angle), 4, 3,3)
		else
			new_color = color_rotation(rotation_angle)

	color = new_color

	if (damage >= emergency_point && !length(filters))
		filters = filter(type="rays", size = 64, color = "#ffd04f", factor = 0.6, density = 12)
		animate(filters[1], time = 10 SECONDS, offset = 10, loop=-1)
		animate(time = 10 SECONDS, offset = 0, loop=-1)

		animate(filters[1], time = 2 SECONDS, size = 80, loop=-1, flags = ANIMATION_PARALLEL)
		animate(time = 2 SECONDS, size = 10, loop=-1, flags = ANIMATION_PARALLEL)
	else if (damage < emergency_point)
		filters = null

	PulseRadiation(src, power * radiation_release_modifier, 5) // Local logic
	power -= (power/decay_factor)**3
	handle_admin_warnings()

	return 1


/obj/machinery/power/supermatter/bullet_act(obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))
		return 0

	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		power += proj_damage * config_bullet_energy	* charging_factor / power_factor
	else
		damage += proj_damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as mob)
	var/pronoun = user.gender == MALE ? "his" : "her"
	user.visible_message(
		SPAN_WARNING("\The [user] reaches out and touches \the [src], inducing a resonance. For a brief instant, [pronoun] body glows brilliantly, then flashes into ash."),
		SPAN_DANGER("You reach out and touch \the [src]. Instantly, you feel a curious sensation as your body turns into new and exciting forms of plasma. That was not a wise decision."),
		SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
	)
	Consume(user)

/obj/machinery/power/supermatter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data = list()

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	var/turf/T = get_turf(src)

	if(istype(T))
		env = T.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling
	data["energy"] = power

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/supermatter/attackby(obj/item/W, mob/living/user)
	// Logic for general tool interaction:
	user.visible_message(
		SPAN_WARNING("\The [user] touches \a [W] to \the [src], then flinches away as it flashes instantly into dust. Silence blankets the air."),
		SPAN_DANGER("You touch \the [W] to \the [src]. Everything suddenly goes silent as it flashes into dust, and you flinch away."),
		SPAN_WARNING("For a brief moment, you hear an oppressive, unnatural silence.")
	)

	user.apply_effect(150, IRRADIATE)
	if (user.drop_from_inventory(W))
		Consume(W)
		return TRUE
	return ..()


/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /obj/effect))
		return
	if(istype(AM, /mob/living))
		var/mob/victim = AM
		var/pronoun = victim.gender == MALE ? "his" : "her"
		AM.visible_message(
			SPAN_WARNING("\The [AM] slams into \the [src], inducing a resonance. For a brief instant, [pronoun] body glows brilliantly, then flashes into ash."),
			SPAN_DANGER("You slam into \the [src], and your mind fills with unearthly shrieking. Your vision floods with light as your body instantly dissolves into dust."),
			SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
		)
	else if(!grav_pulling)
		AM.visible_message(
			SPAN_WARNING("\The [AM] smacks into \the [src] and rapidly flashes to ash."),
			SPAN_WARNING("You hear a loud crack as you are washed with a wave of heat.")
		)

	Consume(AM)


/obj/machinery/power/supermatter/proc/Consume(mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

	for(var/mob/living/l in range(10))
		if(l in view())
			to_chat(l, SPAN_WARNING("As \the [src] slowly stops resonating, you feel an intense wave of heat wash over you."))
		else
			to_chat(l, SPAN_WARNING("You hear a muffled, shrill ringing as an intense wave of heat washes over you."))
	var/rads = 500
	PulseRadiation(src, rads, 5)


/proc/supermatter_pull(atom/target, pull_range = 255, pull_power = STAGE_FIVE)
	for(var/atom/A in range(pull_range, target))
		A.singularity_pull(target, pull_power)

/obj/machinery/power/supermatter/GotoAirflowDest(n)
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/ex_act(severity)
	switch(severity)
		if(1) // EX_ACT_DEVASTATING
			power *= 4
		if(2) // EX_ACT_HEAVY
			power *= 3
		if(3) // EX_ACT_LIGHT
			power *= 2
	log_and_message_admins("WARN: Explosion near the Supermatter! New EER: [power].", null, src)

/obj/machinery/power/supermatter/shard
	name = "supermatter shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='danger'>You get headaches just from looking at it.</span>"
	icon_state = "supermatter_shard"
	base_icon_state = "supermatter_shard"

	warning_point = 50
	code_orange_point = 300
	emergency_point = 400
	code_red_point = 480
	code_delta_point = 540
	explosion_point = 600

	gasefficency = 0.125

	pull_time = 150
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning()
	return


/obj/machinery/power/supermatter/randomsample
	name = "experimental supermatter sample"
	icon_state = "supermatter_shard"
	base_icon_state = "supermatter_shard"

/obj/machinery/power/supermatter/randomsample/Initialize()
	. = ..()
	nitrogen_retardation_factor = rand(0.01, 1) // Fixed 'frand'
	thermal_release_modifier = rand(100, 1000000)
	phoron_release_modifier = rand(0, 100000)
	oxygen_release_modifier = rand(0, 100000)
	radiation_release_modifier = rand(0, 100)
	reaction_power_modifier =  rand(0, 100)

	power_factor = rand(0, 20)
	decay_factor = rand(50, 70000)
	critical_temperature = rand(3000, 5000)
	charging_factor = rand(0, 1)
	damage_rate_limit = rand( 1, 10)

/obj/machinery/power/supermatter/inert
	name = "experimental supermatter sample"
	icon_state = "supermatter_shard"
	base_icon_state = "supermatter_shard"
	thermal_release_modifier = 0
	phoron_release_modifier = 100000000000
	oxygen_release_modifier = 100000000000
	radiation_release_modifier = 1

/obj/machinery/power/supermatter/verb/test_delamination()
	set name = "Test Delamination"
	set category = "Debug"
	set src in view()

	if(!usr.client || !check_rights(R_ADMIN))
		return

	if(delam_test_running)
		delam_test_running = FALSE
		damage = 0
		to_chat(usr, SPAN_NOTICE("Stopping delamination test on [src] and restoring integrity."))
		return

	delam_test_running = TRUE
	to_chat(usr, SPAN_NOTICE("Initiating slow delamination test on [src]..."))
	message_admins("[key_name_admin(usr)] initiated a slow delamination test on [src] at [x],[y],[z].")

	spawn(0)
		while(src && delam_test_running && damage < explosion_point)
			damage = min(damage + 5, explosion_point)
			sleep(1 SECONDS)
		if(src)
			delam_test_running = FALSE
			if(damage < explosion_point)
				damage = 0
			to_chat(usr, SPAN_NOTICE("Delamination test complete, stopped, or crystal destroyed. Integrity restored."))
