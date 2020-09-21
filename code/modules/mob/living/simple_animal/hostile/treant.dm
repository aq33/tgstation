/mob/living/simple_animal/hostile/treant
	name = "Treant"
	desc = "Ktoś w tym jest!"
	icon_state = "venus_human_trap"
	icon_living = "venus_human_trap"
	icon_dead = "old_dead"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 5
	maxHealth = 50
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	health = 50
	see_in_dark = 3
	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"
	melee_damage = 5
	attacktext = "slams"
	attack_sound = 'sound/weapons/punch1.ogg'
	ventcrawler = VENTCRAWLER_ALWAYS
	faction = list("plants")

	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 150
	maxbodytemp = 500
	gold_core_spawnable = HOSTILE_SPAWN

/mob/living/simple_animal/hostile/treant/Initialize()
	. = ..()
	find_candidates()

/mob/living/simple_animal/hostile/treant/attack_ghost(mob/dead/observer/user)
	. = ..()
	give_to_ghost(user)
