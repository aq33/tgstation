/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	// message = "cries"
	message = "płacze"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	// message = "sadly can't find anybody to give daps to, and daps themself. Shameful"
	message = "nie ma z kim przybić żółwika więc przybija ze sobą. Żałosne"
	// message_param = "give daps to %t"
	message_param = "przybija zółwika z %t"
	restraint_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	// message = "raises an eyebrow"
	message = "unosi brew"

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	// message = "grumbles"
	message = "zrzędzi"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	// message = "shakes their own hand"
	message = "uściskuje własną dłoń"
	// message_param = "shakes hands with %t"
	message_param = "uściskuje dłoń z %t"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	// message = "hugs themself"
	message = "przytula siebie"
	// message_param = "hugs %t"
	message_param = "przytula się z %t"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	// message = "mumbles"
	message = "mamrocze"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	// message = "screams"
	message = "krzyczy"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishumanbasic(H) || iscatperson(H))
		if(user.gender == FEMALE)
			return pick('sound/voice/human/femalescream_1.ogg', 'sound/voice/human/femalescream_2.ogg', 'sound/voice/human/femalescream_3.ogg', 'sound/voice/human/femalescream_4.ogg')
		else
			return pick('sound/voice/human/malescream_1.ogg', 'sound/voice/human/malescream_2.ogg', 'sound/voice/human/malescream_3.ogg', 'sound/voice/human/malescream_4.ogg', 'sound/voice/human/malescream_5.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/scream_moth.ogg'
	else if(islizard(H))
		return pick('sound/voice/lizard/lizard_scream_1.ogg', 'sound/voice/lizard/lizard_scream_2.ogg', 'sound/voice/lizard/lizard_scream_3.ogg', 'sound/voice/lizard/lizard_scream_4.ogg')


/datum/emote/living/carbon/human/pale
	key = "pale"
	// message = "goes pale for a second"
	message = "blednie na moment"

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	// message = "raises a hand"
	message = "podnosi rękę"
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	// message = "salutes"
	message = "salutuje"
	// message_param = "salutes to %t"
	message_param = "salutuje do %t"
	restraint_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	// message = "shrugs"
	message = "wzrusza ramionami"

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings"

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		H.Togglewings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if("wings" in H.dna.species.mutant_bodyparts)
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

/mob/living/carbon/human/proc/Togglewings()
	if(!dna || !dna.species)
		return FALSE
	var/obj/item/organ/wings/wings = getorganslot(ORGAN_SLOT_WINGS)
	if(getorgan(/obj/item/organ/wings))
		if(wings.toggleopen(src))
			return TRUE
	return FALSE


/datum/emote/living/carbon/human/fart
	key = "fart"
	key_third_person = "farts"

/datum/emote/living/carbon/human/fart/run_emote(mob/user, params, type_override, intentional)
	if(!..())
		return
	. = TRUE
	var/mob/living/carbon/human/C = user
	var/turf/T = get_turf(user)

	if(HAS_TRAIT(user, TRAIT_MEGAFART) && HAS_TRAIT(user, TRAIT_TOXICFART))
		user.visible_message("<span class = 'warning'>[user] hunches down and grits [user.p_their()] teeth!</span>","<span class = 'warning'>You hunch down and grit your teeth. Stand still!</span>")
		to_chat(user, "<span class = 'userdanger'>You have a very bad feeling about this!</span>")
		if(do_after_mob(user, user, 3.5 SECONDS))
			explosion(T, -1, 0, 0, 0, 0, flame_range = 2)
			C.Knockdown(2 SECONDS)
			C.adjust_fire_stacks(2)
			C.IgniteMob()
			C.apply_damage(15, BRUTE, BODY_ZONE_CHEST)

	else if(HAS_TRAIT(user, TRAIT_MEGAFART))
		user.visible_message("<span class = 'warning'>[user] hunches down and grits [user.p_their()] teeth!</span>","<span class = 'warning'>You hunch down and grit your teeth. Stand still!</span>")
		if(do_after_mob(user, user, 2.5 SECONDS))
			for(var/mob/M in urange(3, user))
				if(!M.stat)
					shake_camera(M, 1, 1)
			goonchem_vortex(T, 1, 2)
			C.Knockdown(1 SECONDS)
			C.apply_damage(20, BRUTE, BODY_ZONE_CHEST)
			//why are we still here? just to suffer?

	else if(HAS_TRAIT(user, TRAIT_TOXICFART))
		user.visible_message("<span class = 'warning'>[user] hunches down and grits [user.p_their()] teeth!</span>","<span class = 'warning'>You hunch down and grit your teeth. Stand still!</span>")
		if(do_after_mob(user, user, 1.5 SECONDS))
			if(istype(T, /turf/open))
				T.atmos_spawn_air("plasma=3")
			C.Knockdown(0.5 SECONDS)
			C.apply_damage(20, TOX)

	/*	jeśli ktoś ma pomysł jak to ładniej zakodować, to dajcie znać na discordzie (b4cku#1372).
		miałem do wyboru albo przepisać WSZYSTKIE checki na początku i na końcu zostawić ..(), które by wykonało słyszalną akcję i dźwięk
		albo sprawić żeby ..() wykonało checki na początku, a skutki wklepać ręcznie na koniec.*/
		
// user.audible_message("<span class='emote'><b>[user]</b> farts!</span>")
	user.audible_message("<span class='emote'><b>[user]</b> pierdzi!</span>")
	playsound(user, 'sound/misc/fart1.ogg', 50, TRUE)

// Robotic Tongue emotes. Beep!

/datum/emote/living/carbon/human/robot_tongue/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/obj/item/organ/tongue/T = user.getorganslot("tongue")
	if(T.status == ORGAN_ROBOTIC)
		return TRUE

/datum/emote/living/carbon/human/robot_tongue/beep
	key = "beep"
	key_third_person = "beeps"
	// message = "beeps"
	message = "pika"
	// message_param = "beeps at %t"
	message_param = "pika na %t"

/datum/emote/living/carbon/human/robot_tongue/beep/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/twobeep.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/buzz
	key = "buzz"
	key_third_person = "buzzes"
	// message = "buzzes"
	message = "brzęczy"
	// message_param = "buzzes at %t"
	message_param = "brzęczy na %t"

/datum/emote/living/carbon/human/robot_tongue/buzz/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/buzz-sigh.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/buzz2
	key = "buzz2"
	message = "buzzes twice"

/datum/emote/living/carbon/human/robot_tongue/buzz2/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/buzz-two.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/chime
	key = "chime"
	key_third_person = "chimes"
	message = "chimes"

/datum/emote/living/carbon/human/robot_tongue/chime/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/chime.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/ping
	key = "ping"
	key_third_person = "pings"
	message = "pings"
	message_param = "pings at %t"

/datum/emote/living/carbon/human/robot_tongue/ping/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/ping.ogg', 50)

 // Clown Robotic Tongue ONLY. Henk.

/datum/emote/living/carbon/human/robot_tongue/clown/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	if(user.mind.assigned_role == "Clown")
		return TRUE

/datum/emote/living/carbon/human/robot_tongue/clown/honk
	key = "honk"
	key_third_person = "honks"
	// message = "honks"
	message = "trąbi"

/datum/emote/living/carbon/human/robot_tongue/clown/honk/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/items/bikehorn.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/clown/sad
	key = "sad"
	key_third_person = "plays a sad trombone"
	// message = "plays a sad trombone"
	message = "smuteczek"

/datum/emote/living/carbon/human/robot_tongue/clown/sad/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/misc/sadtrombone.ogg', 50)
