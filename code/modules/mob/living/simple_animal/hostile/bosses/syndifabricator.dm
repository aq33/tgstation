/mob/living/simple_animal/hostile/boss/syndifabricator
	name = "Syndicate Replicator"
	desc = "A strange machine creating battle drones to help it fight."
	mob_biotypes = list(MOB_INORGANIC)
	boss_abilities = list(/datum/action/boss/fabricate_minions)
	faction = list("hostile","syndicate")
	del_on_death = TRUE
	icon = 'icons/mecha/mech_fab.dmi'
	icon_state = "fabricator"
	ranged = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	minimum_distance = 0
	retreat_distance = 0
	speed = 0
	obj_damage = 0
	melee_damage = 10
	health = 1000
	maxHealth = 1000
	loot = list(/obj/effect/temp_visual/syndifab_dying)
	projectiletype = /obj/item/projectile/temp



//Summon Ability
//Shamelesly stolen from paperwizard
/datum/action/boss/syndifabricator
	name = "Fabricate Minions"
	icon_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "art_summon"
	usage_probability = 100
	boss_cost = 10
	boss_type = /mob/living/simple_animal/hostile/boss/paper_wizard
	needs_target = FALSE
	say_when_triggered = "INITIATE FABRICATION PROCESS, ERROR, SUPPLY AMOUNT EXCEEDS STORAGE SPACE, INITIALIZING F@8RIC@ti0n"
	var/static/summoned_minions = 0 //byly tu kiedys visceratory do mojego syndifaba ale zrobiły błędy więc naprawię soontm

	//robienie tego czegoś to ból ale sugestia była dobra