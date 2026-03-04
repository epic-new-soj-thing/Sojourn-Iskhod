// Demonomicon — blood magic guide. Part of the blood_magic module.
// GLOB.demonomicon_spawned_this_round is set when the archive bookcase spawns one (lib_items.dm) or when a common_oddities spawner spawns one (oddities.dm). Common_oddities is used for oddity spawns and for trash piles that summon oddities (e.g. scrap science/poor in scrap.dm, pack/rare in packs.dm). At most one Demonomicon is spawned per round from these sources; manual spawns and direct map placement do not set it.
GLOBAL_VAR_INIT(demonomicon_spawned_this_round, FALSE)

/obj/item/book/manual/demonomicon
	name = "Demonomicon"
	desc = "A heavy, leather-bound manual. The cover is tooled with runes and geometries that seem to shift when not looked at directly. The spine shows no author; the pages smell faintly of copper and old ash. Reading it weighs on the mind."
	icon_state = "demonomicon"
	author = "Unknown"
	title = "Demonomicon"
	w_class = ITEM_SIZE_SMALL
	window_size = "900x600"  // Wider than tall for the long blood-magic guide text
	var/mob/living/carbon/human/current_reader  // Who has the book window open; sanity drains until they close it
	var/reading_drain_timer  // Timer id for repeating sanity drain while window is open
	var/saved_sanity_gain_multiplier  // Restore reader's passive sanity gain when they close the book
	dat = {"<html>
				<head>
				<style>
				body { font-family: Georgia, serif; margin: 1em 2em; color: #2c1810; background: #f5ecd8; }
				h1 { color: #5c3020; border-bottom: 2px solid #8b6914; padding-bottom: 0.25em; font-size: 1.4em; }
				h2 { color: #5c3020; margin-top: 1.2em; font-size: 1.15em; }
				h3 { color: #6b3a28; margin-top: 1em; font-size: 1.05em; }
				.page { margin-top: 2em; padding-top: 1.5em; border-top: 1px solid #c4a574; }
				.toc { background: #ebe0c8; padding: 0.8em 1em; border: 1px solid #c4a574; margin: 1em 0; }
				.toc a { color: #5c3020; }
				table { border-collapse: collapse; width: 100%; margin: 0.8em 0; font-size: 0.95em; box-shadow: 0 1px 3px rgba(0,0,0,0.15); }
				th { background: #5c3020; color: #f5ecd8; padding: 0.5em 0.6em; text-align: left; border: 1px solid #3d2015; }
				td { padding: 0.4em 0.6em; border: 1px solid #c4a574; }
				tr:nth-child(even) { background: #ebe0c8; }
				tr:nth-child(odd) { background: #f5ecd8; }
				.spell { font-weight: bold; color: #5c3020; }
				.candles { text-align: center; white-space: nowrap; }
				ul { margin: 0.5em 0; padding-left: 1.5em; }
				blockquote { margin: 0.8em 0; padding: 0.5em 1em; border-left: 3px solid #8b6914; background: #ebe0c8; font-style: italic; }
				hr { border: none; border-top: 1px dashed #c4a574; margin: 1.5em 0; }
				</style><style>body,*{user-select:none !important;-webkit-user-select:none !important;-moz-user-select:none !important;-ms-user-select:none !important;}</style>
				</head>
				<body>

				<h1>On the Art of Blood Magic</h1><blockquote>This tome describes the binding of will to blood, and the use of runes and ritual to channel forces that lie outside common understanding.</blockquote>

				<div class="toc"><b>Contents</b> &mdash; I. Prerequisites &amp; Prohibitions &bull; II. The Blood Rune &bull; III. Inscribing the Working &bull; IV. Candles &amp; Invocation &bull; V. The Tongues &bull; VI. Book Spells &bull; VII. Knife Spells &bull; VIII. Scrolls &amp; Traps (incl. scroll spell table) &bull; IX. The Blood Basin &bull; X. Alchemy &bull; XI. Tomes (incl. sanity &amp; cost of reading) &bull; XII. On This Tome</div>

				<h2>I. Prerequisites &amp; Prohibitions</h2>
				<p>Blood magic is closed to the faithful: those who bear the cruciform cannot draw runes in blood nor channel the rituals described herein. Synthetics and slimes are likewise unable to perform these arts. The practitioner must be of flesh, with blood in their veins: no less than fifty measures of blood remain in the body, and the constitution must not be broken (the tome speaks of a threshold of thirty in strength of form). Nearsightedness is not required, but some texts suggest it may sharpen focus: those who are <b>not</b> nearsighted face an additional one-in-ten chance that the ritual fails when invoked (the focus wavers and the working does not take). Whenever a ritual fails&#8212;whether from weak binding or lost focus&#8212;the caster still pays a cost in blood (twelve measures).</p>

				<h2>II. The Blood Rune</h2>
				<h3>How to make a blood rune</h3>
				<ol>
				<li>Obtain a <b>ritual knife</b> (found in oddity caches or maintenance; it may appear as a dormant blade).</li>
				<li>Stand on a <b>floor</b> (or the tile where the rune should lie). You must have at least <b>25 measures of blood</b> in your body; the ritual will cost that much.</li>
				<li><b>Use the ritual knife on the floor</b> (click the knife, then the floor, or use it in hand on the tile). You cut your palm and trace a rune. Remain still until the action completes.</li>
				<li>A <b>blood rune</b> appears on that tile. Only runes drawn in blood with the ritual knife can channel rituals. Runes drawn in wax (e.g. with a crayon&#8212;which can be used to draw rune-shaped markings as fake runes for misdirection) or by any other means cannot channel.</li>
				</ol>
				<p>You need only one rune; the <b>spell name</b> is inscribed on <b>paper</b> (in blood or with a pen), as described in Section III. The rune itself must be this blood rune on the floor&mdash;nothing else can channel.</p>
				<p><b>Sanity:</b> Runes drawn in wax (e.g. with a crayon) and other crayon drawings do not affect the mind. Only a <b>blood rune</b>&mdash;one drawn with the ritual knife&mdash;weighs upon those who behold it; its mere presence slowly drains sanity.</p>

				<hr>

				<div class="page">
				<h2>III. Inscribing the Working</h2><p>The ritual reads the <b>name of the spell</b> from <b>paper</b> only. The rune must be a <b>blood rune on the floor</b> (drawn with the ritual knife); the words must be inscribed on paper in <b>blood or pen</b>, in the <b>required language</b> for that spell, and placed within <b>three tiles</b> of the rune when you invoke. Writing the spell name in blood upon the floor does <b>not</b> work&mdash;the rune will not read it.</p>
				<h3>How to inscribe the spell on paper</h3>
				<p>Inscribe the spell name on <b>paper</b> using a <b>pen</b> (or crayon), or in <b>blood on the paper</b> (get bloody hands from a blood pool or a blood basin, then use the <b>Write in blood</b> verb on the paper). Set the paper&rsquo;s writing language to the <b>required tongue</b>: <b>book</b> spells (Section VI) and <b>scroll</b> inscriptions (Section VIII) require the <b>Cult</b> language; <b>knife</b> spells (Section VII) require the <b>Occult</b> language. Place the paper within three tiles of the blood rune. Spell names are case-sensitive and must end with a full stop.</p>
				<p><b>Blood and pen:</b> Inscriptions written in <b>blood on the paper</b> bind truly; the ritual proceeds as normal. Inscriptions written with a <b>pen</b> or <b>crayon</b> lack the binding and have a <b>chance of failure</b> when invoked&mdash;the rune may flicker and the working may not take. Red <b>crayon</b> (crayon only, not red pen) is said to hold the intent somewhat better and enjoys a higher chance of success than other pen or crayon work. Whenever an invocation fails&#8212;whether the ink lacked binding or the caster&rsquo;s focus wavered&#8212;<b>twelve measures of blood</b> are still drawn from the caster.</p>
				<p><b>Summary:</b> Blood rune on the floor (ritual knife). Spell name on paper (blood or pen/crayon), in the required language (Cult for book/scroll, Occult for knife). Place the paper near the rune. Blood on the paper is reliable; pen and crayon have a chance of failure (red crayon fares better). Non-nearsighted casters face an extra chance of focus failure. Failed rituals cost twelve measures of blood.</p>
				<h2>IV. Candles &amp; Invocation</h2>
				<p>Place <b>candles</b> within three tiles of the rune. When you invoke the rune, any unlit candles in that range may catch flame. Each ritual demands a minimum number of candles (given below). Count only candles within three tiles.</p>
				<h3>Which books work for spells</h3>
				<p>To invoke <b>book</b> spells (Section VI), you must use one of the following upon the blood rune:</p>
				<ul>
				<li><b>The Demonomicon</b> (this tome)&#8212;always valid.</li>
				<li><b>An Omega book</b> or <b>an Unholy book</b> (oddities found in caches or maintenance). Either the <b>closed</b> or the <b>opened</b> form may be used to invoke ordinary book spells. A closed book can be &ldquo;opened&rdquo; by the <b>Ascension.</b> spell (knife, 7 candles); once opened, it may also be used to <b>create thematic tomes</b> (Section XI).</li>
				</ul>
				<p><b>Creating tomes</b> (Fireball., Smoke., etc.) requires an <b>opened</b> Omega or Unholy book, or the Demonomicon; a closed book cannot bind a tome. Use Ascension. to open a closed book first.</p>
				<p>To invoke: hold the book and use it upon the blood rune. The rune will react to the book and to any <b>inscribed paper</b> within three tiles (it does not read blood written on the floor); each such inscription that matches a known spell will trigger that working. The Demonomicon (and the rune when used with it) recognises both &ldquo;book&rdquo; and &ldquo;knife&rdquo; spells and routes them accordingly. Alternatively, use the <b>ritual knife</b> upon the rune to invoke only those spells that are of the knife (see tables).</p>
				<p>To <b>inscribe a scroll</b>: see Section VIII for the full step-by-step.</p>
				<h2>V. The Tongues (Babel &amp; Voice)</h2>
				<p>Many rituals require that the caster know the tongue of the art. <b>Babel.</b> (3 candles) opens the Cult tongue to the mind; it costs twenty-five measures of blood, weakens the body, and carries a toll upon sanity and stability. <b>Voice.</b> (3 candles, knife only) grants the Occult tongue&mdash;a hive-like speech shared across distance with others who know it. Without one or both of these, most spells will not fire; the tome often says &ldquo;able_to_cast&rdquo; in the inner script, meaning the check for Cult or Occult.</p>
				</div>

				<hr>

				<div class="page">
				<h2>VI. Spells Invoked by the Book (or Demonomicon)</h2><p>Invoke the rune with a book; the inscribed spell name must be of the &ldquo;book&rdquo; kind. Minimum candles and blood cost per spell:</p>
				<table>
				<thead><tr><th>Spell name</th><th class="candles">Candles</th><th class="candles">Blood</th><th>Effect (summary)</th></tr></thead>
				<tbody>
				<tr><td class="spell">Babel.</td><td class="candles">3</td><td class="candles">25</td><td>Learn Cult language; heavy cost to body and sanity.</td></tr>
				<tr><td class="spell">Ignorance.</td><td class="candles">1</td><td class="candles">25</td><td>Harden the mind against psionics; blocks your own psionics.</td></tr>
				<tr><td class="spell">Flux.</td><td class="candles">1</td><td class="candles">25</td><td>Increase bluespace entropy; stronger if you know Cult and Occult.</td></tr>
				<tr><td class="spell">Negentropy.</td><td class="candles">1</td><td class="candles">30</td><td>Decrease bluespace entropy and raise the hazard threshold.</td></tr>
				<tr><td class="spell">Life.</td><td class="candles">5</td><td class="candles">18&#8211;25</td><td>Revive a dead animal upon the rune; it becomes bound and weakened.</td></tr>
				<tr><td class="spell">Madness.</td><td class="candles">3</td><td class="candles">10</td><td>Weaken the body and induce a sanity breakdown.</td></tr>
				<tr><td class="spell">Sight.</td><td class="candles">3</td><td class="candles">75</td><td>Remove nearsightedness and blindness.</td></tr>
				<tr><td class="spell">Paradox.</td><td class="candles">7</td><td class="candles">50</td><td>Extreme cost: explosion at the rune, often fatal.</td></tr>
				<tr><td class="spell">The End.</td><td class="candles">1</td><td class="candles">75</td><td>Strip Cult and Occult from the mind; purge blood-magic gifts.</td></tr>
				<tr><td class="spell">Brew.</td><td class="candles">2</td><td class="candles">25</td><td>Grant the Alchemist perk; mutually exclusive with Scribe and Binder.</td></tr>
				<tr><td class="spell">Recipe.</td><td class="candles">1</td><td class="candles">10</td><td>Alchemist only: turn paper into alchemy recipe paper.</td></tr>
				<tr><td class="spell">Bees.</td><td class="candles">4</td><td class="candles">18 each</td><td>Turn sunflowers in range into wasps.</td></tr>
				<tr><td class="spell">Sky.</td><td class="candles">1</td><td class="candles">70</td><td>Transform an open Omega book or this Demonomicon into a Drawing of the Sun (skill-cap oddity).</td></tr>
				<tr><td class="spell">Scribe.</td><td class="candles">7</td><td class="candles">50</td><td>Grant the Scribe perk; requires paper on rune; for scrolls only; mutually exclusive with Alchemist and Binder.</td></tr>
				<tr><td class="spell">Binder.</td><td class="candles">7</td><td class="candles">30</td><td>Grant the Tome Binder perk; requires paper on rune; for creating tomes. Mutually exclusive with Scribe and Alchemist.</td></tr>
				<tr><td class="spell">Pouch.</td><td class="candles">2</td><td class="candles">25</td><td>Turn a dice bag on the rune into a shared blood pouch.</td></tr>
				<tr><td class="spell">Escape.</td><td class="candles">1</td><td class="candles">18</td><td>Remove the caster from the world; leave a mirror fragment.</td></tr>
				<tr><td class="spell">Awaken.</td><td class="candles">7</td><td class="candles">50</td><td>Evolve ritual knife to bloodletter, then to full blade.</td></tr>
				<tr><td class="spell">Satchel.</td><td class="candles">5</td><td class="candles">25</td><td>Alchemist only: turn a pouch into an alchemy satchel.</td></tr>
				<tr><td class="spell">Cessation.</td><td class="candles">1+</td><td class="candles">&#189;&#215; candles</td><td>Remove the caster from the world for a time; duration scales with candles.</td></tr>
				</tbody></table>
				<p>Tome spells (Fireball., Smoke., Blind., etc.) are invoked the same way but create thematic tomes; see <b>Section XI. Tomes</b>.</p>
				</div>

				<hr>

				<div class="page">
				<h2>VII. Spells of the Knife Only</h2><p>Invoke the rune with the <b>ritual knife</b> (or the Demonomicon, which also routes knife spells). Minimum candles and blood cost per spell:</p>
				<table>
				<thead><tr><th>Spell name</th><th class="candles">Candles</th><th class="candles">Blood</th><th>Effect (summary)</th></tr></thead>
				<tbody>
				<tr><td class="spell">Voice.</td><td class="candles">3</td><td class="candles">25</td><td>Learn Occult language.</td></tr>
				<tr><td class="spell">Drain.</td><td class="candles">5</td><td class="candles">35</td><td>Consume a corpse in sight to restore health and max health (with instability cost).</td></tr>
				<tr><td class="spell">Cards To Life.</td><td class="candles">3</td><td class="candles">25</td><td>Turn a Carp card on the rune into a creature or item (pelt&rarr;scroll pouch, warren&rarr;burrow).</td></tr>
				<tr><td class="spell">Life To Cards.</td><td class="candles">3</td><td class="candles">8 or 25</td><td>Turn a creature on the rune into a death card.</td></tr>
				<tr><td class="spell">Cards.</td><td class="candles">3</td><td class="candles">5</td><td>Turn camera film on the rune into a random Carp card.</td></tr>
				<tr><td class="spell">Equalize.</td><td class="candles">6</td><td class="candles">10&#215; (max 40)</td><td>Pool and equalise blood percentage among all humans in view.</td></tr>
				<tr><td class="spell">Scroll.</td><td class="candles">7</td><td class="candles">25</td><td>Consume a dead animal on the rune to create a blank scroll.</td></tr>
				<tr><td class="spell">Blood Party.</td><td class="candles">4</td><td class="candles">varies</td><td>Sacrifice plushies and nutrition for temporary stat bonuses.</td></tr>
				<tr><td class="spell">Cessation.</td><td class="candles">1+</td><td class="candles">&#189;&#215; candles</td><td>As in Book spells.</td></tr>
				<tr><td class="spell">Fountain.</td><td class="candles">7</td><td class="candles">50</td><td>Turn a water tank on the rune into a blood basin (blood well for writing).</td></tr>
				<tr><td class="spell">Ascension.</td><td class="candles">7</td><td class="candles">40</td><td>Open a closed Omega or Unholy book and transform it into its opened, empowered form.</td></tr>
				<tr><td class="spell">Veil.</td><td class="candles">5</td><td class="candles">40</td><td>Turn a blindfold on the rune into an enchanted blindfold (vision aid in dark).</td></tr>
				<tr><td class="spell">Caprice.</td><td class="candles">3</td><td class="candles">5&#8211;10 per rune</td><td>Convert blood runes in view to trap runes; with tongues, may send them to maints or deepmaint.</td></tr>
				<tr><td class="spell">Mightier.</td><td class="candles">3</td><td class="candles">25</td><td>Create throwing projectiles that grow stronger the lower your max health.</td></tr>
				</tbody></table>
				</div>

				<hr>

				<div class="page">
				<h2>VIII. Scrolls &amp; Traps</h2>
				<h3>How to create and use scrolls</h3>
				<ol>
				<li><b>Become a Scribe.</b> At a blood rune, use a book (or this tome) with at least <b>7 candles</b> and a <b>paper</b> on the rune. Inscribe <i>Scribe.</i> in blood or on paper, then invoke. You gain the Scribe perk (once).</li>
				<li><b>Create blank scrolls.</b> At a blood rune, use the <b>ritual knife</b> with at least <b>7 candles</b>. Place a <b>dead animal</b> (superior or simple) on the rune. Inscribe <i>Scroll.</i> in blood or on paper, then invoke. The corpse is consumed and a blank scroll appears.</li>
				<li><b>Inscribe a scroll.</b> Write one of the scroll spell names below (e.g. <i>Mist.</i>) in <b>blood on the floor</b> or on <b>paper with a pen</b>. Place it within <b>3 tiles</b> of a blood rune. You must be <b>blind</b> (or wear a blindfold)&#8212;the ritual requires working by touch alone. Use the <b>blank scroll</b> on the rune. The rune and one inscription are consumed; the scroll now bears that spell.</li>
				<li><b>Use the scroll.</b> Burn it with a <b>lighter or welding tool</b> to cast the spell; the scroll is consumed. Seal with bee wax to carry safely; unseal before burning.</li>
				</ol>
				<p>Scroll spell names (inscribe exactly, then burn to cast). Blood cost is paid when the scroll is burned:</p>
				<table>
				<thead><tr><th>Scroll spell name</th><th class="candles">Blood</th><th>Effect when burned</th></tr></thead>
				<tbody>
				<tr><td class="spell">Mist.</td><td class="candles">50</td><td>Create a blood rune at your feet that blocks laser beams.</td></tr>
				<tr><td class="spell">Shimmer.</td><td class="candles">50</td><td>Create a blood rune at your feet that blocks bullets (penetration still pierces).</td></tr>
				<tr><td class="spell">Smoke.</td><td class="candles">25</td><td>Create a smoke cloud around you (blood-magic dust).</td></tr>
				<tr><td class="spell">Oil.</td><td class="candles">12</td><td>Create a pool of flammable fuel at your feet.</td></tr>
				<tr><td class="spell">Floor Seal.</td><td class="candles">50</td><td>Repair and seal every floor tile in sight that is covered in liquid fuel; consumes the fuel.</td></tr>
				<tr><td class="spell">Light.</td><td class="candles">10</td><td>Create a glowing blood rune that gives off light.</td></tr>
				<tr><td class="spell">Gaia.</td><td class="candles">15</td><td>Those in view who do not know Cult or Occult are weakened; knowing the tongues reduces or reverses the effect.</td></tr>
				<tr><td class="spell">Eta.</td><td class="candles">15</td><td>Those in view who do not know the tongues are thrown backwards.</td></tr>
				<tr><td class="spell">Reveal.</td><td class="candles">10+</td><td>Grant yourself and others in range temporary thermal vision.</td></tr>
				<tr><td class="spell">Entangle.</td><td class="candles">10</td><td>Create a ring of silk anomalies around you that entangle mobs.</td></tr>
				<tr><td class="spell">Joke.</td><td class="candles">5&#8211;15</td><td>Everyone in range giggles, laughs, or groans; outcome affects sanity.</td></tr>
				<tr><td class="spell">Charger.</td><td class="candles">10</td><td>Spawn ball lightning anomalies in nearby tiles.</td></tr>
				</tbody></table>
				<p>Seal a scroll with bee wax to carry it safely; unseal before burning. Trap runes (blood runes converted by <b>Caprice.</b> or other means) may trigger scroll or rune effects on those who cross and do not speak the tongues.</p>
				<h2>IX. The Blood Basin</h2><p>Invoke <b>Fountain.</b> with a water tank adjacent to the rune to create a blood basin. Those who dip bare hands in it may gain bloody hands for writing, at a cost to insight. The basin is said to fill with blood; the script calls it an inkwell for writing in blood.</p>
				<h2>X. Alchemy</h2>
				<p>The art of binding and condensing liquids in the alembic is closed to all but those who have invoked <b>Brew.</b> at a blood rune (2 candles). <b>Alchemist, Scribe, and Tome Binder are mutually exclusive</b>&mdash;you may have only one of the three.</p>
				<h3>The Alembic</h3>
				<p>An <b>alembic</b> is an archaic alchemical still. Place it upon a surface (it may be secured with a wrench). Only an <b>alembic phial</b> may be inserted into it&mdash;no other flask or beaker will do. Reagents inside the phial do not react until the reaction is deliberately triggered at the alembic.</p>
				<ol>
				<li>Insert an <b>alembic phial</b> into the alembic (use the phial on it). Fill the phial with the desired reagents beforehand.</li>
				<li>Hold <b>Ctrl+Shift</b> and <b>click</b> on the alembic to <b>start the alchemical reaction</b>. You must have the Alchemist perk and be adjacent to the alembic.</li>
				<li>Hold <b>Alt</b> and <b>click</b> on the alembic to <b>remove the phial</b>, if any.</li>
				</ol>
				<h3>Vessels &amp; Tools</h3>
				<ul>
				<li><b>Alembic phial</b>: A small bulb-like bottle; the only vessel in which reagents can be mixed inside the alembic. It holds little liquid and does not react until the alembic is used to trigger the reaction.</li>
				<li><b>Throwing flask</b>: A fragile conical flask that can be filled with beneficial or harmful chemicals and thrown at a target; it shatters on impact and spills its contents.</li>
				<li><b>Alchemy satchel</b>: Obtained by invoking <b>Satchel.</b> at a rune (5 candles, Alchemist only) with a dice bag on the rune. A belt-worn satchel that holds throwing flasks and alembic phials; it must be opened before use.</li>
				</ul>
				<h3>Recipe Paper</h3>
				<p>Invoke <b>Recipe.</b> at a blood rune (1 candle, Alchemist only) with <b>paper</b> on the rune to turn it into <b>alchemy recipe paper</b>&mdash;a parchment that bears hints to alchemical compounds in the Cult tongue.</p>
				<h3>Full recipes</h3>
				<p>Each recipe is performed in an <b>alembic phial</b> inside the alembic. All ingredients are one part unless noted. Order does not matter; trigger the reaction at the alembic when the phial contains the correct mix.</p>
				<table>
				<thead><tr><th>Result</th><th>Ingredients (1 part each)</th></tr></thead>
				<tbody>
				<tr><td class="spell">Ironskin draught</td><td>Iron, tungsten, sodium chloride</td></tr>
				<tr><td class="spell">Noxious Sludge</td><td>Ammonia, carbon, sodium chloride</td></tr>
				<tr><td class="spell">Ocular Remedy</td><td>Water, carbon, sodium chloride</td></tr>
				<tr><td class="spell">Ichor of Health</td><td>Detox, viroputine, citalopram</td></tr>
				<tr><td class="spell">Nerevex</td><td>Detox, purger, citalopram</td></tr>
				<tr><td class="spell">Ch&rsquo;alla Volkn</td><td>Iron, silicon, sodium chloride</td></tr>
				<tr><td class="spell">Burning Oils</td><td>Oil, sodium chloride, iron</td></tr>
				<tr><td class="spell">Mental Salts</td><td>Gold, sodium chloride, milk</td></tr>
				<tr><td class="spell">Work Tonic</td><td>Milk, protein, egg</td></tr>
				<tr><td class="spell">Medvesila Brew</td><td>Protein, honey, ethanol</td></tr>
				<tr><td class="spell">Gwalch Liquor</td><td>Black pepper, milk, ethanol</td></tr>
				<tr><td class="spell">Vitaurum</td><td>Blood, gold, Ichor of Health (lively concoction)</td></tr>
				</tbody></table>
				<p><i>Ichor of Health</i> is made first (detox + viroputine + citalopram); then blood, gold, and one part Ichor of Health yield <i>Vitaurum</i>, said to revive beasts.</p>
				<h2>XI. Tomes</h2><p>A <b>scroll bag</b> holds scrolls, oddity books, and ritual tools (e.g. from the Cards To Life knife spell with a pelt). A <b>tome bag</b> holds the thematic tomes (Cinder Codex, Ember's Veil, and the like) and ritual items.</p>

				<p>The thematic tomes (Fireball, Smoke, Blindness, Mind Swap, Force Wall, Knock, Horses, Charge, Summons, Sacred Flame) can be found in <b>oddity caches</b> and <b>maintenance loot</b>, or <b>created by a Binder</b> at a blood rune. This Demonomicon may occasionally surface in a <b>library archival shelf</b> or among <b>random oddity piles</b> (at most one such copy per round from those sources). <b>Scribe, Alchemist, and Tome Binder are mutually exclusive</b>&#8212;you may have only one of the three.</p>
				<h3>How to create a tome (step-by-step)</h3>
				<ol>
				<li><b>Become a Binder.</b> At a blood rune, place <b>paper</b> on the rune. Place at least <b>7 candles</b> within three tiles. Inscribe <i>Binder.</i> in blood on the floor or on paper with a pen. Use the Demonomicon or an Omega/Unholy book (closed or opened) on the rune to invoke. You gain the Tome Binder perk once; this is required to create tomes. (You cannot take Binder if you already have Scribe or Alchemist.)</li>
				<li><b>Prepare the rune.</b> Draw a blood rune with the ritual knife (or use an existing one). Place at least <b>3 candles</b> within three tiles of the rune.</li>
				<li><b>Inscribe the tome name.</b> On <b>paper</b>, write exactly one of the spell names from the table below (case-sensitive, with a full stop). Use blood writing or a pen.</li>
				<li><b>Place the paper on the rune.</b> Put the inscribed paper on the same tile as the blood rune.</li>
				<li><b>Invoke with an opened book or the Demonomicon.</b> Only an <b>opened</b> Omega book, an <b>opened</b> Unholy book, or the <b>Demonomicon</b> can bind a tome. Use one of these on the rune. (A closed book will not work&#8212;use the Ascension. spell to open it first.) The rune consumes the paper and the ritual cost (3 candles); the corresponding <b>tome</b> appears at the rune. Each tome has a unique title, a unique author, and wondrous effects when read.</li>
				</ol>
				<h3>Tome creation chart</h3>
				<p>Inscribe on paper <i>exactly</i> one of the following (then place paper on rune, invoke with opened book or Demonomicon). One paper per tome; one tome per invocation. All require <b>3 candles</b>, <b>20 blood</b>, and the <b>Tome Binder</b> perk.</p>
				<table>
				<thead><tr><th>Inscribe on paper (exact)</th><th>Resulting tome</th><th class="candles">Candles</th><th class="candles">Blood</th><th>Effect (summary)</th></tr></thead>
				<tbody>
				<tr><td class="spell">Fireball.</td><td>The Cinder Codex</td><td class="candles">3</td><td class="candles">20</td><td>When read, may suffuse the reader with warmth and knit small hurts (heal brute &amp; fire).</td></tr>
				<tr><td class="spell">Smoke.</td><td>Ember&rsquo;s Veil</td><td class="candles">3</td><td class="candles">20</td><td>When read, may pour soot and vapour from the pages, weaving a brief obscuring veil.</td></tr>
				<tr><td class="spell">Blind.</td><td>The Oculus Obscura</td><td class="candles">3</td><td class="candles">20</td><td>When read, may clear the eyes and sharpen vigilance for a time.</td></tr>
				<tr><td class="spell">Mind Swap.</td><td>The Mirror of Else</td><td class="candles">3</td><td class="candles">20</td><td>When read, may cost sanity but grant expanded cognition for a time.</td></tr>
				<tr><td class="spell">Force Wall.</td><td>Bastion&rsquo;s Redoubt</td><td class="candles">3</td><td class="candles">20</td><td>When read, may harden the body like a wall (toughness &amp; robustness).</td></tr>
				<tr><td class="spell">Knock.</td><td>The Key That Was Lost</td><td class="candles">3</td><td class="candles">20</td><td>When read, may cause a nearby locked airlock to unbolt and open.</td></tr>
				<tr><td class="spell">Horses.</td><td>The Beast-Speaker&rsquo;s Covenant</td><td class="candles">3</td><td class="candles">20</td><td>When read, may turn one hostile beast in view friendly.</td></tr>
				<tr><td class="spell">Charge.</td><td>Volta&rsquo;s Testament</td><td class="candles">3</td><td class="candles">20</td><td>When read, may sharpen reflexes and alertness for a time.</td></tr>
				<tr><td class="spell">Summons.</td><td>The Muster of the Low Council</td><td class="candles">3</td><td class="candles">20</td><td>When read, may grant a lasting surge of vigour and readiness.</td></tr>
				<tr><td class="spell">Sacred Flame.</td><td>The Liturgy of the Absolute Flame</td><td class="candles">3</td><td class="candles">20</td><td>When read, the faithful may receive healing and sanity; the unfaithful may suffer sanity loss.</td></tr>
				</tbody></table>
				<h3>Sanity and the cost of reading</h3>
				<p>Every time you <b>read</b> a thematic tome (the Cinder Codex, Ember&rsquo;s Veil, the Oculus Obscura, and the rest), the working exacts a toll upon the mind: your <b>sanity</b> is drained (six when above half, two when below). The binding in those books is not inert; it answers the reader at a cost. So long as your sanity remains above <b>half</b> of its fullness, that cost is paid in sanity alone. Once your sanity has fallen <b>below half</b>, each reading also <b>draws blood</b> (twelve measures)&#8212;the tome begins to take from the body when the mind can no longer bear the full weight. Practitioners who read recklessly may find themselves both broken in spirit and drained of blood.</p>
				<p>Losing too much sanity is dangerous. A mind worn thin is more vulnerable to shock, to breakdown, and to the influence of the unnatural. Rest and stability can restore sanity, but the art of blood magic&#8212;and the use of the tomes it produces&#8212;steadily erodes it. Weigh each reading against your reserves. This Demonomicon itself obeys a harsher law: see <b>Section XII. On This Tome</b> for the price of using it.</p>
				<p><b>Flow summary:</b> Binder perk (once) &rarr; blood rune + 3 candles + 20 blood + paper inscribed with tome name on rune &rarr; use <b>opened</b> book or Demonomicon on rune &rarr; paper consumed, tome created.</p>
				<h2>XII. On This Tome</h2>
				<p>This Demonomicon is not a passive manual. <b>Using</b> it&mdash;reading it or invoking a rune with it&mdash;drains the bearer&rsquo;s sanity; the script weighs on the mind. When sanity falls <b>below a quarter</b> of its fullness, each such use also wounds the user (eight when reading, ten when invoking at a rune), weakens their constitution (reducing maximum vigour by three, to no less than thirty), and draws blood (six measures when reading, twelve when invoking), as the tome&rsquo;s grip tightens.</p>
				<p>Like certain anomalous curios, this tome may be used as an <b>inspiration</b> when insight is fulfilled: after resting and completing the prompt, choose &ldquo;Focus on an oddity&rdquo; and select the Demonomicon. Doing so grants stat growth (Cognition, Vigilance) and a single, lasting benefit&mdash;the <b>Bound to the Tome</b> perk&mdash;at a <b>grave expense</b>: the bond sharpens the mind but leaves it more vulnerable to shock and the world, and sanity recovers more slowly. Moreover, <b>each time</b> you focus upon this tome, it exacts a heavy toll in health, sanity, and blood. Weigh the cost before you bind yourself to its wisdom.</p>
				<p>Those <b>Bound to the Tome</b> find that blood rituals take a lesser toll upon the body: the <b>max health</b> paid when casting (Babel, Voice, Life, Brew, Scribe, and the like) is <b>quartered</b>&mdash;one fourth of the usual cost&mdash;so that the bond, for all its price, eases the sacrifice demanded by the art.</p>
				<blockquote>Thus is the art of blood magic set down: by rune, candle, and exact word. Let the practitioner take heed of the prohibitions and the price in blood and sanity.</blockquote>
				</div>

				</body>
				</html>
			"}

/obj/item/book/manual/demonomicon/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, 1, "")
	AddComponent(/datum/component/inspiration, list(STAT_COG = 5, STAT_VIG = 5, STAT_MEC = 3), /datum/perk/oddity/demonomicon, FALSE)
	RegisterSignal(src, COMSIG_ODDITY_USED, PROC_REF(on_focus_used))

/obj/item/book/manual/demonomicon/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		. += SPAN_NOTICE("The runes on the cover seem to shift when you look away. It feels heavier than it looks.")

/obj/item/book/manual/demonomicon/proc/on_focus_used()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return
	H.adjustBruteLoss(15)
	if(H.sanity)
		H.sanity.changeLevel(-25, TRUE)
	var/datum/reagent/organic/blood/B = H.get_blood()
	if(B)
		B.remove_self(10)
	to_chat(H, SPAN_DANGER("The Demonomicon exacts its price; your blood and sanity waver."))

/obj/item/book/manual/demonomicon/attack_self(mob/user)
	// Already open for this user: don't drain again or re-open (prevents spam for sanity/drain)
	if(current_reader == user)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sanity)
			// One-time sanity drain when opening
			if(H.sanity.level >= H.sanity.max_level * 0.25)
				H.sanity.changeLevel(-4, TRUE)
			else
				H.sanity.changeLevel(-2, TRUE)
			if(prob(35))
				to_chat(H, SPAN_WARNING("The script seems to shift on the page as you look away."))
			// Blood/health only when opening or using (e.g. at rune), not while the window is open
			if(H.sanity.level < H.sanity.max_level * 0.25)
				var/datum/reagent/organic/blood/B = H.get_blood()
				if(B)
					B.remove_self(6)
				H.adjustBruteLoss(8)
				H.maxHealth = max(30, H.maxHealth - 3)
				H.health = min(H.health, H.maxHealth)
				to_chat(H, SPAN_DANGER("The tome's grip on you tightens; your blood and vitality waver."))
	..()
	// Register so we get Topic when window is closed; drain sanity periodically while the window stays open
	if(dat && ishuman(user))
		var/mob/living/carbon/human/H = user
		onclose(H, "book", src)
		current_reader = H
		// Prevent passive sanity gain while reading so the tome's drain isn't cancelled out by regen
		if(H.sanity)
			saved_sanity_gain_multiplier = H.sanity.sanity_passive_gain_multiplier
			H.sanity.sanity_passive_gain_multiplier = 0
		schedule_reading_drain()

/obj/item/book/manual/demonomicon/proc/schedule_reading_drain()
	if(reading_drain_timer)
		deltimer(reading_drain_timer)
	reading_drain_timer = addtimer(CALLBACK(src, PROC_REF(drain_sanity_while_open)), 12 SECONDS, TIMER_STOPPABLE)

/obj/item/book/manual/demonomicon/proc/drain_sanity_while_open()
	if(!current_reader || !current_reader.sanity)
		current_reader = null
		return
	current_reader.sanity.changeLevel(-4, TRUE)
	if(current_reader)
		schedule_reading_drain()

/obj/item/book/manual/demonomicon/Topic(href, href_list)
	if(href_list["close"])
		if(current_reader && current_reader.sanity)
			current_reader.sanity.sanity_passive_gain_multiplier = saved_sanity_gain_multiplier
		current_reader = null
		if(reading_drain_timer)
			deltimer(reading_drain_timer)
			reading_drain_timer = null
		return
	return ..()
