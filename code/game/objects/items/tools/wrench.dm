/obj/item/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	block_upgrade_walk = 1
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	materials = list(/datum/material/iron=150)
	drop_sound = 'sound/items/handling/wrench_drop.ogg'
	pickup_sound =  'sound/items/handling/wrench_pickup.ogg'

	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)

/obj/item/wrench/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is beating [user.p_them()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1)
	return (BRUTELOSS)

/obj/item/wrench/brass
	name = "brass wrench"
	desc = "A brass wrench. It's faintly warm to the touch."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "wrench_brass"
	toolspeed = 0.5

/obj/item/wrench/abductor
	name = "alien wrench"
	desc = "A polarized wrench. It causes anything placed between the jaws to turn."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1


/obj/item/wrench/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a bolt bit."
	icon_state = "drill_bolt"
	item_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/drill_use.ogg'
	materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)
 //done for balance reasons, making them high value for research, but harder to get
	force = 8 //might or might not be too high, subject to change
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 8
	attack_verb = list("drilled", "screwed", "jabbed")
	toolspeed = 0.7

/obj/item/wrench/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	var/obj/item/wirecutters/power/s_drill = new /obj/item/screwdriver/power(drop_location())
	to_chat(user, "<span class='notice'>You attach the screw driver bit to [src].</span>")
	qdel(src)
	user.put_in_active_hand(s_drill)

/obj/item/wrench/power/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is pressing [src] against [user.p_their()] head! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/wrench/medical
	name = "medical wrench"
	desc = "A medical wrench with common(medical?) uses. Can be found in your hand."
	icon_state = "wrench_medical"
	force = 2 //MEDICAL
	throwforce = 4
	attack_verb = list("healed", "medicaled", "tapped", "poked", "analyzed") //"cobbyed"
	///var to hold the name of the person who suicided
	var/suicider

/obj/item/wrench/medical/examine(mob/user)
	. = ..()
	if(suicider)
		. += "<span class='notice'>For some reason, it reminds you of [suicider].</span>"

/obj/item/wrench/medical/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is praying to the medical wrench to take [user.p_their()] soul. It looks like [user.p_theyre()] trying to commit suicide!</span>")
	// TODO Make them glow with the power of the M E D I C A L W R E N C H
	// during their ascension

	// Stun stops them from wandering off
	user.Stun(100, ignore_canstun = TRUE)
	playsound(loc, 'sound/effects/pray.ogg', 50, 1, -1)

	// Let the sound effect finish playing
	add_fingerprint(user)
	sleep(20)
	if(!user)
		return
	for(var/obj/item/W in user)
		user.dropItemToGround(W)
	suicider = user.real_name
	user.dust()
	return OXYLOSS

/obj/item/wrench/cyborg
	name = "hydraulic wrench"
	desc = "An advanced robotic wrench, powered by internal hydraulics. Twice as fast as the handheld version."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wrench_cyborg"
	toolspeed = 0.5

/obj/item/wrench/eureka
	name = "experimental wrench"
	desc = "Bizzare wrench with weird apparatus wired to its side that makes it awkward to use."
	icon_state = "wrench_eureka"
	toolspeed = 1.2
	materials = list(/datum/material/iron=150,/datum/material/bluespace=50)
	var/charges = 1
	var/max_charges = 5
	var/eureka_channel_teleport = 20 //długość channela teleportu w tickach. 10 ticków = 1 sekunda
	var/eureka_channel_set = 100 //długość channela anchorowania w tickach
	var/teleport_ready = FALSE //następna akcja klucza: false - zapisanie pozycji, true - teleport do niej
	var/teleport_x //poniżej koordynaty zapisanego miejsca
	var/teleport_y
	var/teleport_z

/obj/item/wrench/eureka/examine(mob/user)
	. = ..()
	. += ("A little switch in its handle is set to \"[teleport_ready?"TELEPORT":"ANCHOR"]\".")
	. += ("<span class='notice'>It has [charges] charges out of [max_charges] left. There seems to be a slot that could fit a bluespace crystal.</span>")

/obj/item/wrench/eureka/attack_self(mob/user)
	if(!teleport_ready)
		to_chat(user, "<span class='notice'>You begin [src]'s anchoring procedure.</span>")
		if(!do_after(user, eureka_channel_set, target = src)) //tutaj pasek ma się pojawiać nad itemem
			return
		to_chat(user, "<span class='notice'>[src] anchors to this spot!</span>")
		var/turf/T = get_turf(user)
		teleport_x = T.x
		teleport_y = T.y
		teleport_z = T.z
		teleport_ready = TRUE
	else
		if(teleport_x && teleport_y && teleport_z)
			user.visible_message("<span class='warning'>[user] raises the [src]!</span>", "<span class='notice'>You raise the [src]!</span>")
			playsound(src, 'sound/items/eureka_channel.ogg', 50, 1)
			if(!do_after(user, eureka_channel_teleport, target = user)) //a tutaj ma się pojawiać nad użytkownikiem
				return
			if(charges < 1)
				to_chat(user, "<span class='notice'>...but it quietly buzzes. Perhaps it can be recharged?</span>")
				return
			charges -= 1
			var/turf/T = locate(teleport_x, teleport_y, teleport_z)
			to_chat(user, "<span class='notice'>You snap back to [src]'s anchor point!</span>")
			do_teleport(user, T,  asoundin = 'sound/items/eureka_teleport.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
		teleport_ready = FALSE //na wszelki wypadek tutaj, w razie gdyby teleport_x, y albo z znikneły

/obj/item/wrench/eureka/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		if(charges >= max_charges)
			to_chat(user, "<span class='warning'>[src] can't contain any more [I]!</span>")
			return
		var/obj/item/stack/ore/bluespace_crystal/B = I
		B.use(1)
		charges += 1
		to_chat(user, "<span class='notice'>You insert [I] into [src]. It now has [charges] charges.</span>")

/obj/item/wrench/eureka/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] raises the [src], muttering insults at the God! It looks like [user.p_theyre()] trying to commit suicide!</span>", "<span class='suicide'>You raise the [src], muttering insults at the God!!</span>")
	playsound(src, 'sound/items/eureka_channel.ogg', 50, 1)
	if(!do_after(user, eureka_channel_teleport, target = user))
		return
	if(charges < 1)
		to_chat(user, "<span class='notice'>...but it quietly buzzes. Perhaps it can be recharged?</span>")
		return SHAME
	charges -= 1
	playsound(src, 'sound/items/eureka_teleport.ogg', 50, 1)
	var/turf/T = get_step(get_step(user, NORTH), NORTH)
	T.Beam(user, icon_state="lightning[rand(1,12)]", time = 5)
	user.visible_message("<span class='warning'>[user] summoned God's wrath!</span>")
	user.dust()
	return FIRELOSS
