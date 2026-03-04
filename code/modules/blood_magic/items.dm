// Blood Magic module - pouches, thrown projectiles, basin, camera.

/obj/item/blood_pouch
	name = "blood pouch"
	desc = "What seems to be a dice bag has turned into something far more strange."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"
	price_tag = 100
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_BIOMATTER = 12)
	attack_verb = list("pouched")

	var/obj/item/storage/heldbag = null
	var/master_bag = FALSE

/obj/item/blood_pouch/Initialize(mapload)
	for(var/obj/item/blood_pouch/linker in world)
		heldbag = linker.heldbag
	if(!heldbag && !master_bag)
		heldbag = new /obj/item/storage/pouch/medium_generic/blood_linker(src)
		master_bag = TRUE

/obj/item/blood_pouch/attackby(obj/item/W as obj, mob/user as mob)
	if(heldbag)
		heldbag.refresh_all()
		heldbag.close_all()
		return heldbag.attackby(W, user)
	else
		to_chat(user, SPAN_WARNING("The blood pouch refuses to open."))
		return

/obj/item/blood_pouch/AltClick(mob/user)
	if(!heldbag)
		to_chat(user, SPAN_WARNING("The blood pouch refuses to open."))
		return
	return heldbag.AltClick(user)

/obj/item/blood_pouch/attack_self(mob/user as mob)
	if(!heldbag)
		to_chat(user, SPAN_WARNING("The blood pouch refuses to open."))
		return
	return heldbag.attack_self(user)

/obj/item/blood_pouch/throw_at(mob/user)
	if(heldbag)
		heldbag.close_all()
	..()

/obj/item/blood_pouch/Destroy()
	heldbag.close_all()
	if(master_bag)
		for(var/obj/item/blood_pouch/linker in world)
			linker.heldbag = null
		master_bag = FALSE
		qdel(heldbag)
	else
		heldbag = null
	contents = null
	. = ..()

/obj/item/storage/pouch/medium_generic/blood_linker

/obj/item/storage/pouch/medium_generic/blood_linker/storage_depth_turf()
	return -1

/obj/item/storage/pouch/medium_generic/blood_linker/attack_self(mob/user as mob)
	open(user)

/obj/item/storage/pouch/medium_generic/blood_linker/Adjacent()
	return TRUE

// Thrown blood rune projectiles: use hunt_knife appearance (icons/obj/stack/items.dmi), scale damage with lower max HP.
/obj/item/stack/thrown/blood_knives
	name = "blood rune projectiles"
	desc = "Sharpened and blood-infused. The perfect weight for throwing."
	icon = 'icons/obj/stack/items.dmi'
	icon_state = "hunt_knife"
	item_state = "hunt_knife"
	singular_name = "blood rune projectile"
	plural_name = "blood rune projectiles"
	tool_qualities = list()
	attack_verb = list("slashed", "stabbed", "marked", "cut")
	matter = list()
	max_amount = 6

/obj/item/stack/thrown/blood_knives/update_icon()
	icon_state = "[initial(icon_state)][amount]"
	item_state = "hunt_knife[amount]"

/obj/item/stack/thrown/blood_knives/launchAt(atom/target, mob/living/carbon/M)
	var/hp_throwing_damage = ((200 - max(M.maxHealth, 30)) / 5) // At 60 hp we do about 28 damage. Caps at 34 damage.
	throwforce = hp_throwing_damage
	..()

// Admin/testing: camera that applies nearsighted on use (for scroll inscribing).
/obj/item/device/camera/blood_scribe
	desc = "Why is the flash on the back...?"
	name = "camera"
	pictures_left = 0

/obj/item/device/camera/blood_scribe/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/device/camera_film))
		to_chat(user, "<span class='warning'>Strange. The film seems to keep popping out.</span>")

/obj/item/device/camera/blood_scribe/attack_self(mob/user)
	if(user)
		to_chat(user, "The camera goes off in your face!")
		playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)
		user.disabilities|=NEARSIGHTED

/obj/structure/sink/basin/blood
	name = "blood basin"
	desc = "A deep basin of polished black, stained with blood, that forever fills with blood for a most splendid gathering. \
			An inkwell of blood in which to dip your fingers to write in blood."
	icon_state = "blood_basin"
	density = 1
//	limited_reagents = FALSE
//	refill_rate = 200
//	reagent_id = "blood"

/obj/structure/sink/basin/blood/attack_hand(mob/living/carbon/human/user)
	if(istype(user))
		if(user.gloves)
			to_chat(user, SPAN_NOTICE("You must take off your gloves to dip your fingers into the basin."))
			return FALSE
		if(user.sanity && user.sanity.insight > 0)
			to_chat(user, SPAN_NOTICE("You dip your fingers in the basin; a bellow of voices echo in your head—a price for a pour of blood."))
			user.sanity.insight = 0
		else
			to_chat(user, SPAN_NOTICE("You dip your fingers in the basin and coat them with blood."))
		user.bloody_hands += 5
		user.hand_blood_color = "#A10808"
		user.update_inv_gloves(1)
		add_verb(user, /mob/living/carbon/human/proc/bloody_doodle)
		add_verb(user, /mob/living/carbon/human/proc/bloody_write_paper)

/obj/structure/sink/basin/blood/attackby(obj/item/I, mob/user)
	if(I.has_quality(QUALITY_BOLT_TURNING))
		anchored = !anchored
