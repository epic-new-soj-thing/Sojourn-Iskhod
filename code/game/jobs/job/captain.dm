var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/facility_director
	title = "Facility Director"
	flag = PREMIER
	department = DEPARTMENT_COMMAND
	head_position = TRUE
	aster_guild_member = TRUE
	department_flag = COMMAND
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "your heart and wisdom"
	difficulty = "Very Hard."
	selection_color = "#ccccff"
	req_admin_notify = 1
	playtimerequired = 2500
	wage = WAGE_COMMAND
	hud_icon = "director"



	ideal_character_age = 50 // Old geezer captains ftw
	minimum_character_age = 40
	outfit_type = /decl/hierarchy/outfit/job/captain

	perks = list(PERK_SOMELLIER)

	description = "The Facility Director is the prime mediator of the colony itself, acting as a trusted diplomat and arbitrator of conflicts amongst their peers.<br>\
	You are trusted with control of the colony primary accounts and are also able to control access within and to the colony.<br>\
	Your primary objective is to oversee council decisions, change access levels and act as both lawyer and consultant in various decisions.<br>\
	You are not the supreme leader of the colony and your word is only advisory in nature. The only person you can give legal orders to is the Steward.<br>\
	The heads of the factions which make up the council each have their own agendas. Their interests must be served to avoid issues.<br>\
	Treat your command officers with respect and listen to their council. Try not to micromanage their departments or interfere in their affairs."

	duties = "Work between the varying interests of council members to achieve colony stability.<br>\
	Offer advise and counsel when approached, particularly during important decisions.<br>\
	Manage the colony primary accounts and access levels accordingly."

	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_BIO = 15,
		STAT_MEC = 15,
		STAT_VIG = 25,
		STAT_COG = 15,
		STAT_VIV = 1,
		STAT_ANA = 1
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)


	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		if(H.age>49)
			var/obj/item/clothing/under/U = H.w_uniform
			if(istype(U)) U.accessories += new /obj/item/clothing/accessory/medal/gold/captain(U)
		return 1

	get_access()
		return get_all_station_access()

/obj/landmark/join/start/facility_director
	name = "Facility Director"
	icon_state = "player-gold-officer"
	join_tag = /datum/job/facility_director

/obj/landmark/join/start/premier
	parent_type = /obj/landmark/join/start/facility_director

/datum/job/pg
	title = "Steward"
	flag = STEWARD
	department = DEPARTMENT_COMMAND
	head_position = FALSE
	aster_guild_member = TRUE
	department_flag = COMMAND
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	difficulty = "Hard."
	selection_color = "#ddddff"
	req_admin_notify = 1
	playtimerequired = 0
	wage = WAGE_COMMAND
	hud_icon = "steward"

	ideal_character_age = 35
	minimum_character_age = 30

	health_modifier = 5
	description = "The Steward is a command role for the colony administration and command staff. Serving as a glorified secretary, ensure the smooth running of the colony.<br>\
	Your primary, and perhaps only, responsibility is to ensure the smooth running of the colony - even if it costs your reputation. A good steward is not often well liked.<br>\
	However, you are an advisor to the Facility Director as well as a secretary. Discreetly inform your superiors of mistakes. Make sure they follow the law and remain proper.<br>\
	You may be assigned special tasks by Command for whatever reason. Ensure these orders are fulfilled to the best of your abilities.<br>\
	Do not embarass them, and especially do not harm their relations with faction leaders. You may not do much talking, but you have great impact."

	duties = "Act as an advisor and confidant to the Facility Director.<br>\
	Perform tasks as assigned by the Facility Director and other command staff - such as filling paperwork or reassigning roles.<br>\
	Demonstrate true loyalty and do not let your superior down."

	outfit_type = /decl/hierarchy/outfit/job/hop

	perks = list(PERK_SOMELLIER)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)


	get_access()
		return get_all_station_access()

	stat_modifiers = list(
		STAT_VIG = 35,
		STAT_TGH = 30,
		STAT_ROB = 25,
		STAT_BIO = 25,
		STAT_MEC = 25,
		STAT_COG = 25,
		STAT_VIV = 2,
		STAT_ANA = 2
	)

/obj/landmark/join/start/pg
	name = "Steward"
	icon_state = "player-gold"
	join_tag = /datum/job/pg

