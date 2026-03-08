/datum/preferences
	var/master_volume = 100		// 0-100, overall multiplier for all sound categories
	var/music_volume = 100		// 0-100, admin midi and lobby music
	var/media_volume = 100			// 0-100, jukebox / area media
	var/instrument_volume = 100	// 0-100, synthesized instruments
	var/media_player = 2		// 0 = VLC, 1 = WMP, 2 = HTML5, 3+ = unassigned

/datum/category_item/player_setup_item/player_global/media
	name = "Media"
	sort_order = 6

/datum/category_item/player_setup_item/player_global/media/load_preferences(var/savefile/S)
	S["master_volume"]	>> pref.master_volume
	S["music_volume"]	>> pref.music_volume
	S["media_volume"]	>> pref.media_volume
	S["instrument_volume"]	>> pref.instrument_volume
	S["media_player"]	>> pref.media_player

/datum/category_item/player_setup_item/player_global/media/save_preferences(var/savefile/S)
	S["master_volume"]	<< pref.master_volume
	S["music_volume"]	<< pref.music_volume
	S["media_volume"]	<< pref.media_volume
	S["instrument_volume"]	<< pref.instrument_volume
	S["media_player"]	<< pref.media_player

/datum/category_item/player_setup_item/player_global/media/sanitize_preferences()
	pref.master_volume = isnum(pref.master_volume) ? CLAMP(pref.master_volume, 0, 100) : initial(pref.master_volume)
	pref.music_volume = isnum(pref.music_volume) ? CLAMP(pref.music_volume, 0, 100) : initial(pref.music_volume)
	// Migrate old 0-1 savefile value to 0-100
	if(isnum(pref.media_volume) && pref.media_volume <= 1 && pref.media_volume >= 0)
		pref.media_volume = round(pref.media_volume * 100)
	pref.media_volume = isnum(pref.media_volume) ? CLAMP(pref.media_volume, 0, 100) : initial(pref.media_volume)
	pref.instrument_volume = isnum(pref.instrument_volume) ? CLAMP(pref.instrument_volume, 0, 100) : initial(pref.instrument_volume)
	pref.media_player = sanitize_inlist(pref.media_player, list(0, 1, 2), initial(pref.media_player))

/datum/category_item/player_setup_item/player_global/media/content(var/mob/user)
	. += "<b>Master Volume:</b> <a href='?src=\ref[src];change_master_volume=1'><b>[pref.master_volume]%</b></a><br>"
	. += "<b>Music Volume:</b> <a href='?src=\ref[src];change_music_volume=1'><b>[pref.music_volume]%</b></a><br>"
	. += "<b>Jukebox Volume:</b> <a href='?src=\ref[src];change_media_volume=1'><b>[pref.media_volume]%</b></a><br>"
	. += "<b>Instrument Volume:</b> <a href='?src=\ref[src];change_instrument_volume=1'><b>[pref.instrument_volume]%</b></a><br>"
	. += "<b>Media Player Type:</b> Depending on you operating system, one of these might work better. "
	. += "Use HTML5 if it works for you. If neither HTML5 nor WMP work, you'll have to fall back to using VLC, "
	. += "but this requires you have the VLC client installed on your comptuer."
	. += "Try the others if you want but you'll probably just get no music.<br>"
	. += (pref.media_player == 2) ? "<span class='linkOn'><b>HTML5</b></span> " : "<a href='?src=\ref[src];set_media_player=2'>HTML5</a> "
	. += (pref.media_player == 1) ? "<span class='linkOn'><b>WMP</b></span> " : "<a href='?src=\ref[src];set_media_player=1'>WMP</a> "
	. += (pref.media_player == 0) ? "<span class='linkOn'><b>VLC</b></span> " : "<a href='?src=\ref[src];set_media_player=0'>VLC</a> "
	. += "<br>"

/datum/category_item/player_setup_item/player_global/media/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["change_master_volume"])
		if(CanUseTopic(user))
			var/value = input("Choose master volume - overall for all sound categories (0-100%)", "Master volume", pref.master_volume)
			if(isnum(value))
				pref.master_volume = CLAMP(round(value), 0, 100)
				// Re-apply music if in lobby so master takes effect
				if(isnewplayer(user) && user.client && GLOB.lobbyScreen)
					GLOB.lobbyScreen.stop_music(user.client)
					if(user.get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
						GLOB.lobbyScreen.play_music(user.client)
			return TOPIC_REFRESH
	else if(href_list["change_music_volume"])
		if(CanUseTopic(user))
			var/value = input("Choose music volume - lobby & admin midi (0-100%)", "Music volume", pref.music_volume)
			if(isnum(value))
				pref.music_volume = CLAMP(round(value), 0, 100)
				if(isnewplayer(user) && user.client && GLOB.lobbyScreen)
					GLOB.lobbyScreen.stop_music(user.client)
					if(user.get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
						GLOB.lobbyScreen.play_music(user.client)
			return TOPIC_REFRESH
	else if(href_list["change_media_volume"])
		if(CanUseTopic(user) && user.client)
			user.client.adjust_volume_verb(user, "jukebox")
			return TOPIC_REFRESH
	else if(href_list["change_instrument_volume"])
		if(CanUseTopic(user))
			var/value = input("Choose instrument volume - played instrument volumes (0-100%)", "Instrument volume", pref.instrument_volume)
			if(isnum(value))
				pref.instrument_volume = CLAMP(round(value), 0, 100)
			return TOPIC_REFRESH
	else if(href_list["set_media_player"])
		if(CanUseTopic(user))
			var/newval = sanitize_inlist(text2num(href_list["set_media_player"]), list(0, 1, 2), pref.media_player)
			if(newval != pref.media_player)
				pref.media_player = newval
				if(user.client && user.client.media)
					user.client.media.open()
					spawn(10)
						user.update_music()
			return TOPIC_REFRESH
	return ..()
