#define CUBE_PRODUCTION "production"
#define CUBE_RECHARGING "recharging"
#define CUBE_READY "ready"


/obj/machinery/cubeDispenser //Most customizable machine 2015
	name = "foodcube dispenser"
	desc = "It's at least better than eating without a table I guess."

	icon = 'icons/obj/machines/Foodcube.dmi'
	icon_state = "off"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/cubedispenser
	max_integrity = 250
	integrity_failure = 80

	// These allow for different icons when creating custom dispensers
	var/icon_off = "off"
	var/icon_on = "ready"
	var/icon_recharging = "on"
	var/icon_creating = "on"
	var/icon_ready = "on"
	var/icon_open = "off_maintenance"


	var/list/using_materials
	var/starting_amount = 5
	var/iron_cost = 0
	var/glass_cost = 0
	var/power_used = 1000
	var/gold_cost = 0
	var/copper_cost = 0

	var/mode = CUBE_READY
	var/timer
	var/cooldownTime = 600
	var/production_time = 30
	//The item the dispenser will create
	var/dispense_type = /obj/item/reagent_containers/food/snacks/foodcube


	var/maximum_idle = 3

	var/work_sound = 'sound/items/rped.ogg'
	var/create_sound = 'sound/items/deconstruct.ogg'

	var/begin_create_message = "brrrr..."
	var/end_create_message = "dispenses a cube."
	var/recharge_message = "pings."
	var/recharging_text = "It is whirring and clicking. It seems to be recharging."

	var/break_message = "lets out a tinny alarm before falling dark."
	var/break_sound = 'sound/machines/warning-buzzer.ogg'

/obj/machinery/cubeDispenser/Initialize()
	. = ..()
	var/datum/component/material_container/materials = AddComponent(/datum/component/material_container, list(/datum/material/iron, /datum/material/glass,  /datum/material/copper, /datum/material/gold), MINERAL_MATERIAL_AMOUNT * MAX_STACK_SIZE * 2, TRUE, /obj/item/stack)
	materials.insert_amount_mat(starting_amount)
	materials.precise_insertion = TRUE
	using_materials = list(/datum/material/iron = iron_cost, /datum/material/glass = glass_cost, /datum/material/copper = copper_cost, /datum/material/gold = gold_cost)

/obj/machinery/cubeDispenser/examine(mob/user)
	. = ..()
	if((mode == CUBE_RECHARGING) && !stat && recharging_text)
		. += "<span class='warning'>[recharging_text]</span>"

/obj/machinery/cubeDispenser/power_change()
	..()
	if(powered())
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon()

/obj/machinery/cubeDispenser/process()
	..()
	if((stat & (NOPOWER|BROKEN)) || !anchored)
		return

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(!materials.has_materials(using_materials))
		return // We require more minerals

	// We are currently in the middle of something
	if(timer > world.time)
		return

	switch(mode)
		if(CUBE_READY)

			if(maximum_idle && (count_shells() >= maximum_idle))
				return // then do nothing; check again next tick
			if(begin_create_message)
				visible_message("<span class='notice'>[src] [begin_create_message]</span>")
			if(work_sound)
				playsound(src, work_sound, 50, 1)

			mode = CUBE_PRODUCTION
			timer = world.time + production_time
			update_icon()

		if(CUBE_PRODUCTION)
			materials.use_materials(using_materials)
			if(power_used)
				use_power(power_used)

			var/atom/A = new dispense_type(loc)
			A.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)

			if(create_sound)
				playsound(src, create_sound, 50, 1)
			if(end_create_message)
				visible_message("<span class='notice'>[src] [end_create_message]</span>")

			mode = CUBE_RECHARGING
			timer = world.time + cooldownTime
			update_icon()

		if(CUBE_RECHARGING)
			if(recharge_message)
				visible_message("<span class='notice'>[src] [recharge_message]</span>")

			mode = CUBE_READY
			update_icon()

/obj/machinery/cubeDispenser/proc/count_shells()
	. = 0
	for(var/a in loc)
		if(istype(a, dispense_type))
			.++

/obj/machinery/cubeDispenser/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else if(panel_open)
		icon_state = icon_open
	else if(mode == CUBE_PRODUCTION)
		icon_state = icon_creating
	else if(mode == CUBE_RECHARGING)
		icon_state = icon_recharging
	else
		icon_state = icon_on

/obj/machinery/cubeDispenser/attackby(obj/item/I, mob/living/user)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!(stat & BROKEN))
			to_chat(user, "<span class='warning'>[src] doesn't need repairs.</span>")
			return

		if(!I.tool_start_check(user, amount=1))
			return

		user.visible_message(
			"<span class='notice'>[user] begins patching up [src] with [I].</span>",
			"<span class='notice'>You begin restoring the damage to [src]...</span>")

		if(!I.use_tool(src, user, 40, volume=50, amount=1))
			return

		user.visible_message(
			"<span class='notice'>[user] fixes [src]!</span>",
			"<span class='notice'>You restore [src] to operation.</span>")

		stat &= ~BROKEN
		obj_integrity = max_integrity
		update_icon()
	else
		return ..()

/obj/machinery/cubeDispenser/obj_break(damage_flag)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(stat & BROKEN))
			if(break_message)
				audible_message("<span class='warning'>[src] [break_message]</span>")
			if(break_sound)
				playsound(src, break_sound, 50, 1)
			stat |= BROKEN
			update_icon()

/obj/machinery/cubeDispenser/attackby(obj/item/I, mob/user, params)

	if(!occupant && default_deconstruction_screwdriver(user, icon_state, icon_state, I))//sent icon_state is irrelevant...
		update_icon()//..since we're updating the icon here, since the scanner can be unpowered when opened/closed

		return

	if(default_pry_open(I))
		return

	if(default_deconstruction_crowbar(I))
		return

	return ..()

#undef CUBE_PRODUCTION
#undef CUBE_RECHARGING
#undef CUBE_READY

