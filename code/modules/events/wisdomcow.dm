/datum/round_event_control/wisdomcow
	name = "Wisdom cow"
	typepath = /datum/round_event/wisdomcow
	max_occurrences = 1
	weight = 20

/datum/round_event/wisdomcow/announce(fake)
	priority_announce("Krowa mędrzec została zauważona w okolicy. Zaleca się spytać ją o poradę.", "Agencja Hodowli Krów Nanotrasen")

/datum/round_event/wisdomcow/start()
	var/turf/targetloc = get_random_station_turf()
	new /mob/living/simple_animal/cow/wisdom(targetloc)
	do_smoke(1, targetloc)

