/*
//////////////////////////////////////
Anxiety
	Bardzo zauważalna.
	Średnio odporna.
	Zwykły stage speed.
	Zaraźliwa.
	Wysoki level.
BONUS
	Postać panikuje.
	Powoduje wypluwanie motyli.
//////////////////////////////////////
*/

/datum/symptom/anxiety

	name = "Stany Lękowe"
	desc = "Symptom wywołujący strach. W późniejszym stadium pacjent wypluwa z siebie motyle."
	stealth = -2
	resistance = 2
	stage_speed = 1
	transmittable = 1
	level = 4
	severity = 1
	symptom_delay_min = 15
	symptom_delay_max = 30




/datum/symptom/anxiety/Activate(datum/disease/advance/A)
	if(!..())
		return
	switch(A.stage)
		if(2) //also changes say, see say.dm
			if(prob(5))
				to_chat(A.affected_mob, "<span class='notice'>You feel anxious.</span>")
		if(3)
			if(prob(10))
				to_chat(A.affected_mob, "<span class='notice'>Your stomach flutters.</span>")
			if(prob(5))
				to_chat(A.affected_mob, "<span class='notice'>You feel panicky.</span>")
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>You're overtaken with panic!</span>")
				A.affected_mob.confused += (rand(2,3))
		if(4 || 5)
			if(prob(10))
				to_chat(A.affected_mob, "<span class='danger'>You feel butterflies in your stomach.</span>")
			if(prob(5))
				A.affected_mob.visible_message("<span class='danger'>[A.affected_mob] stumbles around in a panic.</span>", \
												"<span class='userdanger'>You have a panic attack!</span>")
				A.affected_mob.confused += (rand(6,8))
				A.affected_mob.jitteriness += (rand(6,8))
			if(prob(2))
				A.affected_mob.visible_message("<span class='danger'>[A.affected_mob] coughs up butterflies!</span>", \
													"<span class='userdanger'>You cough up butterflies!</span>")
				new /mob/living/simple_animal/butterfly(A.affected_mob.loc)
				new /mob/living/simple_animal/butterfly(A.affected_mob.loc)
	return
