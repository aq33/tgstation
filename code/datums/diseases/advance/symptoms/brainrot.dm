/*
//////////////////////////////////////
Brainrot

	Bardzo zauważalna.
	Bardzo mało odporna.
	Zmniejsza stage speed.
	Nie zaraźliwa.
	Wysoki level.
BONUS
	Niszczy mózg.
//////////////////////////////////////
*/

/datum/symptom/brainrot

	name = "Brainrot"
	desc = "Symptom niszczący szare komórki, powodujący różne związane z tym powikłania."
	stealth = -2
	resistance = 1
	stage_speed = -1
	transmittable = -2
	level = 5
	severity = 2
	symptom_delay_min = 15
	symptom_delay_max = 30




/datum/symptom/brainrot/Activate(datum/disease/advance/A)
	if(!..())
		return
	switch(A.stage)
		if(2)
			if(prob(2))
				A.affected_mob.emote("blink")
			if(prob(2))
				A.affected_mob.emote("yawn")
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Nie czujesz się sobą.</span>")
			if(prob(2))
				A.affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1, 170)
				A.affected_mob.updatehealth()
		if(3)
			if(prob(2))
				A.affected_mob.emote("stare")
			if(prob(2))
				A.affected_mob.emote("drool")
			if(prob(10))
				A.affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2, 170)
				A.affected_mob.updatehealth()
				if(prob(2))
					to_chat(A.affected_mob, "<span class='danger'>Próbujesz przypomnieć sobie coś ważnego...ale nie możesz.</span>")

		if(4 || 5)
			if(prob(2))
				A.affected_mob.emote("stare")
			if(prob(2))
				A.affected_mob.emote("drool")
			if(prob(15))
				A.affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 170)
				A.affected_mob.updatehealth()
				if(prob(2))
					to_chat(A.affected_mob, "<span class='danger'>Niepokojące buczenie wypełnia twój umysł, pozbawiając cię myśli.</span>")
			if(prob(3))
				to_chat(A.affected_mob, "<span class='danger'>Tracisz przytomność...</span>")
				A.affected_mob.visible_message("<span class='warning'>[A.affected_mob] nagle upada!</span>", \
											"<span class='userdanger'>Nagle upadasz!</span>")
				A.affected_mob.Unconscious(rand(100,200))
				if(prob(1))
					A.affected_mob.emote("snore")
			if(prob(15))
				A.affected_mob.stuttering += 3

	return
