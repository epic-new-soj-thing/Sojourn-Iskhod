// Normal crayons — base type, color subtypes, and drawing/eating logic.
// Blood-magic runes are in code/modules/blood_magic (decals, not items).

/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEM_SIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000"
	var/shade_color = "#220000"
	var/uses = 30
	var/instant = 0
	var/color_name = "red"
	var/grindable = TRUE

/obj/item/pen/crayon/New()
	name = "[color_name] crayon"
	if(grindable)
		create_reagents(20)
		reagents.add_reagent("crayon_dust_[color_name]", 20)
	..()

// Crayon Colors
/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = COLOR_CRAYON_RED
	shade_color = COLOR_CRAYON_SHADE_RED
	color_name = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = COLOR_CRAYON_ORANGE
	shade_color = COLOR_CRAYON_SHADE_ORANGE
	color_name = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = COLOR_CRAYON_YELLOW
	shade_color = COLOR_CRAYON_SHADE_YELLOW
	color_name = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = COLOR_CRAYON_GREEN
	shade_color = COLOR_CRAYON_SHADE_GREEN
	color_name = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = COLOR_CRAYON_BLUE
	shade_color = COLOR_CRAYON_SHADE_BLUE
	color_name = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = COLOR_CRAYON_PURPLE
	shade_color = COLOR_CRAYON_SHADE_PURPLE
	color_name = "purple"

/obj/item/pen/crayon/black
	icon_state = "crayonblack"
	colour = COLOR_CRAYON_BLACK
	shade_color = COLOR_CRAYON_SHADE_BLACK
	color_name = "black"

/obj/item/pen/crayon/white
	icon_state = "crayonwhite"
	colour = COLOR_CRAYON_WHITE
	shade_color = COLOR_CRAYON_SHADE_WHITE
	color_name = "white"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = COLOR_CRAYON_WHITE
	shade_color = COLOR_CRAYON_BLACK
	color_name = "mime"
	uses = 0
	grindable = FALSE

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shade_color = "#000FFF"
	color_name = "rainbow"
	uses = 0
	grindable = FALSE

// Graffiti decal (crayon drawings only; blood runes are /obj/effect/decal/cleanable/blood_rune in blood_magic).
// Crayon runes and drawings never deal sanity loss.
/obj/effect/decal/cleanable/crayon
	name = "graffiti"
	desc = "A drawing in wax."
	icon = 'icons/obj/rune.dmi'
	layer = TURF_DECAL_LAYER
	anchored = TRUE
	random_rotation = 0
	sanity_damage = 0

/obj/effect/decal/cleanable/crayon/New(location, main = "#FFFFFF", shade = "#000000", type = "graffiti")
	..()
	loc = location
	var/is_fake_rune = (type == "rune")
	var/main_state
	var/shade_state
	switch(type)
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")
			main_state = type
			shade_state = "[type]s"
		if("rune")
			var/rune_n = rand(1, 6)
			main_state = "main[rune_n]"
			shade_state = "shade[rune_n]"
	if(is_fake_rune)
		name = "rune"
		desc = "A rune drawn in wax. It cannot channel blood magic."
	else
		name = type
	var/icon/mainOverlay = new/icon('icons/effects/crayondecal.dmi', main_state || "[type]", 2.1)
	var/icon/shadeOverlay = new/icon('icons/effects/crayondecal.dmi', shade_state || "[type]s", 2.1)
	mainOverlay.Blend(main,ICON_ADD)
	shadeOverlay.Blend(shade,ICON_ADD)
	add_overlay(mainOverlay)
	add_overlay(shadeOverlay)
	add_hiddenprint(usr)

// Crayon Logic
/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","letter","arrow","rune")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a fake rune on the [target.name].")
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shade_color,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, SPAN_WARNING("You used up your crayon!"))
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(istype(M) && M == user)
		to_chat(M, "You take a bite of the crayon and swallow it.")
		M.nutrition += 1
		M.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(M, SPAN_WARNING("You ate your crayon!"))
				qdel(src)
	else
		..()

// Mime Crayon Logic
/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob)
	if(colour != COLOR_CRAYON_WHITE && shade_color != COLOR_CRAYON_BLACK)
		colour = COLOR_CRAYON_WHITE
		shade_color = COLOR_CRAYON_BLACK
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = COLOR_CRAYON_BLACK
		shade_color = COLOR_CRAYON_WHITE
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

// Rainbow Crayon Logic
/obj/item/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main color.", "Crayon color") as color
	shade_color = input(user, "Please select the shade color.", "Crayon color") as color
	return
