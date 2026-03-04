/**
 * # Browser window autoclose subsystem
 *
 * Periodically checks each client's machine. If the machine is an obj with
 * browser_window_id set (e.g. surgery console, cloning) and the user can no
 * longer use it (out of range, machine broken, etc.), the browser window
 * is closed and the user's machine is unset. This prevents windows from
 * staying open when inactive or inaccessible.
 */
SUBSYSTEM_DEF(browser_autoclose)
	name = "Browser Autoclose"
	wait = 20
	flags = SS_NO_INIT
	var/list/current_run = list()

/datum/controller/subsystem/browser_autoclose/fire(resumed = FALSE)
	if(!resumed)
		current_run = clients.Copy()

	while(current_run.len)
		var/client/C = current_run[current_run.len]
		current_run.len--

		var/mob/M = C.mob
		if(!M || !M.machine)
			if(MC_TICK_CHECK)
				return
			continue

		var/obj/O = M.machine
		if(!istype(O) || !O.browser_window_id)
			if(MC_TICK_CHECK)
				return
			continue

		if(O.can_use_browser_ui(M))
			if(MC_TICK_CHECK)
				return
			continue

		// User can no longer use this machine's browser UI - close the window
		M << browse(null, "window=[O.browser_window_id]")
		M.unset_machine()

		if(MC_TICK_CHECK)
			return
