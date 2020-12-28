/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = TRUE
	use_power = NO_POWER_USE

	var/obj/machinery/atmospherics/components/binary/circulator/cold_circ
	var/obj/machinery/atmospherics/components/binary/circulator/hot_circ

	var/lastgen = 0
	var/lastgenlev = -1
	var/lastcirc = "00"


/obj/machinery/power/generator/Initialize(mapload)
	. = ..()
	find_circs()
	connect_to_network()
	SSair.atmos_machinery += src
	update_icon()
	component_parts = list(new /obj/item/circuitboard/machine/generator,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stock_parts/scanning_module,
		new /obj/item/stack/sheet/glass,
		new /obj/item/stack/sheet/glass,
		new /obj/item/stack/cable_coil,
		new /obj/item/stack/cable_coil,
		new /obj/item/stack/cable_coil,
		new /obj/item/stack/cable_coil,
		new /obj/item/stack/cable_coil)

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

		var/L = min(round(lastgenlev/(100000),11))
		if(L != 0)
			add_overlay(image('icons/obj/power.dmi', "teg-op[L]"))

		if(hot_circ && cold_circ)
			add_overlay("teg-oc[lastcirc]")


#define GENRATE 800		// generator output coefficient from Q

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

			if(delta_temperature > 0 && cold_air_heat_capacity > 0 && hot_air_heat_capacity > 0)
				var/efficiency = 0.35
				var/techbonus
				if((cold_circ.eff+hot_circ.eff)/2000 < 1)
					techbonus = 0
				else
					techbonus = (log((cold_circ.eff+hot_circ.eff)/2000))

				var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

				var/heat = energy_transfer*(1-efficiency)
				if(delta_temperature > 1500)
					lastgen += ((energy_transfer*efficiency)+(energy_transfer*(techbonus/3)))/10 //defines output

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

/obj/machinery/power/generator/process()
	var/tier
	var/ohno = FALSE
	if(cold_circ && hot_circ)
		tier = (cold_circ.eff + hot_circ.eff)*2
	else
		tier = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		tier += (abs(MB.rating-1))*2000
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		tier += (abs(SM.rating-1))*2000
	//Setting this number higher just makes the change in power output slower, it doesnt actualy reduce power output cause **math**
	var/power_output = round(lastgen / 20)
	add_avail(power_output)
	lastgenlev = power_output
	lastgen -= power_output
	if(src.obj_integrity < 75)
		ohno = TRUE
	if(power_output > 1500000 + tier)
		playsound(src, 'sound/machines/sm/loops/delamming.ogg', 50, TRUE, 10)
		if(ohno)
			var/turf/T = get_turf(src)
			explosion(T, round(min((lastgen/5000000)-tier, 4)), round(min((lastgen/4500000)-tier, 4)), round(min((lastgen/4500000)-tier, 5)), round(min((lastgen/4000000)-tier, 6)), adminlog = TRUE, ignorecap = FALSE, flame_range = round(min((lastgen/5000000)-tier, 7)), silent = FALSE, smoke = FALSE) //testowo eksplozja uszkodzonego TEGa skaluje się z outputem w momencie uszkodzenia

	..()


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

/obj/machinery/power/generator/wrench_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return
	anchored = !anchored
	I.play_tool_sound(src)
	if(!anchored)
		kill_circs()
	connect_to_network()
	to_chat(user, "<span class='notice'>You [anchored?"secure":"unsecure"] [src].</span>")
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
