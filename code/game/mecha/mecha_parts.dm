/////////////////////////
////// Mecha Parts //////
/////////////////////////

// Mecha circuitboards can be found in /code/game/objects/items/weapons/circuitboards/mecha.dm

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = ITEM_SIZE_HUGE
	flags = CONDUCT
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2)

/obj/item/mecha_parts/chassis
	name = "Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct
	var/construct_type
	flags = CONDUCT

/obj/item/mecha_parts/chassis/Initialize()
	. = ..()
	if(construct_type)
		construct = new construct_type(src)

/obj/item/mecha_parts/chassis/Destroy()
	QDEL_NULL(construct)
	return ..()

/obj/item/mecha_parts/chassis/attackby(obj/item/I, mob/user)
	if(!construct || !construct.action(I, user))
		..()
	return

/obj/item/mecha_parts/chassis/attack_hand()
	return

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "Ripley Chassis"
	desc = "A chassis or case for a Ripley mech, needs Ripley torso, arms and legs."
	construct_type = /datum/construction/mecha/ripley_chassis
	matter = list(MATERIAL_STEEL = 30)
	price_tag = 700

/obj/item/mecha_parts/chassis/ripley/firefighter
	name = "Firefighter Chassis"
	desc = "A chassis for a Firefighter mech. Needs Ripley torso, arms and legs, as well as a fire suit."
	construct_type = /datum/construction/mecha/firefighter_chassis

/obj/item/mecha_parts/part/ripley_torso
	name = "Ripley Torso"
	desc = "A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 40, MATERIAL_GLASS = 25)
	price_tag = 700

/obj/item/mecha_parts/part/ripley_left_arm
	name = "Ripley Left Arm"
	desc = "A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 18)
	price_tag = 700

/obj/item/mecha_parts/part/ripley_right_arm
	name = "Ripley Right Arm"
	desc = "A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 18)
	price_tag = 700

/obj/item/mecha_parts/part/ripley_left_leg
	name = "Ripley Left Leg"
	desc = "A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 18)
	price_tag = 700

/obj/item/mecha_parts/part/ripley_right_leg
	name = "Ripley Right Leg"
	desc = "A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 18)
	price_tag = 700

///////// Ivan

/obj/item/mecha_parts/chassis/ivan
	name = "Ivan Chassis"
	desc = "A chassis or case for a Ivan mech, needs Ivan torso, arms and legs."
	construct_type = /datum/construction/mecha/ivan_chassis
	matter = list(MATERIAL_STEEL = 20)
	price_tag = 350

/obj/item/mecha_parts/part/ivan_torso
	name = "Ivan Torso"
	desc = "A torso part of Ivan APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(TECH_DATA = 1, TECH_MATERIAL = 1, TECH_BIO = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 20)
	price_tag = 350

/obj/item/mecha_parts/part/ivan_left_arm
	name = "Ivan Left Arm"
	desc = "A Ivan APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(TECH_DATA = 1, TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 10)
	price_tag = 350

/obj/item/mecha_parts/part/ivan_right_arm
	name = "Ivan Right Arm"
	desc = "A Ivan APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(TECH_DATA = 1, TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 10)
	price_tag = 350

/obj/item/mecha_parts/part/ivan_left_leg
	name = "Ivan Left Leg"
	desc = "A Ivan APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(TECH_DATA = 1, TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 10)
	price_tag = 350

/obj/item/mecha_parts/part/ivan_right_leg
	name = "Ivan Right Leg"
	desc = "A Ivan APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(TECH_DATA = 1, TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 10)
	price_tag = 350

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "Gygax Chassis"
	desc = "The chassis for a Gygax mech. Needs a Gygax head, torso, arms and legs, as well as anti-staining paint and a SMES coil."
	construct_type = /datum/construction/mecha/gygax_chassis
	matter = list(MATERIAL_PLASTEEL = 30)

/obj/item/mecha_parts/part/gygax_torso
	name = "Gygax Torso"
	desc = "A torso part of Gygax. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 25)

/obj/item/mecha_parts/part/gygax_head
	name = "Gygax Head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_GLASS = 10)

/obj/item/mecha_parts/part/gygax_left_arm
	name = "Gygax Left Arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit weapons and tools."
	icon_state = "gygax_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 20)

/obj/item/mecha_parts/part/gygax_right_arm
	name = "Gygax Right Arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit weapons and tools."
	icon_state = "gygax_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 20)

/obj/item/mecha_parts/part/gygax_left_leg
	name = "Gygax Left Leg"
	icon_state = "gygax_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 20)

/obj/item/mecha_parts/part/gygax_right_leg
	name = "Gygax Right Leg"
	icon_state = "gygax_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 20)

/obj/item/mecha_parts/part/gygax_armor
	name = "Gygax Armor Plates"
	icon_state = "gygax_armour" // TODO-ISKHOD - Change this to gygax_armor in the .dmi
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5)
	matter = list(MATERIAL_STEEL = 30, MATERIAL_PLASMA = 10)

//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "Durand Chassis"
	desc = "The chassis for a Durand mech. Needs a Durand head, torso, arms and legs, as well as magboots and four brace bars."
	construct_type = /datum/construction/mecha/durand_chassis
	matter = list(MATERIAL_PLASTEEL = 30)

/obj/item/mecha_parts/part/durand_torso
	name = "Durand Torso"
	icon_state = "durand_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 50, MATERIAL_GLASS = 10, MATERIAL_SILVER = 10)

/obj/item/mecha_parts/part/durand_head
	name = "Durand Head"
	icon_state = "durand_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_GLASS = 10, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/durand_left_arm
	name = "Durand Left Arm"
	icon_state = "durand_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/durand_right_arm
	name = "Durand Right Arm"
	icon_state = "durand_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/durand_left_leg
	name = "Durand Left Leg"
	icon_state = "durand_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/durand_right_leg
	name = "Durand Right Leg"
	icon_state = "durand_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/durand_armor
	name = "Durand Armor Plates"
	icon_state = "durand_armour" // TODO-ISKHOD - Change this to gygax_armor in the .dmi
	origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ENGINEERING = 5)
	matter = list(MATERIAL_PLASTEEL = 50, MATERIAL_URANIUM = 10)

////////// Phazon
//origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ENGINEERING = 5)

/obj/item/mecha_parts/chassis/phazon
	name = "Phazon Chassis"
	desc = "A chassis or case for a Phazon mech, needs arms, legs, head, artificial bluespace crystal, Tesla overdrive chip, large atomic cell, and a super capacity SMES coil."
	origin_tech = list(TECH_MATERIAL =7)
	construct_type = /datum/construction/mecha/phazon_chassis
	matter = list(MATERIAL_PLASTEEL = 25)

/obj/item/mecha_parts/part/phazon_torso
	name = "Phazon Torso"
	icon_state = "phazon_harness"
	origin_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 7, TECH_DATA = 7, TECH_POWER = 7)
	matter = list(MATERIAL_PLASTEEL = 35, MATERIAL_GLASS = 10, MATERIAL_PLASMA = 20)

/obj/item/mecha_parts/part/phazon_head
	name = "Phazon Head"
	icon_state = "phazon_head"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 6, TECH_DATA = 6)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_GLASS = 5, MATERIAL_PLASMA = 10, MATERIAL_SILVER = 30)

/obj/item/mecha_parts/part/phazon_left_arm
	name = "Phazon Left Arm"
	icon_state = "phazon_l_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 10, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/phazon_right_arm
	name = "Phazon Right Arm"
	icon_state = "phazon_r_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 10, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/phazon_left_leg
	name = "Phazon Left Leg"
	icon_state = "phazon_l_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 10, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/phazon_right_leg
	name = "Phazon Right Leg"
	icon_state = "phazon_r_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 10, MATERIAL_SILVER = 3)

/obj/item/mecha_parts/part/phazon_armor
	name = "Phazon Armor Plates"
	icon_state = "phazon_armor"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 10, MATERIAL_URANIUM = 10, MATERIAL_SILVER = 10, MATERIAL_DIAMOND = 5)

///////// Odysseus


/obj/item/mecha_parts/chassis/odysseus
	name = "Odysseus Chassis"
	desc = "The chassis for an Odysseus mech. Needs an Odysseus head, arms and legs."
	construct_type = /datum/construction/mecha/odysseus_chassis
	matter = list(MATERIAL_STEEL = 25)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_head
	name = "Odysseus Head"
	icon_state = "odysseus_head"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 2)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 15)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_torso
	name = "Odysseus Torso"
	desc = "A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 20)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_left_arm
	name = "Odysseus Left Arm"
	desc = "An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 12)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_right_arm
	name = "Odysseus Right Arm"
	desc = "An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 12)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_left_leg
	name = "Odysseus Left Leg"
	desc = "An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 12)
	price_tag = 800

/obj/item/mecha_parts/part/odysseus_right_leg
	name = "Odysseus Right Leg"
	desc = "A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 12)
	price_tag = 800
