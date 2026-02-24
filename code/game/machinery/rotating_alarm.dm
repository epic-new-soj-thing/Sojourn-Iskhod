//Warning lights
/obj/spinning_light
	var/spin_rate = 1 SECOND
	var/_size = 48
	var/_factor = 0.5
	var/_density = 4
	var/_offset = 30
	var/_color = COLOR_ORANGE
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	mouse_opacity = 0


/obj/spinning_light/Initialize()
	. = ..()
	filters = filter(type="rays", size = _size, color = _color, factor = _factor, density = _density, flags = FILTER_OVERLAY, offset = _offset)

	alpha = 200

	//Rays start rotated which made synchronizing the scaling a bit difficult, so let's move it 45 degrees
	var/matrix/m = new
	var/matrix/test = new
	test.Turn(-45)
	//var/matrix/squished = new
	//squished.Scale(1, 0.5)
	animate(src, transform = test * m.Turn(90), time = spin_rate / 4, loop = -1)
	animate(transform = test * m.Turn(90), time = spin_rate / 4, loop = -1)
	animate(transform = test * m.Turn(90), time = spin_rate / 4, loop = -1)
	animate(transform = test * matrix(),   time = spin_rate / 4, loop = -1)


/obj/spinning_light/proc/set_color(_color)
	filters = filter(type="rays", size = _size, color = _color, factor = _factor, density = _density, flags = FILTER_OVERLAY, offset = _offset)


/obj/machinery/rotating_alarm
	name = "industrial alarm"
	desc = "An industrial rotating alarm light."
	icon = 'icons/obj/engine.dmi'
	icon_state = "alarm"
	idle_power_usage = 0
	active_power_usage = 0
	anchored = TRUE

	var/on = FALSE
	var/low_alarm = FALSE
	var/construct_type = /obj/machinery/light_construct

	var/obj/spinning_light/spin_effect = null

	var/alarm_light_color = COLOR_ORANGE
	/// This is an angle to rotate the colour of alarm and its light. Default is orange, so, a 45 degree angle clockwise will make it green
	var/angle = 0

	var/static/list/spinning_lights_cache = list()

	/// Reference to the sound player looping sound instance.
	var/datum/sound_token/sound_loop
	/// Sound file to loop when turned on.
	var/sound_file


/obj/machinery/rotating_alarm/Initialize()
	. = ..()

	//Setup colour
	var/list/color_matrix = color_rotation(angle)

	color = color_matrix

	set_color(alarm_light_color)

	set_dir(dir) //Set dir again so offsets update correctly


/obj/machinery/rotating_alarm/Destroy()
	set_off()
	return ..()


/obj/machinery/rotating_alarm/start_on/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	set_on()


/obj/machinery/rotating_alarm/set_dir(ndir) //Due to effect, offsets cannot be part of sprite, so need to set it for each dir
	. = ..()
	if(dir == NORTH)
		pixel_y = 15
	if(dir == SOUTH)
		pixel_y = -15
	if(dir == WEST)
		pixel_x = -15
	if(dir == EAST)
		pixel_x = 15


/obj/machinery/rotating_alarm/proc/set_color(color)
	if (on)
		vis_contents -= spin_effect
	if (isnull(spinning_lights_cache["[color]"]))
		spinning_lights_cache["[color]"] = new /obj/spinning_light()
	spin_effect = spinning_lights_cache["[color]"]
	alarm_light_color = color
	var/HSV = RGBtoHSV(alarm_light_color)
	var/RGB = HSVtoRGB(RotateHue(HSV, angle))
	alarm_light_color = RGB
	spin_effect.set_color(color)
	if (on)
		vis_contents += spin_effect


/obj/machinery/rotating_alarm/proc/set_on()
	if (on)
		return
	vis_contents += spin_effect
	set_light(2, 0.5, 2, 0.3, alarm_light_color)
	on = TRUE
	low_alarm = FALSE
	if (!sound_file)
		return
	sound_loop = GLOB.sound_player.play_looping(
		src,
		"\ref[src]",
		sound_file,
		50,
		7
	)


/obj/machinery/rotating_alarm/proc/set_off()
	if (!on)
		return
	vis_contents -= spin_effect
	set_light(0)
	on = FALSE
	low_alarm = FALSE
	if (!sound_loop)
		return
	QDEL_NULL(sound_loop)

/obj/machinery/rotating_alarm/supermatter
	name = "supermatter alarm"
	desc = "An industrial rotating alarm light. This one is used to monitor supermatter engines."
	frame_type = /obj/item/frame/supermatter_alarm
	angle = 15
	alarm_light_color = COLOR_ORANGE
	sound_file = 'sound/machines/supermatter.ogg'
	var/last_status = SUPERMATTER_INACTIVE

/obj/machinery/rotating_alarm/supermatter/Initialize()
	. = ..()
	START_PROCESSING(SSmachines, src)

/obj/machinery/rotating_alarm/supermatter/Destroy()
	. = ..()

/obj/machinery/rotating_alarm/supermatter/Process(seconds_per_tick)
    var/found_sm = FALSE
    var/highest_status = 0

    for(var/obj/machinery/power/supermatter/S in GLOB.machines)
        // Check if SM is on a connected Z-level
        if (S.z in GetConnectedZlevels(z))
            found_sm = TRUE
            highest_status = max(S.get_status(), highest_status)

    // If no SM was found at all, or if the status is safe, turn off
    if(!found_sm || highest_status < SUPERMATTER_NOTIFY)
        if(last_status != 0) // Only update if state actually changed
            last_status = 0
            set_off()
    else if(last_status != highest_status)
        last_status = highest_status
        set_on()
