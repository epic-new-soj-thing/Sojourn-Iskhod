/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	matter = list(MATERIAL_WOOD = 10)
	var/mob/living/occupant = null

/obj/structure/closet/coffin/close(mob/living/user)
	..()
	for (var/mob/living/L in contents)
		//When the coffin is closed we check for mobs in it.
		if (L.mind && L.mind.key)
			//We won't check if the mob is dead yet, maybe being spaced in a coffin is an execution method
			occupant = L
			break

//The coffin processes when there's a mob inside
/obj/structure/closet/coffin/lost_in_space()
	//The coffin has left the ship. Burial at space
	if (occupant && is_dead(occupant))
		var/mob/M = key2mob(occupant.mind.key)
		//We send a message to the occupant's current mob - probably a ghost, but who knows.
		to_chat(M, SPAN_NOTICE("Your remains have been committed to the void. Your crew respawn time has been reduced by [CRYOPOD_SPAWN_BONUS_DESC]."))
		M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

		//A proper funeral for the corpse allows a faster respawn
		M.set_respawn_bonus("CORPSE_HANDLING", config.cryopod_spawn_bonus ? config.cryopod_spawn_bonus MINUTES : CRYOPOD_SPAWN_BONUS)

		qdel(occupant)
		qdel(src)

	return TRUE

/obj/structure/closet/coffin/Destroy()
	occupant = null
	return ..()

/obj/structure/closet/coffin/spawnercorpse
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	welded = 1
