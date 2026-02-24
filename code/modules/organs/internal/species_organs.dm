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
	desc = "A sturdy, multi-chambered heart designed for both land and water. It beats with a steady, rhythmic thrum."
	price_tag = 750
	min_broken_damage = 40
	max_damage = 80

/obj/item/organ/internal/vital/lungs/marqua
	name = "amphibian lungs"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "lungs"
	desc = "Specialized lungs that can filter oxygen from both air and water with high efficiency. They feel moist to the touch."
	price_tag = 700
	organ_efficiency = list(OP_LUNGS = 110)
	min_bruised_damage = 15
	min_broken_damage = 35

/obj/item/organ/internal/liver/marqua
	name = "amphibian liver"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "liver"
	desc = "A large, efficient organ capable of processing a wide variety of biological toxins found in marshy environments."
	price_tag = 600
	organ_efficiency = list(OP_LIVER = 115)

/obj/item/organ/internal/kidney/left/marqua
	name = "left amphibian kidney"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "kidneys"
	desc = "A robust filtration organ designed to handle the variable salinity of aquatic habitats."
	price_tag = 500
	organ_efficiency = list(OP_KIDNEYS = 110)

/obj/item/organ/internal/kidney/right/marqua
	name = "right amphibian kidney"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "kidneys"
	desc = "A robust filtration organ designed to handle the variable salinity of aquatic habitats."
	price_tag = 500
	organ_efficiency = list(OP_KIDNEYS = 110)

/obj/item/organ/internal/stomach/marqua
	name = "amphibian stomach"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "stomach"
	desc = "A flexible digestive sac capable of processing even the most exotic off-colony flora."
	price_tag = 400

/obj/item/organ/internal/vital/brain/marqua
	name = "amphibian brain"
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "brain"
	desc = "A highly developed neural center with complex folds, indicating significant cognitive capacity and memory."
	price_tag = 2000

/obj/item/organ/internal/eyes/marqua
	name = "amphibian eyes"
	desc = "A large black orb, belonging to some sort of giant frog by looks of it. They provide excellent wide-angle vision."
	icon = 'icons/mob/human_races/species/marqua/organs.dmi'
	icon_state = "eyes"
	eyes_color = "#000000"
	cache_key = "marqua_eyes"
	price_tag = 350

// --- OPIFEX (Vox) ---

/obj/item/organ/internal/vital/heart/opifex
	name = "opifex heart"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "vox_heart"
	desc = "A frantically beating pump, built for the high-intensity lifestyle of an Opifex. It seems remarkably resistant to shock."
	price_tag = 600

/obj/item/organ/internal/vital/lungs/opifex
	name = "nitrogen sack"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "vox_lungs"
	desc = "A specialized organ for storing and processing nitrogen. Essential for Vox survival, it is quite fragile outside its host."
	price_tag = 850

/obj/item/organ/internal/kidney/left/opifex
	name = "left filtration bladder"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kidney_left"
	desc = "A secondary waste-processing organ. Simple in structure, but highly effective at filtering scavenged materials."
	price_tag = 450

/obj/item/organ/internal/kidney/right/opifex
	name = "right filtration bladder"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kidney_right"
	desc = "A secondary waste-processing organ. Simple in structure, but highly effective at filtering scavenged materials."
	price_tag = 450

/obj/item/organ/internal/liver/opifex
	name = "waste tract"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "liver"
	desc = "A long, winding organ focused on extracting every possible nutrient from whatever the Opifex manages to find."
	price_tag = 400

/obj/item/organ/internal/stomach/opifex
	name = "gizzard"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "stomach"
	desc = "A tough, muscular organ used to grind down tough scavenged food. It often contains small stones to aid digestion."
	price_tag = 350

/obj/item/organ/internal/vital/brain/opifex
	name = "cortical stack"
	icon = 'icons/obj/organs_bay.dmi'
	icon_state = "cortical-stack"
	desc = "A sophisticated biological/technological hybrid for storing the essence of an Opifex. Extremely valuable to the Shariak."
	price_tag = 3000

/obj/item/organ/internal/eyes/opifex
	name = "vox eyes"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "eyes"
	eyes_color = "#0033cc"
	desc = "Jewel-like blue eyes that provide excellent movement detection even in the darkest voids of space."
	price_tag = 300

// --- CINDARITE (Unathi) ---

/obj/item/organ/internal/vital/heart/cindarite
	name = "reptilian heart"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "heart"
	desc = "A powerful reptilian pump, built for long periods of intense physical exertion. It has thick, muscular walls."
	price_tag = 800
	organ_efficiency = list(OP_HEART = 110)
	min_broken_damage = 50
	max_damage = 100

/obj/item/organ/internal/vital/lungs/cindarite
	name = "reptilian lungs"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "lungs"
	desc = "Large-capacity lungs efficient at oxygenating blood even in thin or dry atmospheres. They expand significantly during heavy breathing."
	price_tag = 750
	organ_efficiency = list(OP_LUNGS = 115)
	min_broken_damage = 45
	max_damage = 90

/obj/item/organ/internal/liver/cindarite
	name = "reptilian liver"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "liver"
	desc = "A specialized liver tuned for the high-protein diet of a predator. It appears remarkably healthy and smooth."
	price_tag = 650
	organ_efficiency = list(OP_LIVER = 110)

/obj/item/organ/internal/kidney/left/cindarite
	name = "left reptilian kidney"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	desc = "A dense set of tightly packed kidneys that work twice as better than a standard kidney.\
	Likely worth more on the black market."
	price_tag = 1000 //The right kidney should be worth as much as the left one.
	organ_efficiency = list(OP_KIDNEYS = 200)
	icon_state = "kidneys"

/obj/item/organ/internal/kidney/right/cindarite
	name = "right reptilian kidney"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	desc = "A dense set of tightly packed kidneys that work twice as better than a standard kidney.\
	Likely worth more on the black market."
	price_tag = 1000 //The right kidney should be worth as much as the left one.
	organ_efficiency = list(OP_KIDNEYS = 200)
	icon_state = "kidneys"

/obj/item/organ/internal/stomach/cindarite
	name = "reptilian stomach"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "stomach"
	desc = "A robust stomach designed for digesting large quantities of raw meat. It has a very acidic interior."
	price_tag = 450

/obj/item/organ/internal/vital/brain/cindarite
	name = "reptilian brain"
	icon = 'icons/mob/human_races/species/cindarite/organs.dmi'
	icon_state = "brain"
	desc = "A complex brain with highly developed sections for instinct and tactical combat logic."
	price_tag = 1800

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
	desc = "A rhythmic vessel for circulating hemolymph throughout a chitinous body. It is simple but reliable."
	price_tag = 500
	min_broken_damage = 40
	max_damage = 80

/obj/item/organ/internal/vital/lungs/chtmant
	parent_type = /obj/item/organ/internal/vital/lungs/plant
	name = "absorption respirator"
	desc = "A series of internal tracheae and sacs that passively absorb oxygen. It lacks any visible muscular movement."
	price_tag = 600
	organ_efficiency = list(OP_LUNGS = 105)

/obj/item/organ/internal/stomach/chtmant
	parent_type = /obj/item/organ/internal/stomach/plant
	name = "digestive sac"
	desc = "An efficient organ for converting organic matter into nutrient-rich pulp. It has multiple internal filters."
	price_tag = 350

/obj/item/organ/internal/liver/chtmant
	parent_type = /obj/item/organ/internal/liver/plant
	name = "primary filters"
	desc = "A collection of specialized glands for detoxifying the hemolymph. They are dark and spongy."
	price_tag = 450
	organ_efficiency = list(OP_LIVER = 105)

/obj/item/organ/internal/kidney/left/chtmant
	parent_type = /obj/item/organ/internal/kidney/left/plant
	name = "left secondary filter"
	desc = "A simple but effective filtration cluster located along the main hemolymph vessel."
	price_tag = 300
	organ_efficiency = list(OP_KIDNEYS = 105)

/obj/item/organ/internal/kidney/right/chtmant
	parent_type = /obj/item/organ/internal/kidney/right/plant
	name = "right secondary filter"
	desc = "A simple but effective filtration cluster located along the main hemolymph vessel."
	price_tag = 300
	organ_efficiency = list(OP_KIDNEYS = 105)

/obj/item/organ/internal/vital/brain/chtmant
	parent_type = /obj/item/organ/internal/vital/brain/plant
	name = "ganglial junction"
	desc = "A decentralized but highly efficient neural hub focused on rapid response and environmental processing."
	price_tag = 1200

/obj/item/organ/internal/eyes/chtmant
	parent_type = /obj/item/organ/internal/eyes/plant
	name = "compound ocelli"
	desc = "A multifaceted optical organ providing nearly 360 degrees of motion sensing. It glimmers with iridescent light."
	price_tag = 400

/obj/item/organ/internal/nerve/chtmant
	name = "cht'mant nerves"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cht_nerves"
	desc = "A complex network of neural filaments designed to relay signals through an exoskeleton. They look like glowing silver threads."
	price_tag = 200
