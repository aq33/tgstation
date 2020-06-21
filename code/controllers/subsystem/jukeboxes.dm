/datum/track
	var/name = "undefined"
	var/path = null
	var/length = null

/datum/jukebox
	var/song_id = null
	var/channel = null
	var/obj/jukebox = null

SUBSYSTEM_DEF(jukeboxes)
	name = "Jukeboxes"
	wait = 5
	var/list/song_lib = list()
	var/list/datum/track/songs = list()
	var/list/datum/jukebox/active_jukeboxes = list()
	var/list/free_channels = list()
	var/falloff = 10
	var/wet = -250
	var/dry = -10000

/datum/controller/subsystem/jukeboxes/proc/add_jukebox(obj/jukebox_obj, selection)
	if(selection > songs.len)
		CRASH("[src] tried to play a song with a nonexistant track")
	if(free_channels.len == 0)
		return null
	var/channel = pick(free_channels)
	free_channels -= channel
	active_jukeboxes.len++
	var/datum/jukebox/jukebox = new /datum/jukebox()
	jukebox.song_id = selection
	jukebox.channel = channel
	jukebox.jukebox = jukebox_obj
	active_jukeboxes[active_jukeboxes.len] = jukebox

	var/datum/track/song = songs[jukebox.song_id]
	var/sound/song_sound = sound(song.path)
	song_sound.status = SOUND_MUTE
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue
		M.playsound_local(get_turf(src), null, 100, falloff = falloff, channel = channel, S = song_sound)
		if(song.length == null) //find length of song
			var/list/sounds = M.client.SoundQuery()
			for(var/sound/S in sounds)
				if(S.channel == channel)
					song.length = S.len * 10
					break
		if(song.length == null)
			remove_jukebox(channel)
			CRASH("Couldn't query song length")

	return channel

/datum/controller/subsystem/jukeboxes/proc/remove_jukebox(channel)
	var/datum/jukebox/jukebox = null
	var/id = 1
	for(var/datum/jukebox/i in active_jukeboxes)
		if(i.channel == channel)
			jukebox = i
			break
		id++
	ASSERT(jukebox != null)
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		M.stop_sound_channel(channel)
	//idk if we have to del the jukebox datum
	active_jukeboxes.Cut(id, id+1)
	free_channels += channel
	return TRUE

/datum/controller/subsystem/jukeboxes/Initialize()
	var/list/tracks = flist("config/jukebox_music/sounds/")
	for(var/S in tracks)
		if(S == "exclude")
			continue
		var/datum/track/T = new()
		T.path = file("config/jukebox_music/sounds/[S]")
		T.name = S
		T.length = null 
		songs |= T
		song_lib[S] = songs.len
	song_lib = sortList(song_lib)
	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX_END)
		free_channels |= i
	return ..()

/datum/controller/subsystem/jukeboxes/fire()
	if(!active_jukeboxes.len)
		return
	for(var/datum/jukebox/jukebox in active_jukeboxes)
		var/datum/track/juketrack = songs[jukebox.song_id]
		if(!istype(juketrack))
			CRASH("Invalid jukebox track datum.")
		var/obj/jukebox_obj = jukebox.jukebox
		if(!istype(jukebox_obj))
			CRASH("Nonexistant or invalid object associated with jukebox.")
		var/sound/song_played = sound(juketrack.path)
		var/area/current_area = get_area(jukebox_obj)
		var/list/hearers_cache = hearers(7, jukebox_obj)

		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue
			if(!(M.client.prefs.toggles & SOUND_INSTRUMENTS))
				M.stop_sound_channel(jukebox.channel)
				continue

			var/in_range = FALSE
			if(jukebox_obj.z == M.z)	//todo - expand this to work with mining planet z-levels when robust jukebox audio gets merged to master
				song_played.status = SOUND_UPDATE
				if(get_area(M) == current_area)
					in_range = TRUE
				else if(M in hearers_cache)
					in_range = TRUE
			else
				song_played.status = SOUND_MUTE | SOUND_UPDATE	//Setting volume = 0 doesn't let the sound properties update at all, which is lame.

			M.playsound_local(get_turf(jukebox_obj), null, 100, falloff = falloff, channel = jukebox.channel, S = song_played, envwet = (in_range ? wet : 0), envdry = (in_range ? 0 : dry))
			CHECK_TICK
	return
