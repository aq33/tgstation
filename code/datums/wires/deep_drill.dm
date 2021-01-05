/datum/wires/mineral/deep_drill
	holder_type = /obj/machinery/mineral/deep_drill
	proper_name = "Heavy-Duty Mining Rig"

/datum/wires/mineral/deep_drill/New(atom/holder)
	wires = list(
		WIRE_HACK, WIRE_DISABLE,
		WIRE_SHOCK, WIRE_ZAP
	)
	add_duds(4)
	..()

/datum/wires/mineral/deep_drill/interactable(mob/user)
	var/obj/machinery/mineral/deep_drill/A = holder
	if(A.panel_open && !A.cell)
		return TRUE

/datum/wires/mineral/deep_drill/get_status()
	var/obj/machinery/mineral/deep_drill/A = holder
	var/list/status = list()
	status += "Czerwona kontrolka [A.disabled ? "świeci się" : "nie świeci się"]."
	status += "Serwo taśmy jest [A.hacked ? "włączone" : "wyłączone"]."
	return status

/datum/wires/mineral/deep_drill/on_pulse(wire)
	var/obj/machinery/mineral/deep_drill/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.pulse_eject(!A.hacked)
			addtimer(CALLBACK(A, /obj/machinery/mineral/deep_drill.proc/reset, wire), 10)
		if(WIRE_SHOCK)
			A.shocked = !A.shocked
			addtimer(CALLBACK(A, /obj/machinery/mineral/deep_drill.proc/reset, wire), 60)
		if(WIRE_DISABLE)
			A.disabled = !A.disabled
			addtimer(CALLBACK(A, /obj/machinery/mineral/deep_drill.proc/reset, wire), 60)

/datum/wires/mineral/deep_drill/on_cut(wire, mend)
	var/obj/machinery/mineral/deep_drill/A = holder
	switch(wire)
		if(WIRE_HACK)
			A.pulse_eject(!mend)
		if(WIRE_HACK)
			A.shocked = !mend
		if(WIRE_DISABLE)
			A.disabled = !mend
		if(WIRE_ZAP)
			A.shock(usr, 50)
