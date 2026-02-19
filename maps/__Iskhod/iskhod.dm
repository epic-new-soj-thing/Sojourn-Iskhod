#include "area/_Iskhod_areas.dm"
#include "data/_Iskhod_factions.dm"
#include "data/_Iskhod_Turbolifts.dm"
#include "data/shuttles-iskhod.dm"
#include "data/overmap-eris.dm"
#include "data/shuttles-eris.dm"
#include "data/reports.dm"

#include "map/_Iskhod_Colony.dmm"

/obj/map_data/eris
	name = "Eris"
	is_sealed = TRUE
	height = 1

/obj/map_data/iskhod //Omnie level has all three surface underground and stairs
	name = "Iskhod Map"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = FALSE
	is_sealed = TRUE
	height = 4
	digsites = "HOUSE"

/obj/map_data/iskhod/Initialize()
	. = ..()
	// Initialize all non-airless floors on the station with standard atmosphere
	for(var/z_level in GLOB.maps_data.station_levels)
		for(var/turf/simulated/floor/T in block(locate(1, 1, z_level), locate(world.maxx, world.maxy, z_level)))
			if(!T.oxygen && !T.nitrogen && !findtext("[T.type]", "airless"))
				T.oxygen = MOLES_O2STANDARD
				T.nitrogen = MOLES_N2STANDARD
				T.temperature = T20C

/obj/map_data/admin
	name = "Admin Level"
	is_admin_level = TRUE
	is_accessable_level = FALSE
	height = 1

/obj/map_data/hunting_lodge
	name = "Hunting Lodge"
	is_station_level = FALSE
	is_player_level = TRUE
	is_contact_level = FALSE
	is_accessable_level = FALSE
	is_sealed = TRUE
	height = 2
