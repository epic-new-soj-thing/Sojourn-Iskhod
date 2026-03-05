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

/obj/machinery/librarypubliccomp/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power."))
		return
	usr.set_machine(src)
	nano_ui_interact(user)

/obj/machinery/librarypubliccomp/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = list()
	data["screenstate"] = screenstate
	data["title"] = title
	data["category"] = category
	data["author"] = author
	data["search_error"] = null
	data["search_results"] = list()
	data["view_book"] = null

	switch(screenstate)
		if(0)
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
	if(href_list["printbook"])
		if(view_book_data && view_book_data["title"] != null)
			var/obj/item/book/B = new(src.loc)
			B.name = "Book: [view_book_data["title"]]"
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
	var/screenstate = 0 // 0 - Main Menu, 1 - Inventory, 2 - Checked Out, 3 - Check Out a Book, 4 - Archive, 5 - Upload, 6 - Forbidden, 7 - View Book
	var/sortby = "author"
	var/buffer_book
	var/buffer_mob
	var/upload_category = "Fiction"
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In minutes
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive
	var/list/view_book_data = null // When set, screen 7 shows archive book (id, author, title, content)

	var/bibledelay = 0 // LOL NO SPAM (1 minute delay) -- Doohl

/obj/machinery/librarycomp/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power."))
		return
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

	switch(screenstate)
		if(1)
			sync_library_comp_inventory_from_bookcases()
			for(var/obj/item/book/b in inventory)
				data["inventory"].Add(list("name" = b.name, "ref" = "\ref[b]"))
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
			var/list/manual_entries = get_printable_manuals()
			for(var/i in 1 to manual_entries.len)
				var/list/entry = manual_entries[i]
				data["printable_manuals"].Add(list("name" = entry["name"], "index" = i))
			establish_db_connection()
			if(!dbcon || !dbcon.IsConnected())
				data["archive_error"] = "Unable to contact External Archive. Please contact your system administrator for assistance."
			else
				var/sort_col = (sortby in list("id", "author", "title", "category")) ? sortby : "id"
				var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, category FROM books ORDER BY [sort_col]")
				if(query.Execute())
					while(query.NextRow())
						data["archive_results"].Add(list(
							"id" = query.item[1],
							"author" = query.item[2],
							"title" = query.item[3],
							"category" = query.item[4]
						))
				else
					data["archive_error"] = "Archive query failed. Check that the books table exists."
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
		if(7)
			if(view_book_data && view_book_data["title"] != null)
				data["view_book"] = view_book_data.Copy()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_staff_kiosk.tmpl", "Book Inventory Management", 500, 600)
		ui.set_window_options("focus=0;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/librarycomp/CanUseTopic(mob/user)
	if(stat & NOPOWER)
		return STATUS_CLOSE
	return ..()

/obj/machinery/librarycomp/emag_act(remaining_charges, mob/user)
	if (src.density && !src.emagged)
		src.emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/W, mob/user)
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
				if(!bibledelay)

					var/obj/item/book/ritual/cruciform/B = new /obj/item/book/ritual/cruciform()
					B.loc=src.loc
					bibledelay = 1
					spawn(60)
						bibledelay = 0

				else
					for (var/mob/V in hearers(src))
						V.show_message("<b>[src]</b>'s monitor flashes, \"Bible printer currently unavailable, please wait a moment.\"")

			if("7")
				screenstate = 7
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
		if(dbcon && dbcon.IsConnected())
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, content FROM books WHERE id=[sqlid] LIMIT 1")
			if(query.Execute() && query.NextRow())
				view_book_data = list(
					"id" = query.item[1],
					"author" = query.item[2],
					"title" = query.item[3],
					"content" = query.item[4]
				)
				screenstate = 7
	if(href_list["backfromview"])
		view_book_data = null
		screenstate = 4
	if(href_list["targetid"])
		var/sqlid = sanitizeSQL(href_list["targetid"])
		establish_db_connection()
		if(!dbcon || !dbcon.IsConnected())
			to_chat(usr, SPAN_WARNING("Connection to Archive has been severed. Aborting."))
		else if(bibledelay)
			for (var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"Printer unavailable. Please allow a short time before attempting to print.\"")
		else
			bibledelay = 1
			spawn(60)
				bibledelay = 0
			var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, content FROM books WHERE id=[sqlid] LIMIT 1")
			if(query.Execute() && query.NextRow())
				var/author = query.item[2]
				var/title = query.item[3]
				var/content = query.item[4]
				var/obj/item/book/B = new(src.loc)
				B.name = "Book: [title]"
				B.title = title
				B.author = author
				B.dat = content
				B.icon_state = "book[rand(1,7)]"
				if(!(B in src.inventory))
					src.inventory.Add(B)
				src.visible_message("[src]'s printer hums as it produces a completely bound book. How did it do that?")
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
			if(ispath(book_type, /obj/item/book/manual) && book_type != /obj/item/book/manual/demonomicon)
				var/obj/item/book/manual/M = new book_type(src.loc)
				if(!(M in src.inventory))
					src.inventory.Add(M)
				src.visible_message("[src]'s printer hums as it produces a completely bound book.")
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
