#define MAX_AMBI_LEN 4096

/datum/ambitions
	///Reasons of why would you act in antagonic ways
	var/narrative = ""
	///List of your objectives, in string form
	var/list/objectives = list()
	///Chosen intensity of your antagonism
	var/intensity = 0
	///Note in which you can optionally write out your vision/reasonings, useful if you want it to get reviewed
	var/note_to_admins = ""
	///Whether it was submitted or not
	var/submitted = FALSE
	///Whether we requested an admin review
	var/admin_review_requested = FALSE
	///Whether an admin approved our ambitions.
	var/admin_approval = FALSE
	///If we changed our ambitions after approval
	var/changed_after_approval = FALSE
	///Log of changes made to the ambitions
	var/list/log = list("Ambition Logs:")
	///The mind the ambitions belong to
	var/datum/mind/my_mind
	///The original name of our character
	var/owner_name
	///The last change requested by an admin, if a review was asked for
	var/last_requested_change

/datum/ambitions/New(datum/mind/M)
	my_mind = M
	if(my_mind.current.client)
		owner_name = key_name(my_mind.current.client, FALSE, TRUE)
	else
		owner_name = my_mind.current.real_name
	//Greet our antag player and give him a link to open ambitions!
	to_chat(my_mind.current, "<span class='boldwarning'>Twoja postać jest motywowana historią, a to oznacza, że musisz przedstawić swoje ambicje, zanim zaczniesz zachowywać się jak antagonista!</span>")
	to_chat(my_mind.current, "<span class='boldwarning'>Po wypełnieniu pól poniżej otrzymasz dostęp do specjalnych narzędzi które pomogą Ci w zrealizowaniu twoich celów.</span>")
	to_chat(my_mind.current, "<span class='boldwarning'>Kliknij <a href='?src=[REF(src)];pref=show_ambitions'>tutaj</a> by ustawić swoje ambicje lub uzyskaj do nich dostęp w każdej chwili w zakładce IC.</span>")

/datum/ambitions/proc/ShowPanel(mob/user, admin_view = FALSE)
	if(!user || !user.client)
		return
	var/list/dat = list("<center>")
	if(admin_view)
		dat += "<h3>Admin View Options:</h3>"
		dat += "<i>Down below you have [owner_name]'s ambitions.</i>"
		if(admin_review_requested)
			dat += "<BR><b>They have requested an admin review.</b>"
			if(admin_approval)
				dat += "<BR><b><font color='#00FF00'>...and it was granted!</font></b>"
				if(changed_after_approval)
					dat += "<BR><b><font color='#ffd500'>...however they changed their ambitions after that, see logs for more info.</font></b>"
		else
			dat += "<BR><b>They have NOT requested an admin review.</b>"
		dat += "<BR>"
		if(admin_review_requested && (!admin_approval || changed_after_approval))
			dat += "<a href='?src=[REF(src)];admin_pref=approve'>Approve</a> <a href='?src=[REF(src)];admin_pref=handle'>Handle</a> <a href='?src=[REF(src)];admin_pref=request_changes'>Request Changes</a>  <a href='?src=[REF(src)];admin_pref=discard_review'>Discard</a> -"
		dat += " <a href='?src=[REF(src)];admin_pref=logs'>Logs</a>"
		dat += "<HR>"

	dat += "<b>Rolą antagonisty jest napędzanie konfliktów, zapewnienie dynamiki rundzie oraz interesujących interakcji. <BR> Pamiętaj, że nie chodzi tu o wygraną czy przegraną, ale o stworzone historie. Gra opiera się na roleplayu.</b><BR><BR>"
	dat += "<i>W tym miejscu wpisz motywacje swojej postaci! Określ co i w jaki sposób chcesz osiągnąć w tej rundzie.</i>"
	dat += "<BR><i>Po wypełnieniu i potwierdzeniu swoich ambicji otrzymasz dostęp do specjalnych narzędzi które pomogą Ci w zrealizowaniu twoich celów.</i>"
	dat += "<BR><i>Jeśli nie możesz niczego wymyślić, użyj <b>szablonu</b>, a jeśli nie wiesz, czy twoje ambicje są odpowiednie lub czy nie są zbyt ekstremalne, <b>poproś administrację o ocenę</b>.</i>"
	dat += "<BR><i>Możesz nadal edytować motywacje po ich zatwierdzeniu.</i>"
	dat += "<BR><b><font color='#FF0000'>Jeżeli twoje motywacje są niedorzeczne, możesz otrzymać bana na rolę antagonisty.</font></b>"
	var/review_link = (is_proper_ambitions() && !admin_review_requested) ? "href='?src=[REF(src)];pref=request_review'" : "class='linkOff'"
	var/submit_link = "class='linkOff'"
	if(!is_proper_ambitions())
		dat += "<BR><center><b>Zanim będziesz mógł potwierdzić swoje ambicje, musisz wypełnić narrację, cele i intensywność.</b></center>"
	else if(admin_review_requested && !admin_approval)
		dat += "<BR><center><b>Wysłałeś prośbe do administratora o sprawdzenie. Ambicje zostaną automatycznie zatwierdzone po ocenie.</b></center>"
	else if(!submitted)
		submit_link = "href='?src=[REF(src)];pref=submit'"
	else
		dat += "<BR><center><b>Już zatwierdziłeś swoje ambicje, ale wciąż możesz je edytować.</b></center>"
	dat += "<center><a [submit_link]>Zatwierdź</a> <a href='?src=[REF(src)];pref=template'>Wybierz szablon</a> <a [review_link]>Poproś administrację o ocenę (opcjonalne)</a></center>"
	dat += "<HR>"
	if(changed_after_approval)
		dat += "<BR><b><font color='#ffd500'>Niektóre pozycje zostały zmienione po ocenie administratora.</font></b>"
	if(last_requested_change)
		dat += "<BR><b><font color='#ffd500'>Proponowane zmiany:</font></b>"
		dat += "<BR><b><font color='#ffd500'>[last_requested_change]</font></b>"
		dat += "<BR><a href='?src=[REF(src)];pref=requested_done'>Poinformuj administratora o zmianach!</a></b>"
	dat += "<h3>Narracja:</h3>"
	dat += "<i>Tutaj ustalasz swoją narrację. To przyczyna dla której wykonujesz nikczemne uczynki. Możliwe że potrzebujesz pieniędzy z przyczyn osobistych, mogłeś zostać zatrudniony do wykonania brudnej roboty, a może chcesz po prostu zniszczyć wszystkich, którzy chcą ci zaszczepić implanty marki Bill Gates.</i>"
	dat += "<BR><table align='center'; width='100%'; style='background-color:#13171C'><tr><td><center>"
	if(narrative == "")
		dat += "<font color='#CCCCFF'><b>Ustaw swój scenariusz!</b></font>"
	else
		dat += narrative
	dat += "</center><center><a href='?src=[REF(src)];pref=set_narrative'>Ustaw scenariusz</a></center>"
	dat += "</td></tr></table>"
	dat += "<BR>"
	dat += "<h3>Cele:</h3>"
	dat += "<i>Tutaj dodajesz swoje cele. Pomyśl o nich jak o krokach milowych dla swojej niecnej historii.</i>"
	dat += "<BR><table align='center'; width='100%'; style='background-color:#13171C'>"
	if(length(objectives))
		var/even = TRUE
		var/index = 0
		for(var/objectiv in objectives)
			index++
			even = !even
			var/bg_color = "#23273C"
			if(even)
				bg_color = "#19222C"
			dat += "<tr style='background-color:[bg_color]'><td><center> * [objectiv] <a href='?src=[REF(src)];pref=edit_objective;index=[index]'>Edytuj</a> <a href='?src=[REF(src)];pref=remove_objective;index=[index]'>Usuń</a></center></td></tr>"
	else
		dat += "<tr><td><center><font color='#CCCCFF'><b>Dodaj przynajmniej jeden cel!</b></font></center></td></tr>"
	dat += "<tr><td><center><a href='?src=[REF(src)];pref=add_objective'>Dodaj cel</a></center></td></tr>"
	dat += "</table>"
	dat += "<BR>"
	dat += "<h3>Intensywność:</h3>"
	dat += "<i>Ustal przewidywaną intensywność swoich ambicji. To pomoże administratorom przewidzieć jak chaotyczna może być runda. Ustaw ją adekwatnie.</i>"
	if(intensity == 0)
		dat += "<BR><center><font color='#CCCCFF'><b>Ustal intensywność swoich ambicji!</b></font></center>"
	dat += "<table>"
	dat += "<tr><td width=15%></td><td width=85%></td></tr>"
	for(var/i in 1 to 5)
		var/current_spice
		switch(i)
			if(1)
				current_spice = AMBITION_INTENSITY_STEALTH
			if(2)
				current_spice = AMBITION_INTENSITY_MILD
			if(3)
				current_spice = AMBITION_INTENSITY_MEDIUM
			if(4)
				current_spice = AMBITION_INTENSITY_SEVERE
			if(5)
				current_spice = AMBITION_INTENSITY_EXTREME
		var/active = (current_spice == intensity)
		var/spice_link = active ? "class='linkOn'" : "href='?src=[REF(src)];pref=spice;amount=[current_spice]'"
		var/spice_name
		var/spice_desc
		var/spice_color
		switch(current_spice)
			if(AMBITION_INTENSITY_STEALTH)
				spice_name = "Skryty"
				spice_desc = "Niewidoczny dla większości graczy, akcje dotykają tylko małego obszaru/grupy graczy."
				spice_color = "#a6a6a6"
			if(AMBITION_INTENSITY_MILD)
				spice_name = "Łagodny"
				spice_desc = "Rabowanie, kradzież lub wandalizm."
				spice_color = "#fcdf03"
			if(AMBITION_INTENSITY_MEDIUM)
				spice_name = "Umiarkowany"
				spice_desc = "Napaść, pozbawienie życia, ostry wandalizm, czy zamieszki."
				spice_color = "#fcb103"
			if(AMBITION_INTENSITY_SEVERE)
				spice_name = "Poważny"
				spice_desc = "Morderstwo, poważne napady i ostre naruszenia prawa."
				spice_color = "#fc8c03"
			if(AMBITION_INTENSITY_EXTREME)
				spice_name = "Ekstremalny"
				spice_desc = "Zamachy, otwarta walka i terroryzm."
				spice_color = "#fc5603"
		dat += "<tr style='background-color:[spice_color]'><td><a [spice_link]>[spice_name]</a></td><td><center><i><font color='#000000'><b>[spice_desc]</b></font></i></center></td></tr>"
	dat += "</table>"
	dat += "<HR>"
	dat += "<h3>Notatka dla administracji (opcjonalne):</h3>"
	dat += "<i>Jeżeli chcesz poprosić o ocenę administratora, możesz wypełnić pole poniżej z opisem doświadczeń jakie chcesz zapewnić stacji.</i>"
	dat += "<BR><table align='center'; width='100%'; style='background-color:#13171C'><tr><td><center>"
	dat += note_to_admins
	dat += "</center><BR><center><a href='?src=[REF(src)];pref=edit_admin_note'>Edytuj swoją notatkę dla administracji</a></center>"
	dat += "</td></tr></table>"

	winshow(usr, "ambition_window", TRUE)
	var/datum/browser/popup = new(usr, "ambition_window", "<div align='center'>Ambicje</div>", 950, 750)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(usr, "ambition_window", src)

/datum/ambitions/proc/ShowTemplatePanel(mob/user)
	if(!user || !user.client)
		return
	var/list/dat =  list("<center>")
	dat += "<i>Wzory przedstawione tutaj to głównie pomysły dla twojego stylu gry, możesz je dowolnie edytować tak by odpowiadały twojej postaci.</i>"
	dat += "<BR><i>Nie wszystkie z nich mają wypełnione wszystkie pola, większość z nich jedynie 'intensywność'. To od ciebie zależy jaką wybierzesz narrację.</i>"
	dat += "<BR><i>Miejmy nadzieję, że to pomoże ci znaleźć ciekawe pomysły na swoje nikczemne czyny w przyszłości!</i>"
	var/list/available_templates = list()
	for(var/name in GLOB.ambitions_templates)
		var/datum/ambition_template/AT = GLOB.ambitions_templates[name]
		if(AT.antag_whitelist)
			var/has_required = FALSE
			for(var/datum/antagonist/A in my_mind.antag_datums)
				if(A.name in AT.antag_whitelist)
					has_required = TRUE
					break
			if(!has_required)
				continue
		if(AT.job_whitelist)
			if(!(my_mind.assigned_role in AT.job_whitelist))
				continue
		available_templates += AT
	for(var/temp in available_templates)
		var/datum/ambition_template/AT = temp
		dat += "<table align='center'; width='100%'; style='background-color:#13171C'>"
		dat += "<tr><td><b>[AT.name]</b>  <a href='?src=[REF(src)];temp_pref=choose;name=[AT.name]'>Wybierz</a></td></tr>"
		if(AT.narrative != "")
			dat += "<tr style='background-color:#21526b'><td>Scenariusz:</td></tr>"
			dat += "<tr><td>[AT.narrative]</td></tr>"
		if(length(AT.objectives))
			dat += "<tr style='background-color:#21526b'><td>Cele:</td></tr>"
			var/even = FALSE
			for(var/objec in AT.objectives)
				even = !even
				var/bgc = even ? "#13171C" : "#18211C"
				dat += "<tr style='background-color:[bgc]'><td>* [objec]</td></tr>"
		if(AT.intensity)
			var/string = "ERROR"
			switch(AT.intensity)
				if(AMBITION_INTENSITY_STEALTH)
					string = "Skryty"
				if(AMBITION_INTENSITY_MILD)
					string = "Łagodny"
				if(AMBITION_INTENSITY_MEDIUM)
					string = "Umiarkowany"
				if(AMBITION_INTENSITY_SEVERE)
					string = "Poważny"
				if(AMBITION_INTENSITY_EXTREME)
					string = "Ekstremalny"
			dat += "<tr style='background-color:#21526b'><td>Intensywność: [string]</td></tr>"
		if(length(AT.tips))
			dat += "<tr style='background-color:#21526b'><td>Porady:</td></tr>"
			var/even = FALSE
			for(var/tip in AT.tips)
				even = !even
				var/bgc = even ? "#13171C" : "#23272C"
				dat += "<tr style='background-color:[bgc]'><td>[tip]</td></tr>"
		dat += "</table>"
		dat += "<BR>"

	winshow(usr, "ambition_template_window", TRUE)
	var/datum/browser/popup = new(usr, "ambition_template_window", "<div align='center'>Szablony Ambicji</div>", 950, 750)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(usr, "ambition_template_window", src)

/datum/ambitions/Topic(href, href_list)
	if(href_list["temp_pref"])
		var/temp_name = href_list["name"]
		var/datum/ambition_template/AT = GLOB.ambitions_templates[temp_name]
		if(AT)
			narrative = AT.narrative
			objectives = AT.objectives.Copy()
			if(submitted)
				GLOB.total_intensity -= intensity
				if(intensity)
					GLOB.intensity_counts["[intensity]"] -= 1
				GLOB.total_intensity += AT.intensity
				if(AT.intensity)
					GLOB.intensity_counts["[AT.intensity]"] += 1
			intensity = AT.intensity
			log_action("TEMPLATE: Chosen the [AT.name] template")
		usr << browse(null, "window=ambition_template_window")
		ShowPanel(usr)
	if(href_list["admin_pref"])
		switch(href_list["admin_pref"])
			if("handle")
				var/last_ckey = GLOB.ambitions_to_review[src]
				if(last_ckey && last_ckey != usr.ckey)
					var/action = alert(usr, "[last_ckey] zajmuje się już recenzją! Czy chcesz się nią zająć mimo to?", "", "Yes", "No")
					if(action && !(action == "Yes"))
						return
				GLOB.ambitions_to_review[src] = usr.ckey
				message_admins("<span class='adminhelp'>[usr.ckey] is handling [owner_name]'s ambitions. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
				to_chat(my_mind.current, "<span class='boldnotice'>[usr.ckey] zajmuje się twoimi ambicjami.</span>")
			if("request_changes")
				var/changes_wanted = input(usr, "Proponowane zmiany:", "Ambicje")  as message|null
				if(changes_wanted)
					last_requested_change = changes_wanted
					to_chat(my_mind.current, "<span class='boldwarning'>[usr.ckey] zażądał zmian twoich ambicji: [changes_wanted]. (<a href='?src=[REF(src)];pref=show_ambitions'>VIEW</a>)</span>")
					message_admins("<span class='adminhelp'>[usr.ckey] requested changes in [ADMIN_TPMONTY(my_mind.current)]'s ambitions. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
			if("discard_review")
				var/action = alert(usr, "Are you sure you want to discard this review request (Use request changes if you want it changed instead)?", "", "Yes", "No")
				if(action && action == "Yes" && admin_review_requested)
					admin_review_requested = FALSE
					admin_approval = FALSE
					changed_after_approval = FALSE
					last_requested_change = null
					GLOB.ambitions_to_review -= src
					to_chat(my_mind.current, "<span class='warning'><b>Twoje żądanie recenzji ambicji zostało odrzucone przez [usr.ckey].</b></span>")
					message_admins("<span class='adminhelp'>[ADMIN_TPMONTY(my_mind.current)]'s ambitions review request was DISCARDED by [usr.ckey]. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
			if("approve")
				admin_approval = TRUE
				changed_after_approval = FALSE
				last_requested_change = null
				GLOB.ambitions_to_review -= src
				log_action("APPROVED: Got an approval from [usr.ckey]", FALSE)
				to_chat(my_mind.current, "<span class='nicegreen'><b>Twoje ambicje zostały zaakceptowane przez [usr.ckey].</b></span>")
				message_admins("<span class='nicegreen'>[ADMIN_TPMONTY(my_mind.current)]'s ambitions were approved by [usr.ckey]. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
				submit()
			if("logs")
				var/datum/browser/popup = new(usr, "Ambition logging", "Ambition logs", 500, 200)
				popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "Ambition logs", log.Join("<BR>")))
				popup.open()
				return

		ShowPanel(usr, TRUE)
		return TRUE

	if(href_list["pref"])
		switch(href_list["pref"])
			if("template")
				ShowTemplatePanel(usr)
				return
			if("requested_done")
				to_chat(src, "<span class='nicegreen'><b>Poinformowałeś administrację o dokonanych zmianach.</b></span>")
				message_admins("<span class='adminhelp'>[ADMIN_TPMONTY(usr)] notifies that he has finished the requested changes in his ambitions. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
			if("request_review")
				admin_review_requested = TRUE
				GLOB.ambitions_to_review[src] = 0
				log_action("--Requested an admin review--", FALSE)
				message_admins("<span class='adminhelp'>[ADMIN_TPMONTY(usr)] has requested a review of their ambitions. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
			if("submit")
				submit()
				log_action("SUBMIT: Submitted their ambitions", FALSE)
				message_admins("<span class='adminhelp'>[ADMIN_TPMONTY(usr)] has submitted their ambitions. (<a href='?src=[REF(src)];admin_pref=show_ambitions'>VIEW</a>)</span>")
			if("spice")
				var/new_intensity = text2num(href_list["amount"])
				if(intensity == new_intensity)
					return
				var/string = "ERROR"
				switch(intensity)
					if(AMBITION_INTENSITY_STEALTH)
						string = "Stealth"
					if(AMBITION_INTENSITY_MILD)
						string = "Mild"
					if(AMBITION_INTENSITY_MEDIUM)
						string = "Medium"
					if(AMBITION_INTENSITY_SEVERE)
						string = "Severe"
					if(AMBITION_INTENSITY_EXTREME)
						string = "Extreme"
				log_action("INTENSITY: set to [string]")
				if(submitted)
					GLOB.total_intensity -= intensity
					if(intensity)
						GLOB.intensity_counts["[intensity]"] -= 1
					GLOB.total_intensity += new_intensity
					if(new_intensity)
						GLOB.intensity_counts["[new_intensity]"] += 1
				intensity = new_intensity
			if("edit_admin_note")
				var/msg = input(usr, "Edytuj swoją notatkę dla administracji!", "Notatka dla administracji", note_to_admins) as message|null
				if(msg)
					note_to_admins = strip_html_simple(msg, MAX_AMBI_LEN, TRUE)
					log_action("NOTE: [note_to_admins]", FALSE)
			if("set_narrative")
				var/msg = input(usr, "Ustaw swoją narrację!", "Narracja", narrative) as message|null
				if(msg)
					narrative = strip_html_simple(msg, MAX_AMBI_LEN, TRUE)
					log_action("NARRATIVE - change: [narrative]")
			if("remove_objective")
				var/index = text2num(href_list["index"])
				if(length(objectives) < index)
					return
				log_action("OBJ - removed: [objectives[index]]")
				objectives.Remove(objectives[index])
			if("edit_objective")
				var/index = text2num(href_list["index"])
				if(length(objectives) < index)
					return
				var/old_obj = objectives[index]
				var/msg = input(usr, "Edytuj cel:", "Cele", old_obj) as message|null
				if(msg)
					if(length(objectives) < index)
						return
					objectives[index] = strip_html_simple(msg, MAX_AMBI_LEN, TRUE)
					log_action("OBJ - edit: [old_obj] TO-> [objectives[index]]")
			if("add_objective")
				var/msg = input(usr, "Dodaj cel:", "Cele", "") as message|null
				if(msg)
					var/new_obj = strip_html_simple(msg, MAX_AMBI_LEN, TRUE)
					objectives += new_obj
					log_action("OBJ - add: [new_obj]")

		ShowPanel(usr)
		return TRUE

/datum/ambitions/proc/log_action(text_content, clears_approval = TRUE)
	if(admin_approval && clears_approval && !changed_after_approval)
		changed_after_approval = TRUE
		log += "[time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")] CHANGED AFTER APPROVAL:"
	log += "[time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")] [text_content]"

/datum/ambitions/proc/is_proper_ambitions()
	if(intensity == 0 || length(objectives) == 0 || narrative == "")
		return FALSE
	return TRUE

/datum/ambitions/proc/submit()
	if(submitted)
		return
	submitted = TRUE
	my_mind.ambition_submit()
	GLOB.total_intensity += intensity
	GLOB.intensity_counts["[intensity]"] += 1

/mob/proc/view_ambitions()
	set name = "Pokaż ambicje"
	set category = "IC"
	set desc = "Pokaż i edytuj ambicje swojej postaci."
	if(!mind)
		return
	if(!mind.my_ambitions)
		return
	mind.my_ambitions.ShowPanel(src)

/datum/ambitions/proc/Action(action)
	ShowPanel(usr, TRUE)

#undef AMBITION_INTENSITY_MILD
#undef AMBITION_INTENSITY_MEDIUM
#undef AMBITION_INTENSITY_SEVERE
#undef AMBITION_INTENSITY_EXTREME

#undef MAX_AMBI_LEN