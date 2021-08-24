/obj/structure/blob/resource
	name = "owocnik"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_resource"
	desc = "struktura z gęstych, grzybich pnączy"
	max_integrity = 60
	point_return = 15
	resistance_flags = LAVA_PROOF
	var/resource_delay = 0

/obj/structure/blob/resource/scannerreport()
	return "Stopniowo zasila grzyba zasobami, zwiększając tempo rozrostu."

/obj/structure/blob/resource/creation_action()
	if(overmind)
		overmind.resource_blobs += src

/obj/structure/blob/resource/Destroy()
	if(overmind)
		overmind.resource_blobs -= src
	return ..()

/obj/structure/blob/resource/Be_Pulsed()
	. = ..()
	if(resource_delay > world.time)
		return
	flick("blob_resource_glow", src)
	if(overmind)
		overmind.add_points(1)
		resource_delay = world.time + 40 + overmind.resource_blobs.len * 2.5 //4 seconds plus a quarter second for each resource blob the overmind has
	else
		resource_delay = world.time + 40
