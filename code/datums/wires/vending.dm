/datum/wires/vending
	holder_type = /obj/machinery/vending
	proper_name = "Automat"

/datum/wires/vending/New(atom/holder)
	wires = list(
		WIRE_THROW, WIRE_SHOCK, WIRE_SPEAKER,
		WIRE_CONTRABAND, WIRE_IDSCAN
	)
	add_duds(1)
	..()

/datum/wires/vending/interactable(mob/user)
	var/obj/machinery/vending/V = holder
	if(!issilicon(user) && V.seconds_electrified && V.shock(user, 100))
		return FALSE
	if(V.panel_open)
		return TRUE

/datum/wires/vending/get_status()
	var/obj/machinery/vending/V = holder
	var/list/status = list()
	status += "Pomarańczowa lampka [V.seconds_electrified ? "świeci się" : "nie świeci się"]."
	status += "Czerwona lampka [V.shoot_inventory ? "nie świeci się" : "mruga"]."
	status += "Zielona lampka [V.extended_inventory ? "świeci się" : "nie świeci się"]."
	status += "[V.scan_id ? "Fioletowa" : "Żółta"] lampka się świeci."
	status += "Dioda głośnika [V.shut_up ? "nie świeci się" : "świeci się"]."
	return status

/datum/wires/vending/on_pulse(wire)
	var/obj/machinery/vending/V = holder
	switch(wire)
		if(WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(WIRE_CONTRABAND)
			V.extended_inventory = !V.extended_inventory
		if(WIRE_SHOCK)
			V.seconds_electrified = MACHINE_DEFAULT_ELECTRIFY_TIME
		if(WIRE_IDSCAN)
			V.scan_id = !V.scan_id
		if(WIRE_SPEAKER)
			V.shut_up = !V.shut_up

/datum/wires/vending/on_cut(wire, mend)
	var/obj/machinery/vending/V = holder
	switch(wire)
		if(WIRE_THROW)
			V.shoot_inventory = !mend
		if(WIRE_CONTRABAND)
			V.extended_inventory = FALSE
		if(WIRE_SHOCK)
			if(mend)
				V.seconds_electrified = MACHINE_NOT_ELECTRIFIED
			else
				V.seconds_electrified = MACHINE_ELECTRIFIED_PERMANENT
		if(WIRE_IDSCAN)
			V.scan_id = mend
		if(WIRE_SPEAKER)
			V.shut_up = mend
