	//Baseline hardsuits
/obj/item/clothing/head/helmet/space/hardsuit
	name = "hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	item_state = "eng_helm"
	max_integrity = 300
	armor = list("melee" = 10, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 50, "acid" = 75)
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 1
	light_on = FALSE
	var/basestate = "hardsuit"
	var/on = FALSE
	var/obj/item/clothing/suit/space/hardsuit/suit
	item_color = "engineering" //Determines used sprites: hardsuit[on]-[color] and hardsuit[on]-[color]2 (lying down sprite)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH	| PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	var/rad_count = 0
	var/rad_record = 0
	var/grace_count = 0
	var/datum/looping_sound/geiger/soundloop

/obj/item/clothing/head/helmet/space/hardsuit/Initialize()
	. = ..()
	soundloop = new(list(), FALSE, TRUE)
	soundloop.volume = 5
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/space/hardsuit/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/space/hardsuit/attack_self(mob/user)
	on = !on
	icon_state = "[basestate][on]-[item_color]"
	user.update_inv_head()	//so our mob-overlays update

	set_light_on(on)

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/head/helmet/space/hardsuit/dropped(mob/user)
	..()
	if(suit)
		suit.RemoveHelmet()
		soundloop.stop(user)

/obj/item/clothing/head/helmet/space/hardsuit/item_action_slot_check(slot)
	if(slot == SLOT_HEAD)
		return 1

/obj/item/clothing/head/helmet/space/hardsuit/equipped(mob/user, slot)
	..()
	if(slot != SLOT_HEAD)
		if(suit)
			suit.RemoveHelmet()
			soundloop.stop(user)
		else
			qdel(src)
	else
		soundloop.start(user)

/obj/item/clothing/head/helmet/space/hardsuit/proc/display_visor_message(var/msg)
	var/mob/wearer = loc
	if(msg && ishuman(wearer))
		wearer.show_message("[icon2html(src, wearer)]<b><span class='robot'>[msg]</span></b>", 1)

/obj/item/clothing/head/helmet/space/hardsuit/rad_act(severity)
	. = ..()
	rad_count += severity

/obj/item/clothing/head/helmet/space/hardsuit/process()
	if(!rad_count)
		grace_count++
		if(grace_count == 2)
			soundloop.last_radiation = 0
		return

	grace_count = 0
	rad_record -= rad_record/5
	rad_record += rad_count/5
	rad_count = 0

	soundloop.last_radiation = rad_record

/obj/item/clothing/head/helmet/space/hardsuit/emp_act(severity)
	. = ..()
	display_visor_message("[severity > 1 ? "Light" : "Strong"] electromagnetic pulse detected!")

/obj/item/clothing/suit/space/hardsuit
	name = "hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	item_state = "eng_hardsuit"
	max_integrity = 300
	armor = list("melee" = 10, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 50, "acid" = 75)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser)
	siemens_coefficient = 0
	var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	actions_types = list(/datum/action/item_action/toggle_helmet)
	var/helmettype = /obj/item/clothing/head/helmet/space/hardsuit
	var/obj/item/tank/jetpack/suit/jetpack = null
	pocket_storage_component_path = null


/obj/item/clothing/suit/space/hardsuit/Initialize()
	if(jetpack && ispath(jetpack))
		jetpack = new jetpack(src)
	. = ..()

/obj/item/clothing/suit/space/hardsuit/attack_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/item/clothing/suit/space/hardsuit/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/tank/jetpack/suit))
		if(jetpack)
			to_chat(user, "<span class='warning'>[src] already has a jetpack installed.</span>")
			return
		if(src == user.get_item_by_slot(SLOT_WEAR_SUIT)) //Make sure the player is not wearing the suit before applying the upgrade.
			to_chat(user, "<span class='warning'>You cannot install the upgrade to [src] while wearing it.</span>")
			return

		if(user.transferItemToLoc(I, src))
			jetpack = I
			to_chat(user, "<span class='notice'>You successfully install the jetpack into [src].</span>")
			return
	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(!jetpack)
			to_chat(user, "<span class='warning'>[src] has no jetpack installed.</span>")
			return
		if(src == user.get_item_by_slot(SLOT_WEAR_SUIT))
			to_chat(user, "<span class='warning'>You cannot remove the jetpack from [src] while wearing it.</span>")
			return

		jetpack.turn_off(user)
		jetpack.forceMove(drop_location())
		jetpack = null
		to_chat(user, "<span class='notice'>You successfully remove the jetpack from [src].</span>")
		return
	return ..()


/obj/item/clothing/suit/space/hardsuit/equipped(mob/user, slot)
	..()
	if(jetpack)
		if(slot == SLOT_WEAR_SUIT)
			for(var/X in jetpack.actions)
				var/datum/action/A = X
				A.Grant(user)

/obj/item/clothing/suit/space/hardsuit/dropped(mob/user)
	..()
	if(jetpack)
		for(var/X in jetpack.actions)
			var/datum/action/A = X
			A.Remove(user)

/obj/item/clothing/suit/space/hardsuit/item_action_slot_check(slot)
	if(slot == SLOT_WEAR_SUIT) //we only give the mob the ability to toggle the helmet if he's wearing the hardsuit.
		return 1

	//Engineering
/obj/item/clothing/head/helmet/space/hardsuit/engine
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	item_state = "eng_helm"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 12, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 100, "acid" = 75)
	item_color = "engineering"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/engine
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	item_state = "eng_hardsuit"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 100, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine
	resistance_flags = FIRE_PROOF
	slowdown = 0.6

	//Atmospherics
/obj/item/clothing/head/helmet/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has thermal shielding."
	icon_state = "hardsuit0-atmospherics"
	item_state = "atmo_helm"
	item_color = "atmospherics"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has thermal shielding."
	icon_state = "hardsuit-atmospherics"
	item_state = "atmo_hardsuit"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 25, "fire" = 100, "acid" = 75)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/atmos
	slowdown = 1

	//Chief Engineer's hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "hardsuit0-white"
	item_state = "ce_helm"
	item_color = "white"
	armor = list("melee" = 40, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 90)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/elite
	icon_state = "hardsuit-white"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	item_state = "ce_hardsuit"
	armor = list("melee" = 40, "bullet" = 5, "laser" = 10, "energy" = 20, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 90)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	jetpack = /obj/item/tank/jetpack/suit
	slowdown = 0.8

	//Mining hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating for wildlife encounters and dual floodlights."
	icon_state = "hardsuit0-mining"
	item_state = "mining_helm"
	item_color = "mining"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	heat_protection = HEAD
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75)
	light_range = 7
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator)

/obj/item/clothing/head/helmet/space/hardsuit/mining/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/suit/space/hardsuit/mining
	icon_state = "hardsuit-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating for wildlife encounters."
	item_state = "mining_hardsuit"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 20, "bomb" = 50, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 75)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/storage/bag/ore, /obj/item/pickaxe)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/space/hardsuit/mining/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

	//Syndicate hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi
	name = "blood-red hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced helmet designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_helm"
	item_color = "syndi"
	armor = list("melee" = 40, "bullet" = 50, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 90)
	on = TRUE
	var/obj/item/clothing/suit/space/hardsuit/syndi/linkedsuit = null
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	visor_flags = STOPSPRESSUREDAMAGE

/obj/item/clothing/head/helmet/space/hardsuit/syndi/update_icon()
	icon_state = "hardsuit[on]-[item_color]"

/obj/item/clothing/head/helmet/space/hardsuit/syndi/Initialize()
	. = ..()
	if(istype(loc, /obj/item/clothing/suit/space/hardsuit/syndi))
		linkedsuit = loc

/obj/item/clothing/head/helmet/space/hardsuit/syndi/attack_self(mob/user) //Toggle Helmet
	if(!isturf(user.loc))
		to_chat(user, "<span class='warning'>You cannot toggle your helmet while in this [user.loc]!</span>" )
		return
	on = !on
	if(on || force)
		to_chat(user, "<span class='notice'>You switch your hardsuit to EVA mode, sacrificing speed for space protection.</span>")
		name = initial(name)
		desc = initial(desc)
		set_light_on(TRUE)
		clothing_flags |= visor_flags
		flags_cover |= HEADCOVERSEYES | HEADCOVERSMOUTH
		flags_inv |= visor_flags_inv
		cold_protection |= HEAD
	else
		to_chat(user, "<span class='notice'>You switch your hardsuit to combat mode and can now run at full speed.</span>")
		name += " (combat)"
		desc = alt_desc
		set_light_on(FALSE)
		clothing_flags &= ~visor_flags
		flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
		flags_inv &= ~visor_flags_inv
		cold_protection &= ~HEAD
	update_icon()
	playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	toggle_hardsuit_mode(user)
	user.update_inv_head()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/toggle_hardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		if(on)
			linkedsuit.name = initial(linkedsuit.name)
			linkedsuit.desc = initial(linkedsuit.desc)
			linkedsuit.slowdown = 1
			linkedsuit.clothing_flags |= STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		else
			linkedsuit.name += " (combat)"
			linkedsuit.desc = linkedsuit.alt_desc
			linkedsuit.slowdown = 0
			linkedsuit.clothing_flags &= ~STOPSPRESSUREDAMAGE
			linkedsuit.cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)

		linkedsuit.icon_state = "hardsuit[on]-[item_color]"
		linkedsuit.update_icon()
		user.update_inv_wear_suit()
		user.update_inv_w_uniform()
		user.update_equipment_speed_mods()


/obj/item/clothing/suit/space/hardsuit/syndi
	name = "blood-red hardsuit"
	desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_hardsuit"
	item_color = "syndi"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list("melee" = 40, "bullet" = 50, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 50, "acid" = 90)
	allowed = list(/obj/item/gun, /obj/item/ammo_box,/obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	jetpack = /obj/item/tank/jetpack/suit

//Elite Syndie suit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	name = "elite syndicate hardsuit helmet"
	desc = "An military grade hardware which appears to be modified, with improved armour and fireproofing. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "An military grade hardware which appears to be modified, with improved armour and fireproofing. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit0-syndielite"
	item_color = "syndielite"
	armor = list("melee" = 60, "bullet" = 60, "laser" = 50, "energy" = 60, "bomb" = 55, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/space/hardsuit/syndi/elite
	name = "elite syndicate hardsuit"
	desc = "An military grade hardware which appears to be modified, with improved armour and fireproofing. It is in travel mode."
	alt_desc = "An military grade hardware which appears to be modified, with improved armour and fireproofing. It is in combat mode."
	icon_state = "hardsuit0-syndielite"
	item_color = "syndielite"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/elite
	armor = list("melee" = 60, "bullet" = 60, "laser" = 50, "energy" = 60, "bomb" = 55, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	blocks_shove_knockdown = TRUE
	slowdown = 0.5

//The Owl Hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi/owl
	name = "owl hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for any crime-fighting situation. It is in travel mode."
	alt_desc = "A dual-mode advanced helmet designed for any crime-fighting situation. It is in combat mode."
	icon_state = "hardsuit1-owl"
	item_state = "s_helmet"
	item_color = "owl"
	visor_flags_inv = 0
	visor_flags = 0
	on = FALSE

/obj/item/clothing/suit/space/hardsuit/syndi/owl
	name = "owl hardsuit"
	desc = "A dual-mode advanced hardsuit designed for any crime-fighting situation. It is in travel mode."
	alt_desc = "A dual-mode advanced hardsuit designed for any crime-fighting situation. It is in combat mode."
	icon_state = "hardsuit1-owl"
	item_state = "s_suit"
	item_color = "owl"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi/owl


	//Wizard hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/wizard
	name = "gem-encrusted hardsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "hardsuit0-wiz"
	item_state = "wiz_helm"
	item_color = "wiz"
	resistance_flags = FIRE_PROOF | ACID_PROOF //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list("melee" = 40, "bullet" = 40, "laser" = 40, "energy" = 50, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/wizard
	icon_state = "hardsuit-wiz"
	name = "gem-encrusted hardsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state = "wiz_hardsuit"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 40, "bullet" = 40, "laser" = 40, "energy" = 50, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	allowed = list(/obj/item/teleportation_scroll, /obj/item/tank/internals)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/wizard
	jetpack = /obj/item/tank/jetpack/suit
	slowdown = 0.3

/obj/item/clothing/suit/space/hardsuit/wizard/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, INFINITY, FALSE)


	//Medical hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/medical
	name = "medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort, but does not protect the eyes from intense light."
	icon_state = "hardsuit0-medical"
	item_state = "medical_helm"
	item_color = "medical"
	flash_protect = 0
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	scan_reagents = TRUE

/obj/item/clothing/suit/space/hardsuit/medical
	icon_state = "hardsuit-medical"
	name = "medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement."
	item_state = "medical_hardsuit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/storage/firstaid, /obj/item/healthanalyzer, /obj/item/stack/medical)
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical
	slowdown = 0.4

/obj/item/clothing/head/helmet/space/hardsuit/medical/cmo
	name = "chief medical officer's hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort and protects the eyes from intense light."
	flash_protect = 2

/obj/item/clothing/suit/space/hardsuit/medical/cmo
	name = "chief medical officer's hardsuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical/cmo

	//HEV suit
/obj/item/clothing/head/helmet/space/hardsuit/hev
	name = "HEV suit helmet"
	desc = "A Hazardous Environment Helmet. It fits snug over the suit and has a heads-up display for researchers."
	icon_state = "hardsuit0-hev"
	item_state = "hev_helm"
	item_color = "hev"
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list("melee" = 30, "bullet" = 10, "laser" = 10, "energy" = 15, "bomb" = 100, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 80)
	var/obj/machinery/doppler_array/integrated/bomb_radar
	scan_reagents = TRUE
	actions_types = list(/datum/action/item_action/toggle_research_scanner, /datum/action/item_action/toggle_helmet_light)

/obj/item/clothing/head/helmet/space/hardsuit/hev/Initialize()
	. = ..()
	bomb_radar = new /obj/machinery/doppler_array/integrated(src)

/obj/item/clothing/head/helmet/space/hardsuit/hev/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/hev/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_DIAGNOSTIC_BASIC]
		DHUD.remove_hud_from(user)

/obj/item/clothing/suit/space/hardsuit/hev
	name = "HEV Suit"
	desc = "A Hazardous Environment suit, often called the Hazard suit. It was designed to protect scientists from the blunt trauma, radiation, energy discharge that hazardous materials might produce or entail. Fits you like a glove. The automatic medical system seems broken."
	item_state = "hardsuit-hev"
	icon_state = "hardsuit-hev"
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT //Same as an emergency firesuit. Not ideal for extended exposure.
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/gun/energy/wormhole_projector,
	/obj/item/hand_tele, /obj/item/aicard)
	armor = list("melee" = 30, "bullet" = 10, "laser" = 10, "energy" = 15, "bomb" = 100, "bio" = 100, "rad" = 60, "fire" = 60, "acid" = 100)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/hev
	slowdown = 0.7
	var/morphine_cooldown = 0
	var/morphine_cooldown_duration = 500

/obj/item/clothing/suit/space/hardsuit/hev/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == SLOT_WEAR_SUIT)
		say("Welcome to the H.E.V. mark IV protective system, for use in hazardous environment conditions.")
		playsound(src, 'sound/items/hev/hev_logon.ogg', 50, 0)
	return

/obj/item/clothing/suit/space/hardsuit/hev/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(world.time > morphine_cooldown)
		if(owner.health < 20)
			owner.reagents.add_reagent(/datum/reagent/medicine/epinephrine, 10)
			to_chat(owner, "<span class='warning'>You feel a tiny prick!</span>")
			say("Adrenaline administered.")
			playsound(src, 'sound/items/hev/hev_morphine.ogg', 50, 0)
			morphine_cooldown = world.time + morphine_cooldown_duration
	. = ..()

	//Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-sec"
	item_state = "sec_helm"
	item_color = "sec"
	armor = list("melee" = 40, "bullet" = 35, "laser" = 35,"energy" = 60, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 75, "acid" = 75)


/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-sec"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	item_state = "sec_hardsuit"
	armor = list("melee" = 40, "bullet" = 35, "laser" = 35, "energy" = 60, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 75, "acid" = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security

/obj/item/clothing/suit/space/hardsuit/security/Initialize()
	. = ..()
	allowed = GLOB.security_hardsuit_allowed

	//Head of Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security/hos
	name = "head of security's hardsuit helmet"
	desc = "A special bulky helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-hos"
	item_color = "hos"
	armor = list("melee" = 45, "bullet" = 40, "laser" = 35, "energy" = 60, "bomb" = 25, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 95)


/obj/item/clothing/suit/space/hardsuit/security/hos
	icon_state = "hardsuit-hos"
	name = "head of security's hardsuit"
	desc = "A special bulky suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list("melee" = 45, "bullet" = 40, "laser" = 35, "energy" = 60, "bomb" = 25, "bio" = 100, "rad" = 50, "fire" = 95, "acid" = 95)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos
	jetpack = /obj/item/tank/jetpack/suit

	//SWAT MKII
/obj/item/clothing/head/helmet/space/hardsuit/swat
	name = "MK.II SWAT Helmet"
	icon_state = "hardsuit0-swat2helm"
	item_state = "hardsuit0-swat2helm"
	item_color = "swat2helm"
	desc = "A tactical SWAT helmet MK.II."
	armor = list("melee" = 50, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 60, "bio" = 100, "rad" = 30, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	actions_types = list(/datum/action/item_action/toggle_helmet_light)

/obj/item/clothing/suit/space/hardsuit/swat
	name = "MK.II SWAT Suit"
	desc = "A MK.II SWAT RIG suit with streamlined joints and armor made out of superior materials, insulated against intense heat. The most advanced tactical armor available."
	icon_state = "swat2"
	item_state = "swat2"
	armor = list("melee" = 50, "bullet" = 60, "laser" = 60, "energy" = 60, "bomb" = 60, "bio" = 100, "rad" = 30, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT //this needed to be added a long fucking time ago
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/swat
	blocks_shove_knockdown = TRUE
	slowdown = 0.5

/obj/item/clothing/suit/space/hardsuit/swat/Initialize()
	. = ..()
	allowed = GLOB.security_hardsuit_allowed

	//Captain
/obj/item/clothing/head/helmet/space/hardsuit/swat/captain
	name = "Captain's hardsuit helmet"
	icon_state = "hardsuit0-capspace"
	item_state = "hardsuit0-capspace"
	item_color = "capspace"
	desc = "An custom tactical helmet boasting better protection, there is a lot of data on the visor."
	var/obj/machinery/doppler_array/integrated/bomb_radar
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 50, "bomb" = 50, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)


/obj/item/clothing/head/helmet/space/hardsuit/swat/captain/Initialize()
	. = ..()
	bomb_radar = new /obj/machinery/doppler_array/integrated(src)

/obj/item/clothing/head/helmet/space/hardsuit/swat/captain/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/swat/captain/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
		DHUD.remove_hud_from(user)

/obj/item/clothing/suit/space/hardsuit/swat/captain
	name = "Captain's commando RIG suit"
	desc = "Spaceproofed plate armor suit with streamlined joints, made out of expensive materials, sacraficing combat effectivness for fashion, insulated against intense heat. The most advanced tactical armor available. Usually reserved for heavy hitter corporate security, this one has a regal finish in Nanotrasen company colors. Better not let the assistants get a hold of it."
	icon_state = "caparmor"
	item_state = "capspacesuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/swat/captain
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 50, "bomb" = 50, "bio" = 100, "rad" = 70, "fire" = 100, "acid" = 100)
	slowdown = 1

	//Clown
/obj/item/clothing/head/helmet/space/hardsuit/clown
	name = "cosmohonk hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-humor environment. Has radiation shielding."
	icon_state = "hardsuit0-clown"
	item_state = "hardsuit0-clown"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 20, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 60, "acid" = 30)
	item_color = "clown"

/obj/item/clothing/suit/space/hardsuit/clown
	name = "cosmohonk hardsuit"
	desc = "A special suit that protects against hazardous, low humor environments. Has radiation shielding. Only a true clown can wear it."
	icon_state = "hardsuit-clown"
	item_state = "clown_hardsuit"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 10, "energy" = 20, "bomb" = 10, "bio" = 100, "rad" = 75, "fire" = 60, "acid" = 30)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/clown

/obj/item/clothing/suit/space/hardsuit/clown/mob_can_equip(mob/M, slot)
	if(!..() || !ishuman(M))
		return FALSE
	var/mob/living/carbon/human/H = M
	if(H.mind.assigned_role == "Clown")
		return TRUE
	else
		return FALSE

	//Old Prototype
/obj/item/clothing/head/helmet/space/hardsuit/ancient
	name = "prototype RIG hardsuit helmet"
	desc = "Early prototype RIG hardsuit helmet, designed to quickly shift over a user's head. Design constraints of the helmet mean it has no inbuilt cameras, thus it restricts the users visability."
	icon_state = "hardsuit0-ancient"
	item_state = "anc_helm"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 5, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 75)
	item_color = "ancient"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/ancient
	name = "prototype RIG hardsuit"
	desc = "Prototype powered RIG hardsuit. Provides excellent protection from the elements of space while being comfortable to move around in, thanks to the powered locomotives. Remains very bulky however."
	icon_state = "hardsuit-ancient"
	item_state = "anc_hardsuit"
	armor = list("melee" = 30, "bullet" = 5, "laser" = 5, "energy" = 10, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 75)
	slowdown = 3
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ancient
	resistance_flags = FIRE_PROOF
	var/footstep = 1
	var/mob/listeningTo

/obj/item/clothing/suit/space/hardsuit/ancient/proc/on_mob_move()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 1)
		playsound(src, 'sound/effects/servostep.ogg', 100, 1)
		footstep = 0
	else
		footstep++

/obj/item/clothing/suit/space/hardsuit/ancient/equipped(mob/user, slot)
	. = ..()
	if(slot != SLOT_WEAR_SUIT)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/on_mob_move)
	listeningTo = user

/obj/item/clothing/suit/space/hardsuit/ancient/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/space/hardsuit/ancient/Destroy()
	listeningTo = null
	return ..()

/////////////SHIELDED//////////////////////////////////

/obj/item/clothing/suit/space/hardsuit/shielded
	name = "shielded hardsuit"
	desc = "A hardsuit with built in energy shielding. Will rapidly recharge when not under fire."
	icon_state = "hardsuit-hos"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos
	allowed = null
	armor = list("melee" = 30, "bullet" = 15, "laser" = 30, "energy" = 40, "bomb" = 10, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

//Shield vars
	//How much damage shield can take
	var/capacity = 100
	var/max_capacity = 100
	//How quickly shield will recharge capacity
	var/recharge_rate = 5
	//How long after we've been shot before we can start recharging. 10 seconds here
	var/recharge_delay = 100
	//Time since we've last been shot
	var/recharge_cooldown = 0
	//Shield visual states
	var/shield_state = "shieldblue"
	var/shield_on = "shieldblue"
	var/shield_damaged = "shieldblue-damaged"
	var/shield_critical = "shieldblue-critical"
	var/shield_down = "shield-recharging"

/obj/item/clothing/suit/space/hardsuit/shielded/Initialize()
	. = ..()
	if(!allowed)
		allowed = GLOB.advanced_hardsuit_allowed

/////////////////////////////////////////////////////////////////
////SHIELD CODE//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//EMP hit - shield is gone
/obj/item/clothing/suit/space/hardsuit/shielded/emp_act(severity)
	recharge_cooldown = world.time + recharge_delay
	capacity = 0
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/owner = loc
	START_PROCESSING(SSobj, src)
	do_sparks(3, FALSE, src)
	T.visible_message("[owner]'s energy shield falters!")
	playsound(loc, 'sound/effects/shieldbeep.ogg', 75, 0)
	update_icon()
	owner.update_inv_wear_suit()
	..()

//handles being hit, for some reason code wants to deal bonus 3 points of damage to the shield regardless of what hits it, I give up on trying to fix it and accept it as a feature
/obj/item/clothing/suit/space/hardsuit/shielded/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance = 0, damage, attack_type)
	//you've been hit by, you've been struck by, wait
	recharge_cooldown = world.time + recharge_delay
	if(capacity)
		playsound(loc, 'sound/effects/shieldhit.ogg', 100, 1)
		var/attackforce = 0

		//projectile attacks
		if(isprojectile(hitby))
			var/obj/item/projectile/P = hitby

			//disablers don't damage shields
			if(P.damage_type == STAMINA)
				attackforce = 0

			//kinetic attacks are pretty effective at defeating shields
			if(P.damage_type == BRUTE)
				attackforce = (P.damage * 1.3)

			//most energy weapons deal burn damage
			if(P.damage_type == BURN)
				attackforce = (P.damage)

			//piercing rounds won't damage the shield but will pierce it
			if(P.movement_type & UNSTOPPABLE)
				owner.visible_message("<span class='danger'>[P] pierces through the [owner]'s shield!</span>")
				do_sparks(3, FALSE, src)
				update_icon()
				return 0
			capacity -= attackforce

		//Melee
		if(isitem(hitby))
			var/obj/item/I = hitby
			attackforce = (damage * I.attack_weight)

			//non-brute melee attacks aren't gonna be effective
			if(!I.damtype == BRUTE)
				attackforce = (damage * 0.5)

			//pure stamina damage will be completely blocked
			if(I.damtype == STAMINA)
				attackforce = 0
			capacity -= attackforce

		//simplemob/unarmed attacks
		else if(isliving(hitby))
			attackforce = damage
			capacity -= attackforce

		do_sparks(3, FALSE, src)

		//If damage taken exceeds shield capacity, user is hit by the full force
		if(capacity <= attackforce)
			var/turf/T = get_turf(owner)
			T.visible_message("[owner]'s shield overloads!")
			playsound(loc, 'sound/effects/shieldbeep.ogg', 75, 0)
			capacity = 0
			START_PROCESSING(SSobj, src)
			update_icon()
			owner.update_inv_wear_suit()
			return 0
		else
			owner.visible_message("<span class='danger'>[owner]'s shields deflect [attack_text] in a shower of sparks!</span>")
			update_icon()
		//start recharging shield
		if(recharge_rate && capacity < max_capacity)
			START_PROCESSING(SSobj, src)
		update_icon()
		owner.update_inv_wear_suit()
		return 1
	else
		return 0

//handles shield recharging
/obj/item/clothing/suit/space/hardsuit/shielded/process()
	//check if cooldown is gone, if so, start recharging
	if(world.time > recharge_cooldown)
		playsound(loc, 'sound/effects/shieldraised.ogg', 75, 0)

		//if shield just started recharging boost it up so player is actually rewarded for getting out of hot situation after complete depletion
		if(capacity == 0)
			capacity += 20
		//if not, recharge as usual
		else
			capacity = CLAMP((capacity + recharge_rate), 0, max_capacity)
		update_icon()

		//stop recharging when full
		if(capacity == max_capacity)
			update_icon()
			playsound(loc, 'sound/effects/shieldbeep2.ogg', 100, 1)
			STOP_PROCESSING(SSobj, src)
		if(ishuman(loc))
			var/mob/living/carbon/human/owner = loc
			owner.update_inv_wear_suit()

/obj/item/clothing/suit/space/hardsuit/shielded/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//what icons should be updated to
/obj/item/clothing/suit/space/hardsuit/shielded/update_icon()
	if(capacity == 0)
		shield_state = "[shield_down]"
		return
	else
		var/capacitypercent = round((capacity/max_capacity) * 100, 1)
		switch(capacitypercent)
			if(80 to 100)
				shield_state = "[shield_on]"
			if(30 to 80)
				shield_state = "[shield_damaged]"
			if(0 to 30)
				shield_state = "[shield_critical]"

//actually update the icons
/obj/item/clothing/suit/space/hardsuit/shielded/worn_overlays(isinhands)
	. = list()
	if(!isinhands)
		. += mutable_appearance('icons/effects/effects.dmi', shield_state, MOB_LAYER + 0.01)

/obj/item/clothing/suit/space/hardsuit/shielded/examine(mob/user)
	var/capacitypercent = round((capacity/max_capacity) * 100, 1)
	. += "<span class='info'>Display shows [src] is at [capacitypercent] shield capacity.</span>"

/////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing/head/helmet/space/hardsuit/shielded
	resistance_flags = FIRE_PROOF | ACID_PROOF

///////////////Capture the Flag////////////////////

/obj/item/clothing/suit/space/hardsuit/shielded/ctf
	name = "white shielded hardsuit"
	desc = "Standard issue hardsuit for playing capture the flag."
	icon_state = "ert_medical"
	item_state = "ert_medical"
	item_color = "ert_medical"
	// Adding TRAIT_NODROP is done when the CTF spawner equips people
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf
	armor = list("melee" = 0, "bullet" = 30, "laser" = 30, "energy" = 30, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 95, "acid" = 95)
	slowdown = 0

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/red
	name = "red shielded hardsuit"
	icon_state = "ert_security"
	item_state = "ert_security"
	item_color = "ert_security"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red
	shield_state = "shield-red"
	shield_on = "shield-red"

/obj/item/clothing/suit/space/hardsuit/shielded/ctf/blue
	name = "blue shielded hardsuit"
	desc = "Standard issue hardsuit for playing capture the flag."
	icon_state = "ert_command"
	item_state = "ert_command"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/blue



/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf
	name = "shielded hardsuit helmet"
	desc = "Standard issue hardsuit helmet for playing capture the flag."
	icon_state = "hardsuit0-ert_medical"
	item_state = "hardsuit0-ert_medical"
	item_color = "ert_medical"
	armor = list("melee" = 0, "bullet" = 30, "laser" = 30, "energy" = 40, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 95, "acid" = 95)


/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/red
	icon_state = "hardsuit0-ert_security"
	item_state = "hardsuit0-ert_security"
	item_color = "ert_security"

/obj/item/clothing/head/helmet/space/hardsuit/shielded/ctf/blue
	name = "shielded hardsuit helmet"
	desc = "Standard issue hardsuit helmet for playing capture the flag."
	icon_state = "hardsuit0-ert_commander"
	item_state = "hardsuit0-ert_commander"
	item_color = "ert_commander"





//////Syndicate Version

/obj/item/clothing/suit/space/hardsuit/shielded/syndi
	name = "blood-red hardsuit"
	desc = "An advanced hardsuit with built in energy shielding."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_hardsuit"
	item_color = "syndi"
	armor = list("melee" = 40, "bullet" = 50, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/syndi
	slowdown = 0
	shield_state = "shieldred"
	shield_on = "shieldred"
	shield_damaged = "shieldred-damaged"
	shield_critical = "shieldred-critical"
	shield_down = "shield-recharging"
/*
/obj/item/clothing/suit/space/hardsuit/shielded/syndi/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(shield_state == "broken")
		to_chat(user, "<span class='warning'>You can't interface with the hardsuit's software if the shield's broken!</span>")
		return

	if(shield_state == "shield-red")
		shield_state = "shield-old"
		shield_on = "shield-old"
		to_chat(user, "<span class='warning'>You roll back the hardsuit's software, changing the shield's color!</span>")

	else
		shield_state = "shield-red"
		shield_on = "shield-red"
		to_chat(user, "<span class='warning'>You update the hardsuit's hardware, changing back the shield's color to red.</span>")
	user.update_inv_wear_suit()
*/
/obj/item/clothing/suit/space/hardsuit/shielded/syndi/Initialize()
	jetpack = new /obj/item/tank/jetpack/suit(src)
	. = ..()

/obj/item/clothing/head/helmet/space/hardsuit/shielded/syndi
	name = "blood-red hardsuit helmet"
	desc = "An advanced hardsuit helmet with built in energy shielding."
	icon_state = "hardsuit1-syndi"
	item_state = "syndie_helm"
	item_color = "syndi"
	armor = list("melee" = 40, "bullet" = 50, "laser" = 30, "energy" = 40, "bomb" = 35, "bio" = 100, "rad" = 50, "fire" = 100, "acid" = 100)

///SWAT version
/obj/item/clothing/suit/space/hardsuit/shielded/swat
	name = "death commando spacesuit"
	desc = "An advanced hardsuit favored by commandos for use in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	item_color = "syndi"
	recharge_delay = 15
	armor = list("melee" = 80, "bullet" = 80, "laser" = 50, "energy" =60, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	jetpack = /obj/item/tank/jetpack/suit
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/swat
	dog_fashion = /datum/dog_fashion/back/deathsquad
	blocks_shove_knockdown = TRUE

/obj/item/clothing/head/helmet/space/hardsuit/shielded/swat
	name = "death commando helmet"
	desc = "A tactical helmet with built in energy shielding."
	icon_state = "deathsquad"
	item_state = "deathsquad"
	item_color = "syndi"
	armor = list("melee" = 80, "bullet" = 80, "laser" = 50, "energy" = 60, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()

/obj/item/clothing/suit/space/hardsuit/shielded/swat/honk
	name = "honk squad spacesuit"
	desc = "A hilarious hardsuit favored by HONK squad troopers for use in special pranks."
	icon_state = "hardsuit-clown"
	item_state = "clown_hardsuit"
	item_color = "clown"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/swat/honk

/obj/item/clothing/head/helmet/space/hardsuit/shielded/swat/honk
	name = "honk squad helmet"
	desc = "A hilarious helmet with built in anti-mime propaganda shielding."
	icon_state = "hardsuit0-clown"
	item_state = "hardsuit0-clown"
	item_color = "clown"


// Doomguy ERT version
/obj/item/clothing/suit/space/hardsuit/shielded/doomguy
	name = "juggernaut armor"
	desc = "A somehow spaceworthy set of armor with outstanding protection against almost everything. Comes in an oddly nostalgic green. "
	icon_state = "doomguy"
	item_state = "doomguy"
	recharge_delay = 100
	armor = list("melee" = 135, "bullet" = 135, "laser" = 135, "energy" = 135, "bomb" = 135, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/shielded/doomguy
	dog_fashion = /datum/dog_fashion/back/deathsquad
	blocks_shove_knockdown = TRUE

/obj/item/clothing/head/helmet/space/hardsuit/shielded/doomguy
	name = "juggernaut helmet"
	desc = "A dusty old helmet, somehow capable of resisting the strongest of blows."
	icon_state = "doomguy"
	item_state = "doomguy"
	armor = list("melee" = 135, "bullet" = 135, "laser" = 135, "energy" = 135, "bomb" = 135, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	strip_delay = 130
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	actions_types = list()
