/*
 * Contains:
 *		Security
 *		Detective
 *		Ironhammer Commander
 */


/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "A durable lieutenant's jumpsuit, designed to provide moderate combat protection."
	name = "lieutenant's jumpsuit"
	icon_state = "warden"
	item_state = "r_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/warden/verb/toggle_style()
	set name = "Adjust Style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["specialist jumpsuit"] = "warden"
	options["specialist jumpskirt"] = "warden_skirt"
	options["Specialist formalwear"] = "warden_formal" //credits to Eris for the sprite - slightly modified for our uses

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/obj/item/clothing/head/rank/warden
	name = "lieutenant's helmet"
	desc = "A distinctive red military helmet signifying a lieutenant rank."
	icon_state = "policehelm"
	body_parts_covered = 0

/obj/item/clothing/under/rank/security
	name = "ranger jumpsuit"
	desc = "A durable officer's jumpsuit, designed to provide moderate combat protection."
	icon_state = "security"
	item_state = "ba_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/security/verb/toggle_style()
	set name = "Adjust Style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["officer default"] = "security"
	options["officer jumpskirt"] = "security_skirt"
	options["officer formal"] = "ih_formal" //credits to Eris for the sprite
	options["officer turtleneck"] = "securityrturtle"
	options["cadet default"] = "seccadet"
	options["cadet jumpskirt"] = "cadet"
	options["cadet alt"] = "seccadetalt"

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/obj/item/clothing/under/tactical
	name = "tactical turtleneck"
	desc = "A reinforced military turtleneck, designed to provide moderate combat protection."
	icon_state = "syndicate"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/bdu/marshal
	name = "ranger BDU"
	desc = "A durable officer's Battle Dress Uniform, designed to provide moderate combat protection."
	icon_state = "bdumarshal"
	item_state = "bdumarshal"

/obj/item/clothing/under/rank/bdu/marshal/verb/toggle_style()
	set name = "Adjust style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["suit up"] = ""
	options["suit down"] = "_pants"
	options["sleeves up"] = "_rolled"

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		var/base = initial(icon_state)
		base += options[choice]
		icon_state = base
		item_state = base
		item_state_slots = null
		to_chat(M, "You roll your [choice].")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/*
 * Detective
 */
/obj/item/clothing/under/rank/inspector
	name = "ranger turtleneck"
	desc = "A casual turtleneck and jeans serving as civilian ranger clothing."
	icon_state = "insp_under"
	item_state = "insp_under"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/inspector/verb/toggle_style()
	set name = "Adjust style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["ranger Turtleneck"] = "detective"
	options["Patrol Uniform"] = "det_corporate"
	options["Detective Pants"] = "detective"
	options["Detective Skirt"] = "detective_f"

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1 //Or you could just use this instead of making another subtype just for races

/obj/item/clothing/head/rank/inspector
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "detective"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat",
		)
	allowed = list(/obj/item/reagent_containers/snacks/candy_corn, /obj/item/pen)
	armor_list = list(
		melee = 2,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	siemens_coefficient = 0.8
	body_parts_covered = 0

/obj/item/clothing/head/rank/inspector/verb/toggle_style()
	set name = "Adjust style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["Brown"] = "detective"
	options["Black"] = "detective3"
	options["Gray"] = "detective2"

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1 //Or you could just use this instead of making another subtype just for races


/*
 * Ironhammer Commander
 */
/obj/item/clothing/under/rank/ih_commander
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Captain\". It has additional armor to protect the wearer."
	name = "captain's jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/ih_commander/verb/toggle_style()
	set name = "Adjust Style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["wo jumpsuit"] = "hos"
	options["wo jumpskirt"] = "hos_skirt"
	options["wo formalwear"] = "hos_formal" //credits to Eris for the original sprite - slightly modified for our uses

	var/choice = input(M,"What kind of style do you want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/obj/item/clothing/head/rank/commander
	name = "captain's Hat"
	desc = "The hat of the Captain. For showing the officers who's in charge."
	icon_state = "hoshat"
	body_parts_covered = 0
	siemens_coefficient = 0.6

/obj/item/clothing/head/rank/mcommander
	name = "commander's Hat"
	desc = "The hat of the blackshield commander. Has a scent of napalm. Smells like victory."
	icon_state = "hoshat"
	body_parts_covered = 0
	siemens_coefficient = 0.6

/obj/item/clothing/under/rank/ranger
	name = "ranger utility uniform"
	desc = "The standard utility uniform of the Iskhod Rangers, made from a durable, insulated material."
	icon_state = "navyutility"
	item_state = "navyutility"
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/ranger/officer
	name = "ranger officer's utility uniform"
	icon_state = "navyutility_com"
	item_state = "navyutility_com"

/obj/item/clothing/under/rank/ranger/command
	name = "ranger command utility uniform"
	icon_state = "navyutility_com"
	item_state = "navyutility_com"

/obj/item/clothing/under/rank/ranger/flag
	name = "ranger flag officer utility uniform"
	icon_state = "navyutility_flag"
	item_state = "navyutility_flag"

/obj/item/clothing/under/rank/ranger/fatigues
	name = "ranger field fatigues"
	desc = "An alternative utility uniform of the Iskhod Rangers, designed for field operations where mobility is key."
	icon_state = "navycombat"
	item_state = "navycombat"

/obj/item/clothing/under/rank/ranger/service
	name = "ranger service uniform"
	desc = "The service uniform of the Iskhod Rangers, made from immaculate white fabric for formal duties."
	icon_state = "whiteservice"
	item_state = "whiteservice"

/obj/item/clothing/under/rank/ranger/service/verb/toggle_style()
	set name = "Adjust Style"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	var/mob/M = usr
	var/list/options = list()
	options["standard uniform"] = initial(icon_state)
	options["feminine uniform"] = "[initial(icon_state)]_fem"

	var/choice = input(M,"What kind of style want?","Adjust Style") as null|anything in options

	if(src && choice && !M.incapacitated() && Adjacent(M))
		icon_state = options[choice]
		item_state = options[choice]
		item_state_slots = null
		to_chat(M, "You adjusted your attire's style into [choice] mode.")
		update_icon()
		update_wear_icon()
		usr.update_action_buttons()
		return 1

/obj/item/clothing/under/rank/ranger/service/officer
	name = "ranger officer's service uniform"
	desc = "The service uniform of the Iskhod Ranger officers."
	icon_state = "whiteservice_off"
	item_state = "whiteservice_off"

/obj/item/clothing/under/rank/ranger/service/command
	name = "ranger command service uniform"
	desc = "The service uniform of the Iskhod Ranger command staff, featuring additional gold embellishments."
	icon_state = "whiteservice_comm" // Reusing com if officer isn't distinct, or if there's a specific 'com'
	item_state = "whiteservice_comm"

/obj/item/clothing/under/rank/ranger/service/flag
	name = "ranger flag officer service uniform"
	desc = "The service uniform of the Iskhod Ranger high command, featuring extensive gold trimmings."
	icon_state = "whiteservice_flag"
	item_state = "whiteservice_flag"

/obj/item/clothing/under/rank/ranger/service
	name = "ranger dress uniform"
	desc = "The full dress uniform of the Iskhod Rangers, reserved for the highest formal occasions."
	icon_state = "blueservice"
	item_state = "blueservice"

/obj/item/clothing/suit/rank/ranger/service/officer
	name = "ranger lieutenant's dress uniform"
	icon_state = "blueservice_snco"
	item_state = "blueservice_snco"

/obj/item/clothing/suit/rank/ranger/service/command
	name = "ranger command dress uniform"
	desc = "The service  uniform of the Iskhod Ranger command staff."
	icon_state = "blueservice_off"
	item_state = "blueservice_off"

/obj/item/clothing/suit/rank/ranger/service/flag
	name = "ranger flag officer dress uniform"
	desc = "The service uniform of the Iskhod Ranger high command."
	icon_state = "blueservice_flag"
	item_state = "blueservice_flag"

/obj/item/clothing/under/rank/ranger/pt
	name = "ranger pt uniform"
	desc = "A lightweight uniform for physical training and leisure."
	icon_state = "fleetpt"
	item_state = "fleetpt"


/obj/item/clothing/under/rank/ranger/dress
	name = "ranger dress uniform"
	desc = "The full dress uniform of the Iskhod Rangers, reserved for the highest formal occasions."
	icon_state = "whitedress"
	item_state = "whitedress"

/obj/item/clothing/suit/rank/ranger/service
	name = "ranger service jacket"
	desc = "A modern dark blue service jacket."
	icon_state = "blueservice"
	item_state = "blueservice"

/obj/item/clothing/suit/rank/ranger/service/officer
	name = "ranger lieutenant's service jacket"
	icon_state = "blueservice_snco"
	item_state = "blueservice_snco"

/obj/item/clothing/suit/rank/ranger/service/command
	name = "ranger captain's service jacket"
	icon_state = "blueservice_comm"
	item_state = "blueservice_comm"

/obj/item/clothing/suit/rank/ranger/service/flag
	name = "ranger flag officer service jacket"
	icon_state = "blueservice_flag"
	item_state = "blueservice_flag"

/obj/item/clothing/suit/rank/ranger/dress
	name = "ranger dress jacket"
	desc = "A modern white dress jacket."
	icon_state = "whitedress"
	item_state = "whitedress"

/obj/item/clothing/suit/rank/ranger/dress/officer
	name = "ranger lieutenant's dress uniform"
	icon_state = "whitedress_snco"
	item_state = "whitedress_snco"

/obj/item/clothing/suit/rank/ranger/dress/command
	name = "ranger command dress uniform"
	desc = "The full dress uniform of the Iskhod Ranger command staff."
	icon_state = "whitedress_off"
	item_state = "whitedress_off"

/obj/item/clothing/suit/rank/ranger/dress/flag
	name = "ranger flag officer dress uniform"
	desc = "The full dress uniform of the Iskhod Ranger high command."
	icon_state = "whitedress_flag"
	item_state = "whitedress_flag"

/obj/item/clothing/under/rank/ranger/pt
	name = "ranger pt uniform"
	desc = "A lightweight uniform for physical training and leisure."
	icon_state = "fleetpt"
	item_state = "fleetpt"

//Jensen cosplay gear
/obj/item/clothing/under/rank/jensen
	desc = "You never asked for anything that stylish."
	name = "stylish augmented jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"

/obj/item/clothing/suit/armor/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "jensencoat"
	item_state = "jensencoat"
	flags_inv = 0
	body_parts_covered = UPPER_TORSO|ARMS

