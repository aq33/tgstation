//node2, air2, network2 correspond to input
//node1, air1, network1 correspond to output
#define CIRCULATOR_HOT 0
#define CIRCULATOR_COLD 1

/obj/machinery/atmospherics/components/binary/circulator //stop, nerfhammer time
	name = "circulator/heat exchanger"
	desc = "A gas circulator pump and heat exchanger."
	icon_state = "circ-off-0"
	var/eff
	var/active = FALSE
	can_be_unanchored = TRUE
	var/last_pressure_delta = 0
	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY

	density = TRUE


	var/flipped = 0
	var/mode = CIRCULATOR_HOT
	var/obj/machinery/power/generator/generator

//default cold circ for mappers
/obj/machinery/atmospherics/components/binary/circulator/cold
	mode = CIRCULATOR_COLD

/obj/machinery/atmospherics/components/binary/circulator/Initialize(mapload)
	.=..()
	component_parts = list(new /obj/item/circuitboard/machine/circulator,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stack/sheet/plasteel,
		new /obj/item/stack/sheet/plasteel,
		new /obj/item/stack/sheet/plasteel,
		new /obj/item/stack/sheet/plasteel,
		new /obj/item/stack/sheet/plasteel,
		new /obj/item/stack/cable_coil/five)

/obj/machinery/atmospherics/components/binary/circulator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/atmospherics/components/binary/circulator/Destroy()
	if(generator)
		disconnectFromGenerator()
	return ..()

/obj/machinery/atmospherics/components/binary/circulator/proc/return_transfer_air()

	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	var/fric = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		fric = M.rating
	var/output_starting_pressure = air1.return_pressure()
	var/input_starting_pressure = air2.return_pressure()

	if(output_starting_pressure >= input_starting_pressure-(100/fric))
		//Need at least 100 KPa difference to overcome friction in the mechanism
		last_pressure_delta = 0
		return null

	//Calculate necessary moles to transfer using PV = nRT
	if(air2.return_temperature()>0)
		var/pressure_delta = (input_starting_pressure - output_starting_pressure)/2

		var/transfer_moles = pressure_delta*air1.return_volume()/(air2.return_temperature() * R_IDEAL_GAS_EQUATION)

		last_pressure_delta = pressure_delta

		//Actually transfer the gas
		var/datum/gas_mixture/removed = air2.remove(transfer_moles)

		update_parents()

		return removed

	else
		last_pressure_delta = 0

/obj/machinery/atmospherics/components/binary/circulator/process_atmos()
	..()
	update_icon()

/obj/machinery/atmospherics/components/binary/circulator/update_icon()
	if(stat & (NOPOWER|BROKEN))
		cut_overlays()
	else
		cut_overlays()

	//display front face if facing south
	if(dir == SOUTH && !generator)
		add_overlay(image('icons/obj/power.dmi', "teg_front", BELOW_OBJ_LAYER, pixel_y = -32))

	if(mode == CIRCULATOR_HOT && anchored)
		add_overlay(image('icons/obj/atmospherics/components/binary_devices.dmi', "circ-ov-hot"))
	else if(mode != CIRCULATOR_HOT && anchored)
		add_overlay(image('icons/obj/atmospherics/components/binary_devices.dmi', "circ-ov-cold"))

	//speen states
	if(!is_operational())
		icon_state = "circ-p-0"
	else if(last_pressure_delta > 0)
		if(last_pressure_delta > 1000)
			icon_state = "circ-run-0"
		else if(last_pressure_delta > 500)
			icon_state = "circ-mid-0"
		else
			icon_state = "circ-slow-0"
	else
		icon_state = "circ-off-0"

/obj/machinery/atmospherics/components/binary/circulator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return
	anchored = !anchored
	I.play_tool_sound(src)
	if(generator)
		disconnectFromGenerator()
	to_chat(user, "<span class='notice'>You [anchored?"secure":"unsecure"] [src].</span>")
	return TRUE


	var/obj/machinery/atmospherics/node1 = nodes[1]
	var/obj/machinery/atmospherics/node2 = nodes[2]

	if(node1)
		node1.disconnect(src)
		nodes[1] = null
		nullifyPipenet(parents[1])
	if(node2)
		node2.disconnect(src)
		nodes[2] = null
		nullifyPipenet(parents[2])

	if(anchored)
		SetInitDirections()
		atmosinit()
		node1 = nodes[1]
		if(node1)
			node1.atmosinit()
			node1.addMember(src)
		node2 = nodes[2]
		if(node2)
			node2.atmosinit()
			node2.addMember(src)
		build_network()

	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/SetInitDirections()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = EAST|WEST
		if(EAST, WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/components/binary/circulator/getNodeConnects()
	if(flipped)
		return list(turn(dir, 270), turn(dir, 90))
	return list(turn(dir, 90), turn(dir, 270))

/obj/machinery/atmospherics/components/binary/circulator/can_be_node(obj/machinery/atmospherics/target)
	if(anchored)
		return ..(target)
	return FALSE

/obj/machinery/atmospherics/components/binary/circulator/multitool_act(mob/living/user, obj/item/I)
	if(generator)
		disconnectFromGenerator()
	mode = !mode
	to_chat(user, "<span class='notice'>You set [src] to [mode?"cold":"hot"] mode.</span>")
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/atmospherics/components/binary/circulator/on_deconstruction()
	if(generator)
		disconnectFromGenerator()

/obj/machinery/atmospherics/components/binary/circulator/proc/disconnectFromGenerator()
	if(mode)
		generator.cold_circ = null
	else
		generator.hot_circ = null
	generator.update_icon()
	generator = null

/obj/machinery/atmospherics/components/binary/circulator/setPipingLayer(new_layer)
	..()
	pixel_x = 0
	pixel_y = 0

/obj/machinery/atmospherics/components/binary/circulator/setDir()
	..()
	update_icon()

obj/machinery/atmospherics/components/binary/circulator/RefreshParts()
	eff = 0
	for(var/obj/item/stock_parts/matter_bin/ccMB in component_parts)
		eff += (abs(ccMB.rating-1))*1000
	for(var/obj/item/stock_parts/manipulator/ccM in component_parts)
		eff += (abs(ccM.rating-1))*1000
