//Procs and vars related to dirt, cleaning, and mopping

/*
	Wetness and slipping
*/

/turf/simulated/proc/wet_floor(var/wet_val = 1, var/force_wet = FALSE)
	if(wet_val < wet && !force_wet)
		return

	if(force_wet || !wet)
		wet = wet_val
	if(!wet_overlay)
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		add_overlay(wet_overlay)

	addtimer(CALLBACK(src, PROC_REF(unwet_floor), TRUE), rand(1 MINUTES, 1.5 MINUTES), TIMER_UNIQUE|TIMER_OVERRIDE)

/turf/simulated/proc/unwet_floor(var/check_very_wet)
	wet = 0
	if(wet_overlay)
		cut_overlay(wet_overlay)
		wet_overlay = null


/*
	Cleaning
*/

// Thresholds for mop/cleaner contents: same behaviour as space cleaner and sterilizine
#define STERILIZINE_FULL_CLEAN_RATIO 0.1   // At least 10% sterilizine → full forensic wipe (erase was_bloodied and DNA)
#define CLEANER_ERASE_DNA_RATIO      0.1   // At least 10% space cleaner → erase DNA but leave was_bloodied (luminol still works)

/// Returns "full", "cleaner_dna", or "preserve" based on source's reagent ratios. Returns "dry" if not cleanable.
/turf/proc/get_clean_type_from_source(atom/source)
	if(!source?.reagents || source.reagents.total_volume < 1)
		return "dry"
	var/total = source.reagents.total_volume
	if(total <= 0)
		return "dry"
	var/sterilizine = source.reagents.get_reagent_amount("sterilizine")
	var/cleaner = source.reagents.get_reagent_amount("cleaner")
	if(sterilizine >= total * STERILIZINE_FULL_CLEAN_RATIO)
		return "full"
	if(cleaner >= total * CLEANER_ERASE_DNA_RATIO)
		return "cleaner_dna"
	return "preserve"

/// Only water or holywater wets the tile (slippery). 100% space cleaner or 100% sterilizine does not wet.
/turf/proc/source_has_water_or_holywater(atom/source)
	return source?.reagents && (source.reagents.get_reagent_amount("water") >= 1 || source.reagents.get_reagent_amount("holywater") >= 1)

/turf/simulated/clean_blood()
	// Preserve the was_bloodied marker on the turf while removing visible
	// blood decals/overlays. Individual decals will be removed below; call
	// their clean_blood so they can null out their internals if needed.
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

//expects an atom containing the reagents used to clean the turf (e.g. mop). Uses same logic as space cleaner/sterilizine by content ratio.
/turf/proc/clean(atom/source, mob/user)
	var/amt = 0  // Amount of filth collected (for holy vacuum cleaner)
	if(!source?.reagents || source.reagents.total_volume < 1)
		to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
		return amt
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1) || source.reagents.has_reagent("holywater", 1) || source.reagents.has_reagent("sterilizine", 1))
		var/clean_type = get_clean_type_from_source(source)
		// At least 10% sterilizine → full forensic wipe. At least 10% space cleaner → erase DNA but leave was_bloodied. Otherwise preserve both.
		switch(clean_type)
			if("full")
				clean_blood()
			if("cleaner_dna")
				src.clean_blood_preserve_was(TRUE)  // Erase DNA, keep was_bloodied for luminol
			if("preserve", "dry")
				src.clean_blood_preserve_was()     // Remove only visible blood; keep was_bloodied and DNA

		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay) && !istype(O,/obj/effect/overlay/water))
				amt++
				qdel(O)
		if(user && user.stats)
			if(user.stats.getPerk(PERK_NEAT))
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.sanity)
						H.sanity.changeLevel(0.5)
		// Only water/holywater wets the tile (slippery). 100% space cleaner or 100% sterilizine does not wet.
		if(source_has_water_or_holywater(source))
			source.reagents.trans_to_turf(src, 1, 10)	// wet the floor
	else
		to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
	return amt

/turf/proc/clean_ultimate(var/mob/user)
	clean_blood()
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/decal/cleanable))
			qdel(O)

//As above, but has limitations. Instead of cleaning the tile completely, it just cleans [count] number of things. Uses same sterilizine/cleaner thresholds as clean().
/turf/proc/clean_partial(atom/source, mob/user, var/count = 1)
	if (!count)
		return

	//A negative value can mean infinite cleaning, but in that case just call the unlimited version
	if (!isnum(count) || count < 0)
		clean(source, user)
		return

	if(!source?.reagents || source.reagents.total_volume < 1)
		to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
		return
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1) || source.reagents.has_reagent("holywater", 1) || source.reagents.has_reagent("sterilizine", 1))
		// Only water/holywater wets the tile; 100% cleaner or 100% sterilizine does not.
		if(source_has_water_or_holywater(source))
			source.reagents.trans_to_turf(src, 1, 10)
	else
		to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
		return

	// Apply same forensic logic as clean(): 10%+ sterilizine = full wipe, 10%+ cleaner = erase DNA only, else preserve
	var/clean_type = get_clean_type_from_source(source)
	switch(clean_type)
		if("full")
			clean_blood()
		if("cleaner_dna")
			src.clean_blood_preserve_was(TRUE)
		if("preserve", "dry")
			src.clean_blood_preserve_was()

	for (count;count > 0;count--)
		var/cleanedsomething = FALSE


		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay) && !istype(O,/obj/effect/overlay/water))
				qdel(O)
				cleanedsomething = TRUE
				break //Only clean one per loop iteration

		//If the tile is clean, don't keep looping
		if (!cleanedsomething)
			break

/turf/proc/update_blood_overlays()
	return








/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)


//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/L)
	if (!..())
		return 0

	if(isliving(L))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			B.add_blood(L)
			return 1 //we bloodied the floor
		blood_splatter(src, L, 1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/L)
	if(!L) return
	if(istype(L, /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.add_blood(L)
	else if(istype(L, /mob/living/silicon/robot))
		new /obj/effect/decal/cleanable/blood/oil(src)
	else
		src.add_blood(L)

// Reveal blood traces with luminol
/turf/simulated/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		// Check if there are any existing blood decals
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			B.reveal_blood()
			return
		// If no blood decals exist but the turf was bloodied, create a luminol trace
		var/obj/effect/decal/cleanable/blood/luminol_trace = new /obj/effect/decal/cleanable/blood(src)
		luminol_trace.basecolor = COLOR_LUMINOL
		luminol_trace.fluorescent = TRUE
		if(blood_DNA)
			luminol_trace.blood_DNA = blood_DNA.Copy()
		else
			luminol_trace.blood_DNA = list("UNKNOWN" = "O+")  // Generic blood type for traces
		luminol_trace.update_icon()


// Like clean_blood but preserves the turf's was_bloodied flag (luminol still works).
// If clean_dna is TRUE, DNA is cleared (e.g. space cleaner). Do NOT set was_bloodied = FALSE here.
/turf/simulated/clean_blood_preserve_was(var/clean_dna = FALSE)
	if(!simulated)
		return
	. = ..(clean_dna)
	fluorescent = 0
	// was_bloodied is intentionally NOT cleared - only clean_blood() (e.g. 10%+ sterilizine) does that
	return
