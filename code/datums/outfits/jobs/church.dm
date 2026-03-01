/decl/hierarchy/outfit/job/church
	l_ear = /obj/item/device/radio/headset/church
	id_type = /obj/item/card/id/church
	pda_type = /obj/item/modular_computer/pda/church
	hierarchy_type = /decl/hierarchy/outfit/job/church
	backpack_contents = list(/obj/item/book/ritual/cruciform = 1)

/decl/hierarchy/outfit/job/church/New()
	..()
	BACKPACK_OVERRIDE_NEOTHEOLOGY

/decl/hierarchy/outfit/job/church/penitent
	name = OUTFIT_JOB_NAME("Naturalists - Penitent")
	l_ear = /obj/item/device/radio/headset/heads/preacher
	id_type = /obj/item/card/id/chaplain
	uniform = /obj/item/clothing/under/rank/preacher
	suit = /obj/item/clothing/suit/storage/chaplain/coat
	head = /obj/item/clothing/head/preacher
	shoes = /obj/item/clothing/shoes/reinforced
	gloves = /obj/item/clothing/gloves/thick
	backpack_contents = list(/obj/item/book/ritual/cruciform/priest = 1, /obj/item/clothing/accessory/cross = 1)

/decl/hierarchy/outfit/job/church/mouth
	name = OUTFIT_JOB_NAME("Naturalists - Mouth")
	uniform = /obj/item/clothing/under/rank/acolyte
	suit = /obj/item/clothing/suit/storage/chaplain/mouth
	shoes = /obj/item/clothing/shoes/reinforced
	gloves = /obj/item/clothing/gloves/thick
	backpack_contents = list(/obj/item/book/ritual/cruciform/priest = 1)

/decl/hierarchy/outfit/job/church/hand
	name = OUTFIT_JOB_NAME("Naturalists - Hand")
	uniform = /obj/item/clothing/under/rank/acolyte
	shoes = /obj/item/clothing/shoes/reinforced
	gloves = /obj/item/clothing/gloves/thick
