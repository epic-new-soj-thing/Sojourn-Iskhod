// Blood Magic module - stones (soulstones).
// Creation: xenoarchaeology, Condense. (shard at rune), or Form. (sandstone + blood). Upgraded with Purify. and Mystic.
// When energized (use on blood rune), soulstones grant tier-specific effects. Only mystic stifles psionics/cruciform for others (not the bearer).

// Global: TRUE if H is within range of someone carrying an energized mystic soulstone (and H is not that bearer). Used to stifle cruciform rituals.
/proc/is_in_mystic_soulstone_field(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	for(var/mob/living/carbon/human/M in oview(2, H))
		if(M == H)
			continue
		for(var/obj/item/soulstone/mystic/S in M.get_contents())
			if(S.energized)
				return TRUE
	return FALSE

/obj/item/soulstone
	name = "soulstone"
	desc = "A dark crystalline shard that resonates with blood and ritual. When carried, it subtly steadies the mind. When energized at a rune, it eases the cost of rune rituals for the bearer. Use on a blood rune with candles and blood to energize."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	w_class = ITEM_SIZE_TINY
	price_tag = 350
	matter = list(MATERIAL_GLASS = 1)
	var/energized = FALSE
	var/passive_sanity_bonus = 0.05  // small sanity gain when carried (always on)

/obj/item/soulstone/equipped(var/mob/user, var/slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier += passive_sanity_bonus

/obj/item/soulstone/dropped(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier -= passive_sanity_bonus
	. = ..()

/obj/item/soulstone/Destroy()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier -= passive_sanity_bonus
	return ..()

/obj/item/soulstone/update_icon()
	if(energized)
		icon_state = "soulstone2"
	else
		icon_state = "soulstone"

/obj/item/soulstone/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		. += SPAN_NOTICE("Carrying it steadies the mind slightly.")
		. += energized ? SPAN_NOTICE("It is energized; blood rituals cost less when you carry it or place it on the rune.") : SPAN_NOTICE("It is dormant. Use it on a blood rune with at least one candle and 15 blood to energize.")

/obj/item/soulstone/purified
	name = "purified soulstone"
	desc = "A soulstone washed in blood and candle-flame. When energized and carried, it steadies the mind and wards the bearer—you recover sanity faster, and failed rituals cost far less blood."
	icon_state = "purified_soulstone"
	price_tag = 750
	passive_sanity_bonus = 0  // purified uses its own stronger bonus only when energized
	var/sanity_bonus = 0.15   // passive sanity gain when energized and carried (stronger than base)

/obj/item/soulstone/purified/update_icon()
	if(energized)
		icon_state = "purified_soulstone2"
	else
		icon_state = "purified_soulstone"

/obj/item/soulstone/purified/equipped(var/mob/user, var/slot)
	. = ..()
	if(energized && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier += sanity_bonus

/obj/item/soulstone/purified/dropped(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier -= sanity_bonus
	. = ..()

/obj/item/soulstone/purified/Destroy()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier -= sanity_bonus
	return ..()

/obj/item/soulstone/purified/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		. += energized ? SPAN_NOTICE("It is energized; rituals cost less, your mind steadies, and failed invocations take only a little blood.") : SPAN_NOTICE("It is dormant. Use it on a blood rune with at least one candle and 15 blood to energize.")

/obj/item/soulstone/mystic
	name = "mystic soulstone"
	desc = "A soulstone refined through a second ritual. When energized and carried, it stifles psionics and cruciform rites in those around you—but not your own. It also reduces ritual cost the most."
	icon_state = "mystic_soulstone"
	price_tag = 1500
	var/list/mystic_stifled = list()  // mobs we added psi_blocking to
	var/mystic_psi_strength = 10

/obj/item/soulstone/mystic/update_icon()
	if(energized)
		icon_state = "mystic_soulstone2"
	else
		icon_state = "mystic_soulstone"

/obj/item/soulstone/mystic/equipped(var/mob/user, var/slot)
	. = ..()
	if(energized && ishuman(user))
		START_PROCESSING(SSobj, src)

/obj/item/soulstone/mystic/dropped(mob/user)
	mystic_clear_stifled()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/soulstone/mystic/Destroy()
	mystic_clear_stifled()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/soulstone/mystic/proc/mystic_clear_stifled()
	for(var/mob/living/carbon/human/H in mystic_stifled)
		H.psi_blocking_additive -= mystic_psi_strength
		H.update_equipment_vision()
	mystic_stifled.Cut()

/obj/item/soulstone/mystic/Process()
	if(!energized || !loc || !ishuman(loc))
		mystic_clear_stifled()
		return PROCESS_KILL
	var/mob/living/carbon/human/bearer = loc
	var/list/in_range = list()
	for(var/mob/living/carbon/human/H in oview(2, bearer))
		if(H == bearer)
			continue
		in_range += H
		if(!(H in mystic_stifled))
			H.psi_blocking_additive += mystic_psi_strength
			H.update_equipment_vision()
			mystic_stifled += H
	for(var/mob/living/carbon/human/H in mystic_stifled)
		if(!(H in in_range))
			H.psi_blocking_additive -= mystic_psi_strength
			H.update_equipment_vision()
			mystic_stifled -= H

/obj/item/soulstone/mystic/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		. += energized ? SPAN_NOTICE("It is energized; those near you are stifled in psionics and faith, but you are not. Rituals cost the least.") : SPAN_NOTICE("It is dormant. Use it on a blood rune with at least one candle and 15 blood to energize.")
