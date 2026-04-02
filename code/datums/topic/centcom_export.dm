/**
 * CentCom ban feed for the upstream "standard" exporter (StandardProviderService).
 * @see https://github.com/bobbah/CentCom/blob/master/CentCom.Server/Services/StandardProviderService.cs
 *
 * CentCom requests GET {baseUrl}api/ban?cursor=ID — BYOND only receives world topic query strings.
 * Terminate TLS and map that path to the game port, e.g.:
 *   location /api/ban {
 *     proxy_pass http://127.0.0.1:YOUR_PORT/?centcom_export_bans=1&export_key=SECRET&$is_args$args;
 *   }
 * Or register this server in CentCom with a base URL that already includes a reverse proxy to /api/ban.
 *
 * RoleplayLevel is not part of the ban JSON; it is set in CentCom (StandardProviderConfiguration.RoleplayLevel).
 * For Sojourn, register this source with RoleplayLevel High.
 */

/proc/centcom_sql_datetime_to_iso(var/t)
	if(!istext(t) || !length(t))
		return null
	var/date = copytext(t, 1, 11)
	if(length(date) < 10)
		return null
	var/time = copytext(t, 12)
	if(!length(time))
		time = "00:00:00"
	var/space = findtext(time, " ")
	if(space)
		time = copytext(time, 1, space)
	if(length(time) < 8)
		time = "00:00:00"
	return "[date]T[time]Z"

/proc/centcom_export_build_json(var/cursor_id)
	if(!config || config.ban_legacy_system || !config.sql_enabled)
		return "[]"
	if(!establish_db_connection() || !dbcon || !dbcon.IsConnected())
		return "[]"
	if(!isnum(cursor_id))
		cursor_id = 0
	var/list/out = list()
	var/DBQuery/q = dbcon.NewQuery({"
		SELECT b.id, b.type, b.reason, b.time, b.expiration_time, b.job, b.unbanned,
			t.ckey, a.ckey, u.ckey
		FROM bans b
		INNER JOIN players t ON b.target_id = t.id
		INNER JOIN players a ON b.banned_by_id = a.id
		LEFT JOIN players u ON b.unbanned_by_id = u.id
		WHERE b.id > [cursor_id]
		ORDER BY b.id ASC
		LIMIT 100
		"})
	if(!q.Execute())
		log_world("centcom_export_build_json: [q.ErrorMsg()]")
		return "[]"
	while(q.NextRow())
		var/id = q.item[1]
		var/btype = q.item[2]
		var/reason = q.item[3]
		var/btime = q.item[4]
		var/expiration = q.item[5]
		var/job = q.item[6]
		var/unbanned = q.item[7]
		var/target_ckey = q.item[8]
		var/admin_ckey = q.item[9]
		var/unbanner_ckey = q.item[10]

		var/list/entry = list(
			"id" = text2num(id),
			"banType" = (btype == "JOB_PERMABAN" || btype == "JOB_TEMPBAN") ? "Job" : "Server",
			"cKey" = list("canonicalKey" = ckey(target_ckey)),
			"bannedOn" = centcom_sql_datetime_to_iso(btime),
			"bannedBy" = list("canonicalKey" = ckey(admin_ckey)),
			"reason" = reason,
		)
		if(btype == "TEMPBAN" || btype == "JOB_TEMPBAN")
			entry["expires"] = centcom_sql_datetime_to_iso(expiration)
		else
			entry["expires"] = null

		if(btype == "JOB_PERMABAN" || btype == "JOB_TEMPBAN")
			if(job)
				entry["jobBans"] = list(list("job" = job))
			else
				entry["jobBans"] = list()

		if(unbanned && unbanner_ckey)
			entry["unbannedBy"] = list("canonicalKey" = ckey(unbanner_ckey))
		else
			entry["unbannedBy"] = null

		out.Add(entry)

	// CentCom deserializes as List<RestBan>; BYOND json_encode() can emit a lone {...} for a
	// one-element /list, which breaks System.Text.Json. Always use a JSON array.
	if(!out.len)
		return "[]"
	if(out.len == 1)
		return "[" + json_encode(out[1]) + "]"
	return json_encode(out)

/datum/world_topic/centcom_export_bans
	keyword = "centcom_export_bans"
	log = FALSE

/datum/world_topic/centcom_export_bans/TryRun(list/input)
	if(!config || !config.centcom_export_enabled)
		return "[]"
	if(config.centcom_export_key)
		if(!input["export_key"] || input["export_key"] != config.centcom_export_key)
			return "Unauthorized"
	var/cursor = 0
	if(input["cursor"])
		cursor = text2num(input["cursor"])
		if(!isnum(cursor))
			cursor = 0
	return centcom_export_build_json(cursor)
