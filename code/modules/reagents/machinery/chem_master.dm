/obj/machinery/chem_master
	name = "ChemMaster 4500"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/chemmaster
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chemmaster"
	var/base_icon_state = "chemmaster"
	/// Icon state prefix for overlay sprites; defaults to base_icon_state if unset (e.g. condimaster can use "chemmaster" overlays)
	var/overlay_icon_state = null
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	var/obj/item/reagent_containers/glass/beaker = null
	var/mode = FALSE
	var/condi = FALSE
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle"
	var/syrettesprite = "syrette"
	var/pillsprite = "1"
	var/pill_bottle_sprite = "pill_canister"
	var/client/has_sprites = list()
	var/max_pill_count = 24 //max of pills that can be made in a bottle
	var/max_pill_vol = 60 //max vol pills can have
	reagent_flags = OPENCONTAINER
	/// TRUE while creating pills/bottles/syrettes; drives overlay_screen_active
	var/is_printing = FALSE

/obj/machinery/chem_master/proc/update_chem_master_icon()
	cut_overlays()
	var/overlay_base = overlay_icon_state || base_icon_state
	// Beaker slot
	if(beaker)
		add_overlay(mutable_appearance(icon, "[overlay_base]_overlay_container"))
	// Broken and panel
	if(stat & BROKEN)
		add_overlay(mutable_appearance(icon, "[overlay_base]_overlay_broken"))
	if(panel_open)
		add_overlay(mutable_appearance(icon, "[overlay_base]_overlay_panel"))
	// Extruder (idle or active when printing)
	add_overlay(mutable_appearance(icon, is_printing ? "[overlay_base]_overlay_extruder_active" : "[overlay_base]_overlay_extruder"))
	// Screen and glow when closed and operational
	if(!panel_open && !inoperable())
		var/screen_overlay = "[overlay_base]_overlay_screen"
		if(is_printing)
			screen_overlay += "_active"
		else if(reagents?.total_volume > 0)
			screen_overlay += "_main"
		add_overlay(mutable_appearance(icon, screen_overlay))
		set_light(1, 1, "#fffb00")
	else
		set_light(0)

/obj/machinery/chem_master/Initialize(mapload)
	. = ..()
	update_chem_master_icon()

/obj/machinery/chem_master/power_change()
	. = ..()
	if(inoperable())
		is_printing = FALSE
	update_chem_master_icon()

/obj/machinery/chem_master/RefreshParts()
	if(!reagents)
		create_reagents(10)
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to_holder(reagents, G.volume)
	update_chem_master_icon()

/obj/machinery/chem_master/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		var/amount = G.reagents.get_free_space()
		reagents.trans_to_holder(G, amount)
	..()

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)

/obj/machinery/chem_master/MouseDrop_T(atom/movable/I, mob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container() && !beaker)
		if(user.drop_from_inventory(I))
			user.drop_from_inventory(I)
			I.forceMove(src)
			I.add_fingerprint(user)
			beaker = I
			to_chat(user, SPAN_NOTICE("You add [I] to [src]."))
			SStgui.update_uis(src)
			update_chem_master_icon()
			return
	. = ..()

/obj/machinery/chem_master/proc/has_stats_to_use(mob/user)
	if(simple_machinery)
		return TRUE

	if(user.stats?.getPerk(PERK_NERD) || user.stats?.getPerk(PERK_MEDICAL_EXPERT))
		return TRUE

	//Are we missing the perk AND too low on bio? Needs 15 bio, so 30 to bypass
	if(user.stat_check(STAT_BIO, STAT_LEVEL_EXPERT) || user.stat_check(STAT_COG, 30))
		return TRUE

	return FALSE

/obj/machinery/chem_master/attackby(obj/item/B, mob/user)
	if(default_deconstruction(B, user))
		update_chem_master_icon()
		return

	if(default_part_replacement(B, user))
		return

	//Are we missing the perk AND to low on bio? Needs 15 bio so 30 to bypass
	if(!has_stats_to_use(user))
		to_chat(user, SPAN_WARNING("Your biological understanding isn't enough to use this."))
		return

	if(istype(B, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return

		if(user.unEquip(B, src))
			beaker = B
			to_chat(user, "You add the beaker to the machine!")
			update_chem_master_icon()
		SStgui.update_uis(src)
		return

/obj/machinery/chem_master/attack_hand(mob/user)
	if(inoperable())
		return

	//Are we missing the perk AND to low on bio? Needs 15 bio so 30 to bypass
	if(!has_stats_to_use(user))
		to_chat(user, SPAN_WARNING("Your biological understanding isn't enough to use this."))
		return

	ui_interact(user)

/obj/machinery/chem_master/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/chem_master)
	)

/obj/machinery/chem_master/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster", name)
		ui.open()

/obj/machinery/chem_master/ui_static_data(mob/user)
	var/list/data = list()

	var/pills = list()
	for(var/i in 1 to MAX_PILL_SPRITE)
		pills += "pill[i]"

	data["available_sprites"] = list(
		"pill" = pills,
		"bottle" = BOTTLE_SPRITES,
		"syrette" = SYRETTE_SPRITES,
		"pill_bottle" = PILL_BOTTLE_MODELS,
	)

	return data

/obj/machinery/chem_master/var/analyze_reagent = null

/obj/machinery/chem_master/ui_data(mob/user)
	var/list/data = list()

	data["mode"] = mode
	data["condi"] = condi
	data["buffer"] = reagents.nano_ui_data()

	if(beaker)
		data["beaker"] = beaker.reagents.nano_ui_data()
	else
		data["beaker"] = null

	data["analyze_reagent"] = null
	if(analyze_reagent && beaker)
		for(var/datum/reagent/R as anything in beaker.reagents.reagent_list)
			if(R.id == analyze_reagent)
				var/list/reagent_data = list(
					"name" = R.name,
					"desc" = R.description,
				)

				if(istype(R, /datum/reagent/organic/blood))
					var/datum/reagent/organic/blood/B = R
					reagent_data["blood_type"] = B.data["blood_type"]
					reagent_data["blood_DNA"] = B.data["blood_DNA"]

				data["analyze_reagent"] = reagent_data
				break

		if(!data["analyze_reagent"])
			data["analyze_reagent"] = "ERROR: '[analyze_reagent]' not found in [beaker]"

	data["max_pill_count"] = max_pill_count
	data["set_sprites"] = list(
		"pill" = pillsprite,
		"bottle" = bottlesprite,
		"syrette" = syrettesprite,
		"pill_bottle" = pill_bottle_sprite,
	)

	return data

/obj/machinery/chem_master/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				reagents.clear_reagents()
				update_chem_master_icon()
			. = TRUE
		if("toggle_mode")
			mode = !mode
			. = TRUE
		if("analyze")
			analyze_reagent = params["reagent"]
			. = TRUE
		if("transfer")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(amount == -1)
				amount = tgui_input_number(usr, "Select the amount to transfer.", "Transfer Amount", amount)
			var/target = params["target"]
			transfer(id, amount, target)
			update_chem_master_icon()
			. = TRUE
		if("print")
			var/type = params["type"]
			print(type)
			. = TRUE
		if("set_sprite")
			var/type = params["type"]
			var/sprite = params["sprite"]
			change_sprite(type, sprite)
			. = TRUE

	if(.)
		playsound(src, 'sound/machines/button.ogg', 100, 1)

/obj/machinery/chem_master/proc/transfer(id, amount, target)
	if(!beaker || !beaker.reagents)
		return FALSE

	var/datum/reagents/from_reagents
	// for some reason all of the trans_ procs in reagents require an atom with reagents instead of a reagents datum
	var/atom/to_reagents
	switch(target)
		if("buffer")
			from_reagents = beaker.reagents
			to_reagents = src
			amount = CLAMP(amount, 0, reagents.get_free_space())
		if("beaker")
			if(!mode)
				amount = CLAMP(amount, 0, reagents.total_volume)
				reagents.remove_reagent(id, amount)
				return TRUE
			from_reagents = reagents
			to_reagents = beaker
			amount = CLAMP(amount, 0, beaker.reagents.get_free_space())
		else
			return FALSE

	from_reagents.trans_id_to(to_reagents, id, amount)
	if(to_reagents.reagents.get_free_space() < 1)
		switch(target)
			if("buffer")
				to_chat(usr, SPAN_WARNING("[src] is full."))
			if("beaker")
				to_chat(usr, SPAN_WARNING("[beaker] is full."))

	return TRUE

/obj/machinery/chem_master/proc/print(type)
	if(condi && type != "bottle")
		return FALSE
	switch(type)
		if("pill")
			create_pill()
		if("bottle")
			create_bottle()
		if("syrette")
			create_syrette()
		if("supeyrette")
			create_supeyrette()
		else
			return FALSE
	return TRUE

/obj/machinery/chem_master/proc/create_pill()
	var/count = 0
	var/amount_per_pill = 0

	if(!reagents.total_volume) //Sanity checking.
		return

	var/create_pill_bottle = FALSE
	if(tgui_alert(usr, "Create bottle?", "Container.", buttons = list("Yes", "No")) == "Yes")
		create_pill_bottle = TRUE

	switch(tgui_alert(usr, "Select method to create pills.", "Choose method.", buttons = list("By amount", "By volume")))
		if("By amount")
			count = tgui_input_number(usr, "Select the number of pills to make.", "Max [max_pill_count]", pillamount)
			if(count > max_pill_count)
				tgui_alert(usr, "Maximum supported pills amount is [max_pill_count]","Error.")
				return
			if(pillamount > max_pill_vol)
				tgui_alert(usr, "Maximum volume supported in pills is [max_pill_vol]","Error.")
				return
			count = CLAMP(count, 1, max_pill_count)

		if("By volume")
			amount_per_pill = tgui_input_number(usr, "Select the volume that single pill should contain.", "Max [reagents.total_volume]", 5)
			amount_per_pill = CLAMP(amount_per_pill, 1, reagents.total_volume)
			if(reagents.total_volume > max_pill_vol)
				tgui_alert(usr, "Maximum volume supported in pills is [max_pill_vol]", "Error.")
				return
			if((reagents.total_volume / amount_per_pill) > max_pill_count)
				tgui_alert(usr, "Maximum supported pills amount is [max_pill_count]", "Error.")
				return
		else
			return

	if(count)
		if(reagents.total_volume < count) // min is 1 unit
			return
		amount_per_pill = reagents.total_volume / count

	if(amount_per_pill > max_pill_vol)
		amount_per_pill = max_pill_vol

	var/name = tgui_input_text(usr, "Name:", "Name your pill!", "[reagents.get_master_reagent_name()] ([amount_per_pill] units)", max_length = MAX_NAME_LEN)
	var/obj/item/storage/pill_bottle/PB
	if(create_pill_bottle)
		PB = new(get_turf(src))
		PB.pixel_x = rand(-7, 7) //random position Suffer medical powergamers
		PB.pixel_y = rand(-7, 7)
		PB.name = "[PB.name] ([name])"
		PB.matter = list()
		PB.icon_state = "[pill_bottle_sprite]"

	is_printing = TRUE
	update_chem_master_icon()
	while(reagents.total_volume)
		var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(loc)
		if(!name)
			name = reagents.get_master_reagent_name()
		P.name = "[name] pill"
		P.pixel_x = rand(-7, 7) //random position
		P.pixel_y = rand(-7, 7)
		P.icon_state = "pill" + pillsprite
		reagents.trans_to_obj(P, amount_per_pill)
		if(PB)
			P.forceMove(PB)
	is_printing = FALSE
	update_chem_master_icon()

/obj/machinery/chem_master/proc/create_bottle()
	if(!condi)
		var/name = tgui_input_text(usr, "Name:", "Name your bottle!", reagents.get_master_reagent_name(), max_length = MAX_NAME_LEN)
		if(!name)
			return
		is_printing = TRUE
		update_chem_master_icon()
		var/obj/item/reagent_containers/glass/bottle/P = new /obj/item/reagent_containers/glass/bottle(loc)
		P.name = "[name] bottle"
		P.pixel_x = rand(-7, 7) //random position
		P.pixel_y = rand(-7, 7)
		P.icon_state = bottlesprite
		if(bottlesprite == "potion")
			P.filling_states = "10;20;40;50;60"
		if(bottlesprite == "tincture")
			P.filling_states = "3;5;10;15;20;25;27;30;35;40;45;50;55;60"
		P.label_icon_state = "label_[bottlesprite]"
		P.matter = list()
		reagents.trans_to_obj(P,60)
		if(P.name != " bottle")		// it can be named "bottle" if you create a bottle with no reagents in buffer (it doesn't work without a space in the name, trust me)
			P.force_label = TRUE	// if this isn't the case we force a label on the sprite
		P.toggle_lid()
		is_printing = FALSE
		update_chem_master_icon()
	else
		is_printing = TRUE
		update_chem_master_icon()
		var/obj/item/reagent_containers/condiment/P = new/obj/item/reagent_containers/condiment(loc)
		reagents.trans_to_obj(P, 50)
		is_printing = FALSE
		update_chem_master_icon()

/obj/machinery/chem_master/proc/create_syrette()
	var/name = tgui_input_text(usr, "Name:", "Name your syrette!", reagents.get_master_reagent_name(), max_length = MAX_NAME_LEN)
	if(!name)
		return
	is_printing = TRUE
	update_chem_master_icon()
	var/obj/item/reagent_containers/hypospray/autoinjector/chemmaters/P = new /obj/item/reagent_containers/hypospray/autoinjector/chemmaters(loc)
	P.name = "[name] syrette"
	P.pixel_x = rand(-7, 7) //random position
	P.pixel_y = rand(-7, 7)
	P.matter = list()
	P.icon_state = syrettesprite
	P.item_state = syrettesprite
	P.baseline_sprite = syrettesprite
	reagents.trans_to_obj(P,5)
	P.update_icon()
	is_printing = FALSE
	update_chem_master_icon()

/obj/machinery/chem_master/proc/create_supeyrette()
	var/name = tgui_input_text(usr, "Name:", "Name your advanced syrette!", reagents.get_master_reagent_name(), max_length = MAX_NAME_LEN)
	if(!name)
		return
	is_printing = TRUE
	update_chem_master_icon()
	var/obj/item/reagent_containers/hypospray/autoinjector/large/chemmaters/P = new /obj/item/reagent_containers/hypospray/autoinjector/large/chemmaters(loc)
	P.name = "[name] advanced syrette"
	P.pixel_x = rand(-7, 7) //random position
	P.pixel_y = rand(-7, 7)
	P.matter = list()
	reagents.trans_to_obj(P,10)
	P.update_icon()
	is_printing = FALSE
	update_chem_master_icon()

/obj/machinery/chem_master/proc/change_sprite(type, sprite)
	switch(type)
		if("pill")
			pillsprite = sprite
			return TRUE
		if("bottle")
			bottlesprite = sprite
			return TRUE
		if("syrette")
			syrettesprite = sprite
			return TRUE
		if("pill_bottle")
			pill_bottle_sprite = sprite
			return TRUE
	return FALSE

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	icon_state = "condimaster"
	base_icon_state = "condimaster"
	overlay_icon_state = "chemmaster"
	condi = TRUE
	simple_machinery = TRUE

/obj/machinery/chem_master/medical
	name = "MediMaster 6000"

/obj/machinery/chem_master/medical/Initialize()
	. = ..()
	for(var/obj/item/reagent_containers/glass/beaker/B in component_parts)
		component_parts -= B
		qdel(B)
	component_parts += new /obj/item/reagent_containers/glass/beaker/large(src)
	component_parts += new /obj/item/reagent_containers/glass/beaker/large(src)
	RefreshParts()
