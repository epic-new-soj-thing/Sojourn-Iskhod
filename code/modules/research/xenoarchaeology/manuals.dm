
/obj/item/book/manual/excavation
	name = "Out on the Dig"
	icon_state = "excavation"
	author = "Professor Patrick Mason, Curator of the Antiquities Museum on Ichar VII, Edited by Professor Wisponellus for Iskhod use."
	title = "Out on the Dig"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Prep">Prepping the expedition</a></li>
					<li><a href="#Tools">Equipment you'll need</a></li>
					<li><a href="#Survey">Initial site survey</a></li>
					<li><a href="#Scan">Depth analysis scanning</a></li>
					<li><a href="#Read">Reading scanner data</a></li>
					<li><a href="#Math">Excavation mathematics (critical!)</a></li>
					<li><a href="#Setup">Setting up excavation</a></li>
					<li><a href="#Excavate">The excavation process</a></li>
					<li><a href="#Special">Special cases</a></li>
					<li><a href="#Finds">Types of finds</a></li>
					<li><a href="#Safety">Safety and best practices</a></li>
					<li><a href="#Research">Research and documentation</a></li>
					<li><a href="#Emergency">Emergency procedures</a></li>
					<li><a href="#Advanced">Advanced techniques</a></li>
				</ol>
				<br>

				<h2>Overview</h2>
				The <b>Depth Analysis Scanner</b> (also called X-ray diffractor) is the crucial tool in xenoarchaeology. It uses X-ray diffraction to locate anomalous
				densities in rock, indicating archaeological deposits. This guide will teach you how to use it effectively to uncover ancient artifacts and anomalies.<br>
				<br>

				<h1><a name="Prep">Prepping the expedition</a></h1>
				Every digsite I've been to, someone has forgotten something and I've never yet been to a dig that hasn't had me hiking to get to it - so gather your gear
				and get it to the site the first time. Most importantly, if possible bring others. Share the workload and make an adventure that you and others can
				talk about later: someone capable of medical work, someone capable of protecting the group, and of course someone able to dig up finds.<br>
				<ul>
					<li>Communication equipment (HAM radios - your lifelines!)</li>
					<li>Medicinal supplies (Someone always gets injured somehow.)</li>
					<li>Suspension Field Generator (No field generator means little to no finds.)</li>
					<li>Crates or other transport (You'll have a lot to haul.)</li>
					<li>Weapons and ammo (You'll need it.)</li>
					<li>Food (You will be crawling back starved without this.)</li>
					<li>Base camp equipment (Only needed if actually staying out - power supply, solars, etc.)</li>
				</ul><br>

				<h1><a name="Tools">Equipment you'll need</a></h1>
				Every archaeologist has a plethora of tools at their disposal. From the excavation kit, the important ones are:<br>
				<ul>
					<li><b>Depth Analysis Scanner</b> - Main tool for finding anomalies. Uses X-ray diffraction; comes with a reference log (coordinates and time of each scan).</li>
					<li><b>Alden-Saraspova Counter</b> (Anomaly Scanner) - Detects exotic energy signatures. Use it first to find promising areas.</li>
					<li><b>Excavation pick</b> - For precise digging; removes 2cm per use.</li>
					<li><b>Regular pickaxe</b> - For clearing normal rock.</li>
					<li><b>Measuring tape</b> - Essential. Don't leave home without it; measure the depth you or someone else has dug.</li>
					<li><b>Core sampler</b> - Take core samples from rock faces for the lab.</li>
					<li><b>Suspension Field Generator</b> - Critical for extracting finds safely.</li>
					<li><b>Meson goggles</b> - YOU WILL WANT THESE. See through rock; find markings that stand out. Without them you're basically digging blind. They take small battery cells.</li>
					<li><b>GPS</b> - For navigation and safety; helps others find you if something bad happens.</li>
					<li><b>Hand labeler</b> - For marking finds.</li>
					<li><b>Research tape</b> - For securing dig sites.</li>
					<li><b>Fossil bag</b> - For storing finds.</li>
					<li><b>Flashlight, floodlights or portable light source</b> - Self-explanatory, I hope.</li>
					<li><b>Anomaly suit</b> - Essential protection for dangerous artifacts. Biosealed, catalysis-resistant, with eye shielding and non-reactive gloves.</li>
					<li><b>Environmental safety gear</b> - Enclosed footwear and a pack of internals could save your life.</li>
					<li><b>Personal defence weapon</b> - Pirates, natives, ancient guardians, carnivorous wildlife - it pays in blood to be prepared.</li>
				</ul><br>

				<h1><a name="Survey">Initial site survey</a></h1>
				Wouldn't be an archaeologist without your dig, but everyone has to start somewhere.<br>
				<ul>
					<li><b>Use the Alden-Saraspova Counter first</b> - Detects exotic energy signatures within range; gives wavelength IDs and approximate distances. Helps identify promising areas for detailed scanning.</li>
					<li><b>Survey the terrain</b> - Look for unusual rock formations, white strata or out-of-place geology. Clear away surface debris with the regular pickaxe.</li>
					<li>Double <b>check your gear</b> then triple check it. Digs are a long walk away.</li>
					<li><b>Notify your department</b> - Always let someone know where you are going. Check with others to see if someone would like to come along.</li>
				</ul><br>

				<h1><a name="Scan">Depth analysis scanning</a></h1>
				<ul>
					<li>Equip the Depth Analysis Scanner and <b>click on mineral turfs</b> (rock surfaces) to scan them.</li>
					<li><b>Listen for audio feedback</b> - The scanner will ping if it detects something interesting; different pings indicate different finds.</li>
					<li><b>Check the scanner interface</b> - Click the scanner to open its log; successful scans are automatically recorded.</li>
				</ul><br>

				<h1><a name="Read">Reading scanner data</a></h1>
				The scanner logs contain critical information. Don't skip this.<br>
				<ul>
					<li><b>Coordinates</b> - Exact location (format: X.x:Y.y:Z.z)</li>
					<li><b>Time stamp</b> - When the scan was performed</li>
					<li><b>Anomaly depth</b> - How deep the find is (in centimeters)</li>
					<li><b>Clearance</b> - Size of the soft material bubble around the find (in centimeters)</li>
					<li><b>Dissonance spread</b> - Affects suspension field settings</li>
					<li><b>Material type</b> - Indicates find type and required field setting:
					<ul>
						<li><b>Carbon</b> - Organic materials, fossils, remains</li>
						<li><b>Iron</b> - Metal objects, weapons, tools</li>
						<li><b>Plasma</b> - High-energy artifacts, dangerous items</li>
						<li><b>Mercury</b> - Unknown or exotic materials</li>
					</ul></li>
				</ul><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Math">Excavation mathematics (critical!)</a></h1>
				All scanner data is in <b>centimeters (cm)</b>. Each excavation pick use removes <b>2cm of depth</b>. You must divide measurements by 2 to get pick uses needed.<br>
				<br>
				<b>First dig (to reach the bubble):</b><br>
				(Find Depth - Current Dug Depth - Clearance) ÷ 2 = Pick uses needed<br>
				<br>
				<b>Second dig (into the bubble, with suspension field on):</b><br>
				Clearance ÷ 2 = Pick uses needed<br>
				<br>
				<b>Example:</b> Find Depth 80cm, Clearance 20cm, currently dug 0cm.<br>
				First dig: (80 - 0 - 20) ÷ 2 = 30 pick uses. Second dig: 20 ÷ 2 = 10 pick uses.<br>
				<br>
				<ul>
					<li><b>Find Depth</b> - How far down the object we're trying to dig out is.</li>
					<li><b>Current Dug Depth</b> - How far we've already dug. Use the measuring tape.</li>
					<li><b>Clearance</b> - The bubble of soft material around the find. We dig to the edge of it, THEN dig the bubble itself only after the suspension field is on.</li>
					<li><b>Why divide by 2?</b> - Each use of the excavation pick removes 2cm. So we divide by two to get the number of pick uses.</li>
					<li><b>OH NO I MESSED UP!</b> - Wrong math happens. Too far and you've broken your find. Not far enough, or two separate digs into the bubble, and you'll get a strange rock. A welder, brush or pick might still save it - but it could crumble. Won't know till you try.</li>
					<li><b>But wait there's more!</b> - Multiple finds at a site? If the scanner shows something at 200cm depth, congratulations - you've found an anomaly. Dig to 200cm and it may break into a boulder. Excavate 2cm by 2cm. Wear your anomaly suit. Seriously.</li>
				</ul><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Setup">Setting up excavation</a></h1>
				<ul>
					<li><b>Position the suspension field generator</b> - Face it toward the dig site. Wrench it into place for stability. Configure field type based on material (see the suspension manual).</li>
					<li><b>Clear the excavation area</b> - Remove surface rocks with the regular pickaxe; create a clean workspace; mark the area clearly.</li>
					<li><b>Prepare safety measures</b> - Put on the anomaly suit for dangerous finds; have GPS active for emergency location; ensure good lighting.</li>
				</ul><br>

				<h1><a name="Excavate">The excavation process</a></h1>
				<ul>
					<li><b>First dig (to the bubble)</b> - Use the excavation pick the calculated number of times. Do NOT turn on the suspension field yet. Use the measuring tape to verify depth. You should be at: Find Depth minus Clearance.</li>
					<li><b>Verify your depth</b> - If wrong, recalculate before proceeding.</li>
					<li><b>Activate the suspension field</b> - Turn on the generator. Verify the field is active and stable. Configure to match material type.</li>
					<li><b>Second dig (into the bubble)</b> - MUST be done in one continuous action. Use the excavation pick for the calculated clearance uses. Cannot be split into multiple sessions - or you get a strange rock or break the find.</li>
					<li><b>Extract the find</b> - Turn off the suspension field. Carefully remove the artifact. Label and document immediately.</li>
				</ul><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Special">Special cases</a></h1>
				<ul>
					<li><b>Large anomalies (boulders)</b> - If excavation produces a large boulder, it contains a major artifact. Dig into the boulder 2cm at a time with the excavation pick. Wear the anomaly suit - these can be extremely dangerous. Artifacts may activate when exposed to air.</li>
					<li><b>Strange rocks</b> - Result from improper excavation (wrong depth, broken field, etc.). May still contain salvageable finds. Try welder, brush or pick based on rock type. Success not guaranteed - may crumble completely.</li>
					<li><b>Multiple finds</b> - Single locations may contain multiple artifacts. Scan thoroughly after each extraction. Look for additional depth readings, especially around 200cm - that often indicates major anomalous artifacts.</li>
				</ul><br>

				<h1><a name="Finds">Types of finds</a></h1>
				<b>Common:</b> Weapons (ancient guns, blades, tools), cultural items (bowls, urns, statuettes, coins), technology (circuit boards, strange devices), organic (fossils, plant remains, humanoid remains).<br>
				<b>Rare and dangerous:</b> Precursor technology, anomalous artifacts, cultist items, unknown materials with unknown properties.<br>
				<br>

				<h1><a name="Safety">Safety and best practices</a></h1>
				<b>Critical rules:</b> Always wear the anomaly suit for unknown or large finds. Never dig into the bubble without an active suspension field. Double-check all calculations - you only get one chance. Mark dig sites clearly. Use GPS so others can locate you. Work with a partner when possible.<br>
				<br>
				<b>Tips:</b> Take your time - rushing leads to broken finds. Verify measurements twice before digging. Keep detailed notes. Take core samples for research. Clear excess rock regularly. Watch for wildlife - dig sites attract dangerous creatures.<br>
				<br>
				<b>Mistakes to avoid:</b> Wrong math; digging too far (breaks the find); not digging far enough (creates strange rock); splitting the bubble dig into multiple actions; wrong suspension field (can destroy delicate finds); no safety gear (anomalies can be lethal when exposed).<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Research">Research and documentation</a></h1>
				<b>Core sampling</b> - Use the core sampler on rock faces before excavation. Submit samples to the research lab for analysis; provides research points and geological data; can reveal additional finds.<br>
				<br>
				<b>Find documentation</b> - Label all finds immediately after extraction. Record coordinates, depth and conditions. Submit to research for analysis and points. Some finds are extremely valuable to traders.<br>
				<br>
				<b>Analysis equipment</b> - Artifact Analyser (studies emissions of anomalous materials), Geosample Scanner (rock composition and dating), Radiocarbon Spectrometer (age of organic materials).<br>
				<br>

				<h1><a name="Emergency">Emergency procedures</a></h1>
				<b>If something goes wrong:</b> Activate GPS immediately. Call for backup if dealing with a dangerous anomaly. Evacuate the area if an artifact shows signs of instability. Report incidents to the research department. Seal dangerous sites until proper containment is available.<br>
				<br>
				<b>Equipment failure:</b> Suspension field failure - evacuate immediately; may cause collapse. Scanner malfunction - recalibrate or replace before continuing. Communication loss - return to base; don't work alone.<br>
				<br>

				<h1><a name="Advanced">Advanced techniques</a></h1>
				<b>Multi-find sites</b> - Scan large areas thoroughly for multiple anomalies. Excavate systematically from easiest to hardest. Some sites contain artifact clusters; major sites may have central high-value pieces.<br>
				<br>
				<b>Anomaly prediction</b> - Learn to recognize geological patterns. Certain rock formations favor specific find types. Experience helps predict difficulty and value. Weather and atmospheric conditions can affect scans.<br>
				<br>
				Xenoarchaeology is both science and art. The depth analysis scanner is your window into the past, but proper technique, careful mathematics and safety awareness are what turn ancient secrets into valuable discoveries. Take your time, stay safe, and happy digging!<br>
				<br>
				<a href="#Contents">Contents</a>

				</body>
				</html>
			"}

/obj/item/book/manual/suspension
	name = "Suspension Setup"
	icon_state = "excavation"
	author = "Professor Euclidenies Wisponellus, Curator of Iskhod's Museum of Ancients"
	title = "Suspension Setup"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Prep">Knowing your tool</a></li>
					<li><a href="#Setup">Setting up your generator</a></li>
					<li><a href="#Settings">Field types and material correspondence</a></li>
					<li><a href="#Advanced">Additional field types</a></li>
					<li><a href="#Operation">Field operation</a></li>
					<li><a href="#Effects">Field effects on different targets</a></li>
					<li><a href="#End">Critical safety notes</a></li>
				</ol>
				<br>

				<h1><a name="Prep">Knowing your tool</a></h1>
				The suspension field generator is quite the bulky tool. Hated or loved by many, it's critical for doing xenoarch correctly. It creates a protective
				energy field that prevents artifacts from collapsing during final excavation. Xenoarch tends to be divided into normal finds (which need this field)
				and anomalies, which can be far more dangerous and don't need a suspension field - so they won't be covered in this guide.

				The generator produces a net-like field that holds things in place. We use it to keep our finds from collapsing while we finish digging them out.
				It can be wrenched into place, is powered by a large cell (have one prepped at the start of the shift), is locked until you swipe your ID to unlock it,
				and has a lot of settings when unlocked - we'll cover those below. It's a complicated piece with a lot of value. In my workplace we only have three of them.
				If yours is like mine, don't lose them to the wildlife. Normally we keep two below ground near anomaly research's mine entrance and one up top by expedition prep.<br>
				<ul>
					<li>Heavy and bulky.</li>
					<li>Requires a wrench to get its legs into place.</li>
					<li>Must be facing the right direction (toward the dig).</li>
					<li>Has to be unlocked with your ID to access settings.</li>
					<li>Requires a large cell. Make sure you have one in.</li>
					<li>Valuable piece of equipment. Don't lose it!</li>
				</ul><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Setup">Setting up your generator</a></h1>
				So you've dragged that bulky generator all the way out to your digsite. Congrats, it's heavy. Now get it against the dig. Make sure you have space for
				both the suspension field and yourself - you'll have to dig a little more once it's on. Face it toward the dig. Once in place, wrench its legs down to brace it.
				Swipe your ID to unlock it if you haven't already. Check your depth scanner for which setting to use; the table below tells you which field matches which material.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Settings">Field types and material correspondence</a></h1>
				The scanner identifies the material type of your find. You must match it to the correct suspension field setting. Wrong field type can destroy finds - double-check your scanner reading.<br>
				<ul>
					<li><b>Carbon</b> (scanner reading) → <b>Diffracted Carbon Dioxide Laser</b>. For organic materials: fossils, plant remains, humanoid remains, xeno remains, gas masks, trace organic cells.</li>
					<li><b>Iron</b> → <b>Iron Wafer Conduction Field</b>. For metallic objects: weapons (guns, lasers, katanas, claymores), metal rods, metallic composites.</li>
					<li><b>Mercury</b> → <b>Mercury Dispersion Wave</b>. For unknown or exotic materials, metallic derivatives.</li>
					<li><b>Potassium</b> → <b>Potassium Refrigerant Cloud</b>. For crystalline or energy objects: cult robes, stock parts, long exposure particles.</li>
					<li><b>Nitrogen</b> → <b>Nitrogen Tracer Field</b>. For crystalline structures: soul stones, crystal shards, crystalline structures.</li>
					<li><b>Plasma</b> → <b>Plasma Saturated Field</b>. For high-energy or dangerous artifacts; the default fallback when in doubt.</li>
				</ul>
				Don't mix the metals up - derivative takes Mercury, composite takes Iron. If you get "Unknown" on the scanner, something may be wrong; make a note for the right people.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Advanced">Additional field types</a></h1>
				Calcium Binary Deoxidiser and Chlorine Diffusion Emissions exist for specialized applications in other fields; for xenoarch you'll rarely need them. The six above are the ones to learn.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Operation">Field operation</a></h1>
				<ol>
					<li>Position the generator facing your dig site.</li>
					<li>Wrench it into place for stability (must be anchored before activation).</li>
					<li>Swipe your ID to unlock the console.</li>
					<li>Select the correct field type based on the scanner's material reading.</li>
					<li>Activate the field only when you're ready for the final excavation - not while digging to the bubble.</li>
					<li>Monitor power levels; fields consume energy continuously.</li>
					<li>Deactivate immediately after extraction to save power.</li>
				</ol><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Effects">Field effects on different targets</a></h1>
				The carbon field immobilizes organic creatures and humans. The iron field affects silicon-based lifeforms (such as robots). All fields suspend and protect items during excavation - but clear the area before activation; the field affects everything in front of the generator.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="End">Critical safety notes</a></h1>
				<b>Never activate the field while digging to the bubble</b> - only for the final extraction. <b>The field must be active during bubble excavation</b> - artifacts will crumble without protection. Wrong field type can destroy finds. Ensure adequate power - field failure during extraction destroys the find. Clear the area before activation.<br>
				<br>
				After setting up and getting your settings ready, turn it on and finish your digging. Turn it off afterwards. Please be careful with the equipment - it's bulky and annoying to haul around, but there are only so many of them and they're needed for normal finds. Eventually you'll get the settings down; it's a memorization thing.<br>
				<a href="#Contents">Contents</a>

				</body>
				</html>
			"}

/obj/item/book/manual/mass_spectrometry
	name = "High Power Mass Spectrometry: A Comprehensive Guide"
	icon_state = "analysis"
	author = "Winton Rice, Chief Mass Spectrometry Technician at the Institute of Applied Sciences on Arcadia"
	title = "High powered mass spectrometry, a comprehensive guide"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Terms">A note on terms</a></li>
					<li><a href="#Analysis">Analysis progression</a></li>
					<li><a href="#Heat">Heat management</a></li>
					<li><a href="#Radiation">Ambient radiation</a></li>
				</ol>

				<br>
				<h1><a name="Terms">A note on terms</a></h1>
				<ul>
					<li><b>Mass spectrometry</b> - MS is the procedure used used to measure and quantify the components of matter. The most prized tool in the field of
						'Materials analysis.'</li>
					<li><b>Radiometric dating</b> - MS applied using the right carrier reagents can be used to accurately determine the age of a sample.</li>
					<li><b>Dissonance ratio</b> - This is a pseudoarbitrary value indicating the overall presence of a particular element in a greater composite.
						It takes into account volume, density, molecular excitation and isotope spread.</li>
					<li><b>Vacuum seal integrity</b> - A reference to how close an airtight seal is to failure.</li>
				</ul><br>
				<a href="#Contents">Contents</a>

				<h1><a name="Analysis">Analysis progression</a></h1>
				Modern mass spectrometry requires constant attention from the diligent researcher in order to be successful. There are many different elements to juggle,
					and later chapters will delve into them. For the spectrometry assistant, the first thing you need to know is that the scanner wavelength is automatically
					calculated for you. Just tweak the settings and try to match it with the actual wavelength as closely as possible.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Seal">Seal integrity</a></h1>
				In order to maintain sterile and environmentally static procedures, a special chamber is set up inside the spectrometer. It's protected by a proprietary vacuum seal
					produced by top tier industrial science. It will only last for a certain number of scans before failing outright, but it can be resealed through use of nanite paste.
					Unfortunately, it's susceptible to malforming under heat stress so exposing it to higher temperatures will cause it's operation life to drop significantly.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Heat">Heat management</a></h1>
				The scanner relies on a gyro-rotational system that varies in speed and intensity. Over the course of an ordinary scan, the RPMs can change dramatically. Higher RPMs
					means greater heat generation, but is necessary for the ongoing continuation of the scan. To offset heat production, spectrometers have an inbuilt cooling system.
					Researchers can modify the flow rate of coolant to aid in dropping temperature as necessary, but are advised that frequent coolant replacements may be necessary
					depending on coolant purity. Water and substances such as cryoxadone are viable substitutes, but nowhere near as effective as pure coolant itself.<br>
				<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Radiation">Ambient radiation</a></h1>
				Researchers are warned that while operational, mass spectrometers emit period bursts of radiation and are thus advised to wear protective gear. In the event of
					radiation spikes, there is also a special shield that can be lowered to block emissions. Lowering this, however, will have the effect of blocking the scanner
					so use it sparingly.<br>
				<br>
				<a href="#Contents">Contents</a>

				</body>
				</html>
			"}

/obj/item/book/manual/anomaly_spectroscopy
	name = "Spectroscopy: Analysing the Anomalies of the Cosmos"
	icon_state = "anomaly"
	author = "Doctor Martin Boyle, Director Research at the Lower Hydrolian Sector Listening Array"
	title = "Spectroscopy: Analysing the Anomalies of the Cosmos"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				It's perhaps one of the most exciting times to be alive, with the recent breakthroughs in understanding and categorisation of things we may one day no longer call
				'anomalies,' but rather 'infrequent or rare occurrences of certain celestial weather or phenomena.' Perhaps a little more long winded, but no less eloquent all the
				same! Why, look at the strides we're making in piercing the walls of bluespace or our steadily improving ability to clarify and stabilise subspace emissions; it's
				certainly an exciting time to be alive. For the moment, the Hydrolian hasn't seen two spatial anomalies alike but the day will come and it is soon, I can feel it.
				</body>
			</html>"}

/obj/item/book/manual/materials_chemistry_analysis
	name = "Materials Analysis and the Chemical Implications"
	icon_state = "chemistry"
	author = "Jasper Pascal, Senior Lecturer in Materials Analysis at the University of Jol'Nar"
	title = "Materials Analysis and the Chemical Implications"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				In today's high tech research fields, leaps and bounds are being made every day. Whether it's great strides forward in our understanding of the physical universe
				or the operation of some fancy new piece of equipment, it seems like all the cool fields are producing new toys to play with, leaving doddery old fields such as
				materials analysis and chemistry relegated to the previous few centuries, when we were still learning the makeup and structure of the elements.<br>
				<br>
				Well, when you're out there building the next gryo-whatsitron or isotope mobility thingummy, remember how the field of archaeology experienced a massive new rebirth
				following the excavations at Paranol IV and consider how all of the scientific greats will come crawling back to basic paradigms of natural philosophy when they discover
				a new element that defies classification. I defy you to classify it without reviving this once great field!
			"}

/obj/item/book/manual/anomaly_testing
	name = "Anomalous Materials and Energies"
	icon_state = "triangulate"
	author = "Norman York, formerly of the Tyrolion Institute on Titan"
	title = "Anomalous Materials and Energies"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Anomalies">Foreword: Modern attitude towards anomalies</a></li>
					<li><a href="#Tri">Triangulating anomalous energy readings</a></li>
					<li><a href="#Synthetic">Harvesting and utilising anomalous energy signatures</a></li>
				</ol>
				<br>
				<h1><a name="Anomalies">Modern attitude towards anomalies</a></h1>
				It's only when confronted with things we don't know, that we may push back our knowledge of the world around us. Nowhere is this more obvious than the
				vast and inscrutable mysterious of the cosmos that scholars from such august institutions as the Elysian Institute of the Sciences present
				formulas and hypotheses for every few decades.<br>
				<br>
				Using our vast, telescopic array installations and deep space satellite networks, we are able to detect anomalous energy fields and formations in deep space,
				but are limited to those that are large enough to output energy that will stretch across light years worth of distance between stars.<br>
				<br>
				While some sectors (such as the Hydrolian Rift and Keppel's Run) are replete with inexplicable energetic activity and unique phenomena found nowhere else in
				the galaxy, the majority of space is dry, barren and cold - and if past experience has told us anything, it is that there are always more things we are
				unable to explain.<br>
				<br>
				Indeed, a great source of knowledge and technology has always been those who come before us, in the form of the multitudinous ancient alien precursors that
				have left scattered remnants of their great past all over settled (and unexplored) space.<br>
				<br>
				It is from xenoarchaeologists, high energy materials researchers, and technology reconstruction authorities that we are able to theorise on the gifts these
				species have left behind, and in some cases even reverse engineer or rebuild the technology in question. My colleague, Doctor Raymond Ward of the
				Tyrolian Institute on Titan, has made great breakthroughs in a related field through his pioneering development of universally reflective materials capable
				of harvesting and 'bottling' up virtually any energy emissions yet encountered by spacefaring civilisations.<br>
				<br>
				And yet, there are some amongst us who do not see the benefits of those who have come before us - indeed, some among them profess the opinion that there
				is no species that could possibly match humanity in it's achievements and knowledge, or simply that employing non-human technology is dangerous and unethical.
				Folly, say I. If it is their desire to throw onto the wayside the greatest achievements <i>in the history of the galaxy</i>, simply for preferment of the
				greatest achievements <i>in the history of mankind</i>, then they have no business in the establishment of science.<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Tri">Triangulating anomalous energy readings</a></h1>
				Strong energy emissions, when remaining constant from any one fixed location for millennia, can leave an 'imprint' or distinctive energy signature on other
				matter composites that are spatially fixed relative to the source.<br>
				<br>
				By taking samples of such 'fixed' matter, we can apply complex analytics such as the modified Fourier Transform Procedure to reverse engineer the path of the
				energy, and determine the approximate distance and direction that the energy source is, relative to the sample's point in space. Modern portable devices can do
				all this purely by taking readings of local radiation.<br>
				<br>
				A canny researcher can thusly analyse radiation at pre-chosen points strategically scattered around an area, and if there are any anomalous energy
				emissions in range of those points, combined the researcher can triangulate the source.<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Synthetic">Harvesting and utilising anomalous energy signatures</a></h1>
				As mentioned in the foreword, my colleague from the Tyrolian Institute on Saturn's moon of Titan, in the Sol System, Doctor Raymond Ward has made great strides
				in the area of harvesting and application of the energy emitted by anomalous phenomena from around the galaxy (although I profess I have not yet seen him
				venture further from his birthplace on Earth than the comfortable distance of the Sol Cis-Oort Satellite Sphere).<br>
				<br>
				By employing a patented semi-phased alloy with unique and fascinating bluespace interaction properties, Ward's contraption is able to 'harvest' energy, store
				it and redirect it later at will (with appropriate electronic mechanisms, of course). Although he professes to see or desire no commercial or material gain
				for the application and use of said energy once it is harvested, there are no doubt myriad ways we can come to benefit from such things beyond mere research,
				such as the reconstruction of torn cartilaginous tissue that a peculiar radiation from an amphibious species on Brachis IV was found to emit.<br>
				<a href="#Contents">Contents</a>

				</body>
				</html>
			"}

/obj/item/book/manual/stasis
	name = "Cellular Suspension, the New Cryogenics?"
	icon_state = "stasis"
	author = "Elvin Schmidt"
	title = "Cellular Suspension, the New Cryogenics?"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Foreword: A replacement for cryosleep?</a></li>
					<li><a href="#Development">The breakthrough</a></li>
					<li><a href="#Application">Applying this new principle</a></li>
				</ol>
				<br>
				<h1><a name="Foreword">Foreword: A replacement for cryosleep?</a></h1>
				The development of rudimentary cryofreezing in the 20th and 21st centuries was hailed as a crank science by some, but many early visionaries recognised the
				potential it had to change the way we approach so many fields, such as medicine, therapeutics, and space travel. It was breakthroughs in the field in the 22nd and
				later centuries that turned the procedure from science fiction to science fact, however. Since then, cryogenics has become a hallmark of modern science, and
				regarded as one of the great achievements of our era. As with all sciences however, they have their time and are superseded by newer technological miracles when
				it is over.<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Development">The breakthrough</a></h1>
				It was in examining the effects of decelerated, bluespace, high energy particles when transphased through bluespace that the effects where primarily noticed.
				Due to exigent properties of that dimension, transphasing those particles capable of existing in bluespace with high stability levels has the effect of bringing
				some of those effects into realspace. Examining the Hoffman emissions in particular, it was discovered that they exhibited a-entropic behaviour, and in what is
				now termed the 'Effete Hoffman Principle,' it was found that metastabilising the Hoffman radiation resulted in the effect being applied across other physical
				interactions, in particular forces and reactions.<br>
				<a href="#Contents">Contents</a>

				<h1><a name="Application">Applying this new principle</a></h1>
				When combined with an appropriate energy-effect replicate for cryogenics (slowing down biological activity, thus stabilising the organics), the effect is
				effectively identical to cryogenics, and while it consumes vastly more power and requires extremely complex equipment, it's (for all intents and purposes) superior
				to cryogenics, all that remains is to 'commercialise' the process by enabling cheaper development and mass production.<br>
				The Effete Hoffman Principle can be tweak-combined with other effects however, for different purposes. A division of PMC Research initially developed the application
				in prisons as a literal 'suspension field' where convicts are held immobile in the air, and the use quickly spread to numerous other areas.<br>
				<br>
				By examining the material resonance properties of certain strong waveforms when combined with Hoffman radiation, an effect was produced able to reverse energy
				transferral through matter, and to slow the effects of gravity. When combined with energy repulse technology, the triple effects compound themselves into a much
				stronger field, although all three components do slightly different things. High energy researchers assure me of the following key points:<br>
				<ul>
					<li>The energy repulsion factor provides a 'shell' capable of weak suspension.</li>
					<li>The Hoffman emissions nullify energy transferral and other kinetic activity, maintaining stability inside the field.</li>
					<li>The resonant waveform combines the effects of the above two points, and applies it magnified onto it's synced 'resonance' materials.</li>
				</ul>
				As an interesting aside, a carbon waveform was chosen for the field in prison suspension fields, due to it's resonance with organic matter.<br>
				<a href="#Contents">Contents</a>

				</body>
				</html>
			"}
