//does brute, burn, and toxin damage, and cools targets down
/datum/blobstrain/reagent/cryogenic_poison
	name = "Huba Syberyjska"
	description = "wstrzykujesz zamrażającą truciznę, która zadaje duże obrażenia w czasie."
	analyzerdescdamage = "Wstrzykuje we wrogów zamrażającą truciznę, która stopniowo zabija organy wewnętrzne."
	color = "#8BA6E9"
	complementary_color = "#7D6EB4"
	blobbernaut_message = "wstrzykuje"
	message = "Blob wbija w ciebie kolce"
	message_living = " i czujesz jakby twoje wnętrzności zamarzały."
	reagent = /datum/reagent/blob/cryogenic_poison

/datum/reagent/blob/cryogenic_poison
	name = "Cryogenic Poison"
	description = "wstrzykuje zamrażającą truciznę, która zadaje duże obrażenia w czasie."
	color = "#8BA6E9"
	taste_description = "brain freeze"

/datum/reagent/blob/cryogenic_poison/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/O)
	reac_volume = ..()
	if(M.reagents)
		M.reagents.add_reagent(/datum/reagent/consumable/frostoil, 0.3*reac_volume)
		M.reagents.add_reagent(/datum/reagent/consumable/ice, 0.3*reac_volume)
		M.reagents.add_reagent(/datum/reagent/blob/cryogenic_poison, 0.3*reac_volume)
	M.apply_damage(0.2*reac_volume, BRUTE)

/datum/reagent/blob/cryogenic_poison/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(0.3*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustFireLoss(0.3*REAGENTS_EFFECT_MULTIPLIER, 0)
	M.adjustToxLoss(0.3*REAGENTS_EFFECT_MULTIPLIER, 0)
	. = 1
	..()
