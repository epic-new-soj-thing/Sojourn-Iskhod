/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	has_unlimited_silicon_privilege = TRUE
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel = MAIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/device/radio/common_radio
	//plug before baymed arrives
	var/obj/item/device/radio/silicon_radio

	var/list/hud_list[10]
	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/device/camera/siliconcam/aiCamera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/sensor_mode = 0 //Determines the current HUD.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/list/access_rights
	var/obj/item/card/id/idcard
	var/idcard_type = /obj/item/card/id/synthetic

	var/email_ringtone = TRUE

	#define SEC_HUD 1 //Security HUD mode
	#define MED_HUD 2 //Medical HUD mode
	mob_classification = CLASSIFICATION_SYNTHETIC
	colony_friend = TRUE

	status_flags = CANWEAKEN|CANSTUN|CANPUSH

/mob/living/silicon/Initialize()
	GLOB.silicon_mob_list |= src
	. = ..()
	add_language(LANGUAGE_COMMON)
	add_language(LANGUAGE_ROBOT)
	add_language(LANGUAGE_COMMON)
	add_language(LANGUAGE_ILLYRIAN)
	add_language(LANGUAGE_EURO)
	add_language(LANGUAGE_JANA)
	add_language(LANGUAGE_CYRILLIC)
	add_language(LANGUAGE_LATIN)
	add_language(LANGUAGE_KRIOSAN)
	add_language(LANGUAGE_AKULA)
	add_language(LANGUAGE_MARQUA)
	add_language(LANGUAGE_SYNTHETIC)
	add_language(LANGUAGE_MERP)
	add_language(LANGUAGE_BLORP)
	add_language(LANGUAGE_WEH)
	add_language(LANGUAGE_SABLEKYNE)
	init_id()
	init_subsystems()

/mob/living/silicon/New()
	..()
	if(ckey)
		return
//		recalibrate_hotkeys()

/mob/living/silicon/Destroy()
	GLOB.silicon_mob_list -= src
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.unregister_alarm(src)
	. = ..()

/mob/living/silicon/lay_down()
	resting = FALSE
	update_lying_buckled_and_verb_status()
	updateicon()

/mob/living/silicon/proc/init_id()
	if(idcard)
		return
	idcard = new idcard_type(src)
	set_id_info(idcard)

/mob/living/silicon/SetName(pickedName as text)
	real_name = pickedName
	name = real_name
	create_or_rename_email(pickedName, "root.rt")
//	recalibrate_hotkeys()

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item()
	if(isrobot(src))
		var/mob/living/silicon/robot/R = src
		R.update_robot_modules_display()
	return

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_organ_damage(0,20,emp=TRUE)
			Stun(rand(5,10))
		if(2)
			src.take_organ_damage(0,10,emp=TRUE)
			confused = (min(confused + 2, 30))
//	flick("noise", src.flash)
	flash(0, FALSE , FALSE , FALSE)
	to_chat(src, SPAN_DANGER("<B>*BZZZT*</B>"))
	to_chat(src, SPAN_DANGER("Warning: Electromagnetic pulse detected."))
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)

	if (istype(source, /obj/machinery/containment_field))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("\red [src] was shocked by \the [source]!", \
			"\red <B>Energy pulse detected, system damaged!</B>", \
			"\red You hear an electrical crack")
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/bullet_act(var/obj/item/projectile/Proj)
	if (Proj.is_hot() >= HEAT_MOBIGNITE_THRESHOLD && (!(Proj.testing)))
		IgniteMob()

	if(!Proj.nodamage)
		if(Proj.damage_types[BRUTE] && (!(Proj.testing)))
			adjustBruteLoss(Proj.damage_types[BRUTE])
		if(Proj.damage_types[BURN] && (!(Proj.testing)))
			adjustFireLoss(Proj.damage_types[BURN])

	Proj.on_hit(src)
	if (!(Proj.testing))
		updatehealth()
	return 2

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/armor_value = 0, var/check_protection = 1)
	return FALSE//The only effect that can hit them atm is flashes and they still directly edit so this works for now

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0


// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	. = list()
	if(!src.stat)
		. += "System integrity: [round((health/maxHealth)*100)]%"
	else
		. += "Systems nonfunctional"


// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return list()

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(evacuation_controller)
		var/eta_status = evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/get_status_tab_items()
	. = ..()
	. += show_system_integrity()
	. += show_malf_ai()

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/error_msg, var/target_zone)
	if(error_msg)
		to_chat(user, "<span class='alert'>The armored plating is too tough.</span>")
	return 0

//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	var/datum/language/added_language = all_languages[language]
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	var/datum/language/removed_language = all_languages[rem_language]
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br/>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(HTML_SKELETON(dat), "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical","Disable")
	switch(sensor_type)
		if ("Security")
			sensor_mode = SEC_HUD
			to_chat(src, SPAN_NOTICE("Security records overlay enabled."))
		if ("Medical")
			sensor_mode = MED_HUD
			to_chat(src, SPAN_NOTICE("Life signs monitor overlay enabled."))
		if ("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. It is...", "Pose", null) as text)

// CFW - killing this with fire because it doesn't work and creates runtimes
///mob/living/silicon/verb/recalibrate_hotkeys()
//	set name = "Recalibrate Hotkeys"
//	set desc = "Makes you use the correct borg based hotkeys."
//	set category = "OOC"
//
// CFW - This doesn't work (runtimes because client.get_preference_value always returns null.get_preference_value).
//	if(client)
//		if(client?.get_preference_value(/datum/client_preference/stay_in_hotkey_mode) == GLOB.PREF_YES)
//			winset(client, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=true mapwindow.map.focus=true")
//		else
//			winset(client, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true")
// Doing a work-around for now.
//	winset(client, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true")

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/ex_act(severity)
	flash(0, FALSE , FALSE , FALSE)

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)

	updatehealth()

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, SPAN_WARNING("--- [AH.category] Detected ---"))
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						to_chat(src, SPAN_NOTICE("--- [AH.category] Cleared ---"))
					to_chat(src, "\The [A.alarm_name()].")

		if(alarm_raised)
			to_chat(src, "<A HREF=?src=\ref[src];showalerts=1>\[Show Alerts\]</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF='?src=\ref[src];switchcamera=\ref[C]'>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")

/mob/living/silicon/proc/is_malf_or_contractor()
	return check_special_role(ROLE_CONTRACTOR) || check_special_role(ROLE_MALFUNCTION)

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow = null
