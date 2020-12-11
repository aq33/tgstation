//Programs specifically engineered to cause harm to either the user or its surroundings (as opposed to ones that only do it due to broken programming)
//Very dangerous!

/datum/nanite_program/flesh_eating
	name = "Cellular Breakdown"
	desc = "The nanites destroy cellular structures in the host's body, causing brute damage."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/flesh_eating/active_effect()
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		C.take_bodypart_damage(1, 0, 0)
	else
		host_mob.adjustBruteLoss(1, TRUE)
	if(prob(3))
		to_chat(host_mob, "<span class='warning'>You feel a stab of pain from somewhere inside you.</span>")

/datum/nanite_program/poison
	name = "Poisoning"
	desc = "The nanites deliver poisonous chemicals to the host's internal organs, causing toxin damage and vomiting."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/poison/active_effect()
	host_mob.adjustToxLoss(1)
	if(prob(2))
		to_chat(host_mob, "<span class='warning'>You feel nauseous.</span>")
		if(iscarbon(host_mob))
			var/mob/living/carbon/C = host_mob
			C.vomit(20)

/datum/nanite_program/memory_leak
	name = "Memory Leak"
	desc = "This program invades the memory space used by other programs, causing frequent corruptions and errors."
	use_rate = 0
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/memory_leak/active_effect()
	if(prob(6))
		var/datum/nanite_program/target = pick(nanites.programs)
		if(target == src)
			return
		target.software_error()

/datum/nanite_program/aggressive_replication
	name = "Aggressive Replication"
	desc = "Nanites will consume organic matter to improve their replication rate, damaging the host. The efficiency increases with the volume of nanites, requiring 200 to break even."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/necrotic)

/datum/nanite_program/aggressive_replication/active_effect()
	var/extra_regen = round(nanites.nanite_volume / 200, 0.1)
	nanites.adjust_nanites(null, extra_regen)
	host_mob.adjustBruteLoss(extra_regen / 2, TRUE)

/datum/nanite_program/meltdown
	name = "Meltdown"
	desc = "Causes an internal meltdown inside the nanites, causing internal burns inside the host as well as rapidly destroying the nanite population.\
			Sets the nanites' safety threshold to 0 when activated."
	use_rate = 10
	rogue_types = list(/datum/nanite_program/glitch)

/datum/nanite_program/meltdown/active_effect()
	host_mob.adjustFireLoss(3.5)

/datum/nanite_program/meltdown/enable_passive_effect()
	. = ..()
	to_chat(host_mob, "<span class='userdanger'>Your blood is burning!</span>")
	nanites.safety_threshold = 0

/datum/nanite_program/meltdown/disable_passive_effect()
	. = ..()
	to_chat(host_mob, "<span class='warning'>Your blood cools down, and the pain gradually fades.</span>")

/datum/nanite_program/explosive
	name = "Chain Detonation"
	desc = "Detonates all the nanites inside the host in a chain reaction when triggered."
	can_trigger = TRUE
	trigger_cost = 25 //plus every idle nanite left afterwards
	trigger_cooldown = 100 //Just to avoid double-triggering
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/explosive/on_trigger(comm_message)
	host_mob.visible_message("<span class='warning'>[host_mob] starts emitting a high-pitched buzzing, and [host_mob.p_their()] skin begins to glow...</span>",\
							"<span class='userdanger'>You start emitting a high-pitched buzzing, and your skin begins to glow...</span>")
	addtimer(CALLBACK(src, .proc/boom), clamp((nanites.nanite_volume * 0.35), 25, 150))

/datum/nanite_program/explosive/proc/boom()
	var/nanite_amount = nanites.nanite_volume
	var/dev_range = FLOOR(nanite_amount/200, 1) - 1
	var/heavy_range = FLOOR(nanite_amount/100, 1) - 1
	var/light_range = FLOOR(nanite_amount/50, 1) - 1
	explosion(host_mob, dev_range, heavy_range, light_range)
	qdel(nanites)

//TODO make it defuse if triggered again

/datum/nanite_program/heart_stop
	name = "Heart-Stopper"
	desc = "Stops the host's heart when triggered; restarts it if triggered again."
	can_trigger = TRUE
	trigger_cost = 12
	trigger_cooldown = 10
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/heart_stop/on_trigger(comm_message)
	if(iscarbon(host_mob))
		var/mob/living/carbon/C = host_mob
		var/obj/item/organ/heart/heart = C.getorganslot(ORGAN_SLOT_HEART)
		if(heart)
			if(heart.beating)
				heart.Stop()
			else
				heart.Restart()

/datum/nanite_program/emp
	name = "Electromagnetic Resonance"
	desc = "The nanites cause an electromagnetic pulse around the host when triggered. Will corrupt other nanite programs!"
	can_trigger = TRUE
	trigger_cost = 10
	trigger_cooldown = 50
	program_flags = NANITE_EMP_IMMUNE
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/emp/on_trigger(comm_message)
	empulse(host_mob, 1, 2)

/datum/nanite_program/pyro/active_effect()
	host_mob.fire_stacks += 1
	host_mob.IgniteMob()

/datum/nanite_program/pyro
	name = "Sub-Dermal Combustion"
	desc = "The nanites cause buildup of flammable fluids under the host's skin, then ignites them."
	use_rate = 4
	rogue_types = list(/datum/nanite_program/skin_decay, /datum/nanite_program/cryo)

/datum/nanite_program/pyro/check_conditions()
	if(host_mob.fire_stacks >= 10 && host_mob.on_fire)
		return FALSE
	return ..()

/datum/nanite_program/pyro/active_effect()
	host_mob.fire_stacks += 1
	host_mob.IgniteMob()

/datum/nanite_program/cryo
	name = "Cryogenic Treatment"
	desc = "The nanites rapidly sink heat through the host's skin, lowering their temperature."
	use_rate = 1
	rogue_types = list(/datum/nanite_program/skin_decay, /datum/nanite_program/pyro)

/datum/nanite_program/cryo/check_conditions()
	if(host_mob.bodytemperature <= 70)
		return FALSE
	return ..()

/datum/nanite_program/cryo/active_effect()
	host_mob.adjust_bodytemperature(-rand(15,25), 50)

/datum/nanite_program/comm/mind_control
	name = "Mind Control"
	desc = "The nanites imprint an absolute directive onto the host's brain for one minute when triggered."
	trigger_cost = 30
	trigger_cooldown = 1800
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/comm/mind_control/register_extra_settings()
	. = ..()
	extra_settings[NES_DIRECTIVE] = new /datum/nanite_extra_setting/text("...")

/datum/nanite_program/comm/mind_control/on_trigger(comm_message)
	if(host_mob.stat == DEAD)
		return
	var/sent_directive = comm_message
	if(!comm_message)
		var/datum/nanite_extra_setting/ES = extra_settings[NES_DIRECTIVE]
		sent_directive = ES.get_value()
	brainwash(host_mob, sent_directive)
	log_game("A mind control nanite program brainwashed [key_name(host_mob)] with the objective '[sent_directive]'.")
	addtimer(CALLBACK(src, .proc/end_brainwashing), 600)

/datum/nanite_program/comm/mind_control/proc/end_brainwashing()
	if(host_mob.mind && host_mob.mind.has_antag_datum(/datum/antagonist/brainwashed))
		host_mob.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	log_game("[key_name(host_mob)] is no longer brainwashed by nanites.")

/datum/nanite_program/comm/mind_control/disable_passive_effect()
	. = ..()
	end_brainwashing()

/datum/nanite_program/kunai
	name = "Kunai Form"
	desc = "When triggered, nanites attempt to gather in host's free hand, forming a Kunai knife, which disintegrates a few seconds after being thrown."
	can_trigger = TRUE
	trigger_cost = 100
	trigger_cooldown = 50
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/kunai/on_trigger(comm_message)
	var/obj/item/throwing_star/nanite/N = new(get_turf(host_mob))
	if(!iscarbon(host_mob))
		to_chat(host_mob, "<span class='notice'>A kunai suddenly appears below you!</span>")
		return
	var/mob/living/carbon/C = host_mob
	if(!C.put_in_hands(N))
		to_chat(C, "<span class='notice'>A kunai suddenly appears below you!</span>")
		return
	to_chat(C, "<span class='notice'>A kunai suddenly appears in your hand!</span>")

/datum/nanite_program/nanophage
	name = "Nano Swarm"
	desc = "When triggered, nanites gather in host's stomach, forming nanophages - small, pre-programmed drones, then quickly get coughed out."
	can_trigger = TRUE
	trigger_cost = 100
	trigger_cooldown = 300
	rogue_types = list(/datum/nanite_program/toxic)

/datum/nanite_program/nanophage/register_extra_settings()
	. = ..()
	extra_settings[NES_HOST_AGGRESSION] = new /datum/nanite_extra_setting/boolean(TRUE, "True", "False")

/datum/nanite_program/nanophage/on_trigger(comm_message)
	host_mob.visible_message("<span class='danger'>[host_mob] throws up a swarm of nanophages!</span>", \
					"<span class='userdanger'>You throw up a swarm of nanophages!</span>")
	playsound(host_mob, 'sound/misc/nanobirth.ogg', 50)
	
	var/list/factions = list()
	
	if(!extra_settings[NES_HOST_AGGRESSION].get_value())
		factions = host_mob.faction.Copy() //copypasta z dehydrated carpa. sprawdźmy czy zadziała
		for(var/F in factions)
			if(F == "neutral")
				factions -= F
	
	for(var/i in 1 to 8)
		var/mob/living/simple_animal/hostile/nanophage/nano = new /mob/living/simple_animal/hostile/nanophage(get_turf(host_mob))
		step(nano, pick(NORTH,SOUTH,EAST,WEST))
		if(!extra_settings[NES_HOST_AGGRESSION].get_value())
			nano.faction = factions
		sleep(1)