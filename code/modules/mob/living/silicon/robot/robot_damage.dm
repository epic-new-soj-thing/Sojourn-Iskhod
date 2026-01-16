/mob/living/silicon/robot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.brute_damage
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.electronics_damage
	return amount

/mob/living/silicon/robot/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(var/brute, var/burn, var/destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armor()

	if(!components.len) return FALSE
	var/datum/robot_component/C = components["armor"]
	if(C && C.installed == 1)
		return C
	return FALSE

/mob/living/silicon/robot/heal_organ_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)
	if(!parts.len)	return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute,burn)
	regenerate_icons() // Update overlays when damage is healed

/mob/living/silicon/robot/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/edge = 0, var/emp = 0)
	var/list/components = get_damageable_components()
	if(!components.len)
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute*shield.shield_level
		var/absorb_burn = burn*shield.shield_level
		var/cost = (absorb_brute+absorb_burn)*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, "\red Your shield has overloaded!")
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "\red Your shield absorbs some of the impact!")

	if(!emp)
		var/datum/robot_component/armor/A = get_armor()
		if(A)
			A.take_damage(brute,burn,sharp,edge)
			return

	var/datum/robot_component/C = pick(components)
	C.take_damage(brute,burn,sharp,edge)

/mob/living/silicon/robot/heal_overall_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

	regenerate_icons() // Update overlays when damage is healed

/mob/living/silicon/robot/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute*shield.shield_level
		var/absorb_burn = burn*shield.shield_level
		var/cost = (absorb_brute+absorb_burn)*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, "\red Your shield has overloaded!")
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "\red Your shield absorbs some of the impact!")

	var/datum/robot_component/armor/A = get_armor()
	if(A)
		var/armor_value = 0
		if(A.armor)
			if(used_weapon)
				//It would be nice to have a way to get the damage type from the weapon, but we don't.
				//So we assume melee.
				armor_value = A.armor["melee"]
			else
				armor_value = A.armor["melee"] //Fall back to melee if unspecified? Or maybe just brute?

		//Apply armor reduction
		//Standard body armor formula is usually prob(armor) to block, or flat reduction?
		//Looking at code, clothing/suits seem to just have values.
		//Let's assume standard Baystation/TG armor logic: damage = max(0, damage - armor_value/X) or prob based?
		//Actually, let's look at human defense to be sure, but since I can't look at files casually, I will use a probability block similar to bullet_act for now or flat reduction if high.

		//For consistent mechanics with "mech armor" or "traditional body armor", flat reduction is good for mechs.
		//But vest values are small (10, 20). Usually that's a probability to block OR a reduction.
		//Let's assume it's a reduction percentage for now? No, 10-20 is low for % if max is 100.
		//Let's assume it's a flat reduction for Mechs.
		//But for body armor it's usually: if(prob(armor)) reduce damage.

        //Wait, I'll stick to a simple damage reduction based on the armor value.
        //If armor is 50, reduce damage by 50%?
        //Actually, checking bullet_act earlier: chance = max((chance / B.armor_divisor), 0).

        //Let's implement a flat percent reduction based on the value, clamped.
        //If armor is 50, takes 50% less damage.
        if (A.armor && A.armor["melee"])
             var/reduction = A.armor["melee"] / 100
             brute *= max(0, 1 - reduction)
             burn *= max(0, 1 - reduction) //Assuming melee covers both? Or should checking burn?

        //Original logic below:
		A.take_damage(brute*A.brute_mult,burn*A.burn_mult,sharp)
		return

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage(brute,burn)

		brute	-= (picked.brute_damage - brute_was)
		burn	-= (picked.electronics_damage - burn_was)

		parts -= picked

/mob/living/silicon/robot/emp_act(severity)
	uneq_all()
	..() //Damage is handled at /silicon/ level.



/mob/living/silicon/robot/get_fall_damage(var/turf/from, var/turf/dest)
	//Robots should not be falling! Their bulky inarticulate frames lack shock absorbers, and gravity turns their armor plating against them
	//Falling down a floor is extremely painful for robots, and for anything under them, including the floor

	var/damage = maxHealth*0.49 //Just under half of their health
	//A percentage is used here to simulate different robots having different masses. The bigger they are, the harder they fall

	//Falling two floors is not an instakill, but it almost is
	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage


//On impact, robots will damage everything in the tile and surroundings
/mob/living/silicon/robot/fall_impact(var/turf/from, var/turf/dest)
	take_overall_damage(get_fall_damage(from, dest))

	Stun(5)
	updatehealth()
	//Wreck the contents of the tile
	for (var/atom/movable/AM in dest)
		if (AM != src)
			AM.ex_act(3)

	//Damage the tile itself
	dest.ex_act(2)

	//Damage surrounding tiles
	for (var/turf/T in range(1, src))
		if (T == dest)
			continue

		T.ex_act(3)

	//And do some screenshake for everyone in the vicinity
	for (var/mob/M in range(20, src))
		var/dist = get_dist(M, src)
		dist *= 0.5
		if (dist <= 1)
			dist = 1 //Prevent runtime errors

		shake_camera(M, 10/dist, 2.5/dist, 0.12)

	playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(1)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	spawn(2)
		playsound(src, 'sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	playsound(src, pick(robot_talk_heavy_sound), 100, 1, 5,5)

/mob/living/silicon/robot/IgniteMob()
	..()
	//Overpower the fire with are normal light I suppose
	if(custom_color)
		light_color = custom_color

/mob/living/silicon/robot/ExtinguishMob()
	..()
	if(custom_color)
		light_color = custom_color
	else
		light_color = null
