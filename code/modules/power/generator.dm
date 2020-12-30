/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = TRUE
	use_power = NO_POWER_USE

	var/obj/machinery/atmospherics/components/binary/circulator/cold_circ
	var/obj/machinery/atmospherics/components/binary/circulator/hot_circ
	var/tier = 0
	var/lastgen = 0
	var/lastgenlev = -1
	var/lastcirc = "00"


/obj/machinery/power/generator/Initialize(mapload)
	. = ..()
	find_circs()
	connect_to_network()
	SSair.atmos_machinery += src
	update_icon()
	//stock parts needed for TEG
	component_parts = list(new /obj/item/circuitboard/machine/generator,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stack/sheet/glass,
		new /obj/item/stack/sheet/glass,
		new /obj/item/stack/cable_coil/five)

/obj/machinery/power/generator/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS )

/obj/machinery/power/generator/Destroy()
	kill_circs()
	SSair.atmos_machinery -= src
	return ..()

/obj/machinery/power/generator/update_icon()

	if(stat & (NOPOWER|BROKEN))
		cut_overlays()
	else
		cut_overlays()

	if(panel_open)
		add_overlay("teg-ov-open")

	//display front wall of TEG when facing east or west
	if((dir == EAST || dir == WEST) && (!hot_circ || !cold_circ))
		add_overlay(image('icons/obj/power.dmi', "teg_front", GAS_PIPE_VISIBLE_LAYER, pixel_y = -32))

	//display overlay
	if(!hot_circ && !cold_circ && anchored)
		add_overlay("teg-disp-error")
	else
		if(hot_circ.loc == get_step(src, EAST) || hot_circ.loc == get_step(src, SOUTH))
			add_overlay("teg-disp-hotright")
		else if(cold_circ.loc == get_step(src, EAST) || cold_circ.loc == get_step(src, SOUTH))
			add_overlay("teg-disp-coldright")

		if(hot_circ.loc == get_step(src, WEST) || hot_circ.loc == get_step(src, NORTH))
			add_overlay("teg-disp-hotleft")
		else if(cold_circ.loc == get_step(src, WEST) || cold_circ.loc == get_step(src, NORTH))
			add_overlay("teg-disp-coldleft")

	//power level overlay
	var/L = min(round(lastgenlev/(83333)),18)
	if(L != 0 && anchored)
		//if outputting power level that may result in explosion when damaged, start blinking
		if(lastgenlev > 1500000 + tier)
			add_overlay(image('icons/obj/power.dmi', "teg-critical"))
			return
		add_overlay(image('icons/obj/power.dmi', "teg-op[L]"))

#define GENRATE 800		// generator output coefficient from Q

//Handles atmos stuff and power generation math
/obj/machinery/power/generator/process_atmos()

	if(!cold_circ || !hot_circ)
		return

	if(powernet)
		var/datum/gas_mixture/cold_air = cold_circ.return_transfer_air()
		var/datum/gas_mixture/hot_air = hot_circ.return_transfer_air()

		if(cold_air && hot_air)

			var/cold_air_heat_capacity = cold_air.heat_capacity()
			var/hot_air_heat_capacity = hot_air.heat_capacity()

			var/delta_temperature = hot_air.return_temperature() - cold_air.return_temperature()

			//can we start heat transfer thing and potentially start generating power?
			if(delta_temperature > 0 && cold_air_heat_capacity > 0 && hot_air_heat_capacity > 0)
				var/efficiency = 0.35
				var/techbonus

				//stock parts power generation bonus
				if((cold_circ.eff+hot_circ.eff)/2000 < 1)
					techbonus = 0
				else
					techbonus = (log((cold_circ.eff+hot_circ.eff)/2000))

				//secret ingredient that will help us later
				var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)
				var/heat = energy_transfer*(1-efficiency)

				//minimal delta T for TEG to actually start generating power, math defines power output
				if(delta_temperature > 1500)
					lastgen += ((energy_transfer*efficiency)+(energy_transfer*(techbonus/3)))/10

				//math responsible for cooling hot loop gas and heating up cold loop gas
				hot_air.set_temperature(hot_air.return_temperature() - energy_transfer/hot_air_heat_capacity)
				cold_air.set_temperature(cold_air.return_temperature() + heat/cold_air_heat_capacity)

				//add_avail(lastgen) This is done in process now
		// update icon overlays only if displayed level has changed

		if(hot_air)
			var/datum/gas_mixture/hot_circ_air1 = hot_circ.airs[1]
			hot_circ_air1.merge(hot_air)

		if(cold_air)
			var/datum/gas_mixture/cold_circ_air1 = cold_circ.airs[1]
			cold_circ_air1.merge(cold_air)

		update_icon()

	var/circ = "[cold_circ && cold_circ.last_pressure_delta > 0 ? "1" : "0"][hot_circ && hot_circ.last_pressure_delta > 0 ? "1" : "0"]"
	if(circ != lastcirc)
		lastcirc = circ
		update_icon()

	src.updateDialog()

//Main proc
/obj/machinery/power/generator/process()
	var/ohno = FALSE

	//stock parts effect on TEG performance
	if(cold_circ && hot_circ)
		tier = (cold_circ.eff + hot_circ.eff)*2
	else
		tier = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		tier += (abs(MB.rating-1))*2000
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		tier += (abs(SM.rating-1))*2000
	//How fast power output changes (higher divider, slower change)
	var/power_output = round(lastgen / 20)
	add_avail(power_output)
	lastgenlev = power_output
	lastgen -= power_output
	//how damaged TEG needs to be to explode from overload
	if(src.obj_integrity < 75)
		ohno = TRUE
	//menacing hum
	if(power_output > 1500000 + tier)
		playsound(src, 'sound/machines/sm/loops/delamming.ogg', 50, TRUE, 10)
		//create explosion scaled with output
		if(ohno)
			var/turf/T = get_turf(src)
			explosion(T, round(0.5*(power_output/(1500000 + tier))), round(1*(power_output/(1500000 + tier))), round(1.5*(power_output/(1500000 + tier))), round(2*(power_output/(1500000 + tier))), adminlog = TRUE, ignorecap = FALSE, flame_range = round(2.5*(power_output/(1500000 + tier))), silent = FALSE, smoke = FALSE)

	..()

//TEG UI
/obj/machinery/power/generator/proc/get_menu(include_link = TRUE)
	var/t = ""
	if(!powernet)
		t += "<span class='bad'>Unable to connect to the power network!</span>"
	else if(cold_circ && hot_circ)
		var/datum/gas_mixture/cold_circ_air1 = cold_circ.airs[1]
		var/datum/gas_mixture/cold_circ_air2 = cold_circ.airs[2]
		var/datum/gas_mixture/hot_circ_air1 = hot_circ.airs[1]
		var/datum/gas_mixture/hot_circ_air2 = hot_circ.airs[2]

		t += "<div class='statusDisplay'>"

		t += "Output: [DisplayPower(lastgenlev)]"

		t += "<BR>"

		t += "<B><font color='blue'>Cold loop</font></B><BR>"
		t += "Temperature Inlet: [round(cold_circ_air2.return_temperature(), 0.1)] K / Outlet: [round(cold_circ_air1.return_temperature(), 0.1)] K<BR>"
		t += "Pressure Inlet: [round(cold_circ_air2.return_pressure(), 0.1)] kPa /  Outlet: [round(cold_circ_air1.return_pressure(), 0.1)] kPa<BR>"

		t += "<B><font color='red'>Hot loop</font></B><BR>"
		t += "Temperature Inlet: [round(hot_circ_air2.return_temperature(), 0.1)] K / Outlet: [round(hot_circ_air1.return_temperature(), 0.1)] K<BR>"
		t += "Pressure Inlet: [round(hot_circ_air2.return_pressure(), 0.1)] kPa / Outlet: [round(hot_circ_air1.return_pressure(), 0.1)] kPa<BR>"

		t += "</div>"
	else if(!hot_circ && cold_circ)
		t += "<span class='bad'>Unable to locate hot circulator!</span>"
	else if(hot_circ && !cold_circ)
		t += "<span class='bad'>Unable to locate cold circulator!</span>"
	else
		t += "<span class='bad'>Unable to locate any parts!</span>"
	if(include_link)
		t += "<BR><A href='?src=[REF(src)];close=1'>Close</A>"

	return t

/obj/machinery/power/generator/ui_interact(mob/user)
	. = ..()
	var/datum/browser/popup = new(user, "teg", "Thermo-Electric Generator", 460, 300)
	popup.set_content(get_menu())
	popup.open()

/obj/machinery/power/generator/Topic(href, href_list)
	if(..())
		return
	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return FALSE
	return TRUE


/obj/machinery/power/generator/power_change()
	..()
	update_icon()

//linking circulators
/obj/machinery/power/generator/proc/find_circs()
	kill_circs()
	var/list/circs = list()
	var/obj/machinery/atmospherics/components/binary/circulator/C
	var/circpath = /obj/machinery/atmospherics/components/binary/circulator
	if(dir == NORTH || dir == SOUTH)
		C = locate(circpath) in get_step(src, EAST)
		if(C?.dir == WEST)
			circs += C

		C = locate(circpath) in get_step(src, WEST)
		if(C?.dir == EAST)
			circs += C

	else
		C = locate(circpath) in get_step(src, NORTH)
		if(C?.dir == SOUTH)
			circs += C

		C = locate(circpath) in get_step(src, SOUTH)
		if(C?.dir == NORTH)
			circs += C

	if(circs.len)
		for(C in circs)
			if(C.mode == CIRCULATOR_COLD && !cold_circ)
				cold_circ = C
				C.generator = src
			else if(C.mode == CIRCULATOR_HOT && !hot_circ)
				hot_circ = C
				C.generator = src

//tool interactions
/obj/machinery/power/generator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE
	else
		default_unfasten_wrench(user, I)
	if(!anchored)
		kill_circs()
	connect_to_network()
	update_icon()
	return TRUE

/obj/machinery/power/generator/multitool_act(mob/living/user, obj/item/I)
	if(!anchored)
		return
	find_circs()
	to_chat(user, "<span class='notice'>You update [src]'s circulator links.</span>")
	return TRUE

/obj/machinery/power/generator/screwdriver_act(mob/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	return TRUE

/obj/machinery/power/generator/crowbar_act(mob/user, obj/item/I)
	default_deconstruction_crowbar(I)
	return TRUE

/obj/machinery/power/generator/welder_act(mob/living/user, obj/item/I)
	if(obj_integrity != max_integrity && user.a_intent == INTENT_HELP)
		if(!I.tool_start_check(user, amount=15))
			return
		user.visible_message(
			"<span class='notice'>[user] begins patching up [src] with [I].</span>",
			"<span class='notice'>You begin restoring the damage to [src]...</span>")
		I.use_tool(src, user, 40, amount=15, volume=50)
		user.visible_message(
			"<span class='notice'>[user] fixes [src]!</span>",
			"<span class='notice'>You repair [src].</span>")
		obj_integrity = max_integrity
		return
	else if(user.a_intent != INTENT_HELP)
		..()



/obj/machinery/power/generator/on_deconstruction()
	kill_circs()

/obj/machinery/power/generator/proc/kill_circs()
	if(hot_circ)
		hot_circ.generator = null
		hot_circ = null
	if(cold_circ)
		cold_circ.generator = null
		cold_circ = null
