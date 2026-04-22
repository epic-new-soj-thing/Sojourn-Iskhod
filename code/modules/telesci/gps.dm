GLOBAL_LIST_EMPTY(GPS_list)

GLOBAL_LIST_EMPTY(gps_by_type)

/obj/item/device/gps
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016. Still works, even after the bluespace crash."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 25, MATERIAL_GLASS = 5)
	var/gps_prefix = "COM"
	var/gpstag = "COM0"
	var/emped = 0
	var/turf/locked_location
	var/datum/browser/gps_browser

/obj/item/device/gps/Initialize()
	. = ..()
	GLOB.GPS_list += src
	LAZYADD(GLOB.gps_by_type["[type]"], src)
	gpstag = "[gps_prefix][LAZYLEN(GLOB.gps_by_type["[type]"])]"
	name = "global positioning system ([gpstag])"
	add_overlay(image(icon, "working"))

/obj/item/device/gps/Destroy()
	if(gps_browser?.user)
		GLOB.moved_event.unregister(gps_browser.user, src)
	gps_browser = null
	GLOB.GPS_list -= src
	var/list/typelist = GLOB.gps_by_type["[type]"]
	LAZYREMOVE(typelist, src)
	return ..()

/obj/item/device/gps/emp_act(severity)
	emped = 1
	cut_overlays()
	add_overlay(image(icon, "emp"))
	addtimer(CALLBACK(src, PROC_REF(post_emp)), 300)

/obj/item/device/gps/proc/post_emp()
	emped = 0
	cut_overlays()
	add_overlay(image(icon, "working"))

/proc/_gps_format_line(tag, area_name, x, y, z)
	return "<BR>[tag]: [format_text(area_name)] ([x], [y], [z])"

/obj/item/device/gps/proc/get_gps_html()
	var/html = ""
	if(emped)
		html += "ERROR"
	else
		html += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		html += "<BR>Tag: [gpstag]"
		if(locked_location && locked_location.loc)
			html += "<BR>Bluespace coordinates saved: [locked_location.loc]"

		for(var/obj/item/device/gps/G in GLOB.GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1 || !pos)
				html += "<BR>[tracked_gpstag]: ERROR"
			else
				html += _gps_format_line(tracked_gpstag, gps_area.name, pos.x, pos.y, pos.z)
	return html

/obj/item/device/gps/proc/on_holder_moved(atom/movable/mover, atom/old_loc, atom/new_loc)
	if(!gps_browser || !gps_browser.user || gps_browser.user != mover)
		return
	gps_browser.set_content(get_gps_html())
	gps_browser.update()

/obj/item/device/gps/attack_self(mob/user)

	if(gps_browser?.user)
		GLOB.moved_event.unregister(gps_browser.user, src)

	var/gps_window_height = 110 + GLOB.GPS_list.len * 20 // Variable window height, depending on how many GPS units there are to show
	if(locked_location && locked_location.loc)
		gps_window_height += 20

	var/html = get_gps_html()
	var/window_id = "gps_\ref[src]"
	gps_browser = new(user, window_id, name, 360, min(gps_window_height, 800), src)
	gps_browser.set_content(html)
	gps_browser.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	gps_browser.open()

	GLOB.moved_event.register(user, src, PROC_REF(on_holder_moved))

/obj/item/device/gps/Topic(href, href_list)
	..()
	if(href_list["close"])
		if(gps_browser?.user)
			GLOB.moved_event.unregister(gps_browser.user, src)
		gps_browser = null
		return
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_prefix = "SCI"
	gpstag = "SCI0"

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_prefix = "ENG"
	gpstag = "ENG0"

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_prefix = "MIN"
	gpstag = "MIN0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life."
