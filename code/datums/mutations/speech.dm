//These are all minor mutations that affect your speech somehow.
//Individual ones aren't commented since their functions should be evident at a glance

/datum/mutation/human/nervousness
	name = "Nervousness"
	desc = "Causes the holder to stutter."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>You feel nervous.</span>"

/datum/mutation/human/nervousness/on_life()
	if(prob(10))
		owner.stuttering = max(10, owner.stuttering)


/datum/mutation/human/wacky
	name = "Wacky"
	desc = "You are not a clown. You are the entire circus."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='sans'>You feel an off sensation in your voicebox.</span>"
	text_lose_indication = "<span class='notice'>The off sensation passes.</span>"

/datum/mutation/human/wacky/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/mutation/human/wacky/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/wacky/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/mutation/human/mute
	name = "Mute"
	desc = "Completely inhibits the vocal section of the brain."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>You feel unable to express yourself at all.</span>"
	text_lose_indication = "<span class='danger'>You feel able to speak freely again.</span>"

/datum/mutation/human/mute/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/mute/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/unintelligible
	name = "Unintelligible"
	desc = "Partially inhibits the vocal center of the brain, severely distorting speech."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>You can't seem to form any coherent thoughts!</span>"
	text_lose_indication = "<span class='danger'>Your mind feels more clear.</span>"

/datum/mutation/human/unintelligible/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/unintelligible/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/swedish
	name = "Swedish"
	desc = "A horrible mutation originating from the distant past. Thought to be eradicated after the incident in 2037."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>You feel Swedish, however that works.</span>"
	text_lose_indication = "<span class='notice'>The feeling of Swedishness passes.</span>"

/datum/mutation/human/swedish/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/mutation/human/swedish/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/swedish/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = replacetext(message,"w","v")
		message = replacetext(message,"j","y")
		message = replacetext(message,"a",pick("å","ä","æ","a"))
		message = replacetext(message,"bo","bjo")
		message = replacetext(message,"o",pick("ö","ø","o"))
		if(prob(30))
			message += " Bork[pick("",", bork",", bork, bork")]!"
		speech_args[SPEECH_MESSAGE] = trim(message)

/datum/mutation/human/chav
	name = "Chav"
	desc = "Unknown"
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>Ye feel like a reet prat like, innit?</span>"
	text_lose_indication = "<span class='notice'>You no longer feel like being rude and sassy.</span>"

/datum/mutation/human/chav/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/mutation/human/chav/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/chav/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		message = replacetext(message," looking at  ","  gawpin' at ")
		message = replacetext(message," great "," bangin' ")
		message = replacetext(message," man "," mate ")
		message = replacetext(message," friend ",pick(" mate "," bruv "," bledrin "))
		message = replacetext(message," what "," wot ")
		message = replacetext(message," drink "," wet ")
		message = replacetext(message," get "," giz ")
		message = replacetext(message," what "," wot ")
		message = replacetext(message," no thanks "," wuddent fukken do one ")
		message = replacetext(message," i don't know "," wot mate ")
		message = replacetext(message," no "," naw ")
		message = replacetext(message," robust "," chin ")
		message = replacetext(message,"  hi  "," how what how ")
		message = replacetext(message," hello "," sup bruv ")
		message = replacetext(message," kill "," bang ")
		message = replacetext(message," murder "," bang ")
		message = replacetext(message," windows "," windies ")
		message = replacetext(message," window "," windy ")
		message = replacetext(message," break "," do ")
		message = replacetext(message," your "," yer ")
		message = replacetext(message," security "," coppers ")
		speech_args[SPEECH_MESSAGE] = trim(message)


/datum/mutation/human/elvis
	name = "Elvis"
	desc = "Straszliwa mutacja pochodząca od 'pacjenta-zero'."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>Czujesz się świetnie, laleczko.</span>"
	text_lose_indication = "<span class='notice'>Czujesz, że nie chcesz już tyle mówić.</span>"

/datum/mutation/human/elvis/on_life()
	switch(pick(1,2))
		if(1)
			if(prob(15))
				var/list/dancetypes = list("huśtające", "fantastyczne", "stylowe", "20-sto wieczne", "kręcoce", "rock 'n' rollowe", "cool", "ponętne", "zjawiskowe")
				var/dancemoves = pick(dancetypes)
				owner.visible_message("<b>[owner]</b> nagle zaczyna tańczyć, wykonując swoje [dancemoves] taneczne kroki!")
		if(2)
			if(prob(15))
				owner.visible_message("<b>[owner]</b> [pick("potrząsa bioderkami", "kręci bioderkami", "wiruje bioderkami", "postukuje nóżką", "tańczy do wymyślonej muzyki", "rusza nogami w rytm", "pstryka palcami")]!")

/datum/mutation/human/elvis/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/mutation/human/elvis/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/elvis/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		message = replacetext(message," nie jestem "," ooojjj jaaa nie jestem ")
		message = replacetext(message," dziewczyno ",pick(" słodka "," dziecino "," laleczko "))
		message = replacetext(message," facet ",pick(" synek "," typo "," brach"," kumpel "," typeczek "))
		message = replacetext(message," dzieki "," dzieki, wielkie, wielkie dzięki")
		message = replacetext(message," dziękuje "," dziękuje, bardzo, ale to bardzo dziękuje ")
		message = replacetext(message," tak ",pick(" pewex", "taaaa ", "jaha"))

		speech_args[SPEECH_MESSAGE] = trim(message)


/datum/mutation/human/stoner
	name = "Stoner"
	desc = "A common mutation that severely decreases intelligence."
	quality = NEGATIVE
	text_gain_indication = "<span class='notice'>Czujesz się... totaaaaaaaaaalnie wychilowany...</span>"
	text_lose_indication = "<span class='notice'>Masz wrażenie, jakbyś lepiej odczuwał przepływ czasu.</span>"

/datum/mutation/human/stoner/on_acquiring(mob/living/carbon/human/owner)
	..()
	owner.grant_language(/datum/language/beachbum, TRUE, TRUE, LANGUAGE_STONER)
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)

/datum/mutation/human/stoner/on_losing(mob/living/carbon/human/owner)
	..()
	owner.remove_language(/datum/language/beachbum, TRUE, TRUE, LANGUAGE_STONER)
	owner.remove_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)
