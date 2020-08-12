/datum/map_template/random_engine
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/centerspawner = TRUE
	//var/weight = 10 //weight a room has to appear
	//var/stock = 1 //how many times this room can appear in a round

/datum/map_template/random_engine/teg
	name = "Thermo-Electric Generator"
	room_id = "teg"
	mappath = "_maps/RandomEngines/teg.dmm"
	centerspawner = FALSE
