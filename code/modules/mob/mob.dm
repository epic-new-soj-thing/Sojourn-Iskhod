/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	STOP_PROCESSING(SSmobs, src)
	GLOB.dead_mob_list -= src
	GLOB.living_mob_list -= src
	GLOB.mob_list -= src
	unset_machine()
	QDEL_NULL(hud_used)
	for(var/alert in alerts)
		clear_alert(alert)
	languages = null
	move_intent = null
	QDEL_NULL(weak_reference)
	QDEL_NULL(parallax)
	transform = null
	QDEL_NULL(transform)
	QDEL_NULL(shadow)
	if(client)
		for(var/atom/movable/AM in client.screen)
			qdel(AM)
		client.screen = list()

	for (var/obj/machinery/camera/camera in tracking_cameras)
		camera.lostTarget(src)
	tracking_cameras.Cut()

	ghostize()

	LAssailant_weakref = null

	for (var/datum/movement_handler/mob/handler in movement_handlers)
		handler.host = null
		handler.mob = null

	movement_handlers.Cut()

	if (spawned_from)
		spawned_from.currently_spawned[type] -= src
		spawned_from = null

	return ..()

/mob/get_fall_damage(var/turf/from, var/turf/dest)
	return 0

/mob/fall_impact(var/turf/from, var/turf/dest)
	return

/mob/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	return

/mob/Initialize()
	START_PROCESSING(SSmobs, src)
	if(stat == DEAD)
		GLOB.dead_mob_list += src
	else
		GLOB.living_mob_list += src
	GLOB.mob_list += src
	move_intent = decls_repository.get_decl(move_intent)
	. = ..()

/**
 * Generate the tag for this mob
 *
 * This is simply "mob_"+ a global incrementing counter that goes up for every mob
 */
/mob/GenerateTag()
	tag = "mob_[next_mob_id++]"

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client)	return

	if (type)
		if(type & 1 && (sdisabilities & BLIND || blinded || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if (type & 2 && (sdisabilities & DEAF || ear_deaf))//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1 && sdisabilities & BLIND))
					return
	// Added voice muffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src, "<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src, msg)
	return

// Show a message to all mobs and objects in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
// target (optional) is the target that will ALWAYS be given the message

/mob/visible_message(var/message, var/self_message, var/blind_message, var/range = world.view, var/mob/target, var/message_target = TRUE)
	var/list/messageturfs = list()//List of turfs we broadcast to.
	var/list/messagemobs = list()//List of living mobs nearby who can hear it, and distant ghosts who've chosen to hear it
	for (var/turf in view(range, get_turf(src)))

		messageturfs += turf

	for(var/A in GLOB.player_list)
		var/mob/M = A
		if (QDELETED(M))
			GLOB.player_list -= M
			continue
		if (!M.client || istype(M, /mob/new_player))
			continue
		if((get_turf(M) in messageturfs) || ((target && M == target) && (message_target)))
			messagemobs += M

	for(var/A in messagemobs)
		var/mob/M = A
		if(self_message && M==src)
			M.show_message(self_message, 1, blind_message, 2)
		else if(M.see_invisible < invisibility)  // Cannot view the invisible, but you can hear it.
			if(blind_message)
				M.show_message(blind_message, 2)
		else
			M.show_message(message, 1, blind_message, 2)


// Returns an amount of power drawn from the object (-1 if it's not viable).
// If drain_check is set it will not actually drain power, just return a value.
// If surge is set, it will destroy/damage the recipient and not return any power.
// Not sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge, var/amount = 0)
	return -1


/mob/proc/findname(msg)
	for(var/mob/M in SSmobs.mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

// Show a message to all mobs and objects in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/mob/audible_message(var/message, var/deaf_message, var/hearing_distance, var/self_message)

	var/range = world.view
	if(hearing_distance)
		range = hearing_distance

	var/turf/T = get_turf(src)

	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, range, mobs, objs)


	for(var/m in mobs)
		var/mob/M = m
		if(self_message && M==src)
			M.show_message(self_message,2,deaf_message,1)
			continue

		M.show_message(message,2,deaf_message,1)

	for(var/o in objs)
		var/obj/O = o
		O.show_message(message,2,deaf_message,1)

/mob/proc/movement_delay()
	. = 0

	if ((drowsyness > 0) && !MOVING_DELIBERATELY(src))
		. += 6
	if(lying) //Crawling, it's slower
		. += 14 + (weakened)

	var/turf/T = get_turf(src)
	if(T)
		if(istype(T, /turf/simulated/floor))
			var/turf/simulated/floor/TF = T
			if(TF.flooring)
				. += TF.flooring.tally_addition_decl
		. += T.tally_addition

	. += move_intent?.move_delay

	if(client)
		if(client.true_dir == NORTHEAST || client.true_dir == NORTHWEST || client.true_dir == SOUTHEAST || client.true_dir == SOUTHWEST)
			. += MOVE_DELAY_DIAGONAL_ADDER //If we are moving in a cornerdirs then we slow down a bit to not cheat movement

/mob/proc/Life()
	LEGACY_SEND_SIGNAL(src, COMSIG_MOB_LIFE)
//	if(organStructure)
//		organStructure.ProcessOrgans()
	return

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_STUNNED) && stunned)
		return 1

	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (weakened || resting || pinned.len))
		return 1

	if ((incapacitation_flags & INCAPACITATION_KNOCKOUT) && (stat || paralysis || sleeping || (status_flags & FAKEDEATH)))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc

	if(hud_used)
		hud_used.updatePlaneMasters(src)

	return


/mob/proc/show_inv(mob/user as mob)
	return

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/examinify as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(run_examinate), examinify))

/mob/proc/run_examinate(atom/examinify)

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return

	if(!istype(examinify, /obj/screen))
		face_atom(examinify)
	var/obj/item/device/lighting/toggleable/flashlight/FL = locate() in src
	if (FL?.on && stat != DEAD && !incapacitated())
		FL.afterattack(examinify, src)
	examinify.examine(src)

/**
 * Point at an atom
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/pointed()
 *
 * note: ghosts can point, this is intended
 *
 * visible_message will handle invisibility properly
 *
 * overridden here and in /mob/dead/observer for different point span classes and sanity checks
 */
/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(istype(A, /obj/effect/decal/point))
		return FALSE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(_pointed), A))

	usr.visible_message("<b>[src]</b> points to [A]")

/// possibly delayed verb that finishes the pointing process starting in [/mob/verb/pointed()].
/// either called immediately or in the tick after pointed() was called, as per the [DEFAULT_QUEUE_OR_CALL_VERB()] macro
/mob/proc/_pointed(atom/pointing_at)
	if(client && !(pointing_at in view(client.view, src)))
		return FALSE

	if(!isturf(loc))
		return FALSE

	var/turf/tile = get_turf(pointing_at)
	if (!tile)
		return FALSE

	var/turf/our_tile = get_turf(src)

	var/obj/visual = new /obj/effect/decal/point(our_tile)
	visual.invisibility = invisibility

	animate(visual, pixel_x = (tile.x - our_tile.x) * world.icon_size + pointing_at.pixel_x, pixel_y = (tile.y - our_tile.y) * world.icon_size + pointing_at.pixel_y, time = 1.7, easing = EASE_OUT)
	QDEL_IN(visual, 2 SECONDS)
	return TRUE
/mob/verb/haul_all_objects(turf/T as turf in oview(1))
	set name = "Haul"
	set category = "Object"


	if(!src || !isturf(src.loc) || !(T in oview(1, src.loc)))
		return 0

	if(ismouse(usr))
		return
	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return

	T.UnloadSlide(get_dir(T, src), src, 1)

/mob/proc/haul_all_objs_proc(turf/T)
	if(!src || !isturf(src.loc) || !(T in oview(1, src.loc)))
		return 0
	if(ismouse(src))
		return
	if(!src || !isturf(src.loc))
		return
	if(src.stat || src.restrained())
		return
	T.UnloadSlide(get_dir(T, src), src, 1)


/mob/proc/ret_grab(obj/effect/list_container/mobl/L as obj, flag)
	if(!istype(l_hand, /obj/item/grab) && !istype(r_hand, /obj/item/grab))
		if (!L)
			return null
		else
			return L.container
	else
		if(!L)
			L = new /obj/effect/list_container/mobl(null)
			L.container += src
			L.master = src
		if(istype(l_hand, /obj/item/grab))
			var/obj/item/grab/G = l_hand
			if (!L.container.Find(G.affecting))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if(istype(r_hand, /obj/item/grab))
			var/obj/item/grab/G = r_hand
			if (!L.container.Find(G.affecting))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if(!flag)
			if (L.master == src)
				var/list/temp = list()
				temp += L.container
				//L = null
				qdel(L)
				return temp
			else
				return L.container
	return

/**
 * Verb to activate the object in your held hand
 *
 * Calls attack self on the item and updates the inventory hud for hands
 */
/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(execute_mode)))

///proc version to finish /mob/verb/mode() execution. used in case the proc needs to be queued for the tick after its first called
/mob/proc/execute_mode()
	if(incapacitated())
		return

	var/obj/item/W = get_active_hand()
	if (W)
		W.attack_self(src)

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if (popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)

	if(msg != null)
		flavor_text = msg

/mob/proc/print_flavor_text()
	. = ""
	if (flavor_text && flavor_text != "")
		var/msg = trim(replacetext(flavor_text, "\n", " "))
		if(!msg) . += ""
		else if(length(msg) <= 40)
			. += "<font color='blue'>[msg]</font>"
		else
			. += "<font color='blue'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a></font>"
	if (ooc_text && ooc_text != "")
		. += "<br><a href='byond://?src=\ref[src];ooc_text=1'>\[OOC Notes\]</a>"

/*
/mob/verb/help()
	set name = "Help"
	src << browse('html/help.html', "window=help")
	return
*/

/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || isnewplayer(src))
		to_chat(usr, "\blue You must be observing to use this!")
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/singularity))
			var/name = "Singularity"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/machinery/bot))
			var/name = "BOT: [O.name]"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O


	for(var/mob/M in sortNames(SSmobs.mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = input("Please, select a player!", ok, null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		//if(src in view(usr)) //Flavor at any range
		var/dat = {"
			<html><head><title>[name]</title></head>
			<body><tt>[replacetext(flavor_text, "\n", "<br>")]</tt></body>
			</html>
		"}
		usr << browse(dat, "window=[name]_flavor;size=500x200")
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
	if(href_list["ooc_text"])
		var/dat = {"
				<html><head><title>[name]</title></head>
				<body><tt>[replacetext(ooc_text, "\n", "<br>")]</tt></body>
				</html>
			"}
		usr << browse(dat, "window=[name]_ooc;size=500x200")
		onclose(usr, "[name]")
//	..()
	return


/mob/proc/pull_damage()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.health - H.halloss <= HEALTH_THRESHOLD_SOFTCRIT)
			for(var/name in H.organs_by_name)
				var/obj/item/organ/external/e = H.organs_by_name[name]
				if(e && H.lying)
					if(((e.status & ORGAN_BROKEN && !(e.status & ORGAN_SPLINTED)) || e.status & ORGAN_BLEEDING) && (H.getBruteLoss() + H.getFireLoss() >= 100))
						return 1
		else
			return 0

/mob/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(isAI(M)) return
	show_inv(usr)


/mob/verb/stop_pulling()
	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby = null
		pulling = null
		if(HUDneed.Find("pull"))
			var/obj/screen/HUDthrow/HUD = HUDneed["pull"]
			HUD.update_icon()

/mob/proc/start_pulling(var/atom/movable/AM)

	if ( !AM || !usr || src==AM || !isturf(src.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		to_chat(src, "<span class='warning'>It won't budge!</span>")
		return

	var/mob/M = AM
	if(ismob(AM))

		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size < M.mob_size) && (can_pull_mobs != MOB_PULL_LARGER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size == M.mob_size) && (can_pull_mobs == MOB_PULL_SMALLER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		// If your size is larger than theirs and you have some
		// kind of mob pull value AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(!iscarbon(src))
			M.LAssailant_weakref = null
		else
			M.LAssailant_weakref = WEAKREF(usr)

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	/*if(pullin)
		pullin.icon_state = "pull1"*/

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			to_chat(src, "\red <B>Pulling \the [H] in their current condition would probably be a bad idea.</B>")

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Robot" || mind.assigned_role == "AI"))
		return 1
	return issilicon(src)

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src, message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/// Adds this list to the output to the stat browser
/mob/proc/get_status_tab_items()
	. = list()

// facing verbs
/mob/proc/canface()
	if(!canmove)						return 0
	if(stat)							return 0
	if(anchored)						return 0
	if(transforming)						return 0
	return 1

// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_DEFAULT & (~INCAPACITATION_RESTRAINED))


//Updates lying and icons
/*
Note from Nanako: 2019-02-01
TODO: Bay Movement:
All Canmove setting in this proc is temporary. This var should not be set from here, but from movement controllers
*/
/mob/proc/update_lying_buckled_and_verb_status()

	if(!resting && cannot_stand() && can_stand_overridden())
		lying = FALSE
		canmove = TRUE //TODO: Remove this
	else if(buckled)
		anchored = TRUE
		if(istype(buckled))
			if(buckled.buckle_lying == -1)
				lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			else
				lying = buckled.buckle_lying
			if(buckled.buckle_movable)
				anchored = FALSE
		canmove = FALSE //TODO: Remove this
	else
		lying = incapacitated(INCAPACITATION_KNOCKDOWN)
		canmove = FALSE //TODO: Remove this

	if(lying)
		if(l_hand)
			unEquip(l_hand)
		if(r_hand)
			unEquip(r_hand)
		if (!is_dead(src)) //to prevent dead mobs from always being set to dense. not sure if this is going to have consequences, but it hopefully shouldnt?
			set_density(TRUE)
	else
		canmove = TRUE
		set_density(initial(density))
	reset_layer()

	for(var/obj/item/grab/G in grabbed_by)
		if(G.force_stand())
			lying = TRUE

	//Temporarily moved here from the various life() procs
	//I'm fixing stuff incrementally so this will likely find a better home.
	//It just makes sense for now. ~Carn
	if( update_icon )	//forces a full overlay update
		update_icon = FALSE
		regenerate_icons()
	else if( lying != lying_prev )
		update_icons()

/mob/proc/reset_layer()
	if(lying)
		set_plane(LYING_MOB_PLANE)
		layer = LYING_MOB_LAYER
	else
		reset_plane_and_layer()

/mob/facedir(var/ndir)
	if(!canface() || client.moving)
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	set_move_cooldown(movement_delay())
	return 1


/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))


//This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_lying_buckled_and_verb_status()
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		update_lying_buckled_and_verb_status()
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_lying_buckled_and_verb_status()
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
		return TRUE
	return

/mob/living/Paralyse(amount)
	var/zero_before = FALSE
	if (!paralysis)
		zero_before = TRUE
	.=..()
	if (. && zero_before)
		//These three procs instantly create the blinding/sleep overlay
		//We only call them if the mob has just become paralysed, to prevent an infinite loop
		handle_regular_status_updates() //This checks paralysis and sets stat
		handle_disabilities() //This checks stat and sets eye_blind
		handle_regular_hud_updates() //This checks eye_blind and adds or removes the hud overlay

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return

/mob/proc/Drowsyness(amount)
	drowsyness = max(max(drowsyness,amount),0)
	return

/mob/proc/SetDrowsyness(amount)
	drowsyness = max(amount,0)
	return

/mob/proc/AdjustDrowsyness(amount)
	drowsyness = max(drowsyness + amount,0)
	return

/mob/proc/get_species()
	return ""

/mob/proc/flash_weak_pain()
	return

/mob/living/flash_weak_pain()
//	flick("weak_pain", flash["pain"])
	if(HUDtech.Find("pain"))
		flick("weak_pain", HUDtech["pain"])


/mob/proc/get_visible_implants()
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.can_click())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants()
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>")

	if(!do_mob(U, S, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body.</b></span>","<span class='warning'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body.</b></span>")
	valid_objects = get_visible_implants()
	if(valid_objects.len == 1) //Yanking out last object - removing verb.
		remove_verb(src, /mob/proc/yank_out_object)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/affected

		for(var/obj/item/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		affected.embedded -= selection
		selection.on_embed_removal(src)
		if(!(H.species && ((H.species.flags & NO_PAIN) || (PAIN_LESS in H.mutations))))
			H.shock_stage+=20
		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")

		if (ishuman(U))
			var/mob/living/carbon/human/human_user = U
			human_user.bloody_hands(H)

	else
		embedded -= selection
		selection.on_embed_removal(src)
		if(issilicon(src))
			var/mob/living/silicon/robot/R = src
			R.adjustBruteLoss(5)
			R.adjustFireLoss(10)

	selection.forceMove(get_turf(src))

	if(!(U.l_hand && U.r_hand))
		U.put_in_hands(selection)

	for(var/obj/item/O in pinned)
		if(O == selection)
			pinned -= O
		if(!pinned.len)
			anchored = 0
	return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_slowdown()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		weakened = max(weakened-1,0)	//before you get mad Rockdtben: I done this so update_lying_buckled_and_verb_status isn't called multiple times
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed() // Currently only used by simple_animal.dm, treated as a special case in other mobs
	if(paralysis)
		AdjustParalysis(-1)
	return paralysis

/mob/living/proc/handle_slowdown()
	if(slowdown)
		slowdown = max(slowdown-1, 0)
	return slowdown

//Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple/borer))
			return I

	return FALSE

/mob/proc/updateicon()
	return

/mob/verb/face_direction()

	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/*mob/verb/check_playtime()
	set name = "Check Playtime"
	set category = "IC"
	set src = usr
	for(var/department in GLOB.all_departments)
		todofixmeplease
		if(src.client.prefs.playtime[departmentplaytime])
			to_chat(src, "You have spent [src.client.prefs.playtime[departmentplaytime]] minutes playing in [departmentplaytime].")
*/

/mob/verb/browse_mine_stats()
	set name		= "Show stats and perks"
	set desc		= "Browse your character stats and perks."
	set category	= "IC"
	set src			= usr

	if(SSticker.current_state == GAME_STATE_PREGAME)
		return

	stats?.ui_interact(usr)

/mob/proc/set_face_dir(var/newdir)
	if(!isnull(facing_dir) && newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		set_dir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir()
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))

/mob/verb/change_move_intent()
	set name = "Change moving intent"
	set category = "IC"
	set src = usr

	if(HUDneed["move intent"])
		HUDneed["move intent"]:Click()  // Yep , this is all.

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	/*for (var/obj/screen/HUDthrow/HUD in src.client.screen.)
		if(HUD.name == "throw") //in case we don't have the HUD and we use the hotkey
			//src.throw_icon.icon_state = "act_throw_off"
			HUD.toggle_throw_mode()
			break*/

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	/*if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"*/
	/*for (var/obj/screen/HUDthrow/HUD in src.client.screen.)
		if(HUD.name == "throw") //in case we don't have the HUD and we use the hotkey
			//src.throw_icon.icon_state = "act_throw_off"
			HUD.toggle_throw_mode()
			break*/

/mob/proc/swap_hand()
	return

/mob/proc/check_CH(CH_name as text, var/CH_type, var/second_arg = null)
	if(!src.client.CH || !istype(src.client.CH, CH_type))//(src.client.CH.handler_name != CH_name))
		src.client.CH = new CH_type(client, second_arg)
		to_chat(src, SPAN_WARNING("You prepare [CH_name]."))
	else
		kill_CH()
	return

/mob/proc/kill_CH()
	if (src.client.CH)
		to_chat(src, SPAN_NOTICE ("You unprepare [src.client.CH.handler_name]."))
		qdel(src.client.CH)


/mob/living/proc/Released()
	//This is called when the mob is let out of a holder
	//Override for mob-specific functionality
	return

/mob/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/proc/get_face_name()
	return name

/client/proc/check_has_body_select()
	return mob && mob.HUDneed && mob.HUDneed["damage zone"]

/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = TRUE
	toggle_zone_sel(list(BP_HEAD,BP_EYES,BP_MOUTH))

/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = TRUE
	toggle_zone_sel(list(BP_R_ARM))

/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = TRUE
	toggle_zone_sel(list(BP_L_ARM))

/client/verb/body_chest()
	set name = "body-chest"
	set hidden = TRUE
	toggle_zone_sel(list(BP_CHEST))

/client/verb/body_groin()
	set name = "body-groin"
	set hidden = TRUE
	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = TRUE
	toggle_zone_sel(list(BP_R_LEG))

/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = TRUE
	toggle_zone_sel(list(BP_L_LEG))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/obj/screen/zone_sel/selector = mob.HUDneed["damage zone"]
	selector.set_selected_zone(next_list_item(mob.targeted_organ,zones))
/mob/proc/set_stat(var/new_stat)
	. = stat != new_stat
	stat = new_stat

/client/verb/showplaytime()
	set name = "Show All Playtime"
	set category = "IC"
	var/timeinjob = 0
	log_debug("[src.ckey] just looked at his playtime.")
	for(var/job in GLOB.joblist)
		var/datum/job/J = GLOB.joblist[job]
		timeinjob = SSjob.JobTimeCheck(usr.ckey, "[J.type]")
		if(timeinjob > 0)
			to_chat(src, "You have spent [timeinjob] minutes playing as [J.title].")

/mob/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0


//SoJ

/mob/proc/give_health_via_stats()
	if(maxHealth && stats)
		health += src.stats.getStat(STAT_ANA)
		maxHealth += src.stats.getStat(STAT_ANA)
		if(maxHealth > 300) //soft cap to keep players from becoming killable only by organ damage or pain.
			health = 300
			maxHealth = 300
