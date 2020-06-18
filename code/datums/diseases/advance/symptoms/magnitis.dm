/*
//////////////////////////////////////
Magnitis
	Bardzo zauważalna.
	Średnio odporna.
	Wolny stage speed.
	Nie zaraźliwa.
	Średni Level.
BONUS
	Pacjent przyciąga metal.
//////////////////////////////////////
*/

/datum/symptom/magnitis

	name = "Magnitis"
	desc = "Symptom powodujący zakłócanie pola magnetycznego ciała nosiciela, tworząc z niego potężny magnes."
	stealth = -2
	resistance = 2
	stage_speed = -1
	transmittable = 0
	level = 3
	severity = 1
	symptom_delay_min = 15
	symptom_delay_max = 30



/datum/symptom/magnitis/Activate(datum/disease/advance/A)
	if(!..())
		return
	switch(A.stage)
		if(2)
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Czujesz jak lekki impuls przeszywa twoje ciało.</span>")
			if(prob(2))
				for(var/obj/M in orange(2,A.affected_mob))
					if(!M.anchored && (M.flags_1 & CONDUCT_1))
						step_towards(M,A.affected_mob)
				for(var/mob/living/silicon/S in orange(2,A.affected_mob))
					if(isAI(S))
						continue
					step_towards(S,A.affected_mob)
		if(3)
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Czujesz jak silniejszy impuls przeszywa twoje ciało.</span>")
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Czujesz, że pora się powygłupiać.</span>")
			if(prob(4))
				for(var/obj/M in orange(4,A.affected_mob))
					if(!M.anchored && (M.flags_1 & CONDUCT_1))
						var/i
						var/iter = rand(1,2)
						for(i=0,i<iter,i++)
							step_towards(M,A.affected_mob)
				for(var/mob/living/silicon/S in orange(4,A.affected_mob))
					if(isAI(S))
						continue
					var/i
					var/iter = rand(1,2)
					for(i=0,i<iter,i++)
						step_towards(S,A.affected_mob)
		if(4 || 5)
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Czujesz jak potężny impuls przeszywa twoje ciało.</span>")
			if(prob(2))
				to_chat(A.affected_mob, "<span class='danger'>Zastanawiasz się nad naturą cudów.</span>")
			if(prob(8))
				for(var/obj/M in orange(6,A.affected_mob))
					if(!M.anchored && (M.flags_1 & CONDUCT_1))
						var/i
						var/iter = rand(1,3)
						for(i=0,i<iter,i++)
							step_towards(M,A.affected_mob)
				for(var/mob/living/silicon/S in orange(6,A.affected_mob))
					if(isAI(S))
						continue
					var/i
					var/iter = rand(1,3)
					for(i=0,i<iter,i++)
						step_towards(S,A.affected_mob)
	return
