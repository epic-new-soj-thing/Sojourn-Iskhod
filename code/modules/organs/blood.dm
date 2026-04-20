/****************************************************
				BLOOD SYSTEM
****************************************************/
/mob/living/carbon
	var/datum/reagents/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.

/mob/living/carbon/human
	var/var/pale = 0          // Should affect how mob sprite is drawn, but currently doesn't.

/mob/living/carbon/proc/make_blood()
	if(vessel)
		return

	if(!species)
		return

	vessel = new/datum/reagents(species.blood_volume)
	vessel.my_atom = src

	// set mob blood colour early if we happen to be giving them a vessel here
	if(species)
		src.blood_color = species.blood_color

	if(species && species.blood_reagent)
		vessel.add_reagent(species.blood_reagent,species.blood_volume)
	spawn(1)
		fixblood()

// generic stub so callers in carbon context can compile
/mob/living/carbon/proc/fixblood()
	if (!QDELETED(src))
		for(var/datum/reagent/organic/blood/B in vessel.reagent_list)
			if(B.id == species.blood_reagent)
				B.initialize_data(get_blood_data())
	return

/mob/living/carbon/proc/get_blood_data()
	var/data = list()
	data["donor"] = WEAKREF(src)
	data["blood_DNA"] = dna.unique_enzymes
	data["blood_type"] = dna.b_type
	data["species"] = species.name
	data["blood_group"] = species.blood_group
	var/list/temp_chem = list()
	for(var/datum/reagent/R in reagents?.reagent_list) //TODO: Remove "?." operations.
		temp_chem[R.type] = R.volume
	data["trace_chem"] = temp_chem
	// ensure there is always a colour available, falling back to our species when needed
	if(!blood_color && species)
		blood_color = species.blood_color
	data["blood_color"] = blood_color
	data["resistances"] = null
	data["carrion"] = is_carrion(src)
	return data

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()
	if(in_stasis)
		return

	if(!species.has_process[OP_HEART])
		return

	if(!organ_list_by_process(OP_HEART).len)	//not having a heart is bad for health - true
		setOxyLoss(max(getOxyLoss(),60))
		adjustOxyLoss(10)

	//Bleeding out
	var/blood_max = 0
	for(var/obj/item/organ/external/temp in organs)
		if(!(temp.status & ORGAN_BLEEDING) || BP_IS_ROBOTIC(temp)) // Corrected syntax for BP_IS_ROBOTIC
			continue
		for(var/datum/wound/W in temp.wounds)
			if(W.bleeding())
				if(W.internal)
					var/removed = W.damage/75
					if(chem_effects[CE_BLOODCLOT])
						removed *= 1 - chem_effects[CE_BLOODCLOT]
					if(species && vessel) // Added null checks for species and vessel
						vessel.remove_reagent(species.blood_reagent, temp.wound_update_accuracy * removed)
					if(prob(1 * temp.wound_update_accuracy))
						custom_pain("You feel a stabbing pain in your [temp]!",1)
				else
					blood_max += W.damage * WOUND_BLEED_MULTIPLIER
		if (temp.open)
			blood_max += OPEN_ORGAN_BLEED_AMOUNT  //Yer stomach is cut open

	// bloodclotting slows bleeding
	if(chem_effects[CE_BLOODCLOT])
		blood_max *=  1 - chem_effects[CE_BLOODCLOT]
	drip_blood(blood_max)

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/drip_blood(var/amt as num)

	if(species && species.flags & NO_BLOOD) //TODO: Make drips come from the reagents instead.
		return

	if(!amt)
		return

	vessel.remove_reagent(species.blood_reagent,amt)
	blood_splatter(src,src)

	var/turf/T = get_turf(src)

	// Arterial bleeding: very high blood loss - always notify and spray blood in multiple directions
	if(amt >= 4)
		to_chat(src, SPAN_DANGER("Blood is spurting violently from your wounds!"))
		visible_message(SPAN_DANGER("Blood spurts violently from [src]'s wounds!"))
		if(T)
			for(var/d in GLOB.alldirs)
				var/turf/spray_turf = get_step(T, d)
				if(spray_turf && prob(60))
					blood_splatter(spray_turf, src, 1)
	// Severe bleeding: blood spurting - notify victim and nearby, spray blood
	else if(amt >= 2)
		if(prob(35))
			to_chat(src, SPAN_DANGER("Blood is spurting out of your wounds!"))
			visible_message(SPAN_DANGER("Blood spurts out of [src]'s wounds!"))
			if(T)
				var/spray_dir = pick(GLOB.alldirs)
				var/turf/target = get_step(T, spray_dir)
				if(target)
					blood_splatter(target, src, 1)
				// Chance to hit a second direction
				if(prob(50))
					target = get_step(T, pick(GLOB.alldirs))
					if(target)
						blood_splatter(target, src, 1)
	// Heavy bleeding: notify victim and observers
	else if(amt >= 1)
		if(prob(20))
			to_chat(src, SPAN_WARNING("You're bleeding heavily!"))
			visible_message(SPAN_DANGER("Blood drips heavily from [src]'s wounds."))

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/reagent_containers/container, var/amount)
	// ensure the mob has a colour at all times
	if(!blood_color && species)
		blood_color = species.blood_color

	var/reagent_path = /datum/reagent/organic/blood
	if(species && species.blood_reagent)
		var/datum/reagent/R = GLOB.chemical_reagents_list[species.blood_reagent]
		if(R)
			reagent_path = R.type

	var/datum/reagent/B = new reagent_path
	B.holder = container
	B.volume = amount

	//set reagent data
	B.initialize_data(get_blood_data())

	return B

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/reagent_containers/container, var/amount)

	if(species && (species.flags & NO_BLOOD) && !species.blood_reagent)
		return null

	if(vessel.get_reagent_amount(species.blood_reagent) < amount)
		return null

	. = ..()
	vessel.remove_reagent(species.blood_reagent,amount) // Removes blood if human

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(var/datum/reagent/organic/blood/injected, var/amount)
	if (!injected || !istype(injected))
		return
	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/datum/reagent/organic/blood/injected, var/amount)

	if(species.flags & NO_BLOOD)
		reagents.add_reagent(species.blood_reagent, amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/organic/blood/our = get_blood()

	if (!injected || !our)
		return
	if(blood_incompatible(injected.data["blood_type"],our.data["blood_type"],injected.data["species"],our.data["species"],injected.data["blood_group"],our.data["blood_group"]) && !(bloodstr.has_reagent("nosfernium") || (VAMPIRE in mutations)))
		// X-type and other wrong blood: severity depends on reagent type
		var/tox_amount = amount * 2
		if(istype(injected, /datum/reagent/organic/blood/plant) || istype(injected, /datum/reagent/organic/blood/slime))
			tox_amount = amount * 4 // Significant toxicity for plant and aulvatic in non-host
		if(istype(injected, /datum/reagent/organic/blood/synthetic) || istype(injected, /datum/reagent/organic/blood/oil))
			tox_amount = amount * 6 // Significant toxicity for synthetic and oil in non-host
		reagents.add_reagent("toxin", tox_amount)
		reagents.update_total()
		// Internal bleeding only when blood group differs (e.g. mammalian vs plant/synth), not for same-group wrong type (e.g. A+ vs O-)
		var/donor_group = injected.data["blood_group"]
		if(donor_group && donor_group != our.data["blood_group"])
			var/list/candidates = internal_organs.Copy()
			if(internal_organs_by_efficiency[BP_BRAIN])
				candidates -= internal_organs_by_efficiency[BP_BRAIN]
			if(internal_organs_by_efficiency[OP_BONE])
				candidates -= internal_organs_by_efficiency[OP_BONE]
			if(LAZYLEN(candidates))
				var/obj/item/organ/internal/I = pick(candidates)
				if(I && !(I.status & ORGAN_DEAD) && BP_IS_ORGANIC(I))
					I.add_wound(/datum/component/internal_wound/organic/blunt/hemorrhage, "transfusion sickness")
		if(istype(injected, /datum/reagent/organic/blood/synthetic))
			adjustOxyLoss(amount * 2) // Synthetic blood causes suffocation in non-host
		if(istype(injected, /datum/reagent/organic/blood/oil))
			adjustOxyLoss(amount * 4) // Oil causes suffocation in non-host
		if(istype(injected, /datum/reagent/organic/blood/slime))
			adjustOxyLoss(amount * 2) // Aulvatic fluid causes suffocation in non-host
			adjustHalLoss(amount * 2) // Aulvatic fluid causes halotoxicity in non-host
			apply_damage(amount * 1, CLONE) // Aulvatic fluid causes genetic damage in non-host
	else
		vessel.add_reagent(species.blood_reagent, amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood()
	if(!vessel)
		return null
	var/datum/reagent/organic/blood/res = locate() in vessel.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		var/datum/weakref/ref = res.data["donor"]
		if(istype(ref) && ref.resolve() != src)
			for(var/datum/reagent/organic/blood/D in vessel.reagent_list)
				ref = D.data["donor"]
				if(ref.resolve() == src)
					return D
	return res

proc/blood_incompatible(donor,receiver,donor_species,receiver_species,donor_group,receiver_group)
	if(!donor || !receiver) return 0

	if(donor_group && receiver_group)
		if(donor_group != receiver_group)
			return 1
	else if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return 1

	var/donor_antigen = copytext(donor,1,length(donor))
	var/receiver_antigen = copytext(receiver,1,length(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

proc/blood_splatter(var/target,var/datum/reagent/organic/blood/source,var/large)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	// convert any mob into its blood reagent so we can read colour/data correctly
	var/datum/reagent/organic/blood/B_tmp = null
	if(istype(source, /mob/living/carbon))
		var/mob/living/carbon/M = source
		B_tmp = M.get_blood()
	else if(istype(source, /datum/reagent/organic/blood))
		B_tmp = source

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.add_overlay(drips)
		drop.drips |= drips

	// If it's a mob (possibly non-carbon), we can still try to get some data
	if(isliving(source))
		var/mob/living/L = source
		B.basecolor = L.blood_color ? L.blood_color : COLOR_BLOOD_HUMAN
		B.add_blood(L)
		B.update_icon()
		return B

	// If we have a reagent source, use its data
	if(B_tmp)
		if(B_tmp.data["blood_color"])
			B.basecolor = B_tmp.data["blood_color"]
			B.update_icon()

		if(B_tmp.data["blood_DNA"])
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(B_tmp.data["blood_type"])
				B.blood_DNA[B_tmp.data["blood_DNA"]] = B_tmp.data["blood_type"]
			else
				B.blood_DNA[B_tmp.data["blood_DNA"]] = "O+"
		return B

	return B

//Percentage of maximum blood volume.
/mob/living/carbon/proc/get_blood_volume()
	if(vessel && species && species.blood_reagent && species.blood_volume)
		return round((vessel.get_reagent_amount(species.blood_reagent)/species.blood_volume)*100)
	return 100


//Get fluffy numbers
/mob/living/carbon/human/proc/get_blood_pressure()
	if(status_flags & FAKEDEATH)
		return "[FLOOR(120+rand(-5,5), 1)*0.25]/[FLOOR(80+rand(-5,5)*0.25, 1)]"
	var/blood_result = get_blood_circulation()
	return "[FLOOR((120+rand(-5,5))*(blood_result/100), 1)]/[FLOOR((80+rand(-5,5))*(blood_result/100), 1)]"

//Percentage of maximum blood volume, affected by the condition of circulation organs, affected by the oxygen loss. What ultimately matters for brain
/mob/living/carbon/proc/get_blood_oxygenation()
	return 100

/mob/living/carbon/human/get_blood_oxygenation()
	var/blood_volume = get_blood_circulation()
	if(is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
		return min(blood_volume, total_blood_req)

	if(!need_breathe())
		return blood_volume
	else
		blood_volume = 100

	var/blood_volume_mod = max(0, 1 - getOxyLoss()/(species.total_health/2))
	var/oxygenated_mult = 0
	if(chem_effects[CE_OXYGENATED] == 1) // Dexalin.
		oxygenated_mult = 0.5
	else if(chem_effects[CE_OXYGENATED] >= 2) // Dexplus.
		oxygenated_mult = 0.8
	blood_volume_mod = blood_volume_mod + oxygenated_mult - (blood_volume_mod * oxygenated_mult)
	blood_volume = blood_volume * blood_volume_mod
	return min(blood_volume, 100)

//Percentage of maximum blood volume, affected by the condition of circulation organs
/mob/living/carbon/proc/get_blood_circulation()
	return 100

/mob/living/carbon/human/get_blood_circulation()
	var/heart_efficiency = get_organ_efficiency(OP_HEART)
	var/robo_check = TRUE	//check if all hearts are robotic
	var/open_check = FALSE  //check if any heart is open
	for(var/obj/item/organ/internal/vital/heart/heart in organ_list_by_process(OP_HEART))
		if(!(BP_IS_ROBOTIC(heart)))
			robo_check = FALSE
		if(heart.open)
			open_check = TRUE

	var/blood_volume = get_blood_volume()
	if( heart_efficiency <= 0 || (pulse == PULSE_NONE && !(status_flags & FAKEDEATH) && !robo_check))
		blood_volume *= 0.25
	else
		var/pulse_mod = 1
		switch(pulse)
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_2FAST, PULSE_THREADY)
				pulse_mod *= 1.25
		blood_volume *= max(0.3, (heart_efficiency / 100)) * pulse_mod

	if(!open_check && chem_effects[CE_BLOODCLOT])
		blood_volume *= max(0, 1-chem_effects[CE_BLOODCLOT])

	return min(blood_volume, 100)

/mob/living/carbon/human/proc/regenerate_blood(var/amount)
	amount *= (vessel.maximum_volume / species.blood_volume)
	var/blood_volume_raw = vessel.get_reagent_amount(species.blood_reagent)
	amount = clamp(amount,0,vessel.maximum_volume - blood_volume_raw)
	if(VAMPIRE in mutations)
		amount *= 1.50 //25% more //trilby, how is that 25% -DimasW
	if(amount)
		vessel.add_reagent(species.blood_reagent, amount, get_blood_data())
	return amount
