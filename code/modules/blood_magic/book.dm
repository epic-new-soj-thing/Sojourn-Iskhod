// Blood Magic module - book (type 3) spell procs.

// Babel: Grants you knowledge of the Cult language.
// This is a requirement for the ritual spells.
/obj/effect/decal/cleanable/blood_rune/proc/babel_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	M.add_language(LANGUAGE_CULT)
	to_chat(M, "<span class='warning'>Your head throbs like a maddening heartbeat, eldritch knowledge gnawing open the doors of your psyche and crawling inside, granting you a glimpse of languages older than time itself. The heart pounds in synchrony, making up for the price of blood in exchange.</span>")
	playsound(M, 'sound/effects/singlebeat.ogg', 100)
	var/cost = src.health_spell_cost(M, 20)
	M.maxHealth -= cost
	M.health -= cost
	B.remove_self(25)
	M.sanity.changeLevel(-5, TRUE)
	M.unnatural_mutations.total_instability += 15
	return

// Ignorance: Basically become impervious to telepathic messages from psions. Will stop you from being able to use psionics if you have them.
/obj/effect/decal/cleanable/blood_rune/proc/ignorance_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	M.psi_blocking_additive = 20
	to_chat(M, "<span class='warning'>Your mind feels like an impenetrable fortress against psionic assaults. Your heart is beating like a drum, exerting itself to recover the blood paid for your boon.</span>")
	var/cost = src.health_spell_cost(M, 5)
	M.maxHealth -= cost
	M.health -= cost
	B.remove_self(25)
	M.sanity.changeLevel(-35, TRUE)
	return

// Life: Revives a dead animal on top of the rune.
/obj/effect/decal/cleanable/blood_rune/proc/life_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	for(var/mob/living/carbon/superior/greater in oview(1)) // Must be on the spell circle

		if(!body_checks(M))
			return
		if(!able_to_cast)
			return

		if(M.maxHealth > 30)
			to_chat(M, "<span class='warning'>Gung vf abg qrnq juvpu pna rgreany yvr, naq jvgu fgenatr nrbaf rira qrngu znl qvr.</span>") // Guess the language and the phrase.
			greater.revive()
			greater.colony_friend = TRUE
			greater.friendly_to_colony = TRUE
			greater.friends += M
			greater.faction = "Living Dead"
			greater.maxHealth *= 0.5
			greater.health *= 0.5
			var/cost = src.health_spell_cost(M, 25)
			M.maxHealth -= cost
			M.health -= cost
			B.remove_self(18)
			M.sanity.changeLevel(-10, TRUE)
			return
		return

	for(var/mob/living/simple/lesser in oview(1)) // Must be on the spell circle

		if(!body_checks(M))
			return
		if(!able_to_cast)
			return

		if(M.maxHealth > 30)
			to_chat(M, "<span class='info'>Gung vf abg qrnq juvpu pna rgreany yvr, naq jvgu fgenatr nrbaf rira qrngu znl qvr.</span>")
			lesser.revive()
			lesser.colony_friend = TRUE
			lesser.friendly_to_colony = TRUE
			lesser.faction = "Living Dead"
			lesser.maxHealth *= 0.5
			lesser.health *= 0.5
			var/cost = src.health_spell_cost(M, 25)
			M.maxHealth -= cost
			M.health -= cost
			B.remove_self(25)
			M.sanity.changeLevel(-10, TRUE)
			return
		return
	return

// Madness: Become weaker, and cause a sanity breakdown upon yourself.
/obj/effect/decal/cleanable/blood_rune/proc/madness_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	to_chat(M, "<span class='warning'>Your blood runs thin as you catch a glimpse of forbidden aeons, shortening your lifespan as you come to terms with your feeble inconsequentiality on the greater scheme of things.</span>")
	var/cost = src.health_spell_cost(M, 5)
	M.maxHealth -= cost
	M.health -= cost
	B.remove_self(10)
	M.sanity.breakdown(TRUE)
	M.sanity.changeLevel(30)
	return

// Sight: Removes your Nearsighted and blind disabilities, if you have them
// Removes nearsightedness (and optionally blindness). Nearsightedness is not required for blood magic but aids efficacy.
/obj/effect/decal/cleanable/blood_rune/proc/sight_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	if(M.disabilities&NEARSIGHTED)
		M.disabilities &= ~NEARSIGHTED
	if(M.disabilities&BLIND)
		M.disabilities &= ~BLIND
	to_chat(M, "<span class='warning'>Your vision is impaired no more, your heart stresses itself to recover the blood paid for your blinding to the dark arts. The eyes deceive, true perception will be achieved without their hindrance.</span>")
	B.remove_self(75)
	M.sanity.changeLevel(30)
	return

// Paradox: Literally kill yourself. No really, this removes a lot of blood, causes a sanity breakdown upon the character
// And on top of it causes an explosion centered on the rune, most likly totally gibbing them.
/obj/effect/decal/cleanable/blood_rune/proc/paradox_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	to_chat(M, "<span class='warning'>The air around you grows hot, your heart races as a feeling of dread washes over you. You hear a faint whisper in the back of your head, \"Upside, downside... all cardinal directions, an illusion...\"</span>")
	var/cost = src.health_spell_cost(M, 25)
	M.maxHealth -= cost
	M.health -= cost
	B.remove_self(50)
	M.sanity.breakdown(TRUE)
	sleep(30)
	explosion(loc, 3, 5, 7, 5)
	M.sanity.changeLevel(100)
	// We log this for admins as it can be easily used for griefing and it causes quite the explosion.
	log_and_message_admins("[M] has used the Paradox blood spell, causing an explosion at \the [jumplink(M)] X:[M.x] Y:[M.y] Z:[M.z].")
	return

// The End: Removes your nearsighted disability, but also your knowledge of cult and occult languages
// Basically wiping yourself clean of everything caused by blood magic, but making you unable to cast spells again
/obj/effect/decal/cleanable/blood_rune/proc/end_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	to_chat(M, "<span class='warning'>The truth of the universe flashes before your eyes at a sickening speed, eldritch knowledge being forcefully vacuumed out of your psyche. The light! It burns! IT BURNS!!!</span>")
	M.disabilities &= ~NEARSIGHTED | ~BLIND
	B.remove_self(75)
	M.sanity.breakdown(TRUE)
	M.sanity.changeLevel(5)
	for(var/datum/language/L in M.languages)
		if(L.name == LANGUAGE_CULT)
			M.remove_language(LANGUAGE_CULT)
			M.maxHealth += 5 // Give us a small amount of health back too
			M.health += 5
		if(L.name == LANGUAGE_OCCULT)
			M.remove_language(LANGUAGE_OCCULT)
			M.maxHealth += 5
			M.health += 5
	return

// Flux: Causes additional bluespace entropy upon the world. Truly devilish.
// Causes more entropy if you know both Cult and Occult language
/obj/effect/decal/cleanable/blood_rune/proc/flux_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	var/area/my_area = get_area(src)
	to_chat(M, "<span class='warning'>Reality itself fluctuates around you as a canvas of impending doom. The truth behind the heat death of the universe draws ever nearer, thugged by your strings...</span>")
	my_area.bluespace_hazard_threshold -= 1
	GLOB.bluespace_hazard_threshold -= 1
	bluespace_entropy(1, get_turf(src), TRUE)
	B.remove_self(25)
	M.sanity.changeLevel(15)
	playsound(loc, 'sound/effects/cascade.ogg') // Fitting.
	log_and_message_admins("[M] has used the Flux spell, increasing the world's bluespace entropy")
	for(var/datum/language/L in M.languages)
		if(L.name == LANGUAGE_CULT)
			my_area.bluespace_hazard_threshold -= 5
			GLOB.bluespace_hazard_threshold -= 5
			bluespace_entropy(5, get_turf(src), TRUE)
		if(L.name == LANGUAGE_OCCULT)
			my_area.bluespace_hazard_threshold -= 5
			GLOB.bluespace_hazard_threshold -= 5
			bluespace_entropy(5, get_turf(src), TRUE)
	return

// Negentropy: Increases the threshold at which bluespace related incidents ocurr, and reduces bluespace entropy slightly
// Those with knowledge of Occult and Cult languages give it an extra bonus
/obj/effect/decal/cleanable/blood_rune/proc/negentropy_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	var/area/my_area = get_area(src)
	to_chat(M, "<span class='info'>The threads of creation itself are spun anew, a feeling of inextricable tranquility permeates your thoughts. For reasons perhaps unbeknownst to you, the death heat of the universe strays further away...</span>")
	my_area.bluespace_hazard_threshold += 1
	GLOB.bluespace_hazard_threshold += 1
	bluespace_entropy(-5, get_turf(src))
	B.remove_self(30) //Takes more to heal then harm
	M.sanity.changeLevel(-15, TRUE)
	for(var/datum/language/L in M.languages)
		if(L.name == LANGUAGE_CULT)
			my_area.bluespace_hazard_threshold += 5
			GLOB.bluespace_hazard_threshold += 5
			bluespace_entropy(-5, get_turf(src))
		if(L.name == LANGUAGE_OCCULT)
			my_area.bluespace_hazard_threshold += 5
			GLOB.bluespace_hazard_threshold += 5
			bluespace_entropy(-5, get_turf(src))
	return

// Brew: Grants you the Alchemist perk, and access to all the recipes required by it
/obj/effect/decal/cleanable/blood_rune/proc/brew_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	if(M.stats.getPerk(PERK_SCRIBE))
		to_chat(M, SPAN_WARNING("The paths of the Alchemist and the Scribe are mutually exclusive."))
		return
	if(M.stats.getPerk(PERK_TOME_BINDER))
		to_chat(M, SPAN_WARNING("The paths of the Alchemist and the Tome Binder are mutually exclusive."))
		return
	var/cost = src.health_spell_cost(M, 25)
	M.maxHealth -= cost
	M.health -= cost
	B.remove_self(25)
	M.stats.addPerk(PERK_ALCHEMY)
	M.sanity.changeLevel(15)
	to_chat(M, "<span class='warning'>Your mind expands with knowledge of alchemical components, recipes for crafts lost to time, forbidden transmutations. Your body feels extremely weak...</span>")
	return

// Bees: NOT THE BEES!! Invokes a gigantic bee per sunflower on a five-tiles radius around the spell circle
/obj/effect/decal/cleanable/blood_rune/proc/bees_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	var/cost = src.health_spell_cost(M, 10)
	M.maxHealth -= cost
	M.health -= cost
	for(var/obj/item/reagent_containers/snacks/grown/G in oview(5))

		if(!body_checks(M))
			return

		if(G.name == "sunflower") // Apply all costs ONLY if the plant is the correct one!!!
			to_chat(M, "<span class='info'>Distant voices scream in agony from every direction: NOT THE BEES!</span>")
			new /mob/living/carbon/superior/vox/wasp(G.loc)
			B.remove_self(18)
			M.sanity.changeLevel(4)
			qdel(G)
	return

// Sky: / Above:
// Converts a open omega book (or fully-awakened demonomicon) into a drawing of the sun, a oddity with a perk that exspands the skill cap by 30 points.
/obj/effect/decal/cleanable/blood_rune/proc/sun_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	var/cost = src.health_spell_cost(M, 5)
	M.maxHealth -= cost
	M.health -= cost
	for(var/obj/item/oddity/common/book_omega/opened/BOOK in oview(3))
		to_chat(M, "<span class='info'>A cold voice creeks. </span><span class='angelsay'> With this messy canvas, I can only provide you a glance of that.</span>")
		if(!body_checks(M))
			to_chat(M, "<span class='info'>A cold voice sighs. </span><span class='angelsay'> You will not do. Waste the others time.</span>")
			bluespace_entropy(3, get_turf(src)) //Wasting an artists time is rather rude
			return
		to_chat(M, "<span class='info'>The pages of [BOOK.name] slowly turn into paint.</span>")
		new /obj/item/oddity/rare/drawing_of_sun(BOOK.loc)
		B.remove_self(70) //Base is 540
		qdel(BOOK)
		return
	for(var/obj/item/book/manual/demonomicon/BOOK in oview(3))
		to_chat(M, "<span class='info'>A cold voice creeks. </span><span class='angelsay'> With this messy canvas, I can only provide you a glance of that.</span>")
		if(!body_checks(M))
			to_chat(M, "<span class='info'>A cold voice sighs. </span><span class='angelsay'> You will not do. Waste the others time.</span>")
			bluespace_entropy(3, get_turf(src))
			return
		to_chat(M, "<span class='info'>The pages of [BOOK.name] slowly turn into paint.</span>")
		new /obj/item/oddity/rare/drawing_of_sun(BOOK.loc)
		B.remove_self(70)
		qdel(BOOK)
		return
	return

// Pouch: Spawns a pouch with a dimensional-linked shared storage. Every person holding one of these can access the same storage from anywhere.
// Works only if the pouch is opened, and accessed while being held in-hand
/obj/effect/decal/cleanable/blood_rune/proc/pouch_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	for(var/obj/item/storage/pill_bottle/dice/frodo in oview(1))
		if(!body_checks(M)) //inside cause we have a reocuring blood cost inside.
			return
		B.remove_self(25)
		M.sanity.changeLevel(-50, TRUE) //not always going to break you. But will tank your sanity.
		to_chat(M, "<span class='warning'>The dice bag gives a loud pop.</span>")
		new /obj/item/blood_pouch(frodo.loc)
		qdel(frodo)
	return

// Escape: Deletes and kicks you out of the game
/obj/effect/decal/cleanable/blood_rune/proc/escape_spell(mob/living/carbon/human/M)
	var/datum/reagent/organic/blood/B = M.get_blood()
	var/obj/item/oddity/common/mirror/doodle/ocm = new /obj/item/oddity/common/mirror/doodle(src.loc)
	B.remove_self(18) //We still take some blood for this
	to_chat(M, "<span class='warning'>[M.real_name] stepped into a fragment of a mirror.</span>")
	ocm.name = "[M.real_name]'s fragments."
	ocm.desc = "A thousand doodles of [M.real_name] in blood stare back at you as you examine the trinket."

	var/job = M.mind.assigned_role
	log_and_message_admins("[key_name(M)]" + "[M.mind ? " ([M.mind.assigned_role])" : ""]" + " entered a colouring book.")


	SSjob.FreeRole(job)
	clear_antagonist(M.mind)

	// Delete them from datacore.

	if(PDA_Manifest.len)
		PDA_Manifest.Cut()
	for(var/datum/data/record/R in data_core.medical)
		if ((R.fields["name"] == M.real_name))
			qdel(R)
	for(var/datum/data/record/T in data_core.security)
		if ((T.fields["name"] == M.real_name))
			qdel(T)
	for(var/datum/data/record/G in data_core.general)
		if ((G.fields["name"] == M.real_name))
			qdel(G)
	// Remove the mob's record.
	var/datum/computer_file/report/crew_record/record
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records) // loop through the records
		if(M.mind.name == CR.get_name()) // Check the mind's name to the record's name
			record = CR
			break

	record?.Destroy() // Delete the crew record

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		// Were in a colouring book now...
		if(O.target == M.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, "<span class='warning'>You get the feeling your target is no longer within your reach...</span>")
			qdel(O)

	//Same for contract-based objectives.
	for(var/datum/antag_contract/contract in GLOB.excel_antag_contracts)
		contract.on_mob_despawned(M.mind)


	SSjob.FreeRole(job)
	M.client.ckey = null
	M.dust(anim = FALSE, remains = /obj/effect/overlay/pulse)
	return

// Scribe: Gives you the Scribe perk. This is a requirement for inscribing scrolls with the spells below. Incompatible with Alchemist.
/obj/effect/decal/cleanable/blood_rune/proc/scribe_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	var/mob/living/carbon/human/H = M
	for(var/obj/item/paper/P in oview(1)) // Requires a paper
		if(!body_checks(M))
			return
		if(H.stats.getPerk(PERK_ALCHEMY))
			to_chat(M, SPAN_WARNING("The paths of the Scribe and the Alchemist are mutually exclusive."))
			return
		if(H.stats.getPerk(PERK_TOME_BINDER))
			to_chat(M, SPAN_WARNING("The paths of the Scribe and the Tome Binder are mutually exclusive."))
			return
		if(H.stats.getPerk(PERK_SCRIBE))
			to_chat(M, SPAN_WARNING("You already are a scribe."))
			return
		M.stats.addPerk(PERK_SCRIBE)
		M.sanity.changeLevel(20)
		B.remove_self(50)
		var/cost = src.health_spell_cost(M, 25)
		M.maxHealth -= cost
		M.health -= cost
		to_chat(M, "<span class='warning'>Your head throbs like a heartbeat, the sudden insight of knowledge on how to pen down your dissasociated thoughts into scrolls fogs your eyes, until you can see no more.</span>")
		qdel(P)
	return

// Binder: Gives you the Tome Binder perk. Required to create thematic tomes at the rune. Can be taken alongside Alchemist.
/obj/effect/decal/cleanable/blood_rune/proc/binder_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	var/mob/living/carbon/human/H = M
	for(var/obj/item/paper/P in oview(1))
		if(!body_checks(M))
			return
		if(H.stats.getPerk(PERK_ALCHEMY))
			to_chat(M, SPAN_WARNING("The paths of the Tome Binder and the Alchemist are mutually exclusive."))
			return
		if(H.stats.getPerk(PERK_SCRIBE))
			to_chat(M, SPAN_WARNING("The paths of the Tome Binder and the Scribe are mutually exclusive."))
			return
		if(H.stats.getPerk(PERK_TOME_BINDER))
			to_chat(M, SPAN_WARNING("You already know how to bind tomes."))
			return
		M.stats.addPerk(PERK_TOME_BINDER)
		B.remove_self(30)
		M.sanity.changeLevel(-8, TRUE)
		to_chat(M, "<span class='info'>The rune imprints the art of binding knowledge into lasting form. You may now create thematic tomes with an opened book or the Demonomicon.</span>")
		qdel(P)
		return
	to_chat(M, SPAN_WARNING("Place a paper on the rune to learn the binding art."))
	return

// Awaken: Evolve our Ritual Knife into a greater form.
// It can be used once more upon the harvester for it to become a blade
/obj/effect/decal/cleanable/blood_rune/proc/awaken_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return

	for(var/obj/item/tool/knife/ritual/knifey in oview(1)) // No ascending church knives

		if(!body_checks(M))
			return

		if(istype(knifey, /obj/item/tool/knife/ritual) && !istype(knifey, /obj/item/tool/knife/ritual/sickle) && !istype(knifey, /obj/item/tool/knife/ritual/blade))
			to_chat(M, "<span class='warning'>Your weapon twists its form, metal bending as if it were flesh with a sickening crunch!</span>")
			playsound(loc, 'sound/items/biotransform.ogg', 50)
			new /obj/item/tool/knife/ritual/sickle(knifey.loc)
			B.remove_self(50)
			var/cost = src.health_spell_cost(M, 5)
			M.maxHealth -= cost
			M.health -= cost
			M.sanity.changeLevel(-5, TRUE)
			qdel(knifey)
		if(istype(knifey, /obj/item/tool/knife/ritual/sickle) && !istype(knifey, /obj/item/tool/knife/ritual/blade))
			to_chat(M, "<span class='warning'>Your weapon twists its form, metal bending as if it were flesh with a sickening crunch as is ascends into its final form!</span>")
			playsound(loc, 'sound/items/biotransform.ogg', 50)
			new /obj/item/tool/knife/ritual/blade(knifey.loc)
			B.remove_self(50)
			var/cost = src.health_spell_cost(M, 5)
			M.maxHealth -= cost
			M.health -= cost
			M.sanity.changeLevel(-10, TRUE)
			qdel(knifey)
	return

/****************************/
/*ALCHEMY SPELLS PROCS START*/
/****************************/

// Recipe: Uses a piece of paper on the rune to invoke writings of alchemical reactions written on it.
/obj/effect/decal/cleanable/blood_rune/proc/recipe_spell(mob/living/carbon/human/M, alchemist = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	for(var/obj/item/paper/P in oview(1)) // Must be on the spell circle

		if(!body_checks(M))
			return

		if(alchemist)
			to_chat(M, "<span class='info'>The echoing sound of scribbling fills the air.</span>")
			playsound(loc, 'sound/bureaucracy/pen1.ogg')
			B.remove_self(10)
			M.sanity.changeLevel(-2, TRUE)
			var/obj/item/paper/alchemy_recipes/S = new /obj/item/paper/alchemy_recipes
			S.loc = P.loc
			qdel(P)
		else
			to_chat(M, SPAN_WARNING("You lack the alchemical inspiration to write a revelation in paper."))
			return
	return

// Tome: Binder-only. Consumes a paper on the rune to create a thematic tome (path: /obj/item/book/tome/[effect]).
// Only an opened book (Omega or Unholy) or the Demonomicon may be used to create tomes.
/obj/effect/decal/cleanable/blood_rune/proc/tome_spell(mob/living/carbon/human/M, tome_path, able_to_cast = FALSE, obj/item/book_or_oddity = null)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return
	var/can_bind = M.stats.getPerk(PERK_TOME_BINDER) || istype(book_or_oddity, /obj/item/book/manual/demonomicon)
	if(!can_bind)
		to_chat(M, SPAN_WARNING("Only one who has learned the binding art (Binder. spell at a rune) can create a tome here—or use the Demonomicon."))
		return
	if(!book_or_oddity || (!istype(book_or_oddity, /obj/item/book/manual/demonomicon) && !istype(book_or_oddity, /obj/item/oddity/common/book_omega/opened) && !istype(book_or_oddity, /obj/item/oddity/common/book_unholy/opened)))
		to_chat(M, SPAN_WARNING("Only an opened book (Omega or Unholy) or the Demonomicon can bind a tome. Use the Ascension. spell to open a closed book."))
		return
	for(var/obj/item/paper/P in oview(1))
		if(!body_checks(M))
			return
		to_chat(M, "<span class='info'>The rune drinks from the paper; script flows from the page into something heavier.</span>")
		playsound(loc, 'sound/bureaucracy/pen1.ogg', 50)
		B.remove_self(20)
		M.sanity.changeLevel(-5, TRUE)
		var/obj/item/book/tome/T = new tome_path(P.loc)
		T.loc = P.loc
		qdel(P)
		return
	to_chat(M, SPAN_WARNING("No paper lies upon the rune to bind into a tome."))

// Satchel: Alchemist only - turn a blood pouch into an alchemy satchel
/obj/effect/decal/cleanable/blood_rune/proc/satchel_spell(mob/living/carbon/human/M, able_to_cast = FALSE)
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!able_to_cast)
		return
	for(var/obj/item/blood_pouch/pouch in oview(1))
		if(!body_checks(M))
			return
		B.remove_self(25)
		M.sanity.changeLevel(-30, TRUE)
		to_chat(M, "<span class='warning'>The pouch warps and stiffens into a leather satchel.</span>")
		new /obj/item/storage/pouch/alchemy(pouch.loc)
		qdel(pouch)
		return
	to_chat(M, SPAN_WARNING("Place a blood pouch on the rune to invoke the satchel."))
