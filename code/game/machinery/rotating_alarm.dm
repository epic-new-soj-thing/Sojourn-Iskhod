//Warning lights
/obj/effect/spinning_light
	var/spin_rate = 1 SECOND
	var/_size = 48
	var/_factor = 0.5
	var/_density = 4
	var/_offset = 30
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	mouse_opacity = 0

/obj/effect/spinning_light/Initialize()
	. = ..()
	filters = filter(type="rays", size = _size, color = "#ff9524", factor = _factor, density = _density, flags = FILTER_OVERLAY, offset = 0)
	animate(filters[1], offset = 100, time = spin_rate, loop = -1)
	alpha = 200

/obj/machinery/rotating_alarm
	name = "Industrial alarm"
	desc = "An industrial rotating alarm light."
	icon = 'icons/obj/engine.dmi'
	icon_state = "alarm"
	idle_power_usage = 0
	active_power_usage = 0
	anchored = 1

	var/on = FALSE
	var/construct_type = /obj/machinery/light_construct

	var/static/obj/effect/spinning_light/spin_effect = null

	var/alarm_light_color = COLOR_ORANGE
	/// This is an angle to rotate the colour of alarm and its light. Default is orange, so, a 45 degree angle clockwise will make it green
	var/angle = 0

	/// Reference to the sound datum
	var/datum/repeating_sound/sound_loop
	/// Sound file to loop when turned on.
	var/sound_file

/obj/machinery/rotating_alarm/Initialize()
	. = ..()

	if(!spin_effect)
		spin_effect = new(null)

	alarm_light_color =

	set_dir(dir) //Set dir again so offsets update correctly

/obj/machinery/rotating_alarm/Destroy()
	set_off()
	return ..()

/obj/machinery/rotating_alarm/proc/set_on()
	set_spin(TRUE)
	set_noise(TRUE)

/obj/machinery/rotating_alarm/proc/set_off()
	set_spin(FALSE)
	set_noise(FALSE)

/obj/machinery/rotating_alarm/proc/set_spin(var/_on)
	if (on == _on)
		return
	if(_on)
		vis_contents += spin_effect
		set_light(3, 0.5, 2, 0.3, alarm_light_color)
	else
		vis_contents -= spin_effect
		set_light(0)
	on = _on

/obj/machinery/rotating_alarm/proc/set_noise(var/_on)
	if (_on)
		if (sound_file && !sound_loop)
			sound_loop = new(70, 36000, 0, src, sound_file, 50, 0, 7, 0.5, 0)
	else
		if (sound_loop)
			sound_loop.stop()
			sound_loop = null

/obj/machinery/rotating_alarm/supermatter
	name = "supermatter alarm"
	desc = "An industrial rotating alarm light. This one is used to monitor supermatter engines."

	frame_type = /obj/item/frame/supermatter_alarm

	angle = 15
	alarm_light_color = "#ff9524"
	sound_file = 'sound/effects/matteralarm.ogg'

/obj/machinery/rotating_alarm/supermatter/Initialize()
	. = ..()
	GLOB.supermatter_status.register_global(src, PROC_REF(check_supermatter))

/obj/machinery/rotating_alarm/supermatter/Destroy()
	GLOB.supermatter_status.unregister_global(src, PROC_REF(check_supermatter))
	. = ..()

/obj/machinery/rotating_alarm/supermatter/proc/check_supermatter(obj/machinery/power/supermatter/SM, status)
	if (SM)
		if (SM.z in GetConnectedZlevels(src.z))
			set_spin(status >= SUPERMATTER_NOTIFY)
			set_noise(status >= SUPERMATTER_WARNING)
