//Cleanbot
/mob/living/simple_animal/bot/hygienebot
	name = "\improper Hygienebot"
	desc = "A flying cleaning robot, he'll chase down people who can't shower properly!"
	icon = 'icons/mob/aibots.dmi'
	icon_state = "hygienebot"
	density = FALSE
	anchored = FALSE
	health = 100
	maxHealth = 100
	radio_key = /obj/item/encryptionkey/headset_service
	radio_channel = RADIO_CHANNEL_SERVICE //Service
	bot_type = HYGIENE_BOT
	model = "Cleanbot"
	bot_core_type = /obj/machinery/bot_core/hygienebot
	window_id = "autoclean"
	window_name = "Automatic Crew Cleaner X2"
	pass_flags = PASSMOB
	path_image_color = "#993299"
	allow_pai = FALSE
	layer = ABOVE_MOB_LAYER

	var/mob/living/carbon/human/target
	var/currentspeed = 5
	var/washing = FALSE
	var/mad = FALSE
	var/last_found
	var/oldtarget_name

	var/mutable_appearance/water_overlay
	var/mutable_appearance/fire_overlay

/mob/living/simple_animal/bot/hygienebot/Initialize()
	. = ..()
	update_icon()
	var/datum/job/janitor/J = new/datum/job/janitor
	access_card.access += J.get_access()
	prev_access = access_card.access

/mob/living/simple_animal/bot/hygienebot/explode()
	walk_to(src,0)
	visible_message("<span class='boldannounce'>[src] blows apart in a foamy explosion!</span>")
	do_sparks(3, TRUE, src)
	on = FALSE
	new /obj/effect/particle_effect/foam(loc)

	..()

/mob/living/simple_animal/bot/hygienebot/Cross(atom/movable/AM)
	. = ..()
	if(washing)
		do_wash(AM)

/mob/living/simple_animal/bot/hygienebot/Crossed(atom/movable/AM)
	. = ..()
	if(washing)
		do_wash(AM)

/mob/living/simple_animal/bot/hygienebot/update_icon_state()
	. = ..()
	if(on)
		icon_state = "hygienebot-on"
	else
		icon_state = "hygienebot"


/mob/living/simple_animal/bot/hygienebot/update_icon()
	. = ..()
	cut_overlays()
	if(on)
		var/mutable_appearance/fire_overlay = mutable_appearance(icon, "hygienebot-flame")
		add_overlay(fire_overlay)


	if(washing)
		var/mutable_appearance/water_overlay = mutable_appearance(icon, emagged ? "hygienebot-fire" : "hygienebot-water")
		add_overlay(water_overlay)


/mob/living/simple_animal/bot/hygienebot/turn_off()
	..()
	mode = BOT_IDLE

/mob/living/simple_animal/bot/hygienebot/bot_reset()
	..()
	target = null
	oldtarget_name = null
	walk_to(src,0)
	last_found = world.time

/mob/living/simple_animal/bot/hygienebot/handle_automated_action()
	if(!..())
		return

	if(washing)
		do_wash(loc)
		for(var/AM in loc)
			do_wash(AM)
		if(isopenturf(loc) && !emagged)
			var/turf/open/tile = loc
			tile.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

	switch(mode)
		if(BOT_IDLE)		// idle
			walk_to(src,0)
			look_for_lowhygiene()	// see if any disgusting fucks are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode

		if(BOT_HUNT)		// hunting for stinkman
			if(emagged) //lol fuck em up
				currentspeed = 3.5
				start_washing()
				mad = TRUE
			else
				switch(frustration)
					if(0 to 4)
						currentspeed = 5
						mad = FALSE
					if(5 to INFINITY)
						currentspeed = 2.5
						mad = TRUE
			if(target && !check_purity(target))
				if(target.loc == loc && isturf(target.loc)) //LADIES AND GENTLEMAN WE GOTEM PREPARE TO DUMP
					start_washing()
					if(mad)
						var/list/messagevoice = list("Kurwa, w końcu." = 'sound/effects/hygienebot_angry.ogg',
						"Nareszcie cię złapałem, złamasie." = 'sound/effects/hygienebot_angry.ogg',
						"Degenerat." = 'sound/effects/hygienebot_angry.ogg')
						var/message = pick(messagevoice)
						speak(message)
						playsound(src, messagevoice[message], 60, 1)
						mad = FALSE
					mode = BOT_SHOWERSTANCE
				else
					stop_washing()
					var/olddist = get_dist(src, target)
					if(olddist > 20 || frustration > 100) // Focus on something else
						var/list/messagevoice = list("Pierdole to." = 'sound/effects/hygienebot_angry.ogg',
						"Dobra, spierdalaj gówniarzu." = 'sound/effects/hygienebot_angry.ogg',
						"Spierdalaj z taką robotą." = 'sound/effects/hygienebot_angry.ogg')
						var/message = pick(messagevoice) 
						speak(message)
						playsound(src, messagevoice[message], 60, 1)
						back_to_idle()
						return
					walk_to(src, target,0, currentspeed)
					if(mad && prob(min(frustration * 2, 60)))
						var/list/messagevoice = list("Wracaj, hultaju." = 'sound/effects/hygienebot_angry.ogg',
						"Kiedy się myłeś ostatnio, szczerze?" = 'sound/effects/hygienebot_angry.ogg',
						"Inspekcja wacka, proszę stać." = 'sound/effects/hygienebot_angry.ogg',
						"Myj dupe." = 'sound/effects/hygienebot_angry.ogg',
						"Czy ty kiedykolwiek słyszałeś słowo \"prysznic\"?." = 'sound/effects/hygienebot_angry.ogg',
						"Przestań biegać, troglodyto jebany." = 'sound/effects/hygienebot_angry.ogg',
						"Czy ty się myjesz w ogóle?" =	'sound/effects/hygienebot_angry.ogg')
						var/message = pick(messagevoice) 
						speak(message)
						playsound(src, messagevoice[message], 60, 1)
					if((get_dist(src, target)) >= olddist)
						frustration++
					else
						frustration = 0
			else
				back_to_idle()

		if(BOT_SHOWERSTANCE)
			if(check_purity(target))
				speak("Miłego dnia!")
				playsound(loc, 'sound/effects/hygienebot_happy.ogg', 60, 1)
				back_to_idle()
				return
			if(!target)
				last_found = world.time
			if(target.loc != loc || !isturf(target.loc))
				back_to_hunt()

		if(BOT_START_PATROL)
			look_for_lowhygiene()
			start_patrol()

		if(BOT_PATROL)
			look_for_lowhygiene()
			bot_patrol()

/mob/living/simple_animal/bot/hygienebot/proc/back_to_idle()
	mode = BOT_IDLE
	walk_to(src,0)
	target = null
	frustration = 0
	last_found = world.time
	stop_washing()
	INVOKE_ASYNC(src, .proc/handle_automated_action)

/mob/living/simple_animal/bot/hygienebot/proc/back_to_hunt()
	frustration = 0
	mode = BOT_HUNT
	stop_washing()
	INVOKE_ASYNC(src, .proc/handle_automated_action)

/mob/living/simple_animal/bot/hygienebot/proc/look_for_lowhygiene()
	for (var/mob/living/carbon/human/H in view(7,src)) //Find the NEET
		if((H.name == oldtarget_name) && (world.time < last_found + 100))
			continue
		if(!check_purity(H)) //Theyre impure
			target = H
			oldtarget_name = H.name
			speak("Niehigieniczny klient znaleziony. Proszę stać w miejscu i dać się umyć.")
			playsound(loc, 'sound/effects/hygienebot_happy.ogg', 60, 1)
			visible_message("<b>[src]</b> points at [H.name]!")
			mode = BOT_HUNT
			INVOKE_ASYNC(src, .proc/handle_automated_action)
			break
		else
			continue

/mob/living/simple_animal/bot/hygienebot/proc/start_washing()
	washing = TRUE
	update_icon()

/mob/living/simple_animal/bot/hygienebot/proc/stop_washing()
	washing = FALSE
	update_icon()



/mob/living/simple_animal/bot/hygienebot/get_controls(mob/user)
	var/list/dat = list()
	dat += hack(user)
	dat += showpai(user)
	dat += {"
<TT><B>Hygienebot X2 controls</B></TT><BR><BR>
Status: ["<A href='?src=[REF(src)];power=[TRUE]'>[on ? "On" : "Off"]</A>"]<BR>
Behaviour controls are [locked ? "locked" : "unlocked"]<BR>
Maintenance panel is [open ? "opened" : "closed"]"}

	if(!locked || issilicon(user) || IsAdminGhost(user))
		dat += {"<BR> Auto Patrol: ["<A href='?src=[REF(src)];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"]"}

	return	dat.Join("")

/mob/living/simple_animal/bot/hygienebot/proc/check_purity(mob/living/L)
	if(emagged && L.stat != DEAD)
		return FALSE

	for(var/X in list(SLOT_HEAD, ITEM_SLOT_MASK, SLOT_W_UNIFORM, SLOT_SHOES, SLOT_GLOVES))

		var/obj/item/I = L.get_item_by_slot(X)
		if(I && HAS_BLOOD_DNA(I))
			return FALSE
	return TRUE

/mob/living/simple_animal/bot/hygienebot/proc/do_wash(atom/A)
	if(emagged)
		A.fire_act()  //lol pranked no cleaning besides that
	else
		A.washed(src)



/obj/machinery/bot_core/hygienebot
	req_one_access = list(ACCESS_JANITOR, ACCESS_ROBOTICS)
