/obj/random/ammo
	name = "random ammunition"
	icon_state = "ammo-green"
	spawn_nothing_percentage = 40

/obj/random/ammo/item_to_spawn()
	return pickweight(list(
				/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 3,
				/obj/item/ammo_magazine/ammobox/shotgun = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/buckshot = 3,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_pellet = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_beanbag = 3,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_slug = 2,
				/obj/item/ammo_casing/shotgun/scrap/prespawned = 2,
				/obj/item/ammo_casing/shotgun/pellet/scrap/prespawned = 3,
				/obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned = 4,
				/obj/item/ammo_magazine/pistol_10mm/old = 2,
				/obj/item/ammo_magazine/ammobox/pistol_10mm = 1,
				/obj/item/ammo_magazine/ammobox/pistol_10mm/lethal = 1,
				/obj/item/ammo_magazine/ammobox/pistol_10mm/rubber = 1,
				/obj/item/ammo_magazine/ammobox/pistol_10mm/scrap = 1,
				/obj/item/ammo_magazine/speed_loader_pistol_10mm/scrap = 2,
				/obj/item/ammo_magazine/ammobox/kurtz_12 = 1,
				/obj/item/ammo_magazine/ammobox/kurtz_12/rubber = 1,
				/obj/item/ammo_magazine/ammobox/kurtz_12/lethal = 1,
				/obj/item/ammo_magazine/ammobox/light_rifle_65 = 1,
				/obj/item/ammo_magazine/ammobox/light_rifle_65_small/rubber = 2,
				/obj/item/ammo_magazine/ammobox/light_rifle_65_small/lethal = 1,
				/obj/item/ammo_magazine/ammobox/light_rifle_65/scrap = 2,
				/obj/item/ammo_magazine/light_rifle_65/scrap = 3,
				/obj/item/ammo_magazine/rifle_762/scrap = 2,
				/obj/item/ammo_magazine/rifle_762_short = 1,
				/obj/item/ammo_magazine/rifle_762_short/lethal = 1,
				/obj/item/ammo_magazine/rifle_762_short/rubber = 2,
				/obj/item/ammo_magazine/ammobox/rifle_762_small/scrap = 2,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small= 1,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small/rubber = 2,
				/obj/item/ammo_magazine/ammobox/pistol_9mm = 2,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/rubber = 2,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/scrap = 2,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/lethal = 1,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/scrap = 2,
				/obj/item/ammo_magazine/smg_9mm = 1,
				/obj/item/ammo_magazine/smg_9mm/rubber = 1,
				/obj/item/ammo_magazine/speed_loader_pistol_9mm/scrap = 5,
				/obj/item/ammo_magazine/pistol_9mm/scrap = 4,
				/obj/item/ammo_magazine/pistol_9mm = 2,
				/obj/item/ammo_magazine/pistol_9mm/rubber = 4,
				/obj/item/ammo_magazine/pistol_9mm/practice = 4,
				/obj/item/ammo_magazine/highcap_pistol_9mm = 2,
				/obj/item/ammo_magazine/highcap_pistol_9mm/rubber = 4,
				/obj/item/ammo_magazine/highcap_pistol_9mm/practice = 1,
				/obj/item/ammo_magazine/speed_loader_pistol_10mm = 2,
				/obj/item/ammo_magazine/kurtz_12 = 1,
				/obj/item/ammo_magazine/kurtz_12/lethal = 1,
				/obj/item/ammo_magazine/kurtz_12/rubber = 2,
				/obj/item/ammo_magazine/speed_loader_kurtz_12 = 1,
				/obj/item/ammo_magazine/speed_loader_kurtz_12/rubber = 2,
				/obj/item/ammo_magazine/speed_loader_kurtz_12/lethal = 1,
				/obj/item/ammo_magazine/speed_loader_pistol_9mm = 3,
				/obj/item/ammo_magazine/speed_loader_pistol_9mm/rubber = 4,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small/scrap = 1,
				/obj/item/ammo_magazine/heavy_rifle_86/scrap = 2))

/obj/random/ammo/low_chance
	name = "low chance random ammunition"
	icon_state = "ammo-green-low"
	spawn_nothing_percentage = 60

/obj/random/ammo_fancy
	name = "random advanced ammunition"
	icon_state = "ammo-blue"
	spawn_nothing_percentage = 60

/obj/random/ammo_fancy/item_to_spawn()
	return pick(/obj/item/ammo_magazine/rifle_762/rubber,
				/obj/item/ammo_magazine/rifle_762,
				/obj/item/ammo_magazine/heavy_rifle_86,
				/obj/item/ammo_magazine/heavy_rifle_86/rubber,
				/obj/item/ammo_magazine/heavy_rifle_86/hv,
				/obj/item/ammo_magazine/heavy_rifle_86/lethal,
				/obj/item/ammo_magazine/rifle_762_short/lethal,
				/obj/item/ammo_magazine/rifle_762_short,
				/obj/item/ammo_magazine/rifle_762_short/rubber,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small/rubber,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small/lethal,
				/obj/item/ammo_magazine/ammobox/light_rifle_65_small/rubber,
				/obj/item/ammo_magazine/ammobox/light_rifle_65_small,
				/obj/item/ammo_magazine/ammobox/light_rifle_65,
				/obj/item/ammo_magazine/ammobox/light_rifle_65/rubber,
				/obj/item/ammo_magazine/pistol_10mm/rubber,
				/obj/item/ammo_magazine/speed_loader_pistol_10mm,
				/obj/item/ammo_magazine/speed_loader_kurtz_12,
				/obj/item/ammo_magazine/speed_loader_kurtz_12/rubber,
				/obj/item/ammo_magazine/kurtz_12,
				/obj/item/ammo_magazine/kurtz_12/lethal,
				/obj/item/ammo_magazine/ammobox/kurtz_12/rubber,
				/obj/item/ammo_magazine/ammobox/kurtz_12/lethal,
				/obj/item/ammo_magazine/ammobox/kurtz_12,
				/obj/item/ammo_magazine/pistol_10mm/rubber,
				/obj/item/ammo_magazine/pistol_10mm,
				/obj/item/cell/medium/high,
				/obj/item/ammo_magazine/m12,
				/obj/item/ammo_magazine/m12/pellet,
				/obj/item/ammo_magazine/m12/beanbag)

/obj/random/ammo_fancy/low_chance
	name = "low chance random random ironhammer ammunition"
	icon_state = "ammo-blue-low"
	spawn_nothing_percentage = 60

/obj/random/ammo/shotgun
	name = "random shotgun ammunition"
	icon_state = "ammo-orange"
	spawn_nothing_percentage = 60

/obj/random/ammo/shotgun/item_to_spawn()
	return pickweight(list(
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_pellet = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_beanbag = 3,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_slug = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 4,
				/obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned = 4,
				/obj/item/ammo_magazine/ammobox/shotgun = 2,
				/obj/item/ammo_casing/shotgun/scrap/prespawned = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/stunshells = 1,
				/obj/item/ammo_magazine/ammobox/shotgun/buckshot = 3,
				/obj/item/ammo_casing/shotgun/pellet/scrap/prespawned = 3,
				/obj/item/ammo_magazine/m12/empty = 0.3))

/obj/random/ammo/shotgun/low_chance
	name = "low chance random shotgun ammunition"
	icon_state = "ammo-orange-low"
	spawn_nothing_percentage = 60

/obj/random/ammo_lowcost
	name = "random low tier ammunition"
	icon_state = "ammo-grey"
	spawn_nothing_percentage = 40

/obj/random/ammo_lowcost/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 2,
				/obj/item/ammo_magazine/ammobox/shotgun = 2,
				/obj/item/ammo_magazine/ammobox/shotgun = 1,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_pellet = 2,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_beanbag = 4,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_slug = 2,
				/obj/item/ammo_casing/shotgun/scrap/prespawned = 2,
				/obj/item/ammo_casing/shotgun/pellet/scrap/prespawned = 3,
				/obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned = 4,
				/obj/item/ammo_magazine/ammobox/pistol_9mm = 1,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/rubber = 6,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/scrap = 6,
				/obj/item/ammo_magazine/highcap_pistol_9mm = 2,
				/obj/item/ammo_magazine/highcap_pistol_9mm/rubber = 4,
				/obj/item/ammo_magazine/highcap_pistol_9mm/practice = 1,
				/obj/item/ammo_magazine/pistol_9mm = 3,
				/obj/item/ammo_magazine/pistol_9mm/rubber = 4,
				/obj/item/ammo_magazine/pistol_9mm/practice = 1,
				/obj/item/ammo_magazine/ammobox/pistol_10mm/scrap = 1,
				/obj/item/cell/medium = 1))

/obj/random/ammo_lowcost/low_chance
	name = "low chance random low tier ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60

//Rubber ammo, used in some spawns
/obj/random/rubber_ammo
	name = "random rubber ammunition"
	icon_state = "ammo-grey"

/obj/random/rubber_ammo/item_to_spawn()
	return pickweight(list(
				/obj/item/ammo_magazine/ammobox/shotgun/beanbags = 3,
				/obj/item/ammo_magazine/ammobox/shotgun/scrap_beanbag = 2,
				/obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned = 4,
				/obj/item/ammo_magazine/ammobox/pistol_10mm/rubber = 3,
				/obj/item/ammo_magazine/ammobox/kurtz_12/rubber = 1,
				/obj/item/ammo_magazine/ammobox/light_rifle_65_small/rubber = 2,
				/obj/item/ammo_magazine/rifle_762_short/rubber = 2,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86_small/rubber = 1,
				/obj/item/ammo_magazine/ammobox/pistol_9mm/rubber = 2,
				/obj/item/ammo_magazine/smg_9mm/rubber = 2,
				/obj/item/ammo_magazine/pistol_9mm/rubber = 6,
				/obj/item/ammo_magazine/highcap_pistol_9mm/rubber = 5,
				/obj/item/ammo_magazine/kurtz_12/rubber = 2,
				/obj/item/ammo_magazine/speed_loader_kurtz_12/rubber = 4,
				/obj/item/ammo_magazine/speed_loader_pistol_9mm/rubber = 7))

/obj/random/rubber_ammo/low_chance
	name = "low chance random special ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60

//Dungeon based random spawners (use these only in dungeons, not maint)
/obj/random/dungeon_ammo
	name = "random special ammunition"
	icon_state = "ammo-grey"

/obj/random/dungeon_ammo/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/c10x24 = 3,
				//obj/item/ammo_magazine/a75 = 3,
				/obj/item/ammo_magazine/heavy_rifle_86_drum = 3,
				/obj/item/ammo_magazine/m12/pellet = 6,
				/obj/item/ammo_magazine/ammobox/rifle_762/lethal = 6,
				/obj/item/ammo_magazine/smg_9mm/lethal = 9,
				/obj/item/ammo_magazine/pistol_9mm/lethal = 9,
				/obj/item/ammo_magazine/kurtz_12/lethal = 3,
				/obj/item/ammo_magazine/ammobox/shotgun/buckshot = 6,
				/obj/item/ammo_magazine/ammobox/heavy_rifle_86/hv = 6,
				/obj/item/ammo_casing/antim/lethal/prespawned = 1,
				/obj/item/ammo_casing/antim/ion/prespawned = 1,
				/obj/item/grenade/frag/white_phosphorous = 1))

/obj/random/dungeon_ammo/low_chance
	name = "low chance random special ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 60

/obj/random/dungeon_ammo/really_low_chance
	name = "really low chance random special ammunition"
	icon_state = "ammo-grey-low"
	spawn_nothing_percentage = 90
