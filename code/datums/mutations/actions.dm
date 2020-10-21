/datum/mutation/human/telepathy
	name = "Telepathy"
	desc = "A rare mutation that allows the user to telepathically communicate to others."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You can hear your own voice echoing in your mind!</span>"
	text_lose_indication = "<span class='notice'>You don't hear your mind echo anymore.</span>"
	difficulty = 12
	power = /obj/effect/proc_holder/spell/targeted/telepathy
	instability = 10
	energy_coeff = 1


/datum/mutation/human/olfaction
	name = "Transcendent Olfaction"
	desc = "Your sense of smell is comparable to that of a canine."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>Smells begin to make more sense...</span>"
	text_lose_indication = "<span class='notice'>Your sense of smell goes back to normal.</span>"
	power = /obj/effect/proc_holder/spell/targeted/olfaction
	instability = 30
	synchronizer_coeff = 1
	var/reek = 200

/datum/mutation/human/olfaction/on_life()
	var/hygiene_now = owner.hygiene

	if(hygiene_now < 100 && prob(3))
		owner.adjust_disgust(GET_MUTATION_SYNCHRONIZER(src) * (rand(3,5)))
	if(hygiene_now < HYGIENE_LEVEL_DIRTY && prob(15))
		to_chat(owner,"<span class='danger'>You get a whiff of your stench and feel sick!</span>")
		owner.adjust_disgust(GET_MUTATION_SYNCHRONIZER(src) * rand(5,10))

	if(hygiene_now < HYGIENE_LEVEL_NORMAL && reek >= HYGIENE_LEVEL_NORMAL)
		to_chat(owner,"<span class='warning'>Your inhumanly strong nose picks up a faint odor. Maybe you should shower soon.</span>")
	if(hygiene_now < 150 && reek >= 150)
		to_chat(owner,"<span class='warning'>Your odor is getting bad, what with you having a super-nose and all.</span>")
	if(hygiene_now < 100 && reek >= 100)
		to_chat(owner,"<span class='danger'>Your odor begins to make you gag. You silently curse your godly nose. You should really get clean!</span>")
	if(hygiene_now < HYGIENE_LEVEL_DIRTY && reek >= HYGIENE_LEVEL_DIRTY)
		to_chat(owner,"<span class='userdanger'>Your super-nose is 100% fed up with your stench. You absolutely must get clean.</span>")
	reek = hygiene_now

/obj/effect/proc_holder/spell/targeted/olfaction
	name = "Remember the Scent"
	desc = "Get a scent off of the item you're currently holding to track it. With an empty hand, you'll track the scent you've remembered."
	charge_max = 100
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	action_icon_state = "nose"
	var/mob/living/carbon/tracking_target
	var/list/mob/living/carbon/possible = list()

/obj/effect/proc_holder/spell/targeted/olfaction/cast(list/targets, mob/living/user = usr)
	var/atom/sniffed = user.get_active_held_item()
	if(sniffed)
		var/old_target = tracking_target
		possible = list()
		var/list/prints = sniffed.return_fingerprints()
		for(var/mob/living/carbon/C in GLOB.carbon_list)
			if(prints[rustg_hash_string(RUSTG_HASH_MD5, C.dna.uni_identity)])
				possible |= C
		if(!length(possible))
			to_chat(user,"<span class='warning'>Despite your best efforts, there are no scents to be found on [sniffed]...</span>")
			return
		tracking_target = input(user, "Choose a scent to remember.", "Scent Tracking") as null|anything in sortNames(possible)
		if(!tracking_target)
			if(!old_target)
				to_chat(user,"<span class='warning'>You decide against remembering any scents. Instead, you notice your own nose in your peripheral vision. This goes on to remind you of that one time you started breathing manually and couldn't stop. What an awful day that was.</span>")
				return
			tracking_target = old_target
			on_the_trail(user)
			return
		to_chat(user,"<span class='notice'>You pick up the scent of [tracking_target]. The hunt begins.</span>")
		on_the_trail(user)
		return

	if(!tracking_target)
		to_chat(user,"<span class='warning'>You're not holding anything to smell, and you haven't smelled anything you can track. You smell your palm instead; it's kinda salty.</span>")
		return

	on_the_trail(user)

/obj/effect/proc_holder/spell/targeted/olfaction/proc/on_the_trail(mob/living/user)
	if(!tracking_target)
		to_chat(user,"<span class='warning'>You're not tracking a scent, but the game thought you were. Something's gone wrong! Report this as a bug.</span>")
		return
	if(tracking_target == user)
		to_chat(user,"<span class='warning'>You smell out the trail to yourself. Yep, it's you.</span>")
		return
	if(usr.z < tracking_target.z)
		to_chat(user,"<span class='warning'>The trail leads... way up above you? Huh. They must be really, really far away.</span>")
		return
	else if(usr.z > tracking_target.z)
		to_chat(user,"<span class='warning'>The trail leads... way down below you? Huh. They must be really, really far away.</span>")
		return
	var/direction_text = "[dir2text(get_dir(usr, tracking_target))]"
	if(direction_text)
		to_chat(user,"<span class='notice'>You consider [tracking_target]'s scent. The trail leads <b>[direction_text].</b></span>")

/datum/mutation/human/firebreath
	name = "Fire Breath"
	desc = "An ancient mutation that gives lizards breath of fire."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>Your throat is burning!</span>"
	text_lose_indication = "<span class='notice'>Your throat is cooling down.</span>"
	power = /obj/effect/proc_holder/spell/aimed/firebreath
	instability = 30
	energy_coeff = 1
	power_coeff = 1

/datum/mutation/human/firebreath/modify()
	if(power)
		var/obj/effect/proc_holder/spell/aimed/firebreath/S = power
		S.strength = GET_MUTATION_POWER(src)

/obj/effect/proc_holder/spell/aimed/firebreath
	name = "Fire Breath"
	desc = "You can breathe fire at a target."
	school = "evocation"
	charge_max = 600
	clothes_req = FALSE
	range = 20
	projectile_type = /obj/item/projectile/magic/aoe/fireball/firebreath
	base_icon_state = "fireball"
	action_icon_state = "fireball0"
	sound = 'sound/magic/demon_dies.ogg' //horrifying lizard noises
	active_msg = "You built up heat in your mouth."
	deactive_msg = "You swallow the flame."
	var/strength = 1

/obj/effect/proc_holder/spell/aimed/firebreath/before_cast(list/targets)
	. = ..()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.is_mouth_covered())
			C.adjust_fire_stacks(2)
			C.IgniteMob()
			to_chat(C,"<span class='warning'>Something in front of your mouth caught fire!</span>")
			return FALSE

/obj/effect/proc_holder/spell/aimed/firebreath/ready_projectile(obj/item/projectile/P, atom/target, mob/user, iteration)
	if(!istype(P, /obj/item/projectile/magic/aoe/fireball))
		return
	var/obj/item/projectile/magic/aoe/fireball/F = P
	switch(strength)
		if(1 to 3)
			F.exp_light = strength-1
		if(4 to INFINITY)
			F.exp_heavy = strength-3
	F.exp_fire += strength

/obj/item/projectile/magic/aoe/fireball/firebreath
	name = "fire breath"
	exp_heavy = 0
	exp_light = 0
	exp_flash = 0
	exp_fire= 4

/datum/mutation/human/void
	name = "Void Magnet"
	desc = "A rare genome that attracts odd forces not usually observed."
	quality = MINOR_NEGATIVE //upsides and downsides
	text_gain_indication = "<span class='notice'>You feel a heavy, dull force just beyond the walls watching you.</span>"
	instability = 30
	power = /obj/effect/proc_holder/spell/self/void
	energy_coeff = 1
	synchronizer_coeff = 1

/datum/mutation/human/void/on_life()
	if(!isturf(owner.loc))
		return
	if(prob((0.5+((100-dna.stability)/20))) * GET_MUTATION_SYNCHRONIZER(src)) //very rare, but enough to annoy you hopefully. +0.5 probability for every 10 points lost in stability
		new /obj/effect/immortality_talisman/void(get_turf(owner), owner)

/obj/effect/proc_holder/spell/self/void
	name = "Convoke Void" //magic the gathering joke here
	desc = "A rare genome that attracts odd forces not usually observed. May sometimes pull you in randomly."
	school = "evocation"
	clothes_req = FALSE
	charge_max = 600
	invocation = "DOOOOOOOOOOOOOOOOOOOOM!!!"
	invocation_type = "shout"
	action_icon_state = "void_magnet"

/obj/effect/proc_holder/spell/self/void/can_cast(mob/user = usr)
	. = ..()
	if(!isturf(user.loc))
		return FALSE

/obj/effect/proc_holder/spell/self/void/cast(mob/user = usr)
	. = ..()
	new /obj/effect/immortality_talisman/void(get_turf(user), user)

/datum/mutation/human/self_amputation
	name = "Autotomy"
	desc = "Allows a creature to voluntary discard a random appendage."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>Your joints feel loose.</span>"
	instability = 30
	power = /obj/effect/proc_holder/spell/self/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/obj/effect/proc_holder/spell/self/self_amputation
	name = "Drop a limb"
	desc = "Concentrate to make a random limb pop right off your body."
	clothes_req = FALSE
	human_req = FALSE
	charge_max = 100
	action_icon_state = "autotomy"

/obj/effect/proc_holder/spell/self/self_amputation/cast(mob/user = usr)
	if(!iscarbon(user))
		return

	var/mob/living/carbon/C = user
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return

	var/list/parts = list()
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.body_part != HEAD && BP.body_part != CHEST)
			if(BP.dismemberable)
				parts += BP
	if(!parts.len)
		to_chat(usr, "<span class='notice'>You can't shed any more limbs!</span>")
		return

	var/obj/item/bodypart/BP = pick(parts)
	BP.dismember()

/datum/mutation/human/extendoarm
	name = "Extendo Arm"
	desc = "Allows the affected to stretch their arms to grab objects from a distance."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>Your arms feel stretchy.</span>"
	text_lose_indication = "<span class='warning'>Your arms feel solid again.</span>"
	instability = 30
	power = /obj/effect/proc_holder/spell/aimed/extendoarm

/obj/effect/proc_holder/spell/aimed/extendoarm
	name = "Arm"
	desc = "Stretch your arm to grab or put stuff down."
	charge_max = 50
	cooldown_min = 50
	clothes_req = FALSE
	range = 50
	projectile_type = /obj/item/projectile/bullet/arm
	base_icon_state = "arm"
	action_icon_state = "arm"
	active_msg = "You loosen up your arm!"
	deactive_msg = "You relax your arm."
	active = FALSE
	projectile_amount = 64

/obj/effect/proc_holder/spell/aimed/extendoarm/ready_projectile(obj/item/projectile/bullet/arm/P, atom/target, mob/user, iteration)
	var/mob/living/carbon/C = user
	var/new_color
	if(C.dna?.species && !C.dna.species.use_skintones)
		new_color = C.dna.species.default_features["mcolor"]
		if(!("#" in new_color))
			new_color = "#[new_color]"
		P.add_atom_colour(new_color, FIXED_COLOUR_PRIORITY)

	P.homing = target
	P.beam = new(C, P, time=200, beam_icon_state="2-full", maxdistance=150, beam_sleep_time=1, beam_color = new_color)
	P.beam.Start()

	var/obj/item/I = C.get_active_held_item()
	if(I && C.dropItemToGround(I, FALSE))
		var/obj/item/projectile/bullet/arm/ARM = P
		ARM.grab(I)
	P.arm = C.hand_bodyparts[C.active_hand_index]
	P.arm.drop_limb()
	P.arm.forceMove(P)

/obj/effect/proc_holder/spell/aimed/extendoarm/InterceptClickOn(mob/living/caller, params, atom/target)
	if(!iscarbon(caller))
		return
	var/mob/living/carbon/C = caller
	if(!C.hand_bodyparts[C.active_hand_index]) //all these checks are here, because we dont want to adjust the spell icon thing in your screen and break it. wich it otherwise does in can_cast
		return
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return
	if(!C.canUnEquip(C.get_active_held_item()))
		return
	return ..()

/obj/effect/proc_holder/spell/aimed/extendoarm/can_cast(mob/user = usr)
	. = ..()
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/C = user
	if(C.handcuffed) //this doesnt mix well with the whole arm removal thing
		return FALSE

/obj/item/projectile/bullet/arm
	name = "arm"
	icon_state = "arm"
	suppressed = TRUE
	damage = 0
	range = 100
	speed = 2
	nodamage = 1
	homing = TRUE
	homing_turn_speed = 360
	var/obj/item/grabbed
	var/obj/item/bodypart/arm
	var/returning = FALSE
	var/datum/beam/beam

/obj/item/projectile/bullet/arm/prehit(atom/target, blocked = FALSE)
	if(returning)
		if(target == firer)
			var/mob/living/L = firer
			if(arm && firer)
				arm.attach_limb(firer, TRUE)
				arm = null
			L.put_in_hands(ungrab())
			qdel(src) //If we let it run it's course, it's going to awkwardly hit you
	else if(!isitem(target) && !grabbed && firer)
		target.attack_hand(firer)
		go_home()
	else
		if(grabbed)
			ungrab()
		else if(isitem(target))
			grab(target)
		go_home()

/obj/item/projectile/bullet/arm/proc/go_home()
	homing_target = firer
	returning = TRUE
	icon_state += "-reverse"
	range = decayedRange
	ignore_source_check = TRUE

/obj/item/projectile/bullet/arm/proc/grab(obj/item/I)
	if(!I)
		return
	I.forceMove(src)
	var/image/IM = image(I, src)
	IM.appearance_flags = RESET_COLOR //Otherwise skin color leaks to the object
	grabbed = I
	overlays += IM

/obj/item/projectile/bullet/arm/proc/ungrab()
	if(!grabbed)
		return
	grabbed.forceMove(drop_location())
	overlays.Cut()
	. = grabbed
	grabbed = null

/obj/item/projectile/bullet/arm/Destroy()
	if(grabbed)
		grabbed.forceMove(drop_location())
	if(arm)
		arm.forceMove(drop_location())
	qdel(beam)
	return ..()

/datum/mutation/human/claws
	name = "Claws"
	desc = "A mutation that reshapes the bone structure of the wrist to include claws."
	quality = POSITIVE
	text_gain_indication = "<span class='warning'>You feel sharp pain in your wrists!</span>"
	text_lose_indication = "<span class='notice'>Your wrists painfully reform back to normal.</span>"
	difficulty = 16
	instability = 25
	power = /obj/effect/proc_holder/spell/targeted/conjure_item/claw

/obj/effect/proc_holder/spell/targeted/conjure_item/claw
	name = "Extend Claws"
	desc = "Extend or retract your claws."
	action_icon = 'icons/mob/actions/actions_genetic.dmi'
	action_icon_state = "spikechemswap"
	action_background_icon_state = "bg_spell"
	charge_max = 20
	cooldown_min = 20
	item_type = /obj/item/claw

/obj/item/claw
	name = "claw"
	desc = "A claw made out of extended bone and freaky genetics. Fairly sharp, and always at the ready."
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	var/icon_left = "bloodhand_left"
	var/icon_right = "bloodhand_right"
	hitsound = 'sound/weapons/slash.ogg'
	pickup_sound = 'sound/items/unsheath.ogg'
	drop_sound = 'sound/items/sheath.ogg'
	attack_verb = list("attacked", "slashed", "sliced", "tore", "ripped")
	force = 15
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	damtype = "brute"

/obj/item/claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "genetics")
	AddComponent(/datum/component/butchering, 40, 60)

/obj/item/claw/equipped(mob/user, slot)
	. = ..()
	//these are intentionally inverted
	var/i = user.get_held_index_of_item(src)
	if(!(i % 2))
		icon_state = icon_left
	else
		icon_state = icon_right

/obj/item/claw/suicide_act(mob/living/user)
	playsound(src, 'sound/weapons/slash.ogg', 100, TRUE)
	if(istype(user) && user.get_bodypart(BODY_ZONE_HEAD))
		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
		user.visible_message("<span class='suicide'>[user] begins to slice [user.p_their()] head off with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		myhead.dismember()
	else
		user.visible_message("<span class='suicide'>[user] begins to dice themselves apart with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/datum/mutation/human/armblade
	name = "Arm Blade"
	desc = "A horrific mutation that gives user the ability to turn their arm into a grotesque blade made of bone and flesh."
	locked = TRUE
	text_gain_indication = "<span class='warning'>You feel bones in your arm painfully reforming!</span>"
	text_lose_indication = "<span class='warning'>Your arms painfully reform back to normal.</span>"
	instability = 35
	power = /obj/effect/proc_holder/spell/targeted/conjure_item/armblade

/obj/effect/proc_holder/spell/targeted/conjure_item/armblade
	name = "Arm Blade"
	desc = "Reform one of your arms into a deadly blade."
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "armblade"
	action_background_icon_state = "bg_spell"
	charge_max = 50
	cooldown_min = 50
	item_type = /obj/item/melee/arm_blade/genetics

/obj/item/melee/arm_blade/genetics
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter. This one doesn't look sturdy enough to force an airlock."

/obj/item/melee/arm_blade/genetics/Initialize(mapload,silent,synthetic)
	. = ...()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)
	if(ismob(loc) && !silent)
		loc.visible_message("<span class='warning'>A grotesque blade forms around [loc.name]\'s arm!</span>", "<span class='warning'>Your arm twists and mutates, transforming it into a deadly blade.</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	if(synthetic)
		can_drop = TRUE
	AddComponent(/datum/component/butchering, 60, 80)

/obj/item/melee/arm_blade/genetics/afterattack(atom/target, mob/user, proximity)
	. = ...() //powinno wykonać afterattack() obiektu /obj/item/melee ale nie /obj/item/melee/arm_blade. powinno.