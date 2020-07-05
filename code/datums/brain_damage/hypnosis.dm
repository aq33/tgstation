/datum/brain_trauma/hypnosis
	name = "Hipnoza"
	desc = "Badany wykonuje powtarzające się myśli bez wzgledu na wszystko."
	scan_desc = "Powtarzające się myśli"
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY

	var/hypnotic_phrase = ""
	var/regex/target_phrase

/datum/brain_trauma/hypnosis/New(phrase)
	if(!phrase)
		qdel(src)
	hypnotic_phrase = phrase
	try
		target_phrase = new("(\\b[hypnotic_phrase]\\b)","ig")
	catch(var/exception/e)
		stack_trace("[e] on [e.file]:[e.line]")
		qdel(src)
	..()

/datum/brain_trauma/hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, "<span class='reallybig hypnophrase'>[hypnotic_phrase]</span>")
	to_chat(owner, "<span class='notice'>[pick("Czujesz jak twoje myśli skupiają się tylko na tym zdaniu... nie możesz przestać o tym myśleć.",\
												"Twoja głowa boli, ale nie możesz przestać o tym myśleć. To musi być naprawde ważne.",\
												"Czujesz jak cześć twojego mózgu ciągle powtarza te zdanie. Musisz je wykonać.",\
												"Coś o tym zdaniu... jest prawdziwego. Czujesz, że naprawde musisz je wykonać.",\
												"Te słowa są jak echo w twoich myślach. Jesteś kompletnie zafascynowany nimi.")]</span>")
	to_chat(owner, "<span class='boldwarning'>Zostałeś zahipnotyzowany tymi słowami. Musisz je wykonać. Jeśli nie są wystarczająco jasne, interpretuj je jak chesz, byle by zostały wykonane,\
										oraz zachowuj się jakby te słowa miały najważniejsze znaczenie.</span>")
	var/obj/screen/alert/hypnosis/hypno_alert = owner.throw_alert("hypnosis", /obj/screen/alert/hypnosis)
	hypno_alert.desc = "\"[hypnotic_phrase]\"... twój mózg jest safascynowany tym pomysłem."
	..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, "<span class='userdanger'>Przebudzasz się z hipnozy. Zdanie '[hypnotic_phrase]' nie jest już dla ciebie ważny.</span>")
	owner.clear_alert("hypnosis")
	..()

/datum/brain_trauma/hypnosis/on_life()
	..()
	if(prob(2))
		switch(rand(1,2))
			if(1)
				to_chat(owner, "<i>...[lowertext(hypnotic_phrase)]...</i>")
			if(2)
				new /datum/hallucination/chat(owner, TRUE, FALSE, "<span class='hypnophrase'>[hypnotic_phrase]</span>")

/datum/brain_trauma/hypnosis/on_hear(message, speaker, message_language, raw_message, radio_freq)
	message = target_phrase.Replace(message, "<span class='hypnophrase'>$1</span>")
	return message
