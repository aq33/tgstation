/mob
	/// Used for tracking last uses of emotes for cooldown purposes
	var/list/emotes_used

/datum/keybinding/mob/speech_cloud
	key = "T"
	name = "speech_cloud"
	full_name = "Speech Cloud"
	description = ""

/datum/keybinding/mob/speech_cloud/down(client/user)
	if(!istype(user.mob, /mob/living)) return
	var/mob/living/mob = user.mob
	var/list/listening = get_hearers_in_view(world.view, mob)

	var/image/I = image('icons/mob/talk.dmi', mob, "[mob.bubble_icon]0", FLY_LAYER)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client)
			speech_bubble_recipients.Add(M.client)

	INVOKE_ASYNC(GLOBAL_PROC, /.proc/animate_speechbubble, I, speech_bubble_recipients, 50)
	return TRUE
