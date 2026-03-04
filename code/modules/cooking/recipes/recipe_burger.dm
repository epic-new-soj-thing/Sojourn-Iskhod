
/datum/cooking/recipe/burger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/monkeyburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty)
	)

//Apparently this is a burger
/datum/cooking/recipe/muffinegg
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/snacks/muffinegg
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/friedegg, qmod=0.5),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.5)
	)

/datum/cooking/recipe/slime
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/jellyburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT, "honey", 5),
		list(COOKING_ADD_REAGENT, "vodka", 5),
		list(COOKING_ADD_REAGENT, "sugar", 5),
	)

/datum/cooking/recipe/slimejelly
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/jellyburger/slime

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT, "slimejelly", 5),
	)

/datum/cooking/recipe/jellyburger_cherry
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/jellyburger/cherry

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT, "cherryjelly", 5),
	)

/datum/cooking/recipe/bigbiteburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/bigbiteburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty)
	)

/datum/cooking/recipe/superbiteburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/superbiteburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 3, add_price = 9),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 3, add_price = 12),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 3, add_price = 6),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/meatsteak),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/porkchops),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty)
	)

/datum/cooking/recipe/cheeseburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/cheeseburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cheesewedge, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty)
	)

/datum/cooking/recipe/fishburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/fishburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/fishfingers)
	)

/datum/cooking/recipe/baconburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/baconburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bacon, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/patty)
	)

/datum/cooking/recipe/chickenburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/chickenburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/chickensteak)
	)

/datum/cooking/recipe/tofuburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/tofuburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/tofu)
	)

/datum/cooking/recipe/clownburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/clownburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/clothing/mask/costume/job/clown)
	)

/datum/cooking/recipe/mimeburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/mimeburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/clothing/head/beret)
	)

/datum/cooking/recipe/roburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/roburger
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_REAGENT_OPTIONAL, "silicon", 1),
		list(COOKING_ADD_ITEM, /obj/item/robot_parts/head)
	)

/datum/cooking/recipe/xenoburger
	cooking_container = CUTTING_BOARD

	replace_reagents = TRUE

	product_type = /obj/item/reagent_containers/snacks/xenoburger
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/meat/xenomeat)
	)

/datum/cooking/recipe/brainburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/brainburger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/organ/internal/vital/brain)
	)

/datum/cooking/recipe/humanburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/human/burger

	replace_reagents = TRUE

	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/bun, qmod=0.5),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "cabbage", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		list(COOKING_ADD_PRODUCE_OPTIONAL, "tomato", reagent_skip=TRUE, qmod=0.2, add_price = 2),
		COOKING_BEGIN_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_REAGENT_OPTIONAL, "ketchup", 1, add_price = 4),
		list(COOKING_ADD_REAGENT_OPTIONAL, "bbqsauce", 1, add_price = 5),
		list(COOKING_ADD_REAGENT_OPTIONAL, "honey", 1, add_price = 2),
		COOKING_END_EXCLUSIVE_OPTIONS,
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/meat/human)
	)

/datum/cooking/recipe/sandwich_deepfried
	cooking_container = DF_BASKET
	product_type = /obj/item/reagent_containers/snacks/sandwich
	replace_reagents = TRUE
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/breadslice, qmod=0.5),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cutlet, qmod=0.5, desc="Add any kind of cutlet.", prod_desc="There is meat between the bread."),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/breadslice, qmod=0.5),
		list(COOKING_USE_DEEPFRIER, J_MED, 30 SECONDS, prod_desc="It has been deep fried.")
	)

/datum/cooking/recipe/sandwich_airfried
	cooking_container = AF_BASKET
	product_type = /obj/item/reagent_containers/snacks/sandwich
	replace_reagents = TRUE
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/breadslice, qmod=0.5),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/cutlet, qmod=0.5, desc="Add any kind of cutlet.", prod_desc="There is meat between the bread."),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/breadslice, qmod=0.5),
		list(COOKING_USE_DEEPFRIER, J_MED, 30 SECONDS, prod_desc="It has been air fried.")
	)
