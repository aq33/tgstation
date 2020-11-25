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

/datum/wires/jukebox/on_pulse(wire)
	var/obj/machinery/jukebox/J = holder
	switch(wire)
		if(WIRE_SHOCK)
			J.seconds_electrified = MACHINE_DEFAULT_ELECTRIFY_TIME

/datum/wires/jukebox/on_cut(wire, mend)
	var/obj/machinery/jukebox/J = holder
	switch(wire)
		if(WIRE_ZAP1, WIRE_ZAP2)
			if(isliving(usr))
				J.shock(usr, 50)
		if(WIRE_SHOCK)
			if(mend)
				J.seconds_electrified = MACHINE_NOT_ELECTRIFIED
			else
				J.seconds_electrified = MACHINE_ELECTRIFIED_PERMANENT
