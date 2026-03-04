// Blood Magic module — runes and invocation.
// Base rune decal, mist/shimmer/trap subtypes, attackby (book/knife/scroll), spell routing, body checks.
// Pen-written paper has a chance to fail when invoked; blood-written paper always works.
#define PEN_INVOKE_SUCCESS 65  // Probability (0-100) that a pen-written inscription succeeds when invoked.
#define RED_CRAYON_BONUS 20  // Red crayon (only) gets this much higher success chance when invoked.
#define NON_NEARSIGHTED_FAIL_CHANCE 10  // If not nearsighted, this % chance the ritual fails (on top of any other checks).
#define FAILURE_BLOOD_COST 12  // Blood drawn from caster when a rune invocation fails (pen binding or nearsighted focus; max health is not drained).

/// Effective maxhp for reduction: blood percentage + maxhp until 50% of total; above 50% only maxhp applies.
/mob/living/carbon/human/proc/get_effective_maxhp()
	var/total = species ? species.total_health : 100
	if(maxHealth >= total * 0.5)
		return maxHealth
	return min(get_blood_volume() + maxHealth, total * 0.5)

/// Applies a max HP (and current health) cost using effective maxhp; never reduces below 25% of total.
/mob/living/carbon/human/proc/apply_max_hp_cost(cost)
	var/total = species ? species.total_health : 100
	var/ritual_floor = total * 0.25
	var/effective = get_effective_maxhp()
	var/actual = min(cost, effective - ritual_floor, maxHealth - ritual_floor)
	actual = max(0, actual)
	maxHealth -= actual
	health -= actual
	if(health > maxHealth)
		health = maxHealth

/obj/effect/decal/cleanable/blood_rune
	name = "rune"
	desc = "A blood rune."
	icon = 'icons/obj/rune.dmi'
	layer = TURF_DECAL_LAYER
	anchored = TRUE
	random_rotation = 0
	sanity_damage = 0.4  // Base; overridden in New() for non-subtypes: blood runes 0.4, crayon 0
	var/is_rune = FALSE
	var/drawn_in_blood = FALSE  // Only runes drawn in blood with a ritual knife can be used for casting.

/// Returns blood cost when a ritual invocation fails. Reduced if caster has an energized purified soulstone (ritualist's safeguard).
/obj/effect/decal/cleanable/blood_rune/proc/get_ritual_failure_blood_cost(mob/living/carbon/human/M)
	if(!M)
		return FAILURE_BLOOD_COST
	for(var/obj/item/soulstone/purified/S in M.get_contents())
		if(S.energized)
			return 3  // purified: failed rituals cost only 3 blood instead of 12
	return FAILURE_BLOOD_COST

/// Returns the ritual cost multiplier from soulstones (caster inventory or on rune). Best soulstone wins: base 0.85, purified 0.72, mystic 0.60.
/obj/effect/decal/cleanable/blood_rune/proc/get_soulstone_ritual_discount(mob/living/carbon/human/M)
	if(!M)
		return 1.0
	var/best = 1.0
	for(var/obj/item/soulstone/S in M.get_contents())
		if(!S.energized)
			continue
		if(istype(S, /obj/item/soulstone/mystic))
			best = min(best, 0.60)
		else if(istype(S, /obj/item/soulstone/purified))
			best = min(best, 0.72)
		else if(istype(S, /obj/item/soulstone))
			best = min(best, 0.85)
	for(var/obj/item/soulstone/S in oview(1))
		if(!S.energized)
			continue
		if(istype(S, /obj/item/soulstone/mystic))
			best = min(best, 0.60)
		else if(istype(S, /obj/item/soulstone/purified))
			best = min(best, 0.72)
		else if(istype(S, /obj/item/soulstone))
			best = min(best, 0.85)
	return best

/// Charge blood for a ritual; reduced by soulstone discount. Use instead of B.remove_self(amount) in spell procs.
/obj/effect/decal/cleanable/blood_rune/proc/charge_blood(mob/living/carbon/human/M, amount)
	if(!M)
		return
	var/datum/reagent/organic/blood/B = M.get_blood()
	if(!B)
		return
	var/actual = max(1, round(amount * get_soulstone_ritual_discount(M)))
	B.remove_self(actual)

/// Returns the effective max health/health cost for a spell; quartered if Demonomicon perk, reduced by soulstones.
/obj/effect/decal/cleanable/blood_rune/proc/health_spell_cost(mob/living/carbon/human/M, nominal_cost)
	var/cost = nominal_cost
	if(M && M.stats && M.stats.getPerk(PERK_DEMONOMICON))
		cost = max(1, round(cost / 4))
	cost = max(1, round(cost * get_soulstone_ritual_discount(M)))
	return cost

/// Applies a max HP (and current health) cost, using effective maxhp; delegates to the human proc.
/obj/effect/decal/cleanable/blood_rune/proc/apply_max_hp_cost(mob/living/carbon/human/M, cost)
	M.apply_max_hp_cost(cost)

/obj/effect/decal/cleanable/blood_rune/Destroy()
	..()

// Mist rune, invoked by Scribe scrolls, doesn't allow laser beams to pass through it.
/obj/effect/decal/cleanable/blood_rune/mist
	name = "strange rune"
	desc = "A fine mist comes off this rune"
	alpha = 150
	is_rune = TRUE
	sanity_damage = 4

/obj/effect/decal/cleanable/blood_rune/mist/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile/beam))
		return FALSE
	return TRUE

// Shimmer rune, invoked by Scribe scrolls, doesn't allow bullets to pass through. Unless they have penetration.
/obj/effect/decal/cleanable/blood_rune/shimmer
	name = "strange rune"
	desc = "The air shimmers about this rune."
	alpha = 150
	is_rune = TRUE
	sanity_damage = 4

/obj/effect/decal/cleanable/blood_rune/shimmer/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /obj/item/projectile) && !istype(mover, /obj/item/projectile/beam))
		return FALSE
	return TRUE

// Trap rune. Created by deepmaint and blood mages.
/obj/effect/decal/cleanable/blood_rune/trap
	name = "dangerous rune"
	desc = "The air shimmers about this rune."
	alpha = 50
	is_rune = TRUE
	sanity_damage = 4
	var/playmate = 0
	var/draw = 1

/obj/effect/decal/cleanable/blood_rune/trap/Crossed(mob/living/carbon/human/M)
	var/obj/item/scroll/trap_card = null
	if(ishuman(M))
		playmate = 0
		draw = rand(1,2)
		src.set_light(3,2,"#FFFFFF")
		if(M.species?.reagent_tag == IS_SYNTHETIC || M.species?.reagent_tag == IS_SLIME)
			return
		for(var/datum/language/L in M.languages)
			if(L.name == LANGUAGE_CULT || L.name == LANGUAGE_OCCULT)
				return
		if(draw == 1)
			if(!trap_card)
				trap_card = new /obj/item/scroll(M.loc)
			trap_card.loc = M.loc
			trap_card.alpha = 0
			pick(trap_card.smoke_spell(M), trap_card.gaia_spell(M), trap_card.oil_spell(M), trap_card.entangle_spell(M), trap_card.joke_spell(M), trap_card.charger_spell(M))
			do_sparks(3, 0, M.loc)
		if(draw == 2)
			if(M.maxHealth < 80)
				pick(src.flux_spell(M, TRUE), src.equalize_spell(M, TRUE))
			else pick(src.ignorance_spell(M, TRUE), src.madness_spell(M, TRUE), src.flux_spell(M, TRUE), src.equalize_spell(M, TRUE))
			do_sparks(3, 0, M.loc)
	for(var/mob/living/carbon/human/T in oview(7))
		playmate = 0
		draw = rand(1,2)
		for(var/datum/language/L in T.languages)
			if(L.name == LANGUAGE_CULT || L.name == LANGUAGE_OCCULT)
				playmate = 1
		if(!playmate)
			if(T.species?.reagent_tag == IS_SYNTHETIC || T.species?.reagent_tag == IS_SLIME)
				return
			if(draw == 1)
				if(!trap_card)
					trap_card = new /obj/item/scroll(T.loc)
				trap_card.loc = T.loc
				trap_card.alpha = 0
				pick(trap_card.smoke_spell(T), trap_card.gaia_spell(T), trap_card.oil_spell(T), trap_card.entangle_spell(T), trap_card.joke_spell(T), trap_card.charger_spell(T))
				do_sparks(3, 0, T.loc)
			if(draw == 2)
				if(M.maxHealth < 80)
					pick(src.flux_spell(T), src.equalize_spell(T))
				else pick(src.ignorance_spell(T), src.madness_spell(T), src.flux_spell(T), src.equalize_spell(T))
				do_sparks(3, 0, T.loc)

/obj/effect/decal/cleanable/blood_rune/New(location, main = "#FFFFFF", shade = "#000000", type = "rune", in_blood = FALSE)
	..()
	loc = location
	drawn_in_blood = in_blood
	// Only runes drawn in blood (ritual knife) weigh on the mind; crayon runes and drawings do not.
	if(!istype(src, /obj/effect/decal/cleanable/blood_rune/mist) && !istype(src, /obj/effect/decal/cleanable/blood_rune/shimmer) && !istype(src, /obj/effect/decal/cleanable/blood_rune/trap))
		sanity_damage = drawn_in_blood ? 0.4 : 0
	name = type
	desc = drawn_in_blood ? "A blood rune, drawn with a ritual blade. It can channel rituals." : "A [type] drawn in wax. It cannot channel blood magic."
	var/main_state
	var/shade_state
	switch(type)
		if("rune")
			var/rune_n = rand(1, 6)
			main_state = "main[rune_n]"
			shade_state = "shade[rune_n]"
			is_rune = TRUE
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")
			main_state = type
			shade_state = "[type]s"
	var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi', main_state || "[type]", 2.1)
	var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi', shade_state || "[type]s", 2.1)
	mainOverlay.Blend(main,ICON_ADD)
	shadeOverlay.Blend(shade,ICON_ADD)
	add_overlay(mainOverlay)
	add_overlay(shadeOverlay)
	add_hiddenprint(usr)

/obj/effect/decal/cleanable/blood_rune/attackby(obj/item/I, mob/living/carbon/human/M)
	..()
	var/alchemist = FALSE
	if(M.stats.getPerk(PERK_ALCHEMY))
		alchemist = TRUE
	var/able_to_cast = FALSE
	for(var/datum/language/L in M.languages)
		if(L.name == LANGUAGE_CULT || L.name == LANGUAGE_OCCULT)
			able_to_cast = TRUE
	// Energize soulstone: use soulstone on rune with at least 1 candle, 15 blood
	if(istype(I, /obj/item/soulstone))
		var/obj/item/soulstone/S = I
		if(!S.energized && is_rune && drawn_in_blood && body_checks(M))
			var/candle_amount = 0
			for(var/obj/item/flame/candle/mage_candle in oview(3))
				candle_amount += 1
			if(candle_amount >= 1)
				var/datum/reagent/organic/blood/B = M.get_blood()
				if(B && B.volume >= 15)
					B.remove_self(15)
					M.sanity.changeLevel(-3, TRUE)
					S.energized = TRUE
					S.update_icon()
					to_chat(M, SPAN_NOTICE("You hold the soulstone to the rune; blood and candle-light flow into it. It grows warm and begins to glow."))
				else
					to_chat(M, SPAN_WARNING("You need at least 15 blood to energize the soulstone."))
			else
				to_chat(M, SPAN_WARNING("At least one candle must be within three tiles of the rune to energize a soulstone."))
		else if(S.energized)
			to_chat(M, SPAN_NOTICE("The soulstone is already energized."))
		return
	if(istype(I, /obj/item/oddity/common/book_unholy) || istype(I, /obj/item/oddity/common/book_omega) || istype(I, /obj/item/book/manual/demonomicon))
		if(M.get_core_implant(/obj/item/implant/core_implant/cruciform))
			rejected_playmate_faithful(M)
			return
		if(is_rune && !drawn_in_blood)
			to_chat(M, SPAN_WARNING("This rune was not drawn in blood. Only runes drawn with a ritual knife can channel the ritual."))
			return
		if(body_checks(M) && is_rune && drawn_in_blood)
			var/use_demonomicon = istype(I, /obj/item/book/manual/demonomicon)
			if(use_demonomicon)
				alchemist = TRUE  // Demonomicon bypasses need for Alchemist perk (Recipe., Satchel.)
			to_chat(M, "<span class='info'>The rune lights up in reaction to the book[use_demonomicon ? "... the script seems to twist and deepen in meaning." : "..."]</span>")
			var/datum/reagent/organic/blood/B = M.get_blood()
			// Demonomicon use below 25% sanity: drain health, max HP, and blood
			if(use_demonomicon && M.sanity && M.sanity.level < M.sanity.max_level * 0.25)
				M.adjustBruteLoss(10)
				M.apply_max_hp_cost(8)
				if(B)
					B.remove_self(12)
				to_chat(M, SPAN_DANGER("The tome's grip on you tightens; your blood and vitality waver."))
			var/candle_amount = 0
			for(var/obj/item/flame/candle/mage_candle in oview(3))
				if(!mage_candle.lit && body_checks(M))
					mage_candle.light(flavor_text = SPAN_NOTICE("\The [name] lights up."))
					mage_candle.endless_burn = TRUE
					B.remove_self(8)
					M.sanity.changeLevel(-5, TRUE)
					to_chat(M, "<span class='info'>A candle is lit by forces unknown...</span>")
				candle_amount += 1
			if(able_to_cast && M.health <= M.maxHealth*0.75)
				for(var/obj/effect/decal/cleanable/blood/writing/spell in oview(3))
					var/spell_type = use_demonomicon ? get_demonomicon_spell_type(spell.message) : 3
					if(spell_type)
						if(nearsighted_ritual_fail(M))
							var/datum/reagent/organic/blood/B_fail = M.get_blood()
							if(B_fail)
								B_fail.remove_self(get_ritual_failure_blood_cost(M))
							to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
							continue
						spell_index(M, spell.message, spell_type, I, able_to_cast, candle_amount, alchemist)
				for(var/obj/item/paper/spell in oview(3))
					if(spell.crayon_pen || spell.blood_pen)
						if(!spell.blood_pen && spell.crayon_pen)
							var/pen_success = PEN_INVOKE_SUCCESS
							if(spell.crayon_pen && (findtext(spell.info, "#da0000") || findtext(spell.info, "#ff0000") || findtext(spell.info, "color=red")))
								pen_success = min(100, pen_success + RED_CRAYON_BONUS)
							if(!prob(pen_success))
								var/datum/reagent/organic/blood/B_fail = M.get_blood()
								if(B_fail)
									B_fail.remove_self(get_ritual_failure_blood_cost(M))
								to_chat(M, SPAN_WARNING("The rune flickers; the ink on the page lacks the binding. The ritual fails."))
								continue
						var/spell_type = use_demonomicon ? get_demonomicon_spell_type(spell.info) : 3
						if(spell_type)
							if(nearsighted_ritual_fail(M))
								var/datum/reagent/organic/blood/B_fail = M.get_blood()
								if(B_fail)
									B_fail.remove_self(get_ritual_failure_blood_cost(M))
								to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
								continue
							spell_index(M, spell.info, spell_type, I, able_to_cast, candle_amount, alchemist)
			return
	if(istype(I, /obj/item/tool/knife/ritual))
		if(M.get_core_implant(/obj/item/implant/core_implant/cruciform))
			rejected_playmate_faithful(M)
			return
		if(is_rune && !drawn_in_blood)
			to_chat(M, SPAN_WARNING("This rune was not drawn in blood. Draw runes by using the ritual knife on the floor and offering your blood."))
			return
		if(body_checks(M) && is_rune && drawn_in_blood)
			to_chat(M, "<span class='info'>The rune lights up in response to the touch of the ritual weapon...</span>")
			var/datum/reagent/organic/blood/B = M.get_blood()
			var/candle_amount = 0
			for(var/obj/item/flame/candle/mage_candle in oview(3))
				if(!mage_candle.lit && body_checks(M))
					mage_candle.light(flavor_text = SPAN_NOTICE("\The [name] lights up."))
					mage_candle.endless_burn = TRUE
					B.remove_self(8)
					to_chat(M, "<span class='info'>A candle is lit by forces unknown...</span>")
				candle_amount += 1
			if(able_to_cast && M.health <= M.maxHealth*0.75)
				for(var/obj/effect/decal/cleanable/blood/writing/spell in oview(3))
					if(nearsighted_ritual_fail(M))
						var/datum/reagent/organic/blood/B_fail = M.get_blood()
						if(B_fail)
							B_fail.remove_self(get_ritual_failure_blood_cost(M))
						to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
						continue
					spell_index(M, spell.message, 6, I, able_to_cast, candle_amount)
				for(var/obj/item/paper/spell in oview(3))
					if(spell.crayon_pen || spell.blood_pen)
						if(!spell.blood_pen && spell.crayon_pen)
							var/pen_success = PEN_INVOKE_SUCCESS
							if(spell.crayon_pen && (findtext(spell.info, "#da0000") || findtext(spell.info, "#ff0000") || findtext(spell.info, "color=red")))
								pen_success = min(100, pen_success + RED_CRAYON_BONUS)
							if(!prob(pen_success))
								var/datum/reagent/organic/blood/B_fail = M.get_blood()
								if(B_fail)
									B_fail.remove_self(get_ritual_failure_blood_cost(M))
								to_chat(M, SPAN_WARNING("The rune flickers; the ink on the page lacks the binding. The ritual fails."))
								continue
						if(nearsighted_ritual_fail(M))
							var/datum/reagent/organic/blood/B_fail = M.get_blood()
							if(B_fail)
								B_fail.remove_self(get_ritual_failure_blood_cost(M))
							to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
							continue
						spell_index(M, spell.info, 6, I, able_to_cast, candle_amount)
			return
	if(istype(I, /obj/item/scroll) && !istype(I, /obj/item/scroll/sealed))
		var/has_scribe_or_demonomicon = M.stats.getPerk(PERK_SCRIBE)
		if(!has_scribe_or_demonomicon)
			var/obj/item/other_hand = (M.get_active_hand() == I) ? M.get_inactive_hand() : M.get_active_hand()
			if(istype(other_hand, /obj/item/book/manual/demonomicon))
				has_scribe_or_demonomicon = TRUE  // Demonomicon in hand bypasses need for Scribe perk
		if(!has_scribe_or_demonomicon)
			to_chat(M, SPAN_WARNING("Only a Scribe can inscribe a scroll. Learn the Scribe spell at a rune (book, 7 candles, paper on rune), or hold the Demonomicon."))
			return
		if(is_rune && !drawn_in_blood)
			to_chat(M, SPAN_WARNING("This rune was not drawn in blood. Only runes drawn with a ritual knife can be used."))
			return
		if(!body_checks(M, blind = TRUE) || !is_rune || !drawn_in_blood)
			return
		var/had_spell = FALSE
		for(var/obj/effect/decal/cleanable/blood/writing/spell in oview(3))
			had_spell = TRUE
			break
		if(!had_spell)
			for(var/obj/item/paper/spell in oview(3))
				if(spell.crayon_pen || spell.blood_pen)
					had_spell = TRUE
					break
		if(!had_spell)
			to_chat(M, SPAN_NOTICE("Write a scroll spell name (e.g. Mist.) in blood or on paper within three tiles of the rune, then use the blank scroll on the rune."))
			return
		var/candle_amount = 0
		for(var/obj/item/flame/candle/mage_candle in oview(3))
			candle_amount += 1
		to_chat(M, "<span class='info'>The smell of iron fills the air as the scroll fumbles out of your hands.</span>")
		if(able_to_cast && M.health <= M.maxHealth*0.75)
			for(var/obj/effect/decal/cleanable/blood/writing/spell in oview(3))
				if(nearsighted_ritual_fail(M))
					var/datum/reagent/organic/blood/B_fail = M.get_blood()
					if(B_fail)
						B_fail.remove_self(get_ritual_failure_blood_cost(M))
					to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
					continue
				spell_index(M, spell.message, 2, I, candle_amount, alchemist)
			for(var/obj/item/paper/spell in oview(3))
				if(spell.crayon_pen || spell.blood_pen)
					if(!spell.blood_pen && spell.crayon_pen)
						var/pen_success = PEN_INVOKE_SUCCESS
						if(spell.crayon_pen && (findtext(spell.info, "#da0000") || findtext(spell.info, "#ff0000") || findtext(spell.info, "color=red")))
							pen_success = min(100, pen_success + RED_CRAYON_BONUS)
						if(!prob(pen_success))
							var/datum/reagent/organic/blood/B_fail = M.get_blood()
							if(B_fail)
								B_fail.remove_self(get_ritual_failure_blood_cost(M))
							to_chat(M, SPAN_WARNING("The rune flickers; the ink on the page lacks the binding. The ritual fails."))
							continue
					if(nearsighted_ritual_fail(M))
						var/datum/reagent/organic/blood/B_fail = M.get_blood()
						if(B_fail)
							B_fail.remove_self(get_ritual_failure_blood_cost(M))
						to_chat(M, SPAN_WARNING("Your focus wavers; the ritual fails."))
						continue
					spell_index(M, spell.info, 2, I, candle_amount, alchemist)
		return
	return

/obj/effect/decal/cleanable/blood_rune/proc/get_demonomicon_spell_type(spell_text)
	if(findtext(spell_text, "Voice.") || findtext(spell_text, "Drain.") || findtext(spell_text, "Cards To Life.") || findtext(spell_text, "Life To Cards.") || findtext(spell_text, "Cards."))
		return 6
	if(findtext(spell_text, "Equalize.") || findtext(spell_text, "Scroll.") || findtext(spell_text, "Blood Party.") || findtext(spell_text, "Cessation."))
		return 6
	if(findtext(spell_text, "Fountain.") || findtext(spell_text, "Ascension.") || findtext(spell_text, "Veil.") || findtext(spell_text, "Caprice.") || findtext(spell_text, "Mightier."))
		return 6
	if(findtext(spell_text, "Purify.") || findtext(spell_text, "Mystic."))
		return 6
	if(findtext(spell_text, "Rift."))
		return 6
	if(findtext(spell_text, "Babel.") || findtext(spell_text, "Ignorance.") || findtext(spell_text, "Flux.") || findtext(spell_text, "Negentropy.") || findtext(spell_text, "Life."))
		return 3
	if(findtext(spell_text, "Madness.") || findtext(spell_text, "Insanity.") || findtext(spell_text, "Sight.") || findtext(spell_text, "Paradox."))
		return 3
	if(findtext(spell_text, "The End.") || findtext(spell_text, "The Beginning.") || findtext(spell_text, "Brew.") || findtext(spell_text, "Recipe.") || findtext(spell_text, "Bees.") || findtext(spell_text, "Bees!") || findtext(spell_text, "Condense.") || findtext(spell_text, "Form."))
		return 3
	if(findtext(spell_text, "Sky.") || findtext(spell_text, "Above.") || findtext(spell_text, "Scribe.") || findtext(spell_text, "Binder.") || findtext(spell_text, "Pouch.") || findtext(spell_text, "Escape.") || findtext(spell_text, "Awaken.") || findtext(spell_text, "Satchel."))
		return 3
	// Tomes (Binder-only, require paper on rune)
	if(findtext(spell_text, "Fireball.") || findtext(spell_text, "Smoke.") || findtext(spell_text, "Blind.") || findtext(spell_text, "Mind Swap.") || findtext(spell_text, "Mindswap."))
		return 3
	if(findtext(spell_text, "Force Wall.") || findtext(spell_text, "Forcewall.") || findtext(spell_text, "Knock.") || findtext(spell_text, "Horses.") || findtext(spell_text, "Charge.") || findtext(spell_text, "Summons.") || findtext(spell_text, "Sacred Flame.") || findtext(spell_text, "Sacredflame."))
		return 3
	return 0

/// Returns TRUE if the ritual should fail due to the caster not being nearsighted (10% chance). Nearsighted casters are unaffected.
/obj/effect/decal/cleanable/blood_rune/proc/nearsighted_ritual_fail(mob/living/carbon/human/M)
	if(!istype(M))
		return FALSE
	if(M.disabilities & NEARSIGHTED)
		return FALSE
	return prob(NON_NEARSIGHTED_FAIL_CHANCE)

/obj/effect/decal/cleanable/blood_rune/proc/spell_index(mob/living/carbon/human/M, spell, type, obj/I, able_to_cast, candle_amount, alchemist = FALSE)
	if(type == 2)
		var/obj/item/scroll/S = new /obj/item/scroll(src.loc)
		M.drop_from_inventory(I)
		qdel(I)
		S.message = spell
		S.name = "strange scroll"
		if(S.message != "")
			S.icon_state = "Scroll circle"
			S.desc = "A scroll covered in various glyphs and runes."
			qdel(src)
			return
		S.icon_state = "Scroll blood"
		S.desc = "A scroll with a large rune on it."
		qdel(src)
		return
	if(type == 3)
		if(findtext(spell, "Babel.") && candle_amount >= 3)
			babel_spell(M)
		if(findtext(spell, "Ignorance.") && candle_amount >= 1)
			ignorance_spell(M, able_to_cast)
		if(findtext(spell, "Flux.") && candle_amount >= 1)
			flux_spell(M)
		if(findtext(spell, "Negentropy.") && candle_amount >= 1)
			negentropy_spell(M)
		if(findtext(spell, "Life.") && candle_amount >= 5)
			life_spell(M, able_to_cast)
		if(findtext(spell, "Madness.") || findtext(spell, "Insanity.") && candle_amount >= 3)
			madness_spell(M, able_to_cast)
		if(findtext(spell, "Sight.") && candle_amount >= 3)
			sight_spell(M, able_to_cast)
		if(findtext(spell, "Paradox.") && candle_amount >= 7)
			paradox_spell(M)
		if(findtext(spell, "The End.") || findtext(spell, "The Beginning.") && candle_amount >= 1)
			end_spell(M, able_to_cast)
		if(findtext(spell, "Brew.") && candle_amount >= 2)
			brew_spell(M, able_to_cast)
		if(findtext(spell, "Recipe.") && candle_amount >= 1)
			recipe_spell(M, alchemist)
		if(findtext(spell, "Condense.") && candle_amount >= 5)
			condense_spell(M, able_to_cast)
		if(findtext(spell, "Form.") && candle_amount >= 5)
			form_soulstone_spell(M, able_to_cast)
		if(findtext(spell, "Bees.") || findtext(spell, "Bees!") && candle_amount >= 4)
			bees_spell(M, able_to_cast)
		if(findtext(spell, "Sky.") || findtext(spell, "Above.") && candle_amount >= 1)
			sun_spell(M, able_to_cast)
		if(findtext(spell, "Scribe.") && candle_amount >= 7)
			scribe_spell(M, able_to_cast)
		if(findtext(spell, "Binder.") && candle_amount >= 7)
			binder_spell(M, able_to_cast)
		if(findtext(spell, "Pouch.") && candle_amount >= 2)
			pouch_spell(M, able_to_cast)
		if(findtext(spell, "Escape.") && candle_amount >= 1)
			escape_spell(M)
		if(findtext(spell, "Awaken.") && candle_amount >= 7)
			awaken_spell(M, able_to_cast)
		if(findtext(spell, "Satchel.") && candle_amount >= 5)
			satchel_spell(M, alchemist)
		if(findtext(spell, "Cessation.") && candle_amount >= 1)
			cessation_spell(M, candle_amount)
		if(findtext(spell, "Fireball.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/fireball, able_to_cast, I)
		if(findtext(spell, "Smoke.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/smoke, able_to_cast, I)
		if(findtext(spell, "Blind.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/blind, able_to_cast, I)
		if((findtext(spell, "Mind Swap.") || findtext(spell, "Mindswap.")) && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/mindswap, able_to_cast, I)
		if((findtext(spell, "Force Wall.") || findtext(spell, "Forcewall.")) && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/forcewall, able_to_cast, I)
		if(findtext(spell, "Knock.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/knock, able_to_cast, I)
		if(findtext(spell, "Horses.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/horses, able_to_cast, I)
		if(findtext(spell, "Charge.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/charge, able_to_cast, I)
		if(findtext(spell, "Summons.") && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/summons, able_to_cast, I)
		if((findtext(spell, "Sacred Flame.") || findtext(spell, "Sacredflame.")) && candle_amount >= 3)
			tome_spell(M, /obj/item/book/tome/sacred_flame, able_to_cast, I)
		return
	if(type == 6)
		if(findtext(spell, "Voice.") && candle_amount >= 3)
			voice_spell(M, able_to_cast)
		if(findtext(spell, "Drain.") && candle_amount >= 5)
			drain_spell(M, able_to_cast)
		if(findtext(spell, "Cards To Life.") && candle_amount >= 3)
			cards_to_life_spell(M, able_to_cast)
		if(findtext(spell, "Life To Cards.") && candle_amount >= 3)
			life_to_cards_spell(M, able_to_cast)
		if(findtext(spell, "Cards.") && candle_amount >= 3)
			cards_spell(M, able_to_cast)
		if(findtext(spell, "Equalize.") && candle_amount >= 6)
			equalize_spell(M, able_to_cast)
		if(findtext(spell, "Scroll.") && candle_amount >= 7)
			scroll_spell(M)
		if(findtext(spell, "Blood Party.") && candle_amount >= 4)
			blood_party_spell(M)
		if(findtext(spell, "Cessation.") && candle_amount >= 1)
			cessation_spell(M, candle_amount)
		if(findtext(spell, "Fountain.") && candle_amount >= 7)
			basin_spell(M, able_to_cast)
		if(findtext(spell, "Ascension.") && candle_amount >= 7)
			ascension_spell(M, able_to_cast)
		if(findtext(spell, "Veil.") && candle_amount >= 5)
			veil_spell(M, able_to_cast)
		if(findtext(spell, "Caprice.") && candle_amount >= 3)
			caprice_spell(M, able_to_cast)
		if(findtext(spell, "Mightier.") && candle_amount >= 3)
			mightier_spell(M, able_to_cast)
		if(findtext(spell, "Purify.") && candle_amount >= 6)
			purify_spell(M, able_to_cast)
		if(findtext(spell, "Mystic.") && candle_amount >= 8)
			mystic_spell(M, able_to_cast)
		if(findtext(spell, "Rift.") && candle_amount >= 5)
			rift_spell(M, able_to_cast)
		return
	return

/obj/effect/decal/cleanable/blood_rune/proc/rejected_playmate_faithful(mob/living/carbon/human/M)
	var/not_in_good_faith = pick("To late for that, rejecter!",\
	"You already rejected reality!",\
	"That pesky jewelry says otherwise...",\
	"Seems your still not willing to play by my rules.", \
	"Come back after you recalculate your problem...",\
	"Your already commited to your playmate!",\
	"Your friends wouldn't like our playdate.",\
	"Sorry but you seem a little lost in your own rules, let alone mine.",\
	"Did you really come back without an apology?")
	to_chat(M, "<span class='info'>Voices giggles in the air. </span><span class='angelsay'>Now you wish to play? [not_in_good_faith]</span>")
	if(M.allow_spin && src.allow_spin)
		M.SpinAnimation(10,5)
		M.stunned += 1
		M.confused += 2
		if(ishuman(M))
			addtimer(CALLBACK(M, TYPE_PROC_REF(/atom, SpinAnimation), 3, 3), 1)
	if(M.species?.reagent_tag == IS_SYNTHETIC || M.species?.reagent_tag == IS_SLIME)
		var/in_good_faith = pick("Your a puppet losely strung, no playtime for you!",\
		"Quite a frail wooden doll.",\
		"Blood-gathering is for well played puppets!",\
		"Your strings have been cut, we can't play until your fixed!", \
		"Your not fit for rougher play.",\
		"You were not made to play!",\
		"Did you fall off the shelf? Best to go back to play with more careful friends!",\
		"Come back when your fixed!")
		to_chat(M, "<span class='info'>Some laughter echos. </span><span class='angelsay'>[in_good_faith]</span>")
		return
	var/obj/item/implant/core_implant/cruciform/CI = M.get_core_implant(/obj/item/implant/core_implant/cruciform)
	if(CI)
		if(30 <= CI.power)
			CI.power -= 30
			return
		if(CI.power <= 0)
			CI.power = 0
		if(M.nutrition >= 100)
			M.nutrition -= 100
			return
		var/obj/item/organ/external/organ = M.get_organ(pick(BP_R_LEG, BP_L_LEG, BP_R_ARM, BP_L_ARM))
		if(!organ)
			M.visible_message("<font size=1>\red[M.name] is spun around by [src].</font><\red>", "\red[src] spins you around at high speeds!")
			return
		organ.droplimb(TRUE, DISMEMBER_METHOD_EDGE)
		M.visible_message("<font size=1>\red[M.name] is spun around by [src], a sickening sound coming from a limb being ripped off by vacuum force!.</font><\red>", "\red[src] spins you around, violently ripping one of your limbs off!")
		return

/obj/effect/decal/cleanable/blood_rune/proc/body_checks(mob/living/carbon/human/M, blind = FALSE)
	var/pass = TRUE
	if(blind)
		if(!(M.disabilities&BLIND))
			pass = FALSE
			to_chat(M, SPAN_NOTICE("The ritual demands you work by touch alone; you must be blind to inscribe a scroll. Don a blindfold, then use the blank scroll on the rune."))
	if(M.species?.reagent_tag == IS_SYNTHETIC || M.species?.reagent_tag == IS_SLIME)
		pass = FALSE
	if(M.get_blood_volume() < 50)
		pass = FALSE
	var/ritual_floor = M.species ? (M.species.total_health * 0.25) : 25
	if(M.maxHealth <= ritual_floor)
		to_chat(M, "<span class='info'>Your hand is shaking, your concentration too shattered. The ritual cannot proceed with your constitution as frail as it is.</span>")
		return FALSE
	if(!pass && !blind)
		to_chat(M, "<span class='info'>You try to do as the book describes, but something isn't correct.</span>")
	return pass
