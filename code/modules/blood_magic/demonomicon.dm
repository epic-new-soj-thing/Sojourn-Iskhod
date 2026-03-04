// Demonomicon — blood magic guide. Part of the blood_magic module.
// GLOB.demonomicon_spawned_this_round is set when the archive bookcase spawns one (lib_items.dm) or when a common_oddities spawner spawns one (oddities.dm). Common_oddities is used for oddity spawns and for trash piles that summon oddities (e.g. scrap science/poor in scrap.dm, pack/rare in packs.dm). At most one Demonomicon is spawned per round from these sources; manual spawns and direct map placement do not set it.
GLOBAL_VAR_INIT(demonomicon_spawned_this_round, FALSE)

// Obfuscated book content: HTML is stored base64-encoded in data.dm and decoded here at runtime so it is not readable in source. Rendered only when the book is opened in-game.
/proc/demonomicon_b64decode(b64)
	var/static/b64_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	var/out = ""
	var/i = 1
	var/len = length(b64)
	while(i + 3 <= len)
		var/c1 = copytext(b64, i, i + 1)
		var/c2 = copytext(b64, i + 1, i + 2)
		var/c3 = copytext(b64, i + 2, i + 3)
		var/c4 = copytext(b64, i + 3, i + 4)
		var/n1 = findtext(b64_alphabet, c1) - 1
		var/n2 = findtext(b64_alphabet, c2) - 1
		var/n3 = (c3 == "=") ? 0 : (findtext(b64_alphabet, c3) - 1)
		var/n4 = (c4 == "=") ? 0 : (findtext(b64_alphabet, c4) - 1)
		var/bits = (n1 << 18) | (n2 << 12) | (n3 << 6) | n4
		out += ascii2text((bits >> 16) & 255)
		if(c3 != "=")
			out += ascii2text((bits >> 8) & 255)
		if(c4 != "=")
			out += ascii2text(bits & 255)
		i += 4
	return out

/obj/item/book/manual/demonomicon
	name = "Demonomicon"
	desc = "A heavy, leather-bound manual. The cover is tooled with runes and geometries that seem to shift when not looked at directly. The spine shows no author; the pages smell faintly of copper and old ash. Reading it weighs on the mind."
	icon_state = "demonomicon"
	author = "Unknown"
	title = "Demonomicon"
	window_size = "900x600"  // Wider than tall for the long blood-magic guide text
	var/mob/living/carbon/human/current_reader  // Who has the book window open; sanity drains until they close it
	var/reading_drain_timer                     // Timer id for repeating sanity drain while window is open

/obj/item/book/manual/demonomicon/Initialize()
	. = ..()
	if(GLOB.dat_b64)
		dat = demonomicon_b64decode(GLOB.dat_b64)
		if(copytext(dat, 1, 6) == "html>")
			dat = "<" + dat
		// Prevent copying text from the book/iframe (anti-cheat).
		dat = replacetext(dat, "</style></head>", "</style><style>body,*{user-select:none !important;-webkit-user-select:none !important;-moz-user-select:none !important;-ms-user-select:none !important;}</style></head>")
	AddComponent(/datum/component/atom_sanity, 1, "")
	AddComponent(/datum/component/inspiration, list(STAT_COG = 5, STAT_VIG = 5, STAT_MEC = 3), /datum/perk/oddity/demonomicon, FALSE)
	RegisterSignal(src, COMSIG_ODDITY_USED, PROC_REF(on_focus_used))

/obj/item/book/manual/demonomicon/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		. += SPAN_NOTICE("The runes on the cover seem to shift when you look away. It feels heavier than it looks.")

/obj/item/book/manual/demonomicon/proc/on_focus_used()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return
	H.adjustBruteLoss(15)
	if(H.sanity)
		H.sanity.changeLevel(-25, TRUE)
	var/datum/reagent/organic/blood/B = H.get_blood()
	if(B)
		B.remove_self(10)
	to_chat(H, SPAN_DANGER("The Demonomicon exacts its price; your blood and sanity waver."))

/obj/item/book/manual/demonomicon/attack_self(mob/user)
	// Already open for this user: don't drain again or re-open (prevents spam for sanity/drain)
	if(current_reader == user)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			// One-time sanity drain when opening
			if(H.sanity.level >= H.sanity.max_level * 0.25)
				H.sanity.changeLevel(-4, TRUE)
			else
				H.sanity.changeLevel(-2, TRUE)
			if(prob(35))
				to_chat(H, SPAN_WARNING("The script seems to shift on the page as you look away."))
			// Blood/health only when opening or using (e.g. at rune), not while the window is open
			if(H.sanity.level < H.sanity.max_level * 0.25)
				var/datum/reagent/organic/blood/B = H.get_blood()
				if(B)
					B.remove_self(6)
				H.adjustBruteLoss(8)
				H.maxHealth = max(30, H.maxHealth - 3)
				H.health = min(H.health, H.maxHealth)
				to_chat(H, SPAN_DANGER("The tome's grip on you tightens; your blood and vitality waver."))
	..()
	// Register so we get Topic when window is closed; drain sanity periodically while the window stays open
	if(dat && ishuman(user))
		var/mob/living/carbon/human/H = user
		onclose(H, "book", src)
		current_reader = H
		schedule_reading_drain()

/obj/item/book/manual/demonomicon/proc/schedule_reading_drain()
	if(reading_drain_timer)
		deltimer(reading_drain_timer)
	reading_drain_timer = addtimer(CALLBACK(src, PROC_REF(drain_sanity_while_open)), 20 SECONDS, TIMER_STOPPABLE)

/obj/item/book/manual/demonomicon/proc/drain_sanity_while_open()
	if(!current_reader || !current_reader.sanity)
		current_reader = null
		return
	current_reader.sanity.changeLevel(-2, TRUE)
	if(current_reader)
		schedule_reading_drain()

/obj/item/book/manual/demonomicon/Topic(href, href_list)
	if(href_list["close"])
		current_reader = null
		if(reading_drain_timer)
			deltimer(reading_drain_timer)
			reading_drain_timer = null
		return
	return ..()
