//A cooking step that involves deep frying food in oil, or air frying in an oven (air fryer basket).
/datum/cooking/recipe_step/use_deepfrier
	class=COOKING_USE_DEEPFRIER
	auto_complete_enabled = TRUE
	var/time
	var/heat

/datum/cooking/recipe_step/use_deepfrier/New(var/set_heat, var/set_time, var/datum/cooking/recipe/our_recipe)
	time = set_time
	heat = set_heat

	desc = "Deep fry or air fry at [heat] for [ticks_to_text(time)]."

	..(our_recipe)


/datum/cooking/recipe_step/use_deepfrier/check_conditions_met(var/obj/used_item, var/datum/cooking/recipe_tracker/tracker)
	var/obj/item/reagent_containers/cooking/container/container = tracker.holder_ref.resolve()
	if(!container)
		return COOKING_CHECK_INVALID
	// Deep fryer accepts only deep fryer basket.
	if(istype(used_item, /obj/machinery/cooking/deepfrier))
		return (container.appliancetype == DF_BASKET) ? COOKING_CHECK_VALID : COOKING_CHECK_INVALID
	// Oven with air fryer basket counts as air frying.
	if(istype(used_item, /obj/machinery/cooking/oven))
		return (container.appliancetype == AF_BASKET) ? COOKING_CHECK_VALID : COOKING_CHECK_INVALID
	return COOKING_CHECK_INVALID

/datum/cooking/recipe_step/use_deepfrier/calculate_quality(var/obj/used_item, var/datum/cooking/recipe_tracker/tracker)
	var/obj/item/reagent_containers/cooking/container/container = tracker.holder_ref.resolve()
	if(!container)
		return 0

	var/bad_cooking = 0
	var/quality_mod = 0

	if(istype(used_item, /obj/machinery/cooking/deepfrier))
		var/obj/machinery/cooking/deepfrier/our_fryer = used_item
		quality_mod = our_fryer.quality_mod
		for(var/key in container.deepfry_data)
			if(heat != key)
				bad_cooking += container.deepfry_data[key]
	else if(istype(used_item, /obj/machinery/cooking/oven))
		var/obj/machinery/cooking/oven/our_oven = used_item
		quality_mod = our_oven.quality_mod
		for(var/key in container.oven_data)
			if(heat != key)
				bad_cooking += container.oven_data[key]

	bad_cooking = round(bad_cooking / (5 SECONDS))
	var/good_cooking = round(time / (3 SECONDS)) - bad_cooking + quality_mod
	return clamp_quality(good_cooking)


/datum/cooking/recipe_step/use_deepfrier/follow_step(var/obj/used_item, var/datum/cooking/recipe_tracker/tracker)
	return COOKING_SUCCESS

/datum/cooking/recipe_step/use_deepfrier/is_complete(var/obj/used_item, var/datum/cooking/recipe_tracker/tracker)
	var/obj/item/reagent_containers/cooking/container/container = tracker.holder_ref.resolve()
	if(!container)
		return FALSE

	if(istype(used_item, /obj/machinery/cooking/deepfrier))
		if(container.deepfry_data[heat] >= time)
			#ifdef COOKING_DEBUG
			log_debug("use_deepfrier/is_complete() Returned True; comparing [heat]: [container.deepfry_data[heat]] to [time]")
			#endif
			return TRUE
		#ifdef COOKING_DEBUG
		log_debug("use_deepfrier/is_complete() Returned False; comparing [heat]: [container.deepfry_data[heat]] to [time]")
		#endif
		return FALSE
	if(istype(used_item, /obj/machinery/cooking/oven))
		if(container.oven_data[heat] >= time)
			return TRUE
		return FALSE
	return FALSE
