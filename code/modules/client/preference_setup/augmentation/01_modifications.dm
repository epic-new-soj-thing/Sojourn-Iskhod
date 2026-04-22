/datum/preferences
	/// Limbs & outer body — full-width category (same UI row as eyes/organs).
	var/global/list/augmentation_limbs_row = list(
		BP_HEAD, BP_R_ARM, BP_R_LEG, BP_L_ARM, BP_GROIN, BP_L_LEG,
	)
	/// Eyes & internal organs — full-width category below limbs.
	var/global/list/augmentation_internal_row = list(
		BP_EYES, OP_HEART, OP_KIDNEY_LEFT, OP_KIDNEY_RIGHT, OP_STOMACH, BP_BRAIN, OP_LUNGS, OP_LIVER, OP_APPENDIX,
	)
	var/list/modifications_data   = list()
	var/list/modifications_colors = list()
	var/current_organ = BP_HEAD

/datum/category_item/player_setup_item/augmentation/modifications
	name = "Augmentation"
	sort_order = 1

/datum/category_item/player_setup_item/augmentation/modifications/load_character(var/savefile/S)
	from_file(S["modifications_data"], pref.modifications_data)
	from_file(S["modifications_colors"], pref.modifications_colors)

/datum/category_item/player_setup_item/augmentation/modifications/save_character(var/savefile/S)
	to_file(S["modifications_data"], pref.modifications_data)
	to_file(S["modifications_colors"], pref.modifications_colors)

/datum/category_item/player_setup_item/augmentation/modifications/sanitize_character()
	if(!pref.modifications_data)
		pref.modifications_data = list()

	if(!pref.modifications_colors)
		pref.modifications_colors = list()

	pref.modifications_data -= "chest2"
	pref.modifications_colors -= "chest2"

	var/list/all_tags = pref.augmentation_limbs_row | pref.augmentation_internal_row
	if(!(pref.current_organ in all_tags))
		pref.current_organ = BP_HEAD

	for(var/tag in all_tags)
		if(!iscolor(pref.modifications_colors[tag]))
			pref.modifications_colors[tag] = "#000000"


/datum/category_item/player_setup_item/augmentation/modifications/proc/optgroup_for_mod(var/datum/body_modification/BM)
	if(istype(BM, /datum/body_modification/none))
		return "Normal"
	if(istype(BM, /datum/body_modification/limb/amputation))
		return "Removed"
	if(istype(BM, /datum/body_modification/limb/prosthesis))
		return "Prostheses"
	if(istype(BM, /datum/body_modification/organ/robotize_organ))
		return "Robotic organ"
	return "Mutations & other"

/// Sort list of dict-like lists with "name" key (stable enough for small lists).
/datum/category_item/player_setup_item/augmentation/modifications/proc/sort_entries_by_name(list/entries)
	var/list/out = entries.Copy()
	var/len = out.len
	for(var/i = 1 to len)
		for(var/j = i + 1 to len)
			var/list/a = out[i]
			var/list/b = out[j]
			if(a && b && sorttext(a["name"], b["name"]) > 0)
				out.Swap(i, j)
	return out

/// Escape text for use inside a double-quoted HTML attribute.
/datum/category_item/player_setup_item/augmentation/modifications/proc/attr_encode(var/t)
	if(!t)
		return ""
	return html_encode(t)

/datum/category_item/player_setup_item/augmentation/modifications/proc/build_modification_select()
	var/list/group_order = list("Normal", "Removed", "Prostheses", "Robotic organ", "Mutations & other")
	var/list/group_lists = list()
	for(var/g in group_order)
		group_lists[g] = list()

	for(var/id in body_modifications)
		var/datum/body_modification/BM = body_modifications[id]
		if(!(pref.current_organ in BM.body_parts))
			continue
		var/g = optgroup_for_mod(BM)
		var/allowed = TRUE
		if(pref.can_access_modifications())
			allowed = BM.is_allowed(pref.current_organ, pref, pref.mannequin, TRUE)
		group_lists[g] += list(list("id" = id, "name" = BM.name, "allowed" = allowed))

	var/list/html = list()
	html += "<select id=\"aug_mod_select\" style=\"width:100%;max-width:220px\" size=\"1\" onchange=\"augApplyModification(this);\">"

	var/datum/body_modification/current = pref.get_modification(pref.current_organ)
	var/cur_id = current?.id

	for(var/g in group_order)
		var/list/entries = sort_entries_by_name(group_lists[g])
		if(!length(entries))
			continue
		html += "<optgroup label=\"[html_encode(g)]\">"
		for(var/entry in entries)
			var/list/E = entry
			if(!E)
				continue
			var/sel = (E["id"] == cur_id) ? " selected" : ""
			var/dis = E["allowed"] ? "" : " disabled"
			var/label = E["name"]
			if(!E["allowed"])
				label += " (unavailable)"
			var/datum/body_modification/BM = body_modifications[E["id"]]
			var/desc_txt = BM?.desc
			if(!desc_txt)
				desc_txt = BM?.short_name
			if(!desc_txt)
				desc_txt = label
			html += "<option value=\"[E["id"]]\" data-desc=\"[attr_encode(desc_txt)]\"[sel][dis]>[html_encode(label)]</option>"
		html += "</optgroup>"

	html += "</select>"
	return jointext(html, null)

/datum/category_item/player_setup_item/augmentation/modifications/proc/get_implant_item()
	if(!category || !category.items)
		return null
	for(var/datum/category_item/player_setup_item/PI in category.items)
		if(istype(PI, /datum/category_item/player_setup_item/augmentation/implant))
			return PI
	return null

/// Inline core implant picker (same data as the old options popup, themed for chargen).
/datum/category_item/player_setup_item/augmentation/modifications/proc/build_core_implant_section(var/mob/user)
	var/datum/category_item/player_setup_item/augmentation/implant/I = get_implant_item()
	if(!I || !I.option_category)
		return ""
	var/list/dat = list()
	dat += "<table class=\"aug_implant\" style=\"width:100%;table-layout:fixed;border-collapse:collapse;margin-top:12px;border-top:1px solid #40628a;\"><tr style=\"vertical-align:top\">"
	dat += "<td style=\"width:34%;padding:10px 10px 0 0;\"><b>Core implant</b><br>"
	var/datum/category_item/setup_option/current = I.get_pref_option()
	for(var/datum/category_item/setup_option/option in I.get_options())
		if(LAZYLEN(option.restricted_to_species) > 0)
			if(!LAZYISIN(option.restricted_to_species, pref.species))
				continue
		var/icon/IC = option.get_icon()
		if(IC)
			user << browse_rsc(IC, "option_[option].png")
		var/img = IC ? "<img style=\"vertical-align:middle;\" src=\"option_[option].png\"/> " : ""
		if(option == current)
			dat += "<span class=\"linkOn[img ? " icon" : ""]\">[img][option]</span><br>"
		else
			dat += "<a href='?src=\ref[src];implant_pick=[url_encode(option.name)]'[img ? " class='icon'" : ""]>[img][option]</a><br>"
	dat += "</td><td style=\"padding:10px 0 0 0;\">"
	if(current)
		dat += "<b>[current]</b><br>[current.desc]<br>"
		if(current.stat_modifiers.len)
			dat += "<br>Stats:<br>"
			for(var/stat in current.stat_modifiers)
				dat += "[stat] [current.stat_modifiers[stat]]<br>"
		if(current.restricted_jobs.len)
			dat += "<br>Restricted jobs:<br>"
			for(var/job in current.restricted_jobs)
				var/datum/job/J = job
				dat += "[initial(J.title)]<br>"
		if(current.perks.len)
			dat += "<br>Perks:<br>"
			for(var/perk in current.perks)
				var/datum/perk/P = perk
				dat += "[initial(P.name)]<br>"
		if(current.allowed_jobs.len)
			dat += "<br>Special jobs:<br>"
			for(var/job in current.allowed_jobs)
				var/datum/job/J = job
				dat += "[initial(J.title)]<br>"
		if(!current.allow_modifications)
			dat += "<br><i>Body augmentation disabled for this implant.</i><br>"
	dat += "</td></tr></table>"
	return jointext(dat, null)

/datum/category_item/player_setup_item/augmentation/modifications/content(var/mob/user)
	if(!pref.preview_icon)
		pref.update_preview_icon(naked = TRUE)
	if ((pref.preview_dir== EAST) && (!pref.preview_east))
		pref.mannequin = get_mannequin(pref.client_ckey)
		pref.mannequin.delete_inventory(TRUE)
		if(SSticker.current_state > GAME_STATE_STARTUP)
			pref.dress_preview_mob(pref.mannequin, TRUE)
		pref.mannequin.dir = EAST
		pref.preview_east = getFlatIcon(pref.mannequin, EAST)
		pref.preview_east.Scale(pref.preview_east.Width() * 2, pref.preview_east.Height() * 2)
		user << browse_rsc(pref.preview_east, "new_previewicon[EAST].png")

	if(pref.preview_north && pref.preview_south  && pref.preview_west)
		user << browse_rsc(pref.preview_north, "new_previewicon[NORTH].png")
		user << browse_rsc(pref.preview_south, "new_previewicon[SOUTH].png")
		user << browse_rsc(pref.preview_west, "new_previewicon[WEST].png")

	var/dat = list()

	dat += "<style type=\"text/css\">"
	dat += ".aug_wrap{font-family:Verdana,Geneva,sans-serif;font-size:12px;max-width:920px;margin:0 auto;}"
	dat += ".aug_main_table{width:100%;table-layout:fixed;border-collapse:separate;border-spacing:6px;}"
	dat += ".aug_preview_cell{text-align:center;vertical-align:top;padding:4px 8px;}"
	dat += ".aug_preview_cell img{border:1px solid #40628a;background:#000;padding:4px;}"
	dat += ".aug_detail_row{background:#000;border:1px solid #40628a;padding:10px 12px;margin-top:6px;}"
	dat += ".aug_category_row{padding:10px 4px 4px 4px;line-height:1.65;margin-top:6px;}"
	dat += ".aug_detail_row+.aug_category_row{border-top:1px solid #40628a;margin-top:10px;padding-top:12px;}"
	dat += "span.color_holder_box{display:inline-block;width:20px;height:12px;border:1px solid #161616;padding:0;vertical-align:middle;margin-left:6px;}"
	dat += "#aug_live_desc{margin-top:8px;padding:8px 10px;background:#000;border:1px solid #40628a;min-height:2.5em;font-size:11px;line-height:1.45;white-space:pre-wrap;}"
	dat += ".aug_color_row{margin-top:8px;padding-top:6px;border-top:1px solid #40628a;}"
	dat += "</style>"

	dat += "<script language='javascript'>[js_byjax]"
	dat += "function set(param,value){window.location='?src=\ref[src];'+param+'='+value;}"
	// Use options.item(...) instead of [x.selectedIndex] so DM never sees "[x" (embedded expr)
	dat += "function augApplyModification(x){var opt=x.options.item(x"
	dat += ".selectedIndex);if(!opt)return;var el=document.getElementById('aug_live_desc');if(el){var d=opt.getAttribute('data-desc');el.textContent=d?d:'';}"
	dat += "if(opt.value&&!opt.disabled)set('body_modification',opt.value);}"
	dat += "</script>"

	dat += "<div class=\"aug_wrap\">"
	dat += "<table class=\"aug_main_table\"><tr><td class=\"aug_preview_cell\"><b>Preview</b><br>"
	dat += "<img src=new_previewicon[pref.preview_dir].png width=96 height=96 alt=\"Character preview\">"
	dat += "<div class=\"aug_rotate\"><a href='?src=\ref[src];rotate=right'>&#9664;</a>"
	dat += "<a href='?src=\ref[src];rotate=left'>&#9654;</a></div></td></tr></table>"

	dat += "<div class=\"aug_category_row\"><b>Limbs &amp; body</b><br>"
	for(var/organ in pref.augmentation_limbs_row)
		dat += build_organ_row(organ, TRUE)
	dat += "</div>"

	dat += "<div class=\"aug_detail_row\">"
	var/organ_title = capitalize(organ_tag_to_name[pref.current_organ] || "organ")
	var/datum/body_modification/mod_preview = pref.get_modification(pref.current_organ)
	var/initial_desc = ""
	if(mod_preview)
		initial_desc = mod_preview.desc ? mod_preview.desc : mod_preview.short_name

	dat += "<b>[html_encode(organ_title)]</b> — choose a modification for this region."
	if(pref.can_access_modifications())
		dat += "<br><br>"
		dat += build_modification_select()
		dat += "<div id=\"aug_live_desc\">[html_encode(initial_desc)]</div>"
		if(mod_preview?.hascolor)
			dat += "<div class=\"aug_color_row\"><a href='?src=\ref[src];color=[url_encode(pref.current_organ)]'>Eye / organ color</a>"
			dat += "<a href='?src=\ref[src];color=[url_encode(pref.current_organ)]' title=\"Pick color\"><span class=\"color_holder_box\" style=\"background-color:[pref.modifications_colors[pref.current_organ]]\"></span></a></div>"
	else
		dat += "<br><br><i>Body modifications are disabled for your current setup.</i>"

	dat += "</div>"

	dat += "<div class=\"aug_category_row\"><b>Eyes &amp; internal organs</b><br>"
	for(var/organ in pref.augmentation_internal_row)
		dat += build_organ_row(organ, TRUE)
	dat += "</div>"

	dat += build_core_implant_section(user)
	dat += "</div>"

	return jointext(dat,null)

/datum/category_item/player_setup_item/augmentation/modifications/proc/build_organ_row(var/organ, var/inline=FALSE)
	var/list/dat = list()
	var/datum/body_modification/mod = pref.get_modification(organ)
	var/organ_name = capitalize(organ_tag_to_name[organ] || organ)
	var/disp = mod ? mod.short_name : "Nothing"
	var/enc = url_encode(organ)
	var/title = "Select [organ_name]. Current: [disp]"
	var/inner
	if(!pref.can_access_modifications())
		inner = "<span class=\"linkOff\">[organ_name]: [html_encode(disp)]</span>"
	else if(organ == pref.current_organ)
		inner = "<a class=\"linkOn Organs_active\" href='?src=\ref[src];organ=[enc]' title=\"[attr_encode(title)]\">[organ_name]: [html_encode(disp)]</a>"
	else
		inner = "<a href='?src=\ref[src];organ=[enc]' title=\"[attr_encode(title)]\">[organ_name]: [html_encode(disp)]</a>"
	if(inline)
		dat += "<span style=\"display:inline-block;margin:2px 10px 2px 0;white-space:nowrap;\">[inner]</span>"
	else
		dat += "<div style=\"margin:3px 0;\">[inner]</div>"
	return jointext(dat, null)


/datum/preferences/proc/modifications_allowed()
	for(var/category in setup_options)
		if(!get_option(category))
			continue
		var/datum/category_item/setup_option/option = get_option(category)
		if(!option)
			CRASH("Option [category] could not be found through get_option()")
		if(!option.allow_modifications)
			return FALSE
	return TRUE

/datum/preferences/proc/can_access_modifications()
	// Check if modifications are normally allowed
	if(modifications_allowed())
		return TRUE

	// Check if psions should be allowed to access modifications
	var/datum/category_item/setup_option/core_implant/core_implant_option = get_option("Core implant")
	if(core_implant_option && (core_implant_option.implant_organ_type == "psionic tumor" || core_implant_option.implant_organ_type == "cultured tumor"))
		return TRUE

	return FALSE

/datum/preferences/proc/get_modification(var/organ)
	// Allow psions and normally allowed players to access modifications
	if(!can_access_modifications())
		return new/datum/body_modification/none
	if(!organ || !modifications_data[organ])
		return new/datum/body_modification/none
	return modifications_data[organ]

/datum/preferences/proc/check_child_modifications(var/organ = BP_CHEST)
	var/list/organ_data = organ_structure[organ]
	if(!organ_data)
		return
	var/datum/body_modification/mod = get_modification(organ)
	for(var/child_organ in organ_data["children"])
		var/datum/body_modification/child_mod = get_modification(child_organ)
		if(child_mod.nature < mod.nature)
			if(mod.is_allowed(child_organ, src, null, TRUE))
				modifications_data[child_organ] = mod
			else
				modifications_data[child_organ] = get_default_modificaton(mod.nature)
			check_child_modifications(child_organ)
	return

/datum/category_item/player_setup_item/augmentation/modifications/OnTopic(var/href, list/href_list, mob/user)
	pref.categoriesChanged = "Augmentation"
	if(href_list["organ"])
		pref.current_organ = href_list["organ"]
		return TOPIC_REFRESH

	else if(href_list["color"])
		var/organ = href_list["color"]
		if(!pref.modifications_colors[organ])
			pref.modifications_colors[organ] = "#FFFFFF"
		var/new_color = input(user, "Choose color for [organ_tag_to_name[organ]]: ", "Character Preference", pref.modifications_colors[organ]) as color|null
		if(new_color && pref.modifications_colors[organ]!=new_color)
			pref.modifications_colors[organ] = new_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["body_modification"])
		var/datum/body_modification/mod = body_modifications[href_list["body_modification"]]
		if(mod && mod.is_allowed(pref.current_organ, pref))
			pref.modifications_data[pref.current_organ] = mod
			pref.check_child_modifications(pref.current_organ)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["implant_pick"])
		var/datum/category_item/player_setup_item/augmentation/implant/implant_item = get_implant_item()
		if(implant_item && implant_item.set_pref(href_list["implant_pick"]))
			return TOPIC_REFRESH_UPDATE_PREVIEW
		return TOPIC_NOACTION

	else if(href_list["rotate"])
		if(href_list["rotate"] == "right")
			pref.preview_dir = turn(pref.preview_dir,-90)
		else
			pref.preview_dir = turn(pref.preview_dir,90)
		if ((pref.preview_dir == EAST) && (!pref.preview_east))
			pref.mannequin = get_mannequin(pref.client_ckey)
			pref.mannequin.delete_inventory(TRUE)
			if(SSticker.current_state > GAME_STATE_STARTUP)
				pref.dress_preview_mob(pref.mannequin, TRUE)
			pref.mannequin.dir = EAST
			pref.preview_east = getFlatIcon(pref.mannequin, EAST)
			pref.preview_east.Scale(pref.preview_east.Width() * 2, pref.preview_east.Height() * 2)
			user << browse_rsc(pref.preview_east, "new_previewicon[EAST].png")

		return TOPIC_REFRESH

	return ..()
