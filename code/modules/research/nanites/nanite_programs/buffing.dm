//Programs that buff the host in generally passive ways.

/datum/nanite_program/nervous
	name = "Nerve Support"
	desc = "The nanites act as a secondary nervous system, reducing the amount of time the host is stunned."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/nervous/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.stun_mod *= 0.5

/datum/nanite_program/nervous/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.stun_mod *= 2

/datum/nanite_program/adrenaline
	name = "Adrenaline Burst"
	desc = "The nanites cause a burst of adrenaline when triggered, allowing the user to push their body past its normal limits."
	can_trigger = TRUE
	trigger_cost = 25
	trigger_cooldown = 1200
	rogue_types = list(/datum/nanite_program/toxic, /datum/nanite_program/nerve_decay)

/datum/nanite_program/adrenaline/on_trigger()
	to_chat(host_mob, "<span class='notice'>You feel a sudden surge of energy!</span>")
	host_mob.SetAllImmobility(0)
	host_mob.adjustStaminaLoss(-75)
	host_mob.set_resting(FALSE)
	host_mob.update_mobility()
	host_mob.reagents.add_reagent(/datum/reagent/medicine/stimulants, 3)

/datum/nanite_program/hardening
	name = "Dermal Hardening"
	desc = "The nanites form a mesh under the host's skin, protecting them from melee and bullet impacts."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/skin_decay)

//TODO on_hit effect that turns skin grey for a moment

/datum/nanite_program/hardening/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.melee += 50
		H.physiology.armor.bullet += 35

/datum/nanite_program/hardening/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.melee -= 50
		H.physiology.armor.bullet -= 35

/datum/nanite_program/refractive
	name = "Dermal Refractive Surface"
	desc = "The nanites form a membrane above the host's skin, reducing the effect of laser and energy impacts."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/refractive/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.laser += 50
		H.physiology.armor.energy += 35

/datum/nanite_program/refractive/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.laser -= 50
		H.physiology.armor.energy -= 35

/datum/nanite_program/coagulating
	name = "Rapid Coagulation"
	desc = "The nanites induce rapid coagulation when the host is wounded, dramatically reducing bleeding rate."
	use_rate = 0.10
	rogue_types = list(/datum/nanite_program/suffocating)

/datum/nanite_program/coagulating/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.bleed_mod *= 0.1

/datum/nanite_program/coagulating/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.bleed_mod *= 10

/datum/nanite_program/conductive
	name = "Electric Conduction"
	desc = "The nanites act as a grounding rod for electric shocks, protecting the host. Shocks can still damage the nanites themselves."
	use_rate = 0.20
	program_flags = NANITE_SHOCK_IMMUNE
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/conductive/enable_passive_effect()
	. = ..()
	ADD_TRAIT(host_mob, TRAIT_SHOCKIMMUNE, "nanites")

/datum/nanite_program/conductive/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_SHOCKIMMUNE, "nanites")

/datum/nanite_program/mindshield
	name = "Mental Barrier"
	desc = "The nanites form a protective membrane around the host's brain, shielding them from abnormal influences while they're active."
	use_rate = 0.40
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/mindshield/enable_passive_effect()
	. = ..()
	if(!host_mob.mind.has_antag_datum(/datum/antagonist/rev, TRUE)) //won't work if on a rev, to avoid having implanted revs.
		ADD_TRAIT(host_mob, TRAIT_MINDSHIELD, "nanites")
		host_mob.sec_hud_set_implants()

/datum/nanite_program/mindshield/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_MINDSHIELD, "nanites")
	host_mob.sec_hud_set_implants()

/datum/nanite_program/nanojutsu
	name = "Nanojutsu Teaching Program"
	desc = "The nanites stimulate host's brain, giving them the ability to use the martial art of Nanojutsu."
	use_rate = 3.5
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)
	var/datum/martial_art/nanojutsu/martial

/datum/nanite_program/nanojutsu/enable_passive_effect()
	. = ..()
	if(!ishuman(host_mob))
		return
	var/mob/living/carbon/human/H = host_mob
	martial = new(null)
	to_chat(H, "<span class='notice'>Your mind is flooded with martial arts knowledge[martial.teach(H, TRUE)?".<br>You can learn more about your newfound art by using the Recall Teachings verb in the Nanojutsu tab":", but you manage to block it out"].</span>")

/datum/nanite_program/nanojutsu/disable_passive_effect()
	. = ..()
	if(!ishuman(host_mob))
		return
	var/mob/living/carbon/human/H = host_mob
	martial.remove(H)
	to_chat(H, "<span class='notice'>Your mind feels clear once again, as thoughts about the martial arts leave your head.</span>")
	QDEL_NULL(martial)

/datum/nanite_program/camo
	name = "Adaptive Camouflage"
	desc = "The nanites coat host with a thin, reflective layer, rendering them almost invisible."
	use_rate = 2.5
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/camo/enable_passive_effect()
	. = ..()
	animate(host_mob, alpha = 50,time = 15) //copypasta z ninja suita
	host_mob.visible_message("<span class='warning'>[host_mob] vanishes into thin air!</span>", \
					"<span class='notice'>You see your hands turn invisible.</span>")

/datum/nanite_program/camo/disable_passive_effect()
	. = ..()
	animate(host_mob, alpha = 255, time = 15)
	host_mob.visible_message("<span class='warning'>[host_mob] appears from thin air!</span>", \
					"<span class='notice'>You see your hands reappear.</span>")