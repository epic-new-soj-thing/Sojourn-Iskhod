/*
 * Admin verbs to schedule server updates (main/testmerge/sync) via the Python byond_update script.
 * Updates are applied only on next restart: before shutdown we run the script, then reboot.
 * At end of round we check GitHub and pull; everyone is notified that updates will apply on next restart.
 *
 * Requires: tools/byond_update.py, Linux server, byond-update binary at /home/server/bin/byond-update.
 */

#define BYOND_UPDATE_SCRIPT "tools/byond_update.py"
#define BYOND_UPDATE_PATH "/home/server/bin/byond-update"
#define BYOND_UPDATE_TESTMERGES_FILE "/home/server/start/tmp/testmerges.txt"
#define BYOND_UPDATE_NEXT_RESTART_FILE "data/next_restart_mode.txt"
#define BYOND_UPDATE_EXIT_CHANGES_PULLED 2  // Python script exit code when new commits were pulled
#define BYOND_UPDATE_EXIT_ALREADY_UP_TO_DATE 0  // Python script exit code when no new commits

// Pending update scheduled by admin. list("mode" = "main"|"testmerge"|"sync", "conflict" = ""|"incoming"|"current", "no_sync" = 0|1, "no_backup" = 0|1, "prs" = list(n, ...)) or null.
var/global/list/pending_byond_update = null

/proc/byond_update_python_path()
	return config.python_path ? config.python_path : (world.system_type == UNIX ? "/usr/bin/env python3" : "python")

// Return value: 0 = already up to date, 1 = error, 2 = new changes were pulled (notify everyone).
// Also passes testmerges file and output file so the script writes next-restart mode (testmerge PRs or main) for notifications.
/proc/byond_update_run_check_and_pull()
	if(world.system_type != UNIX)
		return 0
	var/cmd = "[byond_update_python_path()] [BYOND_UPDATE_SCRIPT] check_and_pull --testmerges-file [BYOND_UPDATE_TESTMERGES_FILE] --output-file [BYOND_UPDATE_NEXT_RESTART_FILE]"
	return shell(cmd)

// Read the line written by check_and_pull (e.g. "testmerge 123 456" or "main"). Returns a short phrase for notifications.
/proc/byond_update_next_restart_phrase()
	var/F = file(BYOND_UPDATE_NEXT_RESTART_FILE)
	if(!isfile(F))
		return "master update"
	var/line = trim(file2text(F))
	if(!line)
		return "master update"
	if(copytext(line, 1, 10) == "testmerge ")
		return "testmerge PRs [copytext(line, 10)]"
	return "master update"

/proc/byond_update_run_pending()
	if(world.system_type != UNIX || !pending_byond_update)
		return
	var/list/P = pending_byond_update
	var/mode = P["mode"]
	var/conflict = P["conflict"]
	var/no_sync = P["no_sync"]
	var/no_backup = P["no_backup"]
	var/list/prs = P["prs"]
	if(!prs)
		prs = list()
	var/cmd = "[byond_update_python_path()] [BYOND_UPDATE_SCRIPT] run_update [mode]"
	for(var/n in prs)
		cmd += " [n]"
	if(conflict == "incoming")
		cmd += " --incoming"
	else if(conflict == "current")
		cmd += " --current"
	if(mode != "sync")
		if(no_sync)
			cmd += " --no-sync"
		if(no_backup)
			cmd += " --no-backup"
	cmd += " --byond-update-path [BYOND_UPDATE_PATH]"
	shell(cmd)
	pending_byond_update = null

// Run only sync (saves/config/data). No build or update script. Use when no code changes were pulled.
/proc/byond_update_run_sync_only()
	if(world.system_type != UNIX)
		return
	var/cmd = "[byond_update_python_path()] [BYOND_UPDATE_SCRIPT] run_update sync --byond-update-path [BYOND_UPDATE_PATH]"
	shell(cmd)

// Run update at restart: read testmerges from file; if file exists with PR numbers run testmerge, else run main.
// skip_backup: when TRUE (e.g. automatic round-end update), pass --no-backup; when FALSE, use config.byond_update_no_backup
/proc/byond_update_run_auto(skip_backup = FALSE)
	if(world.system_type != UNIX)
		return
	var/cmd = "[byond_update_python_path()] [BYOND_UPDATE_SCRIPT] run_update_auto --testmerges-file [BYOND_UPDATE_TESTMERGES_FILE]"
	if(config.byond_update_conflict == "incoming")
		cmd += " --incoming"
	else if(config.byond_update_conflict == "current")
		cmd += " --current"
	if(config.byond_update_no_sync)
		cmd += " --no-sync"
	if(skip_backup || config.byond_update_no_backup)
		cmd += " --no-backup"
	cmd += " --byond-update-path [BYOND_UPDATE_PATH]"
	shell(cmd)

/proc/notify_players_update_in_progress()
	to_chat(world, span_boldannounce("The server is currently updating. Please wait for it to complete before the server restarts."))

// skip_backup: when TRUE, do not run backup during update (used for automatic round-end updates)
/proc/RunPendingUpdateAndReboot(reason = null, skip_backup = FALSE)
	// Notify players once and freeze lobby/round timers so they don't keep counting during update
	round_progressing = FALSE
	if(SSvote)
		SSvote.stop_vote()
	for(var/client/C in clients)
		if(C.tgui_panel)
			C.tgui_panel.send_roundrestart()
	// When automatic update is off, only run update script if an admin triggered one
	if(!config.automatic_update && !pending_byond_update)
		world.Reboot(reason)
		return
	// 1) Check GitHub and pull (so next run has latest source)
	var/pull_result = byond_update_run_check_and_pull()
	// 2) If an update was scheduled via admin verb, always run it. Otherwise run full update only when there were changes.
	if(pending_byond_update)
		notify_players_update_in_progress()
		byond_update_run_pending()
	else if(pull_result == BYOND_UPDATE_EXIT_CHANGES_PULLED)
		notify_players_update_in_progress()
		byond_update_run_auto(skip_backup)
	else
		byond_update_run_sync_only()
	world.Reboot(reason)

/proc/notify_world_updates_scheduled(desc)
	to_chat(world, span_boldannounce("[desc] These updates will be applied on the next server restart."))
	log_admin("BYOND update: [desc] (will apply on next restart)")

/proc/set_pending_byond_update(mode, conflict, no_sync, no_backup, list/prs)
	pending_byond_update = list(
		"mode" = mode,
		"conflict" = conflict,
		"no_sync" = no_sync ? 1 : 0,
		"no_backup" = no_backup ? 1 : 0,
		"prs" = prs ? prs.Copy() : list()
	)

ADMIN_VERB_ADD(/client/proc/byond_update_main, R_SERVER, FALSE)
/client/proc/byond_update_main()
	set name = "Update Server (Main)"
	set category = "Admin.Server"
	set desc = "Schedule update to master branch on next restart (Linux only)."

	if(!check_rights(R_SERVER) || !check_rights(R_DEBUG))
		return

	if(world.system_type != UNIX)
		to_chat(src, SPAN_DANGER("Server update is only available on Linux."))
		return

	var/conflict = alert(src, "On merge conflicts:", "Conflict strategy", "Abort (default)", "Accept PR/incoming", "Keep base (current)")
	var/conflict_key = ""
	switch(conflict)
		if("Accept PR/incoming")
			conflict_key = "incoming"
		if("Keep base (current)")
			conflict_key = "current"

	var/no_sync = alert(src, "Sync player saves, config, and data repos?", "Sync", "Yes", "No (--no-sync)") == "No (--no-sync)"
	var/no_backup = alert(src, "Create a backup before updating?", "Backup", "Yes", "No (--no-backup)") == "No (--no-backup)"

	set_pending_byond_update("main", conflict_key, no_sync, no_backup, null)
	log_admin("[key_name(src)] scheduled byond-update main (apply on next restart).")
	message_admins("[key_name_admin(src)] scheduled server update (main).")
	notify_world_updates_scheduled("Server update to master has been scheduled.")
	to_chat(src, SPAN_NOTICE("Update scheduled. It will run when the server restarts (before shutdown)."))

ADMIN_VERB_ADD(/client/proc/byond_update_testmerge, R_SERVER, FALSE)
/client/proc/byond_update_testmerge()
	set name = "Update Server (Testmerge)"
	set category = "Admin.Server"
	set desc = "Schedule testmerge of PR(s) on next restart (Linux only)."

	if(!check_rights(R_SERVER) || !check_rights(R_DEBUG))
		return

	if(world.system_type != UNIX)
		to_chat(src, SPAN_DANGER("Server update is only available on Linux."))
		return

	var/pr_input = input(src, "Enter PR number(s), space or comma separated:", "Testmerge PRs") as text|null
	if(!pr_input || !trim(pr_input))
		return

	var/list/prs = list()
	for(var/t in splittext(trim(pr_input), " ,"))
		var/n = text2num(trim(t))
		if(n > 0)
			prs += n
	if(!prs.len)
		to_chat(src, SPAN_DANGER("No valid PR numbers entered."))
		return

	var/conflict = alert(src, "On merge conflicts:", "Conflict strategy", "Abort (default)", "Accept PR/incoming", "Keep base (current)")
	var/conflict_key = ""
	switch(conflict)
		if("Accept PR/incoming")
			conflict_key = "incoming"
		if("Keep base (current)")
			conflict_key = "current"

	var/no_sync = alert(src, "Sync player saves, config, and data repos?", "Sync", "Yes", "No (--no-sync)") == "No (--no-sync)"
	var/no_backup = alert(src, "Create a backup before updating?", "Backup", "Yes", "No (--no-backup)") == "No (--no-backup)"

	set_pending_byond_update("testmerge", conflict_key, no_sync, no_backup, prs)
	var/pr_list = jointext(prs, " ")
	log_admin("[key_name(src)] scheduled byond-update testmerge PR [pr_list] (apply on next restart).")
	message_admins("[key_name_admin(src)] scheduled server testmerge: PR [pr_list].")
	notify_world_updates_scheduled("Testmerge of PR(s) [pr_list] has been scheduled.")
	to_chat(src, SPAN_NOTICE("Testmerge scheduled. It will run when the server restarts (before shutdown)."))

ADMIN_VERB_ADD(/client/proc/byond_update_sync, R_SERVER, FALSE)
/client/proc/byond_update_sync()
	set name = "Update Server (Sync Only)"
	set category = "Admin.Server"
	set desc = "Schedule sync-only (saves/config/data) on next restart (Linux only)."

	if(!check_rights(R_SERVER) || !check_rights(R_DEBUG))
		return

	if(world.system_type != UNIX)
		to_chat(src, SPAN_DANGER("Server update is only available on Linux."))
		return

	var/conflict = alert(src, "On merge conflicts:", "Conflict strategy", "Abort (default)", "Accept PR/incoming", "Keep base (current)")
	var/conflict_key = ""
	switch(conflict)
		if("Accept PR/incoming")
			conflict_key = "incoming"
		if("Keep base (current)")
			conflict_key = "current"

	set_pending_byond_update("sync", conflict_key, FALSE, FALSE, null)
	log_admin("[key_name(src)] scheduled byond-update sync (apply on next restart).")
	message_admins("[key_name_admin(src)] scheduled server sync only.")
	notify_world_updates_scheduled("Sync of saves/config/data has been scheduled.")
	to_chat(src, SPAN_NOTICE("Sync scheduled. It will run when the server restarts (before shutdown)."))
