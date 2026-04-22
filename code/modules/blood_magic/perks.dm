// Blood Magic module — perk datums used by the art (Scribe, Binder, Alchemist, Bound to the Tome, scroll Reveal).
// Defines are in code/__DEFINES/perks.dm (PERK_DEMONOMICON, PERK_ALCHEMY, PERK_SCRIBE, PERK_TOME_BINDER, PERK_REVEAL).

/datum/perk/oddity/demonomicon
	name = "Bound to the Tome"
	desc = "You focused upon the Demonomicon and internalized its alien clarity. Your cognition and vigilance are sharpened, but the tome's grip on you never fully fades: you take more sanity damage from harm, shock, and the world, recover sanity more slowly, and are susceptible to negative sanity breakdowns when your mind is broken by external cause."
	gain_text = "The script has written itself into you; you see the art of blood and rune with terrible clarity."
	lose_text = "The tome's hold on your mind loosens."
	icon_state = "brain"

/datum/perk/oddity/demonomicon/assign(mob/living/L)
	if(!..())
		return
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(H.sanity)
		H.sanity.sanity_passive_gain_multiplier *= 0.6
		H.sanity.view_damage_threshold = max(5, H.sanity.view_damage_threshold - 10)
		H.sanity.negative_prob = 60
	H.stats.changeStat(STAT_VIG, 15)
	H.stats.changeStat(STAT_COG, 15)
	H.stats.changeStat(STAT_BIO, 10)
	H.stats.changeStat(STAT_MEC, 10)
	H.stats.changeStat(STAT_ROB, 10)
	H.stats.changeStat(STAT_TGH, 10)
	H.stats.changeStat(STAT_VIV, 5)
	H.stats.changeStat(STAT_ANA, 5)
	H.maxHealth += 20
	H.health += 20

/datum/perk/oddity/demonomicon/remove()
	if(holder && ishuman(holder))
		var/mob/living/carbon/human/H = holder
		if(H.sanity)
			H.sanity.sanity_passive_gain_multiplier /= 0.6
			H.sanity.view_damage_threshold += 10
			H.sanity.negative_prob = 0
		H.stats.changeStat(STAT_COG, -5)
		H.stats.changeStat(STAT_VIG, -5)
		H.stats.changeStat(STAT_BIO, -10)
		H.stats.changeStat(STAT_MEC, -10)
		H.stats.changeStat(STAT_ROB, -10)
		H.stats.changeStat(STAT_TGH, -10)
		H.stats.changeStat(STAT_VIV, -5)
		H.stats.changeStat(STAT_ANA, -5)
		H.maxHealth -= 20
		H.health -= 20
	..()

/datum/perk/alchemist
	name = "Alchemy"
	desc = "Whether from fun study or natural talent in the field of brewing random things together you know how to gather basic chemical compounds. \
			Your NSA also has been slightly improved due to self experimentation. You can also see all reagents in beakers."
	perk_shared_ability = PERK_SHARED_SEE_REAGENTS

/datum/perk/alchemist/assign(mob/living/L)
	..()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.metabolism_effects.nsa_mult += 0.05
		H.metabolism_effects.calculate_nsa()

/datum/perk/alchemist/remove()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		H.metabolism_effects.nsa_mult -= 0.05
		H.metabolism_effects.calculate_nsa()
	..()

/datum/perk/scribe
	name = "Scribe"
	desc = "Your ability to turn experiences into words knows no bounds. Paper at this point is hardly able to hold the power of your writing."
	copy_protected = TRUE

/datum/perk/scribe/assign(mob/living/L)
	..()
	if(holder)
		holder.sdisabilities|=BLIND

/datum/perk/scribe/remove()
	if(holder)
		holder.sdisabilities&=~BLIND
	..()

/datum/perk/tome_binder
	name = "Tome Binder"
	desc = "You have learned to bind ritual knowledge into thematic tomes at a blood rune. Mutually exclusive with Scribe and Alchemist."
	copy_protected = TRUE

/datum/perk/tome_binder/assign(mob/living/L)
	..()

/datum/perk/tome_binder/remove()
	..()

/datum/perk/cooldown/reveal
	name = "Peak-A-Boo"
	perk_lifetime = 3 SECONDS
	gain_text = "The scroll's smoke fills your eyes. Whats moving in the walls?"
	lose_text = "Your eyes sting but you don't see the pain anymore."
	copy_protected = TRUE

/datum/perk/cooldown/reveal/assign(mob/living/L)
	..()
	if(holder)
		holder.sight |= SEE_MOBS
