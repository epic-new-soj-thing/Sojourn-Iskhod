//THIS MODULE CAUSES EXACTLY 1 INGAME RUNTIME THAT IS EXPECTED, AND ONLY OCCURS ONCE - WHICH IS IT WILL STATE THAT THE MODULE HAS BEEN RE-INITIALIZED\\
//IGNORE THIS, IT IS A RUNTIME THAT MUST HAPPEN OR ELSE THE MODULE MAY BREAK AND/OR INCORRECTLY FUNCTION.alist
//TODO: Find a way of updating modules without calling init().

/obj/item/borg/upgrade/customgun //Re-uses the big knife upgrade code, with some additions
	name = "CWMF-04 'Jaeger' Frame"
	desc = "Mounts any form of firearm to Synthetics. Due to how the system functions, \
	There is no active recoil stabilisation, meaning that operators should be mindful of the weapons they mount." //You cannot remove weapons from the module... And more importantly, you are one-handing them according to the game. I hope you enjoy a 180* recoil spread.
	icon_state = "cyborg_upgrade3"
	matter = list(MATERIAL_STEEL = 25, MATERIAL_GOLD = 5, MATERIAL_DIAMOND = 1, MATERIAL_PLATINUM = 3) //You can mount a Fenrir to a janibot.
	var/obj/item/gun/ref_to_gun = null //This should always be expecting a gun subtype.

/obj/item/borg/upgrade/customgun/attackby(obj/item/I, mob/living/user, params)
	var/tempgun = I

	if(istype(tempgun,/obj/item/gun))
		ref_to_gun = tempgun //Make ABSOLUTELY sure that this is a firearm of some kind, else we're going to have a real bad time
		user.drop_item()
		sleep(1) //I HATE USING SLEEP BUT ITS ACTUALLY NECESSARY HERE TO PREVENT A REALLY NASTY BUG - Plus! It only runs once.
		to_chat(user, "You insert [tempgun] into [src], securing the locking lugs afterwards. No going back now.")
		src.contents += ref_to_gun
		ref_to_gun.invisibility = 30
	else
		to_chat(user, "This is not a firearm, or does not fit into the mount!")
		return FALSE

/obj/item/borg/upgrade/customgun/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if(!R.module) // no sir please do not delete my gun for no reason
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	else
		R.module.modules += ref_to_gun
		R.module.Initialize() //Fixes layering and possible tool issues
		ref_to_gun.twohanded = FALSE
		ref_to_gun.wielded = TRUE
		ref_to_gun.invisibility = 0
		ref_to_gun.auto_eject = TRUE //This is needed because removing magazines would require modification of gripper code, and that was a headache.
		R.module.contents += ref_to_gun
		return 1

/obj/item/borg/upgrade/customgun/unaction(mob/living/silicon/robot/R)
	..()
	R.module.modules -= ref_to_gun
	R.module.contents -= ref_to_gun
	ref_to_gun.invisibility = 35 //Make this invisible to clients. It's messy, sure (but temporary)
	R.module.Initialize() //This is horrible, but we need to re-initialize the module afterwards to prevent null-ref issues.
