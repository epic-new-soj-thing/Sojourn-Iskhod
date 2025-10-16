// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Racial chemicals used for perks.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/datum/reagent/medicine/sabledone
	name = "Sabledone"
	id = "sabledone"
	description = "A very effective and immensely powerful painkiller naturally produced by sablekyne when under severe stress."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#800080"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE
	constant_metabolism = TRUE
	scannable = TRUE

/datum/reagent/medicine/sabledone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 200, TRUE)
	M.apply_effect(-50, HALLOSS, 0)

/datum/reagent/stim/marquatol
	name = "Marquatol"
	id = "marquatol"
	description = "A chemical naturally produced by the mar'qua that allows them to focus."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#5f95e2"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE
	metabolism = REM/5

/datum/reagent/stim/marquatol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_BASIC, STIM_TIME, "marquatol")
	M.stats.addTempStat(STAT_BIO, STAT_LEVEL_BASIC, STIM_TIME, "marquatol")
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_BASIC, STIM_TIME, "marquatol")

/datum/reagent/medicine/hadrenol
	name = "Hadrenol"
	id = "adrenol"
	description = "A chemical naturally produced by humans pushed to their limit, allowing them to possibly recover from grievous injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040FF"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE
	constant_metabolism = TRUE
	scannable = TRUE

/datum/reagent/medicine/hadrenol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.heal_organ_damage(1, 0.8, 4, 2) // Barely buffed up Hustimdol without the sleepyness, any more would be too good. Remember this has a half hour cooldown.
	M.adjustOxyLoss(-1)
	M.add_chemical_effect(CE_TOXIN, -1)
	M.add_chemical_effect(CE_BLOODCLOT, 0.4)
	M.add_chemical_effect(CE_BLOODRESTORE, 1.1 * effect_multiplier) // Paramount due to how organ efficiency works
	M.add_chemical_effect(CE_PAINKILLER, 45, TRUE) // Come on, stand up! You can do it!
	M.add_chemical_effect(CE_STABLE)

/datum/reagent/stim/kriotol
	name = "Kriotol"
	id = "kriotol"
	description = "A chemical naturally produced by the kriosan that works like a form of adrenaline to enhance their bodies."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#5f95e2"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE

/datum/reagent/stim/kriotol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, 10, STIM_TIME, "kriotol")
	M.stats.addTempStat(STAT_VIG, 20, STIM_TIME, "kriotol")
	M.add_chemical_effect(CE_DARKSIGHT, SEE_INVISIBLE_NOLIGHTING)
	M.add_chemical_effect(CE_SPEEDBOOST, 0.2)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/stim/robustitol
	name = "Robustitol"
	id = "robustitol"
	description = "A chemical naturally produced by the akula that sends them into an all consuming frenzy."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#5f95e2"
	nerve_system_accumulations = 0
	addiction_chance = 100
	appear_in_default_catalog = FALSE

/datum/reagent/stim/robustitol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, 60, STIM_TIME, "robustitol")
	M.stats.addTempStat(STAT_ROB, 60, STIM_TIME, "robustitol")

/datum/reagent/drug/robustitol/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "robustitol_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "robustitol_w")

/datum/reagent/medicine/sergatonin
	name = "Naratonin"
	id = "naratonin"
	description = "Naratonin is a highly effective, short term, muscle stimulant naturally produced by naramadi when under stress."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE
	constant_metabolism = TRUE
	scannable = TRUE

/datum/reagent/medicine/sergatonin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, 25, STIM_TIME, "naratonin")
	M.stats.addTempStat(STAT_ROB, 25, STIM_TIME, "naratonin")
	M.add_chemical_effect(CE_SPEEDBOOST, 0.6)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/medicine/spaceacillin/cindicillin
	name = "Cindicillin"
	id = "cindicillin"
	description = "An all-purpose antiviral agent naturally produced by cindarites that functions identically to Spaceacillin."
	constant_metabolism = TRUE

/datum/reagent/medicine/cindpetamol
	name = "Cindpetamol"
	id = "cindpetamol"
	description = "Cindpetamol is a highly specialized chemical made by cindarites that purges the blood stream of toxins, addictions, and stimulants at the cost of slowing down your movements."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF3300"
	nerve_system_accumulations = 0
	appear_in_default_catalog = FALSE
	constant_metabolism = TRUE
	scannable = TRUE

/datum/reagent/medicine/cindpetamol/affect_blood(mob/living/carbon/M, alien, effect_multiplier, var/removed)
	M.add_chemical_effect(CE_TOXIN, -8)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.random_organ_by_process(OP_LIVER)
		if(istype(L))
			if(BP_IS_ROBOTIC(L))
				return
			var/list/current_wounds = L.GetComponents(/datum/component/internal_wound)
			if(LAZYLEN(current_wounds) && prob(20))
				LEGACY_SEND_SIGNAL(L, COMSIG_IORGAN_REMOVE_WOUND, pick(current_wounds))
			if(L.damage > 0)
				L.damage = max(L.damage - 2 * removed, 0)
	var/mob/living/carbon/C = M
	if(istype(C) && C.metabolism_effects.addiction_list.len)
		if(prob(90 + dose))
			var/datum/reagent/R = pick(C.metabolism_effects.addiction_list)
			to_chat(C, SPAN_NOTICE("You don't crave for [R.name] anymore."))
			C.metabolism_effects.addiction_list.Remove(R)
			qdel(R)
	if(M.bloodstr)
		for(var/current in M.bloodstr.reagent_list)
			var/datum/reagent/toxin/R = current
			if(!istype(R, src))
				R.remove_self(pick(list(1,2,3)))
			var/datum/reagent/stim/S = current
			if(!istype(S, src))
				S.remove_self(effect_multiplier * pick(list(1,2,3)))
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	M.add_chemical_effect(CE_PULSE, -1)
