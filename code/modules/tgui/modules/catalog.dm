#define CATALOG_BROWSE_STAGE_LIST "list"
#define CATALOG_BROWSE_STAGE_ENTRY "entry"
#define CATALOG_BROWSE_STAGE_NONE null

/datum/tgui_module/catalog
	tgui_id = "Catalog"

	// Controls what catalog will be loaded
	var/catalog_key = null

	// Controls generic front page
	var/front_page_use_generic = TRUE
	var/front_page_name = ""
	var/front_page_desc = ""
	var/front_page_icon = ""
	// For catalog_book: static HTML shown as the front page (equipment/how-to from wiki)
	var/front_page_content = ""

	var/catalog_search = ""
	// This whole thing is a state machine
	var/catalog_browse_stage = CATALOG_BROWSE_STAGE_NONE
	var/datum/catalog/catalog
	var/datum/catalog_entry/selected_entry
	var/list/datum/catalog_entry/entry_history = list()

// Overrides
/datum/tgui_module/catalog/New(new_host)
	. = ..()

	if(!catalog_key)
		log_debug("TGUI Catalog [name] did not specify a catalog to browse!")
		return

	if(!(catalog_key in GLOB.catalogs))
		log_debug("TGUI Catalog [name] specified an invalid catalog `[catalog_key]`.")
		return

	catalog = GLOB.catalogs[catalog_key]

/datum/tgui_module/catalog/Destroy()
	catalog = null
	selected_entry = null
	. = ..()

// Helper Functions
/datum/tgui_module/catalog/proc/set_selected_entry(mob/user, datum/catalog_entry/entry_to_browse)
	if(!entry_to_browse)
		return FALSE

	if(selected_entry && selected_entry != entry_to_browse)
		entry_history.Add(selected_entry)

	selected_entry = entry_to_browse
	catalog_browse_stage = CATALOG_BROWSE_STAGE_ENTRY
	return TRUE

// UI
/datum/asset/simple/catalog
	assets = list(
		"The_B.png" = 'nano/images/The_B.png',
		"moebus_logo.png" = 'nano/images/moebus_logo.png',
	)

/datum/tgui_module/catalog/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/simple/catalog)

/datum/tgui_module/catalog/ui_data(mob/user)
	var/list/data = ..()

	// Used to make pretty front pages and "localize" the UI to match the theme of the given catalog
	data["front_page_use_generic"] = front_page_use_generic
	data["front_page_name"] = front_page_name
	data["front_page_desc"] = front_page_desc
	data["front_page_icon"] = front_page_icon ? SSassets.transport.get_asset_url(front_page_icon) : null
	data["front_page_content"] = front_page_content
	data["catalog_key"] = catalog_key

	data["catalog_browse_stage"] = catalog_browse_stage
	data["catalog_search"] = catalog_search
	data["selected_entry"] = null
	if(LAZYLEN(entry_history))
		var/datum/catalog_entry/entry = entry_history[LAZYLEN(entry_history)]
		data["last_entry"] = entry.title
	else
		data["last_entry"] = null

	switch(catalog_browse_stage)
		if(CATALOG_BROWSE_STAGE_ENTRY)
			data["selected_entry"] = selected_entry.ui_data(user)
		if(CATALOG_BROWSE_STAGE_LIST)
			data += catalog.ui_data(user, catalog_search)

	return data

/datum/tgui_module/catalog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		// No transition back to NONE

		// Valid transitions:
		//  - NONE -> LIST
		//  - ENTRY -> LIST (erases history, "home button")
		if("state_machine_enter_list")
			if(catalog_browse_stage == CATALOG_BROWSE_STAGE_LIST)
				log_debug("TGUI Catalog invalid state transition `[catalog_browse_stage]` -> CATALOG_BROWSE_STAGE_LIST")
				return TRUE

			selected_entry = null
			entry_history.Cut()
			// Note: `catalog` ref is always active, does not need to ever change
			catalog_browse_stage = CATALOG_BROWSE_STAGE_LIST
			. = TRUE

		// Valid transitions:
		//  - LIST -> ENTRY
		//  - ENTRY -> ENTRY (history chaining)
		if("state_machine_enter_entry")
			// Valid transitions:
			//  - LIST -> ENTRY
			//  - ENTRY -> ENTRY (history chaining)
			if(catalog_browse_stage == CATALOG_BROWSE_STAGE_NONE)
				log_debug("TGUI Catalog invalid state transition `[catalog_browse_stage]` -> CATALOG_BROWSE_STAGE_ENTRY")
				return TRUE

			var/entry_id = text2path(params["entry"])
			var/datum/catalog_entry/E = GLOB.all_catalog_entries_by_type[entry_id]
			if(!istype(E))
				to_chat(usr, SPAN_WARNING("Unable to load entry '[entry_id]', corrupt data."))
				log_debug("TGUI Catalog attempted to load bad entry [entry_id]")
				return TRUE

			set_selected_entry(usr, E)
			. = TRUE

		// Valid transitions:
		//  - ENTRY -> ENTRY (reverse through entry_history)
		//  - ENTRY -> LIST (when history is empty)
		if("state_machine_pop_entry")
			if(LAZYLEN(entry_history))
				selected_entry = entry_history[LAZYLEN(entry_history)]
				entry_history.Remove(selected_entry)
				// Won't create infinite history because set_selected_entry checks if we're navigating to something we're already on
				set_selected_entry(usr, selected_entry)
			else
				selected_entry = null
				catalog_browse_stage = CATALOG_BROWSE_STAGE_LIST

			. = TRUE

		// Non-state-machine-things
		if("set_catalog_search")
			catalog_search = params["search"]
			. = TRUE

/*********************/
/* Subtypes          */
/*********************/

// Cooking Catalog
/datum/tgui_module/catalog/cooking
	name = "Frontier Logistics (and Vesalius-Andra) Presents: Very Incredible Kitchen Assistant"
	catalog_key = CATALOG_COOKING

	front_page_name = "Very Incredible Kitchen Assistant"
	front_page_desc = "Welcome~"
	front_page_icon = "The_B.png"

/datum/tgui_module/catalog/cooking/ntos
	ntos = TRUE

/datum/tgui_module/catalog/cooking/silicon
/datum/tgui_module/catalog/cooking/silicon/ui_state(mob/user)
	return GLOB.self_state

/datum/tgui_module/catalog/cooking/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/cooking_icons)

// Drinks Catalog
/datum/tgui_module/catalog/drinks
	name = "Drinks Catalog"
	catalog_key = CATALOG_DRINKS

	front_page_name = "Neon Cocktails!"
	front_page_desc = "Electronic handbook containing all information about cocktail craft."

/datum/tgui_module/catalog/drinks/ntos
	ntos = TRUE

/datum/tgui_module/catalog/drinks/silicon
/datum/tgui_module/catalog/drinks/silicon/ui_state(mob/user)
	return GLOB.self_state

// Reagents Catalog
/datum/tgui_module/catalog/chemistry
	name = "Vesalius-Andra Reagent Catalogue"
	catalog_key = CATALOG_CHEMISTRY

	front_page_name = "Vesalius-Andra Reagent Catalog"
	front_page_desc = "Welcome to the Vesalius-Andra Internal Reagent Database"
	front_page_icon = "moebus_logo.png"

/datum/tgui_module/catalog/chemistry/ntos
	ntos = TRUE

/datum/tgui_module/catalog/chemistry/silicon
/datum/tgui_module/catalog/chemistry/silicon/ui_state(mob/user)
	return GLOB.self_state

// Centcom Catalog
/datum/tgui_module/catalog/all
	name = "Centcom chemCatalog"
	catalog_key = CATALOG_ALL

	front_page_name = "CentCom Reagent Catalogue"
	front_page_desc = "Electronic catalog containing all chemical reactions and reagents"

/datum/tgui_module/catalog/all/ntos
	ntos = TRUE

/datum/tgui_module/catalog/all/silicon
/datum/tgui_module/catalog/all/silicon/ui_state(mob/user)
	return GLOB.self_state

/*********************/
/* Catalog Book       */
/* Same data as catalog but opens in book-style TGUI (table of contents + pages) */
/*********************/

/datum/tgui_module/catalog_book
	parent_type = /datum/tgui_module/catalog
	tgui_id = "CatalogBook"
	// Start with list (table of contents) visible; no separate "front page" in book mode
	var/start_in_list = TRUE

/datum/tgui_module/catalog_book/New(new_host)
	. = ..()
	if(start_in_list && catalog_browse_stage == CATALOG_BROWSE_STAGE_NONE)
		catalog_browse_stage = CATALOG_BROWSE_STAGE_LIST

/datum/tgui_module/catalog_book/ui_data(mob/user)
	var/list/data = ..()
	// Book UI always needs entries for the table of contents, even when viewing a page
	if(catalog_browse_stage == CATALOG_BROWSE_STAGE_ENTRY && catalog)
		var/list/toc = catalog.ui_data(user, catalog_search)
		data["entries"] = toc["entries"]
	return data

// Books are just paper — no power required. Silicons can read them even with a dead cell.
/datum/tgui_module/catalog_book/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_module/catalog_book/cooking
	name = "Chef Recipes"
	catalog_key = CATALOG_COOKING
	front_page_name = "Chef Recipes"
	front_page_desc = "A collection of recipes from Frontier Logistics."
	front_page_content = {"<h2>Kitchen Equipment and How to Use It</h2>
<p>Your PDA has a program (VIKA) with every cooking recipe and step-by-step instructions. Use this section for equipment, controls, and supplies.</p>
<h3>The step-based cooking system</h3>
<p>Recipes are done one step at a time in a <b>cooking container</b>. Add ingredients by using them on the container in the order the recipe requires. Pour reagents (flour, water, oil, milk) into the container. Some steps require cooking: on the stove (High/Medium/Low for a set time), on the grill, in the oven, in the deep fryer, or in the oven with an air fryer basket. Doing each step correctly—right amounts, correct heat, correct order—improves quality. Wrong heat or skipping steps can reduce quality or ruin the result. Use a <b>spatula</b> on a full container to empty it and start over.</p>
<h3>Containers and which appliance</h3>
<ul><li><b>Bowl:</b> Mixing. No cooking in the bowl.</li>
<li><b>Cutting board:</b> Assembling burgers, sandwiches, and similar. Add ingredients in order.</li>
<li><b>Pan:</b> Stovetop. Place on a stove burner; set heat and timer, then turn the burner on.</li>
<li><b>Grill:</b> Place on the grill; set heat and timer, then turn that grill slot on.</li>
<li><b>Oven tray:</b> Baking. Place in the oven; set temperature and timer, then turn the oven on.</li>
<li><b>Pot:</b> Boiling, soups. Use on the stovetop like a pan.</li>
<li><b>Deep fryer basket:</b> Only for the deep fryer. Put food in the basket, then place the basket in the deep fryer.</li>
<li><b>Air fryer basket:</b> Used inside the <b>oven</b> for air-fried recipes (no separate air fryer machine). Place in the oven like an oven tray.</li></ul>
<p>Recipes that allow \"deep fry or air fry\" can be made in either the deep fryer or the oven with an air fryer basket; VIKA states which.</p>
<h3>Setting temperature and timer</h3>
<p><b>Stovetop:</b> Four burners. Ctrl+Click the stove to set temperature (High/Medium/Low) or timer for the selected burner. Shift+Ctrl+Click to turn that burner on or off. Put a pan or pot on the burner before starting.</p>
<p><b>Grill:</b> Two slots. Ctrl+Click to set temperature or timer for a slot. Shift+Ctrl+Click to turn that slot on or off. Feed wood into the hopper for fuel.</p>
<p><b>Oven:</b> Accepts oven tray and air fryer basket. Ctrl+Click to set temperature or timer. Shift+Ctrl+Click to turn the oven on or off.</p>
<p><b>Deep fryer:</b> There is no lid. Accepts only the deep fryer basket. Shift+Click to set oil temperature (High/Medium/Low) or to set a timer in seconds. Shift+Ctrl+Click to turn the fryer on or off. If you set a timer, the fryer will run until the timer ends and then turn off. Click the deep fryer with an empty hand to take the basket out; hot oil can burn bare hands at High or Medium—wear gloves or wait for it to cool.</p>
<h3>Supplies and where to get them</h3>
<p><b>Hydroponics</b> (beside the kitchen): Grows wheat, tomatoes, potatoes, and many other fruits and vegetables. Vital staples are wheat, tomatoes, and potatoes. The department can also produce wheat and milk from biomass. See the hydroponics guide for growing.</p>
<p><b>Meat grinder:</b> In the freezer. Put corpses (animals, etc.) in to get steaks. Do not use for crew.</p>
<p><b>Cows:</b> Can be milked with a bucket if fed wheat. Slaughter for meat.</p>
<p><b>Chickens:</b> Feed wheat to get them to lay eggs. Unattended eggs may hatch; any egg that is touched by anyone will not hatch.</p>
<p><b>Church of the Absolute:</b> Can provide basic kitchen stock (meat, milk, garden produce).</p>
<p><b>Cargo:</b> Order protein, chickens, and other ingredients. Prospectors and Blackshield can supply meat.</p>
<p>Not following recipes leads to a broken microwave, burned mess, or failed dish. Use VIKA for exact step-by-step instructions and cooking times.</p>"}

/datum/tgui_module/catalog_book/cooking/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/cooking_icons)

/datum/tgui_module/catalog_book/drinks
	name = "Barman Recipes"
	catalog_key = CATALOG_DRINKS
	front_page_name = "Barman Recipes"
	front_page_desc = "Drinks and cocktails for the discerning bartender."
	front_page_content = {"<h2>Bar Equipment and How to Use It</h2>
<p>Your PDA has a program with every bartending recipe. Use it as your main reference; this section covers equipment, ingredients, and serving.</p>
<h3>Equipment</h3>
<p><b>Drinking glass:</b> Holds only 30 units. Many cocktails need more than 30u of mixed ingredients, so mixing in the glass alone is often not enough.</p>
<p><b>Drink shaker:</b> Use the shaker to mix cocktails before pouring into a glass. Add each ingredient (pour reagents, use bottles or containers) into the shaker, then pour the result into a glass. This lets you fit full recipes into one drink.</p>
<p><b>Booze-o-Mat:</b> Dispenses bottled spirits, wine, and other poured drinks. Poured drinks (straight vodka, gin, wine, etc.) can be served directly from the bottle or from the Booze-o-Mat—no mixing needed. The bar may also have beer kegs and cold drinks.</p>
<p><b>Vending machines:</b> Soda, cola, tomato juice, and other mixers often come from the bar's vending machines or the Booze-o-Mat. Ice and cream from the drinks dispenser.</p>
<h3>Where to get ingredients</h3>
<ul><li><b>Gardener:</b> Fruit and vegetables—process them (e.g. in a grinder or juicer) to get lemon juice, lime juice, orange juice, watermelon juice, berry juice, banana, etc. Lemons, limes, oranges, berries, and other produce are used in many cocktails.</li>
<li><b>Chemist:</b> Ethanol, sulphuric acid, iron, and other chemicals for specific recipes (e.g. Amasec, Acid Spit). Ask Medical or use the chemistry dispenser if you have access.</li>
<li><b>Kitchen:</b> Milk, cream, and sometimes other food reagents.</li>
<li><b>Mining / Cargo:</b> Gold, silver, uranium, and other minerals for novelty drinks (e.g. Goldschlager, Patron). Grind sheets or use ore.</li>
<li><b>Blood:</b> Some drinks use blood; draw with a syringe or use blood tomatoes from botany.</li></ul>
<h3>Alcohol strength and effects</h3>
<p>Each drink has a strength value; lower numbers mean stronger. Drinking too much causes slurring, dizziness, stumbling, and passing out. Drinking slowly reduces the effect. Some species react strongly: Skrell treat any alcohol as very strong and get drunk quickly. Humans can take liver damage from overuse, often around the point they pass out. Non-alcoholic options are available for staff who must stay sober.</p>
<h3>Workflow</h3>
<p>For mixed drinks: gather ingredients (juices, spirits, reagents), add them to the drink shaker in the correct parts or order as per the recipe, then pour into a glass. For poured drinks: dispense from the Booze-o-Mat or bottle into a glass. Presentation matters—a skilled bartender knows both recipes and how to serve them. This book's contents list every recipe in the catalog for when the PDA is unavailable.</p>"}

/datum/tgui_module/catalog_book/chemistry
	name = "Laboratory Chemistry Guide"
	catalog_key = CATALOG_CHEMISTRY
	front_page_name = "Vesalius-Andra Reagent Catalog"
	front_page_desc = "A complete guide to laboratory chemistry and reagents."
	front_page_content = {"<h2>Laboratory Chemistry: Equipment and Use</h2>
<p>Your PDA program (SIRC) lists every chemical recipe. Use this section for equipment, controls, and safety.</p>
<h3>Safety and best practices</h3>
<ul><li>Do not ingest unknown or unlabelled chemicals. Label bottles and vials when storing or handing them off. Keep food and drink out of the lab.</li>
<li>Do not remove beakers from machines while they are running (centrifuge, mass spectrometer, electrolyzer). Wait for the cycle to finish or stop the machine first.</li>
<li>Chemical heaters produce hot vessels; allow beakers to cool before handling when possible.</li>
<li>Wear gloves and eye protection when handling hazardous or unknown mixtures. Droppers, micropipetters, and syringes can squirt or inject into eyes or skin—use care with transfer amount.</li>
<li>Syringes: Confirm mode (draw vs. inject) before use. Use fresh or properly cleaned syringes to avoid cross-contamination. Only trained personnel should perform injections.</li>
<li>Clean up spills promptly. Dispose of waste and used containers according to local policy.</li></ul>
<h3>Containers</h3>
<p><b>Beakers:</b> Standard (60u), large (120u), cryostasis (60u, contents do not react—use for storage), bluespace (300u), vial. All chemistry machines accept beakers. Add a beaker by clicking the machine with the beaker in hand or MouseDrop.</p>
<p><b>Glass bottle:</b> 60u; some have lids—open before refilling or draining. Often used for finished products from the ChemMaster.</p>
<p><b>Transfer amount:</b> Alt+Click any container to set units per use (e.g. 1, 5, 10, 30). This affects pouring, drawing, and dispensing.</p>
<h3>Transfer tools</h3>
<p><b>Dropper:</b> Holds 5u; transfer 1-5u per use (set via Alt+Click). Click a container to draw, then click another container or a mob's eyes to transfer. Does not inject into the bloodstream.</p>
<p><b>Micropipetter:</b> Holds 1u max; transfer 0.1u, 0.2u, 0.5u, or 1u per use. Precision tool for small volumes. Same use as dropper (draw then transfer); does not inject.</p>
<p><b>Syringe:</b> Holds 15u. Toggle mode (e.g. attack self): <b>Draw</b> from containers or blood, <b>Inject</b> into containers or mobs (bloodstream). Requires biology knowledge or training for safe use.</p>
<h3>Chemical dispenser</h3>
<p>Dispenses base reagents into a beaker. Place a beaker on the dispenser (click with beaker or MouseDrop). Set the amount per dose in the interface, then click a chemical name to dispense. The machine uses an internal cell that recharges when idle.</p>
<p><b>Upgrades:</b> <b>Capacitor</b>—increases charge rate (how fast you can dispense). <b>Manipulator</b>—unlocks chemical tiers (Tier 1: water, sugar, ethanol, acids, etc.; higher tiers add oil, toxin, salt, mutagen, inaprovaline; tiers are additive). <b>Power Cell</b>—increases max charge and charge rate.</p>
<p><b>Hacking:</b> Use a multitool on the machine to hack or unhack (adds e.g. Mind Breaker Toxin, Space Cleaner). Opening the panel with a screwdriver first is not required.</p>
<h3>ChemMaster</h3>
<p>Transfers reagents between one beaker and an internal buffer, then turns the buffer into pills, bottles, or syrettes. Insert one beaker (attack or MouseDrop); eject from the interface when done.</p>
<p><b>Modes:</b> Toggle direction—beaker to buffer, or buffer to beaker. Select a reagent and amount, then transfer. Use <b>Analyze</b> on a reagent (e.g. blood) for detailed info.</p>
<p><b>Products:</b> Pills (by number or volume per pill; optional pill bottle). Single bottle (e.g. 60u) from the buffer. Syrette or advanced syrette for single-dose injection. Choose the sprite (pill shape, bottle style) in the interface before printing.</p>
<h3>Chemical heater</h3>
<p>Heats or cools a single beaker to a target temperature. Many reactions depend on temperature. Set the target in Kelvin in the interface and turn the heater on. Add a beaker (attack or MouseDrop); Alt+Click to eject. Better micro-lasers improve heating and cooling speed.</p>
<h3>Mass spectrometer (HPLC)</h3>
<p>Separates reagents by mass. Reagents have a mass value; only those within the chosen range are moved from input to output.</p>
<p><b>Setup:</b> Insert the input beaker (your mixture) by clicking the machine with the container; Alt+Click to eject. Insert the output beaker via the machine's interface (Insert/Eject in the Output section).</p>
<p><b>Sliders:</b> Left slider = lower bound of mass range. Right slider = upper bound. Center slider = moves the whole range left or right without changing its width. The input table shows each reagent's mass; rows in range are highlighted. Press Start; the machine runs for the shown ETA, then transfers matching reagents to the output beaker.</p>
<h3>Centrifuge</h3>
<p>Separates a mixture by moving the dominant reagent into the main beaker and the rest into separation beakers, or runs reactions (synthesis mode).</p>
<p><b>Setup:</b> Main beaker (slot 0): your mixture—add first via attack or MouseDrop. Separation beakers: add to the other slots; they receive the other reagents when separating.</p>
<p><b>Modes:</b> Separating (moves main reagent to main beaker, rest to separation beakers). Synthesising (spins to promote reactions; no separation). Isolating (longer run for finer separation). Choose mode and cycle time, then start; the machine pings when done. Eject beakers when stopped.</p>
<h3>Electrolyzer</h3>
<p>Breaks a single electrolysis-capable reagent back into its recipe ingredients (e.g. water into hydrogen and oxygen). Put only one reagent type in the primary beaker; add an empty separation beaker. Turn the machine on; it pings when finished or buzzes on error (wrong reagent, no space).</p>
<h3>All-In-One grinder</h3>
<p>Grinds plants, produce, and other items into reagents, collected in a single beaker. Add items (e.g. from a produce bag) and a beaker, then run the grinder. Useful for extracting chemicals from plants or breaking down sheets (e.g. metal) into reagent form. Better manipulators improve capacity and speed.</p>"}
