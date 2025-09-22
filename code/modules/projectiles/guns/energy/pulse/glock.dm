/obj/item/gun/energy/glock
	name = "SI-NM \"Galaxy\" Advanced Energy Gun"
	desc = "The \"Galaxy\" plasma pistol is an odd sight, to say the least.. \
	Its externals appear to be based into a modified \"Sky\" pistol frame with elements from the various Soteria energy weapons being crammed into its exterior. \
	A collaboration between Marshals and Soteria, it appears to be a well made firearm; sporting an improved grip compared to the pistol it was based off \
	and flexibility in firemodes; sporting laser and plasma settings, as well as a less-than-lethal stun bolt setting!\
	This one seems to be more powerful than the CRO-issue \"Starburst\" model, but uses more energy in the process of firing."
	icon = 'icons/obj/guns/energy/galaxy.dmi'
	icon_state = "galaxy"
	item_state = "galaxy"
	item_charge_meter = TRUE
	fire_sound = 'sound/weapons/energy/laser_pistol.ogg'
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 6)
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	projectile_type = /obj/item/projectile/beam/midlaser
	suitable_cell = /obj/item/cell/medium
	charge_cost = 80
	fire_delay = 10
	zoom_factors = list(0.4)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_STEEL = 10, MATERIAL_SILVER = 4, MATERIAL_PLASMA = 8)
	price_tag = 8000
	damage_multiplier = 1
	penetration_multiplier = 1
	init_recoil = CARBINE_RECOIL(0.5)
	gun_tags = list(GUN_LASER, GUN_ENERGY, GUN_SIGHT)
	init_firemodes = list(
		list(mode_name="kill shot", mode_desc="A small laser beam capable of personal defense and shooting through windows and grilles.", projectile_type=/obj/item/projectile/beam/midlaser, fire_sound='sound/weapons/energy/laser_pistol.ogg', charge_cost=80, fire_delay=10, icon="kill", projectile_color = "#e4562b"),
		list(mode_name="stun shot", mode_desc="A strong bolt of electricty, capable of taking down targets with only minor long-lasting damage.", projectile_type=/obj/item/projectile/energy/electrode/stunshot, fire_sound='sound/weapons/energy/Taser.ogg', charge_cost=100, fire_delay=20, icon="stun", projectile_color = "#dfdc39"),
		list(mode_name="plasma bolt", mode_desc="Hard hitting plasma bolts to reduce armor.", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/energy/pulse.ogg', charge_cost=120, fire_delay=25, icon="vaporize", projectile_color = "#00AAFF"),
	)
	serial_type = "SI-NM"

	wield_delay = 0.3 SECOND
	wield_delay_factor = 0.2 // 20 vig

/obj/item/gun/energy/glock/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = min(max(round(ratio, 0.25) * 100, 25), 100)

		if(modifystate)
			iconstring = "[modifystate][ratio]"
		else
			iconstring = "[initial(icon_state)][ratio]"

		if(item_charge_meter)
			itemstring += "-[item_modifystate][ratio]"

	if (!cell)
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/gun/energy/glock/sci
	name = "SI-NM \"Starburst\" Advanced Energy Gun"
	desc = "The \"Starburst\" advanced energy gun pistol is an odd sight, to say the least.. \
	Its externals appear to be based into a modified \"Sky\" pistol frame with elements from the various Soteria energy weapons being crammed into its exterior. \
	A collaboration between Marshals and Soteria, it appears to be a well made firearm; sporting an improved grip compared to the pistol it was based off \
	and flexibility in firemodes; sporting laser and plasma settings, as well as an ion shot setting! \
	This one seems to be less powerful than the WO-issue \"Galaxy\" model, but still manages to pack a punch with its improved efficiency."
	icon = 'icons/obj/guns/energy/starburst.dmi'
	icon_state = "starburst"
	item_state = "starburst"
	item_charge_meter = TRUE
	fire_sound = 'sound/weapons/energy/laser_pistol.ogg'
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 6)
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	projectile_type = /obj/item/projectile/beam/midlaser
	suitable_cell = /obj/item/cell/medium
	charge_cost = 80
	fire_delay = 10
	zoom_factors = list(0.4)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_STEEL = 10, MATERIAL_SILVER = 4, MATERIAL_PLASMA = 8)
	price_tag = 8000
	damage_multiplier = 0.8
	penetration_multiplier = 0.8
	init_recoil = CARBINE_RECOIL(0.5)
	gun_tags = list(GUN_LASER, GUN_ENERGY, GUN_SIGHT)
	init_firemodes = list(
		list(mode_name="kill shot", mode_desc="A small laser beam capable of personal defense and shooting through windows and grilles.", projectile_type=/obj/item/projectile/beam/midlaser, fire_sound='sound/weapons/energy/laser_pistol.ogg', charge_cost=50, fire_delay=10, icon="kill", projectile_color = "#e4562b"),
		list(mode_name="plasma bolt", mode_desc="Hard hitting heavy plasma bolts built to reduce the armour of a target.", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/energy/pulse.ogg', charge_cost=100, fire_delay=25, icon="vaporize", projectile_color = "#00AAFF"),
		list(mode_name="ion shot", mode_desc="An iodizing shot to disable cells, electronics and cybernetics. Works on mechs and synthtic life.",projectile_type=/obj/item/projectile/ion, fire_sound='sound/effects/supermatter.ogg', charge_cost=150, fire_delay=25, icon="stun", projectile_color = "#dfdc39"),
	)
	serial_type = "SI-NM"

	wield_delay = 0.3 SECOND
	wield_delay_factor = 0.2 // 20 vig

/obj/item/gun/energy/glock/sci/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = min(max(round(ratio, 0.25) * 100, 25), 100)

		if(modifystate)
			iconstring = "[modifystate][ratio]"
		else
			iconstring = "[initial(icon_state)][ratio]"

		if(item_charge_meter)
			itemstring += "-[item_modifystate][ratio]"

	if (!cell)
		iconstring += "_slide"

	icon_state = iconstring
