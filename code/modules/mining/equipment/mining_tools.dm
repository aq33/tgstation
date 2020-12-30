/*****************Pickaxes & Drills & Shovels****************/

#define DRILL_BASIC 1
#define DRILL_HARDENED 2
/obj/item/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	attack_weight = 2
	block_upgrade_walk = 1
	force = 15
	throwforce = 10
	item_state = "pickaxe"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	materials = list(/datum/material/iron=2000) //one sheet, but where can you make them?
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb = list("hit", "pierced", "sliced", "attacked")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins digging into [user.p_their()] chest!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] couldn't do it!</span>")
	return SHAME

/obj/item/pickaxe/mini
	name = "compact pickaxe"
	desc = "A smaller, compact version of the standard pickaxe."
	icon_state = "minipick"
	force = 10
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=1000)

/obj/item/pickaxe/silver
	name = "silver-plated pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	toolspeed = 0.8 //mines faster than a normal pickaxe, bought from mining vendor
	desc = "A silver-plated pickaxe that mines slightly faster than standard-issue."
	force = 17

/obj/item/pickaxe/diamond
	name = "diamond-tipped pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	toolspeed = 0.7
	desc = "A pickaxe with a diamond pick head. Extremely robust at cracking rock walls and digging up dirt."
	force = 19

/obj/item/pickaxe/drill
	name = "mining drill"
	desc = "Compact electric mining drill for the especially scrawny."
	icon_state = "handdrill"
	item_state = "jackhammer"
	slot_flags = ITEM_SLOT_BELT
	var/drill_level = DRILL_BASIC
	var/drill_delay = 30
	var/is_drilling = FALSE
	toolspeed = 0.6
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = IS_SHARP
	usesound = 'sound/weapons/drill.ogg'
	hitsound = 'sound/weapons/drill.ogg'


/obj/item/pickaxe/drill/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 50, 100)

/obj/item/pickaxe/drill/proc/get_user()
	if(iscarbon(loc))
		var/mob/living/carbon/user = loc
		return user

/obj/item/pickaxe/drill/attack(atom/target, mob/user)
	if(!target || !user && is_drilling)
		is_drilling = FALSE
		return
	if(user.a_intent == INTENT_HARM && !is_drilling)
		is_drilling = TRUE
		if(!isliving(target))
			return
		target.visible_message("<span class='warning'>[user] starts to drill [target].</span>", \
					"<span class='userdanger'>[user] starts to drill [target]...</span>", \
					 "<span class='italics'>You start drilling [target].</span>")
		while(do_after(user, drill_delay, 1, target) && is_drilling)
			if(QDELETED(target))
				is_drilling = FALSE
				break
			is_drilling = TRUE
			drill_mob(target, user)
	else
		is_drilling = FALSE
		..()

/obj/item/pickaxe/drill/attack_obj(obj/target, mob/user)
	if(!target || !user && is_drilling)
		is_drilling = FALSE
		return
	if(user.a_intent == INTENT_HARM && !is_drilling)
		is_drilling = TRUE
		if(!isobj(target))
			return
		target.visible_message("<span class='warning'>[user] starts to drill [target].</span>", \
					"<span class='userdanger'>[user] starts to drill [target]...</span>", \
					 "<span class='italics'>You start drilling [target].</span>")
		while(do_after(user, drill_delay, 1, target) && is_drilling)
			if(QDELETED(target))
				is_drilling = FALSE
				break
			is_drilling = TRUE
			drill_obj(target, user)
	else
		is_drilling = FALSE
		..()

/obj/item/pickaxe/drill/proc/drill_mob(mob/living/target, mob/user)
	target.visible_message("<span class='danger'>[user] is drilling [target] with [src]!</span>", \
						"<span class='userdanger'>[user] is drilling you with [src]!</span>")
	log_combat(user, target, "drilled", "[name]", "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	playsound(src,usesound,40,1)
	if(target.stat == DEAD && target.getBruteLoss() >= 200 && user.a_intent == INTENT_HARM)
		log_combat(user, target, "gibbed", name)
		if(LAZYLEN(target.butcher_results) || LAZYLEN(target.guaranteed_butcher_results))
			var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
			butchering.Butcher(user, target)
		else
			target.gib()
	else
		//drill makes a hole
		var/obj/effect/decal/cleanable/blood/hitsplatter/B = new(target.loc, target)
		B.add_blood_DNA(return_blood_DNA())
		var/dist = rand(0,3)
		var/turf/targ = get_ranged_target_turf(target, rand(0, 360), dist)
		B.GoTo(targ, dist)
		var/obj/item/bodypart/target_part = target.get_bodypart(ran_zone(BODY_ZONE_CHEST))
		target.apply_damage(10*drill_level, BRUTE, BODY_ZONE_CHEST, target.run_armor_check(target_part, "melee"))

		//blood splatters
		var/splatter_dir = get_dir(user, target)
		if(isalien(target))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(target.drop_location(), splatter_dir)
		else
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(target.drop_location(), splatter_dir)

		//organs go everywhere
		if(target_part && prob(10 * drill_level))
			target_part.dismember(BRUTE)

/obj/item/pickaxe/drill/proc/drill_obj(obj/target, mob/user)
	if(target == null)
		return
	target.take_damage(10*drill_level, BRUTE, 0, FALSE, get_dir(user, target))
	do_sparks(2*drill_level, FALSE, target.loc)
	target.visible_message("<span class='danger'>[user] is drilling [target] with [src]!</span>")
	playsound(src,usesound,40,1)

/obj/item/pickaxe/drill/cyborg
	name = "cyborg mining drill"
	desc = "An integrated electric mining drill."
	flags_1 = NONE

/obj/item/pickaxe/drill/cyborg/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CYBORG_ITEM_TRAIT)

/obj/item/pickaxe/drill/diamonddrill
	name = "diamond-tipped mining drill"
	desc = "Compact electric mining drill with diamond-infused drilling bit."
	icon_state = "diamonddrill"
	drill_level = DRILL_HARDENED
	drill_delay = 20
	toolspeed = 0.2

/obj/item/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "diamond-tipped cyborg mining drill" //To inherit the NODROP_1 flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	drill_level = DRILL_HARDENED
	drill_delay = 20
	toolspeed = 0.2

/obj/item/pickaxe/drill/jackhammer
	name = "sonic jackhammer"
	desc = "Heavy-duty mining tool that cracks rocks with sonic blasts."
	icon_state = "jackhammer"
	item_state = "jackhammer"
	drill_level = DRILL_HARDENED
	drill_delay = 10
	toolspeed = 0
	w_class = WEIGHT_CLASS_BULKY
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 8
	block_upgrade_walk = 1
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	throwforce = 4
	item_state = "shovel"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(/datum/material/iron=50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharpness = IS_SHARP

/obj/item/shovel/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 150, 40) //it's sharp, so it works, but barely.

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins digging their own grave!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] couldn't do it!</span>")
	return SHAME

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL

#undef DRILL_BASIC
#undef DRILL_HARDENED
