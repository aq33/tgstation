/obj/machinery/mineral/deep_drill
	name = "heavy-duty mining rig"
	desc = "Piece of heavy machinery designed to extract materials from the underground deposits."
	icon = 'icons/mecha/mech_fab.dmi'
	icon_state = "deep_drill-off"
	density = TRUE
	//circuit = /obj/item/circuitboard/machine/deep_drill
	layer = BELOW_OBJ_LAYER
	var/bluespace_upgrade = FALSE //Can it link with Ore Silo?
	var/on = FALSE
	var/energy_coeff //How good at not discharging
	var/efficiency_coeff //How good at mining
	var/power_draw = 0
	var/datum/component/remote_materials/materials
	var/obj/item/stock_parts/cell/cell

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/hack_wire
	var/disable_wire
	var/shock_wire

	var/overlayopen = "deep_drill-ovopen"
	var/overlayeject = "deep_drill-oveject"
	var/overlaymining = "deep_drill-ovdrilling"

/obj/machinery/mineral/deep_drill/Initialize(mapload)
	. = ..()
	wires = new /datum/wires/mineral/deep_drill(src)
	materials = AddComponent(/datum/component/remote_materials, "bsm", mapload)
	component_parts = list(	new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/matter_bin,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/manipulator,
		new /obj/item/stock_parts/capacitor,
		new /obj/item/pickaxe/drill)
	//cell = new(src)
	RefreshParts()

/obj/machinery/mineral/deep_drill/on_deconstruction()
	if(cell)
		component_parts += cell
		cell = null
	return ..()

/obj/machinery/mineral/deep_drill/Destroy()
	QDEL_NULL(wires)
	drill_eject_mats()
	materials = null
	return ..()

/obj/machinery/mineral/deep_drill/RefreshParts() //Stock Part Effects
	efficiency_coeff = 0.8
	energy_coeff = 1.1
	for(var/obj/item/pickaxe/drill/diamonddrill/DD in component_parts)
		efficiency_coeff = 1.1
		energy_coeff = 1.5
	if(materials)
		var/total_storage = 0
		for(var/obj/item/stock_parts/matter_bin/M in component_parts)
			total_storage += M.rating * 50000
		materials.set_local_size(total_storage)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		efficiency_coeff += M.rating * 0.1
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		energy_coeff -= C.rating * 0.1

	power_draw = efficiency_coeff * 10 * energy_coeff //This defines how much power draw_power() should draw

//INTERACTIONS//////////////////////

/obj/machinery/mineral/deep_drill/examine(mob/user) //:eyes:
	. = ..()
	if(bluespace_upgrade && on) //Ore Silo status
		if(!materials?.silo)
			. += "<span class='notice'>No ore silo connected. Use a multi-tool to link an ore silo to this machine.</span>"
		else if(materials?.on_hold())
			. += "<span class='warning'>Ore silo access is on hold, please contact the quartermaster.</span>"
		else
			. += "<span class='notice'>It's connected to the ore silo.</span>"

	if(on && cell && cell.charge > 0) //Is it powered?
		. += "The charge meter reads [cell ? round(cell.percent(), 1) : 0]%."
		. += "Current power draw: [cell ? round(power_draw, 1) : 0]W."
	else
		. += "It appears to be unpowered."

	if(panel_open) //What about hatch?
		. += "<span class='notice'>Its maintenance hatch is open.</span>"
		if(cell)
			. += "<span class='notice'>There is a [cell] installed.</span>"
		else
			. += "<span class='warning'> There is no power cell installed!<span>"

/obj/machinery/mineral/deep_drill/interact(mob/user)
	shock(user, 70)
	if(on && !panel_open)
		on = FALSE
		to_chat(user, "<span class='notice'>You switch the [src] off.</span>")
	else if(!on && !panel_open)
		on = TRUE
		to_chat(user, "<span class='notice'>You switch the [src] on.</span>")
	if(!cell)
		return
	if(panel_open && cell)
		to_chat(user, "<span class='notice'>You remove the [cell] from the [src]</span>")
		user.put_in_hands(cell)
		cell.add_fingerprint(user)
		cell = null

/obj/machinery/mineral/deep_drill/AltClick(mob/user) //When alt-clicked the drill will try to drop stored mats.
	shock(user, 70)
	if(user.canUseTopic(src, !issilicon(usr)))
		drill_eject_mats()

/obj/machinery/mineral/deep_drill/multitool_act(mob/living/user, obj/item/multitool/M) //Handles linking to Ore Silo if drill has Bluespace Resource Transfer Upgrade
	if(bluespace_upgrade)
		return FALSE
	if(istype(M))
		if(!M.buffer || !istype(M.buffer, /obj/machinery/ore_silo))
			to_chat(user, "<span class='warning'>You need to multitool the ore silo first.</span>")
			return FALSE

/obj/machinery/mineral/deep_drill/attackby(obj/item/I, mob/user, params) //Handles decon, power cell manipulations and upgrade module
	shock(user, 50) //before anything, try to shock the user
	if(user.a_intent == INTENT_HARM) //so we can hit the machine
		return ..()

	add_fingerprint(user)
	if(istype(I, /obj/item/stock_parts/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "<span class='warning'>There is already a power cell inside!</span>")
				return
			else
				user.transferItemToLoc(I, src)
				cell = I
				I.add_fingerprint(usr)
				user.visible_message("<span class='notice'>\The [user] inserts a power cell into \the [src].</span>", "<span class='notice'>You insert the power cell into \the [src].</span>")
				return
		else
			to_chat(user, "<span class='warning'>The maintenance hatch must be open to install the [I]!</span>")
			return

	else if(istype(I, /obj/item/disk/cargo/silo_drill))
		if(panel_open)
			if(!bluespace_upgrade)
				user.visible_message("<span class='notice'>\The [user] inserts a device into \the [src].</span>", "<span class='notice'>You insert the upgrade module into \the [src].</span>")
				user.transferItemToLoc(I, src)
				bluespace_upgrade = TRUE
				return
		else
			to_chat(user, "<span class='warning'>The maintenance hatch must be open to install the [I]!</span>")
			return

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		default_deconstruction_screwdriver(user, "deep_drill-off", "deep_drill-on", I)
		return

	else if(panel_open && is_wire_tool(I))
		if(!cell)
			wires.interact(user)
			return
		else
			to_chat(user, "<span class='warning'>You must remove the cell first!</span>")
			return

	else if(default_deconstruction_crowbar(I))
		return
	else
		return ..()

//PROCS//////////////////////

/obj/machinery/mineral/deep_drill/proc/drill_eject_mats(mob/user) //Eject mats if possible
	if(materials?.silo)
		to_chat(user, "<span class='warning'>[src] can't eject materials from the silo!</span>")
		return FALSE
	if(on && cell && cell.charge > 0)
		var/location = get_step(src,EAST)
		var/datum/component/material_container/mat_container = materials.mat_container
		mat_container.retrieve_all(location)
		to_chat(user, "<span class='notice'>You eject the materials from [src].</span>")
		return TRUE
	else
		to_chat(user, "<span class='warning'>[src] must be on to eject materials!</span>")
		return FALSE

/obj/machinery/mineral/deep_drill/proc/drill_mats() //Actually do the mining thing
	var/datum/component/material_container/mat_container = materials.mat_container
	var/turf/open/floor/plating/asteroid/basalt/vein/T = loc
	var/datum/material/ore = pick(T.ore_rates)
	mat_container.insert_amount_mat((T.ore_rates[ore] * 1000*efficiency_coeff), ore)
	draw_power()

obj/machinery/mineral/deep_drill/proc/draw_power() //This draws power from the cell when called
	cell.use(power_draw)

/obj/machinery/mineral/deep_drill/update_icon(stat)
	//cut_overlays()
	//SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	if(panel_open)
		add_overlay(overlayopen)
		return
	else
		cut_overlay(overlayopen)
		return
	if(on && cell && cell.charge > 0)
		icon_state = "deep_drill-on"
		if("eject")
			add_overlay(overlayeject)
			sleep(6)
			cut_overlay(overlayeject)
			return
		if("mining")
			add_overlay(overlaymining)
			return
	else
		cut_overlays()
		icon_state = "deep_drill-off"
		return
	stat = null

//HACKING PROCS//

/obj/machinery/mineral/deep_drill/proc/reset(wire) //Fixing wires
	switch(wire)
		if(WIRE_HACK)
			if(!wires.is_cut(wire))
				pulse_eject(FALSE)
		if(WIRE_SHOCK)
			if(!wires.is_cut(wire))
				shocked = FALSE
		if(WIRE_DISABLE)
			if(!wires.is_cut(wire))
				disabled = FALSE

/obj/machinery/mineral/deep_drill/proc/shock(mob/user, prb) //Zap the user when checks are passed
	if(shocked && cell.charge > 100 && !prob(prb))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(electrocute_mob(user, get_area(src), src, 0.7, TRUE))
			cell.use(100)
		return TRUE
	else
		return FALSE

/obj/machinery/mineral/deep_drill/proc/pulse_eject(state) //Eject mats when hack wire is cut/pulsed
	hacked = state
	if(hacked)
		drill_eject_mats()
		return

//////////////////////

/obj/machinery/mineral/deep_drill/process() //Heart of this
	if(disabled)
		on = FALSE
		return
	if(on && cell && cell.charge > 0)
		if(istype(get_turf(src), /turf/open/floor/plating/asteroid/basalt/vein))
			drill_mats()
		else
			power_draw = 0

//MISC STUFF//////////////////////

/obj/item/disk/cargo/silo_drill
	name = "Bluespace Resource Transfer Upgrade"
	desc = "Upgrade module for drill rigs allowing for remote transfer of the resources."
	icon = 'icons/obj/module.dmi'
	icon_state = "cargodisk"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL

/*
Roadmap:
-Produkcja materiałów zależnie od turfa DONE
-Stock parts DONE
-Lokalne materiały i możliwość linkowania po upgrade DONE
-Wariant z Diamond Drillem DONE
-Wariant z Plasma Cutterem
-tgui?
-Techweb
-Drop pod z wiertłem
-generowanie mining points
-random gen veinów
-dźwięk wiertła
-sprite states wiertła WIP
-wypadanie materiałów obok wiertła DONE
-BS Miner goes yeet (inny PR?)
-zużycie baterii DONE
-Kable DONE/BUGI

ISSUES:
-użycie ręki otwiera menu kabelków zamiast wyjąć baterię
-drill nie razi prądem nawet gdy warunki są spełnione
*/

