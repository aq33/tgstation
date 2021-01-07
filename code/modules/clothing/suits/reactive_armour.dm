/obj/item/reactive_armour_shell
	name = "reactive armour shell"
	desc = "An experimental suit of armour, awaiting installation of an anomaly core."
	icon_state = "reactiveoff"
	icon = 'icons/obj/clothing/suits.dmi'
	w_class = WEIGHT_CLASS_BULKY

/obj/item/reactive_armour_shell/attackby(obj/item/I, mob/user, params)
	..()
	var/static/list/anomaly_armour_types = list(
		/obj/effect/anomaly/grav	                = /obj/item/clothing/suit/armor/reactive/repulse,
		/obj/effect/anomaly/flux 	           		= /obj/item/clothing/suit/armor/reactive/tesla,
		/obj/effect/anomaly/bluespace 	            = /obj/item/clothing/suit/armor/reactive/teleport,
		/obj/effect/anomaly/pyro 	                = /obj/item/clothing/suit/armor/reactive/fire
		)

	if(istype(I, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/A = I
		var/armour_path = anomaly_armour_types[A.anomaly_type]
		if(!armour_path)
			armour_path = /obj/item/clothing/suit/armor/reactive/stealth //Lets not cheat the player if an anomaly type doesnt have its own armour coded
		to_chat(user, "You insert [A] into the chest plate, and the armour gently hums to life.")
		new armour_path(get_turf(src))
		qdel(src)
		qdel(A)

//Reactive armor
/obj/item/clothing/suit/armor/reactive
	name = "reactive armor"
	desc = "Doesn't seem to do much for some reason."
	var/active = FALSE
	var/reactivearmor_cooldown_duration = 0 //cooldown specific to reactive armor
	var/reactivearmor_cooldown = 0
	icon_state = "reactive"
	item_state = "reactive"
	blood_overlay_type = "armor"
	armor = list("melee" = 25, "bullet" = 10, "laser" = 10, "energy" = 15, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	actions_types = list(/datum/action/item_action/toggle)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	hit_reaction_chance = 50
	pocket_storage_component_path = FALSE

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	active = !(active)
	if(active)
		to_chat(user, "<span class='notice'>[src] is now active.</span>")
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(item_state)]-on"
	else
		to_chat(user, "<span class='notice'>[src] is now inactive.</span>")
		icon_state = "[initial(icon_state)]-off"
		item_state = "[initial(item_state)]-off"
	add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	active = 0
	icon_state = "reactive-off"
	item_state = "reactive-off"
	reactivearmor_cooldown = world.time + 200

//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive/teleport
	name = "reactive teleport armor"
	desc = "Someone separated our Research Director from his own head!"
	var/tele_range = 6
	var/rad_amount= 15
	reactivearmor_cooldown_duration = 100

/obj/item/clothing/suit/armor/reactive/teleport/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		var/mob/living/carbon/human/H = owner
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The reactive teleport system is still recharging! It fails to teleport [H]!</span>")
			return
		owner.visible_message("<span class='danger'>The reactive teleport system flings [H] clear of [attack_text], shutting itself off in the process!</span>")
		playsound(get_turf(owner),'sound/magic/blink.ogg', 100, 1)
		var/list/turfs = new/list()
		for(var/turf/T in orange(tele_range, H))
			if(T.density)
				continue
			if(T.x>world.maxx-tele_range || T.x<tele_range)
				continue
			if(T.y>world.maxy-tele_range || T.y<tele_range)
				continue
			turfs += T
		if(!turfs.len)
			turfs += pick(/turf in orange(tele_range, H))
		var/turf/picked = pick(turfs)
		if(!isturf(picked))
			return
		H.forceMove(picked)
		H.rad_act(rad_amount)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1
	return 0

//Fire

/obj/item/clothing/suit/armor/reactive/fire
	name = "reactive incendiary armor"
	desc = "An experimental suit of armor with a reactive sensor array rigged to a flame emitter. For the stylish pyromaniac."

/obj/item/clothing/suit/armor/reactive/fire/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The reactive incendiary armor on [owner] activates, but fails to send out flames as it is still recharging its flame jets!</span>")
			return
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], sending out jets of flame!</span>")
		playsound(get_turf(owner),'sound/magic/fireball.ogg', 100, 1)
		for(var/mob/living/carbon/C in range(6, owner))
			if(C != owner)
				C.fire_stacks += 8
				C.IgniteMob()
		owner.fire_stacks = -20
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1
	return 0

//Stealth

/obj/item/clothing/suit/armor/reactive/stealth
	name = "reactive stealth armor"
	desc = "An experimental suit of armor that renders the wearer invisible on detection of imminent harm, and creates a decoy that runs away from the owner. You can't fight what you can't see."

/obj/item/clothing/suit/armor/reactive/stealth/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The reactive stealth system on [owner] activates, but is still recharging its holographic emitters!</span>")
			return
		var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
		E.Copy_Parent(owner, 50)
		E.GiveTarget(owner) //so it starts running right away
		E.Goto(owner, E.move_to_delay, E.minimum_distance)
		owner.alpha = 0
		owner.visible_message("<span class='danger'>[owner] is hit by [attack_text] in the chest!</span>") //We pretend to be hit, since blocking it would stop the message otherwise
		spawn(40)
			owner.alpha = initial(owner.alpha)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1

//Tesla

/obj/item/clothing/suit/armor/reactive/tesla
	name = "reactive tesla armor"
	desc = "An experimental suit of armor with sensitive detectors hooked up to a huge capacitor grid, with emitters strutting out of it. Zap."
	siemens_coefficient = -1
	var/tesla_power = 25000
	var/tesla_range = 20
	var/tesla_flags = TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE

/obj/item/clothing/suit/armor/reactive/tesla/dropped(mob/user)
	..()
	if(istype(user))
		user.flags_1 &= ~TESLA_IGNORE_1

/obj/item/clothing/suit/armor/reactive/tesla/equipped(mob/user, slot)
	..()
	if(slot_flags & slotdefine2slotbit(slot)) //Was equipped to a valid slot for this item?
		user.flags_1 |= TESLA_IGNORE_1

/obj/item/clothing/suit/armor/reactive/tesla/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return FALSE
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
			owner.visible_message("<span class='danger'>The tesla capacitors on [owner]'s reactive tesla armor are still recharging! The armor merely emits some sparks.</span>")
			return
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], sending out arcs of lightning!</span>")
		tesla_zap(owner, tesla_range, tesla_power, tesla_flags)
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return TRUE

//Repulse

/obj/item/clothing/suit/armor/reactive/repulse
	name = "reactive repulse armor"
	desc = "An experimental suit of armor that violently throws back attackers."
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/obj/item/clothing/suit/armor/reactive/repulse/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The repulse generator is still recharging!</span>")
			return 0
		playsound(get_turf(owner),'sound/magic/repulse.ogg', 100, 1)
		owner.visible_message("<span class='danger'>[src] blocks [attack_text], converting the attack into a wave of force!</span>")
		var/turf/T = get_turf(owner)
		var/list/thrown_items = list()
		for(var/atom/movable/A in range(T, 7))
			if(A == owner || A.anchored || thrown_items[A])
				continue
			var/throwtarget = get_edge_target_turf(T, get_dir(T, get_step_away(A, T)))
			A.safe_throw_at(throwtarget, 10, 1, force = repulse_force)
			thrown_items[A] = A

		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1

/obj/item/clothing/suit/armor/reactive/table
	name = "reactive table armor"
	desc = "If you can't beat the memes, embrace them."
	var/tele_range = 10

/obj/item/clothing/suit/armor/reactive/table/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!active)
		return 0
	if(prob(hit_reaction_chance))
		var/mob/living/carbon/human/H = owner
		if(world.time < reactivearmor_cooldown)
			owner.visible_message("<span class='danger'>The reactive table armor's fabricators are still on cooldown!</span>")
			return
		owner.visible_message("<span class='danger'>The reactive teleport system flings [H] clear of [attack_text] and slams [H.p_them()] into a fabricated table!</span>")
		owner.visible_message("<font color='red' size='3'>[H] GOES ON THE TABLE!!!</font>")
		owner.Paralyze(40)
		var/list/turfs = new/list()
		for(var/turf/T in orange(tele_range, H))
			if(T.density)
				continue
			if(T.x>world.maxx-tele_range || T.x<tele_range)
				continue
			if(T.y>world.maxy-tele_range || T.y<tele_range)
				continue
			turfs += T
		if(!turfs.len)
			turfs += pick(/turf in orange(tele_range, H))
		var/turf/picked = pick(turfs)
		if(!isturf(picked))
			return
		H.forceMove(picked)
		new /obj/structure/table(get_turf(owner))
		reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/table/emp_act()
	return

//personal energy shields
/obj/item/clothing/suit/armor/reactive/shielded
	name = "experimental shielded vest"
	desc = "Advanced vest housing hardlight shield projector. It's pretty heavy."
	icon_state = "shieldvest"
	w_class = WEIGHT_CLASS_NORMAL
	body_parts_covered = CHEST | GROIN
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	slowdown = 0.1

//Shield vars
	//How much damage shield can take
	var/capacity = 0
	var/max_capacity = 120

	var/isrecharging = FALSE

	//How quickly shield will recharge capacity
	var/recharge_rate = 10
	//How long after we've been shot before we can start recharging.
	var/recharge_delay = 100
	//Time since we've last been shot
	var/recharge_cooldown = 0
	//Shield visual states
	var/shield_state = "nothing"
	var/shield_on = "shieldblue"
	var/shield_damaged = "shieldblue-damaged"
	var/shield_critical = "shieldblue-critical"
	var/shield_down = "shield-recharging"

/////////////////////////////////////////////////////////////////
////SHIELD CODE//////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/obj/item/clothing/suit/armor/reactive/shielded/attack_self(mob/owner)
	active = !(active)
	if(active)
		to_chat(owner, "<span class='notice'>[src] is now active.</span>")
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(item_state)]-on"
		recharge_cooldown = world.time + recharge_delay
		w_class = WEIGHT_CLASS_BULKY
		START_PROCESSING(SSobj, src)
		update_icon()
		update_inventory(owner)
	else
		to_chat(owner, "<span class='notice'>[src] is now inactive.</span>")
		icon_state = "[initial(icon_state)]-off"
		item_state = "[initial(item_state)]-off"
		capacity = 0
		w_class = WEIGHT_CLASS_NORMAL
		STOP_PROCESSING(SSobj, src)
		update_icon()
		update_inventory(owner)
	add_fingerprint(owner)
	return

//EMP hit - shield is gone
/obj/item/clothing/suit/armor/reactive/shielded/emp_act(severity)
	update_icon()
	recharge_cooldown = world.time + recharge_delay
	capacity = 0
	active = !(active)
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/owner = loc
	do_sparks(3, FALSE, src)
	T.visible_message("[owner]'s energy shield falters!")
	playsound(loc, 'sound/effects/shieldbeep.ogg', 75, 0)
	START_PROCESSING(SSobj, src)
	update_inventory(owner)

//handles being hit, for some reason code wants to deal bonus 3 points of damage to the shield regardless of what hits it, I give up on trying to fix it and accept it as a feature
/obj/item/clothing/suit/armor/reactive/shielded/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance = 0, damage, attack_type)
	//you've been hit by, you've been struck by, wait
	recharge_cooldown = world.time + recharge_delay
	if(capacity)
		playsound(loc, 'sound/effects/shieldhit.ogg', 100, 1)
		var/attackforce = 0

		//projectile attacks
		if(isprojectile(hitby))
			var/obj/item/projectile/P = hitby

			//disablers don't damage shields
			if(P.damage_type == STAMINA)
				attackforce = 0

			//kinetic attacks are pretty effective at defeating shields
			if(P.damage_type == BRUTE)
				attackforce = (P.damage * 1.25)

			//most energy weapons deal burn damage
			if(P.damage_type == BURN)
				attackforce = (P.damage)

			//piercing rounds will obliterate the shield and the overload will ignite the owner
			if(P.movement_type & UNSTOPPABLE)
				owner.visible_message("<span class='danger'>[P] shatters the [owner]'s shield!</span>")
				capacity = 0
				attackforce = (P.damage)
				owner.fire_stacks += 1
				owner.IgniteMob()
			capacity -= attackforce

		//melee and yeet attacks
		if(isitem(hitby))
			var/obj/item/I = hitby
			attackforce = (damage * I.attack_weight)

			//non-brute melee attacks aren't gonna be effective
			if(!I.damtype == BRUTE)
				attackforce = (damage * 0.5)

			//pure stamina damage will be completely blocked
			if(I.damtype == STAMINA)
				attackforce = 0
			capacity -= attackforce

		//simplemob/unarmed attacks
		else if(isliving(hitby))
			attackforce = damage
			capacity -= attackforce

		update_icon()
		do_sparks(3, FALSE, src)

		//uh-oh, shield machine broke
		if(capacity <= attackforce)
			var/turf/T = get_turf(owner)
			T.visible_message("[owner]'s shield overloads!")
			playsound(loc, 'sound/effects/shieldbeep.ogg', 75, 0)
			var/overcap = (attackforce - capacity)
			//deal leftover damage to the owner and it's dealt as burn definitely as a conscious design decision and not laziness
			owner.take_overall_damage(0, overcap)
			to_chat(owner, "<span class='danger'>Your shield overloads in a shower of sparks, burning you!</span>")
			capacity = 0
			update_icon()
			START_PROCESSING(SSobj, src)
			update_inventory(owner)
			return 1	//since we've already dealt damage let's not add it for the second time
		else
			owner.visible_message("<span class='danger'>[owner]'s shields deflect [attack_text] in a shower of sparks!</span>")
			var/capacitypercent = round((capacity/max_capacity) * 100, 1) //let's warn the user that his shield isn't doing too well
			if(capacitypercent < 30)
				to_chat(owner, "<span class='danger'>[src] display shows a warning: <B>'SHIELD CRITICAL: [capacitypercent]%'</B>!</span>")

		//start recharging shield
		if(recharge_rate && capacity < max_capacity)
			START_PROCESSING(SSobj, src)
		update_inventory(owner)
		return 1	//work done, damage blocked
	else
		return 0

//handles shield recharging
/obj/item/clothing/suit/armor/reactive/shielded/process()
	//check if cooldown is gone, if so, start recharging
	if(world.time > recharge_cooldown)
		isrecharging = TRUE

		//if shield just started recharging boost it up a little bit
		if(capacity == 0)
			playsound(loc, 'sound/effects/shieldraised.ogg', 75, 0)
			capacity += 20
		//if not, recharge as usual
		else
			capacity = CLAMP((capacity + recharge_rate), 0, max_capacity)

		update_icon()
		//stop recharging when full
		if(capacity == max_capacity)
			isrecharging = FALSE
			update_icon()
			playsound(loc, 'sound/effects/shieldbeep2.ogg', 100, 0)
			src.audible_message("<span class='notify'>[src] makes a loud beep.</span>")
			STOP_PROCESSING(SSobj, src)
		//do we need to update inventory states?
		if(ishuman(loc))
			var/mob/living/carbon/human/owner = loc
			update_inventory(owner)
	else
		isrecharging = FALSE

/obj/item/clothing/suit/armor/reactive/shielded/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

//in actuality, icon are being handled in many places, this one mostly sets shield states, then worn_overlays does its thing, possibly can be done better
/obj/item/clothing/suit/armor/reactive/shielded/update_icon()
	if(!active)
		icon_state = "[initial(icon_state)]-off"
		item_state = "[initial(item_state)]-off"
		shield_state = "nothing"
		return
	if(capacity == 0)
		shield_state = "[shield_down]"
		return
	else
		var/capacitypercent = round((capacity/max_capacity) * 100, 1)
		switch(capacitypercent)
			if(80 to 100)
				shield_state = "[shield_on]"
			if(30 to 80)
				shield_state = "[shield_damaged]"
			if(0 to 30)
				shield_state = "[shield_critical]"

/obj/item/clothing/suit/armor/reactive/shielded/proc/update_inventory(mob/owner)
	if(slot_flags == ITEM_SLOT_OCLOTHING)
		owner.update_inv_wear_suit()
	else if(slot_flags == ITEM_SLOT_BELT)
		owner.update_inv_belt()
	else
		return

//actually update the icons
/obj/item/clothing/suit/armor/reactive/shielded/worn_overlays(isinhands)
	. = list()
	if(!isinhands)
		. += mutable_appearance('icons/effects/effects.dmi', shield_state, MOB_LAYER + 0.01)
		if(isrecharging)
			. += mutable_appearance('icons/effects/effects.dmi', shield_down, MOB_LAYER + 0.02)

//display how much shield is left on examine
/obj/item/clothing/suit/armor/reactive/shielded/examine(mob/user)
	. = ..()
	var/capacitypercent = round((capacity/max_capacity) * 100, 1)
	. += "<span class='info'>Display shows that [src] is at [capacitypercent]% shield capacity.</span>"

/////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing/suit/armor/reactive/shielded/belt
	name = "shieldbelt"
	desc = "Hardlight shield projector miniaturised and installed on a belt. Less powerful than counterparts, but doesn't restrict movement."
	slot_flags = ITEM_SLOT_BELT
	body_parts_covered = GROIN
	armor = list("melee" = 20, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 30)
	slowdown = 0
	lefthand_file = 'icons/mob/inhands/equipment/belt_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/belt_righthand.dmi'
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "shieldbelt"
	item_state = "shieldbelt"
	max_capacity = 90
	recharge_rate = 10
	recharge_delay = 75
