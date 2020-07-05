//Severe traumas, when your brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They cannot be cured with chemicals, and require brain surgery to solve.

/datum/brain_trauma/severe
	resilience = TRAUMA_RESILIENCE_SURGERY

/datum/brain_trauma/severe/mute
	name = "Cichy"
	desc = "Badany nie potrawi mówić."
	scan_desc = "Uszkodzenie mózgu -Płat umiejętności mówienia"
	gain_text = "<span class='warning'>Nie możesz powiedzieć słowa!</span>"
	lose_text = "<span class='notice'>Przypomniało ci się jak rozmawiać.</span>"

/datum/brain_trauma/severe/mute/on_gain()
	ADD_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/mute/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/aphasia
	name = "Afazja"
	desc = "Badany nie rozumie żadnego zdania."
	scan_desc = "Uszkodzenie mózgu -Płat umiejętności mówienia"
	gain_text = "<span class='warning'>Nie rozumiesz żadnych słow...</span>"
	lose_text = "<span class='notice'>Przypominasz sobie jak słowa przmią.</span>"
	var/datum/language_holder/prev_language
	var/datum/language_holder/mob_language

/datum/brain_trauma/severe/aphasia/on_gain()
	mob_language = owner.get_language_holder()
	prev_language = mob_language.copy()
	mob_language.remove_all_languages()
	mob_language.grant_language(/datum/language/aphasia)
	..()

/datum/brain_trauma/severe/aphasia/on_lose()
	mob_language.remove_language(/datum/language/aphasia)
	mob_language.copy_known_languages_from(prev_language) //this will also preserve languages learned during the trauma
	QDEL_NULL(prev_language)
	mob_language = null
	..()

/datum/brain_trauma/severe/blindness
	name = "Ślepota"
	desc = "Oczy badanego nie są już podpięte do mózgu."
	scan_desc = "Łączenie mózgu z oczami zostało przerwane"
	gain_text = "<span class='warning'>Nic nie widzisz!</span>"
	lose_text = "<span class='notice'>Twoja wizja powraca.</span>"

/datum/brain_trauma/severe/blindness/on_gain()
	owner.become_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/blindness/on_lose()
	owner.cure_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/paralysis
	name = "Paraliż"
	desc = "Mózg badanego nie jest wstanie ruszać kończynami."
	scan_desc = "paraliż mózgu"
	gain_text = ""
	lose_text = ""
	var/paralysis_type
	var/list/paralysis_traits = list()
	 //for descriptions

/datum/brain_trauma/severe/paralysis/New(specific_type)
	if(specific_type)
		paralysis_type = specific_type
	if(!paralysis_type)
		paralysis_type = pick("full","left","right","arms","legs","r_arm","l_arm","r_leg","l_leg")
	var/subject
	switch(paralysis_type)
		if("full")
			subject = "your body"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("left")
			subject = "the left side of your body"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)
		if("right")
			subject = "the right side of your body"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG)
		if("arms")
			subject = "your arms"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM)
		if("legs")
			subject = "your legs"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("r_arm")
			subject = "your right arm"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM)
		if("l_arm")
			subject = "your left arm"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM)
		if("r_leg")
			subject = "your right leg"
			paralysis_traits = list(TRAIT_PARALYSIS_R_LEG)
		if("l_leg")
			subject = "your left leg"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG)

	gain_text = "<span class='warning'>You can't feel [subject] anymore!</span>"
	lose_text = "<span class='notice'>You can feel [subject] again!</span>"

/datum/brain_trauma/severe/paralysis/on_gain()
	..()
	for(var/X in paralysis_traits)
		ADD_TRAIT(owner, X, "trauma_paralysis")
	owner.update_disabled_bodyparts()

/datum/brain_trauma/severe/paralysis/on_lose()
	..()
	for(var/X in paralysis_traits)
		REMOVE_TRAIT(owner, X, "trauma_paralysis")
	owner.update_disabled_bodyparts()

/datum/brain_trauma/severe/paralysis/paraplegic
	random_gain = FALSE
	paralysis_type = "legs"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/narcolepsy
	name = "Narkolepsja"
	desc = "Badany zapada w sen podczas wykonywania różnych czynności."
	scan_desc = "narkolepsja"
	gain_text = "<span class='warning'>Masz ciągłe uczucie senności...</span>"
	lose_text = "<span class='notice'>Czujesz się wyspany.</span>"

/datum/brain_trauma/severe/narcolepsy/on_life()
	..()
	if(owner.IsSleeping())
		return
	var/sleep_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		sleep_chance += 2
	if(owner.drowsyness)
		sleep_chance += 3
	if(prob(sleep_chance))
		to_chat(owner, "<span class='warning'>Zasypiasz.</span>")
		owner.Sleeping(60)
	else if(!owner.drowsyness && prob(sleep_chance * 2))
		to_chat(owner, "<span class='warning'>Jesteś zmęczony...</span>")
		owner.drowsyness += 10

/datum/brain_trauma/severe/monophobia
	name = "Monofobia"
	desc = "Badany czuję się słabo kiedy jest sam, musi być w towarzystwie innej osoby lub może się zabić."
	scan_desc = "monofobia"
	gain_text = ""
	lose_text = "<span class='notice'>You feel like you could be safe on your own.</span>"
	var/stress = 0

/datum/brain_trauma/severe/monophobia/on_gain()
	..()
	if(check_alone())
		to_chat(owner, "<span class='warning'>Czujesz się samotny...</span>")
	else
		to_chat(owner, "<span class='notice'>Czujesz się bezpiecznie w towarzystwie innych ludzi.</span>")

/datum/brain_trauma/severe/monophobia/on_life()
	..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && (prob(5)))
			stress_reaction()
	else
		stress = max(stress - 4, 0)

/datum/brain_trauma/severe/monophobia/proc/check_alone()
	if(HAS_TRAIT(owner, TRAIT_BLIND))
		return TRUE
	for(var/mob/M in oview(owner, 7))
		if(!isliving(M)) //ghosts ain't people
			continue
		if((istype(M, /mob/living/simple_animal/pet)) || M.ckey)
			return FALSE
	return TRUE

/datum/brain_trauma/severe/monophobia/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Słabo się czujesz...</span>")
			else
				to_chat(owner, "<span class='warning'>Czujesz się słabo na myśl bycia samemu!</span>")
			addtimer(CALLBACK(owner, /mob/living/carbon.proc/vomit, high_stress), 50) //blood vomit if high stress
		if(2)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Nie możesz przestać się trząść...</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
			else
				to_chat(owner, "<span class='warning'>Czujesz się przestraszony i słabo, gdybyś tylko nie był sam...</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
				owner.adjustStaminaLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Czujesz się naprawde samotnie...</span>")
			else
				to_chat(owner, "<span class='warning'>Jesteś wściekły z podowu samotności!</span>")
				owner.hallucination += 30

		if(5)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Twoje serce wychodzi z rytmu na sekunde.</span>")
				owner.adjustOxyLoss(8)
			else
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					H.set_heartattack(TRUE)
					to_chat(H, "<span class='userdanger'>Czujesz kłujący bul w sercu!</span>")
				else
					to_chat(owner, "<span class='userdanger'>Czujesz jak serce wyrywa się z tłowia...</span>")
					owner.adjustOxyLoss(8)

/datum/brain_trauma/severe/discoordination
	name = "Brak koordynacji"
	desc = "Badany nie może używać narzędzi ani maszyn."
	scan_desc = "dyskoordynacja"
	gain_text = "<span class='warning'>Nie czujesz swoich rąk!</span>"
	lose_text = "<span class='notice'>Czujesz kontrole w rękach.</span>"

/datum/brain_trauma/severe/discoordination/on_gain()
	ADD_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/discoordination/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism
	name = "Pacyfista"
	desc = "Badany nie jest wstanie nikogo skrzywdzić."
	scan_desc = "pacyfism"
	gain_text = "<span class='notice'>Czujesz się spokojny.</span>"
	lose_text = "<span class='notice'>Uczucie spokojności przemija.</span>"

/datum/brain_trauma/severe/pacifism/on_gain()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism/on_lose()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/hypnotic_stupor
	name = "Zahipnotyzowany"
	desc = "Badany jest odurzony hipnozą."
	scan_desc = "odurzenie hipnozą"
	gain_text = "<span class='warning'>Czujesz się oszołomiony.</span>"
	lose_text = "<span class='notice'>Mgła umysłu przemineła.</span>"

/datum/brain_trauma/severe/hypnotic_stupor/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_stupor/on_life()
	..()
	if(prob(1) && !owner.has_status_effect(/datum/status_effect/trance))
		owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)
