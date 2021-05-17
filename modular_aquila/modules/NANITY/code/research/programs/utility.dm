/datum/nanite_program/nutrition_synthesis
	name = "Nutrition Synthesis"
	desc = "The nanites use themself to synthesise nutriments into host's bloodstream, gradually decaying to feed the host."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/nutrition_synthesis/check_conditions()
	if(!iscarbon(host_mob))
		return FALSE
	var/mob/living/carbon/C = host_mob
	if(C.nutrition >= NUTRITION_LEVEL_WELL_FED)
		return FALSE
	return ..()

/datum/nanite_program/nutrition_synthesis/active_effect()
	host_mob.adjust_nutrition(0.5)

/datum/nanite_program/cloud_change
	name = "Cloud Change"
	desc = "When triggered, changes the nanites' cloud of reference."
	unique = FALSE
	can_trigger = TRUE
	trigger_cost = 150
	trigger_cooldown = 600
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/cloud_change/register_extra_settings()
	extra_settings[NES_CLOUD_OVERWRITE] = new /datum/nanite_extra_setting/number(0, 0, 100)

/datum/nanite_program/cloud_change/on_trigger(comm_message)
	var/datum/nanite_extra_setting/cloud = extra_settings[NES_CLOUD_OVERWRITE]
	SEND_SIGNAL(host_mob, COMSIG_NANITE_SET_CLOUD, cloud.get_value())

/datum/nanite_program/nanolink
	name = "Nanolink"
	desc = "The nanites gain the ability to transfer messages between other nano clusters connected to the Nanolink, using the \".z\" key."
	use_rate = 0.2
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/nanolink/register_extra_settings()
	. = ..()
	extra_settings[NES_NANO_RECEIVE] = new /datum/nanite_extra_setting/boolean(TRUE, "True", "False")
	extra_settings[NES_NANO_SEND] = new /datum/nanite_extra_setting/boolean(TRUE, "True", "False")

/datum/nanite_program/nanolink/enable_passive_effect()
	. = ..()
	var/datum/nanite_extra_setting/nano_receive = extra_settings[NES_NANO_RECEIVE]
	var/datum/nanite_extra_setting/nano_send = extra_settings[NES_NANO_SEND]
	if(nano_receive.get_value())
		to_chat(host_mob, "<span class='swarmer'><b>\[NANOLINK\]</b> Connecting to the Nanolink...</span>")
		ADD_TRAIT(host_mob, TRAIT_NANORECEIVE, "nanites")
		if(nano_send.get_value())
			to_chat(host_mob, "<span class='swarmer'><b>\[NANOLINK\]</b> Use the \".z\" key to send messages over the Nanolink.</span>")
	if(nano_send.get_value())
		ADD_TRAIT(host_mob, TRAIT_NANOSEND, "nanites")

/datum/nanite_program/nanolink/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_NANORECEIVE, "nanites")
	REMOVE_TRAIT(host_mob, TRAIT_NANOSEND, "nanites")
