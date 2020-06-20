/datum/track
	var/song_name = "undefined"
	var/song_path = null
	var/song_length = null

/datum/track/New(name, path, length, assocID)
	song_name = name
	song_path = path
	song_length = length

SUBSYSTEM_DEF(jukeboxes)
	name = "Jukeboxes"
	wait = 5
	var/list/datum/track/songs = list()
	var/list/active_jukeboxes = list()
	var/list/free_channels = list()
	var/falloff = 10
	var/wet = -250
	var/dry = -10000

/datum/controller/subsystem/jukeboxes/proc/add_jukebox(obj/jukebox, selection)
	if(selection > songs.len)
		CRASH("[src] tried to play a song with a nonexistant track")
	if(free_channels.len == 0)
		return null
	var/channel = pick(free_channels)
	free_channels -= channel
	active_jukeboxes.len++
	active_jukeboxes[active_jukeboxes.len] = list(selection, channel, jukebox)

	var/sound/song_played = sound(songs[selection].song_path)
	song_played.status = SOUND_STREAM | SOUND_MUTE
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue
		M.playsound_local(get_turf(src), null, 100, falloff = falloff, channel = channel, S = song_played)
		if(songs[selection].song_length == null) //find length of song
			var/list/sounds = M.client.SoundQuery()
			for(var/sound/S in sounds)
				if(S.channel == channel)
					songs[selection].song_length = S.len * 10
					break
		if(songs[selection].song_length == null)
			CRASH("Couldn't query song length")

	return active_jukeboxes.len

/datum/controller/subsystem/jukeboxes/proc/remove_jukebox(IDtoremove)
	var/jukebox = active_jukeboxes[IDtoremove]
	if(islist(jukebox))
		var/channel = jukebox[2]
		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			M.stop_sound_channel(channel)
		active_jukeboxes.Cut(IDtoremove, IDtoremove+1)
		return TRUE
	else
		CRASH("Tried to remove jukebox with invalid ID")

/datum/controller/subsystem/jukeboxes/Initialize()
	var/list/tracks = flist("config/jukebox_music/sounds/")
	for(var/S in tracks)
		if(S == "exclude")
			continue
		var/datum/track/T = new()
		T.song_path = file("config/jukebox_music/sounds/[S]")
		T.song_name = S
		T.song_length = null 
		songs |= T
	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX_END)
		free_channels |= i
	return ..()

/datum/controller/subsystem/jukeboxes/fire()
	if(!active_jukeboxes.len)
		return
	for(var/list/jukeinfo in active_jukeboxes)
		if(!jukeinfo.len)
			CRASH("Active jukebox without any associated metadata.")
		var/datum/track/juketrack = songs[jukeinfo[1]]
		if(!istype(juketrack))
			CRASH("Invalid jukebox track datum.")
		var/obj/jukebox = jukeinfo[3]
		if(!istype(jukebox))
			CRASH("Nonexistant or invalid object associated with jukebox.")
		var/sound/song_played = sound(juketrack.song_path)
		var/area/current_area = get_area(jukebox)
		var/list/hearers_cache = hearers(7, jukebox)

		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				M.stop_sound_channel(jukeinfo[2])
				continue

			var/in_range = FALSE
			if(jukebox.z == M.z)	//todo - expand this to work with mining planet z-levels when robust jukebox audio gets merged to master
				song_played.status = SOUND_UPDATE
				if(get_area(M) == current_area)
					in_range = TRUE
				else if(M in hearers_cache)
					in_range = TRUE
			else
				song_played.status = SOUND_MUTE | SOUND_UPDATE	//Setting volume = 0 doesn't let the sound properties update at all, which is lame.

			M.playsound_local(get_turf(jukebox), null, 100, falloff = falloff, channel = jukeinfo[2], S = song_played, envwet = (in_range ? wet : 0), envdry = (in_range ? 0 : dry))
			CHECK_TICK
	return
