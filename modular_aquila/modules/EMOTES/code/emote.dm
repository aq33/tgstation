/datum/keybinding/emote
	category = CATEGORY_EMOTE
	weight = WEIGHT_EMOTE
	var/emote_key

/datum/keybinding/emote/proc/link_to_emote(datum/emote/faketype)
	key = "Unbound"
	emote_key = initial(faketype.key)
	name = initial(faketype.key)
	full_name = capitalize(initial(faketype.key))
	description = "Do the emote '*[emote_key]'"

/datum/keybinding/emote/down(client/user)
	. = ..()
	return user.mob.emote(emote_key, intentional=TRUE)

/datum/emote/flip/check_cooldown(mob/user, intentional)
	. = ..()
	if(.)
		return
	if(!can_run_emote(user, intentional=intentional))
		return
	if(isliving(user))
		var/mob/living/flippy_mcgee = user
		if(prob(20))
			flippy_mcgee.Knockdown(1 SECONDS)
			flippy_mcgee.visible_message(
	/* AQ EDIT	"<span class='notice'>[flippy_mcgee] attempts to do a flip and falls over, what a doofus!</span>",
				"<span class='notice'>You attempt to do a flip while still off balance from the last flip and fall down!</span>"
				*/
				"<span class='notice'>[flippy_mcgee] próbuje zrobić salto ale upada!</span>",
				"<span class='notice'>Próbujesz ponownie zrobić salto ale tracisz równowagę i upadasz!</span>"
			)
			if(prob(50))
				flippy_mcgee.adjustBruteLoss(1)
		else
			flippy_mcgee.visible_message(
	/* AQ EDIT	"<span class='notice'>[flippy_mcgee] stumbles a bit after their flip.</span>",
				"<span class='notice'>You stumble a bit from still being off balance from your last flip.</span>"
				*/
				"<span class='notice'>[flippy_mcgee] robi salto i potyka się.</span>",
				"<span class='notice'>Tracisz równowagę i potykasz się.</span>"
			)

/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE)
	act = lowertext(act)
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + length(act[custom_param]))
		act = copytext(act, 1, custom_param)


	var/list/key_emotes = GLOB.emote_list[act]

	if(!length(key_emotes))
		if(intentional)
			to_chat(src, "<span class='notice'>'[act]' emote does not exist. Say *help for a list.</span>")
		return FALSE
	var/silenced = FALSE
	for(var/datum/emote/P in key_emotes)
		if(!P.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(P.run_emote(src, param, m_type, intentional))
			SEND_SIGNAL(src, COMSIG_MOB_EMOTE, P, act, m_type, message, intentional)
			return TRUE
	if(intentional && !silenced)
		to_chat(src, "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>")
	return FALSE
