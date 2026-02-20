/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/Initialize()
	. = ..()
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	// keep an initial gas mixture around so return_air() can copy it directly
	// unsimulated airless tiles should not populate this
	if(!initial_gas && !istype(src, /turf/simulated/floor/airless))
		initial_gas = new/datum/gas_mixture
		initial_gas.adjust_multi(GAS_OXYGEN, oxygen,
			GAS_NITROGEN, nitrogen)
		initial_gas.temperature = temperature
		initial_gas.update_values()
