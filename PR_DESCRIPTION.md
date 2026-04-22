<!-- Write **BELOW** The Headers and **ABOVE** The comments else it may not be viewable. -->
<!-- You can view Contributing.MD for a detailed description of the pull request process. -->

## About The Pull Request
<details>
<summary>
	About The Pull Request
</summary>
<hr>

This PR brings the **master** branch up to date with the new Iskhod Colony and all associated map, gameplay, and tooling changes from **map-2**.

**Authors:** addi-4th, MsRandylicious, Yeen

**Map & layout**
- New **Iskhod Colony** map (`_Iskhod_Colony.dmm`) and area definitions; colony renamed from Nadezhda to Iskhod Outpost.
- **Iskhod Deep Tunnels** map; **Excel Compound** (`Isk_ExcelCompound.dmm`); **Isk mines** and **space port**; **Deep Forest** integration and POIs (e.g. Greyson field office, prepper bunker, river forest).
- Turbolifts and elevators (including mines); holodeck; cryogenics; disposals and telesci additions; snow/outdoor tiles and compound addition.
- CentCom map and shuttle/space updates; winter Nadezhda variants retained where used.

**Atmospherics & power**
- Vent pump and scrubber behaviour; map gas and atmos fixes; airless-tile and initial-gas fixes.
- Supermatter chamber, alarm, and delam handling; SM alarm sound and matter alarm sound added.
- APC and power fixes across colony, mining outpost, research outpost, toxins, and HVAC; wiring fixes.

**Jobs, outfits & roles**
- Major job and role changes; Ranger uniforms and loadout; security, medical, civilian, and science outfit updates; Marqua outfit additions.
- Spawnable roles and loadout tweaks; Corpsman disabled/removed; outsider spawn and ID fixes; crew manifest and TGUI department updates.

**Gameplay & systems**
- Species-specific blood (“the great bloodening”); new organs and organ code (including Cindarite/Marqua organ sprites); organ rejection and mycus-related fixes.
- Hunger system fixes and tuning; economy changes (eftpos locking, medical economy, receipt fix).
- Prospector and xenoarch fixes; GPS fixes; xenobot and xenoflora fixes.
- Grid check, prison break, and other event tweaks; supermatter observation/status.

**UI, TGUI & misc**
- Crew manifest and Discord manifest fixes; ID card TGUI; department colours and CrewManifest styling.
- HUD and statpanel updates; new player and late-join flow tweaks.

**Content & assets**
- New icons/sprites (ranger service uniform, organs, Ladon, marqua pistol, decals, etc.); engine and xenoarch sprites adjusted.
- News articles and flavour text (e.g. Ranger communique); narrative/content updates.

**Tools & infra**
- Changelog generation: GitHub workflow, `generate_cl.py` (merged-PR-only, `--base`/`--repo`/`--verbose`), `describe_pr_changes.py` (PR reports, optional AI descriptions), sync scripts; changelog HTML/footer.
- BYOND update admin verb and `tools/byond_update.py` for server ops.
- Config, ticker, licences, and `.dme` updates for the above.

<hr>
</details>

## Changelog
:cl: addi-4th, MsRandylicious, Yeen
add: New Iskhod Colony map; colony renamed to Iskhod Outpost.
add: Iskhod Deep Tunnels, Excel Compound, Isk mines, and space port maps.
add: Deep Forest integration with POIs: Greyson field office, prepper bunker, river forest, and related areas.
add: Turbolifts and elevators across the colony and to the mines.
add: Holodeck and cryogenics on the colony; disposals and telesci additions.
add: Snow and outdoor tiles; compound and winter map variants where applicable.
add: Species-specific blood for each species ("the great bloodening").
add: New organ system with Cindarite and Marqua organ sprites and organ bay assets.
add: Ranger uniforms and loadout; Ranger service uniform sprites.
add: Major job and role changes; spawnable roles and loadout tweaks.
add: Security, medical, civilian, and science outfit updates; Marqua outfit additions.
add: Supermatter alarm and delam handling; new SM and matter alarm sounds.
add: Vent pump and scrubber behaviour improvements; atmos and map gas fixes.
add: Changelog generation from PRs (GitHub Actions + local tools).
add: BYOND update admin verb for server ops.
tweak: Hunger system and hunger factor for humans; food and cold interaction.
tweak: Economy: eftpos locking, medical economy, and receipt handling.
tweak: Prospector and xenoarchaeology behaviour; GPS and xenobot fixes.
tweak: Crew manifest and Discord manifest; ID card TGUI and department colours.
tweak: Grid check, prison break, and other events; supermatter observation/status.
tweak: Corpsman disabled/removed; outsider spawn and ID fixes.
fix: Atmos, airless tiles, and initial gas across the colony.
fix: APC and power across colony, mining outpost, research outpost, toxins, and HVAC.
fix: Wiring and power draw fixes; elevator and turbolift behaviour.
fix: Organ rejection and mycus-related behaviour; xenoflora fixes.
fix: Numerous mapping errors and runtime fixes.
soundadd: Supermatter alarm sound.
soundadd: Matter alarm sound.
imageadd: Ranger service uniform and Ranger-related sprites.
imageadd: Organ bay and Cindarite/Marqua organ sprites.
imageadd: Ladon and marqua pistol sprites; decals and flooring updates.
imageadd: Engine and xenoarch sprite adjustments.
code: Changelog generator (merged PRs only, base-branch filter, verbose option) and describe-PR tool.
code: Various code cleanups and config updates.
/:cl:

<!-- Both :cl:'s are required for the changelog to work! You can put your name to the right of the first :cl: if you want to overwrite your GitHub username as author ingame. -->
<!-- You can use multiple of the same prefix (they're only used for the icon ingame) and delete the unneeded ones. Despite some of the tags, changelogs should generally represent how a player might be affected by the changes rather than a summary of the PR's contents. -->
