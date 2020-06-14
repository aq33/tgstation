//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/no_taste
	name = "Aguezja"
	desc = "Nie czujesz smaku! Toksyczne jedzenie nadal jest trujące."
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = "<span class='notice'>Nie czujesz smaku!</span>"
	lose_text = "<span class='notice'>Znowu czujesz smak!</span>"
	medical_record_text = "Pacjent choruje na aguezję i nie czuje smaku potraw."

/datum/quirk/foreigner
	name = "Obcokrajowiec"
	desc = "Nie jesteś stąd. Nie znasz Galaktycznego Pospolitego!"
	value = 0
	gain_text = "<span class='notice'>Słowa które mówisz nie mają sensu."
	lose_text = "<span class='notice'>Potrafisz płynnie rozmawiać w Galaktycznym Pospolitym."
	medical_record_text = "Pacjent nie zna Galaktycznego Pospolitego i potrzebuje tłumacza."

/datum/quirk/foreigner/add()
	var/mob/living/carbon/human/H = quirk_holder
	H.add_blocked_language(/datum/language/common)
	if(ishumanbasic(H) || isfelinid(H))
		H.grant_language(/datum/language/uncommon)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(H) || isfelinid(H))
		H.remove_language(/datum/language/uncommon)

/datum/quirk/vegetarian
	name = "Wegetarianin"
	desc = "Uważasz, że jedzenie mięsa jest niemoralne."
	value = 0
	gain_text = "<span class='notice'>Odrzuca cię myśl jedzenia mięsa.</span>"
	lose_text = "<span class='notice'>Uważasz, że mięso nie jest jednak takie złe.</span>"
	medical_record_text = "Pacjent zgłosił, że stosuje dietę wegetariańską."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(initial(species.liked_food) & MEAT)
			species.liked_food |= MEAT
		if(!initial(species.disliked_food) & MEAT)
			species.disliked_food &= ~MEAT

/datum/quirk/snob
	name = "Snob"
	desc = "Obchodzą cię tylko piekne rzeczy, jeśli pokój nie wygląda ładnie to nie jest tego wart, czyż nie?"
	value = 0
	gain_text = "<span class='notice'>Czujesz, że znasz definicję piękna.</span>"
	lose_text = "<span class='notice'>Kogo tak właściwie obchodzi wystrój?</span>"
	medical_record_text = "Pacjent ma wygórowane ego."
	mob_trait = TRAIT_SNOB

/datum/quirk/pineapple_liker
	name = "Uwielbienie Ananasa"
	desc = "Uwielbiasz jeść potrawy z ananasem. Nigdy nie masz dość ich słodkości!"
	value = 0
	gain_text = "<span class='notice'>Czujesz niesamowitą potrzebę zjedzenia ananasa.</span>"
	lose_text = "<span class='notice'>Ananasy nie robią już na tobie wrażenia.</span>"
	medical_record_text = "Pacjent wykazuje patologiczne zamiłowanie do spożywania ananasów."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Obrzydzenie Ananasa"
	desc = "Nie lubisz spożywać potraw z ananasem. Serio, komu to w ogóle smakuje? I jaki szaleniec uznał, że dobrym pomysłem jest dodawanie ich do pizzy!?"
	value = 0
	gain_text = "<span class='notice'>Zastanawasz się jakiemu idiocie w ogóle smakują ananasy...</span>"
	lose_text = "<span class='notice'>Ananasy nie robią już na tobie wrażenia.</span>"

/datum/quirk/pineapple_hater/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Dziwne Preferencje Kulinarne"
	desc = "Nie lubisz jedzenia, które wiekszość ludzi uznaje za dobre, a ubóstwiasz to którego nikt inny nie tknie."
	value = 0
	gain_text = "<span class='notice'>Masz ochotę zjeść coś co smakuje dziwnie.</span>"
	lose_text = "<span class='notice'>Masz ochotę zjeść coś normalnego.</span>"
	medical_record_text = "Kubki smakowe pacjenta działają w nietypowy sposób."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food = initial(species.liked_food)
		species.disliked_food = initial(species.disliked_food)

/datum/quirk/monochromatic
	name = "Monochromatyczność"
	desc = "Cierpisz na daltonizm, widzisz świat w czerni i bieli."
	value = 0
	medical_record_text = "Pacjent wykazuje niemal całkowity daltonizm."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, "<span class='boldannounce'>Hmm. Ta stacja jest pełna brudu. Cała w odcieniach szarości...</span>")
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	if(quirk_holder)
		quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/phobia
	name = "Fobia"
	desc = "Czujesz irracjonalny lęk przed czymś."
	value = 0
	medical_record_text = "Pacjent odczuwa irracjonalny strach przed czymś."

/datum/quirk/phobia/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(new /datum/brain_trauma/mild/phobia(H.client?.prefs.phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/needswayfinder
	name = "Nawigacyjnie Upośledzony"
	desc = "Brakuje ci znajomości rozkładu niektórych stacji, zaczynasz z wskaźnikiem."
	value = 0
	medical_record_text = "Pacjent wykazuje tendencję do gubienia się."

	var/obj/item/pinpointer/wayfinding/wayfinder
	var/where

/datum/quirk/needswayfinder/on_spawn()
	if(!GLOB.wayfindingbeacons.len)
		return
	var/mob/living/carbon/human/H = quirk_holder

	wayfinder = new /obj/item/pinpointer/wayfinding
	wayfinder.owner = H.real_name
	wayfinder.roundstart = TRUE

	var/list/slots = list(
		"w swojej lewej kieszeni" = ITEM_SLOT_LPOCKET,
		"w swojej prawej kieszeni" = ITEM_SLOT_RPOCKET,
		"w swoim plecaku" = ITEM_SLOT_BACKPACK
	)
	where = H.equip_in_one_of_slots(wayfinder, slots, FALSE) || "pod twoimi stopami"

/datum/quirk/needswayfinder/post_add()
	if(!GLOB.wayfindingbeacons.len)
		return
	if(where == "w twoim plecaku")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, "<span class='notice'>Masz wskaźnik [where], pomoże ci on się odnaleźć na stacji. Kliknij na niego, kiedy masz go w dłoni, żeby go aktywować.</span>")

/datum/quirk/bald
	name = "Gładkogłowy"
	desc = "Nie masz włosów na głowie i bardzo się tego wstydzisz! Noś swój tupecik lub chociaż przykryj czymś głowę."
	value = 0
	mob_trait = TRAIT_BALD
	gain_text = "<span class='notice'>Twoje głowa jest gładka niczym pupcia niemowlaka, gorzej być nie może.</span>"
	lose_text = "<span class='notice'>Głowa cię swędzi, czy tobie... odrastają włosy?!</span>"
	medical_record_text = "Pacjent stanowczo odmówił zdjęcia nakrycia glowy podczas badania."
	///The user's starting hairstyle
	var/old_hair

/datum/quirk/bald/add()
	var/mob/living/carbon/human/H = quirk_holder
	old_hair = H.hairstyle
	H.hairstyle = "Bald"
	H.update_hair()
	RegisterSignal(H, COMSIG_CARBON_EQUIP_HAT, .proc/equip_hat)
	RegisterSignal(H, COMSIG_CARBON_UNEQUIP_HAT, .proc/unequip_hat)

/datum/quirk/bald/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.hairstyle = old_hair
	H.update_hair()
	UnregisterSignal(H, list(COMSIG_CARBON_EQUIP_HAT, COMSIG_CARBON_UNEQUIP_HAT))
	SEND_SIGNAL(H, COMSIG_CLEAR_MOOD_EVENT, "bad_hair_day")

/datum/quirk/bald/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/head/wig/natural/W = new(get_turf(H))
	if (old_hair == "Bald")
		W.hairstyle = pick(GLOB.hairstyles_list - "Bald")
	else
		W.hairstyle = old_hair
	W.update_icon()
	var/list/slots = list (
		"head" = ITEM_SLOT_HEAD,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(W, slots , qdel_on_fail = TRUE)

///Checks if the headgear equipped is a wig and sets the mood event accordingly
/datum/quirk/bald/proc/equip_hat(mob/user, obj/item/hat)
	if(istype(hat, /obj/item/clothing/head/wig))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_hair_day", /datum/mood_event/confident_mane) //Our head is covered, but also by a wig so we're happy.
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "bad_hair_day") //Our head is covered

///Applies a bad moodlet for having an uncovered head
/datum/quirk/bald/proc/unequip_hat(mob/user, obj/item/clothing, force, newloc, no_move, invdrop, silent)
	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_hair_day", /datum/mood_event/bald)
