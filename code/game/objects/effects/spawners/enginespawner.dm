
/obj/effect/spawner/engine
	name = "random engine spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_room"
	dir = NORTH
	var/datum/map_template/random_engine/template
	var/room_width = 0
	var/room_height = 0

/obj/effect/spawner/engine/proc/LateSpawn()
	template.load(get_turf(src), centered = template.centerspawner)
	qdel(src)

/obj/effect/spawner/engine/Initialize()
	. = ..()
	var/list/possibletemplates = list()
	var/datum/map_template/random_engine/cantidate = null
	shuffle_inplace(SSmapping.random_engine_templates)
	for(var/ID in SSmapping.random_engine_templates)
		cantidate = SSmapping.random_engine_templates[ID]
		if(istype(cantidate, /datum/map_template/random_engine))
			if(!cantidate.spawned)
				possibletemplates[cantidate] = cantidate.weight
		cantidate = null
	if(possibletemplates.len)
		template = pickweight(possibletemplates)
		template.stock --
		template.weight = (template.weight / 2)
		if(template.stock <= 0)
			template.spawned = TRUE
		addtimer(CALLBACK(src, /obj/effect/spawner/engine.proc/LateSpawn), 600)
	else
		template = null
	if(!template)
		qdel(src)
