/obj/item/nanite_injector
	name = "nanite injector (FOR TESTING)"
	desc = "Injects nanites into the user."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/device.dmi'
	icon_state = "nanite_remote"

/obj/item/nanite_injector/attack_self(mob/user)
	user.AddComponent(/datum/component/nanites, 150)

/obj/item/throwing_star/nanite
	name = "brittle kunai"
	desc = "A throwing weapon made of a slim blade and a short handle. It looks very brittle."
	icon_state = "throwingstar"
	item_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 8
	throwforce = 8 //8 + 2 (WEIGHT_CLASS_SMALL) * 4 (EMBEDDED_IMPACT_PAIN_MULTIPLIER) = 16 damage on hit due to guaranteed embedding
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 100, "embedded_fall_chance" = 5)
	materials = list()

/obj/item/throwing_star/nanite/Initialize()
	..()
	spawn(160)
		visible_message("<span class='warning'>[src] falls apart!</span>")
		qdel(src)