//does low brute damage, oxygen damage, and stamina damage and wets tiles when damaged
/datum/blobstrain/reagent/pressurized_slime
	name = "Maślak Śliski"
	description = "zadajesz niskie obrażenia fizyczne, lekkie oparzenia oraz wywołujesz wyczerpanie, jak również pryskasz wodą pod stopy przeciwników."
	effectdesc = "pryskasz wodą wokoło blobów, które są atakowane lub zostały zabite."
	analyzerdescdamage = "Zadaje niskie obrażenia fizyczne, wywołuje lekkie oparzenia, oraz powoduje wyczerpanie, jak również pryska wodą pod stopy ofiar, gasząc je."
	analyzerdesceffect = "Gdy zostanie zaatakowany lub zabity, opryskuje pobliskie podłoże gasząc wszystko, co się na nim znajduje."
	color = "#AAAABB"
	complementary_color = "#BBBBAA"
	blobbernaut_message = "emits slime at"
	message = "Blob rozpryskuje się na ciebie"
	message_living = " i zapierasz dech w piersiach"
	reagent = /datum/reagent/blob/pressurized_slime

/datum/blobstrain/reagent/pressurized_slime/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if((damage_flag == "melee" || damage_flag == "bullet" || damage_flag == "laser") || damage_type != BURN)
		extinguisharea(B, damage)
	return ..()

/datum/blobstrain/reagent/pressurized_slime/death_reaction(obj/structure/blob/B, damage_flag)
	if(damage_flag == "melee" || damage_flag == "bullet" || damage_flag == "laser")
		B.visible_message("<span class='boldwarning'>The blob ruptures, spraying the area with liquid!</span>")
		extinguisharea(B, 50)

/datum/blobstrain/reagent/pressurized_slime/proc/extinguisharea(obj/structure/blob/B, probchance)
	for(var/turf/open/T in RANGE_TURFS(1, B))
		if(prob(probchance))
			T.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
			for(var/obj/O in T)
				O.extinguish()
			for(var/mob/living/L in T)
				L.adjust_fire_stacks(-2.5)
				L.ExtinguishMob()

/datum/reagent/blob/pressurized_slime
	name = "Pressurized Slime"
	taste_description = "a sponge"
	color = "#AAAABB"

/datum/reagent/blob/pressurized_slime/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/O)
	reac_volume = ..()
	var/turf/open/T = get_turf(M)
	if(istype(T) && prob(reac_volume))
		T.MakeSlippery(TURF_WET_LUBE, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)
		M.adjust_fire_stacks(-(reac_volume / 10))
		M.ExtinguishMob()
	M.apply_damage(0.4*reac_volume, BRUTE)
	if(M)
		M.apply_damage(0.4*reac_volume, OXY)
	if(M)
		M.adjustStaminaLoss(reac_volume)
