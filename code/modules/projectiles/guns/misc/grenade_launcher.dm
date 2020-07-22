/obj/item/gun/grenadelauncher
	name = "Granatnik"
	desc = "Śmierdzi szkocką i urwanymi kończynami."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 5
	block_upgrade_walk = 1
	var/list/grenades = new/list()
	var/max_grenades = 5
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 5000)
	fire_rate = 1.5
	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/grenadelauncher/examine(mob/user)
	. = ..()
	. += "[grenades.len] / [max_grenades] załadowanych granatów."

/obj/item/gun/grenadelauncher/attackby(obj/item/I, mob/user, params)

	if((istype(I, /obj/item/grenade)))
		if(grenades.len < max_grenades)
			if(!user.transferItemToLoc(I, src))
				return
			grenades += I
			to_chat(user, "<span class='notice'>Wkładasz granat do granatnika.</span>")
			to_chat(user, "<span class='notice'>[grenades.len] / [max_grenades] granatów.</span>")
		else
			to_chat(usr, "<span class='danger'>Granatnik nie może pomieścić więcej granatów.</span>")

/obj/item/gun/grenadelauncher/can_shoot()
	return grenades.len

/obj/item/gun/grenadelauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	user.visible_message("<span class='danger'>[user] wystrzelił granat!</span>", \
						"<span class='danger'>Wystrzeliwujesz z granatnika!</span>")
	var/obj/item/grenade/F = grenades[1] //Now with less copypasta!
	grenades -= F
	F.forceMove(user.loc)
	F.throw_at(target, 30, 2, user)
	message_admins("[ADMIN_LOOKUPFLW(user)] fired a grenade ([F.name]) from a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].")
	log_game("[key_name(user)] fired a grenade ([F.name]) with a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].")
	F.active = 1
	F.icon_state = initial(F.icon_state) + "_active"
	playsound(user.loc, 'sound/weapons/grenadelaunch.ogg', 75, 1, -3)
	addtimer(CALLBACK(F, /obj/item/grenade.proc/prime), 15)
