// Kitchen chemical heater and cooler. Uses bunson.dmi with overlays: beaker, beaker_lid, heat, cool.
/obj/machinery/cooking/bunson
	name = "kitchen heater-cooler"
	desc = "A bench unit for heating or cooling chemicals in beakers. Place a beaker, then choose heat or cool. Alt+Click to remove the beaker."
	icon = 'icons/obj/cooking/bunson.dmi'
	icon_state = "bunson"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	active_power_usage = 200

	var/obj/item/reagent_containers/beaker = null
	var/mode = 0 // 0 = off, 1 = heat, 2 = cool
	var/target_heat = 350   // K, for heating (e.g. simmer)
	var/target_cool = 270   // K, for cooling (e.g. chill)
	var/heater_coefficient = 0.15
	var/cooler_coefficient = 0.15

/obj/machinery/cooking/bunson/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/cooking/bunson/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker = null
		update_icon()

/obj/machinery/cooking/bunson/update_icon()
	cut_overlays()
	icon_state = "bunson"
	if(beaker)
		add_overlay(image(icon, "beaker", layer=ABOVE_OBJ_LAYER))
		if(mode)
			add_overlay(image(icon, "beaker_lid", layer=ABOVE_OBJ_LAYER))
	if(mode == 1)
		add_overlay(image(icon, "heat", layer=ABOVE_OBJ_LAYER))
	else if(mode == 2)
		add_overlay(image(icon, "cool", layer=ABOVE_OBJ_LAYER))

/obj/machinery/cooking/bunson/Process()
	..()
	if(stat & NOPOWER)
		return
	if(!mode || !beaker || !beaker.reagents?.total_volume)
		if(beaker)
			SStgui.update_uis(src)
		return
	use_power(active_power_usage)
	var/datum/reagents/R = beaker.reagents
	if(mode == 1)
		R.adjust_thermal_energy((target_heat - R.chem_temp) * heater_coefficient * SPECIFIC_HEAT_DEFAULT * R.total_volume)
	else if(mode == 2)
		R.adjust_thermal_energy((target_cool - R.chem_temp) * cooler_coefficient * SPECIFIC_HEAT_DEFAULT * R.total_volume)
	R.handle_reactions()
	SStgui.update_uis(src)

/obj/machinery/cooking/bunson/AltClick(mob/user)
	if(!istype(user) || user.incapacitated() || !in_range(src, user))
		return
	replace_beaker(user)

/obj/machinery/cooking/bunson/proc/replace_beaker(mob/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		beaker.forceMove(drop_location())
		if(istype(user) && user.Adjacent(src))
			user.put_in_hands(beaker)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_icon()
	return TRUE

/obj/machinery/cooking/bunson/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container())
		var/obj/item/reagent_containers/B = I
		if(!user.unEquip(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, SPAN_NOTICE("You place [B] on [src]."))
		update_icon()
		return TRUE
	return ..()

/obj/machinery/cooking/bunson/attack_hand(mob/user)
	if(..())
		return TRUE
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/cooking/bunson/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BunsonHeater", name)
		ui.open()

/obj/machinery/cooking/bunson/ui_data(mob/user)
	var/list/data = list()
	data["mode"] = mode
	if(beaker)
		data["beaker"] = beaker.reagents.nano_ui_data()
	else
		data["beaker"] = null
	return data

/obj/machinery/cooking/bunson/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("eject")
			replace_beaker(usr)
			. = TRUE
		if("mode")
			var/new_mode = text2num(params["mode"])
			if(!isnum(new_mode) || new_mode < 0 || new_mode > 2)
				return
			mode = new_mode
			. = TRUE
	if(.)
		playsound(src, 'sound/machines/button.ogg', 50, 1)
		update_icon()
