/datum/wires/jukebox
	holder_type = /obj/machinery/jukebox
	proper_name = "Jukebox"

/datum/wires/jukebox/New(atom/holder)
	wires = list(
		WIRE_POWER,
		WIRE_ZAP1, WIRE_ZAP2,
		WIRE_SHOCK,
		WIRE_IDSCAN,
		WIRE_LIGHT,
		WIRE_SPEAKER
	)
	add_duds(4)
	..()

/datum/wires/jukebox/interactable(mob/user)
	var/obj/machinery/jukebox/J = holder
	if(J.panel_open)
		return TRUE

/datum/wires/jukebox/get_status()
	var/obj/machinery/jukebox/J = holder
	var/list/status = list()
	status += "This is a test."
	return status
