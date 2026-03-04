/obj/structure/anomaly_container
	name = "anomaly container"
	desc = "Used to safely contain and move anomalies."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anomaly_container"
	density = 1

	var/atom/movable/contained

	/// Item types that count as anomaly-related and can be stored in the container (in addition to artifacts).
	var/static/list/allowed_anomaly_items = list(
		/obj/item/archaeological_find,
		/obj/item/oddity,
		/obj/item/stack/ore/strangerock
	)

/obj/structure/anomaly_container/Initialize()
	. = ..()

	var/obj/machinery/artifact/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/anomaly_container/examine(mob/user)
	. = ..()
	if(contained)
		to_chat(user, SPAN_NOTICE("There is \a [contained] contained within."))
		to_chat(user, SPAN_NOTICE("Click on the container to release the contained anomaly."))
	else
		to_chat(user, SPAN_NOTICE("The container is empty."))
		to_chat(user, SPAN_NOTICE("Drag an anomaly or xenoarchaeological find onto this container to contain it, or use one in hand on it."))

/obj/structure/anomaly_container/attack_hand(var/mob/user)
	if(contained)
		release(user)
	else
		to_chat(user, SPAN_WARNING("The container is empty."))

/obj/structure/anomaly_container/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/anomaly_container/proc/can_contain(var/atom/movable/thing)
	if(istype(thing, /obj/machinery/artifact))
		return TRUE
	if(istype(thing, /obj/item))
		for(var/path in allowed_anomaly_items)
			if(istype(thing, path))
				return TRUE
	return FALSE

/obj/structure/anomaly_container/attackby(obj/item/W, mob/user)
	if(contained)
		to_chat(user, SPAN_WARNING("The container already contains \a [contained]."))
		return
	if(can_contain(W))
		if(!user.unEquip(W))
			return
		contain(W, user)
	else
		to_chat(user, SPAN_WARNING("You can only put artifacts or xenoarchaeological finds in this container."))

/obj/structure/anomaly_container/MouseDrop(var/atom/movable/dropped)
	if(dropped == src || !usr.Adjacent(src))
		return
	if(contained)
		to_chat(usr, SPAN_WARNING("The container already contains \a [contained]."))
		return
	if(can_contain(dropped))
		if(ismob(dropped.loc))
			var/mob/M = dropped.loc
			if(!M.unEquip(dropped))
				return
		else if(!dropped.Adjacent(usr))
			return
		contain(dropped, usr)

/obj/structure/anomaly_container/proc/contain(var/atom/movable/thing, var/mob/user)
	if(contained)
		if(user)
			to_chat(user, SPAN_WARNING("The container already contains \a [contained]."))
		return FALSE

	if(!can_contain(thing))
		if(user)
			to_chat(user, SPAN_WARNING("You can only contain artifacts or xenoarchaeological finds in this container."))
		return FALSE

	contained = thing
	thing.forceMove(src)

	// Stop the artifact from processing while contained
	if(istype(thing, /obj/machinery/artifact) && (thing in SSobj.processing))
		STOP_PROCESSING(SSobj, thing)

	update_icon()

	if(user)
		to_chat(user, SPAN_NOTICE("You successfully contain \the [thing] in \the [src]."))
		user.visible_message(SPAN_NOTICE("[user] places \the [thing] into \the [src]."))

	desc = "Used to safely contain and move anomalies. \The [contained] is safely contained within."
	return TRUE

/obj/structure/anomaly_container/proc/release(var/mob/user)
	if(!contained)
		if(user)
			to_chat(user, SPAN_WARNING("The container is empty."))
		return FALSE

	var/atom/movable/releasing = contained
	releasing.forceMove(get_turf(src))

	// Restart artifact processing only for machinery artifacts
	if(istype(releasing, /obj/machinery/artifact) && !(releasing in SSobj.processing))
		START_PROCESSING(SSobj, releasing)

	contained = null
	update_icon()

	if(user)
		to_chat(user, SPAN_NOTICE("You release \the [releasing] from \the [src]."))
		user.visible_message(SPAN_NOTICE("[user] releases \the [releasing] from \the [src]."))

	desc = initial(desc)
	return TRUE

/obj/structure/anomaly_container/update_icon()
	if(contained)
		underlays.Cut()
		underlays += image(contained)
		icon_state = "anomaly_container_full"
	else
		underlays.Cut()
		icon_state = "anomaly_container"

/obj/machinery/artifact/MouseDrop(var/obj/structure/anomaly_container/over_object)
	if(!istype(over_object))
		return

	if(!Adjacent(over_object))
		to_chat(usr, SPAN_WARNING("You need to be closer to the container."))
		return

	if(!CanMouseDrop(over_object, usr))
		return

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this."))
		return

	var/mob/living/carbon/human/user = usr

	if(user.incapacitated())
		to_chat(user, SPAN_WARNING("You can't do this while incapacitated."))
		return

	over_object.contain(src, user)
