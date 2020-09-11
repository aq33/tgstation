/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	req_access = list(ACCESS_BAR)
	var/active = FALSE
	var/stop = 0
	var/selection = 1
	var/channel = null

/obj/machinery/jukebox/Destroy()
	if(!isnull(channel))
		SSjukeboxes.remove_jukebox(channel)
		channel = null
	return ..()

/obj/machinery/jukebox/attackby(obj/item/O, mob/user, params)
	if(!active && !(flags_1 & NODECONSTRUCT_1))
		if(O.tool_behaviour == TOOL_WRENCH)
			if(!anchored && !isinspace())
				to_chat(user,"<span class='notice'>You secure [src] to the floor.</span>")
				setAnchored(TRUE)
			else if(anchored)
				to_chat(user,"<span class='notice'>You unsecure and disconnect [src].</span>")
				setAnchored(FALSE)
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			return
	return ..()

/obj/machinery/jukebox/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]-active"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/jukebox/ui_interact(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if (!anchored)
		to_chat(user,"<span class='warning'>This device must be anchored by a wrench!</span>")
		return
	if(!allowed(user))
		to_chat(user,"<span class='warning'>Error: Access Denied.</span>")
		user.playsound_local(src,'sound/misc/compiler-failure.ogg', 25, 1)
		return
	if(!SSjukeboxes.songs.len)
		to_chat(user,"<span class='warning'>Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue.</span>")
		playsound(src,'sound/misc/compiler-failure.ogg', 25, 1)
		return
	var/list/dat = list()
	dat +="<div class='statusDisplay' style='text-align:center'>"
	dat += "<b><A href='?src=[REF(src)];action=toggle'>[!active ? "BREAK IT DOWN" : "SHUT IT DOWN"]<b></A><br>"
	dat += "</div><br>"
	dat += "<A href='?src=[REF(src)];action=select'> Select Track</A><br>"
	dat += "Track Selected: [SSjukeboxes.songs[selection].name]<br>"
	dat += "Track Length: [DisplayTimeText(SSjukeboxes.songs[selection].length)]<br><br>"
	var/datum/browser/popup = new(user, "vending", "[name]", 400, 350)
	popup.set_content(dat.Join())
	popup.open()

/obj/machinery/jukebox/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	switch(href_list["action"])
		if("toggle")
			if (QDELETED(src))
				return
			if(!active)
				if(stop > world.time)
					to_chat(usr, "<span class='warning'>Error: The device is still resetting from the last activation, it will be ready again in [DisplayTimeText(stop-world.time)].</span>")
					playsound(src, 'sound/misc/compiler-failure.ogg', 50, 1)
					return
				if(!activate_music())
					to_chat(usr, "<span class='warning'>Error: Hardware failure, try again.</span>")
					playsound(src, 'sound/misc/compiler-failure.ogg', 50, TRUE)
					return
				START_PROCESSING(SSobj, src)
				updateUsrDialog()
			else if(active)
				stop = 0
				updateUsrDialog()
		if("select")
			if(active)
				to_chat(usr, "<span class='warning'>Error: You cannot change the song until the current one is over.</span>")
				return

			var/selected = input(usr, "Choose your song", "Track:") as null|anything in SSjukeboxes.song_lib
			if(QDELETED(src) || !selected)
				return
			selection = SSjukeboxes.song_lib[selected]
			updateUsrDialog()

/obj/machinery/jukebox/proc/activate_music()
	channel = SSjukeboxes.add_jukebox(src, selection)
	if(isnull(channel))
		return null
	active = TRUE
	update_icon()
	stop = world.time + SSjukeboxes.songs[selection].length
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/machinery/jukebox/process()
	if(world.time >= stop && active)
		active = FALSE
		STOP_PROCESSING(SSobj, src)
		playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
		update_icon()
		SSjukeboxes.remove_jukebox(channel)
		channel = null
		stop = world.time + 25
