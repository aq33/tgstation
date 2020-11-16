GLOBAL_VAR(posibrain_notify_cooldown)

/obj/item/mmi/posibrain
	name = "mózg pozytronowy"
	desc = "Kostka z lśniącego metalu pokryta ze wszystkich stron płytkimi żłobieniami."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = WEIGHT_CLASS_NORMAL
	var/next_ask
	var/askDelay = 600 //one minute
	var/searching = FALSE
	brainmob = null
	req_access = list(ACCESS_ROBOTICS)
	mecha = null//This does not appear to be used outside of reference in mecha.dm.
	braintype = "Android"
	var/autoping = TRUE //if it pings on creation immediately
	var/begin_activation_message = "<span class='notice'>Ostrożnie naciskasz przycisk manualnej aktywacji pozytrona rozpoczynając jego proces aktywacji.</span>"
	var/success_message = "<span class='notice'>Pozytron wydaje z siebie głośne 'ping' i zaczyna błyszczeć. Sukces!</span>"
	var/fail_message = "<span class='notice'>Pozytron cichutko buczy, a złote światło zanika. Być może warto spróbować ponownie?</span>"
	var/new_role = "Positronic Brain"
	var/welcome_message = "<span class='warning'>NIE PAMIĘTASZ POPRZEDNICH ŻYĆ.</span>\n\
	<b>Jesteś mózgiem pozytronowym, stworzonym na pokładzie stacji.\n\
	Jako syntetyczna inteligencja, podlegasz wszystkim istotom na stacji oraz SI.\n\
	Pamiętaj, istotą Twojego istnienia jest służenie stacji i załodze. Nie wywołuj krzywdy.</b>"
	var/new_mob_message = "<span class='notice'>Pozytron cicho dzwoni.</span>"
	var/dead_message = "<span class='deadsay'>Wygląda na całkowicie nieaktywny. Dioda restartu mruga w regularnych interwałach.</span>"
	var/recharge_message = "<span class='warning'>Pozytron nie jest jeszcze gotowy do restartu!</span>"
	var/list/possible_names //If you leave this blank, it will use the global posibrain names
	var/picked_name

/obj/item/mmi/posibrain/Topic(href, href_list)
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			activate(ghost)

/obj/item/mmi/posibrain/proc/ping_ghosts(msg, newlymade)
	if(newlymade || GLOB.posibrain_notify_cooldown <= world.time)
		notify_ghosts("[name] [msg] in [get_area(src)]!", ghost_sound = !newlymade ? 'sound/effects/ghost2.ogg':null, notify_volume = 75, enter_link = "<a href=?src=[REF(src)];activate=1>(Click to enter)</a>", source = src, action = NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_POSIBRAIN, notify_suiciders = FALSE)
		if(!newlymade)
			GLOB.posibrain_notify_cooldown = world.time + askDelay

/obj/item/mmi/posibrain/attack_self(mob/user)
	if(!brainmob)
		brainmob = new(src)
	if(is_occupied())
		to_chat(user, "<span class='warning'>Ten [name] jest już aktywne!</span>")
		return
	if(next_ask > world.time)
		to_chat(user, recharge_message)
		return
	//Start the process of requesting a new ghost.
	to_chat(user, begin_activation_message)
	ping_ghosts("requested", FALSE)
	next_ask = world.time + askDelay
	searching = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/check_success), askDelay)

/obj/item/mmi/posibrain/proc/check_success()
	searching = FALSE
	update_icon()
	if(QDELETED(brainmob))
		return
	if(brainmob.client)
		visible_message(success_message)
		playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	else
		visible_message(fail_message)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/mmi/posibrain/attack_ghost(mob/user)
	activate(user)

/obj/item/mmi/posibrain/proc/is_occupied()
	if(brainmob.key)
		return TRUE
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		if(R.mmi == src)
			return TRUE
	return FALSE

//Two ways to activate a positronic brain. A clickable link in the ghost notif, or simply clicking the object itself.
/obj/item/mmi/posibrain/proc/activate(mob/user)
	if(QDELETED(brainmob))
		return
	if(is_occupied() || is_banned_from(user.ckey, ROLE_POSIBRAIN) || QDELETED(brainmob) || QDELETED(src) || QDELETED(user))
		return
	if(user.suiciding) //if they suicided, they're out forever.
		to_chat(user, "<span class='warning'>[src] nieco syczy. Niestety, nie akceptuje samobójców!</span>")
		return
	var/posi_ask = alert("Chcesz grać jako [name]? (UWAGA, nie możesz po tym zostać sklonowany i wszystkie poprzednie życia są zapomniane!)","Czy jesteś pewien?","Tak","Nie")
	if(posi_ask == "Nie" || QDELETED(src))
		return
	if(brainmob.suiciding) //clear suicide status if the old occupant suicided.
		brainmob.set_suicide(FALSE)
	transfer_personality(user)

/obj/item/mmi/posibrain/transfer_identity(mob/living/carbon/C)
	name = "[initial(name)] ([C])"
	brainmob.name = C.real_name
	brainmob.real_name = C.real_name
	if(C.has_dna())
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	brainmob.timeofhostdeath = C.timeofdeath
	brainmob.stat = CONSCIOUS
	if(brainmob.mind)
		brainmob.mind.assigned_role = new_role
	if(C.mind)
		C.mind.transfer_to(brainmob)

	brainmob.mind.remove_all_antag()
	brainmob.mind.wipe_memory()
	update_icon()

/obj/item/mmi/posibrain/proc/transfer_personality(mob/candidate)
	if(QDELETED(brainmob))
		return
	if(is_occupied()) //Prevents hostile takeover if two ghosts get the prompt or link for the same brain.
		to_chat(candidate, "<span class='warning'>Ten [name] zostało już przejęte! Być może później będzie dostępnych ich więcej?</span>")
		return FALSE
	if(candidate.mind && !isobserver(candidate))
		candidate.mind.transfer_to(brainmob)
	else
		brainmob.ckey = candidate.ckey
	name = "[initial(name)] ([brainmob.name])"
	to_chat(brainmob, welcome_message)
	brainmob.mind.assigned_role = new_role
	brainmob.stat = CONSCIOUS
	GLOB.dead_mob_list -= brainmob
	GLOB.alive_mob_list += brainmob

	visible_message(new_mob_message)
	check_success()
	return TRUE


/obj/item/mmi/posibrain/examine(mob/user)
	. = ..()
	if(brainmob && brainmob.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!brainmob.client)
					. += "Wygląda na to, że jest w trybie czuwania." //afk
			if(DEAD)
				. += "<span class='deadsay'>Wygląda na całkowicie nieaktywne.</span>"
	else
		. += "[dead_message]"

/obj/item/mmi/posibrain/Initialize()
	. = ..()
	brainmob = new(src)
	var/new_name
	if(!LAZYLEN(possible_names))
		new_name = pick(GLOB.posibrain_names)
	else
		new_name = pick(possible_names)
	brainmob.name = "[new_name]-[rand(100, 999)]"
	brainmob.real_name = brainmob.name
	brainmob.forceMove(src)
	brainmob.container = src
	if(autoping)
		ping_ghosts("created", TRUE)

/obj/item/mmi/posibrain/attackby(obj/item/O, mob/user)
	return


/obj/item/mmi/posibrain/update_icon()
	if(searching)
		icon_state = "[initial(icon_state)]-searching"
		return
	if(brainmob?.key)
		icon_state = "[initial(icon_state)]-occupied"
	else
		icon_state = initial(icon_state)
