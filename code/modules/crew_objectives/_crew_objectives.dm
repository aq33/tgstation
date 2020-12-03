/datum/controller/subsystem/ticker/proc/give_crew_objective(var/datum/mind/crewMind)
	if(CONFIG_GET(flag/allow_crew_objectives) && crewMind?.current?.client.prefs.crew_objectives)
		generate_individual_objectives(crewMind)
	return

/datum/controller/subsystem/ticker/proc/generate_individual_objectives(var/datum/mind/crewMind)
	if(!(CONFIG_GET(flag/allow_crew_objectives)))
		return
	if(!crewMind)
		return
	if(!crewMind.current || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/list/validobjs = crewobjjobs["[ckey(crewMind.assigned_role)]"]
	if(!validobjs || !validobjs.len)
		return
	var/selectedObj = pick(validobjs)
	var/datum/objective/crew/newObjective = new selectedObj
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.crew_objectives += newObjective
	to_chat(crewMind, "<B>W ramach nanotrasenowskiego systemu przeciwfalowego, zostało ci przydzielone dodatkowe zadanie. Wykonanie zostanie sprawdzone pod koniec zmiany. <span class='warning'>Dopuszczenie się aktów zdrady w celu wykonania zadania może skutkować zerwaniem kontraktu.</span></B>")
	to_chat(crewMind, "<B>Your objective:</B> [newObjective.explanation_text]")
	crewMind.memory += "<br><B>Twój Opcjonalny Cel:</B> [newObjective.explanation_text]"

/datum/objective/crew
	var/jobs = ""
	explanation_text = "Jeśli to widzisz, krzycz na forum. Coś się zjebało."
