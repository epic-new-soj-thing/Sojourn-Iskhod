/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	icon_state = "cabinet"
	icon_lock = "cabinet"


/obj/structure/closet/secure_closet/bar/populate_contents()
	if(populated_contents)
		return
	populated_contents = TRUE
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/drinks/bottle/small/beer(src)

/obj/structure/closet/secure_closet/hospitality
	name = "hospitality manager's locker"
	req_access = list(access_hosp)
	icon_state = "reinforced"
	icon_lock = "reinforced"


/obj/structure/closet/secure_closet/hospitality/populate_contents()
	if(populated_contents)
		return
	populated_contents = TRUE
	new /obj/item/clothing/suit/hooded/wintercoat(src)
	new /obj/item/clothing/shoes/jackboots(src)
