// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/modules/turbolift/turbolift.dmi'
	anchored = 1
	density = 0


	var/datum/turbolift/lift

/obj/structure/lift/set_dir(var/newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(var/mob/user)
	if(!istype(user, /mob/living/silicon))
		playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='danger'>\The [user] hammers on the lift button!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] presses the lift button.</span>")


/obj/structure/lift/New(var/newloc, var/datum/turbolift/_lift)
	lift = _lift
	return ..(newloc)

/obj/structure/lift/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_generic(mob/user, damage, attack_message, damagetype = BRUTE, attack_flag = ARMOR_MELEE, sharp = FALSE, edge = FALSE)
	return attack_hand(user)

/obj/structure/lift/attack_hand(var/mob/user)
	return interact(user)

/obj/structure/lift/interact(var/mob/user)
	if(!lift?.is_functional())
		return 0
	return 1
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	req_access = list(access_eva)
	var/datum/turbolift_stop/floor

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

// Hit it with a PDA or ID to enable priority call mode
/obj/structure/lift/button/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/id = W.GetIdCard()
	if(istype(id))
		if(!check_access(id))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		lift.priority_mode()
		if(floor == lift.current_stop)
			lift.open_doors()
		else
			lift.queue_move_to(floor)
		return
	. = ..()

/obj/structure/lift/button/interact(var/mob/user)
	if(!..())
		return
	if(lift.fire_mode || lift.priority_mode)
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
		return
	light_up()
	pressed(user)
	if(floor == lift.current_stop)
		lift.open_doors()
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/update_icon()
	if(lift.fire_mode)
		icon_state = "button_fire"
	else if(lift.priority_mode)
		icon_state = "button_pri"
	else if(light_up)
		icon_state = "button_lit"
	else
		icon_state = initial(icon_state)

// End button.

// Panel. Lists stops (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	desc = "The brains of an elevator. Use this to get where you want to go."
	icon_state = "panel"
	req_access = list(access_eva)

// Hit it with a PDA or ID to enable priority call mode
/obj/structure/lift/panel/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/id = W.GetIdCard()
	if(istype(id))
		if(!check_access(id))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		lift.update_fire_mode(!lift.fire_mode)
		if(lift.fire_mode)
			audible_message("<span class='danger'>Firefighter Mode Activated.  Door safeties disabled.  Manual control engaged.</span>")
			playsound(src.loc, 'sound/machines/airalarm.ogg', 25, 0, 4)
		else
			audible_message("<span class='warning'>Firefighter Mode Deactivated. Door safeties enabled.  Automatic control engaged.</span>")
		return
	. = ..()

/obj/structure/lift/panel/attack_ghost(var/mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(var/mob/user)
	if(!..())
		return

	ui_interact(user)

/obj/structure/lift/panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Turbolift", name)
		ui.open()

/obj/structure/lift/panel/ui_data(mob/user)
	var/list/data = list()

	data["doors_open"] = lift.doors_are_open()
	data["fire_mode"] = lift.fire_mode

	var/list/floors = list()
	for(var/i in lift.stops.len to 1 step -1)
		var/datum/turbolift_stop/floor = lift.stops[i]
		if(!floor.label)
			continue
		floors += list(list(
			"id" = i,
			"ref" = "[REF(floor)]",
			"queued" = (floor in lift.queued_stops),
			"target" = (lift.target_stop == floor),
			"current" = (lift.current_stop == floor),
			"label" = floor.label,
			"name" = floor.name,
		))
	data["floors"] = floors

	return data

/obj/structure/lift/panel/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("move_to_floor")
			. = TRUE
			lift.queue_move_to(locate(params["ref"]))
		if("toggle_doors")
			. = TRUE
			if(lift.doors_are_open())
				lift.close_doors()
			else
				lift.open_doors()
		if("emergency_stop")
			. = TRUE
			lift.emergency_stop()

	if(.)
		pressed(usr)

/obj/structure/lift/panel/update_icon()
	if(lift.fire_mode)
		icon_state = "panel_fire"
	else
		icon_state = initial(icon_state)

// End panel.
