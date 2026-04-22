//Adding in robot energy powered variants of guns, to avoid the hassle of needing to reload, etc. Centralising them all here for ease of use.

/obj/item/gun/energy/riot
	name = "intergrated \"State\" riot shotgun"
	desc = "A Seinemetall Defense GmbH riot auto action shotgun, its uncommonly seen deployed in most police operation due to the success of the \"stolen\" \"Regulator\" design. \
	This particular shotgun has been redesigned many times, never quite reaching a standard everyone was happy with, with some lauding it as confusing for a shotgun. \
	This variant has been designed to flash-synthesise ammunition from an onboard cell, for Synthetic use."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "riot_shotgun"
	item_state = "riot_shotgun"
	cell_type = /obj/item/cell/medium/greyson
	modifystate = null
	force = WEAPON_FORCE_PAINFUL
	charge_cost = 120 //200 was excessive for this thing's cooldowns.
	self_recharge = 1
	init_firemodes = list(
		list(mode_name="beanbag", projectile_type=/obj/item/projectile/bullet/shotgun/beanbag, fire_sound = 'sound/weapons/guns/fire/shotgun_combat.ogg', fire_delay=25, icon="stun"),
		list(mode_name="slug", projectile_type=/obj/item/projectile/bullet/shotgun, fire_sound='sound/weapons/guns/fire/shotgun_combat.ogg', fire_delay=10, icon="kill"),
		list(mode_name="buckshot", projectile_type=/obj/item/projectile/bullet/pellet/shotgun, fire_sound='sound/weapons/guns/fire/shotgun_combat.ogg', fire_delay=10, icon="kill"),
		list(mode_name="pepperball", projectile_type=/obj/item/projectile/bullet/shotgun/beanbag/pepperball, fire_sound='sound/weapons/guns/fire/shotgun_combat.ogg', fire_delay=10, icon="stun")
	)
	serial_type = "SD GmbH"
	charge_meter = FALSE

/obj/item/gun/energy/bsrifle
	name = "integrated \"STS\" Rifle"
	desc = "A lightweight modified variant of the STS-PARA that has been modified to serve as the main-arm for a combat bot, much of its comfort features have been\
	removed in order to optimize space for an integral flash-synthesizer hooked directly to its power, keeping it flush with ammo as long as the power supply is steady; though decreasing rate of fire as a result."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "security_rifle"
	item_state = "security_rifle"
	damage_multiplier = 1.19 //Damage Multiplier Decrease. These are pretty destructive even as is
	cell_type = /obj/item/cell/medium/greyson
	modifystate = null
	force = WEAPON_FORCE_PAINFUL
	charge_cost = 65 //24 round max capacity - can sustain fire for 15 seconds then has to disengage for around 25
	self_recharge = 1
	recharge_time = 5 // Every 5 ticks
	recharge_amount = 150 // Approximately 3 rounds (per 3 seconds)
	charge_meter = TRUE
	serial_type = "NM"
	init_firemodes = list(
		list(mode_name="Rubber Munitions", projectile_type=/obj/item/projectile/bullet/rifle_75/rubber, fire_sound = 'sound/weapons/guns/fire/NM_PARA.ogg', mode_type = /datum/firemode/automatic,  fire_delay = 2, icon="burst"),
		list(mode_name="Standard Munitions", projectile_type=/obj/item/projectile/bullet/rifle_75, fire_sound = 'sound/weapons/guns/fire/NM_PARA.ogg', mode_type = /datum/firemode/automatic,  fire_delay = 3, icon="burst"),
		list(mode_name="Hollowpoint Munitions", projectile_type=/obj/item/projectile/bullet/rifle_75/lethal, fire_sound = 'sound/weapons/guns/fire/NM_PARA.ogg', mode_type = /datum/firemode/automatic,  fire_delay = 3.5,  icon="burst"),
		list(mode_name="Incendiary Munitions", projectile_type=/obj/item/projectile/bullet/rifle_75/incend, fire_sound = 'sound/weapons/guns/fire/NM_PARA.ogg', mode_type = /datum/firemode/automatic,  fire_delay = 3.5, icon="burst")
		) //Burst fire felt like dogshit, I'd rather use a slightly slower full auto mode.

/obj/item/gun/energy/dazzlation //the last gun you'll ever need.
	name = "integrated \"Dazlation\" light pistol"
	icon = 'icons/obj/guns/projectile/flaregun.dmi'
	icon_state = "flaregun"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg'
	cell_type = /obj/item/cell/small/greyson
	charge_cost = 200 //2 shots per 'charge'
	proj_step_multiplier = 0.5
	self_recharge = 1
	charge_meter = FALSE

	init_firemodes = list(
		list(mode_name="Red Flare", projectile_type=/obj/item/projectile/bullet/flare, fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg', fire_delay = 20 , icon="grenade"),
		list(mode_name="Green Flare", projectile_type=/obj/item/projectile/bullet/flare/green, fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg', fire_delay = 20 , icon="grenade"),
		list(mode_name="Blue Flare", projectile_type=/obj/item/projectile/bullet/flare/blue, fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg', fire_delay = 20  , icon="grenade"),
		list(mode_name="Random Flare", projectile_type=/obj/item/projectile/bullet/flare/chaos, fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg', fire_delay = 20  , icon="grenade")
		)

/obj/item/gun/energy/borg/pistol
	name = "\"Glockinator\" Integrated Autopistol"
	desc = "An ammo-synthensizing pistol based off of ancient, recovered designs from Old Earth Culture. This one has a flash-munitions synthensizer hidden within a drum magazine\
	  And a 'switch' present on the back, capable of alternating between single-shot and full-auto. Supposedly extremely inaccurate."
	icon = 'icons/obj/guns/projectile/glock.dmi'
	icon_state = "glock"
	item_state = "glock"
	cell_type = /obj/item/cell/medium/greyson
	modifystate = null
	charge_cost = 50 //This was so terrible it was hard to describe.
	recharge_time = 2 //Incredibly fast recharge time.
	recharge_amount = 100 //2 rounds per 2 ticks. Not enough to sustain continous fire, but enough to justify it's god-awful damage output
	init_recoil = SMG_RECOIL(0.4) //Hard to control accurately in most cases.
	self_recharge = 1
	init_firemodes = list(
		list(mode_name="Rubber Bullet (Single)", projectile_type=/obj/item/projectile/bullet/pistol_35/rubber, fire_sound = 'sound/weapons/guns/fire/9mm_pistol.ogg', fire_delay=3, icon="stun"),
		list(mode_name="Hollowpoint Round (Single)", projectile_type=/obj/item/projectile/bullet/pistol_35/lethal, fire_sound='sound/weapons/guns/fire/9mm_pistol.ogg', fire_delay=3, icon="kill"),
		list(mode_name = "Rubber Rounds (Switch)", projectile_type=/obj/item/projectile/bullet/pistol_35/rubber, fire_sound='sound/weapons/guns/fire/9mm_pistol.ogg', mode_type = /datum/firemode/automatic, fire_delay = 1.3  , icon="fuller"),
		list(mode_name = "Hollowpoint Rounds (Switch)", projectile_type=/obj/item/projectile/bullet/pistol_35/lethal, fire_sound='sound/weapons/guns/fire/9mm_pistol.ogg',  mode_type = /datum/firemode/automatic, fire_delay = 1.15, icon="fuller")
	)
	charge_meter = FALSE

/obj/item/gun/energy/smg
	icon = 'icons/obj/guns/projectile/armsmg.dmi'
	icon_state = "armsmg"
	item_state = null
	name = "embedded energy SMG"
	desc = "An energy-based SMG deployed from your arm. A hidden weapon favoured by many."
	cell_type = /obj/item/cell/medium/greyson
	charge_cost = 25
	self_recharge = 1
	fire_sound = 'sound/weapons/energy/laser_pistol.ogg'
	projectile_type = /obj/item/projectile/bullet/pistol_35/lethal //self defense gun, great for bugs less good for a "real fight" against anyone with anything resembling armor
	damage_multiplier = 0.7
	penetration_multiplier = 0.7
	init_recoil = HANDGUN_RECOIL(0.4) //Hard to control accurately in most cases.
	charge_meter = FALSE
	gun_tags = list(GUN_PROJECTILE, GUN_CALIBRE_35)
	init_firemodes = list(
		FULL_AUTO_300_NOLOSS,
		BURST_3_ROUND_NOLOSS,
		SEMI_AUTO_NODELAY
		)

/obj/item/gun/energy/smg/blackshield
	init_recoil = HANDGUN_RECOIL(0.2) //Unless you've got built-in targetting software.
	cell_type = /obj/item/cell/medium/hyper //we're not Vesalius-Andra produced, so we don't get a Vesalius-Andra cell.
