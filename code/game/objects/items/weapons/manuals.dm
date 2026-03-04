/*********************MANUALS (BOOKS)***********************/

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = TRUE   // FALSE - Normal book, TRUE - Should not be treated as normal book, unable to be copied, unable to be modified


/obj/item/book/manual/engineering_construction
	name = "Colony Repairs and Construction"
	icon_state = "bookEngineering"
	author = "Artificer's Guild"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Colony Repairs and Construction"

/obj/item/book/manual/engineering_construction/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl]Construction" frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/supermatter_engine
	name = "Supermatter Engine Operating Manual"
	icon_state = "bookParticleAccelerator"
	author = "Artificer's Guild"
	title = "Supermatter Engine Operating Manual"

/obj/item/book/manual/supermatter_engine/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Supermatter_Engine' frameborder="0"></iframe>
		</body>
		</html>
		"}

// Particle accelerator guidebook: same as supermatter book (content + icon)
/obj/item/book/manual/engineering_particle_accelerator
	name = "Supermatter Engine Operating Manual"
	icon_state = "bookParticleAccelerator"
	author = "Artificer's Guild"
	title = "Supermatter Engine Operating Manual"

/obj/item/book/manual/engineering_particle_accelerator/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Supermatter_Engine' frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/engineering_antimatter_engine
	name = "Antimatter Engine Operating Manual"
	icon_state = "bookParticleAccelerator"
	author = "Artificer's Guild"
	title = "Antimatter Engine Operating Manual"

/obj/item/book/manual/engineering_antimatter_engine/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Supermatter_Engine' frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/engineering_hacking
	name = "Hacking"
	icon_state = "bookHacking"
	author = "Artificer's Guild"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Hacking"

/obj/item/book/manual/engineering_hacking/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl]Guide_to_Hacking" frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manualshield_generator_guide
	name = "Artificers Guild Shield Operating Guide"
	icon_state = "book4"
	author = "Artificer's Guild"
	title = "Adv-Shield Generator Manual"

/obj/item/book/manualshield_generator_guide/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Operating Manual for Mk 1 Prototype Advanced Shield Generator.</h1>

				<h2>Chapters</h2>

				<ol>
                  	<li><a href="#Foreward">Foreward</a></li>
					<li><a href="#Preface">Preface</a></li>
					<li><a href="#Setup">Shield Setup & upgrades Ch.1</a></li>
					<li><a href="#Upgrades">Shield Setup & upgrades Ch.2</a></li>
					<li><a href="#Maintenance">Powering the Generator.</a></li>
				</ol>

				<h2><a name="Foreward">Foreward</h2><br>
					<h3>This document is offered in its full, unedited form having been found amongst the many unfiled documents within the Guilds primary offices. Though densely written and at times containing error, it is believed that in this form it shall serve more use than if pared back or otherwise modified from its writers original form. This document shall not be taken as overriding any procedure, instead supplementing knowledge and S.O.P regarding the Shield Generator. Any questions, concerns or similar regarding this document should be directed to the office of Grandmaster Tacitus O'conner - Chief Engineer <i>Zivka Tomic</i> </h3><br>


				<h2><a name="Preface">Preface</h2><br>

The Shield Generator Room is a new asset of the colony, put together by Aenethia Fletcher, consisting of a variety of equipment relying on the various colony factions in order to perform at it's best.<br><br>

In this document, you will find a comprehensive method on learning to use the Shield Generator room, it's do's and don'ts, and suggestions on what best to do with it in case of emergency -if it's needed.<br><br>

Regardless of faction personnel, or personal preferences, or social bounds, this equipment is designed to perform at it's best when the whole of the factions comes together in their effort to defend our Home.<br><br>

While the bubble shield is an asset of immense defensive potential, the best defense remains a good offense, and a good offense relies on our abilities to keep our fighters alive and weaponized.<br><br>

At best, this equipment is to be treated as *a* -not the- non-fighter/non-medical option, for both Engineers and Scientists trying to participate during an emergency ;<br><br>

In fact, not all threats need the bubble shield, and it's activation, and use of it's various settings, is a decision that should rely solely on the /concerned/ command staff, starting with the Blackshield Commander and Warrant Officer.<br><br>

Extraordinary events involving -but not limited to- meteor rain, bluespace, radiation storms, solar flares, or even orbital bombardment, might require a more educated approach from either Artificer or Vesalius-Andra Science personel.<br><br>

Typically, while the Shield Generator relies on a massive engineering effort to power it,
it's up to Vesalius-Andra Science personel to be best educated on which settings might be more advisable during a given situation,
the final decision must swiftly be made however, and is of course, always up to the Blackshield Commander and Warrant Officer.<br><br>

The truth is, most situations won't be needing the shield at all ; it's important to correctly determine if it's even necessary to use it.<br>
Namely, amongst a variety of threats, it certainly won't stop Excelsior Infiltrators, or Giant Spider burrowing, or Hivemind Infestations.<br><br>

As always, in the end, it's all up to the the all-important cooperation between medical teams from Vesalius-Andra and the Church, remaining the<br> strong arm of the colony that's keeping up with our Rangers/Blackshields and Prospectors.<br><br>


				<h2><a name="Setup">Shield Setup & upgrades Ch.1</h2><br>
Upon shift-start, or upon re-assembly, the shield generator must be wrenched down.<br>
Moving it is possible, but doing so, even one single tile, will permanently remove it's ability to receive charge, regardless of if it's being wrenched down over a powered wire node or not.<br>
As a result of this technical limitation, special attention must be put into correctly building it over a powered wire node, then immediately wrenching it in place.<br><br>

However, if you've respected that very important step, then charged the generator, it is possible to then wrench it up and move the generator around.<br><br>

NOTE: This action is strictly forbidden with the one generator from the Shield generator room.<br>
Instead, if you need a generator to use elsewhere, seek the components and boards for a new one at Vesalius-Andra Science.<br><br>

In case of emergency such as a code <b>RED</b>, at a Blackshield Commander or Warrant Officer's decision -or their obligatory joined vote- the furnished shield generator may be moved/reassembled somewhere else within the colony infrastructure,
assuming there is an effort from active Artificers to keep up with the new engineering effort to power the generator in a new location within the colony.<br>
This change must be temporary, and for the express purpose of defending said colony infrastructure.<br><br>

If that happens, the Low Council may choose to inform the High Council upon exiting the emergency situation -or during it- , and the shield generator must be returned without delay to it's original location with it's attributed equipment - ready for use as normal and intended.<br><br>
A situation where a threat was problematic enough to heavily rely on the shield generator should raise valid concerns that the High Council <br><br>


With that said ; the generator offers a variety of tactical decisions if used in the field.<br>
Once charged, you can activate it elsewhere at will, as it will keep it's given charge.<br>
This allows to then redeploy a bubble shield at any point in time, anywhere, at the cost of losing the ability to recharge it, once it's been moved even by one tile.<br>
Once activated, the bubble will not move regardless of the generator's position.<br>
It's possible to move the generator outside of the bubble without consequences.<br><br>

Turning the generator off takes 60 seconds. The bubble remains active during that time.<br>
Using the emergency shutdown is an option, but will drain the generator.<br><br>

Once it's de-activated, the generator must reboot for an additional 60 seconds.<br><br>

The generator is assembled from :
<li>-The shield generator board
<li>-A console screen
<li>-A capacitor
<li>-A micro-laser
<li>-A SMES coil<br><br>

Upgrading the capacitor and laser is an important task that relies on the guild.<br><br>

<li>T3 parts obtained at Vesalius-Andra -a super capacitor and a ultra-powered laser- should be the bare minimum.<br><br>

<li>T4, known as Greyson parts, are obtained trough salvage at the Greyson base -ask prospectors-, or at the space junk field, or at Vesalius-Andra, if they are performing well on research and are given some platinum.<br><br>

<li>T5 parts, known as forged (a forged capacitor and a forged laser) are the best options, obtained trough Artificer craft, but they need T3 parts from Vesalius-Andra for crafting, power tools, and some materials.<br><br>

Upgrading the machine parts tremendously influences the performance of the shield, and should be a top priority in case of a situation where the shield is used.<br>
While very modest, T3 remains an immense step over the T1 furnished.<br><br>


The type of the SMES coil is equally important, and it's choice comes from a lot of careful consideration.<br>
Those coils are furnished with the equipment however, so you won't have to worry about obtaining them, instead only replacing the one in the generator on shift start.<br><br>

There are 3 types of SMES coils, known as the Basic, the Transmission and the Capacity.<br><br>

Each coil allows for an increased amount of energy stored.<br><br>

It's easy to assume the transmission coil would let the shield refill it's power faster, but that is a misconception ;<br>
The type of the coil does not affect the speed at which the generator can receive charge.<br><br>

To put it simply,<br>
<li>-The bubble shield's integrity relies directly on how full is the generator.
<li>-The Transmission coil has the lowest maximum charge.
<li>-The current setup of the generator room + two upgraded SMES units was designed to favor a coil with the lowest maximum.<br><br>

This means that like using a smaller glass, it's easier and faster to refill it to 100%.<br>
This allows to keep the bubble's integrity as high as possible (100%) by having it constantly refilling from the 2 shield SMES units.<br><br>

When nearing 10% integrity, the bubble will start having giant gaps and holes.<br>
For this reason, keeping the generator at a low maximum is the design decision that was originally put together, with a transmission coil the maximum is 500MJ.<br><br>

This is where the two SMES units come in.<br>
A SMES can hold 5 different coils.<br>
Each of them are intended to be assembled with 2 capacitance and 3 transmission coils.<br><br>

More SMES units may be put together if the engineering effort and power production is well above base expectations.<br>
This allows to store enormous amounts of power right next to the generator, able to keep the bubble extremely resistant trough constantly dumping power into it - no power will be wasted if the generator is already full, so you can (and should) keep the SMES's output turned on and maximized at all times.<br><br>

The total amount of punition the bubble can take remains quite considerable even with 500MJ.<br>
For future reference, the 100% integrity given from using a transmission coil already permits to block several of the the highest toxins assemblies possible with relative ease - and it's extremely rapid to recharge with the 2 SMES units.<br>
Testing with 2 or 3 of the most powerful bombs Vesalius-Andra can make, barely damaged the integrity to 85% - which was instantly refilled trough the performance of the built-in SMES's.<br><br>


The generator should be constructed with a TRANSMISSION coil, but it can be given a much higher maximum stored power if you use a capacitance coil.<br>
It's total holding power becomes absurdly high however, so good luck going even above 5% integrity - effectively rendering the generator useless.<br><br>

A different setup isn't out of the question, from competent engineering personnel,
assuming that care is still being put into a bubble shield that can remain at 100% integrity trough rigorous assault.<br><br>



				<h2><a name="Upgrades">Shield Setup & upgrades Ch.2</h2><br>
Once the generator is upgraded, fitted with a transmission coil, and wrenched in it's spot, max out the 2 SMES's output and leave that on.<br>
The SMES's input however is up to your decision on how much you wish to drain from the colony grid.<br><br>


Set the shield's radius to 85, to properly cover the whole colony wall.<br>
The bubble shield will correctly cover not only the wall, but a full circle around the surface facility, projecting even trough the rock and tunnels preset on both sides of the wall.<br>
You also have to turn on the generator's input, which should be set to limitless by typing in 0.<br>
Doing so will leave it to drain from the two SMES units without limits, until it's full.<br>
Once the generator is full, it's input should be left unlimited, as no power will be wasted, instead simply keeping stored with the SMES's with nowhere to go.<br><br>

To give you an idea of how much power a SMES can hold, know that the guild's engine SMES is built with one single basic coil, wich then distributes into each substations - who also are fitted with one single basic coil.<br>
The performance of a handful of SMES units with a single basic coil is more than enough to handle the colony grid ;<br><br>

A SMES unit with even one single capacitance coil will be able to contain a tremendous amount of power, but charge/discharge slowly.<br>
A Transmission coil will hold much less, but paired with a capacitance, it easily reaches the potency of several colony grids - for several shifts.<br><br>

From there, having 2 SMES units with not 1 capacitance + 1 transmission, but 2 capacitance + 3 transmission, holds the potency of a truly massive power hold, with the ability to dump it out extremely easily back out to the generator.<br>
With this in mind, consider that the Shield's equipment is furnished with 2 SMES units with a total of 4 capacitance and 6 transmission ;
it's still possible to fill them up with ease if you follow the detailed list of power sources accounted within the end of this text.<br><br>

This is designed to easily withstand even the most brutal attacks from whatever is out there, including planetary bombardment.<br>
The only condition is to really /really/ store a lot of power in advance, which means a cooperative effort from the various factions, in particular the Guild, the VA Biomechanics, Frontier Logistics, and the Church of the Absolute.<br><br>

Hypothetically, in case of an attack with nuclear warheads, the generator should instead be fitted with a capacitance coil, wich would then require a gargantuan amount of power in order to reach acceptable levels of integrity.<br>
For obvious reasons, this has not been tested, neither really discussed given the already extremely high performance of the current design.<br><br>

The only live testing has been done with a handful of Toxins assemblies, with more than satisfying results.<br>
Still, trying more isn't out of the question, in the future.<br><br>


It's not out of the question to connect the shield's reserves to the colony by simply hotwiring their output back to the grid.<br>
However, doing so is an extremely special, temporary decision that should only be a temporary fix, first decided by the Chief Engineer, if without one, Artificers Engineers,<br><br>
at the all-important condition that this is during an emergency, were the grid, the substations, and engine SMES are all completely drained or destroyed, with no means to use the solars / hydroelectric dam again during that emergency.<br>
Having the shield generator backed, charged, with available reserves from it's assigned SMES units, should remain the main concern at all times - it should never, under any circumstances, be allowed to fully drain itself into the colony grid for whatever reason.<br><br>


Indeed, hotwiring the generator to the colony grid is an option, but that has little to no real application and is in fact, a bad idea.<br>
What really matters is to have the upgraded SMES's able to store large amounts of power and dump it directly into the shield generator, not the grid.<br>
Going against this design decision is an option but really not recommended.<br><br>

For the same reason, maxxing the SMES's input and draining as much as possible from the colony grid is a terrible idea that can and will earn you legal charges namely sabotage, terrorism.<br>
The SoP article about this is quite explicit, you are warned on what not to do. Take this seriously, this equipment is expensive.<br>
Taking any equipment such as the generator, the wrench, the furnished coils, the RCON console, or anything from the SMES units, out of the Generator room, even for a brief moment, for no valid reason, also is grounds for grand theft, sabotage, terrorism, etc.<br><br>

				<h2><a name="Maintenance">Powering the Generator</h2>
There are a variety of ways to power the colony, and with it, the shield.<br>
It's worth going over that topic in detail, since it could make a difference in case of emergency.<br><br>
Engineering alone will have their solars, the Vesalius-Andra solars, then the hydroelectric dam, their 8 diesel generators, a selection of various generators of different kinds, the turbine in atmospherics, and whatever else engine they can put together using a TEG and circulators, maybe even a supermatter in rare occasions.<br><br>
Vesalius-Andra can build a wide variety of generators depending on nearly any available resources ; mining can offer large amounts of plasma for PACMAN's or fuel tanks for more Diesels ;<br>
Built in numbers, each individual CAMPMAN while modest, will be running on planks of wood and prove quite efficient. Harvests from the surface trees or the xenoflora lab for mass production, or order at cargo.<br><br>
On T3, Diesels, PACMANS, CAMPMANS and the likes of them, will have their performance significantly increased, without burning their fuel any faster.<br>
Optimally, with a bunch of platinum and wood, Vesalius-Andra can put together a group of CAMPMAN's running on T4 Greyson parts - and upgrade the guild's diesels by the same occasion.<br><br>
The church has an extremely powerful biogenerator, running on their big golden canisters of biomass, but only if they've been producing them from the junk beacon, which takes some time and effort.<br><br>
Diesels, PACMANS, CAMPMANS and the rest of them are assembled from a board printer at Vesalius-Andra, one matter bin, one micro-laser, and one capacitor.<br>
Their power output relies on the tier of the capacitor and laser, but the matter bin only affects the amount of fuel placed in before needing to be refilled - which remains more important than one might think at first, if you don't want to be constantly babysitting a room full of generators during an emergency situation.<br><br>
On top of the solars and the hydroelectric dam, one of the most reliable, easy and rapid way to get a lot of power quickly on shift start, with no time-sinking preparation or special effort nor costly resources, is to upgrade the 8 diesels in the guild with T3 and to turn them on.
The guild has a lot of fuel tanks in storage, and more can be ordered for rather cheap at cargo - this should be the default strategy if there is an emergency on shift start with too little time to make anything fancy.<br><br>				</body>
			</html>
		"}

/obj/item/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state = "bookEngineering2"
	author = "Artificer's Guild"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"

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
				<h1>Singularity Safety in Special Circumstances</h1>

				<h2>Power outage</h2>

				A power problem has made the entire colony lose power? Could be colony-wide wiring problems or syndicate power sinks. In any case follow these steps:

				<ol>
					<li><b><font color='red'>PANIC!</font></b></li>
					<li>Get your ass over to the Guild! <b>QUICKLY!!!</b></li>
					<li>Get to the <b>Area Power Controller</b> which controls the power to the emitters.</li>
					<li>Swipe it with your <b>ID card</b> - if it doesn't unlock, continue with step 15.</li>
					<li>Open the console and disengage the cover lock.</li>
					<li>Pry open the APC with a <b>Crowbar.</b></li>
					<li>Take out the empty <b>power cell.</b></li>
					<li>Put in the new, <b>full power cell</b> - if you don't have one, continue with step 15.</li>
					<li>Quickly put on a <b>Radiation suit.</b></li>
					<li>Check if the <b>singularity field generators</b> withstood the down-time - if they didn't, continue with step 15.</li>
					<li>Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the Guild APC is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the APC to the powernet. If it wasn't a powersink which caused it, then skip to step 14.</li>
					<li>Grab your crowbar and pry away the tile closest to the APC.</li>
					<li>Use the wirecutters to cut the wire which is connecting the grid to the terminal. </li>
					<li>Go to the bar and tell the guys how you saved them all. Stop reading this guide here.</li>
					<li><b>GET THE FUCK OUT OF THERE!!!</b></li>
				</ol>

				<h2>Shields get damaged</h2>

				<ol>
					<li><b>GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!</b></li>
				</ol>
			</body>
			</html>
			"}

/obj/item/book/manual/medical_cloning
	name = "Cloning Techniques of the 26th Century"
	icon_state = "bookCloning"
	author = "Vesalius-Andra Medical"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning Techniques of the 26th Century"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<H1>How to Clone People</H1>
				So there are 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven't the foggiest idea of what to do? Not to worry!
				This guide is intended to teach you how to clone people and how to do it right, in a simple, step-by-step process! If at any point of the guide you have a mental meltdown,
				genetics probably isn't for you and you should get a job-change as soon as possible before you're sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structural Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Cryo and use the clean SE injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H3>Step 1: Acquire body</H3>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H3>Step 2: Strip body</H3>
				The cloning machine does not like abiotic items. What this means is you can't clone anyone if they're wearing clothes or holding things, so take all of it off. If it's just one person, it's courteous to put their possessions in the closet.
				If you have about seven people awaiting cloning, just leave the piles where they are, but don't mix them around and for God's sake don't let people in to steal them.

				<a name='3'><h3>Step 3: Put body in cloning machine</h3>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><h3>Step 4: Scan body</h3>
				Go onto the computer and scan the body by pressing 'Scan - &lt;Subject Name Here&gt;.' If you're successful, they will be added to the records (note that this can be done at any time, even with living people,
				so that they can be cloned without a body in the event that they are lying dead on port solars and didn't turn on their suit sensors)!
				If not, and it says "Error: Mental interface failure.", then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body,
				click 'Refresh' and try scanning them again. If there's no success, threaten them with gibbing.
				Still no success? Skip over to Step 7 and don't continue after it, as you have an unresponsive body and it cannot be cloned.
				If you got "Error: Unable to locate valid genetic data.", you are trying to clone a monkey - start over.

				<a name='5'><h3>Step 5: Clone body</h3>
				Now that the body has a record, click 'View Records,' click the subject's name, and then click 'Clone' to start the cloning process. Congratulations! You're halfway there.
				Remember not to 'Eject' the cloning pod as this will kill the developing clone and you'll have to start the process again.

				<a name='6'><h3>Step 6: Get clean SEs for body</h3>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process!
				For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they're done. If you're a competent Geneticist, you will already have one ready on your working computer.
				If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console.
				Go into View/Edit/Transfer Buffer, find an open slot and click "SE" to save it. Then click 'Injector' to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><h3>Step 7: Put body in morgue</h3>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there.
				To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed "CHEF MEAT" in order to avoid confusion.

				<a name='8'><h3>Step 8: Await cloned body</h3>
				Now go back to the lab and wait for your patient to be cloned. It won't be long now, I promise.

				<a name='9'><h3>Step 9: Cryo and clean SE injector on person</h3>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab them and stick them in cryo. Cronexidone and Cryoxadone help rebuild their genetic material. Then grab your clean SE injector and jab it in them. Once you've injected them,
				they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><h3>Step 10: Give person clothes back</h3>
				Obviously the person will be naked after they have been cloned. Provided you weren't an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient.
				No matter how cruel you are, it's simply against protocol to force your patients to walk outside naked.

				<a name='11'><h3>Step 11: Send person on their way</h3>
				Give the patient one last check-over - make sure they don't still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio.
				Once you're done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you've gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that contractor had his way with you for cloning his target.

				</body>
				</html>
				"}


/obj/item/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state = "borgbook"
	author = "Randall Varn, Einstein Engines Senior Mechanic"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<span style='font-size: 12px;'><b>Weyland-Yutani - Building Better Worlds</b></span>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul class="a">
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment: Possible</b>
				<li><b>Airtank volume:</b> 500 liters</li>
				<li><b>Devices:</b>
					<ul class="a">
					<li>Hydraulic clamp</li>
					<li>High-speed drill</li>
					</ul>
				</li>
				<li><b>Propulsion device:</b> Powercell-powered electro-hydraulic system</li>
				<li><b>Powercell capacity:</b> Varies</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
					<li>Connect all exosuit parts to the chassis frame.</li>
					<li>Connect all hydraulic fittings and tighten them up with a wrench.</li>
					<li>Adjust the servohydraulics with a screwdriver.</li>
					<li>Wire the chassis (Cable is not included).</li>
					<li>Use the wirecutters to remove the excess cable if needed.</li>
					<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the mainboard with a screwdriver.</li>
					<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the peripherals control module with a screwdriver.</li>
					<li>Install the internal armor plating (Not included due to corporate regulations. Can be made using 5 metal sheets).</li>
					<li>Secure the internal armor plating with a wrench.</li>
					<li>Weld the internal armor plating to the chassis.</li>
					<li>Install the external reinforced armor plating (Not included due to corporate regulations. Can be made using 5 reinforced metal sheets).</li>
					<li>Secure the external reinforced armor plating with a wrench.</li>
					<li>Weld the external reinforced armor plating to the chassis.</li>
				</ol>

				<h2>Additional Information:</h2>
				<ul>
					<li>The firefighting variation is made in a similar fashion.</li>
					<li>A firesuit must be connected to the firefighter chassis for heat shielding.</li>
					<li>Internal armor is plasteel for additional strength.</li>
					<li>External armor must be installed in 2 parts, totalling 10 sheets.</li>
					<li>Completed mech is more resilient against fire, and is a bit more durable overall.</li>
					<li>The Company is determined to ensure the safety of its <s>investments</s> employees.</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Vesalius-Andra Research"
	title = "Research and Development 101"

/obj/item/book/manual/research_and_development/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Research_and_Development' frameborder="0"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/robotics_cyborgs
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "Vesalius-Andra Robotics"
	title = "Cyborgs for Dummies"

/obj/item/book/manual/robotics_cyborgs/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Robotics' frameborder="0"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/robotics_catalogue
	name = "Vesalius-Andra Cyborg Catalogue 2652"
	icon_state = "borgbook"
	author = "Vesalius-Andra Robotics"
	title = "Vesalius-Andra Cyborg Catalogue 2652"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Cyborg Product Catalogue</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Foreword">Foreword</a></li>
					<li><a href="#Generic">Generic Models</a></li>
					<li><a href="#Zeng-Hu">Zeng-Hu models</a></li>
					<li><a href="#Bishop">Bishop Models</a></li>
					<li><a href="#Xion">Xion Models</a></li>
					<li><a href="#Miss M">Miss M. models</a></li>
					<li><a href="#TallBorgs">MekaNika Mekanoid models</a></li>
					<li><a href="#K4t">Mekanika K4t Models</a></li>
					<li><a href="#Pirate">Iron Lords 'Customized' Models</a></li>
				</ol>


				<h2><a name="Foreward">Authors Note</h2>
				<p>"Hello! Thank you for picking this handy little guide up, dear reader. this piece has been a pet project
				that i've worked on for quite some time, I'm very happy to	finally be able to place it in the hands,
				claws, paws and grippers of my fellow Mechanists, Roboticists, Augmenticists- and any one else who
				may be curious about the range of bots available from the Vesalius-Andra Robotics Division. Piece of this
				book have been copied from the sadly obsolete but none the less interesting 'Vesalius-Andra Mechanists Handbook',
				as well as 'SFPD - Identifying Illicit Machines, A comprehensive guide.' as well as a variety of other,
				smaller manuals, handbooks and product-catalogues. While I have done my best to ensure the information
				contained within is accurate much of it may be or become incorrect or outdated. A special thanks to my
				Dear Friend, Patience Constance of the Iron Lords for her help filling in the blanks regarding
				their line of customized MekaNIKA bots - provided to Nadehzda by our wonderful friends with the
				Xanoranth Syndicate." - Dr. Cinead, Vesalius-Andra Robotics Division.

				<h2><a name="Generic"> Chassis that Respect the Users Freedom</h2>
				<center><img src="https://sojourn13.space/w/images/5/58/Generic.png"></img></center>
				<p>Far from being single-origin, these 'standard' frames encompass a wide variety of open source,
				unclaimed or otherwise "freely" available frames. These frames come from sources ranging to hobbyist
				collectives to long-since-deprecated trade claims abandoned to the public domain by their
				corporate owners.

				<h2><a name="Zeng-Hu"> 'Teknotik' - Style and Substance</h2>
				<center><img src="https://sojourn13.space/w/images/e/ee/Zenhgu.png"></img></center>
				<p>Another truly old but no-less respected line from the Giant of Medical Miracles and Horrors both. Where some lines
				fixated on pure pragmatism Zeng-Hured no expense on the appearance of these bots. From Sleek humanoid frames to
				high-speed flying drones these bots were top of the shelf for decades before finally being displaced by Greyson's
				own. In the modern era, a flying drone or a cyborg that fits in a roughly human-shaped package are old news easily
				reproducable(and more modularly at that.), still; these designs are a personal favorite of this author as a reminder
				that even heights of technology once viewed as science-fiction may one day be looked back on as tragically quaint.

				<h2><a name="Bishop"> 'Droid' - Timeless Classics</h2>
				<center><img src="https://sojourn13.space/w/images/f/f0/Bishop.png"></img></center>
				<p>A positively venerable line, Bishop long stood as giants of the cybernetics and robotics field,	shoulder to
				shoulder with the likes of Zeng-Hu and early Greyson Positronics. While their interest in the field of robotics
				waned during the halcyon days of Greyson Positronics these frames remains utterly ubiquitous classics.

				<h2><a name="Xion"> 'Eclectic' - Timeless Classics</h2>
				<center><img src="https://sojourn13.space/w/images/6/63/Xion.png"></img></center>
				<p>Not one cohesive line, but instead a small number of designs from little known manufacturing company 'Xion'. Once a
				pioneer in the field of automated recursive repair solutions, Xion has never once allowed the galaxy to forget that
				they designed the first ever repair drone - A claim supported by little more than a resemblance in their more modern
				designs. With a preference for such nimble, spidery bots their abject failure to dislodge Zeng-Hu from their position
				as the governorcreators of automated flying machines should not go without saying - Though some will claim preference
				for 'eyebot' style drones these bots were sadly an economic failure in their time.

				<h2><a name="Miss M"> Manmade horrors never looked so friendly</h2>
				<center><img src="https://sojourn13.space/w/images/0/0f/Miss_M.png"></img></center>
				<p>A now dated line from the long-since defunct 'Missus Machining', the Miss M. line of cyborgs was marketed both
				towards wealthy individuals with an eye for retro aesthetics and poorer corps without the ability to
				procure higher end 'Customer Friendly' units. It should not go unsaid that despite the companies
				attempts to put a friendly face on Cyborgs, they were ultimately forced	to shutter permanently following a slew
				of accusations that the brains in their units were unethically sourced.


				<h2><a name="Tallborgs">'tallbot' - Towering Metal Friends</h2>
				<center><img src="https://sojourn13.space/w/images/8/86/Mekanika.png"></img></center>
				<p>Affectionately known as 'TallBorgs', these units while wildly varying in both module and appearance
				have proven to be quite popular both for their utility and shockingly low price, owing to their
				pedigree as products of MekaNIKA(One of the few non-megacorp bulk producers of cyborg frames and,
				a corp with surprisingly 'customer-first' product policy.).

				<h2><a name="MekaNIKA ">'K4T' -Silicon Gentle Giants</h2>
				<center><img src="https://sojourn13.space/w/images/f/f5/K4T.png"></img></center>
				<p>Amid concerns that their 'tallbot' Mekanoids "appeared too flimsy" come the K4T line. Where Tallbots
				are svelte and graceful, K4Tbots are notably broader in appearance - It bears noting that despite
				appearances, these walking tanks do not perform notably better or worse than their slimmer "siblings".
				Instead, theirs is a design meant to impress and awe far more than it is to serve as the walking-exosuit
				they nominally resemble. After all, a well programmed borg can already serve as more than a match for
				an equivilent human.

				<h2><a name="Pirate">'Homebrew' - From our friends among the Stars</h2>
				<center><img src="https://sojourn13.space/w/images/b/bf/SYNDIE.png"></img></center>
				<p>"I must admit, I was initially not sure /how/ to describe these units when word came to me that a deal had
				been made with the Iron Lords- brokered by the Xanoranth Syndicate, resulting in our obtaining quite a few
				of these uniquely modified frames. Like most frames, these are style over substance meant to mesh neatly with
				the 'modules' the user has available. This comes with the caveat that in addition to the frame-designs, Xanoranth
				have provided a number of fully operational units who have been run through Vesalius-Andras rigorous process of integration."
				</body>
			</html>
		"}




/obj/item/book/manual/security_space_law
	name = "Space Law and Corporate Regulations"
	desc = "A set of corporate guidelines and space law for keeping law and order on settlements."
	icon_state = "bookSpaceLaw"
	author = "Corporate Liaison"
	title = "Space Law and Corporate Regulations"

/obj/item/book/manual/security_space_law/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl]Laws" frameborder="0"></iframe>
		</body>
		</html>
		"}



/obj/item/book/manual/medical_diagnostics_manual
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "medicalbook"
	author = "Vesalius-Andra Medical"
	title = "Medical Diagnostics Manual"

/obj/item/book/manual/medical_diagnostics_manual/New()
	..()
	dat = {"<html>
				<head>
				<style>
				html, body { margin: 0; padding: 0; height: 100%; width: 100%; }
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				#iframe { display: none; width: 100%; height: 70%; border: none; min-height: 300px; }
				#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
				</style>
				</head>
				<body>
				<br>
				<h1>The Oath</h1>

				<i>The Medical Oath sworn by recognised medical practitioners in the employ of [company_name]</i><br>

				<ol>
					<li>Now, as a new doctor, I solemnly promise that I will, to the best of my ability, serve humanity-caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and I will not abuse my position.</li>
					<li>I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow doctors and other colleagues to meet the needs of my patients.</li>
					<li>I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li>I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li>I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li>I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li>I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li>I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li>I make this declaration solemnly, freely, and upon my honour.</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<script type="text/javascript">
					function pageloaded(myframe) {
						document.getElementById("loading").style.display = "none";
						myframe.style.display = "block";
					}
				</script>
				<p id='loading'>You start skimming through the manual...</p>
				<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl]Guide_to_Medicine" frameborder="0"></iframe>
				</body>
			</html>

		"}


/obj/item/book/manual/engineering_guide
	name = "Engineering Textbook"
	icon_state = "bookEngineering"
	author = "Artificer's Guild"
	title = "Engineering Textbook"

/obj/item/book/manual/engineering_guide/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl]Construction" frameborder="0"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Frontier Logistics Service"
	title = "Chef Recipes"

/obj/item/book/manual/chef_recipes/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Food' frameborder="0"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Frontier Logistics Service"
	title = "Barman Recipes"

/obj/item/book/manual/barman_recipes/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Drinks' frameborder="0"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state = "bookDetective"
	author = "Corporate Liaison"
	title = "The Film Noir: Proper Procedures for Investigations"

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
				<h1>Detective Work</h1>

				Between your bouts of self-narration and drinking whiskey on the rocks, you might get a case or two to solve.<br>
				To have the best chance to solve your case, follow these directions:
				<p>
				<ol>
					<li>Go to the crime scene. </li>
					<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog). </li>
					<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
					<li>Return to your office. </li>
					<li>Using your forensic scanning computer, scan your scanner to upload all of your evidence into the database.</li>
					<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
					<li>If you have 80% or more of the print (The print is displayed), go to step 10, otherwise continue to step 8.</li>
					<li>Look for clues from the suit fibres you found on your perpetrator, and go about looking for more evidence with this new information, scanning as you go. </li>
					<li>Try to get a fingerprint card of your perpetrator, as if used in the computer, the prints will be completed on their dossier.</li>
					<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
					<li>Since you now have both your dossier and the name of the person, print both out as evidence and get security to nab your baddie.</li>
					<li>Give yourself a pat on the back and a bottle of the ship's finest vodka, you did it!</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
			</html>"}

/obj/item/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state = "bookNuclear"  // Nuclear self-destruct operations
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Nuclear Explosives 101</h1>
				Hello and thank you for choosing the Syndicate for your nuclear information needs. Today's crash course will deal with the operation of a Nuclear Fission Device.<br><br>

				First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE. Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done, to unbolt it, one must completely log in, which at this time may not be possible.<br>

				<h2>To make the nuclear device functional</h2>
				<ul>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device from its interface.</li>
					<li>Insert the nuclear authorisation disk into the slot.</li>
					<li>Type the numeric authorisation code into the keypad. This should have been provided.<br>
					<b>Note</b>: If you make a mistake, press R to reset the device.
					<li>Press the E button to log on to the device.</li>
				</ul><br>

				You now have activated the device. To deactivate the buttons at anytime, for example when you've already prepped the bomb for detonation, remove the authentication disk OR press R on the keypad.<br><br>
				Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				<b>Note</b>: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br><br>

				So use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>
				<b>Note</b>: THE BOMB IS STILL SET AND WILL DETONATE<br><br>

				Now before you remove the disk, if you need to move the bomb, you can toggle off the anchor, move it, and re-anchor.<br><br>

				Remember the order:<br>
				<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br><br>
				Intelligence Analysts believe that normal corporate procedure is for the Captain to secure the nuclear authentication disk.<br><br>

				Good luck!
				</body>
			</html>
			"}

/obj/item/book/manual/atmospipes
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "plumbingbook"
	author = "Artificer's Guild"
	title = "Pipes and You: Getting To Know Your Scary Tools"

/obj/item/book/manual/atmospipes/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Atmospherics' frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/evaguide
	name = "EVA Gear and You: Not Spending All Day Inside"
	icon_state = "book4"
	author = "Artificer's Guild"
	title = "EVA Gear and You: Not Spending All Day Inside"

/obj/item/book/manual/evaguide/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_EVA' frameborder="0"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/wiki
	var/page_link = ""
	window_size = "1280x900"

/obj/item/book/manual/wiki/attack_self()
	if(!dat)
		initialize_wikibook()
	return ..()

/obj/item/book/manual/wiki/proc/initialize_wikibook()
	if(config.wikiurl)
		dat = {"
			<html><head>
			<style>
				html, body {
					margin: 0;
					padding: 0;
					height: 100%;
					width: 100%;
					overflow: hidden;
				}
				#iframe {
					display: none;
					width: 100%;
					height: 100%;
					border: none;
				}
				#loading {
					position: absolute;
					top: 50%;
					left: 50%;
					transform: translate(-50%, -50%);
				}
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "block";
    			}
			</script>
			<p id='loading'>You start skimming through the manual...</p>
			<iframe id="iframe" onload="pageloaded(this)" src="[config.wikiurl][page_link][config.language]" frameborder="0"></iframe>
			</body>
			</html>
			"}

//engineering

/obj/item/book/manual/wiki/engineering_construction
	name = "Colony Repairs and Construction"
	icon_state = "bookEngineering"
	author = "Artificer's Guild"
	title = "Colony Repairs and Construction"
	page_link = "Construction"

/obj/item/book/manual/wiki/engineering_atmos
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "plumbingbook"
	author = "Artificer's Guild"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	page_link = "Guide_to_Atmospherics"

/obj/item/book/manual/wiki/engineering_hacking
	name = "Hacking"
	icon_state = "bookHacking"
	author = "Artificer's Guild"
	title = "Hacking"
	page_link = "Guide_to_Hacking"

//science
/obj/item/book/manual/wiki/science_research
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Vesalius-Andra Research"
	title = "Research and Development 101"
	page_link = "Guide_to_Research_and_Development"

/obj/item/book/manual/wiki/science_robotics
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "Vesalius-Andra Robotics"
	title = "Cyborgs for Dummies"
	page_link = "Guide_to_Robotics"

/obj/item/book/manual/wiki/science_toxins
	name = "Toxins Laboratory Guide"
	desc = "TTV bombs, gas preparation, and explosion strength for research and mining."
	icon_state = "rdbook"
	author = "Vesalius-Andra Research"
	title = "Toxins Laboratory Guide"
	page_link = "Guide_to_Toxins"

//security
/obj/item/book/manual/wiki/security_ironparagraphs
	name = "Ranger Paragraphs"
	desc = "A set of corporate guidelines for keeping order on privately-owned space assets."
	icon_state = "bookSpaceLaw"
	author = "Iskhod Rangers"
	title = "Ranger Paragraphs"
	page_link = "Guide_to_Security"

//medical
/obj/item/book/manual/wiki/medical_guide
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "medicalbook"
	author = "Medical Journal, volume 1"
	title = "Medical Diagnostics Manual"
	page_link = "Guide_to_Medicine"

/obj/item/book/manual/wiki/medical_chemistry
	name = "Chemistry Textbook"
	icon_state = "chemistrybook"
	author = "Vesalius-Andra Research"
	title = "Chemistry"
	page_link = "Guide_to_Chemistry"

/obj/item/book/manual/wiki/surgery_guide
	name = "Guide to Surgical Procedures"
	desc = "A practitioner's reference for surgical tools, incision and closure, and step-by-step procedures."
	icon_state = "medicalbook"
	author = "Vesalius-Andra Medical"
	title = "Guide to Surgical Procedures"
	page_link = "Guide_to_Surgery"

//neotheology

//service
/obj/item/book/manual/wiki/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Frontier Logistics Service"
	title = "Barman Recipes"
	page_link = "Guide_to_Drinks"

/obj/item/book/manual/wiki/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Frontier Logistics Service"
	title = "Chef Recipes"
	page_link = "Guide_to_Food"

// Wiki variants of new manuals (load from wiki when available)
/obj/item/book/manual/wiki/infections_guide
	name = "Infections and Pathogens Guide"
	desc = "A medical reference for identifying and containing infectious agents."
	icon_state = "bookinfections"
	author = "Vesalius-Andra Biocontainment"
	title = "Infections and Pathogens Guide"
	page_link = "Guide_to_Medicine"

/obj/item/book/manual/wiki/cqc_manual
	name = "Close Quarters Combat Manual"
	desc = "A compact guide to hand-to-hand and close combat techniques."
	icon_state = "cqcmanual"
	author = "Blackshield Training Division"
	title = "Close Quarters Combat Manual"
	page_link = "Combat"

/obj/item/book/manual/wiki/stealth_manual
	name = "Stealth and Infiltration"
	desc = "A slim volume on moving quietly and observing without being seen."
	icon_state = "stealthmanual"
	author = "Iskhod Rangers"
	title = "Stealth and Infiltration"
	page_link = "Tips"

/obj/item/book/manual/wiki/cytology_textbook
	name = "Cytology Textbook"
	desc = "Cell structure and microscopic biology."
	icon_state = "cytologybook"
	author = "Vesalius-Andra Research"
	title = "Cytology Textbook"
	page_link = "Guide_to_Genetics"

/obj/item/book/manual/wiki/fishing_guide
	name = "Fishing and Xenofauna Guide"
	desc = "Fishing spots and safe handling of alien aquatic life."
	icon_state = "fishbook"
	author = "Prospector's Handbook"
	title = "Fishing and Xenofauna Guide"
	page_link = "Critters"

/obj/item/book/manual/wiki/xenogenetics_guide
	name = "Xenogenetics"
	desc = "Xenofauna genetics, the genetic sequencer, cloning vats, and mutation systems. References the wiki Guide to Genetics."
	icon_state = "bookCloning"
	author = "Vesalius-Andra Research"
	title = "Xenogenetics"
	page_link = "Guide_to_Genetics"

/obj/item/book/manual/wiki/electronic_primer
	name = "Electronic Systems Primer"
	desc = "Basic electronics and secure systems."
	icon_state = "ebook"
	author = "Artificer's Guild"
	title = "Electronic Systems Primer"
	page_link = "Guide_to_Hacking"

/obj/item/book/manual/wiki/boneworking_guide
	name = "Boneworking Guide"
	desc = "Crafting and toolmaking from bone and similar materials."
	icon_state = "boneworking_learning"
	author = "Artificer's Guild"
	title = "Boneworking Guide"
	page_link = "Basic_Construction"

/obj/item/book/manual/wiki/hydroponics_pod_people
	name = "Guide to Xenoflora"
	desc = "Xenobotany, exotic plants, mutations, and the xenoflora lab guide."
	icon_state = "bookHydroponicsPodPeople"
	author = "Vesalius-Andra Xenobotany"
	title = "Guide to Xenoflora"
	page_link = "Guide_to_Xenoflora"

/obj/item/book/manual/wiki/sweets_guide
	name = "Sweet Recipes"
	desc = "Pastries, cakes, and confections."
	icon_state = "cooking_learning_sweets"
	author = "Frontier Logistics Service"
	title = "Sweet Recipes"
	page_link = "Guide_to_Food"

/obj/item/book/manual/wiki/frozen_treats_guide
	name = "Frozen Treats Guide"
	desc = "Ice cream and chilled desserts."
	icon_state = "cooking_learning_ice"
	author = "Frontier Logistics Service"
	title = "Frozen Treats Guide"
	page_link = "Guide_to_Food"

/obj/item/book/manual/religion/c_bible
	name = "Christian Bible"
	desc = "A book with a silver bolder and a golden crucifix in the middle. The glass in the middle seems to shimmer and shine."
	icon_state = "c_bible"
	author = "Unknown"
	title = "Holy Bible"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>The Holy Bible</h1>
				<h2>Genesis 1:1-1:12</h2>
				<ol>
				1:1 In the beginning God created the heaven and the earth.

				1:2 And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.

				1:3 And God said, Let there be light: and there was light.

				1:4 And God saw the light, that it was good: and God divided the light from the darkness.

				1:5 And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.

				1:6 And God said, Let there be a firmament in the midst of the waters, and let it divide the waters from the waters.

				1:7 And God made the firmament, and divided the waters which were under the firmament from the waters which were above the firmament: and it was so.

				1:8 And God called the firmament Heaven. And the evening and the morning were the second day.

				1:9 And God said, Let the waters under the heaven be gathered together unto one place, and let the dry land appear: and it was so.

				1:10 And God called the dry land Earth; and the gathering together of the waters called he Seas: and God saw that it was good.

				1:11 And God said, Let the earth bring forth grass, the herb yielding seed, and the fruit tree yielding fruit after his kind, whose seed is in itself, upon the earth: and it was so.

				1:12 And the earth brought forth grass, and herb yielding seed after his kind, and the tree yielding fruit, whose seed was in itself, after his kind: and God saw that it was good.

				</ol>
				</body>
			</html>
			"}

/obj/item/book/manual/religion/h_book
	name = "Holy Book"
	desc = "An undescript book for an unnamed religion."
	icon_state = "biblep"
	author = "Unknown"

/obj/item/book/manual/fiction/ataleoftwocities
	name = "A Tale of Two Cities"
	desc = "A novel about the adventures of a doctor in the midst of a revolution."
	icon_state ="book2"
	author = "Charles Dickens"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "A Tale of Two Cities"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/DICKENS/dickens-tale-126.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/aroundtheworld
	name = "Around the World in 80 Days"
	desc = "A novel about a wager to sail the world in only eighty days."
	icon_state ="book2"
	author = "Jules Verne"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Around the World in 80 Days"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/80day10.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/theinvisibleman
	name = "The Invisible Man"
	desc = "A novel about a strange bandaged fellow with a dark secret."
	icon_state ="book2"
	author = "H.G. Wells"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Invisible Man"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/wells-invisible-187.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/waroftheworlds
	name = "The War of the Worlds"
	desc = "A novel about survival in a world under invasion."
	icon_state ="book2"
	author = "H.G. Wells"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The War of the Worlds"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/wells-war-189.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/achristmascarol
	name = "A Christmas Carol"
	desc = "A novel about a miserable and bitter man who discovers the spirit of Christmas."
	icon_state ="book2"
	author = "Charles Dickens"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "A Christmas Carol"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/DICKENS/dickens-christmas-125.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/muchadoaboutnothing
	name = "Much Ado About Nothing"
	desc = "A comedic play about love, rumours, and trickery."
	icon_state ="book2"
	author = "William Shakespeare"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Much Ado About Nothing"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/SHAKESPEARE/shakespeare-much-3.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/romeoandjuliet
	name = "Romeo and Juliet"
	desc = "A tragic play about lovers from two feuding families."
	icon_state ="book2"
	author = "William Shakespeare"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Romeo and Juliet"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/SHAKESPEARE/shakespeare-romeo-48.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/kinglear
	name = "King Lear"
	desc = "A tragic play about a troubled king who delves into madness."
	icon_state ="book2"
	author = "William Shakespeare"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "King Lear"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/SHAKESPEARE/shakespeare-king-45.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/twelfthnight
	name = "Twelfth Night"
	desc = "A comedic play about lovers, crossdressing, and a lot of confusion."
	icon_state ="book2"
	author = "William Shakespeare"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Twelfth Night"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/SHAKESPEARE/shakespeare-twelfth-20.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/macbeth
	name = "Macbeth"
	desc = "A tragic play about the corruption of a noble and brave general."
	icon_state ="book2"
	author = "William Shakespeare"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Macbeth"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/SHAKESPEARE/shakespeare-macbeth-46.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/frankenstein
	name = "Frankenstein"
	desc = "A novel about a scientist who creates a terrifying monster."
	icon_state ="book2"
	author = "Mary Shelley"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Frankenstein"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/shelley-frankenstein-160.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/dracula
	name = "Dracula"
	desc = "A novel about the murderous reign of an evil vampire."
	icon_state ="book2"
	author = "Bram Stoker"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Dracula"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/stoker-dracula-168.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/journeytothecenter
	name = "A Journey to the Center of the Earth"
	desc = "A novel about an adventurous journey into the depths of a planet."
	icon_state ="book2"
	author = "Jules Verne"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "A Journey to the Center of the Earth"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/center_earth" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/rimeoftheancientmariner
	name = "The Rime of the Ancient Mariner"
	desc = "A poem about a mariner who is cursed and suffers terrible events."
	icon_state ="book2"
	author = "Samuel Taylor Coleridge"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Rime of the Ancient Mariner"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/coleridge-rime-371.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/kublakhan
	name = "Kubla Khan"
	desc = "A rather abstract poem written about an ancient ruler."
	icon_state ="book2"
	author = "Samuel Taylor Coleridge"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Kubla Khan"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/coleridge-kubla-370.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/warandpeace
	name = "War and Peace"
	desc = "A novel examining a turbulent age through the stories of five families."
	icon_state ="book2"
	author = "Leo Tolstoy"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "War and Peace"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/war_peace_text" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/robinsoncrusoe
	name = "Robinson Crusoe"
	desc = "A novel cataloguing the adventures of a shipwrecked sailor."
	icon_state ="book2"
	author = "Daniel Defoe"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Robinson Crusoe"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/r_crusoe" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/thejunglebook
	name = "The Jungle Book"
	desc = "A series of stories set in the untamed jungle."
	icon_state ="book2"
	author = "Rudyard Kipling"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Jungle Book"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/kipling-jungle-148.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/thetimemachine
	name = "The Time Machine"
	desc = "A novel about a man who explores through time."
	icon_state ="book2"
	author = "H.G. Wells"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Time Machine"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/wells-time-188.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/wutheringheights
	name = "Wuthering Heights"
	desc = "A novel about doomed love and subsequent revenge."
	icon_state ="book2"
	author = "Emily Bronte"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Wuthering Heights"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/bronte-wuthering-179.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/fiction/littlewomen
	name = "Little Women"
	desc = "A novel following the lives of four sisters."
	icon_state ="book2"
	author = "Louisa May Alcott"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Little Women"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/FICTION/li_women" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}


/obj/item/book/manual/nonfiction/metaphysics
	name = "Metaphysics"
	desc = "A complex philosophical work about existence, change, and understanding the world."
	icon_state ="book2"
	author = "Aristotle"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Metaphysics"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/ARISTOTLE/aristotle-metaphysics-77.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/meteorology
	name = "Meteorology"
	desc = "A treatise delving into geology, geography, physics, and the elements."
	icon_state ="book2"
	author = "Aristotle"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Meteorology"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/ARISTOTLE/aristotle-meteorology-80.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/politics
	name = "Politics"
	desc = "A philosophical work about political theory, constitutions, power, and the ideal state."
	icon_state ="book2"
	author = "Aristotle"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Politics"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/ARISTOTLE/aristotle-politics-89.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/ethics
	name = "Nicomachean Ethics"
	desc = "A philosophical work about how man should best live, and how this can be achieved."
	icon_state ="book2"
	author = "Aristotle"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Ethics"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/ARISTOTLE/aristotle-nicomachean-81.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/thescienceofright
	name = "The Science of Right"
	desc = "A philosophical work about the rights man has, and should have."
	icon_state ="book2"
	author = "Immanual Kant"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Science of Right"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/KANT/kant-science-146.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/thetranscendentalist
	name = "The Transcendentalist"
	desc = "A lecture and essay discussing the emergence of Transcendentalism."
	icon_state ="book2"
	author = "Ralph Waldo Emerson"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Transcendentalist"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/EMERSON/emerson-transcendentalist-239.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/manthereformer
	name = "Man The Reformer"
	desc = "A lecture and essay discussing the ability of man to reform and change society."
	icon_state ="book2"
	author = "Ralph Waldo Emerson"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Man The Reformer"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/AUTHORS/EMERSON/emerson-man-235.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/ageofreason
	name = "The Age of Reason"
	desc = "A work promoting rationality and intellectualism over religion."
	icon_state ="book2"
	author = "Thomas Paine"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "The Age of Reason"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/NONFICTION/reason" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/lifewithoutprinciple
	name = "Life Without Principle"
	desc = "An essay discussing the core principles to living a righteous life."
	icon_state ="book2"
	author = "Henry David Thoreau"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Life Without Principle"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/NONFICTION/thoreau-life-183.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/leviathan
	name = "Leviathan"
	desc = "A work discussing the structure of society and government."
	icon_state ="book2"
	author = "Thomas Hobbes"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Leviathan"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/NONFICTION/hobbes-leviathan-66.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/nonfiction/suntzu
	name = "Sun Tzu on The Art of War"
	desc = "A treatise concerning ancient military strategies and tactics."
	icon_state ="book2"
	author = "Sun Tzu"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Sun Tzu on The Art of War"
	dat = {"
		<html><head>
		</head>
		<body>
		<iframe width='100%' height='100%' src="http://www.textfiles.com/etext/NONFICTION/suntx10.txt" frameborder="0" id="main_frame"></iframe>
		</body>
		</html>
		"}

/obj/item/book/manual/xenobio_recipies
	name = "Slime plorts and reactions"
	icon_state = "rdbook"
	author = "Leoric M."		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Slime plorts and reactions"

/obj/item/book/manual/xenobio_recipies/New()
	..()
	dat = {"
		<html><head>
		<style>
			html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
			#iframe { display: none; width: 100%; height: 100%; border: none; }
			#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
		</style>
		</head>
		<body>
		<script type="text/javascript">
			function pageloaded(myframe) {
				document.getElementById("loading").style.display = "none";
				myframe.style.display = "block";
			}
		</script>
		<p id='loading'>You start skimming through the manual...</p>
		<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Xenobiology' frameborder="0"></iframe>
		</body>
		</html>
		"}

// Unused sprite manuals - variety and flavour
/obj/item/book/manual/mystery_manual
	name = "Unidentified Manual"
	desc = "The cover is faded and the title is illegible. Something might still be inside."
	icon_state = "random_book"
	author = "Unknown"
	title = "Unidentified Manual"
	dat = {"<html><head></head><body>
		<p>The pages are water-damaged and mostly unreadable. You can make out a few diagrams and the words &quot;refer to appropriate department&quot;.</p>
		</body></html>"}

/obj/item/book/manual/mystery_manual/attack_self(mob/user)
	// Occasionally show a different snippet as if the text is still shifting
	var/display_dat = dat
	if(prob(20))
		var/static/list/mystery_snippets = list(
			"<p>...isolate affected individuals, don appropriate PPE...</p>",
			"<p>...minimum force necessary. This manual is a supplement to certified...</p>",
			"<p>...nutrient solutions, growth cycles, and ethical guidelines...</p>",
			"<p>...secure water, secure power, secure the perimeter...</p>",
			"<p>...the script seems to shift on the page...</p>"
		)
		display_dat = {"<html><head></head><body>[pick(mystery_snippets)]</body></html>"}
	playsound(src.loc, pick('sound/items/BOOK_Turn_Page_1.ogg','sound/items/BOOK_Turn_Page_2.ogg','sound/items/BOOK_Turn_Page_3.ogg','sound/items/BOOK_Turn_Page_4.ogg'), rand(40,80), 1)
	if(display_dat)
		user << browse(HTML_SKELETON_TITLE("Penned by [author]", display_dat), "window=book")
		user.visible_message("[user] opens a book titled \"[src.title]\" and begins reading intently.")
		onclose(user, "book")
	else
		to_chat(user, "This book is completely blank!")

/obj/item/book/manual/infections_guide
	name = "Infections and Pathogens Guide"
	desc = "A medical reference for identifying and containing infectious agents."
	icon_state = "bookinfections"
	author = "Vesalius-Andra Biocontainment"
	title = "Infections and Pathogens Guide"
	dat = {"<html><head></head><body>
		<h1>Containment Protocols</h1>
		<p>In case of suspected outbreak: isolate affected individuals, don appropriate PPE, and contact Medical. Do not attempt to treat unknown pathogens without diagnostics.</p>
		</body></html>"}

/obj/item/book/manual/cqc_manual
	name = "Close Quarters Combat Manual"
	desc = "A compact guide to hand-to-hand and close combat techniques."
	icon_state = "cqcmanual"
	author = "Blackshield Training Division"
	title = "Close Quarters Combat Manual"
	dat = {"<html><head></head><body>
		<h1>CQC Basics</h1>
		<p>Disarm, disable, detain. Use minimum force necessary. This manual is a supplement to certified Ranger training only.</p>
		</body></html>"}

/obj/item/book/manual/stealth_manual
	name = "Stealth and Infiltration"
	desc = "A slim volume on moving quietly and observing without being seen."
	icon_state = "stealthmanual"
	author = "Redacted"
	title = "Stealth and Infiltration"
	dat = {"<html><head></head><body>
		<p>Stay in the shadows. Watch the patrol routes. Never run when you can walk.</p>
		</body></html>"}

/obj/item/book/manual/origami_guide
	name = "Origami for Beginners"
	desc = "Paper folding for relaxation and dexterity."
	icon_state = "origamibook"
	author = "Frontier Logistics Service"
	title = "Origami for Beginners"
	dat = {"<html><head></head><body>
		<h1>Paper Crane</h1>
		<p>Fold the square in half diagonally. Then fold again&hellip;</p>
		</body></html>"}

/obj/item/book/manual/sweets_guide
	name = "Sweet Recipes"
	desc = "Pastries, cakes, and confections."
	icon_state = "cooking_learning_sweets"
	author = "Frontier Logistics Service"
	title = "Sweet Recipes"
	dat = {"<html><head></head><body>
		<p>Add dough and sugar to the microwave for donuts. For cakes, combine flour, egg, and sugar.</p>
		</body></html>"}

/obj/item/book/manual/frozen_treats_guide
	name = "Frozen Treats Guide"
	desc = "Ice cream and chilled desserts."
	icon_state = "cooking_learning_ice"
	author = "Frontier Logistics Service"
	title = "Frozen Treats Guide"
	dat = {"<html><head></head><body>
		<p>Ice cream requires a few basic ingredients and a cold environment. Perfect for the colony heat.</p>
		</body></html>"}

/obj/item/book/manual/cytology_textbook
	name = "Cytology Textbook"
	desc = "Cell structure and microscopic biology."
	icon_state = "cytologybook"
	author = "Vesalius-Andra Sciences"
	title = "Cytology Textbook"
	dat = {"<html><head></head><body>
		<p>Understanding cellular structure is fundamental to genetics, xenobiology, and medical diagnostics.</p>
		</body></html>"}

/obj/item/book/manual/fishing_guide
	name = "Fishing and Xenofauna Guide"
	desc = "Fishing spots and safe handling of alien aquatic life."
	icon_state = "fishbook"
	author = "Prospector's Handbook"
	title = "Fishing and Xenofauna Guide"
	dat = {"<html><head></head><body>
		<p>Local waters and sealed environments may contain edible or hazardous fauna. Identify before handling.</p>
		</body></html>"}

/obj/item/book/manual/electronic_primer
	name = "Electronic Systems Primer"
	desc = "Basic electronics and secure systems."
	icon_state = "ebook"
	author = "Artificer's Guild"
	title = "Electronic Systems Primer"
	dat = {"<html><head></head><body>
		<p>For authorised personnel. Covers basic wiring, access systems, and when to call a qualified technician.</p>
		</body></html>"}

/obj/item/book/manual/boneworking_guide
	name = "Boneworking Guide"
	desc = "Crafting and toolmaking from bone and similar materials."
	icon_state = "boneworking_learning"
	author = "Guild Archives"
	title = "Boneworking Guide"
	dat = {"<html><head></head><body>
		<p>Bone and chitin can be worked into tools and components where metal is scarce. Requires a steady hand.</p>
		</body></html>"}

/obj/item/book/manual/hydroponics_pod_people
	name = "Guide to Xenoflora"
	desc = "Xenobotany, exotic plants, mutations, and the xenoflora lab guide."
	icon_state = "bookHydroponicsPodPeople"
	author = "Vesalius-Andra Xenobotany"
	title = "Guide to Xenoflora"

/obj/item/book/manual/hydroponics_pod_people/New()
	..()
	if(config.wikiurl)
		dat = {"
			<html><head>
			<style>
				html, body { margin: 0; padding: 0; height: 100%; width: 100%; overflow: hidden; }
				#iframe { display: none; width: 100%; height: 100%; border: none; }
				#loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "block";
				}
			</script>
			<p id='loading'>You start skimming through the manual...</p>
			<iframe id="iframe" onload="pageloaded(this)" src='[config.wikiurl]Guide_to_Xenoflora' frameborder="0"></iframe>
			</body>
			</html>
			"}
	else
		dat = {"<html><head></head><body>
			<p>Xenobotany, exotic plants, and mutation procedures. (Wiki not configured.)</p>
			</body></html>"}

/obj/item/book/manual/mime_art
	name = "The Art of Mime"
	desc = "Silent performance and gesture. Opening it makes no sound."
	icon_state = "bookmime"
	author = "Frontier Logistics Service"
	title = "The Art of Mime"
	dat = {"<html><head></head><body>
		<p>...</p>
		<p><i>(The rest of the book is blank.)</i></p>
		</body></html>"}

/obj/item/book/manual/mime_art/attack_self(mob/user)
	// No page-turn sound - mimes are silent
	if(src.dat)
		user << browse(HTML_SKELETON_TITLE("Penned by [author]", dat), "window=book")
		user.visible_message("[user] opens a book titled \"[src.title]\" and reads in silence.")
		onclose(user, "book")
	else
		to_chat(user, "...")

/obj/item/book/manual/basic_scripture
	name = "Basic Scripture"
	desc = "A plain collection of devotional texts. Said to steady the mind of the faithful."
	icon_state = "basic_bible"
	author = "Church of the Absolute"
	title = "Basic Scripture"
	dat = {"<html><head></head><body>
		<p>Selected readings for daily reflection. Consult clergy for full canon.</p>
		</body></html>"}

/obj/item/book/manual/basic_scripture/attack_self(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_core_implant(/obj/item/implant/core_implant/cruciform) && H.sanity && prob(25))
			H.sanity.changeLevel(3)
			to_chat(H, SPAN_NOTICE("The familiar words ease your mind."))
	..()

/obj/item/book/manual/original_guide
	name = "Original Colony Guide"
	desc = "Early settlement procedures and survival notes."
	icon_state = "ogbook"
	author = "First Landing Party"
	title = "Original Colony Guide"
	dat = {"<html><head></head><body>
		<p>When we first set down here, the rules were simple: secure water, secure power, secure the perimeter. Everything else came after.</p>
		</body></html>"}

// Thematic tomes moved to code/modules/blood_magic/tomes.dm (path: /obj/item/book/tome/[effect]). Obtain via oddity loot or Scribe ritual.
