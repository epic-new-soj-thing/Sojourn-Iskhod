// High-performance liquid chromatography machine (chemical mass spectrometer)
// Ported from tgstation. Separates reagents by mass range; purity/inverse chemistry not implemented in this codebase.

/obj/machinery/chem_mass_spec
	name = "high-performance liquid chromatography machine"
	desc = "Allows you to separate reagents by mass range. Insert input and output beakers, set the mass range, and start."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "HPLC"
	var/base_icon_state = "HPLC"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	active_power_usage = 100
	circuit = /obj/item/circuitboard/chem_mass_spec

	var/processing_reagents = FALSE
	var/delay_time = 0
	var/progress_time = 0
	var/lower_mass_range = 0
	var/upper_mass_range = INFINITY
	var/list/log = list()
	var/obj/item/reagent_containers/beaker1
	var/obj/item/reagent_containers/beaker2
	var/cms_coefficient = 1

/obj/machinery/chem_mass_spec/Initialize(mapload)
	. = ..()
	if(mapload)
		beaker2 = new /obj/item/reagent_containers/glass/beaker/large(src)

/obj/machinery/chem_mass_spec/Destroy()
	QDEL_NULL(beaker1)
	QDEL_NULL(beaker2)
	return ..()

/obj/machinery/chem_mass_spec/on_deconstruction(disassembled)
	var/turf/T = get_turf(src)
	if(beaker1)
		beaker1.forceMove(T)
	if(beaker2)
		beaker2.forceMove(T)
	..()

/obj/machinery/chem_mass_spec/examine(mob/user)
	. = ..()
	if(beaker1)
		. += SPAN_NOTICE("Input beaker of [beaker1.reagents.maximum_volume]u capacity is inserted. Alt-click to eject.")
	else
		. += SPAN_WARNING("No input beaker. Insert with left click.")
	if(beaker2)
		. += SPAN_NOTICE("Output beaker of [beaker2.reagents.maximum_volume]u capacity is inserted. Eject via the machine's interface.")
	else
		. += SPAN_WARNING("No output beaker. Insert via the machine's interface.")

/obj/machinery/chem_mass_spec/update_icon()
	if(stat & NOPOWER || !anchored || !beaker1)
		icon_state = "[base_icon_state]"
	else if(processing_reagents)
		icon_state = "[base_icon_state]_on"
	else
		icon_state = "[base_icon_state]"

	cut_overlays()
	if(panel_open)
		add_overlay(mutable_appearance(icon, "[base_icon_state]_panel-o"))
		return ..()
	if(beaker1)
		add_overlay(mutable_appearance(icon, "[base_icon_state]_beaker1"))
	if(beaker2)
		add_overlay(mutable_appearance(icon, "[base_icon_state]_beaker2"))
	if(!inoperable() && anchored && !(stat & BROKEN))
		if(processing_reagents)
			add_overlay(mutable_appearance(icon, "[base_icon_state]_graph_active"))
		else if(beaker1?.reagents && length(beaker1.reagents.reagent_list))
			add_overlay(mutable_appearance(icon, "[base_icon_state]_graph_idle"))
	return ..()

/obj/machinery/chem_mass_spec/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker1)
		beaker1 = null
	if(A == beaker2)
		beaker2 = null
	update_icon()

/obj/machinery/chem_mass_spec/proc/calculate_mass(smallest = TRUE)
	if(!beaker1 || !beaker1.reagents)
		return 0
	var/result = 0
	for(var/datum/reagent/R in beaker1.reagents.reagent_list)
		var/datum/reagent/template = GLOB.chemical_reagents_list[R.id]
		var/m = template ? template.mass : 1
		if(!result)
			result = m
		else
			result = smallest ? min(result, m) : max(result, m)
	return smallest ? FLOOR(result, 50) : CEILING(result, 50)

/obj/machinery/chem_mass_spec/proc/replace_beaker(mob/user, is_input, obj/item/reagent_containers/new_beaker)
	if(is_input)
		if(beaker1)
			beaker1.forceMove(get_turf(src))
			if(user && Adjacent(user))
				user.put_in_hands(beaker1)
		if(new_beaker && user && user.unEquip(new_beaker, src))
			beaker1 = new_beaker
		else if(new_beaker)
			beaker1 = new_beaker
		else
			beaker1 = null
		if(beaker1)
			lower_mass_range = calculate_mass(smallest = TRUE)
			upper_mass_range = calculate_mass(smallest = FALSE)
			estimate_time()
	else
		if(beaker2)
			beaker2.forceMove(get_turf(src))
			if(user && Adjacent(user))
				user.put_in_hands(beaker2)
		if(new_beaker && user && user.unEquip(new_beaker, src))
			beaker2 = new_beaker
		else if(new_beaker)
			beaker2 = new_beaker
		else
			beaker2 = null
		if(!new_beaker)
			log.Cut()
	update_icon()
	return TRUE

/obj/machinery/chem_mass_spec/proc/estimate_time()
	delay_time = 0
	if(!beaker1 || !beaker1.reagents)
		return
	for(var/datum/reagent/R in beaker1.reagents.reagent_list)
		var/datum/reagent/template = GLOB.chemical_reagents_list[R.id]
		var/mass = template ? template.mass : 1
		if(mass < lower_mass_range || mass > upper_mass_range)
			continue
		delay_time += ((mass * R.volume) * 0.0035) + 10
	delay_time *= cms_coefficient

/obj/machinery/chem_mass_spec/RefreshParts()
	. = ..()
	cms_coefficient = 1
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		cms_coefficient /= L.rating

/obj/machinery/chem_mass_spec/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return
	if(processing_reagents)
		to_chat(user, SPAN_WARNING("Still processing!"))
		return
	var/obj/item/reagent_containers/B = I
	if(istype(B) && B.is_open_container())
		// Always insert into input slot; use UI to insert into output slot
		if(beaker1)
			beaker1.forceMove(get_turf(src))
			if(Adjacent(user))
				user.put_in_hands(beaker1)
		if(user.unEquip(B, src))
			beaker1 = B
			lower_mass_range = calculate_mass(smallest = TRUE)
			upper_mass_range = calculate_mass(smallest = FALSE)
			estimate_time()
		to_chat(user, SPAN_NOTICE("You add [B] to the input slot."))
		update_icon()
		SStgui.update_uis(src)
		return
	return ..()

/obj/machinery/chem_mass_spec/AltClick(mob/user)
	if(!istype(user) || user.incapacitated() || !in_range(src, user))
		return
	if(processing_reagents)
		to_chat(user, SPAN_WARNING("Still processing!"))
		return
	replace_beaker(user, TRUE)
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/chem_mass_spec/Process()
	if(!processing_reagents)
		return
	if(stat & NOPOWER || !anchored)
		return
	progress_time += 1
	if(progress_time >= delay_time)
		processing_reagents = FALSE
		progress_time = 0
		log.Cut()
		if(!beaker1 || !beaker2 || !beaker1.reagents || !beaker2.reagents)
			update_icon()
			SStgui.update_uis(src)
			return
		var/datum/reagents/input_reagents = beaker1.reagents
		var/datum/reagents/output_reagents = beaker2.reagents
		var/list/to_transfer = list()
		for(var/datum/reagent/R in beaker1.reagents.reagent_list)
			var/datum/reagent/template = GLOB.chemical_reagents_list[R.id]
			var/mass = template ? template.mass : 1
			if(mass < lower_mass_range || mass > upper_mass_range)
				continue
			to_transfer[R.id] = R.volume
		for(var/id in to_transfer)
			var/product_vol = min(to_transfer[id], output_reagents.get_free_space())
			if(product_vol <= 0)
				continue
			input_reagents.remove_reagent(id, product_vol)
			output_reagents.add_reagent(id, product_vol)
			var/datum/reagent/R = GLOB.chemical_reagents_list[id]
			if(R)
				log[R.type] = "Separated"
		lower_mass_range = calculate_mass(smallest = TRUE)
		upper_mass_range = calculate_mass(smallest = FALSE)
		estimate_time()
		update_icon()
		SStgui.update_uis(src)
		return
	use_power(active_power_usage)

/obj/machinery/chem_mass_spec/attack_hand(mob/user)
	if(..())
		return TRUE
	if(inoperable())
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/chem_mass_spec/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MassSpec", name)
		ui.open()

/obj/machinery/chem_mass_spec/ui_data(mob/user)
	. = list()
	.["lowerRange"] = lower_mass_range
	.["upperRange"] = upper_mass_range
	.["processing"] = processing_reagents
	.["eta"] = max(0, delay_time - progress_time)
	.["peakHeight"] = 0
	var/obj/item/held = user.get_active_hand()
	.["hasBeakerInHand"] = istype(held, /obj/item/reagent_containers) && held.is_open_container()

	if(beaker1 && beaker1.reagents)
		var/list/beaker1Data = list(
			"currentVolume" = beaker1.reagents.total_volume,
			"maxVolume" = beaker1.reagents.maximum_volume,
			"contents" = list()
		)
		for(var/datum/reagent/R in beaker1.reagents.reagent_list)
			var/datum/reagent/template = GLOB.chemical_reagents_list[R.id]
			var/mass = template ? template.mass : 1
			.["peakHeight"] = max(.["peakHeight"], R.volume)
			beaker1Data["contents"] += list(list(
				"name" = R.name,
				"volume" = round(R.volume, 0.01),
				"mass" = mass,
				"purity" = 100,
				"type" = "Clean",
				"log" = "Ready"
			))
		.["beaker1"] = beaker1Data
	else
		.["beaker1"] = null

	.["graphUpperRange"] = calculate_mass(smallest = FALSE) + 10

	if(beaker2 && beaker2.reagents)
		var/list/beaker2Data = list(
			"currentVolume" = beaker2.reagents.total_volume,
			"maxVolume" = beaker2.reagents.maximum_volume,
			"contents" = list()
		)
		for(var/datum/reagent/R in beaker2.reagents.reagent_list)
			beaker2Data["contents"] += list(list(
				"name" = R.name,
				"volume" = round(R.volume, 0.01),
				"mass" = R.mass,
				"purity" = 100,
				"type" = "Clean",
				"log" = log[R.type] || "Separated"
			))
		.["beaker2"] = beaker2Data
	else
		.["beaker2"] = null

/obj/machinery/chem_mass_spec/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(. || processing_reagents)
		return

	switch(action)
		if("activate")
			if(!beaker1)
				visible_message(SPAN_NOTICE("\The [src] beeps: \"Missing input beaker!\""))
				return
			if(!beaker2)
				visible_message(SPAN_NOTICE("\The [src] beeps: \"Missing output beaker!\""))
				return
			progress_time = 0
			estimate_time()
			if(delay_time <= 0)
				visible_message(SPAN_NOTICE("\The [src] beeps: \"No work to be done!\""))
				return
			processing_reagents = TRUE
			update_icon()
			return TRUE

		if("leftSlider")
			var/value = text2num(params["value"])
			if(!isnull(value))
				var/lowest = calculate_mass(smallest = TRUE)
				lower_mass_range = clamp(value, lowest, (lower_mass_range + upper_mass_range) / 2)
				estimate_time()
			return TRUE

		if("rightSlider")
			var/value = text2num(params["value"])
			if(!isnull(value))
				var/highest = calculate_mass(smallest = FALSE)
				upper_mass_range = clamp(value, (lower_mass_range + upper_mass_range) / 2, highest)
				estimate_time()
			return TRUE

		if("centerSlider")
			var/value = text2num(params["value"])
			if(!isnull(value))
				var/delta_center = ((lower_mass_range + upper_mass_range) / 2) - value
				var/lowest = calculate_mass(smallest = TRUE)
				var/highest = calculate_mass(smallest = FALSE)
				lower_mass_range = clamp(lower_mass_range - delta_center, lowest, highest)
				upper_mass_range = clamp(upper_mass_range - delta_center, lowest, highest)
				estimate_time()
			return TRUE

		if("eject1")
			replace_beaker(ui.user, TRUE)
			return TRUE

		if("eject2")
			replace_beaker(ui.user, FALSE)
			return TRUE

		if("insert1")
			var/obj/item/reagent_containers/C = ui.user.get_active_hand()
			if(istype(C) && C.is_open_container())
				replace_beaker(ui.user, TRUE, C)
			return TRUE

		if("insert2")
			var/obj/item/reagent_containers/C = ui.user.get_active_hand()
			if(istype(C) && C.is_open_container())
				replace_beaker(ui.user, FALSE, C)
			return TRUE
