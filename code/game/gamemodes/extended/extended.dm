/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	report_type = "extended"
	false_report_weight = 0
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

	title_icon = "extended_white"

	var/secret = FALSE

/datum/game_mode/extended/secret
	name = "secret extended"
	config_tag ="secret_extended"
	report_type = "traitor"	//So this won't appear with traitor report
	secret = TRUE

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/generate_report()
	return "Istnieje możliwość że wasza stacja nie jest w zasięgu interesów Syndykatu i nic waszej stacji nie zagraża."

/datum/game_mode/extended/generate_station_goals()
	if(secret)
		return ..()
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()

/datum/game_mode/extended/send_intercept(report = 0)
	if(secret)
		return ..()
	priority_announce("Z pomocą naszego wydziału kontrwywiadu, Stacja [station_name()] jest wolna od zagrożeń. Wszystkie projekty konstrukcyjne zostały autoryzowane. Miłej zmiany załogo!", "Raport Ochrony", 'sound/ai/commandreport.ogg')
