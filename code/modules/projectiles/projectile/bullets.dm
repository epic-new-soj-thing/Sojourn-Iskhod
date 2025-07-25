/*
Bullets are fickle and lead to ammo choices, for idea ranges, damage types and affects wanted.
Bullets tend to also embed and be much more deadly then lasers making them ideal when used correctly.
Bullet also tend to have more armor against them do to this and can be douged unless are hitscan
*/
/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage_types = list(BRUTE = 20)
	nodamage = 0
	check_armor = ARMOR_BULLET
	embed = TRUE
	sharp = 0
	hitsound_wall = "ric_sound"

	affective_damage_range = 6
	affective_ap_range = 10

	has_drop_off = TRUE

	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/bullet/muzzle
	recoil = 3
	structure_damage_factor = 2 //Bullets are great at destorying things, unlike lasers

/obj/item/projectile/bullet/on_hit(atom/target)
	if(!testing)
		if (..(target))
			var/mob/living/L = target
			if (!testing)
				shake_camera(L, 1, 1, 0.5)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, distance, miss_modifier)
	if(penetrating > 0 && damage_types[BRUTE] > 20 && prob(damage_types[BRUTE]))
		mob_passthrough_check = 1
	else
		var/obj/item/grab/G = locate() in target_mob
		if(G && G.state >= GRAB_NECK)
			mob_passthrough_check = rand()
		else
			mob_passthrough_check = 0
	return ..()

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check || testing)
		return FALSE
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	var/datum/penetration_holder/holder = penetration_holder
	if(!A || !A.density)
		return TRUE //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return TRUE //mecha have their own penetration handling
	var/damage = damage_types[BRUTE]
	if(ismob(A))
		if(mob_passthrough_check || (A in holder.force_penetration_on))
			if(iscarbon(A))
				damage *= 0.7
			if (testing) //we are only tracking as a trace
				holder.force_penetration_on += A
			else
				holder.force_penetration_on -= A
			return TRUE
		else
			return FALSE

	var/chance = 0
	if(istype(A, /turf/simulated/wall)) // TODO: refactor this from functional into OOP
		var/turf/simulated/wall/W = A
		chance = round(penetrating/2 * armor_divisor * 2 / W.material.integrity * 180)
	else if(istype(A, /obj/item/shield))
		var/obj/item/shield/S = A
		chance = round(armor_divisor * 2 / S.durability * 180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(penetrating/2 * armor_divisor * 2 / D.maxHealth * 180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100
	else if(istype(A, /obj/structure/low_wall))
		chance = round(penetrating/2 * armor_divisor * 2 / 150 * 180) // hardcoded, value is same as steel wall, will have to be changed once low walls have integrity
	else if(istype(A, /obj/structure/table))
		var/obj/structure/table/T = A
		chance = round(penetrating/2 * armor_divisor * 2 / T.maxHealth * 180)
	else if(istype(A, /obj/structure/barricade))
		var/obj/structure/barricade/B = A
		chance = round(penetrating/2 * armor_divisor * 2 / B.material.integrity * 180)
	else if(istype(A, /obj/machinery) || istype(A, /obj/structure))
		chance = armor_divisor * penetrating/2

	if(prob(chance) || (A in holder?.force_penetration_on))
		if(A.opacity || istype(A, /obj/item/shield))
			//display a message so that people on the other side aren't so confused
			A.visible_message(SPAN_WARNING("\The [src] pierces through \the [A]!"))
			playsound(A.loc, 'sound/weapons/shield/shieldpen.ogg', 50, 1)
		if (testing)
			holder.force_penetration_on += A //we are only tracking as a trace
		else
			holder.force_penetration_on -= A
		return TRUE

	return FALSE

//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	damage_types = list(BRUTE = 15)
	//icon_state = "bullet" //TODO: would be nice to have it's own icon state
	var/pellets = 4			//number of pellets
	var/range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/spread_step = 10	//higher means the pellets spread more across body parts with distance

/obj/item/projectile/bullet/pellet/Bumped()
	. = ..()
	bumped = 0 //can hit all mobs in a tile. pellets is decremented inside attack_mob so this should be fine.

/obj/item/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	var/remaining = pellets - pellet_loss
	if (remaining < 0)
		return 0
	return ROUND_PROB(remaining)

/obj/item/projectile/bullet/pellet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)


	var/total_pellets = get_pellets(distance)
	if (total_pellets <= 0)
		return 1
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		//pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		//whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..()) hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	if (hits >= total_pellets || pellets <= 0)
		return 1
	return 0

/obj/item/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/item/projectile/bullet/pellet/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc)) //Bump if lying or if we would normally Bump.
				if(Bump(M)) //Bump will make sure we don't hit a mob multiple times
					return

/obj/item/projectile/bullet/pellet/adjust_damages(var/list/newdamages)
	if(!newdamages.len)
		return
	for(var/damage_type in newdamages)
		var/bonus = pellets > 2 ? newdamages[damage_type] / pellets * 2 : newdamages[damage_type]
		if(damage_type == IRRADIATE)
			irradiate += bonus
			continue
		damage_types[damage_type] += bonus
