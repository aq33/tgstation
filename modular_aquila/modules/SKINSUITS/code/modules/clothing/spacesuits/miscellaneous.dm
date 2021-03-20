/obj/item/clothing/head/helmet/space/skinsuit
	name = "skinsuit helmet"
	icon = 'icons/obj/clothing/hats.dmi'
	w_class = WEIGHT_CLASS_SMALL //Don't question it. We want it to fit back in the box
	alternate_worn_icon = 'icons/mob/head.dmi'
	icon_state = "skinsuit_helmet"
	item_state = "skinsuit_helmet"
	max_integrity = 200
	desc = "An airtight helmet meant to protect the wearer during emergency situations."
	permeability_coefficient = 0.01
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 20, "rad" = 0, "fire" = 0, "acid" = 0, "stamina" = 0)
	min_cold_protection_temperature = EMERGENCY_HELM_MIN_TEMP_PROTECT
	heat_protection = NONE
	flash_protect = 0
	bang_protect = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	clothing_flags = STOPSPRESSUREDAMAGE | SHOWEROKAY | SNUG_FIT
	max_heat_protection_temperature = 100

/obj/item/clothing/suit/space/skinsuit
	name = "skinsuit"
	desc = "A slim, compression-based spacesuit meant to protect the user during emergency situations. It's only a little warmer than your uniform."
	icon = 'modular_aquila/modules/SKINSUITS/icons/obj/clothing/suits.dmi'//
	alternate_worn_icon = 'icons/mob/suit.dmi'
	icon_state = "skinsuit_rolled"
	item_state = "s_suit"
	max_integrity = 200
	slowdown = 3 //Higher is slower
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = STOPSPRESSUREDAMAGE | SHOWEROKAY
	gas_transfer_coefficient = 0.5
	permeability_coefficient = 0.5
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0, "stamina" = 0)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals)
	min_cold_protection_temperature = EMERGENCY_SUIT_MIN_TEMP_PROTECT
	heat_protection = NONE
	max_heat_protection_temperature = 100
	var/rolled_up = TRUE
	var/torn = FALSE

/obj/item/clothing/suit/space/skinsuit/mob_can_equip(mob/M, mob/living/equipper, slot)
	if(rolled_up && slot == SLOT_WEAR_SUIT)
		if(equipper)
			to_chat(equipper, "<span class='warning'>You need to unroll \the [src], silly.</span>")
		else
			to_chat(M, "<span class='warning'>You need to unroll \the [src], silly.</span>")
		return FALSE
	return ..()

/obj/item/clothing/suit/space/skinsuit/examine(mob/user)
	. = ..()
	if(rolled_up)
		. += "<span class='notice'>It is currently rolled up.</span>"
	else
		. += "<span class='notice'>It can be rolled up to fit in a box.</span>"

/obj/item/clothing/suit/space/skinsuit/attack_self(mob/user)
	if(rolled_up)
		to_chat(user, "<span class='notice'>You unroll \the [src].</span>")
		icon_state = "skinsuit"
		update_icon()
		w_class = WEIGHT_CLASS_NORMAL
	else
		to_chat(user, "<span class='notice'>You roll up \the [src].</span>")
		icon_state = "skinsuit_rolled"
		update_icon()
		w_class = WEIGHT_CLASS_SMALL

	rolled_up = !rolled_up

/obj/item/clothing/suit/space/skinsuit/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!torn && prob(50))
		to_chat(owner, "<span class='warning'>[src] tears from the damage, breaking the air-tight seal!</span>")
		clothing_flags &= ~STOPSPRESSUREDAMAGE
		name = "torn [src]"
		desc = "A slim, compression-based spacesuit meant to protect the user during emergency situations, at least until someone tore a hole in the suit."
		torn = TRUE
		playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1)
		playsound(loc, 'sound/effects/refill.ogg', 50, 1)