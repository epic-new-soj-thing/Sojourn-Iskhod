// Blood Magic module - ritual knife, bloodletter (sickle), awakened blade, and knife (type 6) spell procs.

// --- Ritual knife items (draw runes, cut palm, spell invocation) ---

/obj/item/tool/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant. It can be used on the floor to draw runes in your blood, or on yourself to cut your palm and bloody your hands for writing."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	force = WEAPON_FORCE_PAINFUL
	armor_divisor = ARMOR_PEN_MODERATE
	max_upgrades = 3
	backstab_damage = 14
	price_tag = 7

/obj/item/tool/knife/ritual/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(H.get_core_implant(/obj/item/implant/core_implant/cruciform))
		to_chat(H, SPAN_WARNING("Your faith prevents you from drawing your own blood for the art."))
		return
	if(H.gloves)
		to_chat(H, SPAN_WARNING("Take off your gloves first so your hands can be bloodied."))
		return
	var/datum/reagent/organic/blood/_B = H.get_blood()
	if(!_B || H.get_blood_volume() < 10)
		to_chat(H, SPAN_WARNING("You need more blood in your body to spare any for your hands."))
		return
	to_chat(H, SPAN_NOTICE("You cut your palm with the ritual knife and coat your fingers in blood."))
	if(do_after(H, 25, src))
		_B = H.get_blood()
		if(!_B || H.get_blood_volume() < 10)
			to_chat(H, SPAN_WARNING("You don't have enough blood left."))
			return
		_B.remove_self(5)
		H.bloody_hands = 5
		H.blood_writes_remaining = 5
		H.hand_blood_color = H.species?.blood_color ? H.species.blood_color : "#A10808"
		H.bloody_hands_mob = H
		H.update_inv_gloves(1)
		add_verb(H, /mob/living/carbon/human/proc/bloody_doodle)
		add_verb(H, /mob/living/carbon/human/proc/bloody_write_paper)
		to_chat(H, SPAN_NOTICE("Your hands are now bloody; you can write in blood up to 5 times before you need to cut your palm again."))
	return

/obj/item/tool/knife/ritual/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !istype(target, /turf/simulated/floor))
		return ..()
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(H.get_core_implant(/obj/item/implant/core_implant/cruciform))
		to_chat(H, SPAN_WARNING("Your faith prevents you from drawing blood runes."))
		return
	var/datum/reagent/organic/blood/_B = H.get_blood()
	if(!_B || H.get_blood_volume() < 25)
		to_chat(H, SPAN_WARNING("You need more blood to draw a rune."))
		return
	to_chat(H, SPAN_NOTICE("You slice your palm and trace a rune on the floor in blood."))
	if(do_after(H, 50, target))
		_B = H.get_blood()
		if(!_B || H.get_blood_volume() < 25)
			to_chat(H, SPAN_WARNING("You don't have enough blood left."))
			return
		_B.remove_self(25)
		new /obj/effect/decal/cleanable/blood_rune(target, "#A10808", "#400000", "rune", TRUE)
		to_chat(H, SPAN_NOTICE("You finish drawing the blood rune."))
	return

/obj/item/tool/knife/ritual/sickle
	name = "bloodletter"
	desc = "A ritual knife, its latent unearthly energies partly awoken by forces unknown. \
			The curved blade cuts deep into flesh, drawing blood for rituals with ease."
	icon_state = "render_awakened"
	hitsound = 'sound/weapons/renderslash.ogg'
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_DEEP
	max_upgrades = 2
	hitsound = 'sound/weapons/renderslash.ogg'
	backstab_damage = 8 // Not so much for stabbing as it is for cutting.
	tool_qualities = list(QUALITY_CUTTING = 20, QUALITY_WIRE_CUTTING = 10)
	attack_verb = list("slashed", "sliced", "ripped", "diced", "cut")
	embed_mult = 1.5 // Careful not to lose it!

/obj/item/tool/knife/ritual/blade
	name = "awakened blade"
	desc = "The last stage of ascension of a ritual knife, its latent powers fully awoken by blood magic. \
			Suspiciously glowing runes are drawn on its surface that glow at random intervals."
	icon_state = "crayon_blade"
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_STEEL = 2, MATERIAL_DIAMOND = 1)
	force = WEAPON_FORCE_ROBUST + 4 // 30 damage
	armor_divisor = ARMOR_PEN_MASSIVE // More balanced than psi weapons with psi mania perk.
	w_class = ITEM_SIZE_BULKY
	max_upgrades = 2
	slot_flags = SLOT_BELT|SLOT_BACK
	hitsound = 'sound/weapons/renderslash.ogg' // Snowflake
	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "crayon_blade"
	)

// --- Knife (type 6) spell procs ---

// Voice: Grants us the Occult language, a global hive-like language
// to communicate long-range with other blood cultists
/obj/effect/decal/cleanable/blood_rune/proc/voice_spell(mob/living/carbon/human/M)
	M.add_language(LANGUAGE_OCCULT)
	to_chat(M, "<span class='warning'>Your head throbs like a maddening heartbeat, eldritch knowledge gnawing open the doors of your psyche and crawling inside, granting you a glimpse of languages older than time itself. The heart pounds in synchrony, making up for the price of blood in exchange.</span>")
	playsound(M, 'sound/effects/singlebeat.ogg', 80)
	var/cost = src.health_spell_cost(M, 20)
	M.maxHealth -= cost
	M.health -= cost
	src.charge_blood(M, 25)
	M.unnatural_mutations.total_instability += 15
	M.sanity.changeLevel(-20, TRUE)
	return

// Drain: Consume a superior animal or simple animal's corpse in sight to get your health and max health back
// Increases your total mutation instability so that you can't spam it
/obj/effect/decal/cleanable/blood_rune/proc/drain_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	for(var/mob/living/carbon/superior/greater in oview(1))

		if(!body_checks(M))
			return

		if(able_to_cast && M.maxHealth < 200)
			to_chat(M, "<span class='warning'>The sacrifice vanishes to dust before you. You feel an ominous warm wind envelop your form as you absorb its lifeforce unto your own.</span>")
			M.maxHealth += 1
			M.health += 1
			M.unnatural_mutations.total_instability += 1 //A soft cap
		else
			to_chat(M, "<span class='warning'>The sacrifice vanishes to dust before you. Yet you feel nothing. Perhaps you are as healthy as possible.</span>")
		src.charge_blood(M, 35)
		greater.dust()
		M.sanity.changeLevel(-20, TRUE)
		return

	for(var/mob/living/simple/lesser in oview(1))

		if(!body_checks(M))
			return

		to_chat(M, "<span class='warning'>The sacrifice vanishes to dust before you. You feel an ominous warm wind envelop your form as you absorb its lifeforce unto your own.</span>")
		if(able_to_cast && M.maxHealth < 200)
			M.maxHealth += 1
			M.health += 1
			M.unnatural_mutations.total_instability += 1 //A soft cap
		src.charge_blood(M, 35)
		lesser.dust()
		M.sanity.changeLevel(-20, TRUE)
		return
	return

// Cards: Invokes a random carp card, to use with other spells
/obj/effect/decal/cleanable/blood_rune/proc/cards_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	to_chat(M, "<span class='warning'>A voice whispers in front of you: Any foils?</span>")
	for(var/obj/item/device/camera_film in oview(1)) // Must be on the spell circle

		if(!body_checks(M))
			return

		src.charge_blood(M, 5)
		new /obj/random/card_carp(src.loc)
		M.sanity.changeLevel(-3, TRUE)
	return

// Cards to Life: Consumes a Carp card of a certain type to summon an animal accordingly.
// The animal in question is tamed, friendly to the colony, but are incredibly frail and weak.
// Pelt cards can be turned into scroll pouches, Warren turns into a burrow
/obj/effect/decal/cleanable/blood_rune/proc/cards_to_life_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	var /mob/living/simple/simplemob = /mob/living/simple/hostile/creature
	var /mob/living/carbon/superior/superiormob = null
	for(var/obj/item/card_carp/carpy in oview(1))

		if(!body_checks(M))
			return

		to_chat(M, "<span class='warning'>The card rotates 90 degrees then begins to fold, twisting untill it breaks open with a reality-ripping sound. Something crawls out of its interior!</span>")

		// Nonhostile simplemobs. The pets of the colony.
		if(istype(carpy, /obj/item/card_carp/crab)) simplemob = /mob/living/simple/crab
		if(istype(carpy, /obj/item/card_carp/cat)) simplemob = /mob/living/simple/cat
		if(istype(carpy, /obj/item/card_carp/geck)) simplemob = /mob/living/simple/lizard
		if(istype(carpy, /obj/item/card_carp/goat)) simplemob = /mob/living/simple/hostile/retaliate/goat
		if(istype(carpy, /obj/item/card_carp/larva)) simplemob = /mob/living/simple/light_geist
		// Corgi
		if(istype(carpy, /obj/item/card_carp/stunted_wolf) || istype(carpy, /obj/item/card_carp/coyote) ||istype(carpy, /obj/item/card_carp/wolf)) simplemob = /mob/living/simple/corgi
		// RATS, RATS, WE'RE THE RATS
		if(istype(carpy, /obj/item/card_carp/ratking) || istype(carpy, /obj/item/card_carp/plaguerat) || istype(carpy, /obj/item/card_carp/kangaroorat) || istype(carpy, /obj/item/card_carp/chipmunk) || istype(carpy, /obj/item/card_carp/fieldmice)) simplemob = /mob/living/simple/mouse
		// Retaliation and hostile mobs
		if(istype(carpy, /obj/item/card_carp/croaker_lord)) simplemob = /mob/living/simple/hostile/retaliate/croakerlord
		if(istype(carpy, /obj/item/card_carp/lost_rabbit)) simplemob = /mob/living/simple/hostile/diyaab
		if(istype(carpy, /obj/item/card_carp/adder)) simplemob = /mob/living/simple/hostile/snake
		if(istype(carpy, /obj/item/card_carp/grizzly)) simplemob = /mob/living/simple/hostile/bear
		if(istype(carpy, /obj/item/card_carp/bat)) simplemob = /mob/living/simple/hostile/scarybat
		if(istype(carpy, /obj/item/card_carp/great_white)) simplemob = /mob/living/simple/hostile/carp/greatwhite
		// Birbs
		if(istype(carpy, /obj/item/card_carp/kingfisher) || istype(carpy, /obj/item/card_carp/sparrow) || istype(carpy, /obj/item/card_carp/turkey_vulture) || istype(carpy, /obj/item/card_carp/magpie)) simplemob = /mob/living/simple/jungle_bird
		// Sentient tree
		if(istype(carpy, /obj/item/card_carp/tree) || istype(carpy, /obj/item/card_carp/pinetree)) simplemob = /mob/living/simple/hostile/tree
		// Tindalos
		if(istype(carpy, /obj/item/card_carp/manti) || istype(carpy, /obj/item/card_carp/manti_lord)) simplemob = /mob/living/simple/tindalos

		// Superior mobs below

		//roaches
		if(istype(carpy, /obj/item/card_carp/pupa)) superiormob =  /mob/living/carbon/superior/roach/roachling
		if(istype(carpy, /obj/item/card_carp/cockroach)) superiormob = /mob/living/carbon/superior/roach
		if(istype(carpy, /obj/item/card_carp/stinkbug)) superiormob = /mob/living/carbon/superior/roach/toxic
		//termites for ants
		if(istype(carpy, /obj/item/card_carp/ant) || istype(carpy, /obj/item/card_carp/peltlice)) superiormob = /mob/living/carbon/superior/termite_colony/iron
		if(istype(carpy, /obj/item/card_carp/antqueen)) superiormob = /mob/living/carbon/superior/termite_colony/diamond
		//superior beasties
		if(istype(carpy, /obj/item/card_carp/wyrm)) superiormob = /mob/living/carbon/superior/wurm/diamond
		//golem
		if(istype(carpy, /obj/item/card_carp/rock) || istype(carpy, /obj/item/card_carp/bloodrock)) superiormob = /mob/living/carbon/superior/ameridian_golem

		// End of mob spawns

		// Turned it into a carrying bag
		if(istype(carpy, /obj/item/card_carp/rpelt) || istype(carpy, /obj/item/card_carp/dpelt) || istype(carpy, /obj/item/card_carp/pinepelt) || istype(carpy, /obj/item/card_carp/gpelt))
			new /obj/item/storage/pouch/scroll(carpy.loc)
			qdel(carpy)
			src.charge_blood(M, 25)
			M.sanity.changeLevel(1)
			return

		// Burrow
		if(istype(carpy, /obj/item/card_carp/warren))
			var/obj/structure/burrow/diggy_hole = new /obj/structure/burrow(carpy.loc)
			diggy_hole.deepmaint_entry_point = TRUE
			diggy_hole.isRevealed = TRUE
			diggy_hole.isSealed = FALSE
			diggy_hole.invisibility = 0
			diggy_hole.collapse()
			qdel(carpy)
			src.charge_blood(M, 25)
			M.sanity.changeLevel(1)
			return

		if(istype(carpy, /obj/item/card_carp/daus))
			to_chat(M, "<span class='warning'>A claw swipes and bites at the caster for stealing a bell!</span>")

/*
			Z:/FloppyDisk/TRILBYMOD: //Somethings can not be handled by the common players
			Z:/FloppyDisk/TRILBYMOD: superiormob = /mob/living/carbon/superior/genetics/fratellis //genetics beastie
			Z:/FloppyDisk/TRILBYMOD: DEPLOY DAUS NERF
*/

			new /obj/random/cloth/bells(carpy.loc)
			M.sanity.changeLevel(1)
			M.adjustBruteLoss(10)
			src.charge_blood(M, 25)
			qdel(carpy)
			return


		// Code that takes superiormob var and spawns whatever it was set too.
		if(superiormob != null)
			var /mob/living/carbon/superior/editme = new superiormob(carpy.loc)
			editme.colony_friend = TRUE
			editme.friendly_to_colony = TRUE
			editme.faction = "Living Dead"
			editme.maxHealth = 5
			editme.health = 5
			qdel(carpy)
			src.charge_blood(M, 25)
			M.sanity.changeLevel(1)
			return //we returned out so it shouldn't double up.

		var /mob/living/simple/changemeupinside = new simplemob(carpy.loc)
		changemeupinside.colony_friend = TRUE
		changemeupinside.friendly_to_colony = TRUE
		changemeupinside.faction = "Living Dead"
		changemeupinside.maxHealth = 5
		changemeupinside.health = 5
		src.charge_blood(M, 25)
		M.sanity.changeLevel(1)
		qdel(carpy)

// Life to Cards: Consumes a mob to turn into a uniquic card
/obj/effect/decal/cleanable/blood_rune/proc/life_to_cards_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	var/success = FALSE
	for(var/mob/living/carbon/superior/target in oview(1))

		if(!body_checks(M))
			return
		src.charge_blood(M, 25) //pay da cost BEFORE we do the living check
		if(!able_to_cast) //punishment for not being able to cast
			var/cost = src.health_spell_cost(M, 1)
			M.maxHealth -= cost
			M.health -= cost
			M.unnatural_mutations.total_instability += 1 //A soft cap

		success = TRUE
		var/obj/item/card_carp/death_card/death_card = new /obj/item/card_carp/death_card(src.loc)
		death_card.generate(target.maxHealth, target.meat_amount, target.melee_damage_lower, target.ranged, target.name)
		to_chat(M, "<span class='warning'>\The [target] sinks down into the rune leaving behind... a small card?!</span>")
		target.dust()

	for(var/mob/living/simple/simplemtarget in oview(1))

		if(!body_checks(M))
			return
		src.charge_blood(M, 25)
		if(!able_to_cast)
			var/cost = src.health_spell_cost(M, 1)
			M.maxHealth -= cost
			M.health -= cost
			M.unnatural_mutations.total_instability += 1

		success = TRUE
		var/obj/item/card_carp/death_card/death_card = new /obj/item/card_carp/death_card(src.loc)
		death_card.generate(simplemtarget.maxHealth, simplemtarget.meat_amount, simplemtarget.melee_damage_lower, 0, simplemtarget.name)
		to_chat(M, "<span class='warning'>\The [simplemtarget] sinks down into the rune leaving behind... a small card?!</span>")
		simplemtarget.dust()


	if(!success)
		src.charge_blood(M, 8)
		new /obj/item/card_carp/index/adved(src.loc)

// Equalize: This spell pools together the entire average percentage of blood from all mobs in sight
// and distributes it equally among the number of mobs, "equalizing" it.
// e.g: If a person has 100% blood and another has 50%, both have 75% blood now
// and then the caster incurrs the blood cost for the spell equal to 20 per person affected, up to a cap of 80 cost.
/obj/effect/decal/cleanable/blood_rune/proc/equalize_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	//get percent of blood. Then pass it back into people. Thats total blood between all / by number of people.
	var/bloodpercent = 0
	var/bloodtotal = 0
	var/list/targets = list()
	//add the caster in first. They don't get included in the for loops.
	targets += M
	bloodtotal = M.get_blood_volume()

	//We go thru all possible targets and set them to the list and gather our blood amount
	for(var/mob/living/carbon/human/T in oview(3))
		if(T.species?.reagent_tag != IS_SYNTHETIC && T.species?.reagent_tag != IS_SLIME)
			targets += T
			bloodtotal += T.get_blood_volume()
	bloodpercent = ((bloodtotal / targets.len) * 0.01) // turn it into a decimal for later maths.

	//emergency catch in case somehow we don't have vars we need.
	if(!targets || !bloodpercent)
		return

	//Blood alteration of targets
	for(var/mob/living/carbon/human/T in oview(3))
		if(T.species?.reagent_tag != IS_SYNTHETIC && T.species?.reagent_tag != IS_SLIME)
			if(T.get_blood_volume() >= (bloodpercent * T.species.blood_volume))
				T.vessel.remove_reagent(T.species.blood_reagent, ((T.get_blood_volume() * 0.01) - bloodpercent) * T.species.blood_volume)
			else T.vessel.add_reagent(T.species.blood_reagent, (bloodpercent - (T.get_blood_volume() * 0.01)) * T.species.blood_volume)
			to_chat(T, "<span class='warning'>You feel extremly woozy and light headed for a second. It partially recovers.</span>")
			M.sanity.changeLevel(-5, TRUE) //Good deads always get punished (but only if we successfully cast the spell!)

	//caster blood handling below
	to_chat(M, "<span class='warning'>The sound of a heart beat fills the air around you.</span>")
	playsound(loc, 'sound/effects/singlebeat.ogg', 80)
	if(M.get_blood_volume() < bloodpercent)
		M.vessel.add_reagent(M.species.blood_reagent, (bloodpercent - (M.get_blood_volume() * 0.01)) * M.species.blood_volume)
	else M.vessel.remove_reagent(M.species.blood_reagent, ((M.get_blood_volume() * 0.01) - bloodpercent) * M.species.blood_volume)
	src.charge_blood(M, min(10 * targets.len, 40))
	return

// Fountain: High blood cost, to invoke a bloody basin in which to soak one's hands for writing in blood
// This makes it so that you don't need to gib additional creatures to write each time
// TODO: MORE CRAYON CULT BASED FURNITURE, CHANDELIERS?
/obj/effect/decal/cleanable/blood_rune/proc/basin_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	for(var/obj/structure/reagent_dispensers/watertank/W in oview(1)) // Must be on the spell circle

		if(!body_checks(M))
			return

		to_chat(M, "<span class='info'>Thunder crackles as a miniature cloud of nothingness manifests itself. Otherworldly blood begins pouring down, forming an ominous black blood basin beneath it...</span>")
		src.charge_blood(M, 50) // Basically pouring your blood into a container, insane
		M.sanity.breakdown(FALSE) // If your blood got sucked and poured into a container you too would freak out
		M.sanity.changeLevel(-50, TRUE)
		var/obj/structure/sink/basin/blood/N = new /obj/structure/sink/basin/blood
		N.loc = W.loc
		qdel(W)
	return

// Veil: Invoke a blindfold that works as prescription goggles with one extra tile of visibility in the dark
// These work as normal blindfolds for people who do not have the Cult language learned.
/obj/effect/decal/cleanable/blood_rune/proc/veil_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	for(var/obj/item/clothing/glasses/blindfold/G in oview(1))

		if(!body_checks(M))
			return

		to_chat(M, "<span class='info'>The blindfold glows for a moment before falling silent, forces unknown apparently strengthened its properties...</span>")
		src.charge_blood(M, 40)
		M.sanity.changeLevel(-10, TRUE)
		var/obj/item/clothing/glasses/crayon_blindfold/N = new /obj/item/clothing/glasses/crayon_blindfold
		N.loc = G.loc
		qdel(G)
	return

// Caprice: Converts the rune to a trap rune, if having bable or voice will send it randomly to maints or deepmaints.
/obj/effect/decal/cleanable/blood_rune/proc/caprice_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/turf/simulated/floor/target	//this is where we are teleporting
	var/list/validtargets = list()

	for(var/area/A in world)						//Clumbsy, but less intensive than iterating every tile
		if(istype(A, /area/deepmaint))				//First find our deepmaint areas
			for(var/turf/simulated/floor/T in A)		//Pull a list of valid floor tiles from deepmaint
				validtargets += T					//Add them to the list

		if(istype(A, /area/iskhod/maintenance))			//First find our maints areas
			if(A.is_maintenance)					//Just in case were a subtype of maintenance and NOT maintenanced
				for(var/turf/simulated/floor/T in A)
					if(A.is_maintenance)			//Pull a list of valid floor tiles from deepmaint
						validtargets += T			//Add them to the list

	//We act differently if a human is doing this
	if(M)
		for(var/obj/effect/decal/cleanable/blood_rune/G in oview(3))
			if(!body_checks(M))
				return

			if(able_to_cast)
				var/obj/effect/decal/cleanable/blood_rune/trap/trap_teleport_placement = new /obj/effect/decal/cleanable/blood_rune/trap(src.loc,main=RANDOM_RGB,shade=RANDOM_RGB)
				src.charge_blood(M, 10)
				bluespace_entropy(1, get_turf(src))
				trap_teleport_placement.forceMove(target)
				qdel(G)
			else
				//We just convert to traps, not move them around in deepmaints or maints normal
				src.charge_blood(M, 5)
				new /obj/effect/decal/cleanable/blood_rune/trap(G.loc,main=RANDOM_RGB,shade=RANDOM_RGB)
				qdel(G)
			return
	else
		//This one is done by a higher power with a more stable connection. No entropy
		var/obj/effect/decal/cleanable/blood_rune/trap/trap_teleport_placement = new /obj/effect/decal/cleanable/blood_rune/trap(main=RANDOM_RGB,shade=RANDOM_RGB)
		trap_teleport_placement.forceMove(target)

	return

// Mightier: Invokes throwing blood rune projectiles whose strength gets higher the lower our max HP is.
/obj/effect/decal/cleanable/blood_rune/proc/mightier_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return

	bluespace_entropy(10, get_turf(src))
	src.charge_blood(M, 25) //roughly 10 percent for each projectile.
	var/obj/item/stack/thrown/blood_knives/needles = new /obj/item/stack/thrown/blood_knives(src.loc)
	needles.update_icon()
	if(M.get_inactive_hand() == src)
		M.drop_from_inventory(src)
		M.put_in_inactive_hand(needles)
	return

// Purify.: Consume a soulstone on the rune to create a purified soulstone. Requires 6 candles, 55 blood. Knife or book.
/obj/effect/decal/cleanable/blood_rune/proc/purify_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return
	for(var/obj/item/soulstone/S in oview(1))
		if(istype(S, /obj/item/soulstone/purified) || istype(S, /obj/item/soulstone/mystic))
			continue
		if(!body_checks(M))
			return
		src.charge_blood(M, 55)
		M.sanity.changeLevel(-12, TRUE)
		to_chat(M, SPAN_NOTICE("The soulstone clears as blood and candle-light wash over it."))
		new /obj/item/soulstone/purified(src.loc)
		qdel(S)
		return
	to_chat(M, SPAN_NOTICE("Place a soulstone on the rune, then invoke with Purify. to purify it."))

// Mystic.: Consume a purified soulstone on the rune to create a mystic soulstone. Requires 8 candles, 75 blood. Knife or book.
/obj/effect/decal/cleanable/blood_rune/proc/mystic_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	if(!able_to_cast)
		return
	for(var/obj/item/soulstone/purified/S in oview(1))
		if(!body_checks(M))
			return
		src.charge_blood(M, 75)
		M.sanity.changeLevel(-18, TRUE)
		to_chat(M, SPAN_NOTICE("The purified soulstone deepens and hums with latent power."))
		new /obj/item/soulstone/mystic(src.loc)
		qdel(S)
		return
	to_chat(M, SPAN_NOTICE("Place a purified soulstone on the rune, then invoke with Mystic. to make a mystic soulstone."))

// Scroll: Consume a dead animal on the rune to create a blank scroll. Requires 7 candles and the spell name Scroll.
/obj/effect/decal/cleanable/blood_rune/proc/scroll_spell(mob/living/carbon/human/M)
	for(var/mob/living/carbon/superior/target in oview(1))
		if(!body_checks(M))
			return
		if(target.stat != DEAD)
			continue
		src.charge_blood(M, 25)
		M.sanity.changeLevel(-5, TRUE)
		new /obj/item/scroll(src.loc)
		qdel(target)
		return
	for(var/mob/living/simple/target in oview(1))
		if(!body_checks(M))
			return
		if(target.stat != DEAD)
			continue
		src.charge_blood(M, 25)
		M.sanity.changeLevel(-5, TRUE)
		new /obj/item/scroll(src.loc)
		qdel(target)
		return
	to_chat(M, SPAN_NOTICE("Place a dead animal on the rune, then invoke with the knife again to create a blank scroll."))


// Blood Party: Converts plushies into stats, at a cost of course
/obj/effect/decal/cleanable/blood_rune/proc/blood_party_spell(mob/living/carbon/human/M)
	var/stat_amount = 0
	for(var/obj/structure/plushie/LP in oview(2)) // Must be on the spell circle
		if(M.max_nutrition > 20 && body_checks(M))
			to_chat(M, "<span class='info'>You pour blood into [LP.name]'s offering.</span>")
			src.charge_blood(M, 10) //Your blood
			stat_amount += 2  //We give quite a bit for
			M.max_nutrition -= 20
			var/cost = src.health_spell_cost(M, 5)
			M.maxHealth -= cost
			M.health -= cost
		else
			to_chat(M, "<span class='info'>Your basin has run dry.</span>")
			src.charge_blood(M, 5) //Still cost ya to manifest the blood gathering

	for(var/obj/item/toy/plushie/P in oview(2)) // Must be on the spell circle
		if(M.max_nutrition > 20 && body_checks(M))
			to_chat(M, "<span class='info'>You pour blood into [P.name]'s offering.</span>")
			src.charge_blood(M, 12) //Your blood
			stat_amount += 1  //We give quite a bit for
			M.max_nutrition -= 5
		else
			to_chat(M, "<span class='info'>Your basin has run dry.</span>")
			src.charge_blood(M, 1) //Still cost ya to manifest the blood gathering

	for(var/stat in ALL_STATS_FOR_LEVEL_UP)
		if(M.stats && body_checks(M)) //Make sure to not overburden yourself in this blood party
			M.stats.addTempStat(stat, stat_amount, stat_amount MINUTES, "Blood Party")
	return

// Cessation: Baba is gone? - Removes you from player from the world for an equal amount of candles
/obj/effect/decal/cleanable/blood_rune/proc/cessation_spell(mob/living/carbon/human/M, candle_number)
	var/cn
	//Dont change the top lines they are real letters BYOND DM cant see normally
	var/list/hmm = list("༒", "༎༐།", "‽", "⸘", "༑", \
	"Sipping sounds echo in you.", "Nothing is around you.", "Nothing is still.", "Sounds are felt here, not heard.", "Where are you?")

	src.charge_blood(M, max(1, round(candle_number / 2)))

	for(cn=0, cn<candle_number, cn++)
		var/huh = pick(hmm)
		to_chat(M, "<span class='info'>[huh]</span>") //Spammy!
	M.loc = null

	if(prob(candle_number))
		to_chat(M, "<span class='info'>A secondary voice of a canvus being painted on fittles \"You wanted me to paint a slow path back for you? Don't blame me for what you dont hear!\".</span>")
		candle_number *= 60
	else
		to_chat(M, "<span class='info'>A primary chipper voice of musical notes drips \"You wish to get away from here quickly? I'll lead the way! Te Te Te. Don't blame me for what you dont see!\".</span>")

	//Surely nothing bad will happen
	var/cn_s = candle_number SECONDS
	sleep(cn_s)
	var/turf/source = get_turf(src)
	if(source)
		M.loc = source
		to_chat(M, "<span class='info'>In a instance you find yourself back at the rune...</span>")
