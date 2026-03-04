// Blood Magic module - scrolls and scroll spell procs.

// Scrolls allowing anyone to cast their effects by burning them.
/obj/item/scroll
	name = "blank scroll"
	desc = "A blank canvas in which to express your own insanity."
	icon = 'icons/obj/scroll_bandange.dmi' //icons thanks to Ezoken#5894
	icon_state = "Scrollstended"
	item_state = "blood_scroll_open"
	w_class = ITEM_SIZE_BULKY
	var/message = ""

// Sealed scrolls are much smaller. They are obtained by using a stack of Bee wax on a normal scroll.
/obj/item/scroll/sealed
	name = "sealed scroll"
	desc = "A scroll sealed up with something, or nothing. Only one way to find out!"
	icon_state = "Scrollclosed"
	item_state = "blood_scroll_closed"
	w_class = ITEM_SIZE_SMALL

// Meant to take occult goodies and that's it.
// TODO: Give it a snowflake sprite instead of a placeholder.
/obj/item/storage/pouch/scroll
	name = "scroll bag"
	desc = "Can hold various scrolls and books."
	icon_state = "large_leather"
	item_state = "large_leather"
	w_class = ITEM_SIZE_BULKY
	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	max_w_class = ITEM_SIZE_SMALL
	storage_slots = 7
	max_storage_space = DEFAULT_NORMAL_STORAGE
	can_hold = list(
		/obj/item/scroll,
		/obj/item/oddity/common/book_unholy,
		/obj/item/oddity/common/book_omega,
		/obj/item/tool/knife/ritual, // This means both the knife and sickle...
		/obj/item/paper/alchemy_recipes,
		/obj/item/card_carp,
		/obj/item/device/camera_film)
	cant_hold = list(/obj/item/tool/knife/ritual/blade) // ...but not the sword. No cheating!

/obj/item/scroll/proc/ScrollBurn()
	var/mob/living/M = loc
	if(istype(M))
		M.drop_from_inventory(src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

// Mist: Invokes a blood rune that blocks laser projectiles, dissipating them.
/obj/item/scroll/proc/mist_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(50)
	bluespace_entropy(20, get_turf(src))
	new /obj/effect/decal/cleanable/blood_rune/mist(M.loc,main=RANDOM_RGB,shade=RANDOM_RGB)
	ScrollBurn()

// Shimmer: Invokes a blood rune that blocks both bullets; penetration weapons and rounds will still pierce.
/obj/item/scroll/proc/shimmer_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(50)
	bluespace_entropy(20, get_turf(src))
	new /obj/effect/decal/cleanable/blood_rune/shimmer(M.loc,main=RANDOM_RGB,shade=RANDOM_RGB)
	ScrollBurn()

// Smoke: Creates a smoke cloud centered around the caster
/obj/item/scroll/proc/smoke_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(25) //decently high just to protect server performance.
	var/datum/effect/effect/system/smoke_spread/chem/smoke = new
	var/datum/reagents/gas_storage = new /datum/reagents(100, src)
	gas_storage.add_reagent("crayon_dust_random", 100) //BLOOD MAGIC
	smoke.attach(src.loc)
	smoke.set_up(gas_storage, 12, 0, M.loc)
	spawn(0)
		smoke.start()
		sleep(10)
		smoke.start()
		sleep(10)
		smoke.start()
		sleep(10)
		smoke.start()
		sleep(10)
		qdel(smoke)
		qdel(gas_storage)
	ScrollBurn()

// Oil: Creates a pool of liquid fuel that can be burned to start a fire, or used with Floor Seal.
/obj/item/scroll/proc/oil_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(12)
	bluespace_entropy(10, get_turf(src))
	new /obj/effect/decal/cleanable/liquid_fuel(M.loc,300, 1) //considered a trap cause you instant ignite yourself XD
	ScrollBurn()

// Floor Seal: For every floor tile in sight that is covered by liquid fuel, this spell fixes them all.
/obj/item/scroll/proc/floor_seal_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(50)
	for(var/obj/effect/decal/cleanable/liquid_fuel/fixy_juice in oview(7))
		bluespace_entropy(1, get_turf(src)) //on a per juice basis
		for(var/obj/structure/multiz/ladder/burrow_hole/scary_hole in view(0, fixy_juice.loc))
			qdel(scary_hole)
		for(var/turf/simulated/floor/pot_hole in view(0, fixy_juice.loc))
			pot_hole.health = pot_hole.maxHealth
			pot_hole.broken = FALSE
			pot_hole.burnt = FALSE
			pot_hole.update_icon()
		qdel(fixy_juice)
	ScrollBurn()

// Light: Creates a rune on the floor that gives off light.
/obj/item/scroll/proc/light_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	var/obj/effect/decal/cleanable/blood_rune/light_rune = new /obj/effect/decal/cleanable/blood_rune(M.loc,main=RANDOM_RGB,shade=RANDOM_RGB)
	light_rune.set_light(5,4,"#FFFFFF")
	light_rune.name = "glowing rune"
	light_rune.desc = "A bright rune giving off vibrant light."
	light_rune.color = "#FFFF00"
	B.remove_self(10)
	bluespace_entropy(20, get_turf(src)) //high entropy cost. Low blood cost.
	ScrollBurn()

// Gaia: Every Mob seeable via the scroll when burned must pass a language check or be weakened 5:3; multiple blood mages nearby will flip the effect.
/obj/item/scroll/proc/gaia_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	bluespace_entropy(5, get_turf(src))
	B.remove_self(15)
	var/gaia_pulls = 5
	for(var/mob/T in oview(7))
		for(var/datum/language/L in T.languages)
			if(L.name == LANGUAGE_CULT)
				gaia_pulls -= 3
			if(L.name == LANGUAGE_OCCULT)
				gaia_pulls -= 2
		if(gaia_pulls)
			T.Weaken(gaia_pulls)

	if(M.get_inactive_hand() == src)
		M.drop_from_inventory(src)
	ScrollBurn()

// Eta: Every Mob seeable via the scroll when burned must past a language checks or be thrown backwards 8 to 12 spaces
/obj/item/scroll/proc/eta_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	bluespace_entropy(5, get_turf(src))
	B.remove_self(15)
	var/iron_mind = FALSE
	for(var/mob/T in oview(7))
		iron_mind = FALSE //So 1 blood mage doesn't block the whole thing
		for(var/datum/language/L in T.languages)
			if(L.name == LANGUAGE_CULT || L.name == LANGUAGE_OCCULT)
				iron_mind = TRUE
		if(!iron_mind)
			T.throw_at(get_step(T,reverse_direction(T.dir)),rand(8,12),30)

	if(M.get_inactive_hand() == src)
		M.drop_from_inventory(src)
	ScrollBurn()

// Reveal: Gives everyone in a 5x5 thermal vision for a few seconds then ends. Used for a quick reveal thru walls.
/obj/item/scroll/proc/reveal_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	bluespace_entropy(5, get_turf(src))
	B.remove_self(10) //low cost but for everyone effected.
	M.stats.addPerk(PERK_REVEAL) //removes self after a short amount of time.
	for(var/mob/living/carbon/human/T in oview(5))
		B = T.get_blood()
		bluespace_entropy(5, get_turf(src))
		B.remove_self(10) //low cost but for everyone effected.
		T.stats.addPerk(PERK_REVEAL) //removes self after a short amount of time.
	ScrollBurn()

// Entangle: Creates a ring of fairy light anomalies around the player to entangle mobs.
/obj/item/scroll/proc/entangle_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(10)
	var/turf/T = M.loc
	if(!T || T.is_space()) //do we have a turf? If not we make one! Land mass formed in spaaaaaaace!
		new /turf/simulated/floor/fixed/fgrass(M.loc)
		bluespace_entropy(50, M.loc)
		B.remove_self(10)
	for(var/turf/surround in oview(3))
		if(!surround.is_space())
			var/obj/structure/anomalies_diet/spidersilk/non_spreader/weave = new /obj/structure/anomalies_diet/spidersilk/non_spreader(surround)
			bluespace_entropy(5, M.loc)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel),weave), 3 MINUTES)
	ScrollBurn()

// Joke: Makes people in the radius of effect ether giggle, laugh or groan from the bad joke. Chance to be any of the 3 but everyone should match the type.
// This would go great in the trap rune.
/obj/item/scroll/proc/joke_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	var/outcome = pick("giggle", "laugh", "groan")
	M.say("*[outcome]")
	switch(outcome)
		if("giggle")
			B.remove_self(5)
			to_chat(M, SPAN_WARNING("This joke is alright."))
		if("laugh")
			to_chat(M, SPAN_WARNING("This joke is amazing! To bad the scroll went up in smoke."))
			M.sanity.changeLevel(25)
		if("groan")
			B.remove_self(15)
			to_chat(M, SPAN_WARNING("What a horrible joke. This scroll can't burn fast enough."))
			M.sanity.changeLevel(-25, TRUE)

	for(var/mob/living/carbon/human/T in oview(7))
		//to_chat for target
		T.say("*[outcome]")
		switch(outcome)
			if("giggle")
				to_chat(T, SPAN_WARNING("You hear a joke from [M], it fades from memory faster then you can remember it."))
			if("laugh")
				T.sanity.changeLevel(20)
				to_chat(T, SPAN_WARNING("You hear a good joke from [M], it fades from memory faster then you can remember it."))
			if("groan")
				T.sanity.changeLevel(-20, TRUE)
				to_chat(T, SPAN_WARNING("You hear a horrible joke from [M], it fades from memory faster then you can remember it."))
	ScrollBurn()


// Charger: Releases the wonderful electric anomalys that roam around.
/obj/item/scroll/proc/charger_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	B.remove_self(10)
	var/list/turf_list = list()
	var/again = TRUE

	for(var/turf/T in oview(5, get_turf(M)))
		if(T.Enter(src)) // If we can "enter" on the tile then we store it for potential spawning.
			turf_list += T
	if(!turf_list.len)
		//something went wrong!
		ScrollBurn()
	while(again == TRUE)
		var/obj/structure/anomalies_diet/ball_lightning/zappy = new /obj/structure/anomalies_diet/ball_lightning(pick(turf_list))
		to_chat(M, SPAN_WARNING("A loud crackling fills the air as something forms."))
		again = pick(TRUE, FALSE) //It will spawn more and more till it gets a bad flip on a 50/50 chance. How bad is your luck?
		//creates a callback, global_proc is a mystery to me. But the GLOBAL_PROC_REF() is actually required. As is the , between qdel and zappy. This fucking voodoo proc.
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel),zappy), 3 MINUTES)
	ScrollBurn()

/obj/item/scroll/attackby(obj/item/I, mob/living/carbon/human/M)
	..()
	if(istype(I, /obj/item/stack/wax) && !istype(I, /obj/item/scroll/sealed)) //seal the scroll
		var/obj/item/stack/wax/W = I
		if(W.amount < 1) //No you can't use part of the wax to seal the WHOLE scroll.
			return
		W.use(1)
		var/obj/item/scroll/sealed/wax_on = new /obj/item/scroll/sealed (src.loc)
		wax_on.message = message
		qdel(src)

	if(isflamesource(I)) //casts effects or just burns away if no spell works.

		if(M.species?.reagent_tag == IS_SYNTHETIC || M.species?.reagent_tag == IS_SLIME)
			to_chat(M, "<span class='warning'>You ignite the scroll. But nothing happens.</span>")
			ScrollBurn()
			return


/*
		if(message == "Example Spell.")
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			example_spell(M) //I cast proc!
			return
*/


		if(findtext(message, "Mist."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			mist_spell(M)
			return

		if(findtext(message, "Shimmer."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			shimmer_spell(M)
			return

		if(findtext(message, "Smoke."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			smoke_spell(M)
			return

		if(findtext(message, "Oil."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			oil_spell(M)
			return

		if(findtext(message, "Floor Seal."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			floor_seal_spell(M)
			return

		if(findtext(message, "Light."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash with a world twisting aura.</span>")
			light_spell(M)
			return

		if(findtext(message, "Gaia."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns the ashes sharply move downwards as the world's twisting aura straightens.</span>")
			gaia_spell(M)
			return

		if(findtext(message, "Eta."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash flying every direction away with a world pushing force.</span>")
			eta_spell(M)
			return

		if(findtext(message, "Reveal."))
			to_chat(M, "<span class='warning'>You ignite the scroll. It burns to ash, the smoke from the scroll pressing into peoples eyes.</span>")
			reveal_spell(M)
			return

		if(findtext(message, "Entangle."))
			to_chat(M, "<span class='warning'>You ignite the scroll. Soft bright silk weaves its way thru the air around you.</span>")
			entangle_spell(M)
			return

		if(findtext(message, "Joke."))
			to_chat(M, "<span class='warning'>You ignite the scroll. Words fill the page and you quickly read them off before suddenly forgetting them.</span>")
			joke_spell(M)
			return

		if(findtext(message, "Charger."))
			to_chat(M, "<span class='warning'>You ignite the scroll. Crackling fills the air. Static clings to everything.</span>")
			charger_spell(M)
			return

// If we don't cast anything then we end up doing a normal burn.
		to_chat(M, "<span class='warning'>You ignite the scroll. It burns for a few moments before becoming ash.</span>")
		ScrollBurn()
		return