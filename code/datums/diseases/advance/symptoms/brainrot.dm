/*
//////////////////////////////////////
Brainrot
(OPIS NIECH KTOŚ ZROBI, KTO SIĘ NA TYM ZNA, ZOSTAWIAM TAKI JAK W HEADACHE)
	Noticable.
	Highly resistant.
	Increases stage speed.
	Not transmittable.
	Low Level.
BONUS
	Displays an annoying message!
	Should be used for buffing your disease.
//////////////////////////////////////
*/

/datum/symptom/brainrot

	name = "Brainrot"
	desc = "Symptom niszczący komórki mózgu, powodujący różne związane z tym powikłania."
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
				to_chat(A.affected_mob, "<span class='danger'>You don't feel like yourself.</span>")
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
					to_chat(A.affected_mob, "<span class='danger'>Your try to remember something important...but can't.</span>")

		if(4 || 5)
			if(prob(2))
				A.affected_mob.emote("stare")
			if(prob(2))
				A.affected_mob.emote("drool")
			if(prob(15))
				A.affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 170)
				A.affected_mob.updatehealth()
				if(prob(2))
					to_chat(A.affected_mob, "<span class='danger'>Strange buzzing fills your head, removing all thoughts.</span>")
			if(prob(3))
				to_chat(A.affected_mob, "<span class='danger'>You lose consciousness...</span>")
				A.affected_mob.visible_message("<span class='warning'>[A.affected_mob] suddenly collapses!</span>", \
											"<span class='userdanger'>You suddenly collapse!</span>")
				A.affected_mob.Unconscious(rand(100,200))
				if(prob(1))
					A.affected_mob.emote("snore")
			if(prob(15))
				A.affected_mob.stuttering += 3

	return
