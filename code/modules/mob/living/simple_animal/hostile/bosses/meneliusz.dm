/mob/living/simple_animal/hostile/boss/meneliusz
	name = "Meneliusz, napędzana bimbrem maszyna wojenna"
	desc = "Powietrze w jego okolicy wydala silną, pełną alkoholu woń. Jego miecz jest pokryty nietypową substancją..."
	mob_biotypes = list(MOB_INORGANIC, MOB_HUMANOID)
	faction = list("hostile")
	del_on_death = TRUE
	speak_emote = list("roars")
	speed = 10
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	spacewalk = TRUE
	hardattacks = TRUE
	obj_damage = 500
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	environment_smash = ENVIRONMENT_SMASH_NONE
	deathmessage = "Rozpada się."
	attacktext = "Splashes an alcoholic substance at"
	rapid_melee = 1
	melee_damage = 5
	health = 500
	maxHealth = 500
	loot = list(/obj/item/stack/tile/brass/fifty)
	attack_sound = 'sound/machines/beep.ogg'
	do_footstep = TRUE


/mob/living/simple_animal/hostile/boss/meneliusz/AttackingTarget()
	var/mob/living/carbon/human/human_target = target

	if(!istype(human_target))
		return

	if(prob(8))
		human_target.reagents.add_reagent(/datum/reagent/consumable/ethanol/bacchus_blessing, 690)
	else  //LINE 30
		human_target.reagents.add_reagent(/datum/reagent/consumable/ethanol/hooch, 10)
//note na przyszłość, dodać szansę aby zamienił całą twoją krew w bimber



