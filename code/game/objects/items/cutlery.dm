// Cutlery and tableware (from Baystation12-style service/cuisine)
// Used by the service/cuisine lathe for kitchen and bar.

/obj/item/cutlery
	icon = 'icons/obj/kitchen.dmi'
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	attack_verb = list("poked", "tapped")
	flags = NOBLUDGEON

/obj/item/cutlery/fork
	name = "fork"
	desc = "A simple metal fork for eating."
	icon_state = "fork"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/cutlery/spoon
	name = "spoon"
	desc = "A simple metal spoon for eating."
	icon_state = "spoon"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/cutlery/dinnerknife
	name = "dinner knife"
	desc = "A simple table knife for cutting food. Not very sharp."
	icon_state = "knife"
	matter = list(MATERIAL_STEEL = 1)
