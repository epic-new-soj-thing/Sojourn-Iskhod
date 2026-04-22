/obj/machinery/cooking/deepfrier
	name = "Deep fryer"
	desc = "A vat of oil for deep frying. Use a deep fryer basket to cook food. \nShift+Click: Set temperature or timer \nShift+Ctrl+Click: Turn on the fryer."
	icon = 'icons/obj/cooking/fryer.dmi'
	icon_state = "deep_fryer"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	cooking = FALSE
	var/temperature = J_LO
	var/timer = 0
	var/timerstamp = 0
	var/switches = 0
	var/cooking_timestamp = 0
	var/items = null

	var/reference_time = 0

	var/power_cost = 3000
	var/check_on_10 = 0

	var/on_fire = FALSE

	var/datum/effect/effect/system/smoke_spread/bad/bsmoke = new /datum/effect/effect/system/smoke_spread/bad

	circuit = /obj/item/circuitboard/cooking/deepfrier


/obj/machinery/cooking/deepfrier/New()
	..()
	bsmoke.attach(src)
	bsmoke.set_up(7, 0, src.loc)

/obj/machinery/cooking/deepfrier/Process()

	if(on_fire)
		emit_fire()

	if(switches)
		handle_cooking(null, FALSE)

	if(check_on_10 != 10)
		check_on_10++
		return
	else
		check_on_10 = 0

	if(switches)
		use_power(power_cost)


/obj/machinery/cooking/deepfrier/RefreshParts()
	..()

	var/las_rating = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_rating += M.rating
	quality_mod = round(las_rating/2)

/obj/machinery/cooking/deepfrier/proc/cook_checkin()
	if(items)
		var/old_timestamp = cooking_timestamp
		switch(temperature)
			if("Low")
				spawn(COOKING_BURN_TIME_LOW)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(COOKING_IGNITE_TIME_LOW)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()
			if("Medium")
				spawn(COOKING_BURN_TIME_MEDIUM)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(COOKING_IGNITE_TIME_MEDIUM)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()
			if("High")
				spawn(COOKING_BURN_TIME_HIGH)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(COOKING_IGNITE_TIME_HIGH)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()

/obj/machinery/cooking/deepfrier/proc/handle_burning()
	if(!(items && istype(items, /obj/item/reagent_containers/cooking/container)))
		return
	var/obj/item/reagent_containers/cooking/container/container = items
	container.handle_burning()

/obj/machinery/cooking/deepfrier/proc/handle_ignition()
	if(!(items && istype(items, /obj/item/reagent_containers/cooking/container)))
		return
	bsmoke.start()
	var/area/area = get_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.triggerAlarm(loc, FA, 0)
	on_fire = TRUE

/obj/machinery/cooking/deepfrier/proc/emit_fire()
	bsmoke.start()

/obj/machinery/cooking/deepfrier/attackby(var/obj/item/used_item, var/mob/user, params)
	if(default_deconstruction(used_item, user))
		return

	if(on_fire && istype(used_item, /obj/item/extinguisher))
		var/obj/item/extinguisher/exting = used_item
		if(!exting.safety)
			if (exting.reagents.total_volume < 1)
				to_chat(usr, SPAN_NOTICE("\The [exting] is empty."))
				return
			if (world.time < exting.last_use + 20)
				return
			exting.last_use = world.time
			playsound(exting.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
			exting.reagents.remove_any(20)
			on_fire = FALSE
			return

	if(istype(used_item, /obj/item/gripper))
		var/obj/item/gripper/gripper = used_item
		if(!gripper.wrapped && items)
			var/obj/item/reagent_containers/cooking/container/container = items
			var/turf/T = get_turf(src)
			container.forceMove(T)
			items = null
			update_icon()
		return

	if(items != null)
		var/obj/item/reagent_containers/cooking/container/container = items
		if(istype(used_item, /obj/item/spatula))
			container.do_empty(user, target=src, reagent_clear = FALSE)
		else
			container.process_item(used_item, params)

	else if(istype(used_item, /obj/item/reagent_containers/cooking/container))
		var/obj/item/reagent_containers/cooking/container/container = used_item
		if(container.appliancetype != DF_BASKET)
			to_chat(usr, SPAN_WARNING("Only a deep fryer basket can be used in the deep fryer."))
			update_icon()
			return
		to_chat(usr, SPAN_NOTICE("You put \the [used_item] in the deep fryer."))
		if(usr.canUnEquip(used_item))
			usr.unEquip(used_item, src)
		else
			used_item.forceMove(src)
		items = used_item
		if(switches == 1)
			cooking_timestamp = world.time

	update_icon()

/obj/machinery/cooking/deepfrier/proc/remove_basket(mob/user)
	if(!items)
		return
	if(switches == 1)
		handle_cooking(user)
		cooking_timestamp = world.time
		if(ishuman(user) && (temperature == "High" || temperature == "Medium"))
			var/mob/living/carbon/human/burn_victim = user
			if(!burn_victim.gloves)
				switch(temperature)
					if("High")
						burn_victim.adjustFireLoss(5)
					if("Medium")
						burn_victim.adjustFireLoss(2)
				to_chat(burn_victim, SPAN_DANGER("You burn your hand taking the [items] out of the deep fryer."))
	else
		to_chat(user, SPAN_NOTICE("You take \the [items] out of the deep fryer."))
	var/obj/item/reagent_containers/cooking/container/container = items
	var/turf/T = get_turf(src)
	container.forceMove(T)
	user.put_in_hands(container)
	items = null
	update_icon()

/obj/machinery/cooking/deepfrier/attack_hand(mob/user as mob, params)
	if(items != null)
		remove_basket(user)
	else
		update_icon()

/obj/machinery/cooking/deepfrier/ShiftClick(var/mob/user, params)
	if(!ishuman(user) && !isrobot(user))
		return
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return
	var/choice = input(user, "Set temperature or timer.", "Deep fryer", "Cancel") in list("Set temperature", "Set timer", "Cancel")
	if(choice == "Set temperature")
		handle_temperature(user)
	else if(choice == "Set timer")
		handle_timer(user)

/obj/machinery/cooking/deepfrier/CtrlClick(var/mob/user, params)
	if(!ishuman(user) && !isrobot(user))
		return
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return
	handle_temperature(user)

/obj/machinery/cooking/deepfrier/CtrlShiftClick(var/mob/user, params)
	if(!ishuman(user) && !isrobot(user))
		return
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return
	handle_switch(user)


/obj/machinery/cooking/deepfrier/proc/handle_temperature(var/mob/user)
	var/old_temp = temperature
	var/choice = input(user,"Select oil temperature.","Select Temperature",old_temp) in list("High","Medium","Low","Cancel")
	if(choice && choice != "Cancel" && choice != old_temp)
		temperature = choice
		if(switches == 1)
			handle_cooking(user)
			cooking_timestamp = world.time
			timerstamp = world.time
		if(timer != 0)
			timer_act(user)
	update_icon()

/obj/machinery/cooking/deepfrier/proc/handle_timer(var/mob/user)
	var/old_time = timer ? round((timer/(1 SECONDS)), 1 SECONDS) : 1
	timer = (input(user, "Enter a timer (in seconds)","Set Timer", old_time) as num) SECONDS
	if(timer != 0 && switches == 1)
		timer_act(user)
	update_icon()

/obj/machinery/cooking/deepfrier/proc/timer_act(var/mob/user)
	timerstamp = round(world.time)
	var/old_timerstamp = timerstamp
	spawn(timer)
		if(old_timerstamp == timerstamp)
			playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)
			handle_cooking(user, TRUE)
			switches = 0
			timerstamp = world.time
			cooking_timestamp = world.time
			update_icon()
	update_icon()

/obj/machinery/cooking/deepfrier/proc/handle_switch(user)
	if(switches == 1)
		playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)
		handle_cooking(user)
		switches = 0
		timerstamp = world.time
		cooking_timestamp = world.time
	else
		playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)
		switches = 1
		cooking_timestamp = world.time
		cook_checkin()
		if(timer != 0)
			timer_act(user)
	update_icon()


/obj/machinery/cooking/deepfrier/proc/handle_cooking(var/mob/user, set_timer=FALSE)

	if(!(items && istype(items, /obj/item/reagent_containers/cooking/container)))
		return

	var/obj/item/reagent_containers/cooking/container/container = items
	if(container.appliancetype != DF_BASKET)
		return
	if(set_timer)
		reference_time = timer
	else
		reference_time = world.time - cooking_timestamp

	container.deepfry_data[temperature] = reference_time

	if(user && user.Adjacent(src))
		container.process_item(src, user, lower_quality_on_fail=0, send_message=TRUE)
	else
		container.process_item(src, user, lower_quality_on_fail=0)


/obj/machinery/cooking/deepfrier/update_icon()
	cut_overlays()
	icon_state = "deep_fryer"
	if(items)
		var/obj/item/reagent_containers/cooking/container/C = items
		var/has_contents = (C.contents?.len || (C.reagents && C.reagents.total_volume > 0))
		add_overlay(image(src.icon, has_contents ? "basket_full" : "basket", layer=ABOVE_OBJ_LAYER))

/obj/machinery/cooking/deepfrier/verb/toggle_fryer()
	set src in view(1)
	set name = "Deep fryer - Toggle"
	set category = "Object"
	set desc = "Turn on the deep fryer"
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_switch(usr)

/obj/machinery/cooking/deepfrier/verb/change_temperature()
	set src in view(1)
	set name = "Deep fryer - Set temp"
	set category = "Object"
	set desc = "Set oil temperature."
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_temperature(usr)

/obj/machinery/cooking/deepfrier/verb/change_timer()
	set src in view(1)
	set name = "Deep fryer - Set timer"
	set category = "Object"
	set desc = "Set a timer for the deep fryer."
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_timer(usr)

/obj/machinery/cooking/deepfrier/verb/remove_basket_verb()
	set src in view(1)
	set name = "Deep fryer - Remove basket"
	set category = "Object"
	set desc = "Take the basket out of the deep fryer."
	if(!ishuman(usr) && !isrobot(usr))
		return
	if(items)
		remove_basket(usr)
	else
		to_chat(usr, SPAN_NOTICE("There is no basket in the deep fryer."))

