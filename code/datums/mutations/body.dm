//These mutations change your overall "form" somehow, like size

//Epilepsy gives a very small chance to have a seizure every life tick, knocking you unconscious.
/datum/mutation/human/epilepsy
	name = "Padaczka"
	desc = "Defekt genetyczny, który powoduje napady padaczki."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>Łapie cię ból głowy.</span>"
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/epilepsy/on_life()
	if(prob(1 * GET_MUTATION_SYNCHRONIZER(src)) && owner.stat == CONSCIOUS)
		owner.visible_message("<span class='danger'>[owner] dostaje ataku padaczki!</span>", "<span class='userdanger'>Dostajesz ataku padaczki!</span>")
		owner.Unconscious(200 * GET_MUTATION_POWER(src))
		owner.Jitter(1000 * GET_MUTATION_POWER(src))
		SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "epilepsy", /datum/mood_event/epilepsy)
		addtimer(CALLBACK(src, .proc/jitter_less), 90)

/datum/mutation/human/epilepsy/proc/jitter_less()
	if(owner)
		owner.jitteriness = 10


//Unstable DNA induces random mutations!
/datum/mutation/human/bad_dna
	name = "Niestabilne DNA"
	desc = "Dziwna mutacja, która powoduje niekontrolowane mutacje."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>Czujesz się dziwnie.</span>"
	locked = TRUE

/datum/mutation/human/bad_dna/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	to_chat(owner, text_gain_indication)
	var/mob/new_mob
	if(prob(95))
		if(prob(50))
			new_mob = owner.easy_randmut(NEGATIVE + MINOR_NEGATIVE)
		else
			new_mob = owner.randmuti()
	else
		new_mob = owner.easy_randmut(POSITIVE)
	if(new_mob && ismob(new_mob))
		owner = new_mob
	. = owner
	on_losing(owner)


//Cough gives you a chronic cough that causes you to drop items.
/datum/mutation/human/cough
	name = "Kaszel"
	desc = "Chroniczny kaszel."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>Zaczynasz kaszleć.</span>"
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/cough/on_life()
	if(prob(5 * GET_MUTATION_SYNCHRONIZER(src)) && owner.stat == CONSCIOUS)
		owner.drop_all_held_items()
		owner.emote("cough")
		if(GET_MUTATION_POWER(src) > 1)
			var/cough_range = GET_MUTATION_POWER(src) * 4
			var/turf/target = get_ranged_target_turf(owner, turn(owner.dir, 180), cough_range)
			owner.throw_at(target, cough_range, GET_MUTATION_POWER(src))

/datum/mutation/human/paranoia
	name = "Paranoja"
	desc = "Badanego łatwo przestraszyć, czasem występują halucynacje."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>Słyszysz echo krzyków...</span>"
	text_lose_indication = "<span class'notice'>Krzyki ustępują.</span>"

/datum/mutation/human/paranoia/on_life()
	if(prob(5) && owner.stat == CONSCIOUS)
		owner.emote("scream")
		if(prob(25))
			owner.hallucination += 20

//Dwarfism shrinks your body and lets you pass tables.
/datum/mutation/human/dwarfism
	name = "karłowatość"
	desc = "Mutacja uznawana za przyczyne karłowatości."
	quality = POSITIVE
	difficulty = 16
	instability = 5
	conflicts = list(GIGANTISM)
	locked = TRUE    // Default intert species for now, so locked from regular pool.

/datum/mutation/human/dwarfism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.transform = owner.transform.Scale(1, 0.8)
	passtable_on(owner, GENETIC_MUTATION)
	owner.visible_message("<span class='danger'>[owner] naglę się zmiejsza!</span>", "<span class='notice'>Wszystko dookoła ciebie naglę wydaję się większe..</span>")

/datum/mutation/human/dwarfism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.transform = owner.transform.Scale(1, 1.25)
	passtable_off(owner, GENETIC_MUTATION)
	owner.visible_message("<span class='danger'>[owner] naglę się zwiększa!</span>", "<span class='notice'>Wszystko dookoła ciebie naglę wydaję się mniejsze..</span>")


//Clumsiness has a very large amount of small drawbacks depending on item.
/datum/mutation/human/clumsy
	name = "Nieporadność"
	desc = "Genom, który utrudnia funkcjonowanie mózgu robiąc z badanego niezdarę. Honk"
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>Twoja głowa robi się  lekka.</span>"

/datum/mutation/human/clumsy/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)

/datum/mutation/human/clumsy/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_CLUMSY, GENETIC_MUTATION)


//Tourettes causes you to randomly stand in place and shout.
/datum/mutation/human/tourettes
	name = "Zespół Touretta"
	desc = "Chroniczne drgawki, które zmuszają do przeklinania." //JD
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>Dostajesz drgawek.</span>"
	synchronizer_coeff = 1

/datum/mutation/human/tourettes/on_life()
	if(prob(10 * GET_MUTATION_SYNCHRONIZER(src)) && owner.stat == CONSCIOUS && !owner.IsStun())
		owner.Stun(20)
		switch(rand(1, 3))
			if(1)
				owner.emote("twitch")
			if(2 to 3)
				owner.say("[prob(50) ? ";" : ""][pick("GÓWNO", "KUTAS", "KURWA", "DEBILU", "JEBAĆ PIS", "GŁOSUJE NA PIS", "PIZDA")]", forced="Zespół Touretta") //może nie lubi pis-u ale na niego głosuje, kto wie
		var/x_offset_old = owner.pixel_x
		var/y_offset_old = owner.pixel_y
		var/x_offset = owner.pixel_x + rand(-2,2)
		var/y_offset = owner.pixel_y + rand(-1,1)
		animate(owner, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(owner, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)


//Deafness makes you deaf.
/datum/mutation/human/deaf
	name = "Głuchota"
	desc = "Genom powodujący całkowitą głuchote."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>Wszystko dookoła ucichło.</span>"

/datum/mutation/human/deaf/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)

/datum/mutation/human/deaf/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_DEAF, GENETIC_MUTATION)


//Monified turns you into a monkey.
/datum/mutation/human/race
	name = "Zamieniony w małpe" //nie ma na to słowa- zmałpowany?
	desc = "Dziwny genom, naukowcy uważają go za skutek ewolucji."
	quality = NEGATIVE
	time_coeff = 2
	locked = TRUE //Species specific, keep out of actual gene pool

/datum/mutation/human/race/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	. = owner.monkeyize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)

/datum/mutation/human/race/on_losing(mob/living/carbon/monkey/owner)
	if(owner && istype(owner) && owner.stat != DEAD && (owner.dna.mutations.Remove(src)))
		. = owner.humanize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)

/datum/mutation/human/glow
	name = "Świecący"
	desc = "Twoja osoba emituje światło o losowym kolorze i natężeniu."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Twoja skóra zaczyna świecić.</span>"
	instability = 5
	var/obj/effect/dummy/luminescent_glow/glowth //shamelessly copied from luminescents
	var/glow = 2.5
	var/range = 2.5
	power_coeff = 1
	conflicts = list(/datum/mutation/human/glow/anti)

/datum/mutation/human/glow/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	glowth = new(owner)
	modify()

/datum/mutation/human/glow/modify()
	if(!glowth)
		return
	var/power = GET_MUTATION_POWER(src)
	glowth.set_light(range * power, glow * power, "#[dna.features["mcolor"]]")

/datum/mutation/human/glow/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	QDEL_NULL(glowth)

/datum/mutation/human/glow/anti
	name = "Anty-Świecący" //Zaciemniejący?
	desc = "Twoja skóra pochłania światło dookoła, tworząc ciemność."
	text_gain_indication = "<span class='notice'>Światło dookoła ciebie zaczyna znikać.</span>"
	glow = -3.5 //Slightly stronger, since negating light tends to be harder than making it.
	conflicts = list(/datum/mutation/human/glow)
	locked = TRUE

/datum/mutation/human/strong
	name = "Silny" //mariusz pudzian
	desc = "Mięśnie badanego zauważalnie rosną."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Czujesz się silny.</span>"
	difficulty = 16

/datum/mutation/human/insulated
	name = "Izolowany"
	desc = "Osoba nie przewodzi prądu."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Twoje palce drętwieją.</span>"
	text_lose_indication = "<span class='notice'>Znowu czujesz swoje palce.</span>"
	difficulty = 16
	instability = 25

/datum/mutation/human/insulated/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, "genetics")

/datum/mutation/human/insulated/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, "genetics")

/datum/mutation/human/fire
	name = "Ognisty pot"
	desc = "Badaczy czasem zapala się, lecz jest bardziej odporny na poparzenia."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>Czujesz się rozpalony.</span>" //xD
	text_lose_indication = "<span class'notice'>Czujesz się chłodniej.</span>"
	difficulty = 14
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/human/fire/on_life()
	if(prob((1+(100-dna.stability)/10)) * GET_MUTATION_SYNCHRONIZER(src))
		owner.adjust_fire_stacks(2 * GET_MUTATION_POWER(src))
		owner.IgniteMob()

/datum/mutation/human/fire/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 0.5

/datum/mutation/human/fire/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.physiology.burn_mod *= 2

/datum/mutation/human/badblink
	name = "Niestabilność przestrzeni"
	desc = "Mutacja badanego ma bardzo słabe połączenie do czwartej gęstości i może do niej wejść. Często powoduje zawroty głowy."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>Przestrzeń dookoła ciebie wykręca się.</span>"
	text_lose_indication = "<span class'notice'>Przestrzeń dookoła ciebie wraca do trzeciego wymiaru.</span>"
	difficulty = 18//high so it's hard to unlock and abuse
	instability = 10
	synchronizer_coeff = 1
	energy_coeff = 1
	power_coeff = 1
	var/warpchance = 0

/datum/mutation/human/badblink/on_life()
	if(prob(warpchance))
		var/warpmessage = pick(
		"<span class='warning'>Z zadziwiającym przewrotem 420 stopni, [owner] rozpływa się w powietrzu.</span>",
		"<span class='warning'>[owner] robi przewrót w tył do innego wymiaru. Wygląda to boleśnie.</span>",
		"<span class='warning'>[owner] robi skok w lewo, krok w prawo i wchodzi w czwartą gęstość.</span>",
		"<span class='warning'>tłów [owner]a przerwaca się na lewą strone wychodząc z tego wymiaru, zabierając [owner]a z tłowiem.</span>",
		"<span class='warning'>W jedym momencie widzisz [owner]a. A w następnym, już nie.</span>")
		owner.visible_message(warpmessage, "<span class='userdanger'>Czujesz zawroty głowy i spadanie do innego wymiaru!</span>")
		var/warpdistance = rand(10,15) * GET_MUTATION_POWER(src)
		do_teleport(owner, get_turf(owner), warpdistance, channel = TELEPORT_CHANNEL_FREE)
		owner.adjust_disgust(GET_MUTATION_SYNCHRONIZER(src) * (warpchance * warpdistance))
		warpchance = 0
		owner.visible_message("<span class='danger'>[owner] pojawia się z nikąd!</span>")
	else
		warpchance += 0.25 * GET_MUTATION_ENERGY(src)

/datum/mutation/human/acidflesh
	name = "Kwaśna skóra"
	desc = "U badanego kwas zbiera się pod skórą, wypalając ją z środka. To jest często zabójcze."
	quality = NEGATIVE
	text_gain_indication = "<span class='userdanger'>Okropne uczucie palenia występuje pod twoją skórą, twoje tkanki zamieniają się w kwas!</span>"
	text_lose_indication = "<span class'notice'>Uczucie palenia ustępuje, twoje tkanki wracają do normalności.</span>"
	difficulty = 18//high so it's hard to unlock and use on others
	var/msgcooldown = 0

/datum/mutation/human/acidflesh/on_life()
	if(prob(25))
		if(world.time > msgcooldown)
			to_chat(owner, "<span class='danger'>Kwas pod twoją skórą bombelkuje...</span>")
			msgcooldown = world.time + 200
		if(prob(15))
			owner.acid_act(rand(30,50), 10)
			owner.visible_message("<span class='warning'>kwas pod skórą [owner]a wybucha.</span>", "<span class='userdanger'>Twoja skóra tryska kwasam, To pali!</span>")
			playsound(owner,'sound/weapons/sear.ogg', 50, 1)

/datum/mutation/human/gigantism
	name = "Gigantyzm"//negative version of dwarfism
	desc = "Komórki badanego powiększają się."
	quality = MINOR_NEGATIVE
	difficulty = 12
	conflicts = list(DWARFISM)

/datum/mutation/human/gigantism/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.resize = 1.25
	owner.update_transform()
	owner.visible_message("<span class='danger'>[owner] nagle rośnie!</span>", "<span class='notice'>Wszystko dookoła ciebie maleje..</span>")

/datum/mutation/human/gigantism/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.resize = 0.8
	owner.update_transform()
	owner.visible_message("<span class='danger'>[owner] nagle maleje!</span>", "<span class='notice'>Wszystko dookoła ciebie rośnie..</span>")

/datum/mutation/human/spastic
	name = "Paralityk"
	desc = "Badany cierpi z drgawek mięśni."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>Zaczynasz wzdrygiwać się.</span>"
	text_lose_indication = "<span class'notice'>Twoje drgania ustępują.</span>"
	difficulty = 16

/datum/mutation/human/spastic/on_acquiring()
	if(..())
		return
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)

/datum/mutation/human/spastic/on_losing()
	if(..())
		return
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)

/datum/mutation/human/extrastun
	name = "Dwie lewe nogi"
	desc = "Mutacja która zamienia prawą noge na lewą co powoduje podnoszenię się znacznie trudniejszę."
	quality = NEGATIVE
	text_gain_indication = "<span class='warning'>Twoja prawa noga... jest lewa.</span>"
	text_lose_indication = "<span class'notice'>Twoja prawa noga jest spowrotem prawa.</span>"
	difficulty = 16
	var/stun_cooldown = 0

/datum/mutation/human/extrastun/on_life()
	if(world.time > stun_cooldown)
		if(owner.AmountKnockdown() || owner.AmountStun())
			owner.SetKnockdown(owner.AmountKnockdown()*2)
			owner.SetStun(owner.AmountStun()*2)
			owner.visible_message("<span class='danger'>[owner] próboje się podnieść ale się przewraca!</span>", "<span class='userdanger'>Przewracasz się sam na sobie!</span>")
			stun_cooldown = world.time + 300
