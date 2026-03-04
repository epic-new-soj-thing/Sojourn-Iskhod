/datum/changelog
	var/static/list/changelog_items = list()

/datum/changelog/ui_state()
	return GLOB.always_state

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()
	// Mark changelog as read when they open it (same as the HTML changelog verb).
	if(user?.client?.prefs && user.client.prefs.lastchangelog != changelog_hash)
		user.client.prefs.lastchangelog = changelog_hash
		user.client.prefs.save_preferences()
		winset(user.client, "rpane.changelog", "background-color=none;font-style=;")

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/datum/asset/changelog_item/changelog_item = changelog_items[params["date"]]
		if (!changelog_item)
			changelog_item = new /datum/asset/changelog_item(params["date"])
			changelog_items[params["date"]] = changelog_item
		return ui.send_asset(changelog_item)

/datum/changelog/ui_static_data()
	var/list/data = list("dates" = list(), "month_prs" = list())
	var/regex/ymlRegex = regex(@"\.yml", "g")
	var/regex/monthRegex = regex(@"^\d{4}-\d{2}$")
	var/regex/dateLineRegex = regex(@"date:\s*['\x22]?(\d{4})-(\d{2})-\d{2}")
	var/list/autochangelog_files = flist("html/changelogs/autochangelogs/")
	var/list/month_to_prs = list()

	for(var/fname in autochangelog_files)
		var/month_key = ymlRegex.Replace(fname, "")
		if(monthRegex.Find(month_key))
			// Standalone YYYY-MM.yml file: that month has one entry (itself)
			if(!month_to_prs[month_key])
				month_to_prs[month_key] = list()
			month_to_prs[month_key] += list(month_key)
		else if(findtext(month_key, "AutoChangeLog-pr-") == 1)
			// PR file: read date from the top-level "date:" line only (ignore "date:" inside change text)
			var/path = "html/changelogs/autochangelogs/[fname]"
			var/content = file2text(path)
			if(content)
				var/pr_month = null
				for(var/line in splittext(content, "\n"))
					if(findtext(trim(line), "date:") == 1 && dateLineRegex.Find(line))
						var/yyyy = dateLineRegex.group[1]
						var/mm = dateLineRegex.group[2]
						pr_month = "[yyyy]-[mm]"
						break
				if(pr_month)
					if(!month_to_prs[pr_month])
						month_to_prs[pr_month] = list()
					month_to_prs[pr_month] += list(month_key)

	// Order by top year first, then every month in that year (newest month first); then next year, etc.
	var/list/years = list()
	for(var/m in month_to_prs)
		var/y = copytext(m, 1, 5)
		if(!(y in years))
			years += list(y)
	sortList(years)
	years = reverseList(years)
	data["dates"] = list()
	for(var/year in years)
		var/list/year_months = list()
		for(var/m in month_to_prs)
			if(copytext(m, 1, 5) == year)
				year_months += list(m)
		sortList(year_months)
		// Add in reverse index order so newest month first (2025-12, 2025-11, ..., 2025-01)
		for(var/i = length(year_months); i >= 1; i--)
			data["dates"] += list(year_months[i])
	data["month_prs"] = month_to_prs
	return data
