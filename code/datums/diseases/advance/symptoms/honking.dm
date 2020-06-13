/*
//////////////////////////////////////
Honking
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

/datum/symptom/honking

	name = "Honking"
	desc = "Wirus powoduje zmiany w mózgu, sprawiające, że chce się naśladować dźwięk klaksonu."
	stealth = -3
	resistance = 0
	stage_speed = -1
	transmittable = 2
	level = 8
	severity = 1
	base_message_chance = 100
	symptom_delay_min = 15
	symptom_delay_max = 30



/datum/symptom/honking/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1)
			if(prob(10))
				to_chat(M, "<span class='warning'>You feel a little silly.</span>")
		if(2)
			if(prob(10))
				to_chat(M, "<span class='warning'>You start seeing rainbows.</span>")
		if(3)
			if(prob(10))
				to_chat(M, "<span class='danger'>Your thoughts are interrupted by a loud <b>HONK!</b></span>")
		if(4)
			if(prob(5))
				M.say( pick( list("HONK!", "Honk!", "Honk.", "Honk?", "Honk!!", "Honk?!", "Honk...") ) , forced = "honking")
		if(5)
			if(prob(10))
				M.say( pick( list("HONK!", "Honk!", "Honk.", "Honk?", "Honk!!", "Honk?!", "Honk...") ) , forced = "honking")
