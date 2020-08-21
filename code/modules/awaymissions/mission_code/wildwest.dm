/* Code for the Wild West map by Brotemis
 * Contains:
 *		Wish Granter
 *		Meat Grinder
 */

//Areas

/area/awaymission/wildwest/mines
	name = "Wild West Mines"
	icon_state = "away1"
	requires_power = FALSE

/area/awaymission/wildwest/gov
	name = "Wild West Mansion"
	icon_state = "away2"
	requires_power = FALSE

/area/awaymission/wildwest/refine
	name = "Wild West Refinery"
	icon_state = "away3"
	requires_power = FALSE

/area/awaymission/wildwest/vault
	name = "Wild West Vault"
	icon_state = "away3"

/area/awaymission/wildwest/vaultdoors
	name = "Wild West Vault Doors"  // this is to keep the vault area being entirely lit because of requires_power
	icon_state = "away2"
	requires_power = FALSE


 ////////// wildwest papers

/obj/item/paper/fluff/awaymissions/wildwest/grinder
	info = "meat grinder requires sacri"


/obj/item/paper/fluff/awaymissions/wildwest/journal/page1
	name = "Planer Saul's Journal: Page 1"
	info = "Some ships have flown over to our peacful mining village, some red-and-black dressed men have come here, they do not look peacful. They are heavily armed and they are making us work our asses of for no money at all. They LET US cook in exchange, considering we cook for them too. I hear someone at my door, I will hide this note for now."

/obj/item/paper/fluff/awaymissions/wildwest/journal/page4
	name = "Planer Saul's Journal: Page 4"
	info = " The miners in the town have become sick and almost all production has stopped. They, in a fit of delusion, tossed all of their mining equipment into the furnaces. The syndies are getting angry, some miners decided to get back to work, all I know is that they have bruises spontaniously appearing over their faces."

/obj/item/paper/fluff/awaymissions/wildwest/journal/page7
	name = "Planer Sauls' Journal: Page 7"
	info = "I have seen the Syndicate guards talk about some sort of plan. It looks like they are packing up, but on the other side I heard gunshots at night. We have nowhere to hide, we can only pray."

/obj/item/paper/fluff/awaymissions/wildwest/journal/page8
	name = "Planer Saul's Journal: Page 8"
	info = "The syndicate have invaded.  Their ships appeared out of nowhere and now they likely intend to kill us all and take everything. Some of them are in those hardsuits, but they seem more... elite. You cannot save us, but you can save our town from perishing, avenge us."


/*
 * Wish Granter
 */
/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	density = TRUE
	use_power = NO_POWER_USE

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter_dark/interact(mob/living/carbon/human/user)
	if(chargesa <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!ishuman(user))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")

	else if (!insistinga)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = input("You want...","Wish") as null|anything in sortList(list("Power","Wealth","Immortality","Peace"))
		switch(wish)
			if("Power")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.dna.add_mutation(LASEREYES)
				user.dna.add_mutation(SPACEMUT)
				user.dna.add_mutation(XRAY)
				user.set_species(/datum/species/shadow)
			if("Wealth")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.set_species(/datum/species/shadow)
			if("Immortality")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.verbs += /mob/living/carbon/proc/immortality
				user.set_species(/datum/species/shadow)
			if("Peace")
				to_chat(user, "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>")
				to_chat(user, "You feel as if you just narrowly avoided a terrible fate...")
				for(var/mob/living/simple_animal/hostile/faithless/F in GLOB.mob_living_list)
					F.death()


///////////////Meatgrinder//////////////


/obj/effect/meatgrinder
	name = "Meat Grinder"
	desc = "What is that thing?"
	density = TRUE
	anchored = TRUE
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobpod"
	var/triggered = 0

/obj/effect/meatgrinder/Crossed(atom/movable/AM)
	Bumped(AM)

/obj/effect/meatgrinder/Bumped(atom/movable/AM)

	if(triggered)
		return
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/M = AM

	if(M.stat != DEAD && M.ckey)
		visible_message("<span class='warning'>[M] triggered [src]!</span>")
		triggered = 1

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		explosion(M, 1, 0, 0, 0)
		qdel(src)

/////For the Wishgranter///////////

/mob/living/carbon/proc/immortality() //Mob proc so people cant just clone themselves to get rid of the shadowperson race. No hiding your wickedness.
	set category = "Immortality"
	set name = "Resurrection"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, "<span class='notice'>You're not dead yet!</span>")
		return
	if(C.has_status_effect(STATUS_EFFECT_WISH_GRANTERS_GIFT))
		to_chat(C, "<span class='warning'>You're already resurrecting!</span>")
		return
	C.apply_status_effect(STATUS_EFFECT_WISH_GRANTERS_GIFT)
	return 1
