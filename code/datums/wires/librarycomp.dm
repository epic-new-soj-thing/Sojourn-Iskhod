// Wires for the library check-in/out computer (staff console).
// Cutting or pulsing the restriction-bypass wire enables the Forbidden Lore menu (emagged).

var/const/LIBRARY_WIRE_FORBIDDEN = 1
var/const/LIBRARY_WIRE_POWER = 2
var/const/LIBRARY_WIRE_IDSCAN = 4
var/const/LIBRARY_WIRE_SPARE = 8

/datum/wires/librarycomp
	holder_type = /obj/machinery/librarycomp
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(LIBRARY_WIRE_FORBIDDEN, "Restriction bypass"),
		new /datum/wire_description(LIBRARY_WIRE_POWER, "Power"),
		new /datum/wire_description(LIBRARY_WIRE_IDSCAN, "ID scan"),
		new /datum/wire_description(LIBRARY_WIRE_SPARE, "Spare")
	)

/datum/wires/librarycomp/CanUse(var/mob/living/L)
	var/obj/machinery/librarycomp/C = holder
	if(C.panel_open)
		return 1
	return 0

/datum/wires/librarycomp/get_status(mob/living/user)
	var/obj/machinery/librarycomp/C = holder
	. = ..()
	. += "The restriction light is [C.emagged ? "off" : "on"]."
	. += "The power light is [C.power_cut ? "off" : "on"]."
	. += "The ID scan light is [C.id_scan_cut ? "off" : "on"]."

/datum/wires/librarycomp/UpdateCut(var/index, var/mended)
	var/obj/machinery/librarycomp/C = holder
	switch(index)
		if(LIBRARY_WIRE_FORBIDDEN)
			C.emagged = !mended
		if(LIBRARY_WIRE_POWER)
			C.power_cut = !mended
		if(LIBRARY_WIRE_IDSCAN)
			C.id_scan_cut = !mended
		if(LIBRARY_WIRE_SPARE)
			return

/datum/wires/librarycomp/UpdatePulsed(var/index)
	var/obj/machinery/librarycomp/C = holder
	switch(index)
		if(LIBRARY_WIRE_FORBIDDEN)
			C.emagged = TRUE
		if(LIBRARY_WIRE_POWER)
			return
		if(LIBRARY_WIRE_IDSCAN)
			return
		if(LIBRARY_WIRE_SPARE)
			return
