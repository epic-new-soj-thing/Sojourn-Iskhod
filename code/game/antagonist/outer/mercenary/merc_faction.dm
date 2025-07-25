#define WELCOME_SERBS "You are a void wolf, part of a team of professional smugglers and mercenaries. You are currently aboard your base preparing for a mission targeting the Nadezhda Colony.<br>\
	<br>\
	In your base you will find your armory full of weapon crates and the EVA capable SCAF armor. It is advised that you take a pistol, a rifle, a knife and a SCAF suit for basic equipment.<br>\
	Once you have your basic gear, you may also wish to take along a specialist weapon, like the RPG-7 or the L6 SAW LMG. Each of the specialist weapons is powerful but very bulky, you will need to wear it over your back.<br>\
	<br>\
	Discuss your specialties with your team, choose a broad range of weapons that will allow your group to overcome a variety of obstacles. Search the base and load up everything onto your ship which may be useful, you will not be able to easily return here once you depart.<br>\
	When ready, use the console on your shuttle bridge to depart for the colony. Travelling will take several minutes and you will be detected before you even arrive, stealth is not an option. Once you arrive, you have a time limit to complete your mission."

/datum/antag_faction/mercenary
	id = FACTION_SERBS
	name = "Void Wolf"
	antag = "mercenary"
	antag_plural = "mercenaries"
	welcome_text = WELCOME_SERBS

	hud_indicator = "mercenary"

	possible_antags = list(ROLE_MERCENARY)

	faction_invisible = FALSE

	var/objectives_num
	var/list/possible_objectives = list(
	/datum/objective/harm = 25,
	/datum/objective/steal = 65,
	/datum/objective/assassinate = 45,
	/datum/objective/abduct = 25)
	var/objective_quantity = 6

	//How long the mercenaries get to do their mission



/datum/antag_faction/mercenary/create_objectives()
	objectives.Cut()
	pick_objectives(src, possible_objectives, objective_quantity)

	new /datum/objective/timed/merc(src)

	..()


/datum/antag_faction/mercenary/add_leader(var/datum/antagonist/member, var/announce = TRUE)
	.=..()
	if (.)
		//put the commander outfit on
		var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/mercenary/commander)
		O.equip(member.owner.current, OUTFIT_ADJUSTMENT_NO_RESET)

		//The commander can speak english
		member.owner.current.add_language(LANGUAGE_COMMON)

		member.create_id("Commander")


/* Special inventory proc for mercenaries. Includes the content of their base and ship. So any loot that they haul
back to their ship counts for objectives.
This could potentially return a list of thousands of atoms, but thats fine. Its not as much work as it sounds */
/datum/antag_faction/mercenary/get_inventory()
	var/list/contents = ..()
	var/list/search_areas = list(/area/shuttle/mercenary, /area/centcom/merc_base)
	for (var/a in search_areas)
		contents |= get_area_contents(a)

	return contents
