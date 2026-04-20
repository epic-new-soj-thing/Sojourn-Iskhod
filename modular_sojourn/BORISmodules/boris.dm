/obj/item/borg/upgrade/boris
	name = "ISHAEK Remote Control Chip"
	desc = "A custom piece of hardware; designed in-house by V.A Science in response to the ongoing, wasteful practices of having to manually override shell safties. Functions as a means to produce more AI shells -\
	Though due to the Ad-hoc nature of how it functions, it does not correctly secure the shells against foreign AI intrusion." //You can currently hop in any unoccupied AI shell if you somehow make one off the colony
	icon_state = "cyborg_upgrade1"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)
	matter = list(MATERIAL_STEEL = 5, MATERIAL_GLASS = 3)

/obj/item/borg/upgrade/boris/action(var/mob/living/silicon/robot/R)
	if(R)
		to_chat(usr, "This module is only intended to be inserted into inactive shells!")
		return FALSE
