/datum/design/organ
	category = "Standard"
	build_type = ORGAN_GROWER
	starts_unlocked = TRUE

	required_printer_code = TRUE
	code_dex = "ORGAN_GROWER"

/datum/design/organ/heart
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/vital/heart

/datum/design/organ/lungs
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/vital/lungs

/datum/design/organ/kidney_left
	materials = list()
	build_path = /obj/item/organ/internal/kidney/left

/datum/design/organ/kidney_right
	materials = list()
	build_path = /obj/item/organ/internal/kidney/right

/datum/design/organ/liver
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/liver

/datum/design/organ/stomach
	materials = list(MATERIAL_BIOMATTER = 10)
	build_path = /obj/item/organ/internal/stomach

/datum/design/organ/eyes
	materials = list(MATERIAL_BIOMATTER = 10)
	build_path = /obj/item/organ/internal/eyes

/datum/design/organ/nerves
	materials = list(MATERIAL_BIOMATTER = -10)
	build_path = /obj/item/organ/internal/nerve

/datum/design/organ/muscle
	build_path = /obj/item/organ/internal/muscle

/datum/design/organ/blood_vessel
	materials = list(MATERIAL_BIOMATTER = -10)
	build_path = /obj/item/organ/internal/blood_vessel

/datum/design/organ/back_alley
	category = "Back Alley"
	starts_unlocked = FALSE

/datum/design/organ/back_alley/ex_lungs
	name = "Extended Lungs"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/vital/lungs/long

/datum/design/organ/back_alley/huge_heart
	name = "Huge Heart"
	materials = list(MATERIAL_BIOMATTER = 45)
	build_path = /obj/item/organ/internal/vital/heart/huge

/datum/design/organ/back_alley/big_liver
	name = "Big Liver"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/liver/big

/datum/design/organ/back_alley/hyper_nerves
	name = "Hypersensitive Nerves"
	materials = list(MATERIAL_BIOMATTER = 15, MATERIAL_GOLD = 1)
	build_path = /obj/item/organ/internal/nerve/sensitive_nerve

/datum/design/organ/back_alley/super_muscle
	name = "Super Muscle"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/muscle/super_muscle

/datum/design/organ/back_alley/ex_blood_vessel
	name = "Extensive Blood Vessels"
	materials = list(MATERIAL_BIOMATTER = 30, MATERIAL_PLASTIC = 2)
	build_path = /obj/item/organ/internal/blood_vessel/extensive

// --- SPECIES ORGANS ---

/datum/design/organ/marqua
	category = "Mar'Qua"
	starts_unlocked = TRUE


/datum/design/organ/marqua/heart
	name = "Amphibian Heart"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/vital/heart/marqua

/datum/design/organ/marqua/lungs
	name = "Amphibian Lungs"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/vital/lungs/marqua

/datum/design/organ/marqua/liver
	name = "Amphibian Liver"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/liver/marqua

/datum/design/organ/marqua/kidney_left
	name = "Left Amphibian Kidney"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/left/marqua

/datum/design/organ/marqua/kidney_right
	name = "Right Amphibian Kidney"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/right/marqua

/datum/design/organ/marqua/stomach
	name = "Amphibian Stomach"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/stomach/marqua

/datum/design/organ/marqua/eyes
	name = "Amphibian Eyes"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/eyes/marqua

/datum/design/organ/opifex
	category = "Opifex"
	starts_unlocked = TRUE

/datum/design/organ/opifex/heart
	name = "Opifex Heart "
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/vital/heart/opifex

/datum/design/organ/opifex/lungs
	name = "Nitrogen Sack (Lungs)"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/vital/lungs/opifex

/datum/design/organ/opifex/liver
	name = "Waste Tract (Liver)"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/liver/opifex

/datum/design/organ/opifex/kidney_left
	name = "Left Filtration Bladder (Kidney)"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/left/opifex

/datum/design/organ/opifex/kidney_right
	name = "Right Filtration Bladder (Kidney)"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/right/opifex

/datum/design/organ/opifex/stomach
	name = "Gizzard (Stomach)"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/stomach/opifex

/datum/design/organ/opifex/eyes
	name = "Opifex Eyes"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/eyes/opifex

/datum/design/organ/cindarite
	category = "Cindarite"
	build_type = ORGAN_GROWER
	starts_unlocked = TRUE

/datum/design/organ/cindarite/heart
	name = "Reptilian Heart"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/vital/heart/cindarite

/datum/design/organ/cindarite/lungs
	name = "Reptilian Lungs"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/vital/lungs/cindarite

/datum/design/organ/cindarite/liver
	name = "Reptilian Liver"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/liver/cindarite

/datum/design/organ/cindarite/kidney_left
	name = "Left Reptilian Kidney"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/left/cindarite

/datum/design/organ/cindarite/kidney_right
	name = "Right Reptilian Kidney"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/right/cindarite

/datum/design/organ/cindarite/stomach
	name = "Reptilian Stomach"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/stomach/cindarite

/datum/design/organ/cindarite/eyes
	name = "Reptilian Eyes"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/eyes/cindarite

/datum/design/organ/chtmant
	category = "Cht'mant"
	build_type = ORGAN_GROWER

/datum/design/organ/chtmant/heart
	name = "Hemolymph Pump (Heart)"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/vital/heart/chtmant

/datum/design/organ/chtmant/lungs
	name = "Absorption Respirator (Lungs)"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/vital/lungs/chtmant

/datum/design/organ/chtmant/liver
	name = "Primary Filters (Liver)"
	materials = list(MATERIAL_BIOMATTER = 40)
	build_path = /obj/item/organ/internal/liver/chtmant

/datum/design/organ/chtmant/kidney_left
	name = "Left Secondary Filter (Kidney)"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/left/chtmant

/datum/design/organ/chtmant/kidney_right
	name = "Right Secondary Filter (Kidney)"
	materials = list(MATERIAL_BIOMATTER = 30)
	build_path = /obj/item/organ/internal/kidney/right/chtmant

/datum/design/organ/chtmant/stomach
	name = "Digestive Sac (Stomach)"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/stomach/chtmant

/datum/design/organ/chtmant/eyes
	name = "Compound Ocelli (Eyes)"
	materials = list(MATERIAL_BIOMATTER = 20)
	build_path = /obj/item/organ/internal/eyes/chtmant

