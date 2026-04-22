
/datum/cooking/recipe/dough
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/snacks/dough
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=1),
		list(COOKING_ADD_REAGENT, "flour", 10, remain_percent=0),
		list(COOKING_ADD_REAGENT, "water", 2, remain_percent=0)
	)

/datum/cooking/recipe/dough_batch
	name="batch of dough"
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/snacks/dough
	product_count = 5
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=0.2),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/egg, qmod=0.2),
		list(COOKING_ADD_REAGENT, "flour", 50, remain_percent=0),
		list(COOKING_ADD_REAGENT, "water", 10, remain_percent=0)
	)

/datum/cooking/recipe/kneaded_dough
	name="kneaded dough"
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/dough
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=1, max=70),
		list(COOKING_ADD_REAGENT, "flour", 1, remain_percent=0),
		list(COOKING_ADD_REAGENT, "enzyme", 1, remain_percent=0),
		list(COOKING_USE_TOOL, QUALITY_HAMMERING, 1, max=10, qmod=0.3)
	)

/datum/cooking/recipe/kneaded_dough_batch
	name="batch of kneaded dough"
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/snacks/dough
	product_count = 5
	step_builder = list(
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=0.2, max=70),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=0.2, max=70),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=0.2, max=70),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=0.2, max=70),
		list(COOKING_ADD_ITEM, /obj/item/reagent_containers/snacks/dough, qmod=0.2, max=70),
		list(COOKING_ADD_REAGENT, "flour", 5, remain_percent=0),
		list(COOKING_ADD_REAGENT, "enzyme", 5, remain_percent=0),
		list(COOKING_USE_TOOL, QUALITY_HAMMERING, 1, max=10, qmod=0.3)
	)

