/**
 * CentCom integration: https://github.com/bobbah/CentCom
 * - Public search API (read-only): https://centcom.melonmesa.com/swagger/index.html
 * - Publishing bans for aggregation: world topic + Standard format in centcom_export.dm
 */

/proc/centcom_fetch_bans(var/ckey_text, var/only_active = TRUE)
	if(!config.centcom_api_enabled)
		return list("error" = "CentCom API is disabled in config.")
	var/base = config.centcom_api_url
	if(!istext(base) || !length(base))
		return list("error" = "CentCom API URL is not set.")
	if(copytext(base, length(base)) == "/")
		base = copytext(base, 1, length(base))
	var/ckey_clean = ckey(ckey_text)
	if(!length(ckey_clean))
		return list("error" = "Invalid ckey.")
	var/url = "[base]/ban/search/[url_encode(ckey_clean)]"
	if(only_active)
		url += "?onlyActive=true"
	var/list/http = world.Export(url)
	if(!http || !islist(http))
		return list("error" = "No HTTP response (check server outbound HTTPS).")
	var/status = text2num(http["STATUS"])
	if(status != 200)
		return list("error" = "CentCom returned HTTP [status ? status : "unknown"].")
	var/content = file2text(http["CONTENT"])
	if(!content)
		return list("error" = "Empty response from CentCom.")
	var/list/data = json_decode(content)
	if(!islist(data))
		return list("error" = "Could not parse CentCom JSON.")
	return list("bans" = data)

/datum/admins/proc/centcom_bans_browse(var/ckey_text, var/only_active = TRUE)
	var/list/fetch = centcom_fetch_bans(ckey_text, only_active)
	var/ckey_clean = ckey(ckey_text)
	var/body = "<body><center><h2>CentCom — [html_encode(ckey_clean)]</h2>"
	body += "<font size='2'>Aggregated public bans from participating SS13 communities. "
	body += "<a href=\"https://centcom.melonmesa.com/\">centcom.melonmesa.com</a></font><br><br>"
	if(fetch["error"])
		body += "<p><font color='red'>[html_encode(fetch["error"])]</font></p>"
		usr << browse(HTML_SKELETON_TITLE("CentCom: [ckey_clean]", body), "window=centcom_bans;size=800x600")
		return
	var/list/bans = fetch["bans"]
	if(!bans || !bans.len)
		body += "<p>No matching bans [only_active ? "(active only)" : ""].</p>"
		usr << browse(HTML_SKELETON_TITLE("CentCom: [ckey_clean]", body), "window=centcom_bans;size=800x600")
		return
	body += "<table width='100%' border='1' cellpadding='4' cellspacing='0'>"
	body += "<tr bgcolor='#e0e0e0'><th>Source</th><th>Type</th><th>Banned</th><th>By</th><th>Expires</th><th>Active</th></tr>"
	for(var/i = 1; i <= bans.len; i++)
		var/list/ban = bans[i]
		if(!islist(ban))
			continue
		var/src_name = ban["sourceName"] ? "[ban["sourceName"]]" : "?"
		var/btype = ban["type"] ? "[ban["type"]]" : "?"
		var/banned_on = ban["bannedOn"] ? "[ban["bannedOn"]]" : "?"
		var/banned_by = ban["bannedBy"] ? "[ban["bannedBy"]]" : "?"
		var/expires = ban["expires"] ? "[ban["expires"]]" : "—"
		var/active = isnull(ban["active"]) ? "?" : (ban["active"] ? "Yes" : "No")
		var/reason = ban["reason"] ? "[ban["reason"]]" : ""
		var/jobs = ""
		if(ban["jobs"] && islist(ban["jobs"]))
			var/list/jl = ban["jobs"]
			jobs = jl.len ? jl.Join(", ") : ""
		body += "<tr valign='top'>"
		body += "<td>[html_encode(src_name)]</td>"
		body += "<td>[html_encode(btype)]</td>"
		body += "<td><font size='2'>[html_encode(banned_on)]</font></td>"
		body += "<td>[html_encode(banned_by)]</td>"
		body += "<td><font size='2'>[html_encode(expires)]</font></td>"
		body += "<td>[active]</td></tr>"
		body += "<tr><td colspan='6'><font size='2'><b>Reason:</b> [html_encode(reason)]"
		if(jobs)
			body += "<br><b>Jobs:</b> [html_encode(jobs)]"
		body += "</font></td></tr>"
	body += "</table>"
	body += "<br><font size='2'><a href='?src=\ref[src];centcom_bans_all=1;ckey=[url_encode(ckey_clean)]'>Include inactive / expired</a></font>"
	body += "</center></body>"
	usr << browse(HTML_SKELETON_TITLE("CentCom: [ckey_clean]", body), "window=centcom_bans;size=900x640")

/datum/admins/proc/show_centcom_bans(var/mob/M)
	if(!ismob(M) || !M.ckey)
		to_chat(usr, "No ckey for that mob.")
		return
	log_admin("[key_name(usr)] viewed CentCom bans for [M.ckey]")
	centcom_bans_browse(M.ckey, TRUE)

/datum/admins/proc/show_centcom_bans_ckey(var/ckey_text)
	if(!ckey_text)
		return
	log_admin("[key_name(usr)] viewed CentCom bans for [ckey(ckey_text)] (CentCom lookup verb)")
	centcom_bans_browse(ckey_text, TRUE)
