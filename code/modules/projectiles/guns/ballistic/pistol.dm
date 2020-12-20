/obj/item/gun/ballistic/automatic/pistol
	name = "stechkin pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = TRUE
	actions_types = list()
	bolt_type = BOLT_TYPE_LOCKING
	fire_sound = "sound/weapons/gunshot.ogg"
	vary_fire_sound = FALSE
	fire_sound_volume = 80
	rack_sound = "sound/weapons/pistolrack.ogg"
	bolt_drop_sound = "sound/weapons/pistolslidedrop.ogg"
	bolt_wording = "slide"
	fire_rate = 3
	automatic = 0
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/ballistic/automatic/pistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)

/obj/item/gun/ballistic/automatic/pistol/m1911
	name = "\improper M1911"
	desc = "A classic .45 handgun with a small magazine capacity."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = FALSE

/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/secpistol
	name = "\improper security pistol"
	desc = "Classic pistol modernised for use by station's security force."
	icon_state = "secpistol"
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/toggle_firemode)
	mag_type = /obj/item/ammo_box/magazine/sec9mm
	special_mags = TRUE
	fire_sound = "sound/weapons/secshot.ogg"
	can_suppress = FALSE
	can_flashlight = TRUE
	flight_x_offset = 15
	flight_y_offset = 10
	dual_wield_spread = 40
	spread = 15
	recoil = 0.6
	fire_rate = 1.5
	fire_delay = 2
	burst_size = 2

/obj/item/gun/ballistic/automatic/pistol/secpistol/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			dual_wield_spread = initial(dual_wield_spread)
			spread = initial(spread)
			recoil = initial(recoil)
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, "<span class='notice'>You switch to [burst_size]-rnd burst.</span>")
		if(1)
			select = 0
			dual_wield_spread = 30
			spread = 1
			recoil = 0.3
			burst_size = 1
			fire_rate = 3
			fire_delay = 0
			to_chat(user, "<span class='notice'>You switch to semi-auto.</span>")
	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	update_icon()
	return

/obj/item/gun/ballistic/automatic/pistol/secpistol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/secpistol/tactical
	can_suppress = TRUE

/obj/item/gun/ballistic/automatic/pistol/secpistol/tactical/Initialize()
	set_gun_light(new /obj/item/flashlight/seclite(src))
	update_icon()
	return ..()

/obj/item/gun/ballistic/automatic/pistol/deagle
	name = "\improper Desert Eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = FALSE
	mag_display = TRUE

/obj/item/gun/ballistic/automatic/pistol/deagle/gold
	desc = "A gold plated Desert Eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/gun/ballistic/automatic/pistol/APS
	name = "stechkin APS pistol"
	desc = "The original Russian version of a widely used Syndicate sidearm. Uses 9mm ammo."
	icon_state = "aps"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/pistolm9mm
	can_suppress = FALSE
	burst_size = 3
	fire_delay = 2
	actions_types = list(/datum/action/item_action/toggle_firemode)

/obj/item/gun/ballistic/automatic/pistol/stickman
	name = "flat gun"
	desc = "A 2 dimensional gun.. what?"
	icon_state = "flatgun"

/obj/item/gun/ballistic/automatic/pistol/stickman/pickup(mob/living/user)
	to_chat(user, "<span class='notice'>As you try to pick up [src], it slips out of your grip..</span>")
	if(prob(50))
		to_chat(user, "<span class='notice'>..and vanishes from your vision! Where the hell did it go?</span>")
		qdel(src)
		user.update_icons()
	else
		to_chat(user, "<span class='notice'>..and falls into view. Whew, that was a close one.</span>")
		user.dropItemToGround(src)

// makeshiftov //

/obj/item/gun/ballistic/automatic/pistol/makeshift
	name = "makeshiftov pistol"
	desc = "A small, makeshift 9mm handgun. It's a miracle if it'll even fire."
	icon_state = "makeshift"
	item_state = "makeshiftov"
	mag_type = /obj/item/ammo_box/magazine/m9mm_mkshft
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/makeshift/chamber_round(keep_bullet = FALSE, mob/living/user, message = TRUE)
	if(prob(60))
		playsound(src, dry_fire_sound, 30, TRUE)
		to_chat(user, "<span class='notice'>\The [src] makes a dry sound as the slide is racked.</span>")
		return
	return ..()

/obj/item/gun/ballistic/automatic/pistol/makeshift/TEC10
	name = "machineshiftov pistol"
	desc = "crude machine  pistol that resembles TEC-9 made out of unreriable pistol. Hope it wont explode in your face."
	icon_state = "tec10"
	item_state = "TEC10"
	mag_type = /obj/item/ammo_box/magazine/m9mm_mkshft/TEC10
	automatic = 1
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/ballistic/automatic/pistol/makeshift/TEC10/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(magazine.caliber != initial(magazine.caliber))
		if(prob(70 - (magazine.ammo_count() * 10)))	//minimum probability of 10, maximum of 60
			playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
			to_chat(user, "<span class='userdanger'>[src] blows up in your face!</span>")
			user.take_bodypart_damage(0,20)
			explosion(src, 0, 0, 1, 1)
			user.dropItemToGround(src)
			return 0
	..()
