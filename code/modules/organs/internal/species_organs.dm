/*
    Species-specific internal organs ported from baystation12
    Mappings:
    Mar'Qua = Skrell
    Opifex = Vox
    Cindarite = Unathi
    Chtmant = Insectoid
*/

// --- MAR'QUA (Skrell) ---

/obj/item/organ/internal/vital/heart/marqua
	name = "amphibian heart"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "heart"

/obj/item/organ/internal/vital/lungs/marqua
	name = "amphibian lungs"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "lungs"

/obj/item/organ/internal/liver/marqua
	name = "amphibian liver"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "liver"

/obj/item/organ/internal/kidney/left/marqua
	name = "left amphibian kidney"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/kidney/right/marqua
	name = "right amphibian kidney"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/stomach/marqua
	name = "amphibian stomach"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "stomach"

/obj/item/organ/internal/vital/brain/marqua
	name = "amphibian brain"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "brain"

/obj/item/organ/internal/eyes/marqua
	name = "amphibian eyes"
	desc = "Large black orbs, belonging to some sort of giant frog by looks of it."
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "eyes"
	eyes_color = "#000000"
	cache_key = "marqua_eyes"

// --- OPIFEX (Vox) ---

/obj/item/organ/internal/vital/heart/opifex
	name = "opifex heart"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "vox_heart"

/obj/item/organ/internal/vital/lungs/opifex
	name = "nitrogen sack"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "vox_lungs"

/obj/item/organ/internal/kidney/left/opifex
	name = "left filtration bladder"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/kidney/right/opifex
	name = "right filtration bladder"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/liver/opifex
	name = "waste tract"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "liver"

/obj/item/organ/internal/stomach/opifex
	name = "gizzard"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "stomach"

/obj/item/organ/internal/vital/brain/opifex
	name = "cortical stack"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "cortical-stack"

/obj/item/organ/internal/eyes/opifex
	name = "vox eyes"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "eyes"
	eyes_color = "#0033cc"

// --- CINDARITE (Unathi) ---

/obj/item/organ/internal/vital/heart/cindarite
	name = "reptilian heart"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "heart"

/obj/item/organ/internal/vital/lungs/cindarite
	name = "reptilian lungs"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "lungs"

/obj/item/organ/internal/liver/cindarite
	name = "reptilian liver"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "liver"

/obj/item/organ/internal/kidney/left/cindarite
	name = "left reptilian kidney"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/kidney/right/cindarite
	name = "right reptilian kidney"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "kidneys"

/obj/item/organ/internal/stomach/cindarite
	name = "reptilian stomach"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "stomach"

/obj/item/organ/internal/vital/brain/cindarite
	name = "reptilian brain"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "brain"

/obj/item/organ/internal/eyes/cindarite
	name = "reptilian eyes"
	desc = "Eyes belonging to a big lizard. They seem to be staring right at you no matter where you look from."
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "eyes"
	cache_key = "cindarite_eyes"

// --- CHTMANT (Insectoid) ---

/obj/item/organ/internal/vital/heart/chtmant
	parent_type = /obj/item/organ/internal/vital/heart/plant
	name = "hemolymph pump"

/obj/item/organ/internal/vital/lungs/chtmant
	parent_type = /obj/item/organ/internal/vital/lungs/plant
	name = "absorption respirator"

/obj/item/organ/internal/stomach/chtmant
	parent_type = /obj/item/organ/internal/stomach/plant
	name = "digestive sac"

/obj/item/organ/internal/liver/chtmant
	parent_type = /obj/item/organ/internal/liver/plant
	name = "primary filters"

/obj/item/organ/internal/kidney/left/chtmant
	parent_type = /obj/item/organ/internal/kidney/left/plant
	name = "left secondary filter"

/obj/item/organ/internal/kidney/right/chtmant
	parent_type = /obj/item/organ/internal/kidney/right/plant
	name = "right secondary filter"

/obj/item/organ/internal/vital/brain/chtmant
	parent_type = /obj/item/organ/internal/vital/brain/plant
	name = "ganglial junction"

/obj/item/organ/internal/eyes/chtmant
	parent_type = /obj/item/organ/internal/eyes/plant
	name = "compound ocelli"

/obj/item/organ/internal/nerve/chtmant
	name = "cht'mant nerves"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cht_nerves"
