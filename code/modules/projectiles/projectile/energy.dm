/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage_types = list(BURN = 0)
	check_armor = ARMOR_ENERGY
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	recoil = 4
	heat = 100


//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	damage_types = list(BURN = 5, HALLOSS = 10)
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	if (!testing)
		var/turf/T = flash_range? src.loc : get_turf(A)
		if(!istype(T))
			return

		//blind adjacent people
		for (var/mob/living/carbon/M in viewers(T, flash_range))
			if(M.eyecheck() < FLASH_PROTECTION_MINOR)
				flash(0, FALSE,FALSE,FALSE)

		//snap pop
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		src.visible_message(SPAN_WARNING("\The [src] explodes in a bright flash!"))

		new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
		new /obj/effect/sparks(T)
		new /obj/effect/effect/smoke/illumination(T, brightness=max(flash_range*2, brightness), lifetime=light_duration)

//blinds people like the flash round, but can also be used for temporary illumination for 60~ mins
/obj/item/projectile/energy/flash/flare
	damage_types = list(BURN = 10)
	flash_range = 1
	brightness = 9 //similar to a flare
	light_duration = 60000 //this is in milasecnds.

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	mob_hit_sound = list('sound/weapons/tase.ogg')
	armor_divisor= 1.2
	nodamage = 1
	taser_effect = 1
	damage_types = list(HALLOSS = 40)
	recoil = 6
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage_types = list(BURN = 5, HALLOSS = 80)
	taser_effect = 1
	affective_damage_range = 2
	recoil = 16

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_types = list(CLONE = 0)
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage_types = list(TOX = 1)
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage_types = list(TOX = 20, HALLOSS = 40)
	nodamage = 0
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage_types = list(BURN = 30)


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage_types = list(BURN = 5)
	weaken = 5
