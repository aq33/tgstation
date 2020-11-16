#define DRONE_MINIMUM_AGE 7

///////////////////
//DRONES AS ITEMS//
///////////////////
//Drone shells

//DRONE SHELL
/obj/item/drone_shell
	name = "Nieaktywny dron"
	desc = "Nieaktywny dron naprawczy."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_maint_hat"//yes reuse the _hat state.
	layer = BELOW_MOB_LAYER

	var/drone_type = /mob/living/simple_animal/drone //Type of drone that will be spawned
	var/seasonal_hats = TRUE //If TRUE, and there are no default hats, different holidays will grant different hats
	var/static/list/possible_seasonal_hats //This is built automatically in build_seasonal_hats() but can also be edited by admins!

/obj/item/drone_shell/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("Dron został stworzony w [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_DRONE, notify_suiciders = FALSE)
	GLOB.poi_list |= src
	if(isnull(possible_seasonal_hats))
		build_seasonal_hats()

/obj/item/drone_shell/proc/build_seasonal_hats()
	possible_seasonal_hats = list()
	if(!length(SSevents.holidays))
		return //no holidays, no hats; we'll keep the empty list so we never call this proc again
	for(var/V in SSevents.holidays)
		var/datum/holiday/holiday = SSevents.holidays[V]
		if(holiday.drone_hat)
			possible_seasonal_hats += holiday.drone_hat

/obj/item/drone_shell/Destroy()
	GLOB.poi_list -= src
	. = ..()

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/drone_shell/attack_ghost(mob/user)
	if(is_banned_from(user.ckey, ROLE_DRONE) || QDELETED(src) || QDELETED(user))
		return
	if(CONFIG_GET(flag/use_age_restriction_for_jobs))
		if(!isnum_safe(user.client.player_age)) //apparently what happens when there's no DB connected. just don't let anybody be a drone without admin intervention
			return
	if(!SSticker.mode)
		to_chat(user, "Nie możesz być dronem przed początkiem rundy.")
		return
	if(!(user.client.player_age < DRONE_MINIMUM_AGE))
		var/be_drone = alert("Czy chcesz zostać dronem? (UWAGA, nie możesz po tym zostać sklonowany!)",,"Tak","Nie")
		if(be_drone == "Nie" || QDELETED(src) || !isobserver(user))
			return
		var/mob/living/simple_animal/drone/D = new drone_type(get_turf(loc))
		if(!D.default_hatmask && seasonal_hats && possible_seasonal_hats.len)
			var/hat_type = pick(possible_seasonal_hats)
			var/obj/item/new_hat = new hat_type(D)
			D.equip_to_slot_or_del(new_hat, SLOT_HEAD)
			D.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
		D.key = user.key
		message_admins("[key_name(D)] has taken possession of \a [src] in [AREACOORD(src)].")
		log_game("[key_name(user)] has taken possession of \a [src] in [AREACOORD(src)].")
		qdel(src)
	else
		to_chat(user, "<span class='danger'>Jesteś zbyt nowy żeby grać dronem! Spróbuj ponownie za [DRONE_MINIMUM_AGE - user.client.player_age] dni.</span>")
