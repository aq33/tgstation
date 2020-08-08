
/obj/effect/spawner/engine
    name = "random engine spawner"
    icon = 'icons/effects/landmarks_static.dmi'
    icon_state = "random_room"
    dir = NORTH
    var/datum/map_template/random_engine/template

/obj/effect/spawner/engine/proc/LateSpawn()
	template.load(get_turf(src), centered = template.centerspawner)
	qdel(src)

/obj/effect/spawner/engine/New()
	. = ..()
	if(SSmapping.random_engine_templates.len > 0)
		template = pick_value(SSmapping.random_engine_templates)
		LateSpawn()
	else
		CRASH("No engine template found!")
