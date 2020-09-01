/mob/living/simple_animal/hostile/boss/meneliusz
	name = "Meneliusz, napędzana bimbrem maszyna wojenna"
	desc = "Powietrze w jego okolicy wydala silną, pełną alkoholu woń. Jego miecz jest pokryty nietypową substancją..."
	mob_biotypes = list(MOB_INORGANIC, MOB_HUMANOID)
	faction = list("hostile")
	del_on_death = TRUE
	icon = 'icons/mob/clockwork_mobs.dmi'
	icon_state = "clockwork_marauder"
	environment_smash = ENVIRONMENT_SMASH_NONE
	deathmessage = "Falls to the ground, leaving behind only the very brass which he defended for years..."
	attacktext = "Cuts"
	melee_damage = 0
	health = 400
	maxHealth = 400
	loot = list(/obj/item/stack/tile/brass/fifty)
	projectiletype = /obj/item/projectile/temp
	projectilesound = 'sound/weapons/emitter.ogg'
	attack_sound = 'sound/machines/clockcult/ark_scream.ogg'

	do_footstep = TRUE


/mob/living/simple_animal/hostile/boss/meneliusz/AttackingTarget()
	if(!istype(target, /mob/living))
		return
	target.reagents.add_reagent(/datum/reagent/consumable/ethanol/gargle_blaster, 35)

//note na przyszłość, dodać szansę aby zamienił całą twoją krew w bimber
