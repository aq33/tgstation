////////////////////
//MORE DRONE TYPES//
////////////////////
//Drones with custom laws
//Drones with custom shells
//Drones with overridden procs
//Drones with camogear for hat related memes
//Drone type for use with polymorph (no preloaded items, random appearance)


//More types of drones
/mob/living/simple_animal/drone/syndrone
	name = "Syndron"
	desc = "Zmodyfikowany dron naprawczy Syndykatu. Wygląda jak zapowiedź kłopotów."
	icon_state = "drone_synd"
	icon_living = "drone_synd"
	picked = TRUE //the appearence of syndrones is static, you don't get to change it.
	//health = 30
	//maxHealth = 120 //If you murder other drones and cannibalize them you can get much stronger - it would be cool if it wasn't broken as hell
	initial_language_holder = /datum/language_holder/drone/syndicate
	faction = list(ROLE_SYNDICATE)
	speak_emote = list("syczy")
	bubble_icon = "syndibot"
	heavy_emp_damage = 10
	laws = \
	"1. Przeszkadzaj nie-syndronom.\n"+\
	"2. Zabijaj nie-syndrony.\n"+\
	"3. Niszcz nie-syndrony."
	default_storage = /obj/item/storage/backpack/duffelbag/syndrone
	default_hatmask = null
	hacked = TRUE
	flavortext = null

/mob/living/simple_animal/drone/syndrone/Initialize()
	. = ..()
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(src)
	W.implant(src, force = TRUE)

/mob/living/simple_animal/drone/syndrone/Login()
	..()
	to_chat(src, "<span class='notice'>Syndron online. Protokoły eksterminacji aktywne.</span>" )

/mob/living/simple_animal/drone/syndrone/badass
	name = "Badass Syndrone"
	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	default_storage = /obj/item/uplink/nuclear

/mob/living/simple_animal/drone/syndrone/badass/Initialize()
	. = ..()
	var/datum/component/uplink/hidden_uplink = internal_storage.GetComponent(/datum/component/uplink)
	hidden_uplink.telecrystals = 30
	var/obj/item/implant/weapons_auth/W = new/obj/item/implant/weapons_auth(src)
	W.implant(src, force = TRUE)

/mob/living/simple_animal/drone/snowflake
	default_hatmask = /obj/item/clothing/head/chameleon/drone

/mob/living/simple_animal/drone/snowflake/Initialize()
	. = ..()
	desc += " Wygląda na to, że ten dron posiada na 'głowie' mały holoprojektor."

/obj/item/drone_shell/syndrone
	name = "Nieaktywny syndron"
	desc = "Nieaktywny zmodyfikowany dron naprawczy Syndykatu. Może lepiej, żeby się nie aktywował."
	icon_state = "syndrone_item"
	drone_type = /mob/living/simple_animal/drone/syndrone

/obj/item/drone_shell/syndrone/badass
	name = "badass syndrone shell"
	drone_type = /mob/living/simple_animal/drone/syndrone/badass

/obj/item/drone_shell/snowflake
	name = "Nieaktywny holodron"
	desc = "Nieaktywny dron naprawczy z wbudowanym holoprojektorem czapek."
	drone_type = /mob/living/simple_animal/drone/snowflake

/obj/item/drone_shell/snowflake/attack_ghost(mob/user)
	if(is_banned_from(user.ckey, ROLE_DRONE) || QDELETED(src) || QDELETED(user))
		return
	if(CONFIG_GET(flag/use_age_restriction_for_jobs))
		if(!isnum(user.client.player_age)) //apparently what happens when there's no DB connected. just don't let anybody be a drone without admin intervention
			return
	if(!SSticker.mode)
		to_chat(user, "Nie możesz zostać holodronem przed początkiem rundy.")
		return
	if(!(user.client.player_age < DRONE_MINIMUM_AGE))
		var/be_drone = alert("Czy chcesz zostać holodronem? (UWAGA, nie możesz po tym zostać sklonowany!)",,"Tak","Nie")
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
		to_chat(user, "<span class='danger'>Jesteś zbyt nowy żeby grać holodronem! Spróbuj ponownie za [DRONE_MINIMUM_AGE - user.client.player_age] dni.</span>")

/mob/living/simple_animal/drone/polymorphed
	default_storage = null
	default_hatmask = null
	picked = TRUE
	flavortext = null

/mob/living/simple_animal/drone/polymorphed/Initialize()
	. = ..()
	liberate()
	visualAppearence = pick(MAINTDRONE, REPAIRDRONE, SCOUTDRONE)
	if(visualAppearence == MAINTDRONE)
		var/colour = pick("grey", "blue", "red", "green", "pink", "orange")
		icon_state = "[visualAppearence]_[colour]"
	else
		icon_state = visualAppearence

	icon_living = icon_state
	icon_dead = "[visualAppearence]_dead"

/obj/item/drone_shell/dusty
	name = "derelict drone shell"
	desc = "A long-forgotten drone shell. It seems kind of... Space Russian."
	drone_type = /mob/living/simple_animal/drone/derelict

/mob/living/simple_animal/drone/derelict
	name = "derelict drone"
	default_hatmask = /obj/item/clothing/head/ushanka
