/mob/living/simple_animal/hostile/asteroid/goliath/guardian
	name = "Maze Guardian"
	desc = "Przerośnięte monstrum, od pierwszych momentów jego istnienia, gdy jako chwast rosnący między płytkami poczuł smak krwi pragnął więcej. Potykał podróżujących w strefie działek swoimi gałęziami, i nie przestawał rosnąć, aż stał się królem tego przeklętego miejsca..."
	icon = 'icons/mob/lavaland/64x64megafauna.dmi'
	icon_state = "guardian0"
	icon_living = "guardian0"
	icon_aggro = "guardian1"
	icon_dead = "guardian_dead"
	move_to_delay = 20
	ranged_cooldown_time = 10
	friendly = "warczy na"
	speak_emote = list("huczy")
	faction = list("plants")
	vision_range = 50
	speed = 3
	maxHealth = 500
	health = 500
	obj_damage = 500
	melee_damage = 25
	attacktext = "Rozgniata"
	throw_message = "odbija się od"
	vision_range = 50
	aggro_vision_range = 50
	ventcrawler = VENTCRAWLER_ALWAYS
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	loot = list("/obj/item/gun/magic/staff/tree")
