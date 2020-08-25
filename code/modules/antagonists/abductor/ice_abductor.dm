/obj/structure/fluff/iced_abductor ///Unless more non-machine ayy structures made, it will stay in fluff.
	name = "Tajemnicza Bryła Lodu"
	desc = "Cienista postać leży w tym solidnie wyglądającym bloku lodu. Kto wie, skąd to się wzięło?"
	icon = 'icons/effects/freeze.dmi'
	icon_state =  "ice_ayy"
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/iced_abductor/Destroy()
	var/turf/T = get_turf(src)
	new /obj/effect/mob_spawn/human/abductor(T)
	. = ..()
