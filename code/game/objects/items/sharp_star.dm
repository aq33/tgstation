/obj/item/sharp_star.dm
	name = "Sharp star"
	desc = "A military-grade combat throwing knife with a signature white star logo on it. It has the words: 'on quaeritur de nomine tuo' inscribed on it."
	icon_state = "ostra_gwiazda.dmi"
	icon = 'icons/obj/ostra_gwiazda.dmi'
	item_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 15
	throwforce = 15
	throw_speed = 4
	embedding = list("embedded_pain_multiplier" = 10, "embed_chance" = 100, "embedded_fall_chance" = 20)
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP
	materials = list(/datum/material/iron=500, /datum/material/glass=500)
	resistance_flags = FIRE_PROOF
