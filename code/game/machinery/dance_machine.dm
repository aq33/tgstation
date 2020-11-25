/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/machines/jukebox.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	req_access = list(ACCESS_BAR)
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON
	var/active = FALSE
	var/stop = 0
	var/selection = 1
	var/channel = null
	var/state_base = "jukebox"
	var/seconds_electrified = MACHINE_NOT_ELECTRIFIED

/obj/machinery/jukebox/Initialize()
	. = ..()
	wires = new /datum/wires/jukebox(src)
	update_icon()

/obj/machinery/jukebox/Destroy()
	if(!isnull(channel))
		SSjukeboxes.remove_jukebox(channel)
		channel = null
	QDEL_NULL(wires)
	return ..()

/obj/machinery/jukebox/power_change()
	..()
	stop = 0
	update_icon()

/obj/machinery/jukebox/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I))
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	if(panel_open && is_wire_tool(I))
		wires.interact(user)
		return TRUE
	return ..()

/obj/machinery/jukebox/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		stop = 0
		update_icon()

/obj/machinery/jukebox/_try_interact(mob/user)
	if(seconds_electrified)
		if(shock(user, 100))
			return

/obj/machinery/jukebox/proc/shock(mob/user, prb)
	if(stat & (NOPOWER))
		return FALSE
	if(!prob(prb))
		return FALSE
	do_sparks(5, TRUE, src)
	var/check_range = TRUE
	if(electrocute_mob(user, get_area(src), src, 0.7, check_range))
		return TRUE
	else
		return FALSE

/obj/machinery/jukebox/update_icon()
	overlays = 0
	icon_state = "[state_base]"
	if((stat & MAINT) || panel_open)
		overlays += image(icon = icon, icon_state = "[state_base]-panel")
	if(!(stat & NOPOWER))
		if(anchored)
			overlays += image(icon = icon, icon_state = "[state_base]-powered")
		if(active)
			overlays += image(icon = icon, icon_state = "[state_base]-playing")
		if(stat & BROKEN)
			overlays += image(icon = icon, icon_state = "[state_base]-broken")

/obj/machinery/jukebox/ui_interact(mob/user)
	. = ..()
	if(!is_operational())
		return
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
				if(!anchored)
					to_chat(usr, "<span class='warning'>This device must be anchored by a wrench!</span>")
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
	playsound(src,'sound/machines/terminal_on.ogg',50,TRUE)
	update_icon()
	stop = world.time + SSjukeboxes.songs[selection].length
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/machinery/jukebox/process()
	if(stat & (BROKEN|NOPOWER))
		return PROCESS_KILL
	if(!active)
		return
	if(seconds_electrified > MACHINE_NOT_ELECTRIFIED)
		seconds_electrified--
	if(world.time >= stop && active)
		active = FALSE
		STOP_PROCESSING(SSobj, src)
		playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
		update_icon()
		SSjukeboxes.remove_jukebox(channel)
		channel = null
		stop = world.time + 25
