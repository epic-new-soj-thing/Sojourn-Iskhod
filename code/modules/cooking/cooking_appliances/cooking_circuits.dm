/obj/item/circuitboard/cooking/stove
	build_name = "Industrial Stovetop"
	build_path = /obj/machinery/cooking/stove
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2,
	)

/obj/item/circuitboard/cooking/oven
	build_name = "Industrial Convection Oven"
	build_path = /obj/machinery/cooking/oven
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2,
	)

/obj/item/circuitboard/cooking/grill
	build_name = "Industrial Charcoal Grill"
	build_path = /obj/machinery/cooking/grill
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2, //Affects wood hopper size
	)

/obj/item/circuitboard/cooking/deepfrier
	build_name = "Industrial Deep Fryer"
	build_path = /obj/machinery/cooking/deepfrier
	board_type = "machine"
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/stock_parts/micro_laser = 2, //Affects the food quality
		/obj/item/stock_parts/matter_bin = 2,
	)
