/proc/get_abductor_console(team_number)
	for(var/obj/machinery/abductor/console/C in GLOB.machines)
		if(C.team_number == team_number)
			return C

//Common

/obj/machinery/abductor
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/team_number = 0

//Console

/obj/machinery/abductor/console
	name = "konsola porywaczy"
	desc = "Centrum Dowodzenia Statkiem."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "console"
	density = TRUE
	var/obj/item/abductor/gizmo/gizmo
	var/obj/item/clothing/suit/armor/abductor/vest/vest
	var/obj/machinery/abductor/experiment/experiment
	var/obj/machinery/abductor/pad/pad
	var/obj/machinery/computer/camera_advanced/abductor/camera
	var/list/datum/icon_snapshot/disguises = list()

/obj/machinery/abductor/console/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_ABDUCTOR_TRAINING) && !HAS_TRAIT(user.mind, TRAIT_ABDUCTOR_TRAINING))
		to_chat(user, "<span class='warning'>Zaczynasz wciskać obce przyciski na chybił trafił!</span>")
		if(do_after(user,100, target = src))
			TeleporterSend()
		return
	user.set_machine(src)
	var/dat = ""
	dat += "<H3> Abductsoft 3000 </H3>"

	if(experiment)
		var/points = experiment.points
		var/credits = experiment.credits
		dat += "Zebrane Próbki : [points] <br>"
		dat += "Kredyty Wyposażenia: [credits] <br>"
		dat += "<b>Prześlij dane w zamian za zasoby:</b><br>"
		dat += "<a href='?src=[REF(src)];dispense=baton'>Zaawansowana Pałka (2 Kredyty)</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=mind_device'>Interfejs Mentalny (2 Kredyty)</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=chem_dispenser'>Reagent Synthesizer (2 Kredyty)</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=helmet'>Hełm Agentaqt</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=vest'>Kamizelka Agenta</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=silencer'>Uciszacz Radiowy</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=tool'>Narzędzie Naukowe</A><br>"
		dat += "<a href='?src=[REF(src)];dispense=tongue'>Superlingual Matrix</a><br>"
	else
		dat += "<span class='bad'>NIE WYKRYTO MASZYNY EKSPERYMENTACYJNEJ</span> <br>"

	if(pad)
		dat += "<span class='bad'>Awaryjny System Teleportacyjny.</span>"
		dat += "<span class='bad'>Najpierw rozważ użycie głównej konsoli obserwacyjnej.</span>"
		dat += "<a href='?src=[REF(src)];teleporter_send=1'>Aktywuj Teleporter</A><br>"
		if(gizmo?.marked)
			dat += "<a href='?src=[REF(src)];teleporter_retrieve=1'>Odzyskaj Oznaczony Cel</A><br>"
		else
			dat += "<span class='linkOff'>Odzyskaj Oznaczony Cel</span><br>"
	else
		dat += "<span class='bad'>NIE WYKRYTO TELEPADA</span></br>"

	if(vest)
		dat += "<h4> Tryb Kamizelki Agenta </h4><br>"
		var/mode = vest.mode
		if(mode == VEST_STEALTH)
			dat += "<a href='?src=[REF(src)];flip_vest=1'>Combat</A>"
			dat += "<span class='linkOff'>Maskowanie</span>"
		else
			dat += "<span class='linkOff'>Walka</span>"
			dat += "<a href='?src=[REF(src)];flip_vest=1'>Stealth</A>"

		dat+="<br>"
		dat += "<a href='?src=[REF(src)];select_disguise=1'>Wybierz Przebranie Kamizelki Agenta</a><br>"
		dat += "<a href='?src=[REF(src)];toggle_vest=1'>[HAS_TRAIT_FROM(vest, TRAIT_NODROP, ABDUCTOR_VEST_TRAIT) ? "Odblokuj" : "Zablokuj"] Kamizelkę</a><br>"
	else
		dat += "<span class='bad'>NIE WYKRYTO KAMIZELKI AGENTA</span>"
	var/datum/browser/popup = new(user, "computer", "Abductor Console", 400, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/abductor/console/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(href_list["teleporter_send"])
		TeleporterSend()
	else if(href_list["teleporter_retrieve"])
		TeleporterRetrieve()
	else if(href_list["flip_vest"])
		FlipVest()
	else if(href_list["toggle_vest"])
		if(vest)
			vest.toggle_nodrop()
	else if(href_list["select_disguise"])
		SelectDisguise()
	else if(href_list["dispense"])
		switch(href_list["dispense"])
			if("baton")
				Dispense(/obj/item/abductor/baton,cost=2)
			if("helmet")
				Dispense(/obj/item/clothing/head/helmet/abductor)
			if("silencer")
				Dispense(/obj/item/abductor/silencer)
			if("tool")
				Dispense(/obj/item/abductor/gizmo)
			if("vest")
				Dispense(/obj/item/clothing/suit/armor/abductor/vest)
			if("mind_device")
				Dispense(/obj/item/abductor/mind_device,cost=2)
			if("chem_dispenser")
				Dispense(/obj/item/abductor_machine_beacon/chem_dispenser,cost=2)
			if("tongue")
				Dispense(/obj/item/organ/tongue/abductor)
	updateUsrDialog()

/obj/machinery/abductor/console/proc/TeleporterRetrieve()
	if(pad && gizmo && gizmo.marked)
		pad.Retrieve(gizmo.marked)

/obj/machinery/abductor/console/proc/TeleporterSend()
	if(pad)
		pad.Send()

/obj/machinery/abductor/console/proc/FlipVest()
	if(vest)
		vest.flip_mode()

/obj/machinery/abductor/console/proc/SelectDisguise(remote = FALSE)
	var/list/disguises2 = list()
	for(var/name in disguises)
		var/datum/icon_snapshot/snap = disguises[name]
		var/image/dummy = image(snap.icon, src, snap.icon_state)
		dummy.overlays = snap.overlays
		disguises2[name] = dummy

	var/entry_name
	if(remote)
		entry_name = show_radial_menu(usr, camera.eyeobj, disguises2, tooltips = TRUE)
	else
		entry_name = show_radial_menu(usr, src, disguises2, require_near = TRUE, tooltips = TRUE)

	var/datum/icon_snapshot/chosen = disguises[entry_name]
	if(chosen && vest && (remote || in_range(usr,src)))
		vest.SetDisguise(chosen)

/obj/machinery/abductor/console/proc/SetDroppoint(turf/open/location,user)
	if(!istype(location))
		to_chat(user, "<span class='warning'>Te miejsce nie jest bezpieczne dla obiektu testowego.</span>")
		return

	if(pad)
		pad.teleport_target = location
		to_chat(user, "<span class='notice'>Lokacja oznaczona jako miejsce wypuszczania obiektów testowych.</span>")


/obj/machinery/abductor/console/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/abductor/console/LateInitialize()
	if(!team_number)
		return

	for(var/obj/machinery/abductor/pad/p in GLOB.machines)
		if(p.team_number == team_number)
			pad = p
			break

	for(var/obj/machinery/abductor/experiment/e in GLOB.machines)
		if(e.team_number == team_number)
			experiment = e
			e.console = src

	for(var/obj/machinery/computer/camera_advanced/abductor/c in GLOB.machines)
		if(c.team_number == team_number)
			camera = c
			c.console = src

/obj/machinery/abductor/console/proc/AddSnapshot(mob/living/carbon/human/target)
	if(istype(target.get_item_by_slot(SLOT_HEAD), /obj/item/clothing/head/foilhat))
		say("Obiekt nosi specjalne ochronne nakrycie głowy, skanowanie nie jest możliwe!")
		return
	var/datum/icon_snapshot/entry = new
	entry.name = target.name
	entry.icon = target.icon
	entry.icon_state = target.icon_state
	entry.overlays = target.get_overlays_copy(list(HANDS_LAYER))	//ugh
	//Update old disguise instead of adding new one
	if(disguises[entry.name])
		disguises[entry.name] = entry
		return
	disguises[entry.name] = entry

/obj/machinery/abductor/console/proc/AddGizmo(obj/item/abductor/gizmo/G)
	if(G == gizmo && G.console == src)
		return FALSE

	if(G.console)
		G.console.gizmo = null

	gizmo = G
	G.console = src
	return TRUE

/obj/machinery/abductor/console/proc/AddVest(obj/item/clothing/suit/armor/abductor/vest/V)
	if(vest == V)
		return FALSE

	for(var/obj/machinery/abductor/console/C in GLOB.machines)
		if(C.vest == V)
			C.vest = null
			break

	vest = V
	return TRUE

/obj/machinery/abductor/console/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/abductor/gizmo) && AddGizmo(O))
		to_chat(user, "<span class='notice'>Łączysz narzędzie z konsolą.</span>")
	else if(istype(O, /obj/item/clothing/suit/armor/abductor/vest) && AddVest(O))
		to_chat(user, "<span class='notice'>Łączysz kamizelkę z konsolą.</span>")
	else
		return ..()



/obj/machinery/abductor/console/proc/Dispense(item,cost=1)
	if(experiment && experiment.credits >= cost)
		experiment.credits -=cost
		say("Nadlatuje Dostawa!")
		var/drop_location = loc
		if(pad)
			flick("alien-pad", pad)
			drop_location = pad.loc
		new item(drop_location)

	else
		say("Niewystarczająca ilość danych!")
