/datum/map_template/random_engine
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/centerspawner = TRUE
	//var/weight = 10 //weight a room has to appear
	//var/stock = 1 //how many times this room can appear in a round

datum/map_template/random_engine/sm
	name = "Supermatter engine"
	room_id = "supermatter_engine"
	mappath = "_maps/RandomEngines/supermatter.dmm"
	centerspawner = FALSE

datum/map_template/random_engine/singulo
	name = "Singularity engine"
	room_id = "singularity_engine"
	mappath = "_maps/RandomEngines/singulo.dmm"
	centerspawner = FALSE

/datum/map_template/random_engine/tesla
	name = "Tesla engine"
	room_id = "tesla_engine"
	mappath = "_maps/RandomEngines/tesla.dmm"
	centerspawner = FALSE
