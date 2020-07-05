//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Halucynacje"
	desc = "Badany cierpi z ciągłych halucynacji."
	scan_desc = "schizofrenia"
	gain_text = "<span class='warning'>Słyszałeś to?...</span>"
	lose_text = "<span class='notice'>Czujesz się spokojniej.</span>"

/datum/brain_trauma/mild/hallucinations/on_life()
	owner.hallucination = min(owner.hallucination + 10, 50)
	..()

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.hallucination = 0
	..()

/datum/brain_trauma/mild/stuttering
	name = "Bełkot"
	desc = "Badany jąka się."
	scan_desc = "zmiejszona koordynacja ust"
	gain_text = "<span class='warning'>Mówienie wyraźnie jest trudniejsze.</span>"
	lose_text = "<span class='notice'>Znowu potrafisz mówić wyraźnie.</span>"

/datum/brain_trauma/mild/stuttering/on_life()
	owner.stuttering = min(owner.stuttering + 5, 25)
	..()

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.stuttering = 0
	..()

/datum/brain_trauma/mild/dumbness
	name = "Głupi"
	desc = "Mózg badanego pracuje gorzej, przez co są mniej inteligentni."
	scan_desc = "Zmniejszona aktywność mózgowa"
	gain_text = "<span class='warning'>Twoje iq spada.</span>"
	lose_text = "<span class='notice'>Czujesz się mądry.</span>"

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "dumb", /datum/mood_event/oblivious)
	..()

/datum/brain_trauma/mild/dumbness/on_life()
	owner.derpspeech = min(owner.derpspeech + 5, 25)
	if(prob(3))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && prob(3))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage")
	..()

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.derpspeech = 0
	SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "dumb")
	..()

/datum/brain_trauma/mild/speech_impediment
	name = "Wada wymowy"
	desc = "Badany nie potrawi wypowiedzieć spójnych zdań."
	scan_desc = "Wada wymowy"
	gain_text = "<span class='danger'>Masz problemy z myśleniem logicznie!</span>"
	lose_text = "<span class='danger'>Twój umysł czuje się bardziej czysty.</span>"

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Zakłopotanie"
	desc = "Mózg badanego jest zakłopotany."
	scan_desc = "wstrząs mózgu"
	gain_text = "<span class='warning'>Twoja głowa boli!</span>"
	lose_text = "<span class='notice'>Ciśnienie w twojej głowie ustępuje.</span>"

/datum/brain_trauma/mild/concussion/on_life()
	if(prob(5))
		switch(rand(1,11))
			if(1)
				owner.vomit()
			if(2,3)
				owner.dizziness += 10
			if(4,5)
				owner.confused += 10
				owner.blur_eyes(10)
			if(6 to 9)
				owner.slurring += 30
			if(10)
				to_chat(owner, "<span class='notice'>Zapominasz na moment co robisz.</span>")
				owner.Stun(20)
			if(11)
				to_chat(owner, "<span class='warning'>Odpływasz.</span>")
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/healthy
	name = "Zdrowy ALE" //nie ma takiego słowa jak anosognosia w j. polski
	desc = "Badany nie może stwierdzić swojej kondycji zdrowia."
	scan_desc = "Problem stwierdzania kondycji"
	gain_text = "<span class='notice'>Czujesz się świetnie!</span>"
	lose_text = "<span class='warning'>Przestajesz się czuć w idealnym zdrowiu, już zauważasz problemy.</span>"

/datum/brain_trauma/mild/healthy/on_gain()
	owner.set_screwyhud(SCREWYHUD_HEALTHY)
	..()

/datum/brain_trauma/mild/healthy/on_life()
	owner.set_screwyhud(SCREWYHUD_HEALTHY) //just in case of hallucinations
	owner.adjustStaminaLoss(-5) //no pain, no fatigue
	..()

/datum/brain_trauma/mild/healthy/on_lose()
	owner.set_screwyhud(SCREWYHUD_NONE)
	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Zanik sygnału mięśniowego" //zanik mięsni nie pasuje bo to nie brain trauma
	desc = "Sygnały mięśniowe badanego zanikają."
	scan_desc = "słabe sygnały nerwowe"
	gain_text = "<span class='warning'>Twoje mięśnie drętwieją.</span>"
	lose_text = "<span class='notice'>Czujesz kontrole nad kończynami.</span>"

/datum/brain_trauma/mild/muscle_weakness/on_life()
	var/fall_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(prob(fall_chance) && (owner.mobility_flags & MOBILITY_STAND))
		to_chat(owner, "<span class='warning'>Twoja noga drętwieje!</span>")
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(prob(drop_chance) && owner.dropItemToGround(I))
			to_chat(owner, "<span class='warning'>Upuszczasz [I]!</span>")

	else if(prob(3))
		to_chat(owner, "<span class='warning'>Czujesz jakby twoje mięśnie zanikały!</span>")
		owner.adjustStaminaLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Drgawki"
	desc = "Mięśnie badanego czasem drgają, wprawiając je w ruch."
	scan_desc = "Tik nerwowy"
	gain_text = "<span class='warning'>Twoje mięsnie drgają.</span>"
	lose_text = "<span class='notice'>Czujesz kontrole w kończynach.</span>"

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Kaszel nerwowy" //tak samo jak tik nerwowy?
	desc = "Badany ma potrzebe kaszlu."
	scan_desc = "Nawyk kaszlu"
	gain_text = "<span class='warning'>Czujesz drapanie w twoijm gardle..</span>"
	lose_text = "<span class='notice'>Drapanie w gardle zanika.</span>"

/datum/brain_trauma/mild/nervous_cough/on_life()
	if(prob(12) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, "<span notice='warning'>[pick("Masz nawyk kaszlania!", "Nie możesz przestać kaszleć!")]</span>")
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, /mob/.proc/emote, "cough"), 6)
			addtimer(CALLBACK(owner, /mob/.proc/emote, "cough"), 12)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Afazja wymowy"
	desc = "Badany traci większość słów, będąc niezdolnym do ich wymowy."
	scan_desc = "Problem z wymową trudnych słow" //stół z powyłam- stół bez nóg
	gain_text = "<span class='warning'>Masz trudności z wymową trudnych wyrazów.</span>"
	lose_text = "<span class='notice'>Twoje słownictwo powraca.</span>"

	var/static/list/common_words = world.file2list("strings/1000_most_common.txt")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = ""
			var/suffix_foundon = 0
			for(var/potential_suffix in list("." , "," , ";" , "!" , ":" , "?"))
				suffix_foundon = findtext(word, potential_suffix, -length(potential_suffix))
				if(suffix_foundon)
					suffix = potential_suffix
					break

			if(suffix_foundon)
				word = copytext(word, 1, suffix_foundon)
			word = html_decode(word)

			if(lowertext(word) in common_words)
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("ee","eeh")
					break
				else
					var/list/charlist = text2charlist(word)
					charlist.len = round(charlist.len * 0.5, 1)
					shuffle_inplace(charlist)
					new_message += jointext(charlist, "") + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)
