/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/machines/jukebox.dmi'
	icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	req_access = list(ACCESS_BAR)
	interaction_flags_machine = INTERACT_MACHINE_SET_MACHINE | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN_SILICON
	var/active = FALSE
	var/stop = 0
	var/selection = 1
	var/channel = null
	var/state_base = "jukebox"
	var/seconds_electrified = MACHINE_NOT_ELECTRIFIED
	var/speed_servo_regulator_cut = FALSE //vaporwave
	var/speed_servo_resistor_cut = FALSE //nightcore
	var/speed_potentiometer = 1.0
	var/selection_blocked = FALSE
	var/stop_blocked = FALSE
	var/list_source = list()

/obj/machinery/jukebox/Initialize()
	. = ..()
	wires = new /datum/wires/jukebox(src)
	list_source = SSjukeboxes.song_lib
	update_icon()

/obj/machinery/jukebox/Destroy()
	if(!isnull(channel))
		SSjukeboxes.remove_jukebox(channel)
		channel = null
	QDEL_NULL(wires)
	return ..()

/obj/machinery/jukebox/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		stop = 0

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
	return ..()

/obj/machinery/jukebox/proc/shock(mob/user, prb)
	if(stat & NOPOWER)
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
	if(stat & (BROKEN|NOPOWER))
		return
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if (!anchored)
		to_chat(user,"<span class='warning'>This device must be anchored by a wrench!</span>")
		return
	if(!allowed(user))
		to_chat(user,"<span class='warning'>Error: Access Denied.</span>")
		user.playsound_local(src,'sound/machines/deniedbeep.ogg', 25, 1)
		return
	if(!SSjukeboxes.songs.len)
		to_chat(user,"<span class='warning'>Error: No music tracks have been authorized for your station. Petition Central Command to resolve this issue.</span>")
		playsound(src,'sound/machines/deniedbeep.ogg', 25, 1)
		return
	var/list/dat = list()
	dat += "<div class='statusDisplay' style='text-align:center'>"
	dat += "<b><a href='?src=[REF(src)];action=toggle'>[!active ? "BREAK IT DOWN" : "SHUT IT DOWN"]</a><b><br>"
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
	if(stat & (BROKEN|NOPOWER))
		return
	if(!anchored)
		to_chat(usr, "<span class='warning'>This device must be anchored by a wrench!</span>")
		return
	add_fingerprint(usr)
	if(seconds_electrified)
		if(shock(usr, 100))
			return
	switch(href_list["action"])
		if("toggle")
			if(!active)
				attempt_playback()
			else
				if (stop_blocked)
					to_chat(usr, "<span class='warning'>You try to shut it down, but nothing happens!</span>")
				else
					stop = 0
		if("select")
			if(active)
				to_chat(usr, "<span class='warning'>Error: You cannot change the song until the current one is over.</span>")
				return
			if(selection_blocked)
				to_chat(usr, "<span class='warning'>You press the song picker button, but for some reason nothing happens. Sad!</span>")
				playsound(src, 'sound/machines/deniedbeep.ogg', 50, 1)
				return
			var/selected = input(usr, "Choose your song", "Track:") as null|anything in list_source
			if(QDELETED(src) || !selected)
				return
			selection = list_source[selected]
			updateUsrDialog()

/obj/machinery/jukebox/proc/activate_music()
	if(stat & (BROKEN|NOPOWER))
		return FALSE
	var/speed_factor = get_speed_factor()
	channel = SSjukeboxes.add_jukebox(src, selection, speed_factor)
	if(isnull(channel))
		return null
	active = TRUE
	playsound(src,'sound/machines/terminal_on.ogg',50,TRUE)
	update_icon()
	stop = world.time + (SSjukeboxes.songs[selection].length * (1/speed_factor))
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/machinery/jukebox/process()
	if(seconds_electrified > MACHINE_NOT_ELECTRIFIED)
		seconds_electrified--
	if(world.time >= stop && active)
		active = FALSE
		STOP_PROCESSING(SSobj, src)
		playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
		updateUsrDialog()
		update_icon()
		SSjukeboxes.remove_jukebox(channel)
		channel = null
		stop = world.time + 25

/obj/machinery/jukebox/proc/get_speed_factor()
	var/speed_factor = 1.0
	if (speed_servo_regulator_cut)
		speed_factor *= 0.73
	if (speed_servo_resistor_cut)
		speed_factor *= 1.25
	speed_factor *= speed_potentiometer
	to_chat(world, "Speed factor is: [speed_factor]") // REMOVE THIS
	return speed_factor

/obj/machinery/jukebox/proc/pick_random(specific_list = list_source)
	if(active)
		to_chat(usr, "<span class='warning'>Error: You cannot change the song until the current one is over.</span>")
		return
	var/selected = pick(specific_list)
	if(QDELETED(src) || !selected)
		return
	selection = specific_list[selected]
	updateUsrDialog()

/obj/machinery/jukebox/proc/attempt_playback()
	if (QDELETED(src))
		return
	if(stop > world.time)
		to_chat(usr, "<span class='warning'>Error: The device is still resetting from the last activation, it will be ready again in [DisplayTimeText(stop-world.time)].</span>")
		return
	if(!activate_music())
		to_chat(usr, "<span class='warning'>Error: Hardware failure, try again.</span>")
		playsound(src, 'sound/machines/deniedbeep.ogg', 50, TRUE)
		return
	updateUsrDialog()
