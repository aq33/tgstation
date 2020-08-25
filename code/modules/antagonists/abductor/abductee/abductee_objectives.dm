/datum/objective/abductee
	completed = 1

/datum/objective/abductee/random

/datum/objective/abductee/random/New()
	explanation_text = pick(world.file2list("strings/abductee_objectives.txt"))

/datum/objective/abductee/steal
	explanation_text = "Ukradnij wszystkie"

/datum/objective/abductee/steal/New()
	var/target = pick(list("zwierzęta","światła","małpy","owoce","buty","kostki mydła", "bronie", "komputery", "organy"))
	explanation_text+=" [target]."

/datum/objective/abductee/paint
	explanation_text = "Stacja jest brzydka. Musisz ją pokolorować"

/datum/objective/abductee/paint/New()
	var/color = pick(list("na czerwono", "na niebiesko", "na zielono", "na zółto", "na pomarańczowo", "na fioletowo", "na czarno", "na tęczowo", "we krwi"))
	explanation_text+= " [color]!"

/datum/objective/abductee/speech
	explanation_text = "Twój mózg jest zepsuty... możesz komunikować się jedynie za pomocą"

/datum/objective/abductee/speech/New()
	var/style = pick(list("pantomimy", "rymowanek", "haiku", "wydłużonych metafor", "łamigłówek", "ekstremalnych terminów dosłownych", "efektów dźwiękowych", "żargonu wojskowego", "zdań trzywyrazowych"))
	explanation_text+= " [style]."

/datum/objective/abductee/capture
	explanation_text = "Schwytaj"

/datum/objective/abductee/capture/New()
	var/list/jobs = SSjob.occupations.Copy()
	for(var/X in jobs)
		var/datum/job/J = X
		if(J.current_positions < 1)
			jobs -= J
	if(jobs.len > 0)
		var/datum/job/target = pick(jobs)
		explanation_text += " jakiegoś [target.title]."
	else
		explanation_text += " kogoś."

/datum/objective/abductee/calling/New()
	var/mob/dead/D = pick(GLOB.dead_mob_list)
	if(D)
		explanation_text = "Wiesz, że [D] zginął. Przygotuj seans, by przywołać [D.p_them()] z zaświatów."

/datum/objective/abductee/forbiddennumber

/datum/objective/abductee/forbiddennumber/New()
	var/number = rand(2,10)
	explanation_text = "Ingoruj wszystko co występuje w ilości [number], to nie istnieje."
