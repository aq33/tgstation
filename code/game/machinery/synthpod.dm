//Synth pod; buduje synthy wyglądające tak samo jak skanowana osoby

#define CLONE_INITIAL_DAMAGE     150    //Clones in clonepods start with 150 cloneloss damage and 150 brainloss damage, thats just logical
#define MINIMUM_HEAL_LEVEL 40

/obj/machinery/clonepod/synth
	name = "synth pod"
	desc = "A synth pod. It seems to be an early prototype of the device, originally planned to be used instead of standard-issue cloners."
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(ACCESS_ROBOTICS) //budowanie synthów to działka robotyków
	circuit = /obj/item/circuitboard/machine/clonepod/experimental
	internal_radio = FALSE

//Start building a synth in the pod!
/obj/machinery/clonepod/synth/growclone(clonename, ui, mutation_index, mindref, last_death, datum/species/mrace, list/features, factions, list/quirks, datum/bank_account/insurance)
	if(panel_open)
		return NONE
	if(mess || attempting)
		return NONE

	attempting = TRUE //One at a time!!
	countdown.start()

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)

	H.hardset_dna(ui, mutation_index, H.real_name, null, new /datum/species/synth, features)

	//H.set_species(/datum/species/synth)

	H.silent = 20 //Prevents an extreme edge case where clones could speak if they said something at exactly the right moment.
	occupant = H

	if(!clonename)	//to prevent null names
		clonename = "clone ([rand(1,999)])"
	H.real_name = clonename

	icon_state = "pod_1"
	//Get the clone body ready
	maim_clone(H)
	ADD_TRAIT(H, TRAIT_STABLEHEART, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_STABLELIVER, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_EMOTEMUTE, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_MUTE, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_NOBREATH, CLONING_POD_TRAIT)
	ADD_TRAIT(H, TRAIT_NOCRITDAMAGE, CLONING_POD_TRAIT)
	H.Unconscious(80)

	var/list/candidates = pollCandidatesForMob("Do you want to play as [clonename]'s synthetic clone?", null, null, null, 100, H, POLL_IGNORE_DEFECTIVECLONE)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		H.key = C.key

	if(grab_ghost_when == CLONER_FRESH_CLONE)
		H.grab_ghost()
		to_chat(H, "<span class='notice'><b>Consciousness slowly creeps over you as your body assembles.</b><br><i>So this is what being alive feels like?</i></span>")

	if(grab_ghost_when == CLONER_MATURE_CLONE)
		H.ghostize(TRUE)	//Only does anything if they were still in their old body and not already a ghost
		to_chat(H.get_ghost(TRUE), "<span class='notice'>Your body is beginning to assemble in a synth pod. You will become conscious when it is complete.</span>")

	if(H)
		H.faction |= factions

		H.set_cloned_appearance()

		H.set_suicide(FALSE)
	attempting = FALSE
	return CLONING_DELETE_RECORD | CLONING_SUCCESS //so that we don't spam clones with autoprocess unless we leave a body in the scanner

/obj/machinery/clonepod/synth/process()
	var/mob/living/mob_occupant = occupant

	if(!is_operational()) //Autoeject if power is lost
		if(mob_occupant)
			go_out()
			log_cloning("[key_name(mob_occupant)] ejected from [src] at [AREACOORD(src)] due to power loss.")

			connected_message("Synth Ejected: Loss of power.")

	else if(mob_occupant && (mob_occupant.loc == src))
		if(!reagents.has_reagent(/datum/reagent/medicine/synthflesh, fleshamnt))
			go_out()
			log_cloning("[key_name(mob_occupant)] ejected from [src] at [AREACOORD(src)] due to insufficient material.")
			connected_message("Synth Ejected: Not enough material.")
		if(mob_occupant.stat == DEAD)  //Autoeject corpses.
			go_out()
			log_cloning("[key_name(mob_occupant)] ejected from [src] at [AREACOORD(src)] after dying.")
			connected_message("Synth Rejected: Critical component failure.")

		else if(mob_occupant && mob_occupant.getBruteLoss() > (100 - heal_level))
			mob_occupant.Unconscious(80)
			var/dmg_mult = CONFIG_GET(number/damage_multiplier)
			 //Slowly get that clone healed and finished.
			mob_occupant.adjustBruteLoss(-((speed_coeff / 2) * dmg_mult))
			if(reagents.has_reagent(/datum/reagent/medicine/synthflesh, fleshamnt))
				reagents.remove_reagent(/datum/reagent/medicine/synthflesh, fleshamnt)
			else if(reagents.has_reagent(/datum/reagent/blood, fleshamnt*3))
				reagents.remove_reagent(/datum/reagent/blood, fleshamnt*3)
			var/progress = CLONE_INITIAL_DAMAGE - mob_occupant.getBruteLoss()
			// To avoid the default cloner making incomplete clones
			progress += (100 - MINIMUM_HEAL_LEVEL)
			var/milestone = CLONE_INITIAL_DAMAGE / flesh_number
			var/installed = flesh_number - unattached_flesh.len

			if((progress / milestone) >= installed)
				// attach some flesh
				var/obj/item/I = pick_n_take(unattached_flesh)
				if(isorgan(I))
					var/obj/item/organ/O = I
					O.organ_flags &= ~ORGAN_FROZEN
					O.Insert(mob_occupant)
				else if(isbodypart(I))
					var/obj/item/bodypart/BP = I
					BP.attach_limb(mob_occupant)

			use_power(7500) //This might need tweaking.

		else if(mob_occupant && (mob_occupant.getBruteLoss() <= (100 - heal_level)))
			connected_message("Assembly Process Complete.")
			// If the cloner is upgraded to debugging high levels, sometimes
			// organs and limbs can be missing.
			for(var/i in unattached_flesh)
				if(isorgan(i))
					var/obj/item/organ/O = i
					O.organ_flags &= ~ORGAN_FROZEN
					O.Insert(mob_occupant)
				else if(isbodypart(i))
					var/obj/item/bodypart/BP = i
					BP.attach_limb(mob_occupant)

			go_out()
			log_cloning("[key_name(mob_occupant)] completed assembly cycle in [src] at [AREACOORD(src)].")

	else if (!mob_occupant || mob_occupant.loc != src)
		occupant = null
		if (!mess && !panel_open)
			icon_state = "pod_0"
		use_power(200)

/obj/machinery/clonepod/synth/maim_clone(mob/living/carbon/human/H)
	if(!unattached_flesh)
		unattached_flesh = list()
	else
		for(var/fl in unattached_flesh)
			qdel(fl)
		unattached_flesh.Cut()

	H.adjustBruteLoss(CLONE_INITIAL_DAMAGE)     //syntki nie obslugują clonelossa (podobnie jak ipc) wiec operują na brute

	if(!HAS_TRAIT(H, TRAIT_NODISMEMBER))
		var/static/list/zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
		for(var/zone in zones)
			var/obj/item/bodypart/BP = H.get_bodypart(zone)
			if(BP)
				BP.drop_limb()
				BP.forceMove(src)
				unattached_flesh += BP

	for(var/o in H.internal_organs)
		var/obj/item/organ/organ = o
		if(!istype(organ) || (organ.organ_flags & ORGAN_VITAL))
			continue
		organ.organ_flags |= ORGAN_FROZEN
		organ.Remove(H, special=TRUE)
		organ.forceMove(src)
		unattached_flesh += organ

	flesh_number = unattached_flesh.len

//Prototype cloning console, much more rudimental and lacks modern functions such as saving records, autocloning, or safety checks.
/obj/machinery/computer/synth_pod
	name = "synth pod console"
	desc = "Used to operate a synth pod."
	icon_screen = "dna"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/computer/prototype_cloning
	var/obj/machinery/dna_scannernew/scanner = null //Linked scanner. For scanning.
	var/list/pods //Linked experimental cloning pods
	var/temp = "Inactive"
	var/scantemp = "Ready to Scan"
	var/loading = FALSE // Nice loading text

	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/synth_pod/Initialize()
	. = ..()
	updatemodules(TRUE)

/obj/machinery/computer/synth_pod/Destroy()
	if(pods)
		for(var/P in pods)
			DetachCloner(P)
		pods = null
	return ..()

/obj/machinery/computer/synth_pod/proc/GetAvailablePod(mind = null)
	if(pods)
		for(var/P in pods)
			var/obj/machinery/clonepod/synth/pod = P
			if(pod.is_operational() && !(pod.occupant || pod.mess))
				return pod

/obj/machinery/computer/synth_pod/proc/updatemodules(findfirstcloner)
	scanner = findscanner()
	if(findfirstcloner && !LAZYLEN(pods))
		findcloner()

/obj/machinery/computer/synth_pod/proc/findscanner()
	var/obj/machinery/dna_scannernew/scannerf = null

	// Loop through every direction
	for(var/direction in GLOB.cardinals)
		// Try to find a scanner in that direction
		scannerf = locate(/obj/machinery/dna_scannernew, get_step(src, direction))
		// If found and operational, return the scanner
		if (!isnull(scannerf) && scannerf.is_operational())
			return scannerf

	// If no scanner was found, it will return null
	return null

/obj/machinery/computer/synth_pod/proc/findcloner()
	var/obj/machinery/clonepod/synth/podf = null
	for(var/direction in GLOB.cardinals)
		podf = locate(/obj/machinery/clonepod/synth, get_step(src, direction))
		if (!isnull(podf) && podf.is_operational())
			AttachCloner(podf)

/obj/machinery/computer/synth_pod/proc/AttachCloner(obj/machinery/clonepod/experimental/pod)
	if(!pod.connected)
		pod.connected = src
		LAZYADD(pods, pod)

/obj/machinery/computer/synth_pod/proc/DetachCloner(obj/machinery/clonepod/experimental/pod)
	pod.connected = null
	LAZYREMOVE(pods, pod)

/obj/machinery/computer/synth_pod/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, W))
			return
		var/obj/item/multitool/P = W

		if(istype(P.buffer, /obj/machinery/clonepod/synth))
			if(get_area(P.buffer) != get_area(src))
				to_chat(user, "<font color = #666633>-% Cannot link machines across power zones. Buffer cleared %-</font color>")
				P.buffer = null
				return
			to_chat(user, "<font color = #666633>-% Successfully linked [P.buffer] with [src] %-</font color>")
			var/obj/machinery/clonepod/synth/pod = P.buffer
			if(pod.connected)
				pod.connected.DetachCloner(pod)
			AttachCloner(pod)
		else
			P.buffer = src
			to_chat(user, "<font color = #666633>-% Successfully stored [REF(P.buffer)] [P.buffer.name] in buffer %-</font color>")
		return
	else
		return ..()

/obj/machinery/computer/synth_pod/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/synth_pod/interact(mob/user)
	user.set_machine(src)
	add_fingerprint(user)

	if(..())
		return

	updatemodules(TRUE)

	var/dat = ""
	dat += "<a href='byond://?src=[REF(src)];refresh=1'>Refresh</a>"

	dat += "<h3>Synth Pod Status</h3>"
	dat += "<div class='statusDisplay'>[temp]&nbsp;</div>"

	if (isnull(src.scanner) || !LAZYLEN(pods))
		dat += "<h3>Modules</h3>"
		//dat += "<a href='byond://?src=[REF(src)];relmodules=1'>Reload Modules</a>"
		if (isnull(src.scanner))
			dat += "<font class='bad'>ERROR: No Scanner detected!</font><br>"
		if (!LAZYLEN(pods))
			dat += "<font class='bad'>ERROR: No Pod detected</font><br>"

	// Scan-n-Clone
	if (!isnull(src.scanner))
		var/mob/living/scanner_occupant = get_mob_or_brainmob(scanner.occupant)

		dat += "<h3>Assembly</h3>"

		dat += "<div class='statusDisplay'>"
		if(!scanner_occupant)
			dat += "Scanner Unoccupied"
		else if(loading)
			dat += "[scanner_occupant] => Scanning..."
		else
			scantemp = "Ready to Assemble"
			dat += "[scanner_occupant] => [scantemp]"
		dat += "</div>"

		if(scanner_occupant)
			dat += "<a href='byond://?src=[REF(src)];clone=1'>Assemble</a>"
			if(scanner.scan_level > 3)
				dat += "<a href='byond://?src=[REF(src)];clonetransfer=1'>Assemble and Transfer Mind</a>"
			dat += "<br><a href='byond://?src=[REF(src)];lock=1'>[src.scanner.locked ? "Unlock Scanner" : "Lock Scanner"]</a>"
		else
			dat += "<span class='linkOff'>Assemble</span>"
			if(scanner.scan_level > 3)
				dat += "<span class='linkOff'>Assemble and Transfer Mind</span>"

	var/datum/browser/popup = new(user, "cloning", "Synth Assembly System Control")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/synth_pod/Topic(href, href_list)
	if(..())
		return

	if(loading)
		return

	else if ((href_list["clone"]) && !isnull(scanner) && scanner.is_operational())
		scantemp = ""

		loading = TRUE
		updateUsrDialog()
		playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
		say("Initiating scan...")

		spawn(20)
			clone_occupant(scanner.occupant)
			loading = FALSE
			updateUsrDialog()
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

	else if ((href_list["clonetransfer"]) && !isnull(scanner) && scanner.is_operational())
		scantemp = ""

		loading = TRUE
		updateUsrDialog()
		playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
		say("Initiating advanced scan...")

		spawn(20)
			clone_occupant(scanner.occupant)
			loading = FALSE
			updateUsrDialog()
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

		//No locking an open scanner.
	else if ((href_list["lock"]) && !isnull(scanner) && scanner.is_operational())
		if ((!scanner.locked) && (scanner.occupant))
			scanner.locked = TRUE
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		else
			scanner.locked = FALSE
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

	else if (href_list["refresh"])
		updateUsrDialog()
		playsound(src, "terminal_type", 25, 0)

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/synth_pod/proc/clone_occupant(occupant)
	var/mob/living/mob_occupant = get_mob_or_brainmob(occupant)
	var/datum/dna/dna
	if(ishuman(mob_occupant))
		var/mob/living/carbon/C = mob_occupant
		dna = C.has_dna()
	if(isbrain(mob_occupant))
		var/mob/living/brain/B = mob_occupant
		dna = B.stored_dna

	if(!istype(dna))
		scantemp = "<font class='bad'>Unable to locate valid genetic data.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		return
	if(NO_DNA_COPY in dna.species.species_traits)
		scantemp = "<font class='bad'>The DNA of this lifeform could not be read due to an unknown error!</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		return
	if((HAS_TRAIT(mob_occupant, TRAIT_HUSK)) && (src.scanner.scan_level < 2))
		scantemp = "<font class='bad'>Subject's body is too damaged to scan properly.</font>"
		playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)
		return
	if(HAS_TRAIT(mob_occupant, TRAIT_BADDNA))
		scantemp = "<font class='bad'>Subject's DNA is damaged beyond any hope of recovery.</font>"
		playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)
		return

	var/clone_species
	if(dna.species)
		clone_species = dna.species
	else
		var/datum/species/rando_race = pick(GLOB.roundstart_races)
		clone_species = rando_race.type

	var/obj/machinery/clonepod/pod = GetAvailablePod()
	//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
	if(!LAZYLEN(pods))
		temp = "<font class='bad'>No Synthpods detected.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
	else if(!pod)
		temp = "<font class='bad'>No Synthpods available.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
	else if(pod.occupant)
		temp = "<font class='bad'>Assembly cycle already in progress.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
	else
		pod.growclone(mob_occupant.real_name, dna.uni_identity, dna.mutation_index, null, null, clone_species, dna.features, mob_occupant.faction)
		temp = "[mob_occupant.real_name] => <font class='good'>Assembly data sent to pod.</font>"
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

#undef CLONE_INITIAL_DAMAGE
#undef MINIMUM_HEAL_LEVEL