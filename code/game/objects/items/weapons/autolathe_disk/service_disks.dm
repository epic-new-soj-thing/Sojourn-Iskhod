// Service / cuisine lathe disk: drinkware and cutlery only.
// Use this disk in an autolathe for a dedicated drinks/cutlery fabricator in kitchen or bar.

/obj/item/pc_part/drive/disk/design/service
	disk_name = "Service & Cuisine Pack"
	icon_state = "guild"
	license = 15
	designs = list(
		// Drinkware
		/datum/design/autolathe/container/drinkingglass,
		/datum/design/autolathe/container/drinkingglass_shot,
		/datum/design/autolathe/container/drinkingglass_pint,
		/datum/design/autolathe/container/drinkingglass_doble,
		/datum/design/autolathe/container/drinkingglass_mug,
		/datum/design/autolathe/container/drinkingglass_wine,
		/datum/design/autolathe/container/carafe,
		/datum/design/autolathe/container/insulated_pitcher,
		/datum/design/autolathe/container/jar,
		// Cutlery
		/datum/design/autolathe/cutlery/fork,
		/datum/design/autolathe/cutlery/spoon,
		/datum/design/autolathe/cutlery/dinnerknife,
	)
