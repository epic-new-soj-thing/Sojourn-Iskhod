var/global/list/plant_seed_sprites = list()

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	w_class = ITEM_SIZE_SMALL

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	update_seed()
	return ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(plant_controller.seeds) && plant_controller.seeds[seed_type])
		seed = plant_controller.seeds[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	cut_overlays()
	var/is_seeds = ((seed.seed_noun in list("seeds","pits","nodes")) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOR) : "spores"]"
	if(plant_seed_sprites[seed_base_key])
		seed_mask = plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOR)
		plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOR)]"
	if(plant_seed_sprites[seed_overlay_key])
		seed_overlay = plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOR)
		plant_seed_sprites[seed_overlay_key] = seed_overlay

	add_overlay(seed_mask)
	add_overlay(seed_overlay)

	if(is_seeds)
		src.name = "packet of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It has a picture of [seed.display_name] on the front."
	else
		src.name = "sample of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It's labelled as coming from [seed.display_name]."
	if (seed.origin_tech) origin_tech = seed.origin_tech.Copy()

/obj/item/seeds/examine(mob/user)
	..(user)
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/New()
	..()
	seed = plant_controller.create_random_seed()
	seed_type = seed.name
	update_seed()

/obj/item/seeds/chiliseed
	seed_type = "chili"

/obj/item/seeds/plastiseed
	seed_type = "plastic"

/obj/item/seeds/grapeseed
	seed_type = "grapes"

/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"

/obj/item/seeds/peanutseed
	seed_type = "peanut"

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"

/obj/item/seeds/shandseed
	seed_type = "mercy's hand"

/obj/item/seeds/mtearseed
	seed_type = "sun tear"

/obj/item/seeds/brootseed
	seed_type = "blood root"

/obj/item/seeds/berryseed
	seed_type = "berries"

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"

/obj/item/seeds/bananaseed
	seed_type = "banana"

/obj/item/seeds/clownanaseed
	seed_type = "clownana"

/obj/item/seeds/eggplantseed
	seed_type = "eggplant"

/obj/item/seeds/bloodtomatoseed
	seed_type = "bloodtomato"

/obj/item/seeds/tomatoseed
	seed_type = "tomato"

/obj/item/seeds/killertomatoseed
	seed_type = "killertomato"

/obj/item/seeds/bluetomatoseed
	seed_type = "bluetomato"

/obj/item/seeds/bluespacetomatoseed
	seed_type = "bluespacetomato"
	price_tag = 180

/obj/item/seeds/bluespacetomatoseed/New()
	..()
	item_flags |= BLUESPACE

/obj/item/seeds/cornseed
	seed_type = "corn"

/obj/item/seeds/poppyseed
	seed_type = "poppy"

/obj/item/seeds/potatoseed
	seed_type = "potato"

/obj/item/seeds/icepepperseed
	seed_type = "icechili"

/obj/item/seeds/soyaseed
	seed_type = "soybeans"

/obj/item/seeds/wheatseed
	seed_type = "wheat"

/obj/item/seeds/riceseed
	seed_type = "rice"

/obj/item/seeds/carrotseed
	seed_type = "carrot"

/obj/item/seeds/reishimycelium
	seed_type = "reishi"

/obj/item/seeds/amanitamycelium
	seed_type = "amanita"

/obj/item/seeds/angelmycelium
	seed_type = "destroyingangel"

/obj/item/seeds/libertymycelium
	seed_type = "libertycap"

/obj/item/seeds/chantermycelium
	seed_type = "chanterelle"

/obj/item/seeds/towermycelium
	seed_type = "towercap"

/obj/item/seeds/glowshroom
	seed_type = "glowshroom"

/obj/item/seeds/maintshroom
	seed_type = "fungoartiglieria"

/obj/item/seeds/plumpmycelium
	seed_type = "plumphelmet"

/obj/item/seeds/walkingmushroommycelium
	seed_type = "walkingmushroom"

/obj/item/seeds/nettleseed
	seed_type = "nettle"

/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"

/obj/item/seeds/weeds
	seed_type = "weeds"

/obj/item/seeds/harebell
	seed_type = "harebells"

/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"

/obj/item/seeds/brownmold
	seed_type = "mold"

/obj/item/seeds/appleseed
	seed_type = "apple"

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"

/obj/item/seeds/ambrosiavulgarisseed
	seed_type = "ambrosia"

/obj/item/seeds/ambrosiadeusseed
	seed_type = "ambrosiadeus"

/obj/item/seeds/ambrosiarobusto
	seed_type = "ambrosiarobusto"

/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"

/obj/item/seeds/limeseed
	seed_type = "lime"

/obj/item/seeds/lemonseed
	seed_type = "lemon"

/obj/item/seeds/orangeseed
	seed_type = "orange"

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"

/obj/item/seeds/grassseed
	seed_type = "grass"

/obj/item/seeds/cocoapodseed
	seed_type = "cocoa"

/obj/item/seeds/cherryseed
	seed_type = "cherry"

/obj/item/seeds/kudzuseed
	seed_type = "kudzu"

/obj/item/seeds/jurlmah
	seed_type = "jurlmah"

/obj/item/seeds/amauri
	seed_type = "amauri"

/obj/item/seeds/gelthi
	seed_type = "gelthi"

/obj/item/seeds/vale
	seed_type = "vale bush"

/obj/item/seeds/surik
	seed_type = "surik"

/obj/item/seeds/telriis
	seed_type = "telriis"

/obj/item/seeds/thaadra
	seed_type = "thaadra"

/obj/item/seeds/blueberryseed
	seed_type = "blueberries"

/obj/item/seeds/strawberryseed
	seed_type = "strawberries"

/obj/item/seeds/pineappleseed
	seed_type = "pineapple"

/obj/item/seeds/cinnamonseed
	seed_type = "cinnamon"

/obj/item/seeds/mintseed
	seed_type = "mint"

/obj/item/seeds/spacealocasiaseed
	seed_type = "space alocasia"

/obj/item/seeds/moontearseed
	seed_type = "moon tear"

/obj/item/seeds/curtainweedseed
	seed_type = "curtain weed"

//Renaming seed packets
/obj/item/seeds/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen))
		var/new_name = input(user, "What would you like to label the seed packet?", "Tape labeling") as null|text
		if(isnull(new_name)) return
		new_name = sanitizeSafe(new_name)
		if(new_name)
			SetName("[initial(name)] - '[new_name]'")
			to_chat(user, SPAN_NOTICE("You label the seed packet '[new_name]'."))
		else
			SetName("[initial(name)]")
			to_chat(user, SPAN_NOTICE("You wipe off the label."))
		return

	..()
