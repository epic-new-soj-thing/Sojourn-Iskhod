//	Observer Pattern Implementation: Supermatter status changed
//		Registration type: /datum/supermatter (register for the global event only)
//
//		Raised when: After a supermatter shard changes status
//
//		Arguments that the called proc should expect:
//			/obj/machinery/power/supermatter: the shard
//          status : The status level of the supermatter (SUPERMATTER_* define)

GLOBAL_DATUM_INIT(supermatter_status, /decl/observ/supermatter_status, new)

/decl/observ/supermatter_status
	name = "Supermatter status changed"
	expected_type = /obj/machinery/power/supermatter
