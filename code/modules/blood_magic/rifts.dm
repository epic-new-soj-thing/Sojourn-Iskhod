// Blood Magic module — rifts (portal spells).
// Rift.: open a temporary rift — either to deep maintenance (default) or to a chosen area.
// Choosing a destination is very dangerous and can kill the caster.

/// Returns TRUE if the area is allowed as a rift destination (no admin-only / centcom / thunderdome).
/obj/effect/decal/cleanable/blood_rune/proc/rift_area_allowed(area/A)
	if(!A)
		return FALSE
	if(istype(A, /area/admin))
		return FALSE
	if(is_type_in_list(A, centcom_areas))
		return FALSE
	if(istype(A, /area/shuttle/thunderdome))
		return FALSE
	if(istype(A, /area/space))
		return FALSE
	return TRUE

/// Builds a list of areas that have at least one valid floor turf and are allowed for rifts.
/obj/effect/decal/cleanable/blood_rune/proc/get_valid_rift_areas()
	var/list/valid = list()
	for(var/area/A in all_areas)
		if(!rift_area_allowed(A))
			continue
		var/has_floor = FALSE
		for(var/turf/simulated/floor/T in A)
			has_floor = TRUE
			break
		if(has_floor)
			valid[A.name] = A
	return valid

// Rift.: Open a temporary rift. Cancel at area prompt = deep maintenance. Choosing an area is very dangerous.
/obj/effect/decal/cleanable/blood_rune/proc/rift_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return
	if(!body_checks(M))
		return

	var/list/valid_areas = get_valid_rift_areas()
	var/list/area_names = list()
	for(var/name in valid_areas)
		area_names += name
	if(!area_names.len)
		area_names += "(No other areas available)"

	var/chosen_name = input(M, "Choose destination area. Cancel to open a rift to deep maintenance instead.", "Rift destination") as null|anything in area_names
	var/turf/simulated/floor/destination = null
	var/dangerous = FALSE
	var/desc_text = "A tear in reality. It will not last long."
	var/blood_cost = 40
	var/sanity_cost = -8
	var/entropy_amount = 5
	var/portal_failchance = 5

	if(chosen_name && chosen_name != "(No other areas available)" && valid_areas[chosen_name])
		var/area/A = valid_areas[chosen_name]
		var/list/turfs = list()
		for(var/turf/simulated/floor/T in A)
			turfs += T
		if(!turfs.len)
			to_chat(M, SPAN_WARNING("No valid floor in that area."))
			return
		destination = pick(turfs)
		dangerous = TRUE
		desc_text = "A tear in reality leading to [A.name]. It will not last long. It looks unstable."
		blood_cost = 80
		sanity_cost = -20
		entropy_amount = 15
		portal_failchance = 15

		// Risk of death or severe harm when casting a chosen rift
		if(prob(25))
			if(prob(40))
				to_chat(M, SPAN_DANGER("Reality bites back; the rift tears at your body!"))
				M.apply_damage(80, BRUTE, null, 1, 1, sharp = TRUE)
				if(M.stat == DEAD)
					return
			else
				to_chat(M, SPAN_DANGER("The rift collapses through you. You are unmade."))
				M.gib()
				return
		else if(prob(30))
			to_chat(M, SPAN_WARNING("The ritual exacts a heavy toll; you feel your life force drain."))
			M.apply_damage(40, BRUTE, null, 1, 1, sharp = TRUE)
		else
			to_chat(M, SPAN_WARNING("Opening the rift leaves you shaken and bleeding."))
			M.apply_damage(15, BRUTE, null, 1, 1, sharp = TRUE)
	else
		// Default: deep maintenance
		var/list/validtargets = list()
		for(var/area/A in world)
			if(istype(A, /area/deepmaint))
				for(var/turf/simulated/floor/T in A)
					validtargets += T
		if(!validtargets.len)
			to_chat(M, SPAN_WARNING("No place in deep maintenance could be found to anchor the rift."))
			return
		destination = pick(validtargets)
		desc_text = "A tear in reality leading into deep maintenance. It will not last long."

	B.remove_self(blood_cost)
	M.sanity.changeLevel(sanity_cost, TRUE)
	bluespace_entropy(entropy_amount, get_turf(src))
	to_chat(M, SPAN_NOTICE("Reality tears; a rift opens[dangerous ? " to the chosen place" : " to the depths"]."))
	playsound(src.loc, 'sound/effects/portal_open.ogg', 60, 1)
	var/obj/effect/portal/P = new /obj/effect/portal(src.loc, 2 MINUTES)
	P.name = "rift"
	P.desc = desc_text
	P.icon = 'icons/obj/spatial_cut.dmi'
	P.icon_state = "rift"
	P.mask = "rift_mask"
	P.SpawnAnimationState = "rift_spawn"
	P.DespawnAnimationState = "rift_dissolve"
	P.DespawnAnimationTime = 9
	P.failchance = portal_failchance
	P.set_target(destination)
