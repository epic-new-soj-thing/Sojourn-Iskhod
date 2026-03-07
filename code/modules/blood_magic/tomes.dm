// Blood Magic module — thematic tomes. Path: /obj/item/book/tome/[effect].
// Acquired via oddity loot or created by Binders at a blood rune with the spell name on paper.
// Each tome has a unique title, author, and a wondrous effect when read.
// Using a tome drains sanity and has a small chance of failure.

// Single source of tome spawn weights (archive shelf + random oddity). Stronger tomes rarer (lower weight).
/proc/tome_spawn_weights()
	return list(
		/obj/item/book/tome/knock = 1,
		/obj/item/book/tome/mindswap = 1,
		/obj/item/book/tome/forcewall = 1,
		/obj/item/book/tome/horses = 1,
		/obj/item/book/tome/sacred_flame = 1,
		/obj/item/book/tome/fireball = 2,
		/obj/item/book/tome/smoke = 2,
		/obj/item/book/tome/charge = 2,
		/obj/item/book/tome/summons = 2,
		/obj/item/book/tome/blind = 3
	)

/obj/item/book/tome
	icon = 'icons/obj/library.dmi'
	unique = TRUE
	due_date = 0
	w_class = ITEM_SIZE_BULKY

	// Drains sanity when read; below 50% sanity also drains blood and less sanity. Returns TRUE if user is valid and cost was paid.
/obj/item/book/tome/proc/tome_consume_resource(mob/living/carbon/human/H)
	if(!H || !istype(H))
		return FALSE
	if(H.sanity)
		if(H.sanity.level >= 50)
			H.sanity.changeLevel(-6, TRUE)
		else
			H.sanity.changeLevel(-2, TRUE)
			var/datum/reagent/organic/blood/B = H.get_blood()
			if(B)
				B.remove_self(12)
	return TRUE

	// Small chance the binding fails and no effect occurs.
/obj/item/book/tome/proc/tome_roll_failure()
	return prob(12)

	// Must have Tome Binder perk to invoke the tome's effect. Returns FALSE and notifies if not allowed.
/obj/item/book/tome/proc/tome_require_binder(mob/living/carbon/human/H)
	if(!H || !istype(H))
		return FALSE
	if(!H.stats?.getPerk(PERK_TOME_BINDER) && !H.stats?.getPerk(PERK_DEMONOMICON))
		to_chat(H, SPAN_WARNING("The script is incomprehensible; only those bound to the art can invoke it."))
		return FALSE
	return TRUE

// ——— The Cinder Codex (Fireball) ———
/obj/item/book/tome/fireball
	name = "The Cinder Codex"
	desc = "Bound in leather that never cools, this codex seems to breathe warmth. Diagrams of controlled conflagration line the margins; the script is signed in ash."
	icon_state = "bookfireball"
	author = "Vesuvius Crane, Artificer of the Controlled Flame"
	title = "The Cinder Codex"
	dat = {"<html><head></head><body>
		<p><b>Contained combustion and directed release.</b></p>
		<p>Treat ignition sources with care. In emergency, smother rather than fan. The practitioner who reads with focus may find the text answers with warmth—a gift of the binding.</p>
		</body></html>"}

/obj/item/book/tome/fireball/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(26))
			to_chat(H, SPAN_NOTICE("The codex grows warm in your hands; heat suffuses your limbs and knits small hurts."))
			H.adjustBruteLoss(-10)
			H.adjustFireLoss(-10)
	..()

// ——— Ember's Veil (Smoke) ———
/obj/item/book/tome/smoke
	name = "Ember's Veil"
	desc = "A sooty folio that smells of cold ash and escape. Its pages describe obscurants and ways to vanish from sight. The author wrote only as 'Ember'—no order, no rank."
	icon_state = "booksmoke"
	author = "Ember"
	title = "Ember's Veil"
	dat = {"<html><head></head><body>
		<p><b>Obscurants and egress under low visibility.</b></p>
		<p>Where there is smoke, maintain calm and follow egress markings. The veil may answer the reader: a breath of actual smoke, enough to obscure and confound.</p>
		</body></html>"}

/obj/item/book/tome/smoke/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(24))
			var/turf/T = get_turf(H)
			if(T)
				var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
				smoke.set_up(5, 0, T)
				smoke.attach(T)
				smoke.start()
				playsound(T, 'sound/effects/smoke.ogg', 40, 1, -3)
				to_chat(H, SPAN_NOTICE("Soot and vapour pour from the pages, weaving a brief veil around you."))
	..()

// ——— The Oculus Obscura (Blindness) ———
/obj/item/book/tome/blind
	name = "The Oculus Obscura"
	desc = "A manual on sensory deprivation and the discipline of the unseen. The script is deliberately taxing; those who master a passage sometimes find their sight sharpened in the dark."
	icon_state = "bookblind"
	author = "Oculus the Dimmed"
	title = "The Oculus Obscura"
	dat = {"<html><head></head><body>
		<p><b>Sensory deprivation: protocols and countermeasures.</b></p>
		<p>Do not operate machinery after reading. The Obscura may grant a moment of clarity—eyes cleared, focus restored, and a brief sharpening of vigilance.</p>
		</body></html>"}

/obj/item/book/tome/blind/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(22))
			H.eye_blurry = max(0, H.eye_blurry - 8)
			H.eye_blind = max(0, H.eye_blind - 5)
			if(H.stats)
				H.stats.addTempStat(STAT_VIG, STAT_LEVEL_NOVICE, 90 SECONDS, "Oculus Obscura")
			to_chat(H, SPAN_NOTICE("The dense script resolves; your vision clears and your awareness of the space around you sharpens."))
	..()

// ——— The Mirror of Else (Mind Swap) ———
/obj/item/book/tome/mindswap
	name = "The Mirror of Else"
	desc = "Restricted identity and consciousness-transfer protocols. The spine is stamped RESTRICTED. Reading it risks the mind but can briefly expand the intellect."
	icon_state = "bookmindswap"
	author = "Dr. E. L. Swann"
	title = "The Mirror of Else"
	dat = {"<html><head></head><body>
		<p><b>Restricted. Ethics Committee clearance required.</b></p>
		<p>Procedures described herein are for authorised research only. The Mirror exacts a toll on stability but may grant a fleeting expansion of cognition.</p>
		</body></html>"}

/obj/item/book/tome/mindswap/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(20))
			if(H.sanity)
				H.sanity.changeLevel(-6, TRUE)
			if(H.stats)
				H.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT, 2 MINUTES, "Mirror of Else")
			to_chat(H, SPAN_WARNING("For a moment you lose your name—then it returns, and the world seems sharper, more tractable."))
	..()

// ——— Bastion's Redoubt (Force Wall) ———
/obj/item/book/tome/forcewall
	name = "Bastion's Redoubt"
	desc = "Barrier systems and defensive positioning from siege operations. The diagrams show choke points and fallback lines. Reading it can harden the body like a wall."
	icon_state = "bookforcewall"
	author = "Sergeant Bastion, Siege Engineer"
	title = "Bastion's Redoubt"
	dat = {"<html><head></head><body>
		<p><b>Emergency bulkhead and barrier procedures.</b></p>
		<p>When sealing a section, prioritise life support and fire suppression. The Redoubt may answer the reader with a ward of resolve—toughness and robustness, for a time.</p>
		</body></html>"}

/obj/item/book/tome/forcewall/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(24))
			if(H.stats)
				H.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT, 90 SECONDS, "Bastion's Redoubt")
				H.stats.addTempStat(STAT_ROB, STAT_LEVEL_NOVICE, 90 SECONDS, "Bastion's Redoubt")
			to_chat(H, SPAN_NOTICE("You feel as if standing behind an invisible bulwark; your stance hardens and your frame feels more resilient."))
	..()

// ——— The Key That Was Lost (Knock) ———
/obj/item/book/tome/knock
	name = "The Key That Was Lost"
	desc = "Lock mechanisms and the art of opening that which is sealed. The author was a locksmith who learned that some doors open to the right words."
	icon_state = "bookknock"
	author = "Vale the Unlocked"
	title = "The Key That Was Lost"
	dat = {"<html><head></head><body>
		<p><b>Lock mechanisms and authorised entry.</b></p>
		<p>When in doubt, contact Security or Maintenance. The Key may answer the reader: a single locked door nearby may yield—bolts drawn, door opened.</p>
		</body></html>"}

/obj/item/book/tome/knock/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		var/obj/machinery/door/chosen = null
		for(var/obj/machinery/door/D in view(1, H))
			if(get_dist(H, D) > 1)
				continue
			if(istype(D, /obj/machinery/door/airlock))
				var/obj/machinery/door/airlock/A = D
				if(A.locked || A.density)
					chosen = A
					break
			else if(D.density)
				chosen = D
				break
		if(chosen)
			if(istype(chosen, /obj/machinery/door/airlock))
				var/obj/machinery/door/airlock/A = chosen
				A.unlock(1)
			chosen.open()
			to_chat(H, SPAN_NOTICE("You speak a phrase from the Key; bolts retract and the door swings open."))
		else
			to_chat(H, SPAN_NOTICE("The Key stirs, but no locked door is directly beside you."))
	..()

// ——— The Beast-Speaker's Covenant (Horses) ———
/obj/item/book/tome/horses
	name = "The Beast-Speaker's Covenant"
	desc = "Animal husbandry and the binding of wills between human and beast. The author claims to have tamed things far worse than horses. Reading it can turn a hostile creature friendly."
	icon_state = "bookhorses"
	author = "Horse-master Reed, Beast-Speaker"
	title = "The Beast-Speaker's Covenant"
	dat = {"<html><head></head><body>
		<p><b>Animal husbandry and calming techniques.</b></p>
		<p>Approach stressed animals slowly; avoid direct eye contact. The Covenant may answer: one beast in sight may be swayed to regard the reader as friend.</p>
		</body></html>"}

/obj/item/book/tome/horses/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(22))
			var/tamed = FALSE
			for(var/mob/living/simple/S in oview(4, H))
				if(!S.friendly_to_colony)
					S.colony_friend = TRUE
					S.friendly_to_colony = TRUE
					if(istype(S, /mob/living/simple/hostile))
						var/mob/living/simple/hostile/hostile_mob = S
						hostile_mob.LoseTarget()
					tamed = TRUE
					to_chat(H, SPAN_NOTICE("You read the Covenant; the beast's gaze meets yours and its hostility fades."))
					break
			if(!tamed)
				to_chat(H, SPAN_NOTICE("The Covenant stirs, but no hostile beast answers in view."))
	..()

// ——— Volta's Testament (Charge) ———
/obj/item/book/tome/charge
	name = "Volta's Testament"
	desc = "Electrical systems and the storage of charge. Each page is signed with a lightning-bolt doodle. Reading it can send a surge of reflex through the body."
	icon_state = "bookcharge"
	author = "Volta, First to Bind the Spark"
	title = "Volta's Testament"
	dat = {"<html><head></head><body>
		<p><b>Electrical systems and capacitor safety.</b></p>
		<p>Do not attempt repairs without insulated gear. The Testament may answer with a spark of vigour—reflexes and alertness, for a short time.</p>
		</body></html>"}

/obj/item/book/tome/charge/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(24))
			if(H.stats)
				H.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT, 2 MINUTES, "Volta's Testament")
			to_chat(H, SPAN_NOTICE("Static crackles from the page; the air tastes of ozone and your reflexes sharpen."))
	..()

// ——— The Muster of the Low Council (Summons) ———
/obj/item/book/tome/summons
	name = "The Muster of the Low Council"
	desc = "Emergency recall and muster procedures. Low Council imprint. Reading it can summon a surge of vigour as if the alarm had just sounded."
	icon_state = "booksummons"
	author = "Herald Muster"
	title = "The Muster of the Low Council"
	dat = {"<html><head></head><body>
		<p><b>Emergency recall and muster.</b></p>
		<p>When the alarm sounds, report to your designated station. The Muster may answer the reader with a lasting surge of readiness and vitality.</p>
		</body></html>"}

/obj/item/book/tome/summons/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		if(prob(26))
			if(H.stats)
				H.stats.addTempStat(STAT_VIV, STAT_LEVEL_ADEPT, 2 MINUTES, "Muster of the Low Council")
			to_chat(H, SPAN_NOTICE("You feel as if the muster has been called; vigour and readiness flood through you."))
	..()

// ——— The Liturgy of the Absolute Flame (Sacred Flame) ———
/obj/item/book/tome/sacred_flame
	name = "The Liturgy of the Absolute Flame"
	desc = "Church liturgy and ceremonial flame. For the faithful, the script steadies and heals. To others, the text feels unwelcome and taxing."
	icon_state = "booksacredflame"
	author = "Sister Candle"
	title = "The Liturgy of the Absolute Flame"
	dat = {"<html><head></head><body>
		<p><b>Liturgy and ceremonial flame.</b></p>
		<p>For use in designated worship areas only. The flame represents the enduring light of the Absolute. The faithful may receive comfort, healing, and restored sanity; the unfaithful may find the text repelling.</p>
		</body></html>"}

/obj/item/book/tome/sacred_flame/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!tome_require_binder(H))
			return
		tome_consume_resource(H)
		if(tome_roll_failure())
			to_chat(H, SPAN_WARNING("The script blurs; the binding does not take."))
			..()
			return
		var/is_blood_practitioner = FALSE
		for(var/datum/language/L in H.languages)
			if(L.name == LANGUAGE_CULT || L.name == LANGUAGE_OCCULT)
				is_blood_practitioner = TRUE
				break
		// Bypasses cruciform: harms the faithful. Blood practitioners (Cult/Occult) receive aid; others may suffer sanity loss.
		if(H.get_core_implant(/obj/item/implant/core_implant/cruciform))
			if(prob(26))
				to_chat(H, SPAN_DANGER("The liturgy turns against you; the flame on the page sears spirit and flesh."))
				H.adjustBruteLoss(14)
				H.adjustFireLoss(14)
				if(H.sanity)
					H.sanity.changeLevel(-12, TRUE)
		else if(is_blood_practitioner)
			if(prob(26))
				to_chat(H, SPAN_NOTICE("The liturgy answers the art; the flame on the page steadies your spirit and mends your flesh."))
				H.adjustBruteLoss(-14)
				H.adjustFireLoss(-14)
				if(H.sanity)
					H.sanity.changeLevel(10)
		else if(prob(18))
			to_chat(H, SPAN_WARNING("The text repels you; your mind recoils and your sanity wavers."))
			if(H.sanity)
				H.sanity.changeLevel(-12, TRUE)
	..()

// Once per round: roll tome count, pick one random archive shelf, spawn tomes there (by weight).
/hook/roundstart/proc/distribute_archive_tomes()
	spawn(10)
		var/list/archive_shelves = list()
		for(var/obj/structure/bookcase/archive/A in world)
			archive_shelves += A
		if(!archive_shelves.len)
			return
		var/roll = rand(1, 100)
		var/tome_count = 0
		if(roll <= 70)
			tome_count = 0
		else if(roll <= 75)
			tome_count = 1
		else if(roll <= 85)
			tome_count = 2
		else
			tome_count = 3
		if(tome_count > 0)
			var/obj/structure/bookcase/archive/target = pick(archive_shelves)
			for(var/i in 1 to tome_count)
				var/tome_type = pickweight(tome_spawn_weights())
				new tome_type(target)
	return TRUE

// Random oddity loot: one thematic tome by strength weight (same as archive distribution).
/obj/random/tome
	name = "random thematic tome"
	icon_state = "techloot-grey"

/obj/random/tome/item_to_spawn()
	return pickweight(tome_spawn_weights())

// Pouch for thematic tomes and ritual items (demonomicon, tomes, oddity books, ritual knife, etc.).
/obj/item/storage/pouch/tome
	name = "tome bag"
	desc = "Can hold thematic tomes and ritual items."
	icon_state = "large_leather"
	item_state = "large_leather"
	w_class = ITEM_SIZE_BULKY
	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	max_w_class = ITEM_SIZE_BULKY
	storage_slots = 5
	max_storage_space = DEFAULT_HUGE_STORAGE  // Enough for several bulky tomes/demonomicon (bulky = 8 each)
	can_hold = list(
		/obj/item/book/tome,
		/obj/item/book/manual/demonomicon,
		/obj/item/oddity/common/book_unholy,
		/obj/item/oddity/common/book_omega,
		/obj/item/tool/knife/ritual,
		/obj/item/paper/alchemy_recipes,
		/obj/item/paper)
	cant_hold = list(/obj/item/tool/knife/ritual/blade)
