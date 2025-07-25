/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	item_flags = DRAG_AND_DROP_UNEQUIP
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/psi_blocking = 0							// Sets the item's level of psionic protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted						// Only these species can wear this kit.
	var/gunshot_residue								// Used by forensics.
	var/initial_name = "clothing"					// For coloring
	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/equip_delay = 0 //If set to a nonzero value, the item will require that much time to wear and remove
	stiffness = 0 // Recoil caused by moving, defined in obj/item
	obscuration = 0 // Similar to tint, but decreases firearm accuracy instead via giving minimum extra offset, defined in obj/item

	//Used for hardsuits. If false, this piece cannot be retracted while the core module is engaged
	var/retract_while_active = TRUE
	blacklist_upgrades = list(
							/obj/item/tool_upgrade/augment = TRUE,
							/obj/item/tool_upgrade/refinement = TRUE,
							/obj/item/gun_upgrade = TRUE, // Goodbye tacticool clothing
							/obj/item/tool_upgrade/artwork_tool_mod = TRUE)

/obj/item/clothing/Initialize(mapload, ...)
	. = ..()

	var/list/init_accessories = accessories
	accessories = list()
	for (var/path in init_accessories)
		attach_accessory(null, new path (src))

	var/obj/screen/item_action/action = new /obj/screen/item_action/top_bar/clothing_info
	action.owner = src
	if(!hud_actions)
		hud_actions = list()
	hud_actions += action

	if(matter)
		return

	else if(chameleon_type)
		matter = list(MATERIAL_PLASTIC = 2 * w_class)
		origin_tech = list(TECH_ILLEGAL = 3)
	else
		matter = list(MATERIAL_BIOMATTER = 5 * w_class)

/obj/item/clothing/Destroy()
	for(var/obj/item/clothing/accessory/A in accessories)
		A.on_removed()
		accessories -= A
		update_wear_icon()
	accessories = null
	return ..()

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	. = ..()
	gunshot_residue = null


//Delayed equipping
/obj/item/clothing/pre_equip(var/mob/user, var/slot)
	..(user, slot)
	if (equip_delay > 0 && !user.stats.getPerk(PERK_SECOND_SKIN))
		//If its currently worn, we must be taking it off
		if (is_worn())
			user.visible_message(
				SPAN_NOTICE("[user] starts taking off \the [src]..."),
				SPAN_NOTICE("You start taking off \the [src]...")
			)
			if(!do_after(user,equip_delay,src))
				return TRUE //A nonzero return value will cause the equipping operation to fail

		else if (is_held() && !(slot in unworn_slots))
			user.visible_message(
				SPAN_NOTICE("[user] starts putting on \the [src]..."),
				SPAN_NOTICE("You start putting on \the [src]...")
			)
			if(!do_after(user,equip_delay,src))
				return TRUE //A nonzero return value will cause the equipping operation to fail

// To catch MouseDrop on clothing
/obj/item/clothing/MouseDrop(over_object)
	if(!(item_flags & DRAG_AND_DROP_UNEQUIP))
		return ..()
	if(!pre_equip(usr, over_object))
		..()

/proc/body_part_coverage_to_string(var/body_parts)
	var/list/body_partsL = list()
	if(body_parts & HEAD)
		body_partsL.Add("head")
	if(body_parts & FACE)
		body_partsL.Add("face")
	if(body_parts & EYES)
		body_partsL.Add("eyes")
	if(body_parts & EARS)
		body_partsL.Add("ears")
	if(body_parts & UPPER_TORSO)
		body_partsL.Add("upper torso")
	if(body_parts & LOWER_TORSO)
		body_partsL.Add("lower torso")
	if(body_parts & LEGS)
		body_partsL.Add("legs")
	else
		if(body_parts & LEG_LEFT)
			body_partsL.Add("left leg")
		if(body_parts & LEG_RIGHT)
			body_partsL.Add("right leg")
	if(body_parts & ARMS)
		body_partsL.Add("arms")
	else
		if(body_parts & ARM_LEFT)
			body_partsL.Add("left arm")
		if(body_parts & ARM_RIGHT)
			body_partsL.Add("right arm")

	return english_list(body_partsL)

/obj/item/clothing/ui_action_click(mob/living/user, action_name)
	if(action_name == "Clothing information")
		ui_interact(user)
		return TRUE
	return ..()

/obj/item/clothing/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ItemStats", name)
		ui.open()

/obj/item/clothing/ui_data(mob/user)
	var/list/data = list()

	var/list/stats = list()

	var/list/armor_stats = list()

	var/list/armorlist = armor.getList()
	if(armorlist.len)
		for(var/i in armorlist)
			if(armorlist[i])
				armor_stats += list(list(
					"type" = "ProgressBar",
					"name" = capitalize(i) + " armor",
					"value" = armorlist[i],
					"max" = 25,
					"color" = armorlist[i] > 25 ? (armorlist[i] > 50 ? "good" : "average") : "bad",
					"unit" = ""
				))

	stats["Armor Stats"] = armor_stats

	var/list/equipment_stats = list()

	equipment_stats += list(list("name" = "Slowdown", "type" = "ProgressBar", "unit" = " delay units", "value" = slowdown, "min" = -5, "max" = 20, "color" = slowdown < 1 ? "good" : (slowdown > 1 ? "bad" : "average")))
	equipment_stats += list(list("name" = "Stiffness", "type" = "ProgressBar", "unit" = " delay units", "value" = stiffness, "min" = -5, "max" = 20, "color" = stiffness < 1 ? "good" : (stiffness > 1 ? "bad" : "average")))
	equipment_stats += list(list("name" = "Obscuration", "type" = "ProgressBar", "unit" = " delay units", "value" = obscuration, "min" = -5, "max" = 20, "color" = obscuration < 1 ? "good" : (obscuration > 1 ? "bad" : "average")))
	equipment_stats += list(list("name" = "Coverage", "type" = "String", "value" = body_part_coverage_to_string(body_parts_covered)))
	equipment_stats += list(list("name" = "Time To Equip", "type" = "ProgressBar", "unit" = equip_delay == 1 ? " second" : " seconds", "value" = equip_delay / 10, "min" = 0, "max" = 10, "color" = equip_delay < 10 ? "good" : (equip_delay > 50 ? "bad" : "average")))

	stats["Equipment Stats"] = equipment_stats

	var/list/temperature_stats = list()

	if(heat_protection && max_heat_protection_temperature)
		temperature_stats += list(list("name" = "Heat Protection Coverage", "type" = "String", "value" = body_part_coverage_to_string(heat_protection)))
		temperature_stats += list(list("name" = "Max Temperature", "type" = "AnimatedNumber", "value" = max_heat_protection_temperature, "unit" = " deg K"))

	if(cold_protection && min_cold_protection_temperature)
		temperature_stats += list(list("name" = "Cold Protection Coverage", "type" = "String", "value" = body_part_coverage_to_string(cold_protection)))
		temperature_stats += list(list("name" = "Minimum Temperature", "type" = "AnimatedNumber", "value" = min_cold_protection_temperature, "unit" = " deg K"))

	stats["Temperature Stats"] = temperature_stats

	data["stats"] = stats

	return data

/obj/screen/item_action/top_bar/clothing_info
	icon = 'icons/mob/screen/gun_actions.dmi'
	screen_loc = "7.95,1.4"
	minloc = "7,2:13"
	name = "Clothing information"
	icon_state = "info"
	ErisOptimized_minloc = "16,10.3"

/obj/item/clothing/refresh_upgrades()
	var/obj/item/clothing/referencecarmor = new type()
	armor = referencecarmor.armor
	qdel(referencecarmor)
	..()

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !ishuman(user))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = ITEM_SIZE_HUGE
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "blocked"
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	var/obj/item/master_item

/obj/item/clothing/ears/offear/New(var/obj/O)
	name = O.name
	desc = O.desc
	icon = O.icon
	icon_state = O.icon_state
	w_class = O.w_class
	set_dir(O.dir)
	master_item = O

/obj/item/clothing/ears/offear/can_be_equipped(mob/living/user, slot, disable_warning)
	var/other_slot = (slot == slot_l_ear) ? slot_r_ear : slot_l_ear
	if(user.get_equipped_item(other_slot) != master_item || user.get_equipped_item(slot))
		return FALSE
	return ..()

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS


/obj/item/clothing/ears/earmuffs/mp3
	name = "headphones"
	desc = "A black portable wireless stereo headset, with a built-in FM radio."
	icon_state = "headphones"
	item_state = "headphones"
	action_button_name = "action_music"
	var/obj/item/device/player/player = null
	var/tick_cost = 0.1
	cell = null
	suitable_cell = /obj/item/cell/small


/*
/obj/item/clothing/ears/earmuffs/mp3/New()
	..()
	player = new(src)
	START_PROCESSING(SSobj, src)
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)



/obj/item/clothing/ears/earmuffs/mp3/update_icon()
	cut_overlays()
	..() //blood overlay, etc.
	if(player.current_track)
		add_overlay("headphones_on")

/obj/item/clothing/ears/earmuffs/mp3/ui_action_click()
	player.OpenInterface(usr)

/obj/item/clothing/ears/earmuffs/mp3/dropped(var/mob/user)
	..()
	player.stop(user)

/obj/item/clothing/ears/earmuffs/mp3/equipped(var/mob/user, var/slot)
	..()
	if(cell && cell.checked_use(tick_cost))
		player.active = TRUE
		player.play(user)

/obj/item/clothing/ears/earmuffs/mp3/Process()
	if(player.active)
		if(!cell || !cell.checked_use(tick_cost))
			if(ismob(src.loc))
				player.outofenergy()
				to_chat(src.loc, SPAN_WARNING("[src] flashes with error - LOW POWER."))


/obj/item/clothing/ears/earmuffs/mp3/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/clothing/ears/earmuffs/mp3/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

		*/

///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/inventory/eyes/icon.dmi'
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = EYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/have_lenses = 0
	var/protection = 0

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/inventory/hands/icon.dmi'
	siemens_coefficient = 0.75
	var/wired = 0
	var/clipped = 0
	body_parts_covered = ARMS
	armor_list = list(melee = 2, bullet = 0, energy = 3, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/wirecutters) || istype(W, /obj/item/tool/scalpel))
		if (clipped)
			to_chat(user, SPAN_NOTICE("The [src] have already been clipped!"))
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("\red [user] cuts the fingertips off of the [src].","\red You cut the fingertips off of the [src].")

		clipped = 1
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		return

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/inventory/head/icon.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_SMALL

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/refresh_upgrades()
	var/obj/item/clothing/head/referencecarmor = new type()
	armor = referencecarmor.armor
	qdel(referencecarmor)
	..()

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(mob/user, damage, attack_message, damagetype = BRUTE, attack_flag = ARMOR_MELEE, sharp = FALSE, edge = FALSE)
	if(!istype(user) || !mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(isdrone(user))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, SPAN_WARNING("You are already wearing a hat."))
	else if(success == 1)
		to_chat(user, SPAN_NOTICE("You crawl under \the [src]."))
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)

	cut_overlays()
	var/mob/living/carbon/human/H
	if(ishuman(user))
		H = user

	if(on)

		// Generate object icon.
		if(!light_overlay_cache["[light_overlay]_icon"])
			light_overlay_cache["[light_overlay]_icon"] = image('icons/obj/light_overlays.dmi', light_overlay)
		add_overlay(light_overlay_cache["[light_overlay]_icon"])

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/cache_key = "[light_overlay][H ? "_[H.species.get_bodytype()]" : ""]"
		if(!light_overlay_cache[cache_key])
			light_overlay_cache[cache_key] = image('icons/mob/light_overlays.dmi', light_overlay)

	if(H)
		H.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/inventory/face/icon.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES

	var/muffle_voice = FALSE
	var/voicechange = FALSE
	var/list/say_messages
	var/list/say_verbs

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/inventory/feet/icon.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = LEGS
	slot_flags = SLOT_FEET

	var/can_hold_knife = 0
	var/obj/item/holding
	var/noslip = 0
	var/module_inside = 0

	armor_list = list(melee = 2, bullet = 0, energy = 2, bomb = 0, bio = 0, rad = 0)
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	force = 2
	var/overshoes = 0

/obj/item/clothing/shoes/Destroy()
	if(holding)
		holding.forceMove(loc)
		holding = null
	return ..()

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "IC"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	if(!holding)
		to_chat(usr, SPAN_WARNING("\The [src] has no knife."))
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message(SPAN_DANGER("\The [usr] pulls a knife out of their boot!"))
		holding = null
	else
		to_chat(usr, SPAN_WARNING("You need an empty, unbroken hand to do that."))
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	return

/obj/item/clothing/shoes/AltClick()
	if((src in usr) && holding)
		draw_knife()
	else
		..()

/obj/item/clothing/shoes/attack_hand()
	if((src in usr) && holding)
		draw_knife()
	else
		..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	var/global/knifes
	var/global/not_a_knife
	if(istype(I,/obj/item/noslipmodule))
		if (item_flags != 0)
			noslip = item_flags
		module_inside = 1
		to_chat(user, "You attached a no-slip sole to \the [src].")
		permeability_coefficient = 0.05
		item_flags = NOSLIP | SILENT
		origin_tech = list(TECH_ILLEGAL = 3)
		siemens_coefficient = 0 // DAMN BOI
		qdel(I)

	if(istype(I, /obj/item/tool/knife/psionic_blade))
		return ..()
	if(!knifes)
		knifes = list(
			/obj/item/tool/knife,
			/obj/item/material/shard,
			/obj/item/material/butterfly,
			/obj/item/material/kitchen/utensil,
			/obj/item/tool/knife/tacknife,
			/obj/item/tool/knife/shiv
		)
	if(!not_a_knife)
		not_a_knife = list(/obj/item/tool/knife/psionic_blade)
	if(can_hold_knife && is_type_in_list(I, knifes))
		if(holding)
			to_chat(user, SPAN_WARNING("\The [src] is already holding \a [holding]."))
			return
		if(is_type_in_list(I, not_a_knife))
			to_chat(user, SPAN_WARNING("\The [src] is not a real knife."))
			return
		if(user.unEquip(I, src))
			holding = I
			user.visible_message(SPAN_NOTICE("\The [user] shoves \the [I] into \the [src]."))
			verbs |= /obj/item/clothing/shoes/proc/draw_knife
	else
		return ..()

/obj/item/clothing/shoes/verb/detach_noslipmodule()
	set name = "Detach acccessory"
	set category = "Object"
	set src in view(1)

	if (module_inside == 1 )
		if (noslip != 0)
			item_flags = noslip
		var/obj/item/noslipmodule/NSM = new()
		usr.put_in_hands(NSM)
	else to_chat(usr, "You haven't got any accessories in your shoes.")

/obj/item/clothing/shoes/update_icon()
	cut_overlays()
	//if(holding)
	//	add_overlay(image(icon, "[icon_state]_knife"))
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	return


///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/inventory/suit/icon.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(
		/obj/item/clipboard,
		/obj/item/pen,
		/obj/item/paper,
		/obj/item/device/flash,
		/obj/item/storage/pouch,
		/obj/item/storage/sheath,
		/obj/item/gun,
		/obj/item/melee,
		/obj/item/material,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/tank,
		/obj/item/tool, //People are going to so abuse this
		/obj/item/device/suit_cooling_unit,
		/obj/item/cell,
		/obj/item/storage/fancy,
		/obj/item/flamethrower,
		/obj/item/device/lighting,
		/obj/item/device/scanner,
		/obj/item/reagent_containers/spray,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/storage/box/matches,
		/obj/item/reagent_containers/drinks/flask,
		/obj/item/device/radio,
		/obj/item/clothing/mask,
		/obj/item/storage/backpack/guncase,
		/obj/item/implant/carrion_spider/holographic)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	var/list/extra_allowed = list()
	blacklisted_allowed = list(
		/obj/item/tool/knife/psionic_blade,
		/obj/item/tool/hammer/telekinetic_fist,
		/obj/item/flame/pyrokinetic_spark,
		/obj/item/tool/psionic_omnitool,
		/obj/item/shield/riot/crusader/psionic,
		/obj/item/gun/kinetic_blaster,
		/obj/item/tool/cannibal_scythe
		)
	equip_delay = 1 SECONDS

	valid_accessory_slots = list("armband","decor")
	restricted_accessory_slots = list("utility", "armband")

/obj/item/clothing/suit/New()
	LAZYOR(allowed, extra_allowed)
	.=..()

/obj/item/clothing/suit/refresh_upgrades()
	var/obj/item/clothing/suit/referencecarmor = new type()
	armor = referencecarmor.armor
	qdel(referencecarmor)
	..()

///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/inventory/uniform/icon.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	w_class = ITEM_SIZE_NORMAL
	var/has_sensor = 1 //For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rolldown = FALSE
	equip_delay = 2 SECONDS

	//convenience var for defining the icon state for the overlay used when the clothing is worn.

	valid_accessory_slots = list("utility","armband","decor")
	restricted_accessory_slots = list("utility", "armband")


/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/New()
	..()
	LAZYSET(item_state_slots, slot_w_uniform_str, icon_state) //TODO: drop or gonna use it?
	if(isOnStationLevel(src))
		sensor_mode = 3 // Clothing spawning on colony levels is on tracking by default.

/obj/item/clothing/under/examine(mob/user)
	..(user)
	switch(src.sensor_mode)
		if(0)
			to_chat(user, "Its sensors appear to be disabled.")
		if(1)
			to_chat(user, "Its binary life sensors appear to be enabled.")
		if(2)
			to_chat(user, "Its vital tracker appears to be enabled.")
		if(3)
			to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(var/mob/M)
	if(has_sensor >= 2)
		to_chat(usr, "The controls are locked.")
		return 0
	if(has_sensor <= 0)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	if(sensor_mode == 3)
		sensor_mode = 0
	else
		sensor_mode++

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				to_chat(usr, "You disable your suit's remote sensing equipment.")
			if(1)
				to_chat(usr, "Your suit will now report whether you are live or dead.")
			if(2)
				to_chat(usr, "Your suit will now report your vital lifesigns.")
			if(3)
				to_chat(usr, "Your suit will now report your vital lifesigns as well as your coordinate position.")
	else if (ismob(loc))
		switch(sensor_mode)
			if(0)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("\red [usr] disables [src.loc]'s remote sensing equipment.", 1)
			if(1)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] turns [src.loc]'s remote sensors to binary.", 1)
			if(2)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to track vitals.", 1)
			if(3)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to maximum.", 1)

/obj/item/clothing/under/attackby(var/obj/item/I, var/mob/U)
	if(I.get_tool_type(usr, list(QUALITY_SCREW_DRIVING), src) && ishuman(U))
		set_sensors(U)
	else
		return ..()

/obj/item/clothing/under/verb/roll_down()
	set name = "Toggle Jumpsuit"
	set desc = "Toggle the appearance of your jumpsuit."
	set category = "Object"

	usr.visible_message("[usr] adjusts their jumpsuit.", \
	"You adjust your jumpsuit.")
	rolldown = !rolldown
	usr.update_inv_w_uniform()
