/datum/gear/factionsecurity
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/hooded/wintercoat/security
	allowed_roles = list(JOBS_SECURITY)
	slot = slot_wear_suit
	sort_category = "Faction: Security"
	cost = 0

/datum/gear/factionsecurity/ironhammer_wintercoat //it's just a generic marshal plate carrier coat with no added coverage -Dongels
	display_name = "security armored coat"
	path = /obj/item/clothing/suit/armor/vest/ironhammer_wintercoat

/datum/gear/factionsecurity/raincloak
	display_name = "security raincloak"
	path = /obj/item/clothing/accessory/duster/marshal

/datum/gear/factionsecurity/basic_uniform
	display_name = "security uniform (default)"
	path = /obj/item/clothing/under/rank/security

/datum/gear/factionsecurity/miljacket_marshal //it's a Jacket for Rangers Commisioned by pneumo/husky and sprited/coded by Dromkii
	display_name = "security jacket"
	path = /obj/item/clothing/suit/storage/toggle/miljacket_marshal

/datum/gear/factionsecurity/snowsuitsecurity
	display_name = "snowsuit, security"
	path = /obj/item/clothing/suit/storage/snowsuit/security

/datum/gear/factionsecurity/beretcommander
	display_name = "beret, security head"
	path = /obj/item/clothing/head/rank/commander
	allowed_roles = list("Captain")
	slot = slot_head

/datum/gear/factionsecurity/beretwarden
	display_name = "beret, lieutenant"
	path = /obj/item/clothing/head/rank/warden/beret
	allowed_roles = list("Lieutenant")
	slot = slot_head

/datum/gear/factionsecurity/beretironhammer
	display_name = "beret, security"
	path = /obj/item/clothing/head/rank/ironhammer
	allowed_roles = list("Detective", "Ranger", "Junior Ranger")
	slot = slot_head

/datum/gear/factionsecurity/capsarge
	display_name = "cap, lieutenant"
	path = /obj/item/clothing/head/soft/sarge2soft
	allowed_roles = list("Lieutenant")
	slot = slot_head

/datum/gear/factionsecurity/capofficer
	display_name = "cap, officer"
	path = /obj/item/clothing/head/rank/janacap
	slot = slot_head

/datum/gear/factionsecurity/capfield
	display_name = "cap, field"
	path = /obj/item/clothing/head/soft/sec2soft
	slot = slot_head

/datum/gear/factionsecurity/cappatrolblue
	display_name = "cap, patrol blue"
	path = /obj/item/clothing/head/seccap
	slot = slot_head

/datum/gear/factionsecurity/cappatrolblack
	display_name = "cap, patrol black"
	path = /obj/item/clothing/head/seccorp
	slot = slot_head

/datum/gear/factionsecurity/cloak
	display_name = "cloak, captain"
	path = /obj/item/clothing/accessory/job/cape/ihc
	allowed_roles = list("Captain")
	slot = slot_wear_suit
	sort_category = "Faction: Security"

/datum/gear/factionsecurity/cloakironhammer
	display_name = "cloak, security"
	path = /obj/item/clothing/accessory/job/cape/ironhammer

/datum/gear/factionsecurity/bdu
	display_name = "security battle dress uniform"
	path = /obj/item/clothing/under/rank/bdu/marshal
	slot = slot_w_uniform

/datum/gear/factionsecurity/winterbootssecurity
	display_name = "winter boots, security"
	path = /obj/item/clothing/shoes/winter/security
	slot = slot_shoes

/datum/gear/factionsecurity/secpatch
	display_name = "HUD eyepatch"
	path = /obj/item/clothing/glasses/eyepatch/secpatch

/datum/gear/factionsecurity/secglasses
	display_name = "HUD Glasses"
	path = /obj/item/clothing/glasses/sechud
	cost = 2 //has flash protection

/datum/gear/factionsecurity/security
	display_name = "security HUD"
	path = /obj/item/clothing/glasses/hud/security

/datum/gear/factionsecurity/security_tact
	display_name = "tactical security HUD"
	path = /obj/item/clothing/glasses/sechud/tactical
	cost = 2 //has flash protection

/datum/gear/factionsecurity/shoulderboardselection
	display_name = "ranger shoulderboard selection"
	description = "A selection of shoulderboards for the Iskhod Rangers."
	path = /obj/item/clothing/accessory/ranks
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionsecurity/shoulderboardselection/New()
	..()
	var/ranks = list(
		"junior ranger shoulderboards"	= /obj/item/clothing/accessory/ranks/volunteer,
		"ranger shoulderboards"			= /obj/item/clothing/accessory/ranks/trooper,
		"detective shoulderboards"		= /obj/item/clothing/accessory/ranks/corpsman,
		"lieutenant shoulderboards"		= /obj/item/clothing/accessory/ranks/sergeant,
		"captain shoulderboards"		= /obj/item/clothing/accessory/ranks/commander,
	)
	gear_tweaks += new /datum/gear_tweak/path(ranks)

/datum/gear/factionsecurity/patchselection
	display_name = "ranger rank patch selection"
	description = "A selection of ranger rank patches."
	path = /obj/item/clothing/accessory/patches
	cost = 0
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionsecurity/patchselection/New()
	..()
	var/patches = list(
		"junior ranger patch"	= /obj/item/clothing/accessory/patches/blackshield_volunteer,
		"ranger patch"			= /obj/item/clothing/accessory/patches/blackshield_trooper,
		"detective patch"		= /obj/item/clothing/accessory/patches/blackshield_corpsman,
		"lieutenant patch"		= /obj/item/clothing/accessory/patches/blackshield_sergeant,
		"captain patch"			= /obj/item/clothing/accessory/patches/blackshield_commander,
	)
	gear_tweaks += new /datum/gear_tweak/path(patches)

/datum/gear/factionsecurity/mantleselection
	display_name = "ranger mantle selection"
	description = "A selection of rank mantles for the Iskhod Rangers."
	path = /obj/item/clothing/accessory/halfcape/
	cost = 1
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/factionsecurity/mantleselection/New()
	..()
	var/mantles = list(
		"Ranger mantle"			= /obj/item/clothing/accessory/halfcape/trooper_cape,
		"Lieutenant mantle"		= /obj/item/clothing/accessory/cape/sergeant_cape,
		"Captain mantle"		= /obj/item/clothing/accessory/halfcape,
	)
	gear_tweaks += new /datum/gear_tweak/path(mantles)
