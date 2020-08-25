#define SUBDUE_COMBO "GDD"
#define SPINPUNCH_COMBO "DDDDDH"

/datum/martial_art/sharpshadowofthemist
	name = "sharpshadowofthemist"
	id = MARTIALART_SHARPSHADOWOFTHEMIST
	help_verb = /mob/living/carbon/human/proc/sharpshadowofthemist_help  //here is the verb for reminding yourself the combos

/datum/martial_art/sharpshadowofthemist/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,SUBDUE_COMBO))
		streak = ""
		Subdue(A,D)
		return 1
	if(findtext(streak,SPINPUNCH_COMBO))
		Spinpunch(A,D)
		return 1
	return 0


/datum/martial_art/sharpshadowofthemist/proc/Subdue(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	if(D.mobility_flags & MOBILITY_STAND)
		D.visible_message("<span class='warning'>[A] subdues [D] !</span>", \
						  	"<span class='userdanger'>[A]subdues you!</span>")
		playsound(get_turf(A), 'sound/weapons/slam.ogg', 50, 1, -1)
		D.Paralyze(120)
		D.adjustStaminaLoss(150)
	log_combat(A, D, "subdued (sharpshadowofthemist)")

/datum/martial_art/sharpshadowofthemist/proc/SpinpunchAnimate(mob/living/carbon/human/A)
	set waitfor = FALSE
	for(var/i in list(NORTH,EAST,SOUTH,WEST,NORTH,EAST,SOUTH,WEST,NORTH,EAST,SOUTH,WEST))
		if(!A)
			break
		A.setDir(i)
		playsound(A.loc,'sound/misc/desceration-03.ogg', 15, 1, -1)
		sleep(1)

/datum/martial_art/sharpshadowofthemist/proc/Spinpunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	SpinpunchAnimate(A)
	if(!can_use(A))
		return FALSE
	if(D.mobility_flags & MOBILITY_STAND)
		D.visible_message("<span class='warning'>[A] Spinpunches  [D] !</span>", \
						  	"<span class='userdanger'>[A]Spinpunches you!</span>")
		D.say("*scream")
		D.apply_damage(100, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	log_combat(A, D, "Spinkicked (sharpshadowofthemist)")

/datum/martial_art/sharpshadowofthemist/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return FALSE
	if(A==D)
		return FALSE //prevents grabbing yourself
	if(A.a_intent == INTENT_GRAB)
		add_to_streak("G",D)
		if(check_streak(A,D)) //doing combos is prioritized over upgrading grabs
			return TRUE
		D.grabbedby(A, 1)
		if(A.grab_state == GRAB_PASSIVE)
			D.drop_all_held_items()
			A.setGrabState(GRAB_AGGRESSIVE) //Instant agressive grab if on grab intent
			log_combat(A, D, "grabbed", addition="aggressively")
			D.visible_message("<span class='warning'>[A] violently grabs [D]!</span>", \
								"<span class='userdanger'>[A] violently grabs you!</span>")
	else
		D.grabbedby(A, 1)
	return TRUE

/datum/martial_art/sharpshadowofthemist/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/sharpshadowofthemist/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/mob/living/carbon/human/proc/sharpshadowofthemist_help()
	set name = "Remember your teachings"
	set desc = "You go inwards, you see your painful childhood, getting kicked out of clown school for being to serious and not dumb enough, you feel sorrow and rage, which awaken your memory! You remind yourself how to use the subduation technique!"
	set category = "sharp shadow of the mist"
	to_chat(usr, "<span class='notice'>Subdue</span>: Grab, Disarm, Disarm. Subdue your enemies with a long technique.")
	to_chat(usr, "<span class='notice'>SpinKick</span>: Disarm, Disarm, Disarm, Disarm, Disarm, Harm. Perform a spinning punch. Spin so fast, that the impact of your kick breaks your enemies legs!.")
	to_chat(usr, "<b><i>In addition, your joints and bones became elastic to further enchance your miming techniques, you now are immune to being grabbed and you grab aggresively!.</i></b>")
