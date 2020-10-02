/obj/effect/spawner/xeno_egg_delivery
	name = "xeno egg delivery"
	icon = 'icons/mob/alien.dmi'
	icon_state = "egg_growing"
	var/announcement_time = 1200

/obj/effect/spawner/xeno_egg_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	new /obj/structure/alien/egg(T)
	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("An alien egg has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("An alien egg has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/infectious_zombie_delivery
	name = "infectious zombie delivery"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "zombie"
	var/announcement_time = 1200

/obj/effect/spawner/infectious_zombie_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)
	var/mob/living/simple_animal/hostile/zombie/Z = new /mob/living/simple_animal/hostile/zombie(T)
	Z.infection_chance = 60
	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("An infectious zombie has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("An infectious zombie has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/swarmer_fabricator_delivery
	name = "swarmer fabricator delivery"
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer"
	var/announcement_time = 1200

/obj/effect/spawner/swarmer_fabricator_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	new /obj/machinery/droneDispenser/swarmer(T)
	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("A swarmer fabricator has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("A swarmer fabricator has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a mysterious device in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/spider_egg_delivery
	name = "spider egg delivery"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "spidereggs"
	var/announcement_time = 1200

/obj/effect/spawner/spider_egg_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	var/obj/structure/spider/eggcluster/E = new /obj/structure/spider/eggcluster(T)
	E.player_spiders = TRUE

	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("A spider egg cluster has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("A spider egg cluster has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/infected_monkey_delivery
	name = "infected monkey delivery"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey1"
	var/announcement_time = 1200

/obj/effect/spawner/infected_monkey_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	var/datum/disease/transformation/jungle_fever/D = new /datum/disease/transformation/jungle_fever
	D.infect(new /mob/living/carbon/monkey/(T))

	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("An infected monkey has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("An infected monkey has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/hivebot_delivery
	name = "hivebot delivery"
	icon = 'icons/obj/objects.dmi'
	icon_state = "hivebot_fab"
	var/announcement_time = 1200

/obj/effect/spawner/hivebot_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	new /obj/machinery/droneDispenser/hivebot(T)
	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("An infected monkey has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("An infected monkey has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a mysterious device in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/morph_delivery
	name = "morph delivery"
	icon = 'icons/mob/animal.dmi'
	icon_state = "morph"
	var/announcement_time = 1200

/obj/effect/spawner/morph_delivery/Initialize(mapload)
	..()
	var/turf/T = get_turf(src)

	new /mob/living/simple_animal/hostile/morph(T)
	new /obj/effect/temp_visual/gravpush(T)

	new /obj/effect/temp_visual/gravpush(T)
	playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)

	message_admins("A morph has been delivered to [ADMIN_VERBOSEJMP(T)].")
	log_game("A morph has been delivered to [AREACOORD(T)]")
	var/message = "Attention [station_name()], we have entrusted you with a research specimen in [get_area_name(T, TRUE)]. Remember to follow all safety precautions when dealing with the specimen."
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, /proc/addtimer, CALLBACK(GLOBAL_PROC, /proc/print_command_report, message), announcement_time))
	return INITIALIZE_HINT_QDEL
