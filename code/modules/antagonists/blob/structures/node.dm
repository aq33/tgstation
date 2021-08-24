/obj/structure/blob/node
	name = "grzybi węzeł"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blank_blob"
	desc = "Dwa mniejsze, pulsujące grzybki."
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 65, "acid" = 90, "stamina" = 0)
	health_regen = 3
	point_return = 25
	resistance_flags = LAVA_PROOF

/obj/structure/blob/node/Initialize()
	GLOB.blob_nodes += src
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/blob/node/scannerreport()
	return "Stopniowo rozrasta się i podtrzymuje zarodnie oraz grzybonautów."

/obj/structure/blob/node/update_icon()
	cut_overlays()
	color = null
	var/mutable_appearance/blob_overlay = mutable_appearance('icons/mob/blob.dmi', "blob")
	if(overmind)
		blob_overlay.color = overmind.blobstrain.color
	add_overlay(blob_overlay)
	add_overlay(mutable_appearance('icons/mob/blob.dmi', "blob_node_overlay"))

/obj/structure/blob/node/Destroy()
	GLOB.blob_nodes -= src
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/blob/node/process()
	if(overmind)
		Pulse_Area(overmind, 10, 3, 2)

/obj/structure/blob/node/lone/process()
	Pulse_Area(overmind, 10, 3, 2)


