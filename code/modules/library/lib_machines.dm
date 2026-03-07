/* Library Machines
 *
 * Contains:
 *		Borrowbook datum
 *		Library Public Computer
 *		Library Computer
 *		Library Scanner
 *		Book Binder
 */

/*
 * Borrowbook datum
 */
datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

/// Returns a library check-in computer in the given area, or null.
/proc/get_library_comp_in_area(var/area/A)
	if(!A)
		return null
	for(var/obj/machinery/librarycomp/C in world)
		if(get_area(C) == A)
			return C
	return null

/// Forbidden Lore: list of list("name", "id") for thematic tomes. Id is "tome_&lt;subtype&gt;" e.g. tome_fireball.
/proc/get_forbidden_tome_entries()
	var/static/list/cached
	if(cached)
		return cached
	cached = list()
	var/list/weights = tome_spawn_weights()
	for(var/path in weights)
		var/obj/item/book/tome/T = new path(null)
		cached += list(list("name" = T.name || "Thematic Tome", "id" = "tome_[replacetext("[path]", "/obj/item/book/tome/", "")]"))
		qdel(T)
	return cached

/// Forbidden Lore: list of list("name", "id", "message") for scroll spells. Id is "scroll_&lt;key&gt;" for Topic.
/proc/get_forbidden_scroll_entries()
	var/static/list/cached
	if(cached)
		return cached
	var/list/spells = list(
		list("name" = "Mist", "id" = "scroll_mist", "message" = "Mist."),
		list("name" = "Shimmer", "id" = "scroll_shimmer", "message" = "Shimmer."),
		list("name" = "Smoke", "id" = "scroll_smoke", "message" = "Smoke."),
		list("name" = "Oil", "id" = "scroll_oil", "message" = "Oil."),
		list("name" = "Floor Seal", "id" = "scroll_floor_seal", "message" = "Floor Seal."),
		list("name" = "Light", "id" = "scroll_light", "message" = "Light."),
		list("name" = "Gaia", "id" = "scroll_gaia", "message" = "Gaia."),
		list("name" = "Eta", "id" = "scroll_eta", "message" = "Eta."),
		list("name" = "Reveal", "id" = "scroll_reveal", "message" = "Reveal."),
		list("name" = "Entangle", "id" = "scroll_entangle", "message" = "Entangle."),
		list("name" = "Joke", "id" = "scroll_joke", "message" = "Joke."),
		list("name" = "Charger", "id" = "scroll_charger", "message" = "Charger.")
	)
	cached = spells
	return cached

/*
 * Library Public Computer
 */
/obj/machinery/librarypubliccomp
	name = "visitor computer"
	desc = "This public computer can search the library inventory."
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	var/screenstate = 0 // 0 = search settings, 1 = search results, 2 = view book
	var/title
	var/category = "Any"
	var/author
	var/SQLquery
	var/list/view_book_data = null // When set, screen 2 shows book (id, author, title, content)
	var/hacked = FALSE // When set, allows printing books from the archive (bypasses staff-only restriction)

/obj/machinery/librarypubliccomp/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power."))
		return
	usr.set_machine(src)
	nano_ui_interact(user)

/obj/machinery/librarypubliccomp/attackby(obj/item/W, mob/user)
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' : 'sound/machines/Custom_screwdriverclose.ogg'
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
			panel_open = !panel_open
			to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src]."))
			update_icon()
		return
	if(panel_open && (QUALITY_PULSING in W.tool_qualities))
		if(W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PULSING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			if(!hacked)
				hacked = TRUE
				to_chat(user, SPAN_NOTICE("You reroute the printer circuit on \the [src]. It can now print books from the archive."))
			else
				to_chat(user, SPAN_WARNING("\The [src] is already hacked."))
		return
	..()

/obj/machinery/librarypubliccomp/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = list()
	data["screenstate"] = screenstate
	data["title"] = title
	data["category"] = category
	data["author"] = author
	data["search_error"] = null
	data["search_results"] = list()
	data["view_book"] = null
	data["hacked"] = hacked
	data["printable_manuals"] = list()

	switch(screenstate)
		if(0)
			// When hacked, include printable manual books (same list as staff archive)
			if(hacked)
				var/list/manual_entries = get_printable_manuals()
				for(var/i in 1 to manual_entries.len)
					var/list/entry = manual_entries[i]
					data["printable_manuals"] += list(list("name" = entry["name"], "index" = i))
			// Search settings - template uses helper.link() for all buttons
			;
		if(1)
			establish_db_connection()
			if(!dbcon || !dbcon.IsConnected())
				data["search_error"] = "Unable to contact External Archive. Please contact your system administrator for assistance."
			else if(!SQLquery)
				data["search_error"] = "Malformed search request. Please contact your system administrator for assistance."
			else
				var/DBQuery/query = dbcon.NewQuery(SQLquery)
				if(query.Execute())
					while(query.NextRow())
						data["search_results"] += list(list(
							"author" = query.item[1],
							"title" = query.item[2],
							"category" = query.item[3],
							"id" = query.item[4]
						))
				else
					data["search_error"] = "Archive search failed. Check that the books table exists."
		if(2)
			if(view_book_data && view_book_data["title"] != null)
				data["view_book"] = view_book_data.Copy()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_visitor_kiosk.tmpl", "Library Visitor", 500, 600)
		ui.set_window_options("focus=0;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/librarypubliccomp/CanUseTopic(mob/user)
	if(stat & NOPOWER)
		return STATUS_CLOSE
	return ..()

/obj/machinery/librarypubliccomp/Topic(href, href_list)
	if(..())
		return

	if(href_list["settitle"])
		var/newtitle = input("Enter a title to search for:") as text|null
		if(newtitle)
			title = sanitize(newtitle)
		else
			title = null
	if(href_list["setcategory"])
		var/newcategory = input("Choose a category to search for:") in list("Any", "Fiction", "Non-Fiction", "Adult", "Reference", "Religion", "Technical", "Other")
		if(newcategory)
			category = sanitize(newcategory)
		else
			category = "Any"
	if(href_list["setauthor"])
		var/newauthor = input("Enter an author to search for:") as text|null
		if(newauthor)
			author = sanitize(newauthor)
		else
			author = null
	if(href_list["search"])
		SQLquery = "SELECT author, title, category, id FROM books WHERE "
		if(category == "Any")
			SQLquery += "author LIKE '%[sanitizeSQL(author)]%' AND title LIKE '%[sanitizeSQL(title)]%'"
		else
			var/sqlcat = (category in list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion", "Technical", "Other")) ? sanitizeSQL(category) : "Other"
			SQLquery += "author LIKE '%[sanitizeSQL(author)]%' AND title LIKE '%[sanitizeSQL(title)]%' AND category='[sqlcat]'"
		screenstate = 1

	if(href_list["back"])
		screenstate = 0
	if(href_list["viewbookid"])
		var/sqlid = sanitizeSQL(href_list["viewbookid"])
		establish_db_connection()
		if(dbcon && dbcon.IsConnected())
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, content FROM books WHERE id=[sqlid] LIMIT 1")
			if(query.Execute() && query.NextRow())
				view_book_data = list(
					"id" = query.item[1],
					"author" = query.item[2],
					"title" = query.item[3],
					"content" = query.item[4]
				)
				screenstate = 2
	if(href_list["backfromview"])
		view_book_data = null
		screenstate = 1
	if(href_list["printmanual"])
		if(!hacked)
			to_chat(usr, SPAN_WARNING("The printer is disabled on this terminal."))
		else
			var/idx = text2num(href_list["printmanual"])
			var/list/manual_entries = get_printable_manuals()
			if(idx && idx >= 1 && idx <= manual_entries.len)
				var/list/entry = manual_entries[idx]
				var/path_str = entry["path"]
				var/book_type = text2path(path_str)
				if(book_type && ispath(book_type, /obj/item/book/manual) && book_type != /obj/item/book/manual/demonomicon)
					var/obj/item/book/manual/M = new book_type(src.loc)
					var/obj/machinery/librarycomp/comp = get_library_comp_in_area(get_area(src))
					if(comp && !(M in comp.inventory))
						comp.inventory += M
					visible_message("[src] prints a book.")
					to_chat(usr, SPAN_NOTICE("Printed: [M.name]."))
	if(href_list["printbook"])
		if(!hacked)
			to_chat(usr, SPAN_WARNING("The printer is disabled on this terminal. Only staff computers can print."))
		else if(view_book_data && view_book_data["title"] != null)
			var/obj/item/book/B = new(src.loc)
			B.name = view_book_data["title"]
			B.title = view_book_data["title"]
			B.author = view_book_data["author"] || "Unknown"
			B.dat = view_book_data["content"] || ""
			B.icon_state = "book[rand(1,7)]"
			var/obj/machinery/librarycomp/comp = get_library_comp_in_area(get_area(src))
			if(comp && !(B in comp.inventory))
				comp.inventory += B
			visible_message("[src] prints a book.")
		screenstate = 2

	src.updateUsrDialog()
	SSnano.update_uis(src)
	keyboardsound(usr)
	return


/*
 * Library Computer
 */
// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it.
/obj/machinery/librarycomp
	name = "check-in/out computer"
	desc = "This staff computer can access the library inventory and archives."
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	req_access = list(access_library)
	var/screenstate = 0 // 0 - Main Menu, 1 - Inventory, 2 - Checked Out, 3 - Check Out a Book, 4 - Archive, 5 - Upload, 6 - Forbidden, 7 - View Book, 8 - Forbidden Tome Subtype, 9 - Forbidden Scroll Subtype
	var/sortby = "author"
	var/buffer_book
	var/buffer_mob
	var/upload_category = "Fiction"
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In minutes
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive
	var/list/view_book_data = null // When set, screen 7 shows archive book (id, author, title, content)

	var/print_delay = 0 // Cooldown between prints (1 minute) for archive and forbidden lore
	var/demonomicon_printed = FALSE // When emagged, demonomicon can be printed from Forbidden Lore once per console; printing sets GLOB.demonomicon_spawned_this_round
	var/cruciform_printed = 0     // Absolutism ritual books (max 2)
	var/c_bible_printed = 0      // Christian Bibles (max 3)
	var/tome_prints_used = 0    // Thematic tomes of one's choice (max 2 total)
	var/scroll_prints_used = 0   // Scrolls of one's choice (max 3 total)
	var/pending_forbidden_id = null // When set, nanoui shows confirm dialog before printing
	var/datum/wires/librarycomp/wires = null
	var/power_cut = FALSE   // Power wire cut: machine is off
	var/id_scan_cut = FALSE // ID scan wire cut: access scans halted (no ID check)

/obj/machinery/librarycomp/New()
	..()
	wires = new /datum/wires/librarycomp(src)

/obj/machinery/librarycomp/proc/get_forbidden_confirm_data(id)
	if(!id)
		return null
	var/remaining = 0
	var/name = "Item"
	if(id == "cruciform")
		remaining = 2 - cruciform_printed
		if(remaining <= 0) return null
		name = "Absolutism Ritual Tome"
	else if(id == "c_bible")
		remaining = 3 - c_bible_printed
		if(remaining <= 0) return null
		name = "Christian Bible"
	else if(id == "demonomicon")
		if(!emagged || demonomicon_printed) return null
		remaining = 1
		name = "Demonomicon"
	else if(copytext(id, 1, 6) == "tome_")
		remaining = 2 - tome_prints_used
		if(remaining <= 0) return null
		var/tome_type = text2path("/obj/item/book/tome/[copytext(id, 6)]")
		if(!ispath(tome_type, /obj/item/book/tome)) return null
		var/obj/item/book/tome/T = new tome_type(null)
		name = T.name
		qdel(T)
	else if(copytext(id, 1, 8) == "scroll_")
		remaining = 3 - scroll_prints_used
		if(remaining <= 0) return null
		for(var/list/entry in get_forbidden_scroll_entries())
			if(entry["id"] == id)
				name = "[entry["name"]] Scroll"
				break
	else
		return null
	return list("remaining" = remaining, "name" = name)

/obj/machinery/librarycomp/attack_hand(mob/user)
	if((stat & NOPOWER) || power_cut)
		to_chat(user, SPAN_WARNING("\The [src] has no power."))
		return
	if(!id_scan_cut && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied. ID scan required."))
		return
	if(panel_open)
		wires.Interact(user)
	usr.set_machine(src)
	nano_ui_interact(user)

/obj/machinery/librarycomp/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = list()
	data["screenstate"] = screenstate
	data["emagged"] = emagged
	data["buffer_book"] = buffer_book
	data["buffer_mob"] = buffer_mob
	data["checkoutperiod"] = checkoutperiod
	data["checkout_time"] = round(world.time / 600)
	data["due_time"] = round((world.time + (checkoutperiod * 600)) / 600)
	data["sortby"] = sortby
	data["upload_category"] = upload_category
	data["inventory"] = list()
	data["checkouts"] = list()
	data["archive_error"] = null
	data["archive_results"] = list()
	data["printable_manuals"] = list()
	data["view_book"] = null
	data["upload_scanner_author"] = null
	data["upload_scanner_title"] = null
	data["upload_no_scanner"] = FALSE
	data["upload_no_cache"] = FALSE
	data["printable_forbidden"] = list()
	data["forbidden_menu"] = list()       // Screen 6: categories with remaining + has_submenu
	data["forbidden_tome_list"] = list() // Screen 8: tome subtypes
	data["forbidden_scroll_list"] = list() // Screen 9: scroll subtypes
	data["forbidden_remaining"] = 0       // Screen 8/9: remaining count for subtitle
	data["confirm_forbidden"] = null     // When set, show nanoui confirm dialog { id, remaining, name }

	switch(screenstate)
		if(1)
			sync_library_comp_inventory_from_bookcases()
			for(var/obj/item/book/b in inventory)
				data["inventory"] += list(list("name" = b.name, "ref" = "\ref[b]"))
		if(2)
			for(var/datum/borrowbook/b in checkouts)
				var/timetaken = round((world.time - b.getdate) / 600)
				var/timedue = (b.duedate - world.time) / 600
				var/timedue_display = (timedue <= 0) ? "(OVERDUE) [round(timedue)]" : "in [round(timedue)] minutes"
				data["checkouts"] += list(list(
					"bookname" = b.bookname,
					"mobname" = b.mobname,
					"timetaken" = timetaken,
					"timedue" = timedue_display,
					"overdue" = (timedue <= 0),
					"ref" = "\ref[b]"
				))
		if(4)
			// Fetch both DB archive and printable manuals like the modular computer library program
			establish_db_connection()
			if(!dbcon || !dbcon.IsConnected())
				data["archive_error"] = "Unable to contact External Archive. Please contact your system administrator for assistance."
			else
				var/sort_col = (sortby in list("id", "author", "title", "category")) ? sortby : "id"
				var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, category FROM books ORDER BY [sort_col]")
				if(!query.Execute())
					data["archive_error"] = "Archive query failed. The books table may be missing or the database schema may differ. Check server logs."
					if(dbcon && dbcon.ErrorMsg())
						log_debug("Library archive query failed: [dbcon.ErrorMsg()]")
				else
					while(query.NextRow())
						data["archive_results"] += list(list(
							"id" = query.item[1],
							"author" = query.item[2],
							"title" = query.item[3],
							"category" = query.item[4]
						))
			var/list/manual_entries = get_printable_manuals()
			for(var/i in 1 to manual_entries.len)
				var/list/entry = manual_entries[i]
				data["printable_manuals"] += list(list("name" = entry["name"], "index" = i))
		if(5)
			if(!scanner)
				for(var/obj/machinery/libraryscanner/S in range(9))
					scanner = S
					break
			if(!scanner)
				data["upload_no_scanner"] = TRUE
			else if(!scanner.cache)
				data["upload_no_cache"] = TRUE
			else
				data["upload_scanner_title"] = scanner.cache.name
				data["upload_scanner_author"] = scanner.cache.author ? scanner.cache.author : "Anonymous"
		if(6)
			// Menu of categories: "Remaining Prints: N" and either Print or Select type
			var/cruciform_remaining = 2 - cruciform_printed
			if(cruciform_remaining > 0)
				data["forbidden_menu"] += list(list("name" = "Absolutism Ritual Tome", "id" = "cruciform", "remaining" = cruciform_remaining, "submenu" = 0))
			var/c_bible_remaining = 3 - c_bible_printed
			if(c_bible_remaining > 0)
				data["forbidden_menu"] += list(list("name" = "Christian Bible", "id" = "c_bible", "remaining" = c_bible_remaining, "submenu" = 0))
			if(emagged && !demonomicon_printed)
				data["forbidden_menu"] += list(list("name" = "Demonomicon", "id" = "demonomicon", "remaining" = 1, "submenu" = 0))
			var/tome_remaining = 2 - tome_prints_used
			if(tome_remaining > 0)
				data["forbidden_menu"] += list(list("name" = "Thematic Tome", "id" = "tome_menu", "remaining" = tome_remaining, "submenu" = 8))
			var/scroll_remaining = 3 - scroll_prints_used
			if(scroll_remaining > 0)
				data["forbidden_menu"] += list(list("name" = "Scroll", "id" = "scroll_menu", "remaining" = scroll_remaining, "submenu" = 9))
		if(8)
			data["forbidden_remaining"] = 2 - tome_prints_used
			for(var/list/entry in get_forbidden_tome_entries())
				data["forbidden_tome_list"] += list(list("name" = entry["name"], "id" = entry["id"], "remaining" = data["forbidden_remaining"]))
		if(9)
			data["forbidden_remaining"] = 3 - scroll_prints_used
			for(var/list/entry in get_forbidden_scroll_entries())
				data["forbidden_scroll_list"] += list(list("name" = "[entry["name"]] Scroll", "id" = entry["id"], "remaining" = data["forbidden_remaining"]))
		if(7)
			if(view_book_data && view_book_data["title"] != null)
				data["view_book"] = view_book_data.Copy()

	if(pending_forbidden_id)
		var/list/confirm_data = src.get_forbidden_confirm_data(pending_forbidden_id)
		if(confirm_data)
			data["confirm_forbidden"] = list("id" = pending_forbidden_id, "remaining" = confirm_data["remaining"], "name" = confirm_data["name"])
		else
			pending_forbidden_id = null

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_staff_kiosk.tmpl", "Book Inventory Management", 500, 600)
		ui.set_window_options("focus=0;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/librarycomp/CanUseTopic(mob/user)
	if((stat & NOPOWER) || power_cut)
		return STATUS_CLOSE
	return ..()

/obj/machinery/librarycomp/emag_act(remaining_charges, mob/user)
	if (src.density && !src.emagged)
		src.emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/W, mob/user)
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' : 'sound/machines/Custom_screwdriverclose.ogg'
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
			panel_open = !panel_open
			to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src]."))
			update_icon()
		return
	if((QUALITY_CUTTING in W.tool_qualities) || (QUALITY_WIRE_CUTTING in W.tool_qualities) || (QUALITY_PULSING in W.tool_qualities))
		if(panel_open)
			wires.Interact(user)
		return
	if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		scanner.computer = src
		to_chat(user, "[scanner]'s associated machine has been set to [src].")
		for (var/mob/V in hearers(src))
			V.show_message("[src] lets out a low, short blip.", 2)
	else
		..()

/obj/machinery/librarycomp/Topic(href, href_list)
	if(..())
		return

	if(href_list["switchscreen"])
		switch(href_list["switchscreen"])
			if("0")
				screenstate = 0
			if("1")
				screenstate = 1
			if("2")
				screenstate = 2
			if("3")
				screenstate = 3
			if("4")
				screenstate = 4
			if("5")
				screenstate = 5
			if("6")
				screenstate = 6
			if("7")
				screenstate = 7
			if("8")
				screenstate = 8
			if("9")
				screenstate = 9
	if(href_list["increasetime"])
		checkoutperiod += 1
	if(href_list["decreasetime"])
		checkoutperiod -= 1
		if(checkoutperiod < 1)
			checkoutperiod = 1
	if(href_list["editbook"])
		buffer_book = sanitizeSafe(input("Enter the book's title:") as text|null)
	if(href_list["editmob"])
		buffer_mob = sanitize(input("Enter the recipient's name:") as text|null, MAX_NAME_LEN)
	if(href_list["checkout"])
		var/datum/borrowbook/b = new /datum/borrowbook
		b.bookname = sanitizeSafe(buffer_book)
		b.mobname = sanitize(buffer_mob)
		b.getdate = world.time
		b.duedate = world.time + (checkoutperiod * 600)
		checkouts.Add(b)
	if(href_list["checkin"])
		var/datum/borrowbook/b = locate(href_list["checkin"])
		checkouts.Remove(b)
	if(href_list["delbook"])
		var/obj/item/book/b = locate(href_list["delbook"])
		inventory.Remove(b)
	if(href_list["setauthor"])
		var/newauthor = sanitize(input("Enter the author's name: ") as text|null)
		if(newauthor)
			scanner.cache.author = newauthor
	if(href_list["setcategory"])
		var/newcategory = input("Choose a category: ") in list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion", "Technical", "Other")
		if(newcategory)
			upload_category = newcategory
	if(href_list["upload"])
		if(scanner && scanner.cache)
			scanner.try_auto_upload_to_archive(scanner.cache, upload_category)
			src.updateUsrDialog()

	if(href_list["viewbookid"])
		var/sqlid = sanitizeSQL(href_list["viewbookid"])
		establish_db_connection()
		if(!dbcon || !dbcon.IsConnected())
			to_chat(usr, SPAN_WARNING("Network Error: Connection to the Archive has been severed."))
		else
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, content FROM books WHERE id=[sqlid] LIMIT 1")
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Failed to fetch book from archive."))
			else if(query.NextRow())
				view_book_data = list(
					"id" = query.item[1],
					"author" = query.item[2] || "Unknown",
					"title" = query.item[3] || "Untitled",
					"content" = query.item[4] || ""
				)
				screenstate = 7
			else
				to_chat(usr, SPAN_WARNING("Book not found in archive."))
	if(href_list["backfromview"])
		view_book_data = null
		screenstate = 4
	if(href_list["printarchivebook"])
		if(view_book_data && view_book_data["title"] != null)
			if(print_delay)
				for(var/mob/V in hearers(src))
					V.show_message("<b>[src]</b>'s monitor flashes, \"Printer unavailable. Please allow a short time before attempting to print.\"")
			else
				print_delay = 1
				spawn(60)
					print_delay = 0
				var/obj/item/book/B = new(src.loc)
				B.name = view_book_data["title"]
				B.title = view_book_data["title"]
				B.author = view_book_data["author"] || "Unknown"
				B.dat = view_book_data["content"] || ""
				B.icon_state = "book[rand(1,7)]"
				if(!(B in src.inventory))
					src.inventory.Add(B)
				src.visible_message("[src]'s printer hums as it produces a completely bound book. How did it do that?")
				to_chat(usr, SPAN_NOTICE("Printed: [B.name]"))
	if(href_list["targetid"])
		var/sqlid = sanitizeSQL(href_list["targetid"])
		establish_db_connection()
		if(!dbcon || !dbcon.IsConnected())
			to_chat(usr, SPAN_WARNING("Network Error: Connection to the Archive has been severed."))
		else if(print_delay)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"Printer unavailable. Please allow a short time before attempting to print.\"")
		else
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, content FROM books WHERE id=[sqlid] LIMIT 1")
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Failed to fetch book from archive."))
			else if(query.NextRow())
				var/author = query.item[2] || "Unknown"
				var/title = query.item[3] || "Untitled"
				var/content = query.item[4] || ""
				print_delay = 1
				spawn(60)
					print_delay = 0
				var/obj/item/book/B = new(src.loc)
				B.name = title
				B.title = title
				B.author = author
				B.dat = content
				B.icon_state = "book[rand(1,7)]"
				if(!(B in src.inventory))
					src.inventory.Add(B)
				src.visible_message("[src]'s printer hums as it produces a completely bound book. How did it do that?")
				to_chat(usr, SPAN_NOTICE("Printed: [B.name]"))
			else
				to_chat(usr, SPAN_WARNING("Book not found in archive."))
	if(href_list["orderbyid"])
		var/orderid = input(usr, "Enter the book ID (SS13BN) to order:") as num|null
		if(orderid != null && isnum(orderid))
			var/list/fake_list = list("targetid" = "[orderid]")
			src.Topic("", fake_list)
	if(href_list["printmanual"])
		var/idx = text2num(href_list["printmanual"])
		var/list/manual_entries = get_printable_manuals()
		if(idx && idx >= 1 && idx <= manual_entries.len)
			var/list/entry = manual_entries[idx]
			var/path_str = entry["path"]
			var/book_type = text2path(path_str)
			if(book_type && ispath(book_type, /obj/item/book/manual) && book_type != /obj/item/book/manual/demonomicon)
				var/obj/item/book/manual/M = new book_type(src.loc)
				if(!(M in src.inventory))
					src.inventory.Add(M)
				src.visible_message("[src]'s printer hums as it produces a completely bound book.")
				to_chat(usr, SPAN_NOTICE("Printed: [M.name]."))
	if(href_list["cancelforbidden"])
		pending_forbidden_id = null
	if(href_list["confirmforbidden"])
		var/id = href_list["confirmforbidden"]
		pending_forbidden_id = null
		if(!id)
			return 1
		if(print_delay)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"Restricted materials printer unavailable. Please allow a short time before attempting to print.\"")
			return 1
		var/printed = FALSE
		if(id == "cruciform" && cruciform_printed < 2)
			print_delay = 1
			spawn(60)
				print_delay = 0
			cruciform_printed += 1
			var/obj/item/book/ritual/cruciform/B = new /obj/item/book/ritual/cruciform(src.loc)
			if(!(B in src.inventory))
				src.inventory.Add(B)
			src.visible_message("[src]'s printer hums as it produces a completely bound book.")
			to_chat(usr, SPAN_NOTICE("Printed: [B.name]."))
			printed = TRUE
		else if(id == "c_bible" && c_bible_printed < 3)
			print_delay = 1
			spawn(60)
				print_delay = 0
			c_bible_printed += 1
			var/obj/item/book/manual/religion/c_bible/C = new /obj/item/book/manual/religion/c_bible(src.loc)
			if(!(C in src.inventory))
				src.inventory.Add(C)
			src.visible_message("[src]'s printer hums as it produces a completely bound book.")
			to_chat(usr, SPAN_NOTICE("Printed: [C.name]."))
			printed = TRUE
		else if(id == "demonomicon" && emagged && !demonomicon_printed)
			print_delay = 1
			spawn(60)
				print_delay = 0
			demonomicon_printed = TRUE
			GLOB.demonomicon_spawned_this_round = TRUE // Prevent demonomicon from spawning elsewhere this round
			var/obj/item/book/manual/demonomicon/D = new /obj/item/book/manual/demonomicon(src.loc)
			if(!(D in src.inventory))
				src.inventory.Add(D)
			src.visible_message("[src]'s printer hums as it produces a completely bound book.")
			to_chat(usr, SPAN_NOTICE("Printed: [D.name]."))
			printed = TRUE
		else if(copytext(id, 1, 6) == "tome_" && tome_prints_used < 2)
			var/tome_type = text2path("/obj/item/book/tome/[copytext(id, 6)]")
			if(ispath(tome_type, /obj/item/book/tome))
				print_delay = 1
				spawn(60)
					print_delay = 0
				tome_prints_used += 1
				var/obj/item/book/tome/T = new tome_type(src.loc)
				if(!(T in src.inventory))
					src.inventory.Add(T)
				src.visible_message("[src]'s printer hums as it produces a completely bound book.")
				to_chat(usr, SPAN_NOTICE("Printed: [T.name]."))
				printed = TRUE
		else if(copytext(id, 1, 8) == "scroll_" && scroll_prints_used < 3)
			var/scroll_message = null
			for(var/list/entry in get_forbidden_scroll_entries())
				if(entry["id"] == id)
					scroll_message = entry["message"]
					break
			if(scroll_message)
				print_delay = 1
				spawn(60)
					print_delay = 0
				scroll_prints_used += 1
				var/obj/item/scroll/S = new /obj/item/scroll(src.loc)
				S.message = scroll_message
				S.name = "scroll"
				if(!(S in src.inventory))
					src.inventory.Add(S)
				src.visible_message("[src]'s printer hums as it produces a scroll.")
				to_chat(usr, SPAN_NOTICE("Printed: [S.name] ([scroll_message])."))
				printed = TRUE
		if(!printed)
			to_chat(usr, SPAN_WARNING("That item is not available or you have no prints remaining for that category."))
		return 1
	if(href_list["printforbidden"])
		var/id = href_list["printforbidden"]
		if(id == "tome_menu" || id == "scroll_menu")
			return 1
		if(print_delay)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"Restricted materials printer unavailable. Please allow a short time before attempting to print.\"")
		else
			var/list/confirm_data = get_forbidden_confirm_data(id)
			if(confirm_data)
				pending_forbidden_id = id
	if(href_list["sort"] in list("author", "title", "category"))
		sortby = href_list["sort"]
	src.updateUsrDialog()
	SSnano.update_uis(src)
	return 1

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner"
	desc = "This machine can upload literature to the library database."
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/book))
		if(istype(O, /obj/item/book/manual/demonomicon))
			if(isliving(user))
				var/mob/living/L = user
				L.flash(5, FALSE, TRUE, TRUE)
			visible_message(SPAN_DANGER("\The [O] blazes with a sickly light as it rejects the scanner! The runes on its cover seem to glare."))
			to_chat(user, SPAN_DANGER("Your vision whites out as the tome vents its fury — something in you knows it will not be copied, bound, or archived. Your eyes sting."))
			return
		user.drop_item()
		O.loc = src

/obj/machinery/libraryscanner/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, SPAN_WARNING("\The [src] has no power."))
		return
	user.set_machine(src)
	nano_ui_interact(user)

/obj/machinery/libraryscanner/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(stat & (NOPOWER|BROKEN))
		return
	var/list/data = list()
	data["has_cache"] = (cache != null)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_scanner.tmpl", "Book Scanner", 400, 250)
		ui.set_initial_data(data)
		ui.open()

/// Uploads a book to the archive DB. Returns 1 on success, 0 on skip/failure (duplicate, no DB, unique book, etc.).
/obj/machinery/libraryscanner/proc/try_auto_upload_to_archive(obj/item/book/B, category = "Fiction")
	if(!B || istype(B, /obj/item/book/manual/demonomicon))
		return 0
	// All unique (copy-protected) books, including manuals, cannot be uploaded
	if(B.unique)
		return 0
	if(!establish_db_connection() || !dbcon || !dbcon.IsConnected())
		return 0
	var/check_title = B.title ? B.title : B.name
	var/check_author = B.author ? B.author : "Anonymous"
	var/sqltitle = sanitizeSQL(check_title)
	var/sqlauthor = sanitizeSQL(check_author)
	var/DBQuery/check = dbcon.NewQuery("SELECT id FROM books WHERE title='[sqltitle]' AND author='[sqlauthor]' LIMIT 1")
	if(!check.Execute() || check.NextRow())
		return 0
	var/sqlcontent = sanitizeSQL(B.dat ? B.dat : "")
	var/sqlcategory = sanitizeSQL(category)
	// ss13gamedb.books: id, author, title, content, category, author_id, created_at, updated_at (id is AUTO_INCREMENT)
	var/DBQuery/ins = dbcon.NewQuery("INSERT INTO books (author, title, content, category, author_id, created_at, updated_at) VALUES ('[sqlauthor]', '[sqltitle]', '[sqlcontent]', '[sqlcategory]', NULL, Now(), Now())")
	return ins.Execute() ? 1 : 0

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return 1

	if(href_list["scan"])
		for(var/obj/item/book/B in contents)
			cache = B
			// Upload to archive only via the library console's Upload button, not on scan
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/book/B in contents)
			B.loc = src.loc
	SSnano.update_uis(src)
	return 1


/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "book binder"
	desc = "A machine for turning paper into properly binded books."
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE

/obj/machinery/bookbinder/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/paper))
		user.drop_item()
		O.loc = src
		user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
		src.visible_message("[src] begins to hum as it warms up its printing drums.")
		sleep(rand(5,20)) //Insanely fast do to how intensive sleep is
		src.visible_message("[src] whirs as it prints and binds a new book.")
		var/obj/item/book/b = new(src.loc)
		b.dat = O:info
		b.name = "Print Job #" + "[rand(100, 999)]"
		b.icon_state = "book[rand(1,7)]"
		qdel(O)
	else
		..()
