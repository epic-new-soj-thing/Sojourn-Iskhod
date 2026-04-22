/datum/gear/factionblackshield
	display_name = "beret, ranger"
	path = /obj/item/clothing/head/rank/trooper/beret
	allowed_roles = list(JOBS_SECURITY)
	slot = slot_head
	sort_category = "Faction: Iskhod Rangers"
	cost = 0

/datum/gear/factionblackshield/captrooper
	display_name = "cap, ranger"
	path = /obj/item/clothing/head/rank/trooper/cap

/datum/gear/factionblackshield/radiohat // THINK FAST CHUCKLENUTS!
	display_name = "radio cap, ranger"
	path = /obj/item/device/radio/headset/radiohat_blackshield

/datum/gear/factionblackshield/gloves
	display_name = "ranger combat gloves"
	path = /obj/item/clothing/gloves/thick/swat/blackshield
	slot = slot_gloves

/datum/gear/factionblackshield/cadet
	display_name = "uniform, cadet"
	path = /obj/item/clothing/under/rank/trooper/cadet
	allowed_roles = list(JOBS_SECURITY)
	slot = slot_w_uniform

/datum/gear/factionblackshield/gorkasecurity
	display_name = "gorka jumpsuit, security"
	path = /obj/item/clothing/under/rank/security/gorka_ih
	allowed_roles = list(JOBS_SECURITY)
	slot = slot_w_uniform

/datum/gear/factionblackshield/gorka_pants
	display_name = "gorka security pants"
	path = /obj/item/clothing/under/rank/security/gorkapantsih

	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionblackshield/gorka_ih
	display_name = "gorka jacket, security"
	path = /obj/item/clothing/suit/gorka/toggle/gorka_ih
	allowed_roles = list(JOBS_SECURITY)
	slot = slot_wear_suit

/datum/gear/factionblackshield/bdu
	display_name = "ranger battle dress uniform"
	path = /obj/item/clothing/under/rank/bdu/trooper
	slot = slot_w_uniform

/datum/gear/factionblackshield/blackshield
	display_name = "cloak selection, ranger"
	path = /obj/item/clothing/accessory/job/cape/blackshield
	slot = slot_wear_suit
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/factionblackshield/blackcoat
	display_name = "longcoat selection, ranger"
	path = /obj/item/clothing/accessory/bscloak
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/factionblackshield/fatigueselection
	display_name = "fatigue selection"
	path = /obj/item/clothing/under/rank/fatigues/
	slot = slot_w_uniform

/datum/gear/factionblackshield/fatigueselection/New() //Like so.
	..()
	var/fatigues = list(
		"Green Fatigues"				=	/obj/item/clothing/under/rank/fatigues,
		"Navy Fatigues"			=	/obj/item/clothing/under/rank/fatigues/navy,
		"Grey Fatigues"			=	/obj/item/clothing/under/rank/fatigues/grey,
		"Camo Fatigues"				=	/obj/item/clothing/under/rank/fatigues/camo,
		"Tan Fatigues"				=	/obj/item/clothing/under/rank/fatigues/tan,
		"Alt Grey Fatigues"				=	/obj/item/clothing/under/rank/fatigues/kav,
		"Alt Green Fatigues"				=	/obj/item/clothing/under/rank/fatigues/kav/green,
		"Alt Tan Fatigues"				=	/obj/item/clothing/under/rank/fatigues/kav/tan,
		"Alt Jungle Fatigues"				=	/obj/item/clothing/under/rank/fatigues/kav/jungle,
	)
	gear_tweaks += new /datum/gear_tweak/path(fatigues)


/datum/gear/factionblackshield/fatiguecoverselection
	display_name = "fatigue cover selection"
	path = /obj/item/clothing/head/rank/fatigue/
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/factionblackshield/shoulderboardselection
	display_name = "ranger shoulderboard selection"
	description = "A selection of shoulderboards for the Iskhod Rangers."
	path = /obj/item/clothing/accessory/ranks
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionblackshield/shoulderboardselection/New()
	..()
	var/ranks = list(
		"junior ranger shoulderboards"	= /obj/item/clothing/accessory/ranks/volunteer,
		"ranger shoulderboards"			= /obj/item/clothing/accessory/ranks/trooper,
		"detective shoulderboards"		= /obj/item/clothing/accessory/ranks/corpsman,
		"lieutenant shoulderboards"		= /obj/item/clothing/accessory/ranks/sergeant,
		"captain shoulderboards"		= /obj/item/clothing/accessory/ranks/commander,
	)
	gear_tweaks += new /datum/gear_tweak/path(ranks)

/datum/gear/factionblackshield/patchselection
	display_name = "ranger rank patch selection"
	description = "A selection of ranger rank patches."
	path = /obj/item/clothing/accessory/patches
	cost = 0
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionblackshield/patchselection/New()
	..()
	var/patches = list(
		"junior ranger patch"	= /obj/item/clothing/accessory/patches/blackshield_volunteer,
		"ranger patch"			= /obj/item/clothing/accessory/patches/blackshield_trooper,
		"detective patch"		= /obj/item/clothing/accessory/patches/blackshield_corpsman,
		"lieutenant patch"		= /obj/item/clothing/accessory/patches/blackshield_sergeant,
		"captain patch"			= /obj/item/clothing/accessory/patches/blackshield_commander,
	)
	gear_tweaks += new /datum/gear_tweak/path(patches)

/datum/gear/factionblackshield/mantleselection
	display_name = "ranger mantle selection"
	description = "A selection of rank mantles for the Iskhod Rangers."
	path = /obj/item/clothing/accessory/halfcape/
	cost = 1
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionblackshield/mantleselection/New()
	..()
	var/mantles = list(
		"Ranger mantle"			= /obj/item/clothing/accessory/halfcape/trooper_cape,
		"Lieutenant mantle"		= /obj/item/clothing/accessory/cape/sergeant_cape,
		"Captain mantle"		= /obj/item/clothing/accessory/halfcape,
	)
	gear_tweaks += new /datum/gear_tweak/path(mantles)

/datum/gear/factionblackshield/blackshieldbackpack
	display_name = "green ranger backpack"
	path = /obj/item/storage/backpack/militia/green
	slot = slot_back
