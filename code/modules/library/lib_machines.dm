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
	data["content"] = get_visitor_ui_content()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_visitor_kiosk.tmpl", "Library Visitor", 500, 600)
		ui.set_window_options("focus=0;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/librarypubliccomp/proc/get_visitor_ui_content()
	var/dat = ""
	switch(screenstate)
		if(0)
			dat += {"<h2>Search Settings</h2><br>
			<A href='?src=\ref[src];settitle=1'>Filter by Title: [title]</A><BR>
			<A href='?src=\ref[src];setcategory=1'>Filter by Category: [category]</A><BR>
			<A href='?src=\ref[src];setauthor=1'>Filter by Author: [author]</A><BR>
			<A href='?src=\ref[src];search=1'>\[Start Search\]</A><BR>"}
		if(1)
			establish_db_connection()
			if(!dbcon || !dbcon.IsConnected())
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font><BR>"
			else if(!SQLquery)
				dat += "<font color=red><b>ERROR</b>: Malformed search request. Please contact your system administrator for assistance.</font><BR>"
			else
				dat += {"<table>
				<tr><td>AUTHOR</td><td>TITLE</td><td>CATEGORY</td><td>SS<sup>13</sup>BN</td><td></td></tr>"}

				var/DBQuery/query = dbcon.NewQuery(SQLquery)
				if(query.Execute())
					while(query.NextRow())
						var/author = query.item[1]
						var/title = query.item[2]
						var/category = query.item[3]
						var/id = query.item[4]
						dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>[id]</td><td><A href='?src=\ref[src];viewbookid=[id]'>\[View\]</A></td></tr>"
				else
					dat += "<tr><td colspan='5'><font color=red>Archive search failed. Check that the books table exists.</font></td></tr>"
				dat += "</table><BR>"
			dat += "<A href='?src=\ref[src];back=1'>\[Go Back\]</A><BR>"
		if(2)
			dat += "<h3>Archive Book</h3>"
			if(view_book_data && view_book_data["title"] != null)
				dat += "<b>[view_book_data["title"]]</b><BR>"
				dat += "<i>by [view_book_data["author"] || "Unknown"]</i> (USBN: [view_book_data["id"]])<BR><BR>"
				dat += "<div style=\"white-space: pre-wrap; background: #eee; padding: 8px; max-height: 400px; overflow-y: auto;\">[view_book_data["content"] || "(No content)"]</div><BR>"
				dat += "<A href='?src=\ref[src];printbook=1'>\[Print and add to library\]</A><BR>"
			else
				dat += "<font color=red>No book loaded.</font><BR>"
			dat += "<A href='?src=\ref[src];backfromview=1'>\[Back to Search Results\]</A><BR>"
	return dat

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
		title = sanitizeSQL(title)
	if(href_list["setcategory"])
		var/newcategory = input("Choose a category to search for:") in list("Any", "Fiction", "Non-Fiction", "Adult", "Reference", "Religion", "Technical", "Other")
		if(newcategory)
			category = sanitize(newcategory)
		else
			category = "Any"
		category = sanitizeSQL(category)
	if(href_list["setauthor"])
		var/newauthor = input("Enter an author to search for:") as text|null
		if(newauthor)
			author = sanitize(newauthor)
		else
			author = null
		author = sanitizeSQL(author)
	if(href_list["search"])
		SQLquery = "SELECT author, title, category, id FROM books WHERE "
		if(category == "Any")
			SQLquery += "author LIKE '%[author]%' AND title LIKE '%[title]%'"
		else
			SQLquery += "author LIKE '%[author]%' AND title LIKE '%[title]%' AND category='[category]'"
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
	data["content"] = get_staff_ui_content()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "library_staff_kiosk.tmpl", "Book Inventory Management", 500, 600)
		ui.set_window_options("focus=0;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/librarycomp/proc/get_staff_ui_content()
	var/dat = ""
	switch(screenstate)
		if(0)
			// Main Menu
			dat += {"<A href='?src=\ref[src];switchscreen=1'>1. View General Inventory</A><BR>
			<A href='?src=\ref[src];switchscreen=2'>2. View Checked Out Inventory</A><BR>
			<A href='?src=\ref[src];switchscreen=3'>3. Check out a Book</A><BR>
			<A href='?src=\ref[src];switchscreen=4'>4. Connect to External Archive</A><BR>
			<A href='?src=\ref[src];switchscreen=5'>5. Upload New Title to Archive</A><BR>"}
			if(src.emagged)
				dat += "<A href='?src=\ref[src];switchscreen=6'>6. Access the Forbidden Lore Vault</A><BR>"
			dat += "<BR><b>Barcode scanner:</b> Use the scanner on this computer to associate.<BR>"
			dat += "Mode 1 = Set book for check-out (then enter recipient on screen 3).<BR>"
			dat += "Mode 2 = Check in (scan book to clear its checkout).<BR>"
			dat += "Mode 3 = Add scanned book to registered inventory.<BR>"
		if(1)
			// Registered inventory (for check-out tracking)
			dat += "<H3>Registered Inventory (for check-out)</H3><BR>"
			for(var/obj/item/book/b in inventory)
				dat += "[b.name] <A href='?src=\ref[src];delbook=\ref[b]'>(Delete)</A><BR>"
			dat += "<BR><H3>Physical Inventory (all books in library)</H3><BR>"
			var/area/comp_area = get_area(src)
			if(comp_area)
				for(var/obj/item/book/b in world)
					if(get_area(b) == comp_area)
						var/where = "on floor"
						if(b.loc && istype(b.loc, /obj/structure/bookcase))
							where = "in bookcase"
						dat += "[b.name][b.author ? " by [b.author]" : ""] - [where]<BR>"
			dat += "<BR><A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"
		if(2)
			// Checked Out
			dat += "<h3>Checked Out Books</h3><BR>"
			for(var/datum/borrowbook/b in checkouts)
				var/timetaken = world.time - b.getdate
				//timetaken *= 10
				timetaken /= 600
				timetaken = round(timetaken)
				var/timedue = b.duedate - world.time
				//timedue *= 10
				timedue /= 600
				if(timedue <= 0)
					timedue = "<font color=red><b>(OVERDUE)</b> [timedue]</font>"
				else
					timedue = round(timedue)
				dat += {"\"[b.bookname]\", Checked out to: [b.mobname]<BR>--- Taken: [timetaken] minutes ago, Due: in [timedue] minutes<BR>
				<A href='?src=\ref[src];checkin=\ref[b]'>(Check In)</A><BR><BR>"}
			dat += "<A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"
		if(3)
			// Check Out a Book
			dat += {"<h3>Check Out a Book</h3><BR>
			<i>Scan a book with the barcode scanner (mode 1) to set the book title, or edit below.</i><BR>
			Book: [src.buffer_book]
			<A href='?src=\ref[src];editbook=1'>\[Edit\]</A><BR>
			Recipient: [src.buffer_mob]
			<A href='?src=\ref[src];editmob=1'>\[Edit\]</A><BR>
			Checkout Date : [world.time/600]<BR>
			Due Date: [(world.time + checkoutperiod)/600]<BR>
			(Checkout Period: [checkoutperiod] minutes) (<A href='?src=\ref[src];increasetime=1'>+</A>/<A href='?src=\ref[src];decreasetime=1'>-</A>)
			<A href='?src=\ref[src];checkout=1'>(Commit Entry)</A><BR>
			<A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"}
		if(4)
			dat += "<h3>External Archive</h3>"
			establish_db_connection()
			if(!dbcon || !dbcon.IsConnected())
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font>"
			else
				dat += {"<A href='?src=\ref[src];orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>
				<table>
				<tr><td><A href='?src=\ref[src];sort=author>AUTHOR</A></td><td><A href='?src=\ref[src];sort=title>TITLE</A></td><td><A href='?src=\ref[src];sort=category>CATEGORY</A></td><td>USBN</td><td></td></tr>"}
				var/sort_col = (sortby in list("id", "author", "title", "category")) ? sortby : "id"
				var/DBQuery/query = dbcon.NewQuery("SELECT id, author, title, category FROM books ORDER BY [sort_col]")
				if(query.Execute())
					while(query.NextRow())
						var/id = query.item[1]
						var/author = query.item[2]
						var/title = query.item[3]
						var/category = query.item[4]
						dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>[id]</td><td><A href='?src=\ref[src];viewbookid=[id]'>\[View\]</A> <A href='?src=\ref[src];targetid=[id]'>\[Order\]</A></td></tr>"
				else
					dat += "<tr><td colspan='5'><font color=red>Archive query failed. Check that the books table exists.</font></td></tr>"
				dat += "</table>"
			dat += "<BR><A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"
		if(7)
			dat += "<h3>Archive Book</h3>"
			if(view_book_data && view_book_data["title"] != null)
				dat += "<b>[view_book_data["title"]]</b><BR>"
				dat += "<i>by [view_book_data["author"] || "Unknown"]</i> (USBN: [view_book_data["id"]])<BR><BR>"
				dat += "<div style=\"white-space: pre-wrap; background: #eee; padding: 8px; max-height: 400px; overflow-y: auto;\">[view_book_data["content"] || "(No content)"]</div><BR>"
			else
				dat += "<font color=red>No book loaded.</font><BR>"
			dat += "<A href='?src=\ref[src];backfromview=1'>\[Back to Archive\]</A><BR>"
			dat += "<A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"
		if(5)
			dat += "<H3>Upload a New Title</H3>"
			if(!scanner)
				for(var/obj/machinery/libraryscanner/S in range(9))
					scanner = S
					break
			if(!scanner)
				dat += "<FONT color=red>No scanner found within wireless network range.</FONT><BR>"
			else if(!scanner.cache)
				dat += "<FONT color=red>No data found in scanner memory.</FONT><BR>"
			else
				dat += {"<TT>Data marked for upload...</TT><BR>
				<TT>Title: </TT>[scanner.cache.name]<BR>"}
				if(!scanner.cache.author)
					scanner.cache.author = "Anonymous"
				dat += {"<TT>Author: </TT><A href='?src=\ref[src];setauthor=1'>[scanner.cache.author]</A><BR>
				<TT>Category: </TT><A href='?src=\ref[src];setcategory=1'>[upload_category]</A><BR>
				<A href='?src=\ref[src];upload=1'>\[Upload\]</A><BR>"}
			dat += "<A href='?src=\ref[src];switchscreen=0'>(Return to main menu)</A><BR>"
		if(6)
			dat += {"<h3>Accessing Forbidden Lore Vault v 1.3</h3>
			Are you absolutely sure you want to proceed? EldritchTomes Inc. takes no responsibilities for loss of sanity resulting from this action.<p>
			<A href='?src=\ref[src];arccheckout=1'>Yes.</A><BR>
			<A href='?src=\ref[src];switchscreen=0'>No.</A><BR>"}

	return dat

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
			alert("Connection to Archive has been severed. Aborting.")
		if(bibledelay)
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
					src.inventory += B
				src.visible_message("[src]'s printer hums as it produces a completely bound book. How did it do that?")
	if(href_list["orderbyid"])
		var/orderid = input("Enter your order:") as num|null
		if(orderid)
			if(isnum(orderid))
				var/nhref = "src=\ref[src];targetid=[orderid]"
				spawn() src.Topic(nhref, params2list(nhref), src)
	if(href_list["sort"] in list("author", "title", "category"))
		sortby = href_list["sort"]
	src.updateUsrDialog()
	SSnano.update_uis(src)
	return

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
