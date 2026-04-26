/datum/preferences
	var/list/relations
	var/list/relations_info

/datum/category_item/player_setup_item/relations
	name = "Matchmaking (Disabled)"
	sort_order = 1

/datum/category_item/player_setup_item/relations/load_character(var/savefile/S)
	S["relations"]	>> pref.relations
	S["relations_info"]	>> pref.relations_info

/datum/category_item/player_setup_item/relations/save_character(var/savefile/S)
	S["relations"]	<< pref.relations
	S["relations_info"]	<< pref.relations_info

/datum/category_item/player_setup_item/relations/sanitize_character()
	if(!pref.relations)
		pref.relations = list()
	if(!pref.relations_info)
		pref.relations_info = list()

/datum/category_item/player_setup_item/relations/content(mob/user)
	return "Matchmaking is currently disabled on this server."

/datum/category_item/player_setup_item/relations/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["relation"] || href_list["relation_info"])
		return TOPIC_REFRESH
	return ..()

/datum/category_item/player_setup_item/relations/update_setup(var/savefile/preferences, var/savefile/character)
	if(preferences["version"] < 18)
		// Remove old relation types
		for(var/i in pref.relations)
			var/f = FALSE
			for(var/T in subtypesof(/datum/relation))
				var/datum/relation/R = T
				if(initial(R.name) == i)
					f = TRUE
					break
			if(!f)
				pref.relations -= i
				. = TRUE
		for(var/i in pref.relations_info)
			var/f = FALSE
			for(var/T in subtypesof(/datum/relation))
				var/datum/relation/R = T
				if(initial(R.name) == i)
					f = TRUE
					break
			if(!f)
				pref.relations_info -= i
				. = TRUE
