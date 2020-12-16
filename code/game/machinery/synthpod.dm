/obj/machinery/synthpod
	name = "synth pod"
	desc = "An advanced machine used for converting its occupant into a synth."
	density = TRUE
	state_open = FALSE
	icon = 'icons/obj/machines/autodoc.dmi'
	icon_state = "autodoc_machine"
	verb_say = "states"
	idle_power_usage = 50
	circuit = /obj/item/circuitboard/machine/synthpod
	var/processing = FALSE
	var/surgerytime = 300

/obj/machinery/synthpod/Initialize()
	. = ..()
	update_icon()

/obj/machinery/synthpod/RefreshParts()
	var/max_time = 500
	for(var/obj/item/stock_parts/L in component_parts)
		max_time -= (L.rating*15)
	surgerytime = max(max_time,15)

/obj/machinery/synthpod/examine(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		if(panel_open)
			. += "<span class='warning'>[src]'s conversion protocols have been corrupted!</span>"
		else
			. += "<span class='warning'>[src]'s control panel is slightly smoking.</span>"
	if(processing)
		. += "<span class='notice'>[src] is currently converting [occupant].</span>"

/obj/machinery/synthpod/close_machine(mob/user)
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(occupant)
		if(!ishuman(occupant) || isipc(occupant) || issynth(occupant))
			occupant.forceMove(drop_location())
			occupant = null
			return
		var/mob/living/carbon/human/mob_occupant = occupant
		if(mob_occupant.stat == DEAD)
			occupant.forceMove(drop_location())
			occupant = null
			return
		to_chat(occupant, "<span class='notice'>You enter [src]</span>")

		convert()

/obj/machinery/synthpod/proc/convert()
	var/mob/living/carbon/human/C = occupant
	
	occupant.visible_message("<span class='notice'>[occupant] presses a button on [src], and you hear a mechanical noise.</span>", "<span class='notice'>You feel a sharp sting as [src] starts the conversion procedure.</span>")
	playsound(get_turf(occupant), 'sound/weapons/circsawhit.ogg', 50, 1)
	processing = TRUE
	update_icon()
	sleep(surgerytime)
	
	if(!processing)
		return
	
	var/mob/living/carbon/human/dummy = new /mob/living/carbon/human(loc)
	C.dna.transfer_identity(dummy) //copypasta regenerative blacka
	dummy.updateappearance(mutcolor_update=1)
	dummy.real_name = C.real_name
	dummy.adjustBruteLoss(C.getBruteLoss())
	dummy.adjustFireLoss(C.getFireLoss())
	ADD_TRAIT(dummy, TRAIT_EMOTEMUTE, "conversion")		//dziwne rozwiązanie dziwnego błędu. z jakiegoś powodu ciała używały deathgasp z innym imieniem niż powinny mieć.
	dummy.death()										//prawdopodobnie transfer_identity działa z opóźnieniem. próbowałem spawn(0), ale nie pomogło, więc możemy tylko wyciszyć deathgaspa
	REMOVE_TRAIT(dummy, TRAIT_EMOTEMUTE, "conversion")
	
	if(obj_flags & EMAGGED)
		C.set_species(/datum/species/ipc)
	else
		C.set_species(/datum/species/synth)
	
	occupant.visible_message("<span class='notice'>[src] completes the conversion procedure")
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, 0)
	processing = FALSE
	open_machine()

/obj/machinery/synthpod/open_machine(mob/user)
	if(processing)
		occupant.visible_message("<span class='notice'>[user] cancels [src]'s procedure", "<span class='notice'>[src] stops the conversion procedure.</span>")
		processing = FALSE
	if(occupant)
		occupant.forceMove(drop_location())
		occupant = null
	..(FALSE)

/obj/machinery/synthpod/interact(mob/user)
	if(panel_open)
		to_chat(user, "<span class='notice'>Close the maintenance panel first.</span>")
		return

	if(state_open)
		close_machine()
		return

	open_machine()

/obj/machinery/synthpod/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, "<span class='warning'>[src] is currently occupied!</span>")
		return
	if(state_open)
		to_chat(user, "<span class='warning'>[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!</span>")
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	return FALSE

/obj/machinery/synthpod/crowbar_act(mob/living/user, obj/item/I)
	if(default_deconstruction_crowbar(I))
		return TRUE


/obj/machinery/synthpod/update_icon()
	overlays.Cut()
	if(!state_open)
		if(processing)
			overlays += "[icon_state]_door_on"
			overlays += "[icon_state]_stack"
			overlays += "[icon_state]_smoke"
			overlays += "[icon_state]_green"
		else
			overlays += "[icon_state]_door_off"
			if(occupant)
				if(powered(AREA_USAGE_EQUIP))
					overlays += "[icon_state]_stack"
					overlays += "[icon_state]_yellow"
			else
				overlays += "[icon_state]_red"
	else if(powered(AREA_USAGE_EQUIP))
		overlays += "[icon_state]_red"
	if(panel_open)
		overlays += "[icon_state]_panel"

/obj/machinery/synthpod/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='warning'>You reprogram [src]'s conversion procedures.</span>")
