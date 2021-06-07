GLOBAL_LIST(round_join_declarees)
	
/proc/check_tgs_declare_notify()
	if(LAZYLEN(GLOB.round_join_declarees))
		var/list/to_notify = list()
		var/current_players = SSticker.totalPlayers
		for(var/i in GLOB.round_join_declarees)
			if(LAZYLEN(GLOB.round_join_declarees[i]) == 0)
				continue
			var/list/declarees = GLOB.round_join_declarees[i].Copy()
			if(i > current_players + declarees.len)
				break
			current_players += declarees.len
			for(var/j in declarees)
				to_notify += declarees[j]
			declarees.len = 0
		
		if(to_notify.len > 0)
			send2irc("Notice", "[to_notify.Join(", ")] jest obecnie grających lub zadeklarowanych [current_players] graczy.")
	
/datum/tgs_chat_command/declare
	name = "declare"
	help_text = "!tgs declare N - gdzie N to liczba graczy przy których zostaniesz powiadomony by dołączyć"

/datum/tgs_chat_command/declare/Run(datum/tgs_chat_user/sender, params)
	if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
		return "[sender.mention], runda już się zakończyła!"
	var/treshold = text2num(params)
	if(treshold == null || treshold <= 0)
		return "Musisz podać minimalną liczbę graczy przy której dołączysz."
	if(treshold > 35)
		return "Maksymalna wartośc N to 35."
	if(GLOB.round_join_declarees == null)
		GLOB.round_join_declarees = list()
		GLOB.round_join_declarees.len = 35
	LAZYOR(GLOB.round_join_declarees[treshold], sender.mention)
	check_tgs_declare_notify()
	return "Powiadomię cię jezeli dołączy, lub zadeklaruje się przynajmniej [treshold] graczy."