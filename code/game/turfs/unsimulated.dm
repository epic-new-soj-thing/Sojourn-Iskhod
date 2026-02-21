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
	if(!initial_gas && (oxygen || nitrogen || carbon_dioxide || plasma || hydrogen))
		initial_gas = new/datum/gas_mixture
		initial_gas.adjust_multi(GAS_OXYGEN, oxygen, GAS_NITROGEN, nitrogen, GAS_CO2, carbon_dioxide, GAS_PLASMA, plasma, GAS_HYDROGEN, hydrogen)
		initial_gas.temperature = temperature
		initial_gas.update_values()
