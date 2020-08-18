/datum/map_template/random_engine
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/centerspawner = TRUE
	var/meta_engines = list("_maps/RandomEngines/meta_supermatter.dmm", "_maps/RandomEngines/meta_singulo.dmm", "_maps/RandomEngines/meta_tesla.dmm", "_maps/RandomEngines/meta_teg.dmm")
	//var/kilo_engines = list("_maps/RandomEngines/kilo_supermatter.dmm", "_maps/RandomEngines/kilo_singulo.dmm", "_maps/RandomEngines/kilo_tesla.dmm", "_maps/RandomEngines/kilo_teg.dmm")

/datum/map_template/random_engine/engine/New()
	switch(SSmapping.config?.map_name)
		if("MetaStation")
			mappath = pick(meta_engines)
		//if("Kilo Station")
		//	mappath = pick(kilo_engines)

/datum/map_template/random_engine/engine
	name = "Supermatter engine"
	room_id = "supermatter_engine"
	centerspawner = FALSE
	mappath = "_maps/RandomEngines/emergency_engine.dmm"
