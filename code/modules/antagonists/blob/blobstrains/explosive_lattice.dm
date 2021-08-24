//does aoe brute damage when hitting targets, is immune to explosions
/datum/blobstrain/reagent/explosive_lattice
	name = "Purchawka Wybuchowa"
	description = "zadajesz obszarowe obrażenia fizyczne."
	effectdesc = "jesteś wysoce odporny na wybuchy, ale otrzymujesz większe obrażenia od ognia oraz innych typów energii."
	analyzerdescdamage = "Zadaje średnie obrażenia fizyczne oraz obszarowe."
	analyzerdesceffect = "Jest wysoce odporny na wybuchy, ale otrzymuje większe obrażenia od ognia oraz innych typów energii."
	color = "#8B2500"
	complementary_color = "#00668B"
	blobbernaut_message = "blasts"
	message = "The blob blasts you"
	reagent = /datum/reagent/blob/explosive_lattice

/datum/blobstrain/reagent/explosive_lattice/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage_flag == "bomb")
		return 0
	else if(damage_flag != "melee" && damage_flag != "bullet" && damage_flag != "laser")
		return damage * 1.5
	return ..()

/datum/reagent/blob/explosive_lattice
	name = "Explosive Lattice"
	taste_description = "the bomb"
	color = "#8B2500"

/datum/reagent/blob/explosive_lattice/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/O)
	var/initial_volume = reac_volume
	reac_volume = ..()
	if(reac_volume >= 10) //if it's not a spore cloud, bad time incoming
		var/obj/effect/temp_visual/explosion/fast/E = new /obj/effect/temp_visual/explosion/fast(get_turf(M))
		E.alpha = 150
		for(var/mob/living/L in ohearers(1, get_turf(M)))
			if(ROLE_BLOB in L.faction) //no friendly fire
				continue
			var/aoe_volume = ..(L, TOUCH, initial_volume, 0, L.get_permeability_protection(), O)
			L.apply_damage(0.4*aoe_volume, BRUTE)
		if(M)
			M.apply_damage(0.6*reac_volume, BRUTE)
	else
		M.apply_damage(0.6*reac_volume, BRUTE)
