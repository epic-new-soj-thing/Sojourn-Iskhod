/datum/job/penitent
	title = "Penitent"
	flag = CHAPLAIN
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH | COMMAND
	faction = MAP_FACTION
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director and the Iskhod Council"
	difficulty = "Medium."
	selection_color = "#e6be3c"
	ideal_character_age = 40
	minimum_character_age = 30
	playtimerequired = 1200
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_CLERGY
	health_modifier = 10
	access = list(access_nt_preacher, access_nt_disciple, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_RC_announce, access_keycard_auth, access_heads, access_sec_doors, access_heads_vault)
	disallow_species = list(FORM_SOTSYNTH, FORM_AGSYNTH, FORM_BSSYNTH, FORM_NASHEF)
	hud_icon = "prime"


	wage = WAGE_COMMAND //The sect's charity work is funded by the colony
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/church/penitent

	stat_modifiers = list(
		STAT_MEC = 30,
		STAT_BIO = 15,
		STAT_COG = 10,
		STAT_VIG = 15,
		STAT_TGH = 10,
		STAT_ROB = 15,
	)

	perks = list(PERK_NEAT, PERK_GREENTHUMB, PERK_CHANNELING)

	software_on_spawn = list(/datum/computer_file/program/records, /datum/computer_file/program/reports)

	core_upgrades = list(
		CRUCIFORM_CLERGY,
		CRUCIFORM_PRIME
	)

	description = "The Penitent is the highest rank among the Naturalists at Iskhod. You serve as the Mouth—the chief giver of the Word—and lead this sect of pilgrims who turned from the shattered Absolute to tend life in the bunker.<br>\
	Two precepts guide you: care for the other, and maintain the life of the world. Where the Naturalists set their home, life flourishes; the hungry are fed and wounds are tended with meager supplies.<br>\
	Your duties are spiritual and practical: give the Word, organize charity, tend the chapel gardens, and support the colony. The order is built on giving, even when it grows taxing.<br>\
	The Naturalists have no enforcement wing, but they are not sworn to pacifism. When the hivemind threatens the bunker, some take up arms to protect the flock; your ritual book may aid in that defense."

	duties = "Serve as the Mouth—give the Word and lead the faithful.<br>\
		Organize charity, tend the struggling life of the bunker, and support those in need.<br>\
		Hold rites for the dead and guide the Hands in their work."

	setup_restricted = TRUE

/obj/landmark/join/start/penitent
	name = "Penitent"
	icon_state = "player-cyan-officer"
	join_tag = /datum/job/penitent

/datum/job/mouth
	title = "Mouth"
	flag = MOUTH
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Penitent"
	difficulty = "Medium."
	selection_color = "#eccd67"
	ideal_character_age = 35
	minimum_character_age = 25
	access = list(access_morgue, access_crematorium, access_maint_tunnels, access_nt_disciple, access_chapel_office)
	wage = WAGE_PROFESSIONAL
	hud_icon = "hand"

	outfit_type = /decl/hierarchy/outfit/job/church/mouth
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_COMMON
	health_modifier = 5
	stat_modifiers = list(
		STAT_MEC = 15,
		STAT_BIO = 15,
		STAT_COG = 15,
		STAT_VIG = 10,
		STAT_TGH = 5,
		STAT_ROB = 10,
	)
	disallow_species = list(FORM_SOTSYNTH, FORM_AGSYNTH, FORM_BSSYNTH, FORM_NASHEF)

	core_upgrades = list(
		CRUCIFORM_CLERGY
	)

	perks = list(PERK_NEAT, PERK_GREENTHUMB, PERK_CHANNELING)

	description = "You are the Mouth—the chief giver of the Word among the Naturalists. Where the Penitent holds the highest rank and leads the sect, you are the one who speaks the precepts: care for the other, and maintain the life of the world.<br>\
	Your duty is to give the Word: lead sermons, teach the faithful, and lead group rituals. You work alongside the Penitent and the Hands, tending the spiritual life of the bunker so that charity and devotion flourish.<br>\
	The Naturalists have no enforcement wing but are not sworn to pacifism; when the bunker is threatened, you may take up arms with the rest. Your ritual book allows you to lead the flock in shared litanies."

	duties = "Give the Word: lead sermons and teach the precepts.<br>\
		Lead group rituals and support the Penitent in spiritual matters.<br>\
		Assist Hands in chapel duties and tend to the faithful."

	setup_restricted = TRUE

/obj/landmark/join/start/mouth
	name = "Mouth"
	icon_state = "player-cyan"
	join_tag = /datum/job/mouth

/datum/job/hand
	title = "Hand"
	flag = ACOLYTE
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = MAP_FACTION
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Penitent and the Mouth"
	difficulty = "Easy to Medium."
	selection_color = "#d1be80"
	access = list(access_morgue, access_crematorium, access_maint_tunnels, access_nt_disciple)
	wage = WAGE_PROFESSIONAL
	hud_icon = "hand"

	outfit_type = /decl/hierarchy/outfit/job/church/hand
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_COMMON
	alt_titles = list("Gardener","Carer","Tender")
	health_modifier = 5
	stat_modifiers = list(
	STAT_MEC = 25,
	STAT_BIO = 10,
	STAT_VIG = 10,
	STAT_TGH = 5,
	STAT_ROB = 10,
	)
	disallow_species = list(FORM_SOTSYNTH, FORM_AGSYNTH, FORM_BSSYNTH, FORM_NASHEF)

	core_upgrades = list(
		CRUCIFORM_CLERGY
	)

	perks = list(PERK_NEAT, PERK_GREENTHUMB, PERK_CHANNELING)

	description = "You are a Hand—a lay member of the Naturalists. After the fall of Nadezhda and the exodus, this sect walked away from the Absolute to become gardeners who tend the struggling life inside the arctic bunker.<br>\
	Your precepts are simple: care for the other, and maintain the life of the world. Operate the bioreactor and tend biomass with religious devotion; feed the hungry and tend wounds with meager supplies. The order is built on charity and giving, even when it grows taxing.<br>\
	The Penitent leads the sect and gives the Word; you support that work and represent the Naturalists in a positive light to all colonists."

	duties = "Operate the bioreactor and manage biomass for the sect's machines.<br>\
		Maintain chapel areas and tend life—gardens, hydroponics, and the needy.<br>\
		Offer assistance to colonists in need; give freely even when it is taxing."

	setup_restricted = TRUE

/obj/landmark/join/start/hand
	name = "Hand"
	icon_state = "player-cyan-lower"
	join_tag = /datum/job/hand
